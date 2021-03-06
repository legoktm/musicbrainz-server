package MusicBrainz::Server::Controller::WS::2::Event;
use Moose;
BEGIN { extends 'MusicBrainz::Server::ControllerBase::WS::2' }

use aliased 'MusicBrainz::Server::WebService::WebServiceStash';
use Readonly;
use MusicBrainz::Server::Validation qw( is_guid );

my $ws_defs = Data::OptList::mkopt([
     event => {
                         method   => 'GET',
                         required => [ qw(query) ],
                         optional => [ qw(fmt limit offset) ],
     },
     event => {
                         method   => 'GET',
                         inc      => [ qw(aliases annotation _relations
                                          tags user-tags ratings user-ratings) ],
                         optional => [ qw(fmt limit offset) ],
                         linked   => [ qw( area artist place ) ]
     },
     event => {
                         method   => 'GET',
                         inc      => [ qw(aliases annotation _relations
                                          tags user-tags ratings user-ratings) ],
                         optional => [ qw(fmt) ],
     },
]);

with 'MusicBrainz::Server::WebService::Validator' => {
     defs => $ws_defs,
};

with 'MusicBrainz::Server::Controller::Role::Load' => {
    model => 'Event'
};

sub base : Chained('root') PathPart('event') CaptureArgs(0) { }

sub event_toplevel {
    my ($self, $c, $stash, $event) = @_;

    my $opts = $stash->store($event);

    $self->linked_events($c, $stash, [$event]);

    $c->model('EventType')->load($event);

    $c->model('Event')->annotation->load_latest($event)
        if $c->stash->{inc}->annotation;

    if ($c->stash->{inc}->aliases) {
        my $aliases = $c->model('Event')->alias->find_by_entity_id($event->id);
        $opts->{aliases} = $aliases;
    }

    $self->load_relationships($c, $stash, $event);
}

sub event : Chained('load') PathPart('') {
    my ($self, $c) = @_;
    my $event = $c->stash->{entity};

    return unless defined $event;

    my $stash = WebServiceStash->new;
    my $opts = $stash->store($event);

    $self->event_toplevel($c, $stash, $event);

    $c->res->content_type($c->stash->{serializer}->mime_type . '; charset=utf-8');
    $c->res->body($c->stash->{serializer}->serialize('event', $event, $c->stash->{inc}, $stash));
}

sub event_browse : Private {
    my ($self, $c) = @_;

    my ($resource, $id) = @{ $c->stash->{linked} };
    my ($limit, $offset) = $self->_limit_and_offset($c);

    if (!is_guid($id)) {
        $c->stash->{error} = "Invalid mbid.";
        $c->detach('bad_req');
    }

    my $events;
    my $total;

    if ($resource eq 'area') {
        my $area = $c->model('Area')->get_by_gid($id);
        $c->detach('not_found') unless $area;

        my @tmp = $c->model('Area')->find_by_area($area->id, $limit, $offset);
        $events = $self->make_list(@tmp, $offset);
    }

    if ($resource eq 'artist') {
        my $artist = $c->model('Artist')->get_by_gid($id);
        $c->detach('not_found') unless $artist;

        my @tmp = $c->model('Event')->find_by_artist($artist->id, $limit, $offset);
        $events = $self->make_list(@tmp, $offset);
    }

    if ($resource eq 'place') {
        my $place = $c->model('Place')->get_by_gid($id);
        $c->detach('not_found') unless $place;

        my @tmp = $c->model('Event')->find_by_place($place->id, $limit, $offset);
        $events = $self->make_list(@tmp, $offset);
    }

    my $stash = WebServiceStash->new;

    for (@{ $events->{items} }) {
        $self->event_toplevel($c, $stash, $_);
    }

    $c->res->content_type($c->stash->{serializer}->mime_type . '; charset=utf-8');
    $c->res->body($c->stash->{serializer}->serialize('event-list', $events, $c->stash->{inc}, $stash));
}

sub event_search : Chained('root') PathPart('event') Args(0) {
    my ($self, $c) = @_;

    $c->detach('event_browse') if ($c->stash->{linked});
    $self->_search($c, 'event');
}

__PACKAGE__->meta->make_immutable;
1;

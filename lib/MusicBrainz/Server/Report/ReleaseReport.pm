package MusicBrainz::Server::Report::ReleaseReport;
use Moose::Role;

with 'MusicBrainz::Server::Report::QueryReport';

around inflate_rows => sub {
    my $orig = shift;
    my $self = shift;

    my $items = $self->$orig(@_);

    my $releases = $self->c->model('Release')->get_by_ids(
        map { $_->{release_id} } @$items
    );

    $self->c->model('ArtistCredit')->load(values %$releases);

    return [
        map +{
            %$_,
            release => $releases->{ $_->{release_id} }
        },
            @$items
    ];
};

1;

=head1 COPYRIGHT

Copyright (C) 2009 Lukas Lalinsky
Copyright (C) 2012 MetaBrainz Foundation

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=cut

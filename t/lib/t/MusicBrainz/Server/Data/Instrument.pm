package t::MusicBrainz::Server::Data::Instrument;
use Test::Routine;
use Test::Moose;
use Test::More;
use Test::Fatal;
use Test::Deep qw( cmp_set );

use MusicBrainz::Server::Data::Instrument;

use MusicBrainz::Server::Context;
use MusicBrainz::Server::Data::Search;
use MusicBrainz::Server::Test;
use Sql;

with 't::Edit';
with 't::Context';

test 'Load basic data' => sub {
    my $test = shift;
    
    MusicBrainz::Server::Test->prepare_test_database($test->c, '+data_instrument');
    
    my $instrument_data = $test->c->model('Instrument');
    does_ok($instrument_data, 'MusicBrainz::Server::Data::Role::Editable');
    
    # ----
    # Test fetching instruments:
    
    # An instrument with all attributes populated
    my $instrument = $instrument_data->get_by_id(3);
    is ( $instrument->id, 3, 'loaded full instrument correctly from DB');
    is ( $instrument->gid, "745c079d-374e-4436-9448-da92dedef3ce", 'loaded full instrument correctly from DB' );
    is ( $instrument->name, "Test Instrument", 'loaded full instrument correctly from DB' );
    is ( $instrument->type_id, 2, 'loaded full instrument correctly from DB' );
    is ( $instrument->edits_pending, 0, 'loaded full instrument correctly from DB' );
    is ( $instrument->comment, 'Yet Another Test Instrument', 'loaded full instrument correctly from DB' );
    is ( $instrument->description, 'This is a description!', 'loaded full instrument correctly from DB' );
    
    # An instrument with the minimal set of required attributes
    $instrument = $instrument_data->get_by_id(4);
    is ( $instrument->id, 4, 'loaded minimal instrument correctly from DB' );
    is ( $instrument->gid, "945c079d-374e-4436-9448-da92dedef3cf", 'loaded minimal instrument correctly from DB' );
    is ( $instrument->name, "Minimal Instrument", 'loaded minimal instrument correctly from DB' );
    is ( $instrument->type_id, undef, 'loaded minimal instrument correctly from DB' );
    is ( $instrument->edits_pending, 0, 'loaded minimal instrument correctly from DB' );
    is ( $instrument->comment, '', 'loaded minimal instrument correctly from DB' );
    is ( $instrument->description, '', 'loaded minimal instrument correctly from DB' );
};

test 'Create, update, delete instruments' => sub {
    my $test = shift;
    
    MusicBrainz::Server::Test->prepare_test_database($test->c, '+data_instrument');
    
    my $instrument_data = $test->c->model('Instrument');

    my $instrument = $instrument_data->insert({
            name => 'New Instrument',
            comment => 'Instrument comment',
            type_id => 1,
        });
    isa_ok($instrument, 'MusicBrainz::Server::Entity::Instrument');
    ok($instrument->id > 4);
    
    $instrument = $instrument_data->get_by_id($instrument->id);
    is($instrument->name, 'New Instrument', 'newly-created instrument is correct');
    is($instrument->type_id, 1, 'newly-created instrument is correct');
    is($instrument->comment, 'Instrument comment', 'newly-created instrument is correct');
    is($instrument->description, '', 'newly-created instrument is correct');
    ok(defined $instrument->gid, 'newly-created instrument has an MBID');
    ok($test->c->sql->select_single_value('SELECT true from link_attribute_type where gid = ?', $instrument->gid),
       'link_attribute_type row was inserted too');
    
    # ---
    # Updating instruments
    $instrument_data->update($instrument->id, {
            name => 'Updated Instrument',
            type_id => undef,
            comment => 'Updated comment',
            description => 'Newly-created description'
        });
    
    
    $instrument = $instrument_data->get_by_id($instrument->id);
    is($instrument->name, 'Updated Instrument', 'updated instrument data is correct');
    is($instrument->type_id, undef, 'updated instrument data is correct');
    is($instrument->comment, 'Updated comment', 'updated instrument data is correct');
    is($instrument->description, 'Newly-created description', 'updated instrument data is correct');
    is($test->c->sql->select_single_value('SELECT description from link_attribute_type where gid = ?', $instrument->gid),
       'Newly-created description',
       'link_attribute_type row was updated');

    my $gid = $instrument->gid;
    $instrument_data->delete($instrument->id);
    $instrument = $instrument_data->get_by_id($instrument->id);
    ok(!defined $instrument, 'instrument was deleted');
    ok(!defined $test->c->sql->select_single_value('SELECT true from link_attribute_type where gid = ?', $gid),
       'link_attribute_type row was deleted too');
};
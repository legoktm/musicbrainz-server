-- Generated by CompileSchemaScripts.pl from:
-- 20160507-mbs-8669.sql
\set ON_ERROR_STOP 1
BEGIN;
--------------------------------------------------------------------------------
SELECT '20160507-mbs-8669.sql';


SET search_path = musicbrainz, documentation;

ALTER TABLE place DROP CONSTRAINT IF EXISTS place_pkey;
ALTER TABLE place_gid_redirect DROP CONSTRAINT IF EXISTS place_gid_redirect_pkey;
ALTER TABLE place_type DROP CONSTRAINT IF EXISTS place_type_pkey;
ALTER TABLE edit_place DROP CONSTRAINT IF EXISTS edit_place_pkey;
ALTER TABLE place_alias DROP CONSTRAINT IF EXISTS place_alias_pkey;
ALTER TABLE place_alias_type DROP CONSTRAINT IF EXISTS place_alias_type_pkey;
ALTER TABLE place_annotation DROP CONSTRAINT IF EXISTS place_annotation_pkey;
ALTER TABLE l_area_place DROP CONSTRAINT IF EXISTS l_area_place_pkey;
ALTER TABLE l_artist_place DROP CONSTRAINT IF EXISTS l_artist_place_pkey;
ALTER TABLE l_label_place DROP CONSTRAINT IF EXISTS l_label_place_pkey;
ALTER TABLE l_place_place DROP CONSTRAINT IF EXISTS l_place_place_pkey;
ALTER TABLE l_place_recording DROP CONSTRAINT IF EXISTS l_place_recording_pkey;
ALTER TABLE l_place_release DROP CONSTRAINT IF EXISTS l_place_release_pkey;
ALTER TABLE l_place_release_group DROP CONSTRAINT IF EXISTS l_place_release_group_pkey;
ALTER TABLE l_place_url DROP CONSTRAINT IF EXISTS l_place_url_pkey;
ALTER TABLE l_place_work DROP CONSTRAINT IF EXISTS l_place_work_pkey;
ALTER TABLE place_tag DROP CONSTRAINT IF EXISTS place_tag_pkey;
ALTER TABLE place_tag_raw DROP CONSTRAINT IF EXISTS place_tag_raw_pkey;
ALTER TABLE l_area_place_example DROP CONSTRAINT IF EXISTS l_area_place_example_pkey;
ALTER TABLE l_artist_place_example DROP CONSTRAINT IF EXISTS l_artist_place_example_pkey;
ALTER TABLE l_label_place_example DROP CONSTRAINT IF EXISTS l_label_place_example_pkey;
ALTER TABLE l_place_place_example DROP CONSTRAINT IF EXISTS l_place_place_example_pkey;
ALTER TABLE l_place_recording_example DROP CONSTRAINT IF EXISTS l_place_recording_example_pkey;
ALTER TABLE l_place_release_example DROP CONSTRAINT IF EXISTS l_place_release_example_pkey;
ALTER TABLE l_place_release_group_example DROP CONSTRAINT IF EXISTS l_place_release_group_example_pkey;
ALTER TABLE l_place_url_example DROP CONSTRAINT IF EXISTS l_place_url_example_pkey;
ALTER TABLE l_place_work_example DROP CONSTRAINT IF EXISTS l_place_work_example_pkey;

ALTER TABLE place ADD CONSTRAINT place_pkey PRIMARY KEY (id);
ALTER TABLE place_gid_redirect ADD CONSTRAINT place_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE place_type ADD CONSTRAINT place_type_pkey PRIMARY KEY (id);
ALTER TABLE edit_place ADD CONSTRAINT edit_place_pkey PRIMARY KEY (edit, place);
ALTER TABLE place_alias ADD CONSTRAINT place_alias_pkey PRIMARY KEY (id);
ALTER TABLE place_alias_type ADD CONSTRAINT place_alias_type_pkey PRIMARY KEY (id);
ALTER TABLE place_annotation ADD CONSTRAINT place_annotation_pkey PRIMARY KEY (place, annotation);
ALTER TABLE l_area_place ADD CONSTRAINT l_area_place_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_place ADD CONSTRAINT l_artist_place_pkey PRIMARY KEY (id);
ALTER TABLE l_label_place ADD CONSTRAINT l_label_place_pkey PRIMARY KEY (id);
ALTER TABLE l_place_place ADD CONSTRAINT l_place_place_pkey PRIMARY KEY (id);
ALTER TABLE l_place_recording ADD CONSTRAINT l_place_recording_pkey PRIMARY KEY (id);
ALTER TABLE l_place_release ADD CONSTRAINT l_place_release_pkey PRIMARY KEY (id);
ALTER TABLE l_place_release_group ADD CONSTRAINT l_place_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_place_url ADD CONSTRAINT l_place_url_pkey PRIMARY KEY (id);
ALTER TABLE l_place_work ADD CONSTRAINT l_place_work_pkey PRIMARY KEY (id);
ALTER TABLE place_tag ADD CONSTRAINT place_tag_pkey PRIMARY KEY (place, tag);
ALTER TABLE place_tag_raw ADD CONSTRAINT place_tag_raw_pkey PRIMARY KEY (place, editor, tag);
ALTER TABLE l_area_place_example ADD CONSTRAINT l_area_place_example_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_place_example ADD CONSTRAINT l_artist_place_example_pkey PRIMARY KEY (id);
ALTER TABLE l_label_place_example ADD CONSTRAINT l_label_place_example_pkey PRIMARY KEY (id);
ALTER TABLE l_place_place_example ADD CONSTRAINT l_place_place_example_pkey PRIMARY KEY (id);
ALTER TABLE l_place_recording_example ADD CONSTRAINT l_place_recording_example_pkey PRIMARY KEY (id);
ALTER TABLE l_place_release_example ADD CONSTRAINT l_place_release_example_pkey PRIMARY KEY (id);
ALTER TABLE l_place_release_group_example ADD CONSTRAINT l_place_release_group_example_pkey PRIMARY KEY (id);
ALTER TABLE l_place_url_example ADD CONSTRAINT l_place_url_example_pkey PRIMARY KEY (id);
ALTER TABLE l_place_work_example ADD CONSTRAINT l_place_work_example_pkey PRIMARY KEY (id);

COMMIT;

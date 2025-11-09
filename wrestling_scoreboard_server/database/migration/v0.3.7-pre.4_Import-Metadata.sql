create table public.api_metadata
(
    entity_id   integer not null,
    entity_type VARCHAR not null,
    last_import timestamptz,
    constraint api_metadata_pk primary key (entity_id, entity_type)
);

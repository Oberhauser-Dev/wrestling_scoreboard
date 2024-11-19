alter table public.migration
    add min_client_version varchar(127) default '0.0.0'::character varying not null;

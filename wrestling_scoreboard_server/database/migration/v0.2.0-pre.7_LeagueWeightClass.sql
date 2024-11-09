create table league_weight_class
(
    id               serial
        constraint league_weight_class_pk
            primary key,
    league_id      integer           not null
        constraint league_weight_class_league_id_fk
            references league
            on delete cascade,
    weight_class_id  integer           not null
        constraint league_weight_class_weight_class_id_fk
            references weight_class
            on delete cascade,
    pos              integer default 0 not null,
    season_partition integer,
    org_sync_id      varchar(127),
    organization_id  integer
        constraint league_weight_class_organization_id_fk
            references organization
);

alter table league_weight_class
    owner to wrestling;

create unique index league_weight_class_id_uindex
    on league_weight_class (id);


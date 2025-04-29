create type round_type as enum ('qualification', 'elimination', 'repechage', 'semiFinals', 'finals');
alter type round_type owner to wrestling;

create type competition_system as enum ('singleElimination', 'doubleElimination', 'nordic', 'twoPools');
alter type competition_system owner to wrestling;


alter table public.competition
    add mat_count smallint default 0 not null;

alter table public.competition
    add max_ranking smallint default 10 not null;

alter table public.competition_bout
    add pos integer default 0 not null;

alter table public.competition_bout
    add mat smallint;

alter table public.competition_bout
    add round smallint;

alter table public.competition_bout
    add weight_category_id integer
        constraint competition_bout_competition_weight_category_id_fk
            references public.competition_weight_category;

alter table public.competition_bout
    add round_type round_type default 'qualification' not null;


create table public.age_category
(
    id              serial
        constraint age_category_pk
            primary key,
    org_sync_id     varchar(127),
    organization_id integer
        constraint age_category_organization_id_fk
            references public.organization
            on delete cascade,
    name            varchar(127) not null,
    min_age         smallint,
    max_age         smallint
);

alter table public.age_category owner to wrestling;


create table public.competition_lineup
(
    id              serial
        constraint competition_lineup_pk
            primary key,
    competition_id integer not null
        constraint competition_lineup_competition_id_fk
            references public.competition
            on delete cascade,
    club_id integer not null
        constraint competition_lineup_club_id_fk
            references public.club
            on delete cascade,
    leader_id integer
        constraint competition_lineup_membership_id_fk
            references public.membership,
    coach_id integer
        constraint competition_lineup_membership_id_fk_2
            references public.membership
);

alter table public.competition_lineup owner to wrestling;


create table public.competition_weight_category
(
    id              serial  not null
        constraint competition_weight_category_pk
            primary key,
    org_sync_id     varchar(127),
    organization_id integer
        constraint competition_weight_category_organization_id_fk
            references public.organization,
    weight_class_id integer not null
        constraint competition_weight_category_weight_class_id_fk
            references public.weight_class
            on delete cascade,
    age_category_id integer not null
        constraint competition_weight_category_age_category_id_fk
            references public.age_category
            on delete cascade,
    competition_id  integer not null
        constraint competition_weight_category_competition_id_fk
            references public.competition
            on delete cascade
);

alter table public.competition_weight_category owner to wrestling;


create table public.competition_participation
(
    id              serial
        constraint competition_participation_pk
            primary key,
    competition_lineup_id integer not null
        constraint competition_participation_competition_lineup_id_fk
            references public.competition_lineup
            on delete cascade,
    membership_id integer not null
        constraint competition_participation_membership_id_fk
            references public.membership
            on delete cascade,
    weight_category_id integer
        constraint competition_participation_weight_category_id_fk
            references public.competition_weight_category,
    weight numeric(5,2)
);

alter table public.competition_participation owner to wrestling;

alter table public.competition_participation
    add pool_group smallint;

alter table public.competition_participation
    add pool_draw_number smallint;

alter table public.competition_participation
    add eliminated boolean default false not null;

alter table public.competition_participation
    add disqualified boolean default false not null;


create table public.competition_system_affiliation
(
    id                 serial             not null
        constraint competition_system_affiliation_pk
            primary key,
    competition_id     integer            not null
        constraint competition_system_affiliation_competition_id_fk
            references public.competition,
    competition_system competition_system not null,
    max_contestants    integer
);

alter table public.competition_system_affiliation owner to wrestling;

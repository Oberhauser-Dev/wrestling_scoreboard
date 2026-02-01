alter table public.competition_weight_category
    drop column competition_system;

alter table public.competition_weight_category
    drop column pool_group_count;

alter table public.competition_weight_category
    drop column paired_round;

alter table public.competition_weight_category
    add competition_system_affiliation_id integer;

alter table public.competition_weight_category
    add constraint competition_weight_category_cs_affiliation_id_fk
        foreign key (competition_system_affiliation_id) references public.competition_system_affiliation;

alter table public.competition_weight_category
    add paired_round_by_phase smallint[] default array []::smallint[] not null;

alter table public.competition_participation
    drop column pool_group;

alter table public.competition_participation
    drop column pool_draw_number;

alter table public.competition_participation
    add pool_groups smallint[] default array []::smallint[] not null;

alter table public.competition_participation
    add pool_draw_numbers smallint[] default array []::smallint[] not null;

create table public.competition_system_phase
(
    id                 serial
        constraint competition_system_phase_pk
            primary key,
    competition_system_affiliation_id     integer            not null
        constraint competition_system_phase_affiliation_id_fk
            references public.competition_system_affiliation,
    competition_system competition_system not null,
    pool_group_count   smallint default 1 not null,
    cross_over         boolean default false not null,
    max_rank           integer default 3 not null,
    pos                integer DEFAULT 0 not null
);
alter table public.competition_system_phase
    owner to wrestling;

alter table public.competition_system_affiliation
    drop column competition_system;

alter table public.competition_system_affiliation
    drop column pool_group_count;


alter table public.competition_bout
    add phase_pos integer default 0 not null;

ALTER TYPE public.competition_system ADD VALUE 'bestOfThree';

ALTER TYPE public.competition_system ADD VALUE 'finals';

alter table public.competition_weight_category
    add pool_group_count smallint default 1 not null;

alter table public.competition_system_affiliation
    add pool_group_count smallint default 1 not null;

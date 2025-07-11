alter table public.competition_weight_category
    add pos integer DEFAULT 0 not null;

alter table public.competition_weight_category
    add skipped_cycles smallint[] not null default array []::smallint[];

create table public.competition_age_category
(
    id                 serial
        constraint competition_age_category_pk
            primary key,
    age_category_id    integer            not null
        constraint competition_age_category_age_category_id_fk
            references public.age_category
            on delete cascade,
    competition_id     integer            not null
        constraint competition_age_category_competition_id_fk
            references public.competition
            on delete cascade,
    pos integer DEFAULT 0 NOT NULL,
    skipped_cycles smallint[] NOT NULL DEFAULT array []::smallint[]
);

alter table public.competition_age_category
    owner to wrestling;


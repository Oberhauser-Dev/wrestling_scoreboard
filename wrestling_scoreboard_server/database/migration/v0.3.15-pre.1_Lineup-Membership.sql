create type public.lineup_role as enum ('leader', 'coach', 'substitute');

alter type public.lineup_role owner to wrestling;

create table public.team_lineup_membership
(
    id            serial
        constraint team_lineup_membership_pk
            primary key,
    lineup_id     integer            not null
        constraint team_lineup_membership_team_lineup_id_fk
            references public.team_lineup
            on delete cascade,
    membership_id integer            not null
        constraint team_lineup_membership_membership_id_fk
            references public.membership
            on delete cascade,
    lineup_role   public.lineup_role not null,
    constraint team_lineup_membership_uk
        unique (lineup_id, membership_id, lineup_role)
);

alter table public.team_lineup_membership owner to wrestling;

create table public.competition_lineup_membership
(
    id                    serial
        constraint competition_lineup_membership_pk
            primary key,
    competition_lineup_id integer            not null
        constraint competition_lineup_membership_competition_lineup_id_fk
            references public.competition_lineup
            on delete cascade,
    membership_id         integer            not null
        constraint competition_lineup_membership_membership_id_fk
            references public.membership
            on delete cascade,
    lineup_role           public.lineup_role not null,
    constraint competition_lineup_membership_uk
        unique (competition_lineup_id, membership_id, lineup_role)
);

alter table public.competition_lineup_membership owner to wrestling;

-- team lineup: leader
insert into public.team_lineup_membership (lineup_id, membership_id, lineup_role)
select tl.id, tl.leader_id, 'leader'::public.lineup_role
from public.team_lineup tl
where tl.leader_id is not null
order by tl.id
on conflict do nothing;

-- team lineup: coach
insert into public.team_lineup_membership (lineup_id, membership_id, lineup_role)
select tl.id, tl.coach_id, 'coach'::public.lineup_role
from public.team_lineup tl
where tl.coach_id is not null
order by tl.id
on conflict do nothing;

-- competition lineup: leader
insert into public.competition_lineup_membership (competition_lineup_id, membership_id, lineup_role)
select cl.id, cl.leader_id, 'leader'::public.lineup_role
from public.competition_lineup cl
where cl.leader_id is not null
order by cl.id
on conflict do nothing;

-- competition lineup: coach
insert into public.competition_lineup_membership (competition_lineup_id, membership_id, lineup_role)
select cl.id, cl.coach_id, 'coach'::public.lineup_role
from public.competition_lineup cl
where cl.coach_id is not null
order by cl.id
on conflict do nothing;

-- drop leader and coach columns (and their foreign key constraints)
alter table public.team_lineup drop constraint if exists team_lineup_membership_id_fk;
alter table public.team_lineup drop constraint if exists team_lineup_membership_id_fk_2;
alter table public.team_lineup drop column if exists leader_id;
alter table public.team_lineup drop column if exists coach_id;

alter table public.competition_lineup drop constraint if exists competition_lineup_membership_id_fk;
alter table public.competition_lineup drop constraint if exists competition_lineup_membership_id_fk_2;
alter table public.competition_lineup drop column if exists leader_id;
alter table public.competition_lineup drop column if exists coach_id;

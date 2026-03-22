alter table public.competition_system_phase
    alter column max_rank drop not null;

alter table public.competition_system_phase
    alter column max_rank drop default;

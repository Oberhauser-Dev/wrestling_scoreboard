alter table public.bout
    add is_running boolean default false not null;

alter table public.athlete_bout_state
    add activity_time_millis integer;

alter table public.athlete_bout_state
    add injury_time_millis integer;

alter table public.athlete_bout_state
    add is_injury_time_running boolean default false not null;

alter table public.athlete_bout_state
    add bleeding_injury_time_millis integer;

alter table public.athlete_bout_state
    add is_bleeding_injury_time_running boolean default false not null;


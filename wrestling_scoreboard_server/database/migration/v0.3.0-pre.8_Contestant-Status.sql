CREATE TYPE public.contestant_status AS ENUM (
    'eliminated',
    'disqualified',
    'injured'
);
ALTER TYPE public.contestant_status OWNER TO wrestling;

alter table public.competition_participation
    add contestant_status contestant_status;

alter table public.competition_participation
    drop column eliminated;

alter table public.competition_participation
    drop column disqualified;

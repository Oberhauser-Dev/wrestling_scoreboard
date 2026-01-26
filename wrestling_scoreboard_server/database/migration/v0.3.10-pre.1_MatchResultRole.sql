CREATE TYPE public.match_result_role AS ENUM (
    'home',
    'guest',
    'tie'
);
ALTER TYPE public.match_result_role OWNER TO wrestling;

alter table public.team_match
    add result_role match_result_role;

alter table public.team_lineup
    add classification_points integer;

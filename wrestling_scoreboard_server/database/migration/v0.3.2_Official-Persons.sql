ALTER TYPE public.person_role ADD VALUE 'matChairman';
ALTER TYPE public.person_role ADD VALUE 'judge';

create table public.team_match_person
(
    id            serial
        constraint team_match_person_pk
            primary key,
    team_match_id integer not null
        constraint team_match_person_team_match_id_fk
            references public.team_match
            on delete cascade,
    person_id     integer not null
        constraint team_match_person_person_id_fk
            references public.person,
    person_role   person_role
);

alter table public.team_match_person owner to wrestling;

-- referee
INSERT INTO public.team_match_person (team_match_id, person_id, person_role)
SELECT tm.id, tm.referee_id, 'referee'::person_role
FROM public.team_match tm
WHERE tm.referee_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.team_match_person tmp
    WHERE tmp.team_match_id = tm.id
      AND tmp.person_id = tm.referee_id
      AND tmp.person_role = 'referee'::person_role
  );

-- transcriptWriter
INSERT INTO public.team_match_person (team_match_id, person_id, person_role)
SELECT tm.id, tm.transcript_writer_id, 'transcriptWriter'::person_role
FROM public.team_match tm
WHERE tm.transcript_writer_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.team_match_person tmp
    WHERE tmp.team_match_id = tm.id
      AND tmp.person_id = tm.transcript_writer_id
      AND tmp.person_role = 'transcriptWriter'::person_role
  );

-- timeKeeper
INSERT INTO public.team_match_person (team_match_id, person_id, person_role)
SELECT tm.id, tm.time_keeper_id, 'timeKeeper'::person_role
FROM public.team_match tm
WHERE tm.time_keeper_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.team_match_person tmp
    WHERE tmp.team_match_id = tm.id
      AND tmp.person_id = tm.time_keeper_id
      AND tmp.person_role = 'timeKeeper'::person_role
  );

-- matChairman
INSERT INTO public.team_match_person (team_match_id, person_id, person_role)
SELECT tm.id, tm.mat_chairman_id, 'matChairman'::person_role
FROM public.team_match tm
WHERE tm.mat_chairman_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.team_match_person tmp
    WHERE tmp.team_match_id = tm.id
      AND tmp.person_id = tm.mat_chairman_id
      AND tmp.person_role = 'matChairman'::person_role
  );

-- steward
INSERT INTO public.team_match_person (team_match_id, person_id, person_role)
SELECT tm.id, tm.judge_id, 'judge'::person_role
FROM public.team_match tm
WHERE tm.judge_id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM public.team_match_person tmp
    WHERE tmp.team_match_id = tm.id
      AND tmp.person_id = tm.judge_id
      AND tmp.person_role = 'judge'::person_role
  );

-- drop foreign key constraints on team_match person columns (IF they exist)
ALTER TABLE public.team_match DROP CONSTRAINT IF EXISTS team_match_person_id_fk;
ALTER TABLE public.team_match DROP CONSTRAINT IF EXISTS team_match_person_id_fk_2;
ALTER TABLE public.team_match DROP CONSTRAINT IF EXISTS team_match_person_id_fk_3;
ALTER TABLE public.team_match DROP CONSTRAINT IF EXISTS team_match_person_id_fk_4;
ALTER TABLE public.team_match DROP CONSTRAINT IF EXISTS team_match_person_id_fk_5;

-- drop the columns from team_match (IF present)
ALTER TABLE public.team_match DROP COLUMN IF EXISTS referee_id;
ALTER TABLE public.team_match DROP COLUMN IF EXISTS transcript_writer_id;
ALTER TABLE public.team_match DROP COLUMN IF EXISTS time_keeper_id;
ALTER TABLE public.team_match DROP COLUMN IF EXISTS mat_chairman_id;
ALTER TABLE public.team_match DROP COLUMN IF EXISTS judge_id;

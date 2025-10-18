SET TIMEZONE TO 'UTC';
ALTER TABLE public.wrestling_event
    ALTER COLUMN date TYPE timestamptz USING date AT TIME ZONE 'UTC';

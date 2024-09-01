create table migration
(
    semver varchar(127) default '0.0.0'::character varying not null
);
alter table migration owner to wrestling;
INSERT INTO public.migration (semver) VALUES ('0.0.0');

CREATE TYPE public.user_privilege AS ENUM (
    'none',
    'read',
    'write',
    'admin'
);
ALTER TYPE public.user_privilege OWNER TO wrestling;

alter table public.bout add organization_id integer;

alter table public.division_weight_class add organization_id integer;
alter table public.division_weight_class add org_sync_id varchar(127);

alter table public.league add bout_days integer DEFAULT 14 NOT NULL;

CREATE TABLE public.secured_user (
    id integer NOT NULL,
    username character varying(127) NOT NULL,
    password_hash bytea NOT NULL,
    email character varying(127),
    person_id integer,
    salt character varying(127) NOT NULL,
    created_at date NOT NULL,
    privilege public.user_privilege DEFAULT 'none'::public.user_privilege NOT NULL
);
ALTER TABLE public.secured_user OWNER TO wrestling;

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.user_id_seq OWNER TO wrestling;
ALTER SEQUENCE public.user_id_seq OWNED BY public.secured_user.id;
ALTER TABLE ONLY public.secured_user ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);

COPY public.secured_user (id, username, password_hash, email, person_id, salt, created_at, privilege) FROM stdin;
1	admin	\\xb2950268d52c1d17f1b35edd35c071be3d320b488c81425c6b144340963e524a		\N	924VOg==	2024-08-25	admin
\.

SELECT pg_catalog.setval('public.user_id_seq', 1, true);

ALTER TABLE ONLY public.secured_user ADD CONSTRAINT user_pk PRIMARY KEY (id);
ALTER TABLE ONLY public.secured_user ADD CONSTRAINT user_pk_2 UNIQUE (username);

ALTER TABLE ONLY public.bout ADD CONSTRAINT bout_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);
ALTER TABLE ONLY public.division_weight_class ADD CONSTRAINT division_weight_class_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);

ALTER TABLE ONLY public.secured_user ADD CONSTRAINT user_person_id_fk FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


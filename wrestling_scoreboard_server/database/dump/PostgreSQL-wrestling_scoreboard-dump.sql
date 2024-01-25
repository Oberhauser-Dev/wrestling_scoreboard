--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: bout_action_type; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.bout_action_type AS ENUM (
    'points',
    'passivity',
    'verbal',
    'caution',
    'dismissal'
);


ALTER TYPE public.bout_action_type OWNER TO wrestling;

--
-- Name: bout_result; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.bout_result AS ENUM (
    'vfa',
    'vin',
    'vca',
    'vsu',
    'vsu1',
    'vpo',
    'vpo1',
    'vfo',
    'dsq',
    'dsq2'
);


ALTER TYPE public.bout_result OWNER TO wrestling;

--
-- Name: bout_role; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.bout_role AS ENUM (
    'red',
    'blue'
);


ALTER TYPE public.bout_role OWNER TO wrestling;

--
-- Name: gender; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.gender AS ENUM (
    'male',
    'female',
    'other'
);


ALTER TYPE public.gender OWNER TO wrestling;

--
-- Name: person_role; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.person_role AS ENUM (
    'referee',
    'transcriptWriter',
    'timeKeeper',
    'matPresident',
    'steward'
);


ALTER TYPE public.person_role OWNER TO wrestling;

--
-- Name: weight_unit; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.weight_unit AS ENUM (
    'pound',
    'kilogram'
);


ALTER TYPE public.weight_unit OWNER TO wrestling;

--
-- Name: wrestling_style; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.wrestling_style AS ENUM (
    'free',
    'greco'
);


ALTER TYPE public.wrestling_style OWNER TO wrestling;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bout; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.bout (
    id integer NOT NULL,
    red_id integer,
    blue_id integer,
    weight_class_id integer,
    winner_role public.bout_role,
    bout_result public.bout_result,
    duration_millis integer
);


ALTER TABLE public.bout OWNER TO wrestling;

--
-- Name: bout_action; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.bout_action (
    id integer NOT NULL,
    duration_millis integer NOT NULL,
    point_count smallint,
    action_type public.bout_action_type NOT NULL,
    bout_role public.bout_role NOT NULL,
    bout_id integer NOT NULL
);


ALTER TABLE public.bout_action OWNER TO wrestling;

--
-- Name: bout_action_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.bout_action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bout_action_id_seq OWNER TO wrestling;

--
-- Name: bout_action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.bout_action_id_seq OWNED BY public.bout_action.id;


--
-- Name: bout_config; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.bout_config (
    id integer NOT NULL,
    period_duration_secs integer,
    break_duration_secs integer,
    activity_duration_secs integer,
    injury_duration_secs integer,
    period_count smallint
);


ALTER TABLE public.bout_config OWNER TO wrestling;

--
-- Name: bout_config_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.bout_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bout_config_id_seq OWNER TO wrestling;

--
-- Name: bout_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.bout_config_id_seq OWNED BY public.bout_config.id;


--
-- Name: bout_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.bout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bout_id_seq OWNER TO wrestling;

--
-- Name: bout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.bout_id_seq OWNED BY public.bout.id;


--
-- Name: club; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.club (
    id integer NOT NULL,
    no character varying(8),
    name character varying(255) NOT NULL
);


ALTER TABLE public.club OWNER TO wrestling;

--
-- Name: club_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.club_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.club_id_seq OWNER TO wrestling;

--
-- Name: club_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.club_id_seq OWNED BY public.club.id;


--
-- Name: wrestling_event; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.wrestling_event (
    id integer NOT NULL,
    date date,
    location character varying(100),
    visitors_count integer,
    comment text,
    no character varying(16)
);


ALTER TABLE public.wrestling_event OWNER TO wrestling;

--
-- Name: competition; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.competition (
    name character varying(127),
    bout_config_id integer NOT NULL
)
INHERITS (public.wrestling_event);


ALTER TABLE public.competition OWNER TO wrestling;

--
-- Name: competition_bout; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.competition_bout (
    id integer NOT NULL,
    competition_id integer NOT NULL,
    bout_id integer
);


ALTER TABLE public.competition_bout OWNER TO wrestling;

--
-- Name: competition_bout_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.competition_bout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.competition_bout_id_seq OWNER TO wrestling;

--
-- Name: competition_bout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.competition_bout_id_seq OWNED BY public.competition_bout.id;


--
-- Name: competition_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.competition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.competition_id_seq OWNER TO wrestling;

--
-- Name: competition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.competition_id_seq OWNED BY public.competition.id;


--
-- Name: competition_person; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.competition_person (
    id integer NOT NULL,
    competition_id integer NOT NULL,
    person_id integer NOT NULL,
    person_role public.person_role
);


ALTER TABLE public.competition_person OWNER TO wrestling;

--
-- Name: event_person_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.event_person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_person_id_seq OWNER TO wrestling;

--
-- Name: event_person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.event_person_id_seq OWNED BY public.competition_person.id;


--
-- Name: league; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.league (
    id integer NOT NULL,
    name character varying(127) NOT NULL,
    start_date date NOT NULL,
    bout_config_id integer NOT NULL
);


ALTER TABLE public.league OWNER TO wrestling;

--
-- Name: league_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.league_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.league_id_seq OWNER TO wrestling;

--
-- Name: league_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.league_id_seq OWNED BY public.league.id;


--
-- Name: league_team_participation; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.league_team_participation (
    id integer NOT NULL,
    league_id integer NOT NULL,
    team_id integer NOT NULL
);


ALTER TABLE public.league_team_participation OWNER TO wrestling;

--
-- Name: league_team_participation_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.league_team_participation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.league_team_participation_id_seq OWNER TO wrestling;

--
-- Name: league_team_participation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.league_team_participation_id_seq OWNED BY public.league_team_participation.id;


--
-- Name: league_weight_class; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.league_weight_class (
    id integer NOT NULL,
    league_id integer NOT NULL,
    weight_class_id integer NOT NULL,
    pos integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.league_weight_class OWNER TO wrestling;

--
-- Name: league_weight_class_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.league_weight_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.league_weight_class_id_seq OWNER TO wrestling;

--
-- Name: league_weight_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.league_weight_class_id_seq OWNED BY public.league_weight_class.id;


--
-- Name: lineup; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.lineup (
    id integer NOT NULL,
    team_id integer,
    leader_id integer,
    coach_id integer
);


ALTER TABLE public.lineup OWNER TO wrestling;

--
-- Name: lineup_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.lineup_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lineup_id_seq OWNER TO wrestling;

--
-- Name: lineup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.lineup_id_seq OWNED BY public.lineup.id;


--
-- Name: membership; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.membership (
    id integer NOT NULL,
    person_id integer NOT NULL,
    club_id integer NOT NULL,
    no character varying(55)
);


ALTER TABLE public.membership OWNER TO wrestling;

--
-- Name: membership_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.membership_id_seq OWNER TO wrestling;

--
-- Name: membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.membership_id_seq OWNED BY public.membership.id;


--
-- Name: participant_state; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.participant_state (
    id integer NOT NULL,
    participation_id integer NOT NULL,
    classification_points smallint
);


ALTER TABLE public.participant_state OWNER TO wrestling;

--
-- Name: participant_state_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.participant_state_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.participant_state_id_seq OWNER TO wrestling;

--
-- Name: participant_state_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.participant_state_id_seq OWNED BY public.participant_state.id;


--
-- Name: participation; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.participation (
    id integer NOT NULL,
    membership_id integer NOT NULL,
    lineup_id integer NOT NULL,
    weight_class_id integer,
    weight numeric(5,2)
);


ALTER TABLE public.participation OWNER TO wrestling;

--
-- Name: participation_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.participation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.participation_id_seq OWNER TO wrestling;

--
-- Name: participation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.participation_id_seq OWNED BY public.participation.id;


--
-- Name: person; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.person (
    id integer NOT NULL,
    prename character varying(100) NOT NULL,
    surname character varying(100) NOT NULL,
    birth_date date,
    gender public.gender
);


ALTER TABLE public.person OWNER TO wrestling;

--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.person_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.person_id_seq OWNER TO wrestling;

--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.person.id;


--
-- Name: team; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.team (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255),
    club_id integer NOT NULL
);


ALTER TABLE public.team OWNER TO wrestling;

--
-- Name: team_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.team_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_id_seq OWNER TO wrestling;

--
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_id_seq OWNED BY public.team.id;


--
-- Name: team_match; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.team_match (
    id integer,
    date date,
    location character varying(100),
    visitors_count integer,
    comment text,
    home_id integer,
    guest_id integer,
    referee_id integer,
    transcript_writer_id integer,
    time_keeper_id integer,
    mat_chairman_id integer,
    league_id integer,
    judge_id integer
)
INHERITS (public.wrestling_event);


ALTER TABLE public.team_match OWNER TO wrestling;

--
-- Name: team_match_bout; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.team_match_bout (
    id integer NOT NULL,
    team_match_id integer NOT NULL,
    bout_id integer NOT NULL,
    pos integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.team_match_bout OWNER TO wrestling;

--
-- Name: team_match_bout_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.team_match_bout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_match_bout_id_seq OWNER TO wrestling;

--
-- Name: team_match_bout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_match_bout_id_seq OWNED BY public.team_match_bout.id;


--
-- Name: team_match_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.team_match_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_match_id_seq OWNER TO wrestling;

--
-- Name: team_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_match_id_seq OWNED BY public.team_match.id;


--
-- Name: weight_class; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.weight_class (
    id integer NOT NULL,
    suffix character varying(255),
    weight smallint NOT NULL,
    style public.wrestling_style DEFAULT 'free'::public.wrestling_style NOT NULL,
    unit public.weight_unit
);


ALTER TABLE public.weight_class OWNER TO wrestling;

--
-- Name: weight_class_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.weight_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.weight_class_id_seq OWNER TO wrestling;

--
-- Name: weight_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.weight_class_id_seq OWNED BY public.weight_class.id;


--
-- Name: wrestling_event_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.wrestling_event_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.wrestling_event_id_seq OWNER TO wrestling;

--
-- Name: wrestling_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.wrestling_event_id_seq OWNED BY public.wrestling_event.id;


--
-- Name: bout id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout ALTER COLUMN id SET DEFAULT nextval('public.bout_id_seq'::regclass);


--
-- Name: bout_action id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_action ALTER COLUMN id SET DEFAULT nextval('public.bout_action_id_seq'::regclass);


--
-- Name: bout_config id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_config ALTER COLUMN id SET DEFAULT nextval('public.bout_config_id_seq'::regclass);


--
-- Name: club id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.club ALTER COLUMN id SET DEFAULT nextval('public.club_id_seq'::regclass);


--
-- Name: competition id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition ALTER COLUMN id SET DEFAULT nextval('public.competition_id_seq'::regclass);


--
-- Name: competition_bout id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_bout ALTER COLUMN id SET DEFAULT nextval('public.competition_bout_id_seq'::regclass);


--
-- Name: competition_person id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_person ALTER COLUMN id SET DEFAULT nextval('public.event_person_id_seq'::regclass);


--
-- Name: league id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league ALTER COLUMN id SET DEFAULT nextval('public.league_id_seq'::regclass);


--
-- Name: league_team_participation id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_team_participation ALTER COLUMN id SET DEFAULT nextval('public.league_team_participation_id_seq'::regclass);


--
-- Name: league_weight_class id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_weight_class ALTER COLUMN id SET DEFAULT nextval('public.league_weight_class_id_seq'::regclass);


--
-- Name: lineup id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup ALTER COLUMN id SET DEFAULT nextval('public.lineup_id_seq'::regclass);


--
-- Name: membership id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership ALTER COLUMN id SET DEFAULT nextval('public.membership_id_seq'::regclass);


--
-- Name: participant_state id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participant_state ALTER COLUMN id SET DEFAULT nextval('public.participant_state_id_seq'::regclass);


--
-- Name: participation id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participation ALTER COLUMN id SET DEFAULT nextval('public.participation_id_seq'::regclass);


--
-- Name: person id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.person ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- Name: team id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team ALTER COLUMN id SET DEFAULT nextval('public.team_id_seq'::regclass);


--
-- Name: team_match id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match ALTER COLUMN id SET DEFAULT nextval('public.team_match_id_seq'::regclass);


--
-- Name: team_match_bout id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_bout ALTER COLUMN id SET DEFAULT nextval('public.team_match_bout_id_seq'::regclass);


--
-- Name: weight_class id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.weight_class ALTER COLUMN id SET DEFAULT nextval('public.weight_class_id_seq'::regclass);


--
-- Name: wrestling_event id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.wrestling_event ALTER COLUMN id SET DEFAULT nextval('public.wrestling_event_id_seq'::regclass);


--
-- Data for Name: bout; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout (id, red_id, blue_id, weight_class_id, winner_role, bout_result, duration_millis) FROM stdin;
22	\N	\N	2	\N	\N	\N
23	25	\N	3	\N	\N	\N
24	\N	26	4	\N	\N	\N
25	27	28	7	\N	\N	\N
26	29	30	10	\N	\N	\N
21	23	24	1	red	vfa	45000
\.


--
-- Data for Name: bout_action; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout_action (id, duration_millis, point_count, action_type, bout_role, bout_id) FROM stdin;
1	20000	2	points	red	21
2	25000	1	points	red	21
3	30000	1	points	blue	21
4	36000	\N	passivity	blue	21
\.


--
-- Data for Name: bout_config; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout_config (id, period_duration_secs, break_duration_secs, activity_duration_secs, injury_duration_secs, period_count) FROM stdin;
1	180	30	30	30	2
\.


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.club (id, no, name) FROM stdin;
1	05432	Quahog Hunters
2	12345	Springfield Wrestlers
\.


--
-- Data for Name: competition; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition (id, date, location, visitors_count, comment, no, name, bout_config_id) FROM stdin;
1	2021-07-17	Quahog	15	\N	\N	The Griffin-Simpson Competition	1
\.


--
-- Data for Name: competition_bout; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition_bout (id, competition_id, bout_id) FROM stdin;
\.


--
-- Data for Name: competition_person; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition_person (id, competition_id, person_id, person_role) FROM stdin;
\.


--
-- Data for Name: league; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league (id, name, start_date, bout_config_id) FROM stdin;
2	Real Pro Wrestling Jn	2021-10-01	1
3	National League	2021-10-01	1
1	Real Pro Wrestling	2021-10-01	1
\.


--
-- Data for Name: league_team_participation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league_team_participation (id, league_id, team_id) FROM stdin;
1	1	1
2	2	2
3	3	3
4	3	1
5	1	3
\.


--
-- Data for Name: league_weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league_weight_class (id, league_id, weight_class_id, pos) FROM stdin;
1	1	1	1
2	1	3	3
3	1	4	4
4	1	7	7
5	1	2	2
6	1	10	10
7	2	1	5
\.


--
-- Data for Name: lineup; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.lineup (id, team_id, leader_id, coach_id) FROM stdin;
3	2	\N	\N
2	3	\N	\N
4	3	\N	\N
1	1	1	\N
\.


--
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.membership (id, person_id, club_id, no) FROM stdin;
1	1	2	\N
2	2	2	\N
3	3	2	\N
4	4	2	\N
5	5	1	\N
6	6	1	\N
7	7	1	\N
8	8	1	\N
\.


--
-- Data for Name: participant_state; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.participant_state (id, participation_id, classification_points) FROM stdin;
25	2	\N
26	6	\N
27	3	\N
28	7	\N
29	4	\N
30	8	\N
24	5	1
23	1	4
\.


--
-- Data for Name: participation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.participation (id, membership_id, lineup_id, weight_class_id, weight) FROM stdin;
2	2	1	3	64.50
4	4	1	10	110.00
5	5	2	1	55.30
7	7	2	7	80.20
8	8	2	10	129.80
3	3	1	7	79.12
6	6	2	4	70.95
1	1	1	1	59.12
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.person (id, prename, surname, birth_date, gender) FROM stdin;
1	Lisa	Simpson	2010-07-08	female
2	Bart	Simpson	2007-07-08	male
3	March	Simpson	1980-07-08	female
4	Homer	Simpson	1975-07-08	male
5	Chris	Griffin	2005-03-08	male
6	Meg	Griffin	2007-03-08	female
7	Lois	Griffin	1979-03-08	female
8	Peter	Griffin	1975-03-08	male
9	Mr	Referee	\N	other
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team (id, name, description, club_id) FROM stdin;
1	Springfield Wrestlers	1. Team Men	2
2	Springfield Wrestlers Jn	Juniors	2
3	Quahog Hunters II	2. Team Men	1
\.


--
-- Data for Name: team_match; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match (id, date, location, visitors_count, comment, no, home_id, guest_id, referee_id, transcript_writer_id, time_keeper_id, mat_chairman_id, league_id, judge_id) FROM stdin;
1	2021-07-10	Springfield	\N	\N	\N	1	2	9	\N	\N	\N	1	\N
\.


--
-- Data for Name: team_match_bout; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match_bout (id, team_match_id, bout_id, pos) FROM stdin;
19	1	21	0
20	1	22	1
21	1	23	2
22	1	24	3
23	1	25	4
24	1	26	5
\.


--
-- Data for Name: weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.weight_class (id, suffix, weight, style, unit) FROM stdin;
6	B	75	greco	kilogram
1	\N	57	free	kilogram
7	\N	80	free	kilogram
2	\N	61	greco	kilogram
3	\N	66	free	kilogram
8	\N	86	greco	kilogram
9	\N	98	free	kilogram
4	\N	71	greco	kilogram
5	A	75	free	kilogram
10	\N	130	greco	kilogram
\.


--
-- Data for Name: wrestling_event; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.wrestling_event (id, date, location, visitors_count, comment, no) FROM stdin;
\.


--
-- Name: bout_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_action_id_seq', 4, true);


--
-- Name: bout_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_config_id_seq', 1, true);


--
-- Name: bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_id_seq', 26, true);


--
-- Name: club_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.club_id_seq', 2, true);


--
-- Name: competition_bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.competition_bout_id_seq', 1, false);


--
-- Name: competition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.competition_id_seq', 1, false);


--
-- Name: event_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.event_person_id_seq', 1, false);


--
-- Name: league_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_id_seq', 7, true);


--
-- Name: league_team_participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_team_participation_id_seq', 1, false);


--
-- Name: league_weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_weight_class_id_seq', 7, true);


--
-- Name: lineup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.lineup_id_seq', 4, true);


--
-- Name: membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.membership_id_seq', 8, true);


--
-- Name: participant_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.participant_state_id_seq', 30, true);


--
-- Name: participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.participation_id_seq', 8, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.person_id_seq', 9, true);


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_id_seq', 3, true);


--
-- Name: team_match_bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_bout_id_seq', 24, true);


--
-- Name: team_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_id_seq', 1, true);


--
-- Name: weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.weight_class_id_seq', 10, true);


--
-- Name: wrestling_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.wrestling_event_id_seq', 1, true);


--
-- Name: bout_action bout_action_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_action
    ADD CONSTRAINT bout_action_pk PRIMARY KEY (id);


--
-- Name: bout_config bout_config_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_config
    ADD CONSTRAINT bout_config_pk PRIMARY KEY (id);


--
-- Name: bout bout_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout
    ADD CONSTRAINT bout_pk PRIMARY KEY (id);


--
-- Name: club club_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pk PRIMARY KEY (id);


--
-- Name: competition_bout competition_bout_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_bout
    ADD CONSTRAINT competition_bout_pk PRIMARY KEY (id);


--
-- Name: competition competition_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition
    ADD CONSTRAINT competition_pk PRIMARY KEY (id);


--
-- Name: competition_person event_person_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_person
    ADD CONSTRAINT event_person_pk PRIMARY KEY (id);


--
-- Name: league league_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_pk PRIMARY KEY (id);


--
-- Name: league_team_participation league_team_participation_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_team_participation
    ADD CONSTRAINT league_team_participation_pk PRIMARY KEY (id);


--
-- Name: league_weight_class league_weight_class_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_weight_class
    ADD CONSTRAINT league_weight_class_pk PRIMARY KEY (id);


--
-- Name: lineup lineup_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup
    ADD CONSTRAINT lineup_pk PRIMARY KEY (id);


--
-- Name: membership membership_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_pk PRIMARY KEY (id);


--
-- Name: membership membership_pkey; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_pkey UNIQUE (person_id, club_id);


--
-- Name: participant_state participant_state_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participant_state
    ADD CONSTRAINT participant_state_pk PRIMARY KEY (id);


--
-- Name: participation participation_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_pk PRIMARY KEY (id);


--
-- Name: person person_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pk PRIMARY KEY (id);


--
-- Name: team_match_bout team_match_bout_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_bout
    ADD CONSTRAINT team_match_bout_pk PRIMARY KEY (id);


--
-- Name: team_match team_match_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_pk PRIMARY KEY (id);


--
-- Name: team team_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_pk PRIMARY KEY (id);


--
-- Name: weight_class weight_class_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.weight_class
    ADD CONSTRAINT weight_class_pk PRIMARY KEY (id);


--
-- Name: wrestling_event wrestling_event_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.wrestling_event
    ADD CONSTRAINT wrestling_event_pk PRIMARY KEY (id);


--
-- Name: bout_config_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX bout_config_id_uindex ON public.bout_config USING btree (id);


--
-- Name: club_no_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX club_no_uindex ON public.club USING btree (no);


--
-- Name: event_person_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX event_person_id_uindex ON public.competition_person USING btree (id);


--
-- Name: league_team_participation_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX league_team_participation_id_uindex ON public.league_team_participation USING btree (id);


--
-- Name: league_weight_class_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX league_weight_class_id_uindex ON public.league_weight_class USING btree (id);


--
-- Name: team_match_bout_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX team_match_bout_id_uindex ON public.team_match_bout USING btree (id);


--
-- Name: bout_action bout_action_bout_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_action
    ADD CONSTRAINT bout_action_bout_id_fk FOREIGN KEY (bout_id) REFERENCES public.bout(id) ON DELETE CASCADE;


--
-- Name: bout bout_participant_state_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout
    ADD CONSTRAINT bout_participant_state_id_fk FOREIGN KEY (red_id) REFERENCES public.participant_state(id) ON DELETE CASCADE;


--
-- Name: bout bout_participant_state_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout
    ADD CONSTRAINT bout_participant_state_id_fk_2 FOREIGN KEY (blue_id) REFERENCES public.participant_state(id) ON DELETE CASCADE;


--
-- Name: bout bout_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout
    ADD CONSTRAINT bout_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


--
-- Name: competition_bout competition_bout_bout_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_bout
    ADD CONSTRAINT competition_bout_bout_id_fk FOREIGN KEY (bout_id) REFERENCES public.bout(id) ON DELETE CASCADE;


--
-- Name: competition_bout competition_bout_competition_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_bout
    ADD CONSTRAINT competition_bout_competition_id_fk FOREIGN KEY (competition_id) REFERENCES public.competition(id) ON DELETE CASCADE;


--
-- Name: competition competition_bout_config_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition
    ADD CONSTRAINT competition_bout_config_id_fk FOREIGN KEY (bout_config_id) REFERENCES public.bout_config(id) ON DELETE CASCADE;


--
-- Name: competition_person event_person_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_person
    ADD CONSTRAINT event_person_person_id_fk FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: competition_person event_person_wrestling_event_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.competition_person
    ADD CONSTRAINT event_person_wrestling_event_id_fk FOREIGN KEY (competition_id) REFERENCES public.wrestling_event(id) ON DELETE CASCADE;


--
-- Name: league league_bout_config_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_bout_config_id_fk FOREIGN KEY (bout_config_id) REFERENCES public.bout_config(id) ON DELETE CASCADE;


--
-- Name: league_team_participation league_team_participation_league_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_team_participation
    ADD CONSTRAINT league_team_participation_league_id_fk FOREIGN KEY (league_id) REFERENCES public.league(id) ON DELETE CASCADE;


--
-- Name: league_team_participation league_team_participation_team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_team_participation
    ADD CONSTRAINT league_team_participation_team_id_fk FOREIGN KEY (team_id) REFERENCES public.team(id) ON DELETE CASCADE;


--
-- Name: league_weight_class league_weight_class_league_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_weight_class
    ADD CONSTRAINT league_weight_class_league_id_fk FOREIGN KEY (league_id) REFERENCES public.league(id) ON DELETE CASCADE;


--
-- Name: league_weight_class league_weight_class_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_weight_class
    ADD CONSTRAINT league_weight_class_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


--
-- Name: lineup lineup_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup
    ADD CONSTRAINT lineup_person_id_fk FOREIGN KEY (leader_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: lineup lineup_person_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup
    ADD CONSTRAINT lineup_person_id_fk_2 FOREIGN KEY (coach_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: membership membership_club_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_club_id_fk FOREIGN KEY (club_id) REFERENCES public.club(id);


--
-- Name: membership membership_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_person_id_fk FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: participant_state participant_state_participation_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participant_state
    ADD CONSTRAINT participant_state_participation_id_fk FOREIGN KEY (participation_id) REFERENCES public.participation(id) ON DELETE CASCADE;


--
-- Name: participation participation_lineup_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_lineup_id_fk FOREIGN KEY (lineup_id) REFERENCES public.lineup(id);


--
-- Name: participation participation_membership_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_membership_id_fk FOREIGN KEY (membership_id) REFERENCES public.membership(id) ON DELETE CASCADE;


--
-- Name: participation participation_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


--
-- Name: team team_club_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_club_id_fk FOREIGN KEY (club_id) REFERENCES public.club(id) ON DELETE CASCADE;


--
-- Name: team_match_bout team_match_bout_bout_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_bout
    ADD CONSTRAINT team_match_bout_bout_id_fk FOREIGN KEY (bout_id) REFERENCES public.bout(id) ON DELETE CASCADE;


--
-- Name: team_match_bout team_match_bout_team_match_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_bout
    ADD CONSTRAINT team_match_bout_team_match_id_fk FOREIGN KEY (team_match_id) REFERENCES public.team_match(id) ON DELETE CASCADE;


--
-- Name: team_match team_match_league_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_league_id_fk FOREIGN KEY (league_id) REFERENCES public.league(id) ON DELETE CASCADE;


--
-- Name: team_match team_match_lineup_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_lineup_id_fk FOREIGN KEY (home_id) REFERENCES public.lineup(id) ON DELETE CASCADE;


--
-- Name: team_match team_match_lineup_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_lineup_id_fk_2 FOREIGN KEY (guest_id) REFERENCES public.lineup(id);


--
-- Name: team_match team_match_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_person_id_fk FOREIGN KEY (referee_id) REFERENCES public.person(id);


--
-- Name: team_match team_match_person_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_person_id_fk_2 FOREIGN KEY (transcript_writer_id) REFERENCES public.person(id);


--
-- Name: team_match team_match_person_id_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_person_id_fk_3 FOREIGN KEY (time_keeper_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: team_match team_match_person_id_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_person_id_fk_4 FOREIGN KEY (mat_chairman_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: team_match team_match_person_id_fk_5; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match
    ADD CONSTRAINT team_match_person_id_fk_5 FOREIGN KEY (judge_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--


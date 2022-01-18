--
-- PostgreSQL database dump
--

-- Dumped from database version 13.5 (Ubuntu 13.5-0ubuntu0.21.10.1)
-- Dumped by pg_dump version 13.5 (Ubuntu 13.5-0ubuntu0.21.10.1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: wrestling
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO wrestling;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: wrestling
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: fight_action_type; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.fight_action_type AS ENUM (
    'points',
    'passivity',
    'verbal',
    'caution',
    'dismissal'
);


ALTER TYPE public.fight_action_type OWNER TO wrestling;

--
-- Name: fight_result; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.fight_result AS ENUM (
    'VFA',
    'VIN',
    'VCA',
    'VSU',
    'VSU1',
    'VPO',
    'VPO1',
    'VFO',
    'DSQ',
    'DSQ2'
);


ALTER TYPE public.fight_result OWNER TO wrestling;

--
-- Name: fight_role; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.fight_role AS ENUM (
    'red',
    'blue'
);


ALTER TYPE public.fight_role OWNER TO wrestling;

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


ALTER TABLE public.club_id_seq OWNER TO wrestling;

--
-- Name: club_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.club_id_seq OWNED BY public.club.id;


--
-- Name: fight; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.fight (
    id integer NOT NULL,
    red_id integer,
    blue_id integer,
    weight_class_id integer NOT NULL,
    winner public.fight_role,
    fight_result public.fight_result
);


ALTER TABLE public.fight OWNER TO wrestling;

--
-- Name: fight_action; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.fight_action (
    id integer NOT NULL,
    duration_millis integer NOT NULL,
    point_count smallint,
    action_type public.fight_action_type NOT NULL,
    fight_role public.fight_role NOT NULL,
    fight_id integer NOT NULL
);


ALTER TABLE public.fight_action OWNER TO wrestling;

--
-- Name: fight_action_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.fight_action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fight_action_id_seq OWNER TO wrestling;

--
-- Name: fight_action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.fight_action_id_seq OWNED BY public.fight_action.id;


--
-- Name: fight_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.fight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fight_id_seq OWNER TO wrestling;

--
-- Name: fight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.fight_id_seq OWNED BY public.fight.id;


--
-- Name: league; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.league (
    id integer NOT NULL,
    name character varying(127) NOT NULL,
    start_date date NOT NULL
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


ALTER TABLE public.league_id_seq OWNER TO wrestling;

--
-- Name: league_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.league_id_seq OWNED BY public.league.id;


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


ALTER TABLE public.league_weight_class_id_seq OWNER TO wrestling;

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


ALTER TABLE public.lineup_id_seq OWNER TO wrestling;

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


ALTER TABLE public.membership_id_seq OWNER TO wrestling;

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


ALTER TABLE public.participant_state_id_seq OWNER TO wrestling;

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
    weight_class_id integer NOT NULL,
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


ALTER TABLE public.participation_id_seq OWNER TO wrestling;

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


ALTER TABLE public.person_id_seq OWNER TO wrestling;

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
    club_id integer NOT NULL,
    league_id integer
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


ALTER TABLE public.team_id_seq OWNER TO wrestling;

--
-- Name: team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_id_seq OWNED BY public.team.id;


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
    mat_president_id integer,
    league_id integer
)
INHERITS (public.wrestling_event);


ALTER TABLE public.team_match OWNER TO wrestling;

--
-- Name: team_match_fight; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.team_match_fight (
    id integer NOT NULL,
    team_match_id integer NOT NULL,
    fight_id integer NOT NULL,
    pos integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.team_match_fight OWNER TO wrestling;

--
-- Name: team_match_fight_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.team_match_fight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_match_fight_id_seq OWNER TO wrestling;

--
-- Name: team_match_fight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_match_fight_id_seq OWNED BY public.team_match_fight.id;


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


ALTER TABLE public.team_match_id_seq OWNER TO wrestling;

--
-- Name: team_match_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_match_id_seq OWNED BY public.team_match.id;


--
-- Name: tournament; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.tournament (
    name character varying(127)
)
INHERITS (public.wrestling_event);


ALTER TABLE public.tournament OWNER TO wrestling;

--
-- Name: tournament_fight; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.tournament_fight (
    id integer NOT NULL,
    tournament_id integer NOT NULL,
    fight_id integer
);


ALTER TABLE public.tournament_fight OWNER TO wrestling;

--
-- Name: tournament_fight_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.tournament_fight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_fight_id_seq OWNER TO wrestling;

--
-- Name: tournament_fight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.tournament_fight_id_seq OWNED BY public.tournament_fight.id;


--
-- Name: tournament_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.tournament_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tournament_id_seq OWNER TO wrestling;

--
-- Name: tournament_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.tournament_id_seq OWNED BY public.tournament.id;


--
-- Name: weight_class; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.weight_class (
    id integer NOT NULL,
    name character varying(255),
    weight smallint NOT NULL,
    style public.wrestling_style DEFAULT 'free'::public.wrestling_style NOT NULL
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


ALTER TABLE public.weight_class_id_seq OWNER TO wrestling;

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


ALTER TABLE public.wrestling_event_id_seq OWNER TO wrestling;

--
-- Name: wrestling_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.wrestling_event_id_seq OWNED BY public.wrestling_event.id;


--
-- Name: club id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.club ALTER COLUMN id SET DEFAULT nextval('public.club_id_seq'::regclass);


--
-- Name: fight id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight ALTER COLUMN id SET DEFAULT nextval('public.fight_id_seq'::regclass);


--
-- Name: fight_action id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight_action ALTER COLUMN id SET DEFAULT nextval('public.fight_action_id_seq'::regclass);


--
-- Name: league id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league ALTER COLUMN id SET DEFAULT nextval('public.league_id_seq'::regclass);


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
-- Name: team_match_fight id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_fight ALTER COLUMN id SET DEFAULT nextval('public.team_match_fight_id_seq'::regclass);


--
-- Name: tournament id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.tournament ALTER COLUMN id SET DEFAULT nextval('public.tournament_id_seq'::regclass);


--
-- Name: tournament_fight id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.tournament_fight ALTER COLUMN id SET DEFAULT nextval('public.tournament_fight_id_seq'::regclass);


--
-- Name: weight_class id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.weight_class ALTER COLUMN id SET DEFAULT nextval('public.weight_class_id_seq'::regclass);


--
-- Name: wrestling_event id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.wrestling_event ALTER COLUMN id SET DEFAULT nextval('public.wrestling_event_id_seq'::regclass);


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.club (id, no, name) FROM stdin;
1	05432	Quahog Hunters
2	12345	Springfield Wrestlers
\.


--
-- Data for Name: fight; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.fight (id, red_id, blue_id, weight_class_id, winner, fight_result) FROM stdin;
21	23	24	1	\N	\N
22	\N	\N	2	\N	\N
23	25	\N	3	\N	\N
24	\N	26	4	\N	\N
25	27	28	7	\N	\N
26	29	30	10	\N	\N
\.


--
-- Data for Name: fight_action; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.fight_action (id, duration_millis, point_count, action_type, fight_role, fight_id) FROM stdin;
\.


--
-- Data for Name: league; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league (id, name, start_date) FROM stdin;
2	Real Pro Wrestling Jn	2021-10-01
3	National League	2021-10-01
1	Real Pro Wrestling	2021-10-01
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
23	1	\N
24	5	\N
25	2	\N
26	6	\N
27	3	\N
28	7	\N
29	4	\N
30	8	\N
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

COPY public.team (id, name, description, club_id, league_id) FROM stdin;
1	Springfield Wrestlers	1. Team Men	2	1
2	Springfield Wrestlers Jn	Juniors	2	2
3	Quahog Hunters II	2. Team Men	1	1
\.


--
-- Data for Name: team_match; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match (id, date, location, visitors_count, comment, home_id, guest_id, referee_id, transcript_writer_id, time_keeper_id, mat_president_id, league_id, no) FROM stdin;
1	2021-07-10	Springfield	\N	\N	1	2	9	\N	\N	\N	1	\N
\.


--
-- Data for Name: team_match_fight; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match_fight (id, team_match_id, fight_id, pos) FROM stdin;
19	1	21	0
20	1	22	0
21	1	23	0
22	1	24	0
23	1	25	0
24	1	26	0
\.


--
-- Data for Name: tournament; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.tournament (id, date, location, visitors_count, comment, name, no) FROM stdin;
1	2021-07-17	Quahog	15	\N	The Griffin-Simpson Tournament	\N
\.


--
-- Data for Name: tournament_fight; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.tournament_fight (id, tournament_id, fight_id) FROM stdin;
\.


--
-- Data for Name: weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.weight_class (id, name, weight, style) FROM stdin;
1	\N	57	free
2	\N	61	greco
3	\N	66	free
4	\N	71	greco
7	\N	80	free
8	\N	86	greco
9	\N	98	free
10	\N	130	greco
5	75 kg A	75	free
6	75 kg B	75	greco
\.


--
-- Data for Name: wrestling_event; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.wrestling_event (id, date, location, visitors_count, comment, no) FROM stdin;
\.


--
-- Name: club_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.club_id_seq', 2, true);


--
-- Name: fight_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.fight_action_id_seq', 1, false);


--
-- Name: fight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.fight_id_seq', 26, true);


--
-- Name: league_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_id_seq', 7, true);


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
-- Name: team_match_fight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_fight_id_seq', 24, true);


--
-- Name: team_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_id_seq', 1, true);


--
-- Name: tournament_fight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.tournament_fight_id_seq', 1, false);


--
-- Name: tournament_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.tournament_id_seq', 1, false);


--
-- Name: weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.weight_class_id_seq', 10, true);


--
-- Name: wrestling_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.wrestling_event_id_seq', 1, true);


--
-- Name: club club_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_pk PRIMARY KEY (id);


--
-- Name: fight_action fight_action_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight_action
    ADD CONSTRAINT fight_action_pk PRIMARY KEY (id);


--
-- Name: fight fight_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight
    ADD CONSTRAINT fight_pk PRIMARY KEY (id);


--
-- Name: league league_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_pk PRIMARY KEY (id);


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
-- Name: team_match_fight team_match_fight_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_fight
    ADD CONSTRAINT team_match_fight_pk PRIMARY KEY (id);


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
-- Name: tournament_fight tournament_fight_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.tournament_fight
    ADD CONSTRAINT tournament_fight_pk PRIMARY KEY (id);


--
-- Name: tournament tournament_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.tournament
    ADD CONSTRAINT tournament_pk PRIMARY KEY (id);


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
-- Name: club_no_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX club_no_uindex ON public.club USING btree (no);


--
-- Name: league_weight_class_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX league_weight_class_id_uindex ON public.league_weight_class USING btree (id);


--
-- Name: team_match_fight_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX team_match_fight_id_uindex ON public.team_match_fight USING btree (id);


--
-- Name: fight_action fight_action_fight_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight_action
    ADD CONSTRAINT fight_action_fight_id_fk FOREIGN KEY (fight_id) REFERENCES public.fight(id) ON DELETE CASCADE;


--
-- Name: fight fight_participant_state_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight
    ADD CONSTRAINT fight_participant_state_id_fk FOREIGN KEY (red_id) REFERENCES public.participant_state(id) ON DELETE CASCADE;


--
-- Name: fight fight_participant_state_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight
    ADD CONSTRAINT fight_participant_state_id_fk_2 FOREIGN KEY (blue_id) REFERENCES public.participant_state(id) ON DELETE CASCADE;


--
-- Name: fight fight_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.fight
    ADD CONSTRAINT fight_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT lineup_person_id_fk_2 FOREIGN KEY (coach_id) REFERENCES public.person(id);


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
-- Name: team team_league_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_league_id_fk FOREIGN KEY (league_id) REFERENCES public.league(id) ON DELETE CASCADE;


--
-- Name: team_match_fight team_match_fight_fight_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_fight
    ADD CONSTRAINT team_match_fight_fight_id_fk FOREIGN KEY (fight_id) REFERENCES public.fight(id) ON DELETE CASCADE;


--
-- Name: team_match_fight team_match_fight_team_match_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_fight
    ADD CONSTRAINT team_match_fight_team_match_id_fk FOREIGN KEY (team_match_id) REFERENCES public.team_match(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT team_match_person_id_fk_4 FOREIGN KEY (mat_president_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: tournament_fight tournament_fight_fight_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.tournament_fight
    ADD CONSTRAINT tournament_fight_fight_id_fk FOREIGN KEY (fight_id) REFERENCES public.fight(id) ON DELETE CASCADE;


--
-- Name: tournament_fight tournament_fight_tournament_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.tournament_fight
    ADD CONSTRAINT tournament_fight_tournament_id_fk FOREIGN KEY (tournament_id) REFERENCES public.tournament(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


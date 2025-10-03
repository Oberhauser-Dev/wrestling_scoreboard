--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: api_provider; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.api_provider AS ENUM (
    'deNwRingenApi',
    'deByRingenApi'
);


ALTER TYPE public.api_provider OWNER TO wrestling;

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
    'vpo',
    'vfo',
    'dsq',
    'bothDsq',
    'bothVfo',
    'bothVin'
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
    'steward'
);


ALTER TYPE public.person_role OWNER TO wrestling;

--
-- Name: report_provider; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.report_provider AS ENUM (
    'deNwRdb274'
);


ALTER TYPE public.report_provider OWNER TO wrestling;

--
-- Name: user_privilege; Type: TYPE; Schema: public; Owner: wrestling
--

CREATE TYPE public.user_privilege AS ENUM (
    'none',
    'read',
    'write',
    'admin'
);


ALTER TYPE public.user_privilege OWNER TO wrestling;

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
    duration_millis integer,
    org_sync_id character varying(127),
    organization_id integer
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
    period_count smallint,
    bleeding_injury_duration_secs integer
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
-- Name: bout_result_rule; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.bout_result_rule (
    id integer NOT NULL,
    bout_config_id integer NOT NULL,
    bout_result public.bout_result NOT NULL,
    winner_technical_points smallint,
    loser_technical_points smallint,
    technical_points_difference smallint,
    winner_classification_points smallint NOT NULL,
    loser_classification_points smallint NOT NULL
);


ALTER TABLE public.bout_result_rule OWNER TO wrestling;

--
-- Name: bout_result_rule_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.bout_result_rule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bout_result_rule_id_seq OWNER TO wrestling;

--
-- Name: bout_result_rule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.bout_result_rule_id_seq OWNED BY public.bout_result_rule.id;


--
-- Name: club; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.club (
    id integer NOT NULL,
    no character varying(8),
    name character varying(255) NOT NULL,
    organization_id integer NOT NULL,
    org_sync_id character varying(127)
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
    no character varying(16),
    organization_id integer,
    org_sync_id character varying(127)
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
-- Name: division; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.division (
    id integer NOT NULL,
    name character varying(127) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    bout_config_id integer NOT NULL,
    season_partitions integer DEFAULT 1 NOT NULL,
    parent_id integer,
    organization_id integer NOT NULL,
    org_sync_id character varying(127)
);


ALTER TABLE public.division OWNER TO wrestling;

--
-- Name: division_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.division_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.division_id_seq OWNER TO wrestling;

--
-- Name: division_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.division_id_seq OWNED BY public.division.id;


--
-- Name: division_weight_class; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.division_weight_class (
    id integer NOT NULL,
    division_id integer NOT NULL,
    weight_class_id integer NOT NULL,
    pos integer DEFAULT 0 NOT NULL,
    season_partition integer,
    org_sync_id character varying(127),
    organization_id integer
);


ALTER TABLE public.division_weight_class OWNER TO wrestling;

--
-- Name: division_weight_class_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.division_weight_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.division_weight_class_id_seq OWNER TO wrestling;

--
-- Name: division_weight_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.division_weight_class_id_seq OWNED BY public.division_weight_class.id;


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
    end_date date NOT NULL,
    division_id integer NOT NULL,
    org_sync_id character varying(127),
    organization_id integer,
    bout_days integer DEFAULT 14 NOT NULL
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
    pos integer DEFAULT 0 NOT NULL,
    season_partition integer,
    org_sync_id character varying(127),
    organization_id integer
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
    no character varying(55),
    org_sync_id character varying(127),
    organization_id integer
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
-- Name: migration; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.migration (
    semver character varying(127) DEFAULT '0.0.0'::character varying NOT NULL,
    min_client_version character varying(127) DEFAULT '0.0.0'::character varying NOT NULL
);


ALTER TABLE public.migration OWNER TO wrestling;

--
-- Name: organization; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.organization (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    abbreviation character varying(64),
    parent_id integer,
    api_provider public.api_provider,
    report_provider public.report_provider
);


ALTER TABLE public.organization OWNER TO wrestling;

--
-- Name: organization_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.organization_id_seq OWNER TO wrestling;

--
-- Name: organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.organization_id_seq OWNED BY public.organization.id;


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
    gender public.gender,
    nationality character(3) DEFAULT NULL::bpchar,
    org_sync_id character varying(127),
    organization_id integer
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
-- Name: secured_user; Type: TABLE; Schema: public; Owner: wrestling
--

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

--
-- Name: team; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.team (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(255),
    org_sync_id character varying(127),
    organization_id integer
);


ALTER TABLE public.team OWNER TO wrestling;

--
-- Name: team_club_affiliation; Type: TABLE; Schema: public; Owner: wrestling
--

CREATE TABLE public.team_club_affiliation (
    id integer NOT NULL,
    team_id integer NOT NULL,
    club_id integer NOT NULL
);


ALTER TABLE public.team_club_affiliation OWNER TO wrestling;

--
-- Name: team_club_affiliation_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.team_club_affiliation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.team_club_affiliation_id_seq OWNER TO wrestling;

--
-- Name: team_club_affiliation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.team_club_affiliation_id_seq OWNED BY public.team_club_affiliation.id;


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
    judge_id integer,
    season_partition integer
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
    pos integer DEFAULT 0 NOT NULL,
    org_sync_id character varying(127),
    organization_id integer
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
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: wrestling
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO wrestling;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: wrestling
--

ALTER SEQUENCE public.user_id_seq OWNED BY public.secured_user.id;


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
-- Name: bout_result_rule id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_result_rule ALTER COLUMN id SET DEFAULT nextval('public.bout_result_rule_id_seq'::regclass);


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
-- Name: division id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division ALTER COLUMN id SET DEFAULT nextval('public.division_id_seq'::regclass);


--
-- Name: division_weight_class id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division_weight_class ALTER COLUMN id SET DEFAULT nextval('public.division_weight_class_id_seq'::regclass);


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
-- Name: organization id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.organization ALTER COLUMN id SET DEFAULT nextval('public.organization_id_seq'::regclass);


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
-- Name: secured_user id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.secured_user ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: team id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team ALTER COLUMN id SET DEFAULT nextval('public.team_id_seq'::regclass);


--
-- Name: team_club_affiliation id; Type: DEFAULT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_club_affiliation ALTER COLUMN id SET DEFAULT nextval('public.team_club_affiliation_id_seq'::regclass);


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

COPY public.bout (id, red_id, blue_id, weight_class_id, winner_role, bout_result, duration_millis, org_sync_id, organization_id) FROM stdin;
52	79	80	85	blue	vpo	360000	005029c_61_kg_free	2
\.


--
-- Data for Name: bout_action; Type: TABLE DATA; Schema: public; Owner: wrestling
--
-- Id 16 (not existent any more) is an example for removing an entity in a list on import
-- 16	360000	1	points	red	52
COPY public.bout_action (id, duration_millis, point_count, action_type, bout_role, bout_id) FROM stdin;
5	26000	2	points	red	52
6	37000	2	points	blue	52
7	98000	\N	verbal	blue	52
8	124000	\N	passivity	blue	52
9	156000	1	points	red	52
10	252000	\N	verbal	red	52
11	292000	\N	passivity	red	52
12	326000	1	points	blue	52
13	337000	1	points	red	52
14	360000	\N	passivity	blue	52
15	360000	2	points	blue	52
\.


--
-- Data for Name: bout_config; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout_config (id, period_duration_secs, break_duration_secs, activity_duration_secs, injury_duration_secs, period_count, bleeding_injury_duration_secs) FROM stdin;
2	120	30	30	120	2	240
3	120	30	30	120	2	240
4	180	30	30	120	2	240
5	180	30	30	120	2	240
6	180	30	30	120	2	240
7	180	30	30	120	2	240
\.


--
-- Data for Name: bout_result_rule; Type: TABLE DATA; Schema: public; Owner: wrestling
--
-- Id 72 is an example for adding an entity in a list on import
COPY public.bout_result_rule (id, bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points) FROM stdin;
5	2	vpo	\N	\N	8	3	0
6	2	vpo	\N	\N	3	2	0
8	2	vfo	\N	\N	\N	4	0
9	2	dsq	\N	\N	\N	4	0
11	3	vfa	\N	\N	\N	4	0
12	3	vin	\N	\N	\N	4	0
13	3	vca	\N	\N	\N	4	0
14	3	vsu	\N	\N	15	4	0
15	3	vpo	\N	\N	8	3	0
16	3	vpo	\N	\N	3	2	0
18	3	vfo	\N	\N	\N	4	0
19	3	dsq	\N	\N	\N	4	0
21	4	vfa	\N	\N	\N	4	0
22	4	vin	\N	\N	\N	4	0
23	4	vca	\N	\N	\N	4	0
24	4	vsu	\N	\N	15	4	0
25	4	vpo	\N	\N	8	3	0
26	4	vpo	\N	\N	3	2	0
28	4	vfo	\N	\N	\N	4	0
29	4	dsq	\N	\N	\N	4	0
31	5	vfa	\N	\N	\N	4	0
32	5	vin	\N	\N	\N	4	0
33	5	vca	\N	\N	\N	4	0
34	5	vsu	\N	\N	15	4	0
35	5	vpo	\N	\N	8	3	0
36	5	vpo	\N	\N	3	2	0
38	5	vfo	\N	\N	\N	4	0
39	5	dsq	\N	\N	\N	4	0
41	6	vfa	\N	\N	\N	4	0
42	6	vin	\N	\N	\N	4	0
43	6	vca	\N	\N	\N	4	0
44	6	vsu	\N	\N	15	4	0
45	6	vpo	\N	\N	8	3	0
46	6	vpo	\N	\N	3	2	0
48	6	vfo	\N	\N	\N	4	0
49	6	dsq	\N	\N	\N	4	0
51	7	vfa	\N	\N	\N	4	0
52	7	vin	\N	\N	\N	4	0
53	7	vca	\N	\N	\N	4	0
54	7	vsu	\N	\N	15	4	0
55	7	vpo	\N	\N	8	3	0
56	7	vpo	\N	\N	3	2	0
58	7	vfo	\N	\N	\N	4	0
59	7	dsq	\N	\N	\N	4	0
10	2	bothDsq	\N	\N	\N	0	0
20	3	bothDsq	\N	\N	\N	0	0
30	4	bothDsq	\N	\N	\N	0	0
40	5	bothDsq	\N	\N	\N	0	0
50	6	bothDsq	\N	\N	\N	0	0
60	7	bothDsq	\N	\N	\N	0	0
61	2	bothVfo	\N	\N	\N	0	0
62	3	bothVfo	\N	\N	\N	0	0
63	4	bothVfo	\N	\N	\N	0	0
64	5	bothVfo	\N	\N	\N	0	0
65	6	bothVfo	\N	\N	\N	0	0
66	7	bothVfo	\N	\N	\N	0	0
67	2	bothVin	\N	\N	\N	0	0
68	3	bothVin	\N	\N	\N	0	0
69	4	bothVin	\N	\N	\N	0	0
70	5	bothVin	\N	\N	\N	0	0
71	6	bothVin	\N	\N	\N	0	0
7	2	vpo	1	\N	0	1	0
17	3	vpo	1	\N	0	1	0
27	4	vpo	1	\N	0	1	0
37	5	vpo	1	\N	0	1	0
47	6	vpo	1	\N	0	1	0
57	7	vpo	1	\N	0	1	0
1	2	vfa	\N	\N	\N	4	0
2	2	vin	\N	\N	\N	4	0
3	2	vca	\N	\N	\N	4	0
4	2	vsu	\N	\N	15	4	0
72	7	bothVin	\N	\N	\N	0	0
\.


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.club (id, no, name, organization_id, org_sync_id) FROM stdin;
3	30525	RG Willmering	2	30525
4	30074	ASV Cham	2	30074
5	20178	TV Geiselhöring	2	20178
6	70434	TSC Mering	2	70434
7	10142	TSV Berchtesgaden	2	10142
8	20696	SV Untergriesbach	2	20696
\.


--
-- Data for Name: competition; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition (id, date, location, visitors_count, comment, no, organization_id, org_sync_id, name, bout_config_id) FROM stdin;
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
-- Data for Name: division; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.division (id, name, start_date, end_date, bout_config_id, season_partitions, parent_id, organization_id, org_sync_id) FROM stdin;
3	(S) Bezirksliga	2023-01-01	2024-01-01	2	2	\N	2	2023_(S) Bezirksliga
4	(S) Finalrunde	2023-01-01	2024-01-01	3	2	\N	2	2023_(S) Finalrunde
5	Bayernliga	2023-01-01	2024-01-01	4	2	\N	2	2023_Bayernliga
6	Gruppenoberliga	2023-01-01	2024-01-01	5	2	\N	2	2023_Gruppenoberliga
7	Landesliga	2023-01-01	2024-01-01	6	2	\N	2	2023_Landesliga
8	Oberliga	2023-01-01	2024-01-01	7	2	\N	2	2023_Oberliga
\.


--
-- Data for Name: division_weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.division_weight_class (id, division_id, weight_class_id, pos, season_partition, org_sync_id, organization_id) FROM stdin;
30	3	33	0	0	2023_(S)_Bezirksliga_29_kg_free_0	2
40	3	43	0	1	2023_(S)_Bezirksliga_29_kg_greco_1	2
50	4	53	0	0	2023_(S)_Finalrunde_29_kg_free_0	2
60	4	63	0	1	2023_(S)_Finalrunde_29_kg_greco_1	2
70	5	73	0	0	2023_Bayernliga_57_kg_free_0	2
80	5	83	0	1	2023_Bayernliga_57_kg_greco_1	2
90	6	93	0	0	2023_Gruppenoberliga_57_kg_free_0	2
99	6	102	9	0	2023_Gruppenoberliga_66_kg_greco_0	2
104	6	107	0	1	2023_Gruppenoberliga_57_kg_greco_1	2
113	6	116	9	1	2023_Gruppenoberliga_66_kg_free_1	2
118	7	121	0	0	2023_Landesliga_57_kg_free_0	2
39	3	42	12	0	2023_(S)_Bezirksliga_46_kg_greco_0	2
37	3	40	13	0	2023_(S)_Bezirksliga_51_kg_free_0	2
49	3	52	12	1	2023_(S)_Bezirksliga_46_kg_free_1	2
47	3	50	13	1	2023_(S)_Bezirksliga_51_kg_greco_1	2
52	4	55	1	0	2023_(S)_Finalrunde_33_kg_greco_0	2
54	4	57	2	0	2023_(S)_Finalrunde_37_kg_free_0	2
56	4	59	3	0	2023_(S)_Finalrunde_41_kg_greco_0	2
58	4	61	4	0	2023_(S)_Finalrunde_46_kg_free_0	2
59	4	62	5	0	2023_(S)_Finalrunde_51_kg_greco_0	2
57	4	60	6	0	2023_(S)_Finalrunde_58_kg_free_0	2
55	4	58	7	0	2023_(S)_Finalrunde_62_kg_greco_0	2
53	4	56	8	0	2023_(S)_Finalrunde_67_kg_free_0	2
51	4	54	9	0	2023_(S)_Finalrunde_80_kg_greco_0	2
62	4	65	1	1	2023_(S)_Finalrunde_33_kg_free_1	2
64	4	67	2	1	2023_(S)_Finalrunde_37_kg_greco_1	2
66	4	69	3	1	2023_(S)_Finalrunde_41_kg_free_1	2
68	4	71	4	1	2023_(S)_Finalrunde_46_kg_greco_1	2
69	4	72	5	1	2023_(S)_Finalrunde_51_kg_free_1	2
67	4	70	6	1	2023_(S)_Finalrunde_58_kg_greco_1	2
65	4	68	7	1	2023_(S)_Finalrunde_62_kg_free_1	2
63	4	66	8	1	2023_(S)_Finalrunde_67_kg_greco_1	2
61	4	64	9	1	2023_(S)_Finalrunde_80_kg_free_1	2
72	5	75	1	0	2023_Bayernliga_61_kg_greco_0	2
74	5	77	2	0	2023_Bayernliga_66_kg_free_0	2
76	5	79	3	0	2023_Bayernliga_71_kg_greco_0	2
78	5	81	4	0	2023_Bayernliga_75_kg_A_free_0	2
79	5	82	5	0	2023_Bayernliga_75_kg_B_greco_0	2
77	5	80	6	0	2023_Bayernliga_80_kg_free_0	2
75	5	78	7	0	2023_Bayernliga_86_kg_greco_0	2
73	5	76	8	0	2023_Bayernliga_98_kg_free_0	2
71	5	74	9	0	2023_Bayernliga_130_kg_greco_0	2
82	5	85	1	1	2023_Bayernliga_61_kg_free_1	2
84	5	87	2	1	2023_Bayernliga_66_kg_greco_1	2
86	5	89	3	1	2023_Bayernliga_71_kg_free_1	2
88	5	91	4	1	2023_Bayernliga_75_kg_A_greco_1	2
89	5	92	5	1	2023_Bayernliga_75_kg_B_free_1	2
87	5	90	6	1	2023_Bayernliga_80_kg_greco_1	2
85	5	88	7	1	2023_Bayernliga_86_kg_free_1	2
83	5	86	8	1	2023_Bayernliga_98_kg_greco_1	2
81	5	84	9	1	2023_Bayernliga_130_kg_free_1	2
92	6	95	1	0	2023_Gruppenoberliga_61_kg_greco_0	2
94	6	97	2	0	2023_Gruppenoberliga_66_kg_free_0	2
96	6	99	3	0	2023_Gruppenoberliga_75_kg_greco_0	2
98	6	101	4	0	2023_Gruppenoberliga_86_kg_free_0	2
100	6	103	5	0	2023_Gruppenoberliga_98_kg_greco_0	2
102	6	105	6	0	2023_Gruppenoberliga_130_kg_free_0	2
103	6	106	7	0	2023_Gruppenoberliga_57_kg_greco_0	2
101	6	104	8	0	2023_Gruppenoberliga_61_kg_free_0	2
97	6	100	10	0	2023_Gruppenoberliga_75_kg_free_0	2
95	6	98	11	0	2023_Gruppenoberliga_86_kg_greco_0	2
93	6	96	12	0	2023_Gruppenoberliga_98_kg_free_0	2
91	6	94	13	0	2023_Gruppenoberliga_130_kg_greco_0	2
106	6	109	1	1	2023_Gruppenoberliga_61_kg_free_1	2
108	6	111	2	1	2023_Gruppenoberliga_66_kg_greco_1	2
110	6	113	3	1	2023_Gruppenoberliga_75_kg_free_1	2
112	6	115	4	1	2023_Gruppenoberliga_86_kg_greco_1	2
114	6	117	5	1	2023_Gruppenoberliga_98_kg_free_1	2
116	6	119	6	1	2023_Gruppenoberliga_130_kg_greco_1	2
117	6	120	7	1	2023_Gruppenoberliga_57_kg_free_1	2
115	6	118	8	1	2023_Gruppenoberliga_61_kg_greco_1	2
111	6	114	10	1	2023_Gruppenoberliga_75_kg_greco_1	2
109	6	112	11	1	2023_Gruppenoberliga_86_kg_free_1	2
107	6	110	12	1	2023_Gruppenoberliga_98_kg_greco_1	2
105	6	108	13	1	2023_Gruppenoberliga_130_kg_free_1	2
119	7	122	13	0	2023_Landesliga_130_kg_greco_0	2
127	7	130	9	0	2023_Landesliga_66_kg_greco_0	2
132	7	135	0	1	2023_Landesliga_57_kg_greco_1	2
141	7	144	9	1	2023_Landesliga_66_kg_free_1	2
146	8	149	0	0	2023_Oberliga_57_kg_free_0	2
156	8	159	0	1	2023_Oberliga_57_kg_greco_1	2
166	3	169	1	0	2023_(S)_Bezirksliga_33_kg_greco_0	2
167	3	170	2	0	2023_(S)_Bezirksliga_37_kg_free_0	2
168	3	171	3	0	2023_(S)_Bezirksliga_41_kg_greco_0	2
169	3	172	4	0	2023_(S)_Bezirksliga_46_kg_free_0	2
170	3	173	5	0	2023_(S)_Bezirksliga_51_kg_greco_0	2
171	3	174	6	0	2023_(S)_Bezirksliga_62_kg_free_0	2
172	3	175	7	0	2023_(S)_Bezirksliga_80_kg_greco_0	2
173	3	176	8	0	2023_(S)_Bezirksliga_29_kg_greco_0	2
174	3	177	9	0	2023_(S)_Bezirksliga_33_kg_free_0	2
175	3	178	10	0	2023_(S)_Bezirksliga_37_kg_greco_0	2
176	3	179	11	0	2023_(S)_Bezirksliga_41_kg_free_0	2
177	3	180	14	0	2023_(S)_Bezirksliga_62_kg_greco_0	2
178	3	181	15	0	2023_(S)_Bezirksliga_80_kg_free_0	2
179	3	182	1	1	2023_(S)_Bezirksliga_33_kg_free_1	2
180	3	183	2	1	2023_(S)_Bezirksliga_37_kg_greco_1	2
181	3	184	3	1	2023_(S)_Bezirksliga_41_kg_free_1	2
182	3	185	4	1	2023_(S)_Bezirksliga_46_kg_greco_1	2
183	3	186	5	1	2023_(S)_Bezirksliga_51_kg_free_1	2
184	3	187	6	1	2023_(S)_Bezirksliga_62_kg_greco_1	2
185	3	188	7	1	2023_(S)_Bezirksliga_80_kg_free_1	2
186	3	189	8	1	2023_(S)_Bezirksliga_29_kg_free_1	2
187	3	190	9	1	2023_(S)_Bezirksliga_33_kg_greco_1	2
188	3	191	10	1	2023_(S)_Bezirksliga_37_kg_free_1	2
189	3	192	11	1	2023_(S)_Bezirksliga_41_kg_greco_1	2
190	3	193	14	1	2023_(S)_Bezirksliga_62_kg_free_1	2
191	3	194	15	1	2023_(S)_Bezirksliga_80_kg_greco_1	2
120	7	123	1	0	2023_Landesliga_61_kg_greco_0	2
122	7	125	2	0	2023_Landesliga_66_kg_free_0	2
124	7	127	3	0	2023_Landesliga_75_kg_greco_0	2
126	7	129	4	0	2023_Landesliga_86_kg_free_0	2
128	7	131	5	0	2023_Landesliga_98_kg_greco_0	2
130	7	133	6	0	2023_Landesliga_130_kg_free_0	2
131	7	134	7	0	2023_Landesliga_57_kg_greco_0	2
129	7	132	8	0	2023_Landesliga_61_kg_free_0	2
125	7	128	10	0	2023_Landesliga_75_kg_free_0	2
123	7	126	11	0	2023_Landesliga_86_kg_greco_0	2
121	7	124	12	0	2023_Landesliga_98_kg_free_0	2
134	7	137	1	1	2023_Landesliga_61_kg_free_1	2
136	7	139	2	1	2023_Landesliga_66_kg_greco_1	2
138	7	141	3	1	2023_Landesliga_75_kg_free_1	2
140	7	143	4	1	2023_Landesliga_86_kg_greco_1	2
142	7	145	5	1	2023_Landesliga_98_kg_free_1	2
144	7	147	6	1	2023_Landesliga_130_kg_greco_1	2
145	7	148	7	1	2023_Landesliga_57_kg_free_1	2
143	7	146	8	1	2023_Landesliga_61_kg_greco_1	2
139	7	142	10	1	2023_Landesliga_75_kg_greco_1	2
137	7	140	11	1	2023_Landesliga_86_kg_free_1	2
135	7	138	12	1	2023_Landesliga_98_kg_greco_1	2
133	7	136	13	1	2023_Landesliga_130_kg_free_1	2
148	8	151	1	0	2023_Oberliga_61_kg_greco_0	2
150	8	153	2	0	2023_Oberliga_66_kg_free_0	2
152	8	155	3	0	2023_Oberliga_71_kg_greco_0	2
154	8	157	4	0	2023_Oberliga_75_kg_A_free_0	2
155	8	158	5	0	2023_Oberliga_75_kg_B_greco_0	2
153	8	156	6	0	2023_Oberliga_80_kg_free_0	2
151	8	154	7	0	2023_Oberliga_86_kg_greco_0	2
149	8	152	8	0	2023_Oberliga_98_kg_free_0	2
147	8	150	9	0	2023_Oberliga_130_kg_greco_0	2
158	8	161	1	1	2023_Oberliga_61_kg_free_1	2
160	8	163	2	1	2023_Oberliga_66_kg_greco_1	2
162	8	165	3	1	2023_Oberliga_71_kg_free_1	2
164	8	167	4	1	2023_Oberliga_75_kg_A_greco_1	2
165	8	168	5	1	2023_Oberliga_75_kg_B_free_1	2
163	8	166	6	1	2023_Oberliga_80_kg_greco_1	2
161	8	164	7	1	2023_Oberliga_86_kg_free_1	2
159	8	162	8	1	2023_Oberliga_98_kg_greco_1	2
157	8	160	9	1	2023_Oberliga_130_kg_free_1	2
\.


--
-- Data for Name: league; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league (id, name, start_date, end_date, division_id, org_sync_id, organization_id, bout_days) FROM stdin;
4	Grenzlandliga	2023-01-01	2024-01-01	3	2023_(S) Bezirksliga_Grenzlandliga	2	14
5	Mittelfranken	2023-01-01	2024-01-01	3	2023_(S) Bezirksliga_Mittelfranken	2	16
6	Niederbayern/Oberpfalz	2023-01-01	2024-01-01	3	2023_(S) Bezirksliga_Niederbayern/Oberpfalz	2	14
7	Oberbayern/Schwaben Gr. A	2023-01-01	2024-01-01	3	2023_(S) Bezirksliga_Oberbayern/Schwaben Gr. A	2	14
8	Oberbayern/Schwaben Gr. B	2023-01-01	2024-01-01	3	2023_(S) Bezirksliga_Oberbayern/Schwaben Gr. B	2	14
9	Bayern	2023-01-01	2024-01-01	4	2023_(S) Finalrunde_Bayern	2	4
10	Nord	2023-01-01	2024-01-01	5	2023_Bayernliga_Nord	2	18
12	Nord	2023-01-01	2024-01-01	6	2023_Gruppenoberliga_Nord	2	14
13	Süd	2023-01-01	2024-01-01	6	2023_Gruppenoberliga_Süd	2	18
14	Nord	2023-01-01	2024-01-01	7	2023_Landesliga_Nord	2	14
15	Süd	2023-01-01	2024-01-01	7	2023_Landesliga_Süd	2	14
16	Bayern	2023-01-01	2024-01-01	8	2023_Oberliga_Bayern	2	18
11	Süd	2023-01-01	2024-01-01	5	2023_Bayernliga_Süd	2	18
\.


--
-- Data for Name: league_team_participation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league_team_participation (id, league_id, team_id) FROM stdin;
6	11	19
7	11	14
8	11	10
\.


--
-- Data for Name: league_weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league_weight_class (id, league_id, weight_class_id, pos, season_partition, org_sync_id, organization_id) FROM stdin;
1	4	195	0	0	2023_(S)_Bezirksliga_Grenzlandliga_29_kg_free_0	2
2	4	196	0	1	2023_(S)_Bezirksliga_Grenzlandliga_29_kg_greco_1	2
3	4	197	1	0	2023_(S)_Bezirksliga_Grenzlandliga_32_kg_greco_0	2
4	4	198	1	1	2023_(S)_Bezirksliga_Grenzlandliga_32_kg_free_1	2
5	4	199	2	0	2023_(S)_Bezirksliga_Grenzlandliga_35_kg_free_0	2
6	4	200	2	1	2023_(S)_Bezirksliga_Grenzlandliga_35_kg_greco_1	2
7	4	201	3	0	2023_(S)_Bezirksliga_Grenzlandliga_38_kg_greco_0	2
8	4	202	3	1	2023_(S)_Bezirksliga_Grenzlandliga_38_kg_free_1	2
9	4	203	4	0	2023_(S)_Bezirksliga_Grenzlandliga_42_kg_free_0	2
10	4	204	4	1	2023_(S)_Bezirksliga_Grenzlandliga_42_kg_greco_1	2
11	4	205	5	0	2023_(S)_Bezirksliga_Grenzlandliga_46_kg_greco_0	2
12	4	206	5	1	2023_(S)_Bezirksliga_Grenzlandliga_46_kg_free_1	2
13	4	207	6	0	2023_(S)_Bezirksliga_Grenzlandliga_51_kg_free_0	2
14	4	208	6	1	2023_(S)_Bezirksliga_Grenzlandliga_51_kg_greco_1	2
15	4	209	7	0	2023_(S)_Bezirksliga_Grenzlandliga_57_kg_greco_0	2
16	4	210	7	1	2023_(S)_Bezirksliga_Grenzlandliga_57_kg_free_1	2
17	4	211	8	0	2023_(S)_Bezirksliga_Grenzlandliga_67_kg_free_0	2
18	4	212	8	1	2023_(S)_Bezirksliga_Grenzlandliga_67_kg_greco_1	2
19	4	213	9	0	2023_(S)_Bezirksliga_Grenzlandliga_85_kg_greco_0	2
20	4	214	9	1	2023_(S)_Bezirksliga_Grenzlandliga_85_kg_free_1	2
21	5	215	0	0	2023_(S)_Bezirksliga_Mittelfranken_29_kg_free_0	2
22	5	216	0	1	2023_(S)_Bezirksliga_Mittelfranken_29_kg_greco_1	2
23	5	217	1	0	2023_(S)_Bezirksliga_Mittelfranken_33_kg_greco_0	2
24	5	218	1	1	2023_(S)_Bezirksliga_Mittelfranken_33_kg_free_1	2
25	5	219	2	0	2023_(S)_Bezirksliga_Mittelfranken_36_kg_free_0	2
26	5	220	2	1	2023_(S)_Bezirksliga_Mittelfranken_36_kg_greco_1	2
27	5	221	3	0	2023_(S)_Bezirksliga_Mittelfranken_41_kg_greco_0	2
28	5	222	3	1	2023_(S)_Bezirksliga_Mittelfranken_41_kg_free_1	2
29	5	223	4	0	2023_(S)_Bezirksliga_Mittelfranken_46_kg_free_0	2
30	5	224	4	1	2023_(S)_Bezirksliga_Mittelfranken_46_kg_greco_1	2
31	5	225	5	0	2023_(S)_Bezirksliga_Mittelfranken_50_kg_greco_0	2
32	5	226	5	1	2023_(S)_Bezirksliga_Mittelfranken_50_kg_free_1	2
33	5	227	6	0	2023_(S)_Bezirksliga_Mittelfranken_60_kg_free_0	2
34	5	228	6	1	2023_(S)_Bezirksliga_Mittelfranken_60_kg_greco_1	2
35	5	229	7	0	2023_(S)_Bezirksliga_Mittelfranken_76_kg_greco_0	2
36	5	230	7	1	2023_(S)_Bezirksliga_Mittelfranken_76_kg_free_1	2
37	5	231	8	0	2023_(S)_Bezirksliga_Mittelfranken_29_kg_greco_0	2
38	5	232	8	1	2023_(S)_Bezirksliga_Mittelfranken_29_kg_free_1	2
39	5	233	9	0	2023_(S)_Bezirksliga_Mittelfranken_33_kg_free_0	2
40	5	234	9	1	2023_(S)_Bezirksliga_Mittelfranken_33_kg_greco_1	2
41	5	235	10	0	2023_(S)_Bezirksliga_Mittelfranken_36_kg_greco_0	2
42	5	236	10	1	2023_(S)_Bezirksliga_Mittelfranken_36_kg_free_1	2
43	5	237	11	0	2023_(S)_Bezirksliga_Mittelfranken_41_kg_free_0	2
44	5	238	11	1	2023_(S)_Bezirksliga_Mittelfranken_41_kg_greco_1	2
45	5	239	12	0	2023_(S)_Bezirksliga_Mittelfranken_46_kg_greco_0	2
46	5	240	12	1	2023_(S)_Bezirksliga_Mittelfranken_46_kg_free_1	2
47	5	241	13	0	2023_(S)_Bezirksliga_Mittelfranken_50_kg_free_0	2
48	5	242	13	1	2023_(S)_Bezirksliga_Mittelfranken_50_kg_greco_1	2
49	5	243	14	0	2023_(S)_Bezirksliga_Mittelfranken_60_kg_greco_0	2
50	5	244	14	1	2023_(S)_Bezirksliga_Mittelfranken_60_kg_free_1	2
51	5	245	15	0	2023_(S)_Bezirksliga_Mittelfranken_76_kg_free_0	2
52	5	246	15	1	2023_(S)_Bezirksliga_Mittelfranken_76_kg_greco_1	2
53	6	247	0	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_29_kg_free_0	2
54	6	248	0	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_29_kg_greco_1	2
55	6	249	1	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_31_kg_free_0	2
56	6	250	1	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_31_kg_greco_1	2
57	6	251	2	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_34_kg_free_0	2
58	6	252	2	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_34_kg_greco_1	2
59	6	253	3	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_38_kg_free_0	2
60	6	254	3	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_38_kg_greco_1	2
61	6	255	4	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_42_kg_free_0	2
62	6	256	4	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_42_kg_greco_1	2
63	6	257	5	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_46_kg_free_0	2
64	6	258	5	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_46_kg_greco_1	2
65	6	259	6	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_50_kg_free_0	2
66	6	260	6	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_50_kg_greco_1	2
67	6	261	7	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_55_kg_free_0	2
68	6	262	7	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_55_kg_greco_1	2
69	6	263	8	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_60_kg_free_0	2
70	6	264	8	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_60_kg_greco_1	2
71	6	265	9	0	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_76_kg_free_0	2
72	6	266	9	1	2023_(S)_Bezirksliga_Niederbayern/Oberpfalz_76_kg_greco_1	2
\.


--
-- Data for Name: lineup; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.lineup (id, team_id, leader_id, coach_id) FROM stdin;
5	19	\N	\N
6	14	\N	\N
7	14	\N	\N
8	10	\N	\N
\.


--
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.membership (id, person_id, club_id, no, org_sync_id, organization_id) FROM stdin;
23	26	8	1234	20696-1234	2
24	27	7	4321	10142-4321	2
\.


--
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.migration (semver, min_client_version) FROM stdin;
0.2.0-pre.11	0.0.0
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.organization (id, name, abbreviation, parent_id, api_provider, report_provider) FROM stdin;
2	BaRiVe	BRV	\N	deByRingenApi	\N
\.


--
-- Data for Name: participant_state; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.participant_state (id, participation_id, classification_points) FROM stdin;
79	32	0
80	33	1
\.


--
-- Data for Name: participation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.participation (id, membership_id, lineup_id, weight_class_id, weight) FROM stdin;
32	23	5	85	\N
33	24	6	85	\N
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.person (id, prename, surname, birth_date, gender, nationality, org_sync_id, organization_id) FROM stdin;
24	Mustafa	Durak	\N	\N	\N	Mustafa_Durak_null	2
25	Fröhlich	Peter	\N	\N	\N	Fröhlich_Peter_null	2
26	Max	Muster	2000-01-31	male	DEU	Max_Muster_2000-01-31	2
27	Tobias	Müller	2000-03-02	male	DEU	Tobias_Müller_2000-03-02	2
\.


--
-- Data for Name: secured_user; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.secured_user (id, username, password_hash, email, person_id, salt, created_at, privilege) FROM stdin;
2	admin	\\x9b452a2e6bc24ddb4117dfb727f78f5da9ed569201a094a9f3e9d8a1671f891a	\N	\N	36jSKg==	2024-10-23	admin
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team (id, name, description, org_sync_id, organization_id) FROM stdin;
4	WKG Willmering/Cham	\N	WKG Willmering/Cham	2
5	WKG Willmering/Cham II	\N	WKG Willmering/Cham II	2
6	S - WKG Willmering/Cham	\N	S - WKG Willmering/Cham	2
7	TV Geiselhöring	\N	TV Geiselhöring	2
8	S - TV Geiselhöring	\N	S - TV Geiselhöring	2
9	TV Geiselhöring II	\N	TV Geiselhöring II	2
10	TSC Mering	\N	TSC Mering	2
11	S - TSC Mering	\N	S - TSC Mering	2
12	TSC Mering II	\N	TSC Mering II	2
13	S - TSC Mering II	\N	S - TSC Mering II	2
14	TSV Berchtesgaden	\N	TSV Berchtesgaden	2
15	S - TSV Berchtesgaden	\N	S - TSV Berchtesgaden	2
16	TSV Berchtesgaden II	\N	TSV Berchtesgaden II	2
17	SV Untergriesbach II	\N	SV Untergriesbach II	2
18	S - SV Untergriesbach	\N	S - SV Untergriesbach	2
19	SV Untergriesbach	\N	SV Untergriesbach	2
\.


--
-- Data for Name: team_club_affiliation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_club_affiliation (id, team_id, club_id) FROM stdin;
4	4	3
5	5	3
6	6	3
7	4	4
8	5	4
9	6	4
10	7	5
11	8	5
12	9	5
13	10	6
14	11	6
15	12	6
16	13	6
17	14	7
18	15	7
19	16	7
20	17	8
21	18	8
22	19	8
\.


--
-- Data for Name: team_match; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match (id, date, location, visitors_count, comment, no, organization_id, org_sync_id, home_id, guest_id, referee_id, transcript_writer_id, time_keeper_id, mat_chairman_id, league_id, judge_id, season_partition) FROM stdin;
2	2023-10-28	Verbandsschulturnhalle, Passauerstr. 47, 94107 Untergriesbach	295	Verspäteter Beginn aufgrund Vorkämpfe	005029c	2	005029c	5	6	24	\N	\N	\N	11	\N	1
3	2023-10-21	Kongresshaus Berchtesgaden, Maximilianstr. 9, 83471 Berchtesgaden	813	TSV BGD 57kg übergewicht	029013c	2	029013c	7	8	25	\N	\N	\N	11	\N	0
\.


--
-- Data for Name: team_match_bout; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match_bout (id, team_match_id, bout_id, pos, org_sync_id, organization_id) FROM stdin;
50	2	52	0	005029c_61_kg_free	2
\.


--
-- Data for Name: weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.weight_class (id, suffix, weight, style, unit) FROM stdin;
33	\N	29	free	kilogram
40	\N	51	free	kilogram
42	\N	46	greco	kilogram
43	\N	29	greco	kilogram
50	\N	51	greco	kilogram
52	\N	46	free	kilogram
53	\N	29	free	kilogram
54	\N	80	greco	kilogram
55	\N	33	greco	kilogram
56	\N	67	free	kilogram
57	\N	37	free	kilogram
58	\N	62	greco	kilogram
59	\N	41	greco	kilogram
60	\N	58	free	kilogram
61	\N	46	free	kilogram
62	\N	51	greco	kilogram
63	\N	29	greco	kilogram
64	\N	80	free	kilogram
65	\N	33	free	kilogram
66	\N	67	greco	kilogram
67	\N	37	greco	kilogram
68	\N	62	free	kilogram
69	\N	41	free	kilogram
70	\N	58	greco	kilogram
71	\N	46	greco	kilogram
72	\N	51	free	kilogram
73	\N	57	free	kilogram
74	\N	130	greco	kilogram
75	\N	61	greco	kilogram
76	\N	98	free	kilogram
77	\N	66	free	kilogram
78	\N	86	greco	kilogram
79	\N	71	greco	kilogram
80	\N	80	free	kilogram
81	A	75	free	kilogram
82	B	75	greco	kilogram
83	\N	57	greco	kilogram
84	\N	130	free	kilogram
85	\N	61	free	kilogram
86	\N	98	greco	kilogram
87	\N	66	greco	kilogram
88	\N	86	free	kilogram
89	\N	71	free	kilogram
90	\N	80	greco	kilogram
91	A	75	greco	kilogram
92	B	75	free	kilogram
93	\N	57	free	kilogram
94	\N	130	greco	kilogram
95	\N	61	greco	kilogram
96	\N	98	free	kilogram
97	\N	66	free	kilogram
98	\N	86	greco	kilogram
99	\N	75	greco	kilogram
100	\N	75	free	kilogram
101	\N	86	free	kilogram
102	\N	66	greco	kilogram
103	\N	98	greco	kilogram
104	\N	61	free	kilogram
105	\N	130	free	kilogram
106	\N	57	greco	kilogram
107	\N	57	greco	kilogram
108	\N	130	free	kilogram
109	\N	61	free	kilogram
110	\N	98	greco	kilogram
111	\N	66	greco	kilogram
112	\N	86	free	kilogram
113	\N	75	free	kilogram
114	\N	75	greco	kilogram
115	\N	86	greco	kilogram
116	\N	66	free	kilogram
117	\N	98	free	kilogram
118	\N	61	greco	kilogram
119	\N	130	greco	kilogram
120	\N	57	free	kilogram
121	\N	57	free	kilogram
122	\N	130	greco	kilogram
123	\N	61	greco	kilogram
124	\N	98	free	kilogram
125	\N	66	free	kilogram
126	\N	86	greco	kilogram
127	\N	75	greco	kilogram
128	\N	75	free	kilogram
129	\N	86	free	kilogram
130	\N	66	greco	kilogram
131	\N	98	greco	kilogram
132	\N	61	free	kilogram
133	\N	130	free	kilogram
134	\N	57	greco	kilogram
135	\N	57	greco	kilogram
136	\N	130	free	kilogram
137	\N	61	free	kilogram
138	\N	98	greco	kilogram
139	\N	66	greco	kilogram
140	\N	86	free	kilogram
141	\N	75	free	kilogram
142	\N	75	greco	kilogram
143	\N	86	greco	kilogram
144	\N	66	free	kilogram
145	\N	98	free	kilogram
146	\N	61	greco	kilogram
147	\N	130	greco	kilogram
148	\N	57	free	kilogram
149	\N	57	free	kilogram
150	\N	130	greco	kilogram
151	\N	61	greco	kilogram
152	\N	98	free	kilogram
153	\N	66	free	kilogram
154	\N	86	greco	kilogram
155	\N	71	greco	kilogram
156	\N	80	free	kilogram
157	A	75	free	kilogram
158	B	75	greco	kilogram
159	\N	57	greco	kilogram
160	\N	130	free	kilogram
161	\N	61	free	kilogram
162	\N	98	greco	kilogram
163	\N	66	greco	kilogram
164	\N	86	free	kilogram
165	\N	71	free	kilogram
166	\N	80	greco	kilogram
167	A	75	greco	kilogram
168	B	75	free	kilogram
169	\N	33	greco	kilogram
170	\N	37	free	kilogram
171	\N	41	greco	kilogram
172	\N	46	free	kilogram
173	\N	51	greco	kilogram
174	\N	62	free	kilogram
175	\N	80	greco	kilogram
176	\N	29	greco	kilogram
177	\N	33	free	kilogram
178	\N	37	greco	kilogram
179	\N	41	free	kilogram
180	\N	62	greco	kilogram
181	\N	80	free	kilogram
182	\N	33	free	kilogram
183	\N	37	greco	kilogram
184	\N	41	free	kilogram
185	\N	46	greco	kilogram
186	\N	51	free	kilogram
187	\N	62	greco	kilogram
188	\N	80	free	kilogram
189	\N	29	free	kilogram
190	\N	33	greco	kilogram
191	\N	37	free	kilogram
192	\N	41	greco	kilogram
193	\N	62	free	kilogram
194	\N	80	greco	kilogram
195	\N	29	free	kilogram
196	\N	29	greco	kilogram
197	\N	32	greco	kilogram
198	\N	32	free	kilogram
199	\N	35	free	kilogram
200	\N	35	greco	kilogram
201	\N	38	greco	kilogram
202	\N	38	free	kilogram
203	\N	42	free	kilogram
204	\N	42	greco	kilogram
205	\N	46	greco	kilogram
206	\N	46	free	kilogram
207	\N	51	free	kilogram
208	\N	51	greco	kilogram
209	\N	57	greco	kilogram
210	\N	57	free	kilogram
211	\N	67	free	kilogram
212	\N	67	greco	kilogram
213	\N	85	greco	kilogram
214	\N	85	free	kilogram
215	\N	29	free	kilogram
216	\N	29	greco	kilogram
217	\N	33	greco	kilogram
218	\N	33	free	kilogram
219	\N	36	free	kilogram
220	\N	36	greco	kilogram
221	\N	41	greco	kilogram
222	\N	41	free	kilogram
223	\N	46	free	kilogram
224	\N	46	greco	kilogram
225	\N	50	greco	kilogram
226	\N	50	free	kilogram
227	\N	60	free	kilogram
228	\N	60	greco	kilogram
229	\N	76	greco	kilogram
230	\N	76	free	kilogram
231	\N	29	greco	kilogram
232	\N	29	free	kilogram
233	\N	33	free	kilogram
234	\N	33	greco	kilogram
235	\N	36	greco	kilogram
236	\N	36	free	kilogram
237	\N	41	free	kilogram
238	\N	41	greco	kilogram
239	\N	46	greco	kilogram
240	\N	46	free	kilogram
241	\N	50	free	kilogram
242	\N	50	greco	kilogram
243	\N	60	greco	kilogram
244	\N	60	free	kilogram
245	\N	76	free	kilogram
246	\N	76	greco	kilogram
247	\N	29	free	kilogram
248	\N	29	greco	kilogram
249	\N	31	free	kilogram
250	\N	31	greco	kilogram
251	\N	34	free	kilogram
252	\N	34	greco	kilogram
253	\N	38	free	kilogram
254	\N	38	greco	kilogram
255	\N	42	free	kilogram
256	\N	42	greco	kilogram
257	\N	46	free	kilogram
258	\N	46	greco	kilogram
259	\N	50	free	kilogram
260	\N	50	greco	kilogram
261	\N	55	free	kilogram
262	\N	55	greco	kilogram
263	\N	60	free	kilogram
264	\N	60	greco	kilogram
265	\N	76	free	kilogram
266	\N	76	greco	kilogram
\.


--
-- Data for Name: wrestling_event; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.wrestling_event (id, date, location, visitors_count, comment, no, organization_id, org_sync_id) FROM stdin;
\.


--
-- Name: bout_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_action_id_seq', 16, true);


--
-- Name: bout_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_config_id_seq', 7, true);


--
-- Name: bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_id_seq', 52, true);


--
-- Name: bout_result_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_result_rule_id_seq', 72, true);


--
-- Name: club_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.club_id_seq', 8, true);


--
-- Name: competition_bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.competition_bout_id_seq', 1, false);


--
-- Name: competition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.competition_id_seq', 1, true);


--
-- Name: division_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.division_id_seq', 8, true);


--
-- Name: division_weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.division_weight_class_id_seq', 191, true);


--
-- Name: event_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.event_person_id_seq', 1, false);


--
-- Name: league_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_id_seq', 16, true);


--
-- Name: league_team_participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_team_participation_id_seq', 8, true);


--
-- Name: league_weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_weight_class_id_seq', 72, true);


--
-- Name: lineup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.lineup_id_seq', 8, true);


--
-- Name: membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.membership_id_seq', 24, true);


--
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.organization_id_seq', 2, true);


--
-- Name: participant_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.participant_state_id_seq', 80, true);


--
-- Name: participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.participation_id_seq', 33, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.person_id_seq', 27, true);


--
-- Name: team_club_affiliation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_club_affiliation_id_seq', 22, true);


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_id_seq', 19, true);


--
-- Name: team_match_bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_bout_id_seq', 50, true);


--
-- Name: team_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_id_seq', 3, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.user_id_seq', 2, true);


--
-- Name: weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.weight_class_id_seq', 266, true);


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
-- Name: bout_result_rule bout_result_rule_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_result_rule
    ADD CONSTRAINT bout_result_rule_pk PRIMARY KEY (id);


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
-- Name: division division_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division
    ADD CONSTRAINT division_pk PRIMARY KEY (id);


--
-- Name: division_weight_class division_weight_class_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division_weight_class
    ADD CONSTRAINT division_weight_class_pk PRIMARY KEY (id);


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
-- Name: league_team_participation league_team_participation_pk2; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_team_participation
    ADD CONSTRAINT league_team_participation_pk2 UNIQUE (league_id, team_id);


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
-- Name: organization organization_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pk PRIMARY KEY (id);


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
-- Name: participation participation_uk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.participation
    ADD CONSTRAINT participation_uk UNIQUE (membership_id, lineup_id, weight_class_id);


--
-- Name: person person_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pk PRIMARY KEY (id);


--
-- Name: team_club_affiliation team_club_affiliation_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_club_affiliation
    ADD CONSTRAINT team_club_affiliation_pk PRIMARY KEY (id);


--
-- Name: team_club_affiliation team_club_affiliation_pk_2; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_club_affiliation
    ADD CONSTRAINT team_club_affiliation_pk_2 UNIQUE (team_id, club_id);


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
-- Name: secured_user user_pk; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.secured_user
    ADD CONSTRAINT user_pk PRIMARY KEY (id);


--
-- Name: secured_user user_pk_2; Type: CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.secured_user
    ADD CONSTRAINT user_pk_2 UNIQUE (username);


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
-- Name: division_weight_class_id_uindex; Type: INDEX; Schema: public; Owner: wrestling
--

CREATE UNIQUE INDEX division_weight_class_id_uindex ON public.division_weight_class USING btree (id);


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
-- Name: bout bout_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout
    ADD CONSTRAINT bout_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


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
-- Name: bout_result_rule bout_result_rule_bout_config_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout_result_rule
    ADD CONSTRAINT bout_result_rule_bout_config_id_fk FOREIGN KEY (bout_config_id) REFERENCES public.bout_config(id);


--
-- Name: bout bout_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.bout
    ADD CONSTRAINT bout_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


--
-- Name: club club_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.club
    ADD CONSTRAINT club_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


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
-- Name: division division_bout_config_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division
    ADD CONSTRAINT division_bout_config_id_fk FOREIGN KEY (bout_config_id) REFERENCES public.bout_config(id) ON DELETE CASCADE;


--
-- Name: division division_division_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division
    ADD CONSTRAINT division_division_id_fk FOREIGN KEY (parent_id) REFERENCES public.division(id);


--
-- Name: division division_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division
    ADD CONSTRAINT division_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: division_weight_class division_weight_class_division_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division_weight_class
    ADD CONSTRAINT division_weight_class_division_id_fk FOREIGN KEY (division_id) REFERENCES public.division(id) ON DELETE CASCADE;


--
-- Name: division_weight_class division_weight_class_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division_weight_class
    ADD CONSTRAINT division_weight_class_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: division_weight_class division_weight_class_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.division_weight_class
    ADD CONSTRAINT division_weight_class_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


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
-- Name: league league_division_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_division_id_fk FOREIGN KEY (division_id) REFERENCES public.division(id);


--
-- Name: league league_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league
    ADD CONSTRAINT league_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


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
-- Name: league_weight_class league_weight_class_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_weight_class
    ADD CONSTRAINT league_weight_class_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: league_weight_class league_weight_class_weight_class_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.league_weight_class
    ADD CONSTRAINT league_weight_class_weight_class_id_fk FOREIGN KEY (weight_class_id) REFERENCES public.weight_class(id) ON DELETE CASCADE;


--
-- Name: lineup lineup_membership_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup
    ADD CONSTRAINT lineup_membership_id_fk FOREIGN KEY (leader_id) REFERENCES public.membership(id) ON DELETE CASCADE;


--
-- Name: lineup lineup_membership_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup
    ADD CONSTRAINT lineup_membership_id_fk_2 FOREIGN KEY (coach_id) REFERENCES public.membership(id) ON DELETE CASCADE;


--
-- Name: lineup lineup_team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.lineup
    ADD CONSTRAINT lineup_team_id_fk FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- Name: membership membership_club_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_club_id_fk FOREIGN KEY (club_id) REFERENCES public.club(id);


--
-- Name: membership membership_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: membership membership_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.membership
    ADD CONSTRAINT membership_person_id_fk FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: organization organization_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_organization_id_fk FOREIGN KEY (parent_id) REFERENCES public.organization(id);


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
-- Name: person person_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: team_club_affiliation team_club_affiliation_club_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_club_affiliation
    ADD CONSTRAINT team_club_affiliation_club_id_fk FOREIGN KEY (club_id) REFERENCES public.club(id);


--
-- Name: team_club_affiliation team_club_affiliation_team_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_club_affiliation
    ADD CONSTRAINT team_club_affiliation_team_id_fk FOREIGN KEY (team_id) REFERENCES public.team(id);


--
-- Name: team_match_bout team_match_bout_bout_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_bout
    ADD CONSTRAINT team_match_bout_bout_id_fk FOREIGN KEY (bout_id) REFERENCES public.bout(id) ON DELETE CASCADE;


--
-- Name: team_match_bout team_match_bout_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team_match_bout
    ADD CONSTRAINT team_match_bout_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


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
-- Name: team team_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.team
    ADD CONSTRAINT team_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: secured_user user_person_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.secured_user
    ADD CONSTRAINT user_person_id_fk FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE;


--
-- Name: wrestling_event wrestling_event_organization_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: wrestling
--

ALTER TABLE ONLY public.wrestling_event
    ADD CONSTRAINT wrestling_event_organization_id_fk FOREIGN KEY (organization_id) REFERENCES public.organization(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: wrestling
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--


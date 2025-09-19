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
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.migration (semver, min_client_version) FROM stdin;
0.2.0-pre.11	0.0.0
\.


--
-- Data for Name: secured_user; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.secured_user (id, username, password_hash, email, person_id, salt, created_at, privilege) FROM stdin;
1	admin	\\xb2950268d52c1d17f1b35edd35c071be3d320b488c81425c6b144340963e524a		\N	924VOg==	2024-08-25	admin
\.


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


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


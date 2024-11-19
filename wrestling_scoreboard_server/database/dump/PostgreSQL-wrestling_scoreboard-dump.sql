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
28	33	34	20	\N	\N	0	\N	\N
29	35	36	21	\N	\N	0	\N	\N
32	40	41	22	\N	\N	0	\N	\N
34	44	45	23	\N	\N	0	\N	\N
35	46	47	24	\N	\N	0	\N	\N
37	50	51	25	\N	\N	0	\N	\N
38	52	53	26	\N	\N	0	\N	\N
40	56	57	27	\N	\N	0	\N	\N
43	62	\N	28	\N	\N	0	\N	\N
45	65	66	29	\N	\N	0	\N	\N
47	69	70	30	\N	\N	0	\N	\N
49	73	74	31	\N	\N	0	\N	\N
50	75	76	32	\N	\N	0	\N	\N
27	31	32	19	\N	\N	0	\N	\N
\.


--
-- Data for Name: bout_action; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout_action (id, duration_millis, point_count, action_type, bout_role, bout_id) FROM stdin;
\.


--
-- Data for Name: bout_config; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout_config (id, period_duration_secs, break_duration_secs, activity_duration_secs, injury_duration_secs, period_count, bleeding_injury_duration_secs) FROM stdin;
1	180	30	30	30	2	\N
\.


--
-- Data for Name: bout_result_rule; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.bout_result_rule (id, bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points) FROM stdin;
1	1	vfa	\N	\N	\N	4	0
2	1	vin	\N	\N	\N	4	0
3	1	vca	\N	\N	\N	4	0
4	1	vsu	\N	\N	15	4	0
5	1	vpo	\N	\N	8	3	0
6	1	vpo	\N	\N	3	2	0
7	1	vpo	\N	\N	1	1	0
8	1	vfo	\N	\N	\N	4	0
9	1	dsq	\N	\N	\N	4	0
10	1	dsq2	\N	\N	\N	0	0
\.


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.club (id, no, name, organization_id, org_sync_id) FROM stdin;
2	12345	Springfield Wrestlers	1	\N
1	05432	Quahog Hunters	1	\N
\.


--
-- Data for Name: competition; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition (id, date, location, visitors_count, comment, no, organization_id, org_sync_id, name, bout_config_id) FROM stdin;
1	2021-07-17	Quahog	15	\N	\N	1	\N	The Griffin-Simpson Competition	1
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
1	National League	2024-01-01	2025-01-01	1	2	\N	1	\N
2	National League Junior	2024-01-01	2025-01-01	1	2	\N	1	\N
\.


--
-- Data for Name: division_weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.division_weight_class (id, division_id, weight_class_id, pos, season_partition, org_sync_id, organization_id) FROM stdin;
7	2	1	5	\N	\N	\N
1	1	1	1	0	\N	\N
6	1	10	2	0	\N	\N
5	1	2	3	0	\N	\N
2	1	3	5	0	\N	\N
4	1	7	6	0	\N	\N
3	1	4	7	0	\N	\N
9	1	12	8	0	\N	\N
10	1	13	9	0	\N	\N
11	1	14	10	0	\N	\N
13	1	16	12	0	\N	\N
14	1	17	13	0	\N	\N
15	1	18	14	0	\N	\N
16	1	19	1	1	\N	\N
17	1	20	2	1	\N	\N
18	1	21	3	1	\N	\N
19	1	22	4	1	\N	\N
8	1	11	4	0	\N	\N
12	1	15	11	0	\N	\N
20	1	23	5	1	\N	\N
21	1	24	6	1	\N	\N
22	1	25	7	1	\N	\N
23	1	26	8	1	\N	\N
24	1	27	9	1	\N	\N
25	1	28	10	1	\N	\N
26	1	29	11	1	\N	\N
27	1	30	12	1	\N	\N
29	1	32	14	1	\N	\N
28	1	31	13	1	\N	\N
\.


--
-- Data for Name: league; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league (id, name, start_date, end_date, division_id, org_sync_id, organization_id, bout_days) FROM stdin;
2	North Jn	2021-10-01	2022-10-01	2	\N	1	14
1	South	2021-10-01	2022-10-01	1	\N	1	14
3	North	2021-10-01	2022-10-01	1	\N	1	14
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

COPY public.league_weight_class (id, league_id, weight_class_id, pos, season_partition, org_sync_id, organization_id) FROM stdin;
\.


--
-- Data for Name: lineup; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.lineup (id, team_id, leader_id, coach_id) FROM stdin;
3	2	\N	\N
4	3	\N	\N
2	3	14	8
1	1	16	4
\.


--
-- Data for Name: membership; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.membership (id, person_id, club_id, no, org_sync_id, organization_id) FROM stdin;
22	23	2	\N	\N	1
20	21	2	\N	\N	1
18	19	2	\N	\N	1
17	18	2	\N	\N	1
11	12	1	\N	\N	1
13	14	1	\N	\N	1
9	10	1	\N	\N	1
3	3	2	\N	\N	1
2	2	2	\N	\N	1
4	4	2	\N	\N	1
7	7	1	\N	\N	1
5	5	1	1234	\N	1
16	17	2	\N	\N	1
8	8	1	\N	\N	1
21	22	2	\N	\N	1
1	1	2	\N	\N	1
10	11	1	\N	\N	1
12	13	1	\N	\N	1
19	20	2	\N	\N	1
6	6	1	\N	\N	1
15	16	1	\N	\N	1
14	15	1	\N	\N	1
\.


--
-- Data for Name: migration; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.migration (semver, min_client_version) FROM stdin;
0.2.0-pre.8	0.0.0
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.organization (id, name, abbreviation, parent_id, api_provider, report_provider) FROM stdin;
1	United World Wrestling	UWW	\N	\N	\N
\.


--
-- Data for Name: participant_state; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.participant_state (id, participation_id, classification_points) FROM stdin;
26	6	\N
31	13	\N
32	24	\N
33	14	\N
34	23	\N
35	15	\N
36	26	\N
40	10	\N
41	28	\N
44	9	\N
45	25	\N
46	12	\N
47	30	\N
50	11	\N
51	31	\N
52	1	\N
53	5	\N
56	4	\N
57	8	\N
62	16	\N
65	20	\N
66	27	\N
69	22	\N
70	29	\N
73	3	\N
74	7	\N
75	21	\N
76	6	\N
\.


--
-- Data for Name: participation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.participation (id, membership_id, lineup_id, weight_class_id, weight) FROM stdin;
4	4	1	10	110.00
8	8	2	10	129.80
13	21	1	19	40.00
14	4	1	20	110.00
9	2	1	23	66.00
10	19	1	22	98.00
11	20	1	25	75.00
15	1	1	21	61.00
12	22	1	24	86.00
1	1	1	1	50.12
16	18	1	28	61.00
20	19	1	29	97.00
21	17	1	32	75.00
22	2	1	30	66.00
3	3	1	31	77.12
23	8	2	20	130.00
24	13	2	19	56.00
25	15	2	23	66.00
26	10	2	21	61.00
7	5	2	31	80.20
27	12	2	29	98.00
28	12	2	22	98.00
29	7	2	30	66.00
5	13	2	26	55.30
30	5	2	24	86.00
6	9	2	32	70.95
31	9	2	25	75.00
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.person (id, prename, surname, birth_date, gender, nationality, org_sync_id, organization_id) FROM stdin;
18	Ned	Flanders	1964-03-08	male	\N	\N	1
22	Maggie	Simpson	2020-03-07	female	\N	\N	1
15	Adam	West	1967-03-08	male	\N	\N	1
13	Cleveland	Brown	1985-03-08	male	\N	\N	1
23	Nelson	Muntz	\N	male	\N	\N	1
20	Krusty	Clown	1983-03-08	male	\N	\N	1
9	Mr	Referee	\N	other	\N	\N	1
10	Glenn	Quagmire	1982-03-08	male	\N	\N	1
12	Joe	Swanson	1976-03-08	male	\N	\N	1
11	Brian	Griffin	2000-03-07	male	\N	\N	1
21	Moe	Szyslak	1981-03-08	male	\N	\N	1
19	Milhouse	Van Houten	2004-03-07	male	\N	\N	1
17	Mr.	Burns	1925-03-08	male	\N	\N	1
16	Bonnie	Swanson	1991-03-08	female	\N	\N	1
14	Stewie	Griffin	2021-03-07	male	\N	\N	1
5	Chris	Griffin	2005-03-08	male	\N	\N	1
8	Peter	Griffin	1975-03-08	male	\N	\N	1
7	Lois	Griffin	1979-03-08	female	\N	\N	1
4	Homer	Simpson	1975-07-08	male	\N	\N	1
2	Bart	Simpson	2007-07-08	male	\N	\N	1
3	March	Simpson	1980-07-08	female	\N	\N	1
6	Meg	Griffin	2007-03-08	female	\N	\N	1
1	Lisa	Simpson	2010-07-08	female	USA	\N	1
\.


--
-- Data for Name: secured_user; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.secured_user (id, username, password_hash, email, person_id, salt, created_at, privilege) FROM stdin;
1	admin	\\xb2950268d52c1d17f1b35edd35c071be3d320b488c81425c6b144340963e524a		\N	924VOg==	2024-08-25	admin
\.


--
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team (id, name, description, org_sync_id, organization_id) FROM stdin;
3	Quahog Hunters II	2. Team Men	\N	1
2	Springfield Wrestlers Jn	Juniors	\N	1
1	Springfield Wrestlers	1. Team Men	\N	1
\.


--
-- Data for Name: team_club_affiliation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_club_affiliation (id, team_id, club_id) FROM stdin;
1	3	1
2	2	2
3	1	2
\.


--
-- Data for Name: team_match; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match (id, date, location, visitors_count, comment, no, organization_id, org_sync_id, home_id, guest_id, referee_id, transcript_writer_id, time_keeper_id, mat_chairman_id, league_id, judge_id, season_partition) FROM stdin;
1	2021-07-10	Springfield	\N	\N		1	\N	1	2	\N	\N	\N	\N	1	\N	1
\.


--
-- Data for Name: team_match_bout; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match_bout (id, team_match_id, bout_id, pos, org_sync_id, organization_id) FROM stdin;
25	1	27	0	\N	\N
26	1	28	1	\N	\N
27	1	29	2	\N	\N
30	1	32	3	\N	\N
32	1	34	4	\N	\N
33	1	35	5	\N	\N
35	1	37	6	\N	\N
36	1	38	7	\N	\N
38	1	40	8	\N	\N
41	1	43	9	\N	\N
43	1	45	10	\N	\N
45	1	47	11	\N	\N
47	1	49	12	\N	\N
48	1	50	13	\N	\N
\.


--
-- Data for Name: weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.weight_class (id, suffix, weight, style, unit) FROM stdin;
6	B	75	greco	kilogram
8	\N	86	greco	kilogram
9	\N	98	free	kilogram
5	A	75	free	kilogram
1		57	free	kilogram
10		130	free	kilogram
2		61	greco	kilogram
3		66	free	kilogram
7		86	free	kilogram
4		75	greco	kilogram
12		57	greco	kilogram
13		130	greco	kilogram
14		61	free	kilogram
16		66	greco	kilogram
17		86	greco	kilogram
18		75	free	kilogram
19		57	greco	kilogram
20		130	greco	kilogram
21		61	free	kilogram
22		98	free	kilogram
11		98	greco	kilogram
15		98	free	kilogram
23		66	greco	kilogram
24		86	greco	kilogram
25		75	free	kilogram
26		57	free	kilogram
27		130	free	kilogram
28		61	greco	kilogram
29		98	greco	kilogram
30		66	free	kilogram
32		75	greco	kilogram
31		86	free	kilogram
\.


--
-- Data for Name: wrestling_event; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.wrestling_event (id, date, location, visitors_count, comment, no, organization_id, org_sync_id) FROM stdin;
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

SELECT pg_catalog.setval('public.bout_id_seq', 51, true);


--
-- Name: bout_result_rule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.bout_result_rule_id_seq', 10, true);


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

SELECT pg_catalog.setval('public.competition_id_seq', 1, true);


--
-- Name: division_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.division_id_seq', 2, true);


--
-- Name: division_weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.division_weight_class_id_seq', 29, true);


--
-- Name: event_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.event_person_id_seq', 1, false);


--
-- Name: league_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_id_seq', 3, true);


--
-- Name: league_team_participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_team_participation_id_seq', 5, true);


--
-- Name: league_weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.league_weight_class_id_seq', 1, false);


--
-- Name: lineup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.lineup_id_seq', 4, true);


--
-- Name: membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.membership_id_seq', 22, true);


--
-- Name: organization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.organization_id_seq', 1, true);


--
-- Name: participant_state_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.participant_state_id_seq', 78, true);


--
-- Name: participation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.participation_id_seq', 31, true);


--
-- Name: person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.person_id_seq', 23, true);


--
-- Name: team_club_affiliation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_club_affiliation_id_seq', 3, true);


--
-- Name: team_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_id_seq', 3, true);


--
-- Name: team_match_bout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_bout_id_seq', 49, true);


--
-- Name: team_match_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.team_match_id_seq', 1, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.weight_class_id_seq', 32, true);


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


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
10	1	bothDsq	\N	\N	\N	0	0
11	1	bothVfo	\N	\N	\N	0	0
12	1	bothVin	\N	\N	\N	0	0
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.organization (id, name, abbreviation, parent_id, api_provider, report_provider) FROM stdin;
1	United World Wrestling	UWW	\N	\N	\N
\.


--
-- Data for Name: club; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.club (id, no, name, organization_id, org_sync_id) FROM stdin;
2	12345	Springfield Wrestlers	1	\N
1	05432	Quahog Hunters	1	\N
\.


--
-- Data for Name: wrestling_event; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.wrestling_event (id, date, location, visitors_count, comment, no, organization_id, org_sync_id) FROM stdin;
\.


--
-- Data for Name: competition; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition (id, date, location, visitors_count, comment, no, organization_id, org_sync_id, name, bout_config_id) FROM stdin;
1	2021-07-17	Quahog	15	\N	\N	1	\N	The Griffin-Simpson Competition	1
\.


--
-- Data for Name: division; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.division (id, name, start_date, end_date, bout_config_id, season_partitions, parent_id, organization_id, org_sync_id) FROM stdin;
1	National League	2024-01-01	2025-01-01	1	2	\N	1	\N
2	National League Junior	2024-01-01	2025-01-01	1	2	\N	1	\N
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
-- Data for Name: competition_person; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition_person (id, competition_id, person_id, person_role) FROM stdin;
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
-- Data for Name: team; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team (id, name, description, org_sync_id, organization_id) FROM stdin;
3	Quahog Hunters II	2. Team Men	\N	1
2	Springfield Wrestlers Jn	Juniors	\N	1
1	Springfield Wrestlers	1. Team Men	\N	1
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
-- Data for Name: team_club_affiliation; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_club_affiliation (id, team_id, club_id) FROM stdin;
1	3	1
2	2	2
3	1	2
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
-- Data for Name: team_match; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.team_match (id, date, location, visitors_count, comment, no, organization_id, org_sync_id, home_id, guest_id, referee_id, transcript_writer_id, time_keeper_id, mat_chairman_id, league_id, judge_id, season_partition) FROM stdin;
1	2021-07-10	Springfield	\N	\N		1	\N	1	2	\N	\N	\N	\N	1	\N	1
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
-- Data for Name: league_weight_class; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.league_weight_class (id, league_id, weight_class_id, pos, season_partition, org_sync_id, organization_id) FROM stdin;
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
-- Data for Name: competition_bout; Type: TABLE DATA; Schema: public; Owner: wrestling
--

COPY public.competition_bout (id, competition_id, bout_id) FROM stdin;
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

SELECT pg_catalog.setval('public.bout_result_rule_id_seq', 12, true);


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
-- Name: weight_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.weight_class_id_seq', 32, true);


--
-- Name: wrestling_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: wrestling
--

SELECT pg_catalog.setval('public.wrestling_event_id_seq', 1, true);

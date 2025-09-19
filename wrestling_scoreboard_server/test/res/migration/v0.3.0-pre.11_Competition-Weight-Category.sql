COPY public.age_category (id, org_sync_id, organization_id, name, min_age, max_age) FROM stdin;
1	\N	1	A-Juniors (U17)	15	17
2	\N	1	B-Juniors (U14)	13	14
3	\N	1	C-Juniors (U12)	11	12
4	\N	1	D-Juniors (U10)	9	10
5	\N	1	E-Juniors (U8)	6	8
\.

COPY public.competition_system_affiliation (id, competition_id, competition_system, max_contestants, pool_group_count) FROM stdin;
1	1	nordic	6	1
2	1	nordicDoubleElimination	\N	2
\.

COPY public.competition_person (id, competition_id, person_id, person_role) FROM stdin;
1	1	12	steward
2	1	9	referee
3	1	18	transcriptWriter
\.

COPY public.competition_age_category (id, age_category_id, competition_id, pos, skipped_cycles) FROM stdin;
3	3	1	1	{}
1	1	1	3	{}
2	2	1	2	{}
\.

COPY public.weight_class (id, suffix, weight, style, unit) FROM stdin;
35	\N	42	free	kilogram
33	\N	68	free	kilogram
34	\N	75	free	kilogram
\.

COPY public.competition_weight_category (id, org_sync_id, organization_id, weight_class_id, competition_id, paired_round, competition_system, pool_group_count, pos, skipped_cycles, competition_age_category_id) FROM stdin;
3	\N	\N	35	1	\N	\N	1	0	{}	3
1	\N	\N	33	1	\N	\N	1	1	{}	2
2	\N	\N	34	1	\N	\N	1	2	{}	2
\.

COPY public.competition_lineup (id, competition_id, club_id, leader_id, coach_id) FROM stdin;
1	1	2	16	17
2	1	1	14	11
\.


SELECT pg_catalog.setval('public.competition_lineup_id_seq', 2, true);
SELECT pg_catalog.setval('public.competition_system_affiliation_id_seq', 2, true);
SELECT pg_catalog.setval('public.competition_weight_category_id_seq', 3, true);
SELECT pg_catalog.setval('public.event_person_id_seq', 3, true);
SELECT pg_catalog.setval('public.weight_class_id_seq', 35, true);

SELECT pg_catalog.setval('public.age_category_id_seq', 5, true);

SELECT pg_catalog.setval('public.competition_age_category_id_seq', 3, true);

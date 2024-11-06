create table public.bout_result_rule
(
    id                           serial
        constraint bout_result_rule_pk
            primary key,
    bout_config_id               integer     not null
        constraint bout_result_rule_bout_config_id_fk
            references public.bout_config,
    bout_result                  bout_result not null,
    winner_technical_points      smallint,
    loser_technical_points       smallint,
    technical_points_difference  smallint,
    winner_classification_points smallint    not null,
    loser_classification_points  smallint    not null
);

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vfa'::bout_result, null, null, null, 4, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vin'::bout_result, null, null, null, 4, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vca'::bout_result, null, null, null, 4, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vsu'::bout_result, null, null, 15, 4, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vpo'::bout_result, null, null, 8, 3, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vpo'::bout_result, null, null, 3, 2, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vpo'::bout_result, null, null, 1, 1, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'vfo'::bout_result, null, null, null, 4, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'dsq'::bout_result, null, null, null, 4, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'dsq2'::bout_result, null, null, null, 0, 0
FROM bout_config b;

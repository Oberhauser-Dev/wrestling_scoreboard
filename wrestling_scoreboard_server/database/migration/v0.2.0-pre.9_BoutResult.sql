ALTER TYPE public.bout_result ADD VALUE 'bothDsq';
ALTER TYPE public.bout_result ADD VALUE 'bothVfo';
ALTER TYPE public.bout_result ADD VALUE 'bothVin';

UPDATE public.bout SET bout_result = 'bothDsq'::bout_result WHERE bout_result = 'dsq2';
UPDATE public.bout_result_rule SET bout_result = 'bothDsq'::bout_result WHERE bout_result = 'dsq2';

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'bothVfo'::bout_result, null, null, null, 0, 0
FROM bout_config b;

INSERT INTO public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points, technical_points_difference, winner_classification_points, loser_classification_points)
SELECT b.id, 'bothVin'::bout_result, null, null, null, 0, 0
FROM bout_config b;

ALTER TYPE public.bout_result ADD VALUE 'vfw' AFTER 'vfo';
ALTER TYPE public.bout_result ADD VALUE 'bothVfw' AFTER 'bothVfo';

-- Copy from forfeit by default.
-- Only for team matches (division configs), as wrestlers failing the weight can't participate in competitions at all.
insert into public.bout_result_rule (bout_config_id, bout_result, winner_technical_points, loser_technical_points,
                                     technical_points_difference, winner_classification_points,
                                     loser_classification_points, style)
select bout_config_id,
       (case bout_result when 'vfo' then 'vfw' else 'bothVfw' end)::public.bout_result,
       winner_technical_points,
       loser_technical_points,
       technical_points_difference,
       winner_classification_points,
       loser_classification_points,
       style
from public.bout_result_rule
where bout_result in ('vfo', 'bothVfo')
  and bout_config_id in (select bout_config_id from public.division);

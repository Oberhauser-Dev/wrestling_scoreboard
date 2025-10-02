-- Update competition rule to allow a winner on tie by points
update public.bout_result_rule
set technical_points_difference = 0
where bout_result = 'vpo'
  and technical_points_difference = 1
  and loser_technical_points = 1
  and winner_classification_points = 3
  and loser_classification_points = 1;

-- Update team match rule to allow a winner on tie by points
update public.bout_result_rule
set technical_points_difference = 0,
    winner_technical_points = 1
where bout_result = 'vpo'
  and technical_points_difference = 1
  and winner_classification_points = 1
  and loser_classification_points = 0;

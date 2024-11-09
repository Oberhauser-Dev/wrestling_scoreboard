alter table public.lineup
    add constraint lineup_team_id_fk
        foreign key (team_id) references public.team;

-- Delete all duplicate participations in lineup. This only works, because we don't have competitions at this point, which could have multiple participation in one weight class.

WITH duplicates AS (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY lineup_id, weight_class_id ORDER BY id) AS row_num
    FROM participation
)
DELETE FROM participation
WHERE id IN (SELECT id FROM duplicates WHERE row_num > 1);

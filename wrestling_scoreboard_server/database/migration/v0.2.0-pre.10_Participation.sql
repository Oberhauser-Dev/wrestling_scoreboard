WITH duplicates AS (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY lineup_id, membership_id, weight_class_id ORDER BY id) AS row_num
    FROM participation
)
DELETE FROM participation
WHERE id IN (SELECT id FROM duplicates WHERE row_num > 1);

alter table public.participation
    add constraint participation_uk
        unique (membership_id, lineup_id, weight_class_id);

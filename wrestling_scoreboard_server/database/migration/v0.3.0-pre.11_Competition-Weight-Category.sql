-- 1. Add new column to hold the competition_age_category reference
ALTER TABLE competition_weight_category
ADD COLUMN competition_age_category_id INTEGER;

-- 2. Insert missing competition_age_category rows
INSERT INTO competition_age_category (age_category_id, competition_id)
SELECT DISTINCT cwc.age_category_id, cwc.competition_id
FROM competition_weight_category cwc
LEFT JOIN competition_age_category cac
  ON cwc.age_category_id = cac.age_category_id
 AND cwc.competition_id = cac.competition_id
WHERE cwc.competition_age_category_id IS NULL;

-- 3. Update competition_weight_category to reference competition_age_category
UPDATE competition_weight_category cwc
SET competition_age_category_id = cac.id
FROM competition_age_category cac
WHERE cwc.age_category_id = cac.age_category_id
  AND cwc.competition_id = cac.competition_id;

-- 4. Set NOT NULL constraint if needed
ALTER TABLE competition_weight_category
ALTER COLUMN competition_age_category_id SET NOT NULL;

-- 5. Add foreign key constraint
ALTER TABLE competition_weight_category
ADD CONSTRAINT competition_weight_category_competition_age_category_id_fk
FOREIGN KEY (competition_age_category_id)
REFERENCES competition_age_category(id)
ON DELETE CASCADE;

-- 6. Drop old foreign key and column
ALTER TABLE competition_weight_category
DROP CONSTRAINT competition_weight_category_age_category_id_fk;

ALTER TABLE competition_weight_category
DROP COLUMN age_category_id;

-- Drop duplicate participations for the same weight class within a lineup, keeping the earliest one,
-- so the unique constraint below can be added even on databases where the bug already produced duplicates.
delete from public.team_lineup_participation t
    using public.team_lineup_participation t2
    where t.lineup_id = t2.lineup_id
        and t.weight_class_id = t2.weight_class_id
        and t.id > t2.id;

-- Only one membership may occupy a given weight class within the same team lineup.
-- This supersedes the previous (membership_id, lineup_id, weight_class_id) constraint,
-- which still allowed two different memberships to be assigned to the same weight class.
alter table public.team_lineup_participation
    drop constraint team_lineup_participation_pk_2;

alter table public.team_lineup_participation
    add constraint team_lineup_participation_weight_class_uk
        unique (lineup_id, weight_class_id);

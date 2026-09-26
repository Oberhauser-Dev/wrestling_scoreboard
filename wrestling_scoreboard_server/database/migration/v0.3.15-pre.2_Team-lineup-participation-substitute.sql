-- Each weight class can have one regular participant and one substitute.
alter table public.team_lineup_participation
    add is_substitute boolean default false not null;

alter table public.team_lineup_participation
    drop constraint team_lineup_participation_weight_class_uk;

alter table public.team_lineup_participation
    add constraint team_lineup_participation_weight_class_uk
        unique (lineup_id, weight_class_id, is_substitute);

-- Superseded by the weight class constraint above; it would prevent swapping the regular participant and the substitute.
alter table public.team_lineup_participation
    drop constraint if exists participation_uk;

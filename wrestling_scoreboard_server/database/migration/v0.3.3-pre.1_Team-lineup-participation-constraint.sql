alter table public.team_lineup_participation
    add constraint team_lineup_participation_pk_2
        unique (membership_id, lineup_id, weight_class_id);

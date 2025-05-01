alter table public.lineup
    rename constraint lineup_pk to team_lineup_pk;

alter table public.lineup
    rename constraint lineup_team_id_fk to team_lineup_team_id_fk;

alter table public.lineup
    rename constraint lineup_membership_id_fk to team_lineup_membership_id_fk_2;

alter table public.lineup
    rename constraint lineup_membership_id_fk_2 to team_lineup_membership_id_fk;

alter table public.lineup
    rename to team_lineup;


alter table public.participation
    rename constraint participation_pk to team_lineup_participation_pk;

alter table public.participation
    rename constraint participation_membership_id_fk to team_lineup_participation_membership_id_fk;

alter table public.participation
    rename constraint participation_weight_class_id_fk to team_lineup_participation_weight_class_id_fk;

alter table public.participation
    rename to team_lineup_participation;


alter table public.participant_state
    rename constraint participant_state_pk to athlete_bout_state_pk;

alter table public.participant_state
    rename to athlete_bout_state;


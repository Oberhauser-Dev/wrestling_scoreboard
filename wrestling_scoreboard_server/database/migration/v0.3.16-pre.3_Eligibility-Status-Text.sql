-- Free-text eligibility markers of a participant, e.g. J, N6 or ND. NULL means not set yet.
alter table public.team_lineup_participation
    add eligibility_status_text varchar(100);

alter table public.competition_participation
    add eligibility_status_text varchar(100);

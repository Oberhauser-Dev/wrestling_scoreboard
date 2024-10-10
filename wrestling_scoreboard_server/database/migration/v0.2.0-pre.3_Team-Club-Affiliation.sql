create table public.team_club_affiliation
(
    id      serial
        constraint team_club_affiliation_pk
            primary key,
    team_id integer not null
        constraint team_club_affiliation_team_id_fk
            references public.team,
    club_id integer not null
        constraint team_club_affiliation_club_id_fk
            references public.club,
    constraint team_club_affiliation_pk_2
        unique (team_id, club_id)
);

INSERT INTO team_club_affiliation (team_id, club_id) SELECT id AS team_id, club_id FROM team;

ALTER TABLE team DROP COLUMN club_id;

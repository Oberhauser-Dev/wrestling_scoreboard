alter table public.lineup
    drop constraint lineup_person_id_fk;

alter table public.lineup
    add constraint lineup_membership_id_fk
        foreign key (leader_id) references public.membership (id)
            on delete cascade;

alter table public.lineup
    drop constraint lineup_person_id_fk_2;

alter table public.lineup
    add constraint lineup_membership_id_fk_2
        foreign key (coach_id) references public.membership (id)
            on delete cascade;

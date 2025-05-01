alter table public.athlete_bout_state
add column membership_id integer,
add constraint athlete_bout_state_membership_id_fk
foreign key (membership_id)
references public.membership (id)
on delete cascade;

update public.athlete_bout_state abs
set membership_id = tlp.membership_id
from public.team_lineup_participation tlp
where abs.participation_id = tlp.id;

alter table public.athlete_bout_state
alter column membership_id set not null;

alter table public.athlete_bout_state
drop column participation_id;

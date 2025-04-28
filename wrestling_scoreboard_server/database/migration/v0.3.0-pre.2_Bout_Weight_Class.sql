alter table public.team_match_bout
add column weight_class_id integer
    references public.weight_class
    on delete cascade;

update public.team_match_bout tmb
set weight_class_id = b.weight_class_id
from public.bout b
where tmb.bout_id = b.id;

alter table public.team_match_bout
alter column weight_class_id set not null;

alter table public.bout
drop column weight_class_id;
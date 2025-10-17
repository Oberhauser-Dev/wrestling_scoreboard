-- Null values are considered distinct, so multiple entries with null values are possible
alter table public.person add constraint person_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.membership add constraint membership_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.bout add constraint bout_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.club add constraint club_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.age_category add constraint age_category_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.team add constraint team_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.division add constraint division_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.division_weight_class add constraint division_weight_class_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.league add constraint league_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.league_weight_class add constraint league_weight_class_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.team_match_bout add constraint team_match_bout_org_sync_id_pk unique (org_sync_id, organization_id);
alter table public.wrestling_event add constraint wrestling_event_org_sync_id_pk unique (org_sync_id, organization_id);

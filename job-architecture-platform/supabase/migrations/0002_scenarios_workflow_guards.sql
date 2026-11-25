-- EJA production foundation extension: scenarios, reporting lines, workflow guards.
-- Apply after 0001_multi_tenant_foundation.sql in a dedicated test database first.

create table if not exists public.org_scenarios (
 id uuid primary key default gen_random_uuid(),
 tenant_id uuid not null references public.tenants(id) on delete restrict,
 scenario_code text not null,
 scenario_name text not null,
 scenario_type text not null check(scenario_type in ('approved_baseline','draft','what_if','submitted')),
 status text not null default 'draft' check(status in ('draft','in_review','approved','archived')),
 based_on_scenario_id uuid,
 version integer not null default 1 check(version>0),
 effective_from date,
 effective_to date,
 created_by uuid references auth.users(id) on delete set null,
 approved_by uuid references auth.users(id) on delete set null,
 approved_at timestamptz,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(),
 unique(tenant_id,id),
 unique(tenant_id,scenario_code,version),
 foreign key(tenant_id,based_on_scenario_id) references public.org_scenarios(tenant_id,id) on delete restrict
);

alter table public.org_units
 add constraint org_units_scenario_fk
 foreign key(tenant_id,scenario_id) references public.org_scenarios(tenant_id,id) on delete restrict;

alter table public.positions add column if not exists scenario_id uuid;
alter table public.positions
 add constraint positions_scenario_fk
 foreign key(tenant_id,scenario_id) references public.org_scenarios(tenant_id,id) on delete restrict;

create table if not exists public.reporting_relationships (
 id uuid primary key default gen_random_uuid(),
 tenant_id uuid not null references public.tenants(id) on delete restrict,
 scenario_id uuid not null,
 position_id uuid not null,
 manager_position_id uuid not null,
 relationship_type text not null check(relationship_type in ('solid','dotted','functional','matrix')),
 effective_from date,
 effective_to date,
 created_at timestamptz not null default now(),
 unique(tenant_id,id),
 check(position_id <> manager_position_id),
 foreign key(tenant_id,scenario_id) references public.org_scenarios(tenant_id,id) on delete restrict,
 foreign key(tenant_id,position_id) references public.positions(tenant_id,id) on delete restrict,
 foreign key(tenant_id,manager_position_id) references public.positions(tenant_id,id) on delete restrict
);
create index if not exists reporting_relationship_scenario_idx on public.reporting_relationships(tenant_id,scenario_id);

alter table public.org_scenarios enable row level security;
alter table public.reporting_relationships enable row level security;
create policy scenarios_member_read on public.org_scenarios for select using(public.is_tenant_member(tenant_id));
create policy scenarios_editor_insert on public.org_scenarios for insert
 with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']) and created_by=auth.uid());
create policy scenarios_editor_update on public.org_scenarios for update
 using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']))
 with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy reporting_member_read on public.reporting_relationships for select using(public.is_tenant_member(tenant_id));
create policy reporting_editor_insert on public.reporting_relationships for insert
 with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy reporting_editor_update on public.reporting_relationships for update
 using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']))
 with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));

create or replace function public.prevent_self_approval()
returns trigger language plpgsql security definer set search_path=public
as $$
begin
 if new.status='approved' and old.status is distinct from 'approved' then
   if new.requested_by = auth.uid() then
     raise exception 'Separation of duties: requester cannot approve own request';
   end if;
   if not public.has_tenant_role(new.tenant_id,array['tenant_admin','architecture_owner','approver']) then
     raise exception 'Insufficient approval role';
   end if;
   new.reviewed_by := auth.uid();
   new.decided_at := coalesce(new.decided_at,now());
 end if;
 return new;
end;
$$;
drop trigger if exists workflow_prevent_self_approval on public.workflow_requests;
create trigger workflow_prevent_self_approval
 before update on public.workflow_requests
 for each row execute function public.prevent_self_approval();

create or replace function public.prevent_audit_mutation()
returns trigger language plpgsql set search_path=public
as $$
begin
 raise exception 'Audit events are append-only';
end;
$$;
drop trigger if exists audit_events_no_update on public.audit_events;
create trigger audit_events_no_update before update or delete on public.audit_events
 for each row execute function public.prevent_audit_mutation();

create or replace function public.set_updated_at()
returns trigger language plpgsql set search_path=public
as $$
begin
 new.updated_at := now();
 return new;
end;
$$;
do $$
declare t text;
begin
 foreach t in array array['tenants','org_units','job_profiles','positions','org_scenarios'] loop
   execute format('drop trigger if exists %I on public.%I',t||'_set_updated_at',t);
   execute format('create trigger %I before update on public.%I for each row execute function public.set_updated_at()',t||'_set_updated_at',t);
 end loop;
end $$;

-- Note: server-side RPCs must validate that each entity_id belongs to tenant_id before
-- writing workflow/audit events. Do not grant direct client insert on audit_events.
-- Storage bucket policies must use tenant-scoped paths and validate membership server-side.
-- Add tenant provisioning/invitation RPCs and privilege grants only after a security review.

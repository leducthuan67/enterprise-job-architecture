-- Enterprise Job Architecture Platform: secure multi-tenant foundation
-- PostgreSQL / Supabase-compatible. Review and apply only to a dedicated project.
-- No client data or production secrets belong in this migration.
create extension if not exists pgcrypto;
create table if not exists public.tenants (
 id uuid primary key default gen_random_uuid(), name text not null check(length(trim(name)) between 1 and 160),
 slug text not null unique check(slug ~ '^[a-z0-9][a-z0-9-]{1,62}$'),
 status text not null default 'active' check(status in ('active','suspended','archived')),
 default_language text not null default 'en' check(default_language in ('en','vi')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.tenant_memberships (
 tenant_id uuid not null references public.tenants(id) on delete restrict,
 user_id uuid not null references auth.users(id) on delete restrict,
 role text not null check(role in ('tenant_admin','architecture_owner','hr_editor','evaluator','approver','viewer','auditor')),
 status text not null default 'active' check(status in ('invited','active','suspended','removed')),
 invited_by uuid references auth.users(id) on delete set null, created_at timestamptz not null default now(),
 primary key(tenant_id,user_id)
);
create index if not exists tenant_memberships_user_idx on public.tenant_memberships(user_id,status);
create table if not exists public.org_units (
 id uuid primary key default gen_random_uuid(), tenant_id uuid not null references public.tenants(id) on delete restrict,
 parent_id uuid, unit_code text not null, unit_name text not null,
 unit_type text not null check(unit_type in ('group','head_office','center','business_unit','division','department','function','team','other')),
 reporting_line_type text not null default 'solid' check(reporting_line_type in ('solid','dotted','functional','matrix')),
 status text not null default 'active' check(status in ('active','inactive','proposed')),
 scenario_id uuid, created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
 unique(tenant_id,id), unique(tenant_id,unit_code),
 foreign key(tenant_id,parent_id) references public.org_units(tenant_id,id) on delete restrict
);
create table if not exists public.job_profiles (
 id uuid primary key default gen_random_uuid(), tenant_id uuid not null references public.tenants(id) on delete restrict,
 profile_code text not null, title text not null, job_family text, sub_family text, career_stream text,
 career_level text, internal_grade text,
 status text not null default 'draft' check(status in ('draft','in_review','approved','retired')),
 version integer not null default 1 check(version>0), effective_from date, effective_to date,
 content jsonb not null default '{}'::jsonb, created_by uuid references auth.users(id) on delete set null,
 updated_by uuid references auth.users(id) on delete set null, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(), unique(tenant_id,id), unique(tenant_id,profile_code,version)
);
create table if not exists public.positions (
 id uuid primary key default gen_random_uuid(), tenant_id uuid not null references public.tenants(id) on delete restrict,
 position_code text not null, title text not null, org_unit_id uuid, job_profile_id uuid,
 position_type text not null default 'PE' check(position_type in ('PE','SLOT','other')),
 status text not null default 'active' check(status in ('active','vacant','proposed','closed')),
 source_record jsonb not null default '{}'::jsonb, created_by uuid references auth.users(id) on delete set null,
 updated_by uuid references auth.users(id) on delete set null, created_at timestamptz not null default now(),
 updated_at timestamptz not null default now(), unique(tenant_id,id), unique(tenant_id,position_code),
 foreign key(tenant_id,org_unit_id) references public.org_units(tenant_id,id) on delete restrict,
 foreign key(tenant_id,job_profile_id) references public.job_profiles(tenant_id,id) on delete set null
);
create index if not exists positions_tenant_org_idx on public.positions(tenant_id,org_unit_id);
-- Authorized IPE outputs are stored as immutable source evidence; no IPE calculation is performed.
create table if not exists public.evaluation_records (
 id uuid primary key default gen_random_uuid(), tenant_id uuid not null references public.tenants(id) on delete restrict,
 position_id uuid not null, evaluation_provider text not null, source_reference text, source_version text,
 evaluated_on date, evaluator_reference text, source_file_name text, source_file_hash text,
 source_values jsonb not null,
 approval_status text not null default 'unverified' check(approval_status in ('unverified','submitted','approved','rejected','superseded')),
 created_by uuid references auth.users(id) on delete set null, created_at timestamptz not null default now(),
 foreign key(tenant_id,position_id) references public.positions(tenant_id,id) on delete restrict
);
create table if not exists public.workflow_requests (
 id uuid primary key default gen_random_uuid(), tenant_id uuid not null references public.tenants(id) on delete restrict,
 entity_type text not null check(entity_type in ('org_unit','job_profile','position','evaluation','mapping','scenario')),
 entity_id uuid not null, action text not null check(action in ('create','update','approve','reject','retire','publish')),
 status text not null default 'pending' check(status in ('pending','approved','rejected','cancelled')),
 requested_by uuid not null references auth.users(id) on delete restrict, assigned_to uuid references auth.users(id) on delete set null,
 reviewed_by uuid references auth.users(id) on delete set null, rationale text not null, before_snapshot jsonb,
 proposed_snapshot jsonb, decision_note text, created_at timestamptz not null default now(), decided_at timestamptz
);
create index if not exists workflow_tenant_status_idx on public.workflow_requests(tenant_id,status,created_at desc);
create table if not exists public.audit_events (
 id bigint generated always as identity primary key, tenant_id uuid not null references public.tenants(id) on delete restrict,
 actor_user_id uuid references auth.users(id) on delete set null, event_type text not null, entity_type text not null,
 entity_id uuid, request_id text, occurred_at timestamptz not null default now(), before_hash text, after_hash text,
 metadata jsonb not null default '{}'::jsonb
);
create index if not exists audit_tenant_time_idx on public.audit_events(tenant_id,occurred_at desc);
create or replace function public.is_tenant_member(target_tenant uuid)
returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.tenant_memberships m where m.tenant_id=target_tenant and m.user_id=auth.uid() and m.status='active');
$$;
create or replace function public.has_tenant_role(target_tenant uuid, allowed_roles text[])
returns boolean language sql stable security definer set search_path=public as $$
 select exists(select 1 from public.tenant_memberships m where m.tenant_id=target_tenant and m.user_id=auth.uid() and m.status='active' and m.role=any(allowed_roles));
$$;
alter table public.tenants enable row level security;
alter table public.tenant_memberships enable row level security;
alter table public.org_units enable row level security;
alter table public.job_profiles enable row level security;
alter table public.positions enable row level security;
alter table public.evaluation_records enable row level security;
alter table public.workflow_requests enable row level security;
alter table public.audit_events enable row level security;
create policy tenant_member_read on public.tenants for select using(public.is_tenant_member(id));
create policy membership_read_self_or_admin on public.tenant_memberships for select using(user_id=auth.uid() or public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','auditor']));
create policy membership_admin_manage on public.tenant_memberships for all using(public.has_tenant_role(tenant_id,array['tenant_admin'])) with check(public.has_tenant_role(tenant_id,array['tenant_admin']));
create policy org_units_member_read on public.org_units for select using(public.is_tenant_member(tenant_id));
create policy org_units_editor_write on public.org_units for insert with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy org_units_editor_update on public.org_units for update using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor'])) with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy job_profiles_member_read on public.job_profiles for select using(public.is_tenant_member(tenant_id));
create policy job_profiles_editor_insert on public.job_profiles for insert with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy job_profiles_editor_update on public.job_profiles for update using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor'])) with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy positions_member_read on public.positions for select using(public.is_tenant_member(tenant_id));
create policy positions_editor_insert on public.positions for insert with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy positions_editor_update on public.positions for update using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor'])) with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor']));
create policy evaluation_member_read on public.evaluation_records for select using(public.is_tenant_member(tenant_id));
create policy evaluation_submit on public.evaluation_records for insert with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','hr_editor','evaluator']));
create policy evaluation_no_client_update on public.evaluation_records for update using(false);
create policy evaluation_no_client_delete on public.evaluation_records for delete using(false);
create policy workflow_member_read on public.workflow_requests for select using(public.is_tenant_member(tenant_id));
create policy workflow_submit on public.workflow_requests for insert with check(public.is_tenant_member(tenant_id) and requested_by=auth.uid());
create policy workflow_review on public.workflow_requests for update using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','approver'])) with check(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','approver']));
create policy audit_member_read on public.audit_events for select using(public.has_tenant_role(tenant_id,array['tenant_admin','architecture_owner','auditor']));
create policy audit_no_client_insert on public.audit_events for insert with check(false);
create policy audit_no_client_update on public.audit_events for update using(false);
create policy audit_no_client_delete on public.audit_events for delete using(false);
-- Before production: revoke broad grants; implement audited SECURITY DEFINER RPCs for tenant provisioning,
-- invitations, workflow decisions and audit writes; validate actor/tenant/role inside every RPC.
-- Add immutable event triggers, tenant-safe entity checks, rate limits, backup/restore and negative RLS tests.

alter table public.organizations add column if not exists created_by uuid references auth.users(id);

drop policy if exists "members read org" on public.organizations;
drop policy if exists "members read memberships" on public.organization_members;

create policy "members read org" on public.organizations for select to authenticated
using (public.is_org_member(id) or created_by=(select auth.uid()));

create policy "owner creates org" on public.organizations for insert to authenticated
with check (created_by=(select auth.uid()));

create policy "owner creates membership" on public.organization_members for insert to authenticated
with check (user_id=(select auth.uid()) and role='owner' and status='active' and exists (
  select 1 from public.organizations o where o.id=organization_id and o.created_by=(select auth.uid())
));

create policy "members read memberships" on public.organization_members for select to authenticated
using (public.is_org_member(organization_id) or user_id=(select auth.uid()));

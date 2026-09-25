create extension if not exists pgcrypto;

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 full_name text,
 phone text,
 avatar_url text,
 created_at timestamptz not null default now()
);
create table if not exists public.organizations (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 legal_name text,
 tax_id text,
 currency text not null default 'UAH',
 timezone text not null default 'Europe/Kyiv',
 created_at timestamptz not null default now()
);
create table if not exists public.organization_members (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null check (role in ('owner','admin','accountant','manager','warehouse','cashier','viewer')),
 status text not null default 'active',
 created_at timestamptz not null default now(),
 unique(organization_id,user_id)
);
create table if not exists public.product_categories (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 name text not null,
 parent_id uuid references public.product_categories(id) on delete set null
);
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 sku text,
 barcode text,
 name text not null,
 description text,
 category_id uuid references public.product_categories(id) on delete set null,
 unit text not null default 'pcs',
 purchase_price numeric(14,2) not null default 0,
 sale_price numeric(14,2) not null default 0,
 tax_rate numeric(5,2) not null default 0,
 track_stock boolean not null default true,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.warehouses (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 name text not null,
 address text,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.inventory_balances (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 warehouse_id uuid not null references public.warehouses(id) on delete cascade,
 product_id uuid not null references public.products(id) on delete cascade,
 quantity numeric(14,3) not null default 0,
 reserved_quantity numeric(14,3) not null default 0,
 average_cost numeric(14,2) not null default 0,
 unique(warehouse_id,product_id)
);
create table if not exists public.inventory_movements (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 warehouse_id uuid not null references public.warehouses(id) on delete cascade,
 product_id uuid not null references public.products(id) on delete cascade,
 type text not null,
 quantity numeric(14,3) not null,
 unit_cost numeric(14,2) not null default 0,
 reference_type text,
 reference_id uuid,
 created_by uuid references auth.users(id),
 created_at timestamptz not null default now()
);
create table if not exists public.customers (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 type text not null default 'individual',
 name text not null,
 phone text,
 email text,
 tax_id text,
 address text,
 notes text,
 created_at timestamptz not null default now()
);
create table if not exists public.suppliers (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 name text not null,
 phone text,
 email text,
 tax_id text,
 address text,
 notes text,
 created_at timestamptz not null default now()
);
create table if not exists public.sales_orders (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 customer_id uuid references public.customers(id) on delete set null,
 number text not null,
 status text not null default 'draft',
 subtotal numeric(14,2) not null default 0,
 discount numeric(14,2) not null default 0,
 tax numeric(14,2) not null default 0,
 total numeric(14,2) not null default 0,
 paid_amount numeric(14,2) not null default 0,
 manager_id uuid references auth.users(id) on delete set null,
 created_at timestamptz not null default now(),
 unique(organization_id,number)
);
create table if not exists public.sales_order_items (
 id uuid primary key default gen_random_uuid(),
 sales_order_id uuid not null references public.sales_orders(id) on delete cascade,
 product_id uuid not null references public.products(id),
 quantity numeric(14,3) not null,
 price numeric(14,2) not null,
 discount numeric(14,2) not null default 0,
 tax numeric(14,2) not null default 0,
 total numeric(14,2) not null default 0
);
create table if not exists public.purchase_orders (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 supplier_id uuid references public.suppliers(id) on delete set null,
 number text not null,
 status text not null default 'draft',
 total numeric(14,2) not null default 0,
 paid_amount numeric(14,2) not null default 0,
 created_at timestamptz not null default now(),
 unique(organization_id,number)
);
create table if not exists public.purchase_order_items (
 id uuid primary key default gen_random_uuid(),
 purchase_order_id uuid not null references public.purchase_orders(id) on delete cascade,
 product_id uuid not null references public.products(id),
 quantity numeric(14,3) not null,
 price numeric(14,2) not null,
 total numeric(14,2) not null default 0
);
create table if not exists public.accounts (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 name text not null,
 type text not null,
 currency text not null default 'UAH',
 balance numeric(14,2) not null default 0
);
create table if not exists public.finance_categories (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 name text not null,
 type text not null,
 parent_id uuid references public.finance_categories(id) on delete set null
);
create table if not exists public.transactions (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 account_id uuid references public.accounts(id) on delete set null,
 type text not null,
 amount numeric(14,2) not null,
 category_id uuid references public.finance_categories(id) on delete set null,
 reference_type text,
 reference_id uuid,
 description text,
 transaction_date date not null default current_date,
 created_by uuid references auth.users(id)
);
create table if not exists public.audit_logs (
 id uuid primary key default gen_random_uuid(),
 organization_id uuid not null references public.organizations(id) on delete cascade,
 user_id uuid references auth.users(id) on delete set null,
 action text not null,
 entity_type text not null,
 entity_id uuid,
 old_data jsonb,
 new_data jsonb,
 created_at timestamptz not null default now()
);

create or replace function public.is_org_member(org_id uuid)
returns boolean language sql stable security invoker
as $$ select exists(
 select 1 from public.organization_members m
 where m.organization_id=org_id
 and m.user_id=(select auth.uid())
 and m.status='active'
) $$;

alter table public.profiles enable row level security;
alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.product_categories enable row level security;
alter table public.products enable row level security;
alter table public.warehouses enable row level security;
alter table public.inventory_balances enable row level security;
alter table public.inventory_movements enable row level security;
alter table public.customers enable row level security;
alter table public.suppliers enable row level security;
alter table public.sales_orders enable row level security;
alter table public.sales_order_items enable row level security;
alter table public.purchase_orders enable row level security;
alter table public.purchase_order_items enable row level security;
alter table public.accounts enable row level security;
alter table public.finance_categories enable row level security;
alter table public.transactions enable row level security;
alter table public.audit_logs enable row level security;

create policy "own profile" on public.profiles for all to authenticated
using (id=(select auth.uid())) with check (id=(select auth.uid()));

create policy "members read org" on public.organizations for select to authenticated
using (public.is_org_member(id));

create policy "members read memberships" on public.organization_members for select to authenticated
using (public.is_org_member(organization_id));

create policy "org scoped products" on public.products for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped categories" on public.product_categories for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped warehouses" on public.warehouses for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped inventory" on public.inventory_balances for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped movements" on public.inventory_movements for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped customers" on public.customers for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped suppliers" on public.suppliers for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped sales" on public.sales_orders for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "sales items via order" on public.sales_order_items for all to authenticated
using (exists(select 1 from public.sales_orders s where s.id=sales_order_id and public.is_org_member(s.organization_id)))
with check (exists(select 1 from public.sales_orders s where s.id=sales_order_id and public.is_org_member(s.organization_id)));

create policy "org scoped purchases" on public.purchase_orders for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "purchase items via order" on public.purchase_order_items for all to authenticated
using (exists(select 1 from public.purchase_orders p where p.id=purchase_order_id and public.is_org_member(p.organization_id)))
with check (exists(select 1 from public.purchase_orders p where p.id=purchase_order_id and public.is_org_member(p.organization_id)));

create policy "org scoped accounts" on public.accounts for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped finance categories" on public.finance_categories for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped transactions" on public.transactions for all to authenticated
using (public.is_org_member(organization_id)) with check (public.is_org_member(organization_id));

create policy "org scoped audit" on public.audit_logs for select to authenticated
using (public.is_org_member(organization_id));
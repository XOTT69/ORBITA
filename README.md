# ORBITA

**Operating system for Ukrainian business.**

ORBITA is a modern SaaS platform for sales, inventory, purchasing, finance, CRM, documents and analytics, designed as a practical migration path away from legacy accounting/ERP workflows.

## MVP

- Organizations and team roles
- Products and categories
- Warehouses and inventory movements
- Customers and suppliers
- Sales orders
- Purchase orders
- Income and expenses
- Dashboard and basic analytics
- CSV/XLSX migration layer
- Audit log

## Product principles

1. Business-first UI, not accounting-first UI.
2. Multi-tenant from day one.
3. Every stock change is traceable through inventory movements.
4. Authorization is enforced server-side with Supabase RLS.
5. Financial and inventory calculations are deterministic; AI explains data but does not invent it.
6. Migration from spreadsheets and legacy systems is a first-class feature.

## Planned stack

- Next.js + TypeScript
- Supabase PostgreSQL/Auth/Storage
- Vercel
- Tailwind CSS + shadcn/ui

## Roadmap

### Phase 1 — Foundation
Auth, organization, memberships, roles, RLS, app shell.

### Phase 2 — Core operations
Products, warehouses, inventory, customers, suppliers, sales and purchases.

### Phase 3 — Finance
Accounts, transactions, income/expenses, dashboard metrics.

### Phase 4 — Migration
CSV/XLSX import/export, validation and import preview.

### Phase 5 — Documents & integrations
PDF documents, Nova Poshta, banking, fiscalization integrations.

### Phase 6 — Intelligence
Business analytics and controlled AI queries over verified business data.

## Status

Early development — architecture and MVP are being built incrementally.

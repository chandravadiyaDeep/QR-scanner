-- Initial schema migration for QR Digital Menu.
-- Apply only to a disposable/development Supabase project first.
-- Source is aligned with DATABASE_SCHEMA.sql; migration is tracked separately for repeatable deploys.

begin;
create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end;
$$;

create table public.shops (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(trim(name)) between 1 and 120),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$' and char_length(slug) between 3 and 70),
  description text, phone text, address text, logo_path text,
  brand_color text not null default '#173B6C' check (brand_color ~ '^#[0-9A-Fa-f]{6}$'),
  default_language text not null default 'en' check (default_language in ('gu','hi','en')),
  enabled_languages text[] not null default array['en']::text[],
  is_published boolean not null default false,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
  check (cardinality(enabled_languages) between 1 and 3),
  check (default_language = any(enabled_languages)),
  check (enabled_languages <@ array['gu','hi','en']::text[])
);

create table public.shop_members (
  shop_id uuid not null references public.shops(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'owner' check (role in ('owner','editor','viewer')),
  created_at timestamptz not null default now(), primary key (shop_id,user_id)
);

create table public.menus (
  id uuid primary key default gen_random_uuid(),
  shop_id uuid not null unique references public.shops(id) on delete cascade,
  default_language text not null default 'en' check (default_language in ('gu','hi','en')),
  theme_key text not null default 'classic' check (theme_key in ('classic','modern','minimal')),
  is_published boolean not null default false, published_at timestamptz,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);

create table public.categories (
  id uuid primary key default gen_random_uuid(), menu_id uuid not null references public.menus(id) on delete cascade,
  sort_order integer not null default 0, is_visible boolean not null default true, archived_at timestamptz,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.category_translations (
  id uuid primary key default gen_random_uuid(), category_id uuid not null references public.categories(id) on delete cascade,
  language_code text not null check (language_code in ('gu','hi','en')),
  name text not null check (char_length(trim(name)) between 1 and 100), description text,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
  unique(category_id,language_code)
);
create table public.menu_items (
  id uuid primary key default gen_random_uuid(), category_id uuid not null references public.categories(id) on delete cascade,
  price numeric(10,2) not null check (price >= 0), currency char(3) not null default 'INR' check (currency = 'INR'),
  image_path text, is_available boolean not null default true, sort_order integer not null default 0,
  archived_at timestamptz, created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.menu_item_translations (
  id uuid primary key default gen_random_uuid(), menu_item_id uuid not null references public.menu_items(id) on delete cascade,
  language_code text not null check (language_code in ('gu','hi','en')),
  name text not null check (char_length(trim(name)) between 1 and 140), description text,
  created_at timestamptz not null default now(), updated_at timestamptz not null default now(),
  unique(menu_item_id,language_code)
);
create table public.menu_view_events (
  id uuid primary key default gen_random_uuid(), shop_id uuid not null references public.shops(id) on delete cascade,
  menu_id uuid not null references public.menus(id) on delete cascade, occurred_at timestamptz not null default now(),
  source text not null default 'qr' check (source in ('qr','direct','share','unknown')),
  dedupe_key_hash text, created_at timestamptz not null default now()
);
create table public.menu_view_daily (
  shop_id uuid not null references public.shops(id) on delete cascade,
  menu_id uuid not null references public.menus(id) on delete cascade,
  view_date date not null, view_count bigint not null default 0 check (view_count >= 0),
  updated_at timestamptz not null default now(), primary key(shop_id,menu_id,view_date)
);

create index idx_shop_members_user on public.shop_members(user_id);
create index idx_categories_menu_order on public.categories(menu_id,sort_order);
create index idx_menu_items_category_order on public.menu_items(category_id,sort_order);
create index idx_view_events_shop_time on public.menu_view_events(shop_id,occurred_at desc);

-- Keep update timestamps consistent across editable records.
do $$ declare table_name text; begin
  foreach table_name in array array['shops','menus','categories','category_translations','menu_items','menu_item_translations','menu_view_daily'] loop
    execute format('create trigger trg_%I_updated_at before update on public.%I for each row execute function public.set_updated_at()', table_name, table_name);
  end loop;
end $$;

-- SECURITY DEFINER helpers are scoped to public and use auth.uid() from Supabase.
create or replace function public.is_shop_member(target_shop_id uuid)
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.shop_members sm where sm.shop_id=target_shop_id and sm.user_id=auth.uid());
$$;
create or replace function public.has_shop_role(target_shop_id uuid, allowed_roles text[])
returns boolean language sql stable security definer set search_path=public as $$
  select exists(select 1 from public.shop_members sm where sm.shop_id=target_shop_id and sm.user_id=auth.uid() and sm.role=any(allowed_roles));
$$;
revoke all on function public.is_shop_member(uuid) from public;
revoke all on function public.has_shop_role(uuid,text[]) from public;
grant execute on function public.is_shop_member(uuid) to authenticated;
grant execute on function public.has_shop_role(uuid,text[]) to authenticated;

alter table public.shops enable row level security;
alter table public.shop_members enable row level security;
alter table public.menus enable row level security;
alter table public.categories enable row level security;
alter table public.category_translations enable row level security;
alter table public.menu_items enable row level security;
alter table public.menu_item_translations enable row level security;
alter table public.menu_view_events enable row level security;
alter table public.menu_view_daily enable row level security;

create policy shops_member_select on public.shops for select to authenticated using(public.is_shop_member(id));
create policy shops_owner_update on public.shops for update to authenticated using(public.has_shop_role(id,array['owner'])) with check(public.has_shop_role(id,array['owner']));
create policy memberships_member_select on public.shop_members for select to authenticated using(public.is_shop_member(shop_id));
create policy menus_member_select on public.menus for select to authenticated using(public.is_shop_member(shop_id));
create policy menus_editor_update on public.menus for update to authenticated using(public.has_shop_role(shop_id,array['owner','editor'])) with check(public.has_shop_role(shop_id,array['owner','editor']));
create policy categories_member_select on public.categories for select to authenticated using(exists(select 1 from public.menus m where m.id=menu_id and public.is_shop_member(m.shop_id)));
create policy categories_editor_all on public.categories for all to authenticated using(exists(select 1 from public.menus m where m.id=menu_id and public.has_shop_role(m.shop_id,array['owner','editor']))) with check(exists(select 1 from public.menus m where m.id=menu_id and public.has_shop_role(m.shop_id,array['owner','editor'])));
create policy category_translations_member_select on public.category_translations for select to authenticated using(exists(select 1 from public.categories c join public.menus m on m.id=c.menu_id where c.id=category_id and public.is_shop_member(m.shop_id)));
create policy category_translations_editor_all on public.category_translations for all to authenticated using(exists(select 1 from public.categories c join public.menus m on m.id=c.menu_id where c.id=category_id and public.has_shop_role(m.shop_id,array['owner','editor']))) with check(exists(select 1 from public.categories c join public.menus m on m.id=c.menu_id where c.id=category_id and public.has_shop_role(m.shop_id,array['owner','editor'])));
create policy items_member_select on public.menu_items for select to authenticated using(exists(select 1 from public.categories c join public.menus m on m.id=c.menu_id where c.id=category_id and public.is_shop_member(m.shop_id)));
create policy items_editor_all on public.menu_items for all to authenticated using(exists(select 1 from public.categories c join public.menus m on m.id=c.menu_id where c.id=category_id and public.has_shop_role(m.shop_id,array['owner','editor']))) with check(exists(select 1 from public.categories c join public.menus m on m.id=c.menu_id where c.id=category_id and public.has_shop_role(m.shop_id,array['owner','editor'])));
create policy item_translations_member_select on public.menu_item_translations for select to authenticated using(exists(select 1 from public.menu_items i join public.categories c on c.id=i.category_id join public.menus m on m.id=c.menu_id where i.id=menu_item_id and public.is_shop_member(m.shop_id)));
create policy item_translations_editor_all on public.menu_item_translations for all to authenticated using(exists(select 1 from public.menu_items i join public.categories c on c.id=i.category_id join public.menus m on m.id=c.menu_id where i.id=menu_item_id and public.has_shop_role(m.shop_id,array['owner','editor']))) with check(exists(select 1 from public.menu_items i join public.categories c on c.id=i.category_id join public.menus m on m.id=c.menu_id where i.id=menu_item_id and public.has_shop_role(m.shop_id,array['owner','editor'])));
create policy analytics_member_select on public.menu_view_daily for select to authenticated using(public.is_shop_member(shop_id));

-- No anon table access. Public menu reads must pass through a sanitized API DTO.
grant select on public.shops,public.shop_members,public.menus,public.categories,public.category_translations,public.menu_items,public.menu_item_translations,public.menu_view_daily to authenticated;
grant update on public.shops,public.menus to authenticated;
grant select,insert,update,delete on public.categories,public.category_translations,public.menu_items,public.menu_item_translations to authenticated;
revoke all on public.menu_view_events from anon,authenticated;
commit;

-- Backend must validate JWT and shop membership on every protected request.
-- Validate all policies and grants in a disposable Supabase project before production use.

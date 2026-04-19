-- Schéma minimal pour `playtest_entries` (mode: partagé + pas d'auth Supabase)
-- À exécuter dans Supabase -> SQL Editor.

create extension if not exists "pgcrypto";

create table if not exists public.playtest_entries (
  id uuid primary key default gen_random_uuid(),
  type text not null,
  severity text not null default 'info',
  content text not null,
  session_id text not null,
  game_name text not null default '',
  session_date date,
  elapsed_time text not null default '00:00:00',
  was_added_during_session boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists playtest_entries_session_id_idx on public.playtest_entries (session_id);
create index if not exists playtest_entries_created_at_idx on public.playtest_entries (created_at desc);

-- Option A (débutant): RLS désactivé (tout le monde avec la clé publishable peut lire/écrire)
-- alter table public.playtest_entries disable row level security;

-- Option B (recommandée si tu veux voir les règles explicitement): RLS activé + policies permissives
alter table public.playtest_entries enable row level security;

drop policy if exists "playtest_entries_select_all" on public.playtest_entries;
create policy "playtest_entries_select_all"
on public.playtest_entries
for select
to anon, authenticated
using (true);

drop policy if exists "playtest_entries_insert_all" on public.playtest_entries;
create policy "playtest_entries_insert_all"
on public.playtest_entries
for insert
to anon, authenticated
with check (true);

drop policy if exists "playtest_entries_update_all" on public.playtest_entries;
create policy "playtest_entries_update_all"
on public.playtest_entries
for update
to anon, authenticated
using (true)
with check (true);

drop policy if exists "playtest_entries_delete_all" on public.playtest_entries;
create policy "playtest_entries_delete_all"
on public.playtest_entries
for delete
to anon, authenticated
using (true);


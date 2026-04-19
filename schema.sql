create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid unique not null references auth.users(id) on delete cascade,
  email text,
  user_code text unique not null,
  prenom text not null,
  age integer,
  poids real,
  taille integer,
  objectif_poids real,
  objectifs text,
  sport text,
  ton_coach text default 'Bienveillant',
  onboarding_done boolean default false,
  created_at timestamptz default now()
);

create table if not exists public.meals (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  description text not null,
  score integer,
  calories integer,
  proteines real,
  graisses real,
  glucides real,
  heure text,
  date date default current_date,
  notes text,
  created_at timestamptz default now()
);

create table if not exists public.sleep (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  duree_min integer,
  qualite text,
  score integer,
  date date default current_date,
  created_at timestamptz default now()
);

create table if not exists public.activity (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  type text,
  duree_min integer,
  calories integer,
  description text,
  date date default current_date,
  created_at timestamptz default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('user', 'assistant')),
  content text not null,
  created_at timestamptz default now()
);

create index if not exists idx_profiles_auth_user_id on public.profiles(auth_user_id);
create index if not exists idx_meals_auth_user_id_date on public.meals(auth_user_id, date desc);
create index if not exists idx_sleep_auth_user_id_date on public.sleep(auth_user_id, date desc);
create index if not exists idx_activity_auth_user_id_date on public.activity(auth_user_id, date desc);
create index if not exists idx_conversations_auth_user_id_created on public.conversations(auth_user_id, created_at asc);

alter table public.profiles enable row level security;
alter table public.meals enable row level security;
alter table public.sleep enable row level security;
alter table public.activity enable row level security;
alter table public.conversations enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_insert_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;
drop policy if exists "profiles_delete_own" on public.profiles;
create policy "profiles_select_own" on public.profiles for select using (auth.uid() = auth_user_id);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = auth_user_id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);
create policy "profiles_delete_own" on public.profiles for delete using (auth.uid() = auth_user_id);

drop policy if exists "meals_select_own" on public.meals;
drop policy if exists "meals_insert_own" on public.meals;
drop policy if exists "meals_update_own" on public.meals;
drop policy if exists "meals_delete_own" on public.meals;
create policy "meals_select_own" on public.meals for select using (auth.uid() = auth_user_id);
create policy "meals_insert_own" on public.meals for insert with check (auth.uid() = auth_user_id);
create policy "meals_update_own" on public.meals for update using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);
create policy "meals_delete_own" on public.meals for delete using (auth.uid() = auth_user_id);

drop policy if exists "sleep_select_own" on public.sleep;
drop policy if exists "sleep_insert_own" on public.sleep;
drop policy if exists "sleep_update_own" on public.sleep;
drop policy if exists "sleep_delete_own" on public.sleep;
create policy "sleep_select_own" on public.sleep for select using (auth.uid() = auth_user_id);
create policy "sleep_insert_own" on public.sleep for insert with check (auth.uid() = auth_user_id);
create policy "sleep_update_own" on public.sleep for update using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);
create policy "sleep_delete_own" on public.sleep for delete using (auth.uid() = auth_user_id);

drop policy if exists "activity_select_own" on public.activity;
drop policy if exists "activity_insert_own" on public.activity;
drop policy if exists "activity_update_own" on public.activity;
drop policy if exists "activity_delete_own" on public.activity;
create policy "activity_select_own" on public.activity for select using (auth.uid() = auth_user_id);
create policy "activity_insert_own" on public.activity for insert with check (auth.uid() = auth_user_id);
create policy "activity_update_own" on public.activity for update using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);
create policy "activity_delete_own" on public.activity for delete using (auth.uid() = auth_user_id);

drop policy if exists "conversations_select_own" on public.conversations;
drop policy if exists "conversations_insert_own" on public.conversations;
drop policy if exists "conversations_update_own" on public.conversations;
drop policy if exists "conversations_delete_own" on public.conversations;
create policy "conversations_select_own" on public.conversations for select using (auth.uid() = auth_user_id);
create policy "conversations_insert_own" on public.conversations for insert with check (auth.uid() = auth_user_id);
create policy "conversations_update_own" on public.conversations for update using (auth.uid() = auth_user_id) with check (auth.uid() = auth_user_id);
create policy "conversations_delete_own" on public.conversations for delete using (auth.uid() = auth_user_id);

-- SARAK MVP reading schema
-- Run manually in the Supabase SQL editor for the project configured in APIConstants.

create table if not exists public.books (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  author text not null,
  status text not null check (status in ('queued', 'reading', 'finished')),
  progress double precision not null default 0 check (progress >= 0 and progress <= 1),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table if not exists public.reading_sessions (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  book_id uuid not null references public.books(id) on delete cascade,
  started_at timestamptz not null,
  ended_at timestamptz,
  duration_minutes integer not null default 0 check (duration_minutes >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table if not exists public.goals (
  id uuid primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  goal_date date not null,
  target_minutes integer not null check (target_minutes > 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, goal_date)
);

create index if not exists books_user_status_idx on public.books(user_id, status) where deleted_at is null;
create index if not exists reading_sessions_user_started_idx on public.reading_sessions(user_id, started_at);
create index if not exists reading_sessions_book_idx on public.reading_sessions(book_id);
create index if not exists goals_user_date_idx on public.goals(user_id, goal_date);

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists books_set_updated_at on public.books;
create trigger books_set_updated_at
before update on public.books
for each row execute function public.set_updated_at();

drop trigger if exists reading_sessions_set_updated_at on public.reading_sessions;
create trigger reading_sessions_set_updated_at
before update on public.reading_sessions
for each row execute function public.set_updated_at();

drop trigger if exists goals_set_updated_at on public.goals;
create trigger goals_set_updated_at
before update on public.goals
for each row execute function public.set_updated_at();

alter table public.books enable row level security;
alter table public.reading_sessions enable row level security;
alter table public.goals enable row level security;

drop policy if exists books_user_select on public.books;
create policy books_user_select on public.books
for select using (auth.uid() = user_id);

drop policy if exists books_user_insert on public.books;
create policy books_user_insert on public.books
for insert with check (auth.uid() = user_id);

drop policy if exists books_user_update on public.books;
create policy books_user_update on public.books
for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists books_user_delete on public.books;
create policy books_user_delete on public.books
for delete using (auth.uid() = user_id);

drop policy if exists reading_sessions_user_select on public.reading_sessions;
create policy reading_sessions_user_select on public.reading_sessions
for select using (auth.uid() = user_id);

drop policy if exists reading_sessions_user_insert on public.reading_sessions;
create policy reading_sessions_user_insert on public.reading_sessions
for insert with check (auth.uid() = user_id);

drop policy if exists reading_sessions_user_update on public.reading_sessions;
create policy reading_sessions_user_update on public.reading_sessions
for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists reading_sessions_user_delete on public.reading_sessions;
create policy reading_sessions_user_delete on public.reading_sessions
for delete using (auth.uid() = user_id);

drop policy if exists goals_user_select on public.goals;
create policy goals_user_select on public.goals
for select using (auth.uid() = user_id);

drop policy if exists goals_user_insert on public.goals;
create policy goals_user_insert on public.goals
for insert with check (auth.uid() = user_id);

drop policy if exists goals_user_update on public.goals;
create policy goals_user_update on public.goals
for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists goals_user_delete on public.goals;
create policy goals_user_delete on public.goals
for delete using (auth.uid() = user_id);

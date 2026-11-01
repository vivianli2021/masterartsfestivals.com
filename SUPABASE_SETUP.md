# Connecting the photo gallery to Supabase

The Photos page and the Admin Login page use Supabase to store photos. Until
this is set up, the Photos page shows "Photos Coming Soon" and the login form
is disabled. Setup takes about 10 minutes.

## 1. Create the project

1. Sign up at <https://supabase.com> and click **New project** (the free plan is fine).
2. Pick a name and a database password, then wait a minute for it to finish.

## 2. Create the photo table and storage

Open **SQL Editor** → **New query**, paste all of this, and click **Run**:

```sql
-- One row per gallery photo
create table public.photos (
  id bigint generated always as identity primary key,
  path text not null,
  caption text,
  taken_on date,
  created_at timestamptz not null default now()
);

alter table public.photos enable row level security;

create policy "Anyone can view photos"
  on public.photos for select using (true);
create policy "Team can add photos"
  on public.photos for insert to authenticated with check (true);
create policy "Team can delete photos"
  on public.photos for delete to authenticated using (true);

-- Public bucket that holds the image files
insert into storage.buckets (id, name, public)
values ('photos', 'photos', true);

create policy "Team can upload photo files"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'photos');
create policy "Team can delete photo files"
  on storage.objects for delete to authenticated
  using (bucket_id = 'photos');
```

## 3. Lock down sign-ups

So that only your team can upload:

1. Go to **Authentication** → **Sign In / Providers** (called **Providers** in some versions).
2. Turn **off** "Allow new users to sign up".

## 4. Add team accounts

Go to **Authentication** → **Users** → **Add user** → **Create new user**.
Enter each uploader's email and a password, and check **Auto Confirm User**.
They use these to sign in on the site's **Admin Login** page.

## 5. Connect the website

1. Go to **Project Settings** → **API** (or **Data API**).
2. Copy the **Project URL** and the **anon public** key.
3. Paste them into `supabase-config.js`:

```js
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOi...';
```

4. Commit the change. The anon key is meant to be public. The rules from step 2
   only let signed-in team members upload or delete photos.

**Never** paste the `service_role` key into the website. It bypasses all of those rules.

## Adding photos

1. Click **Admin Login** at the bottom of any page and sign in.
2. Drag in photos, add an optional caption and date, and click **Upload Photos**.
3. They show up on the Photos page right away. You can delete photos from the same screen.

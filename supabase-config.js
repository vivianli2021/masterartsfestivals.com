// Supabase connection for the photo gallery and Admin Login page.
// Paste these from Supabase: Project Settings -> API. See SUPABASE_SETUP.md.
// The anon key is safe to publish; the database rules decide what it can do.
const SUPABASE_URL = '';
const SUPABASE_ANON_KEY = '';

const PHOTO_BUCKET = 'photos';

const db = (SUPABASE_URL && SUPABASE_ANON_KEY && window.supabase)
  ? window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
  : null;

function photoUrl(path) {
  return db.storage.from(PHOTO_BUCKET).getPublicUrl(path).data.publicUrl;
}

function formatDate(isoDate) {
  if (!isoDate) return '';
  const [y, m, d] = isoDate.split('-').map(Number);
  return new Date(y, m - 1, d).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}

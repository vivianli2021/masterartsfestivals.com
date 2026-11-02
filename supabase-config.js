// Supabase connection for the photo gallery and Admin Login page.
// Paste these from Supabase: Project Settings -> API. See SUPABASE_SETUP.md.
// The anon key is safe to publish; the database rules decide what it can do.
const SUPABASE_URL = 'https://ewspzxkvltshoirtlngf.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3c3B6eGt2bHRzaG9pcnRsbmdmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM1NzM2ODEsImV4cCI6MjEwOTE0OTY4MX0.0pyXr_9bM6DkiHrA_-XC1Dxmg4NP1CT4x_9wP_wV8JI';

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

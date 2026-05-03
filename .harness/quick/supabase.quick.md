# Supabase Quick Guide

- No `import Supabase` in Views/ViewModels.
- Supabase calls stay in approved service/repository layers.
- Use table constants, async/await, and non-blocking error handling.
- Preserve user scoping/RLS expectations.

Open full `.harness/supabase.md` only when modifying auth flows, DTO mappings, or query/write semantics.

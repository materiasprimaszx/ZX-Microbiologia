-- ============================================================
-- ZX · MICROBIOLOGÍA — tabla del monitoreo ambiental
-- Ejecutar en: Supabase > proyecto CalidadZX > SQL Editor > New query
-- ============================================================

create table if not exists public.monitoreo_micro (
  id                 bigint generated always as identity primary key,
  folio              text not null,
  fecha              date not null,
  punto_id           text not null,
  punto              text not null,
  departamento       text,
  zona               smallint,
  micro_id           text not null,
  microorganismo     text not null,
  resultado          text not null,
  unidad             text,
  limite             numeric,
  dictamen           text not null default 'na',   -- conforme | alerta | noconf | na
  metodo             text,
  turno              text,
  analista           text,
  estado_desviacion  text not null default 'na',   -- na | abierta | cerrada
  accion_correctiva  text,
  certificado_url    text,
  certificado_nombre text,
  created_at         timestamptz not null default now()
);

create index if not exists idx_micro_fecha  on public.monitoreo_micro (fecha desc);
create index if not exists idx_micro_punto  on public.monitoreo_micro (punto_id);
create index if not exists idx_micro_dict   on public.monitoreo_micro (dictamen);
create unique index if not exists idx_micro_folio on public.monitoreo_micro (folio);

-- ------------------------------------------------------------
-- Políticas de acceso
-- Mismo esquema que equipos_medicion: la app usa la llave anon
-- sin inicio de sesión, así que se abre el acceso a ese rol.
-- Si más adelante quieren usuarios con contraseña, se reemplaza
-- esto por políticas basadas en auth.uid().
-- ------------------------------------------------------------
alter table public.monitoreo_micro enable row level security;

drop policy if exists "micro_select" on public.monitoreo_micro;
drop policy if exists "micro_insert" on public.monitoreo_micro;
drop policy if exists "micro_update" on public.monitoreo_micro;
drop policy if exists "micro_delete" on public.monitoreo_micro;

create policy "micro_select" on public.monitoreo_micro for select using (true);
create policy "micro_insert" on public.monitoreo_micro for insert with check (true);
create policy "micro_update" on public.monitoreo_micro for update using (true) with check (true);
create policy "micro_delete" on public.monitoreo_micro for delete using (true);

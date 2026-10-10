-- Per-user default screen on app launch (GoRouter path, e.g. /home or /home/room/uuid).

ALTER TABLE public.app_settings
  ADD COLUMN IF NOT EXISTS start_route TEXT NOT NULL DEFAULT '/home';

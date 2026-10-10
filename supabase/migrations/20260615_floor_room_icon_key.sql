-- Icon preset keys for floors and rooms (matches LocationPresets in the app)
ALTER TABLE public.floors ADD COLUMN IF NOT EXISTS icon_key text;
ALTER TABLE public.rooms ADD COLUMN IF NOT EXISTS icon_key text;

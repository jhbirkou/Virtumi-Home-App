-- UDP port of the linked device, copied from devices.port when a parameter device is chosen.

ALTER TABLE public.cp_parameters
  ADD COLUMN IF NOT EXISTS port INTEGER;

ALTER TABLE public.courses_likes 
ADD COLUMN updated_at TIMESTAMPTZ DEFAULT now();
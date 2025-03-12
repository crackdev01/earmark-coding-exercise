CREATE OR REPLACE FUNCTION public.owns_record_as_user(user_id uuid)
RETURNS boolean
LANGUAGE plpgsql
STABLE
SET search_path TO 'pg_catalog', 'public', 'pg_temp'
AS $function$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.users 
        WHERE auth_user_id = auth.uid() 
        AND id = user_id
    );
END;
$function$;
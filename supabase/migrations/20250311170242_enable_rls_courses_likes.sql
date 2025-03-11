-- Enable RLS on the table
alter table "public"."courses_likes" enable row level security;


-- Create the policy
create policy "select_own_liked_courses"
on "public"."courses_likes"
as permissive
for select
TO public
using (owns_record(user_id))

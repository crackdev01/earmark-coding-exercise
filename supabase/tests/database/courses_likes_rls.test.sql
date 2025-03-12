begin;
select plan( 3 );

select policies_are(
  'public',
  'courses_likes',
  ARRAY [
    'select_own_liked_courses'
  ]
);

-- Insert two auth users
INSERT INTO auth.users (id) VALUES ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid);
INSERT INTO auth.users (id) VALUES ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'::uuid);

DELETE FROM public.users;

-- Insert two users with auth_user_id
INSERT INTO public.users (id, auth_user_id, first_name, last_name, created_at, updated_at) VALUES
    ('11111111-1111-1111-1111-111111111111'::uuid, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid, 'User', 'One', now(), now()),
    ('22222222-2222-2222-2222-222222222222'::uuid, 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'::uuid, 'User', 'Two', now(), now());

-- Insert two courses
INSERT INTO public.courses (id, title, active, cost, created_at, updated_at) VALUES
    ('cccccccc-cccc-cccc-cccc-cccccccccccc'::uuid, 'Course A', true, 99.99, now(), now()),
    ('dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid, 'Course B', true, 49.99, now(), now());

-- Insert course likes
INSERT INTO public.courses_likes (user_id, course_id, created_at, updated_at) VALUES
    ('11111111-1111-1111-1111-111111111111'::uuid, 'cccccccc-cccc-cccc-cccc-cccccccccccc'::uuid, now(), now()),
    ('22222222-2222-2222-2222-222222222222'::uuid, 'dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid, now(), now());


-- Test: User 1 can see only their own likes
SET LOCAL request.jwt.claim.sub = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa';
set role authenticated;

select results_eq(
  'SELECT user_id::text, course_id::text FROM public.courses_likes',
  $$ VALUES ('11111111-1111-1111-1111-111111111111', 'cccccccc-cccc-cccc-cccc-cccccccccccc') $$,
  'User 1 should see only their own likes'
);

-- Test: User 2 can see only their own likes
SET LOCAL request.jwt.claim.sub = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';
set role authenticated;
select results_eq(
  'SELECT user_id::text, course_id::text FROM public.courses_likes',
  $$ VALUES ('22222222-2222-2222-2222-222222222222', 'dddddddd-dddd-dddd-dddd-dddddddddddd') $$,
  'User 2 should see only their own likes'
);




select * from finish();
rollback;

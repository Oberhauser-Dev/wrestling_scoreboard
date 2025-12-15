-- Normalize usernames
UPDATE public.secured_user
SET username = LOWER(username)
WHERE username <> LOWER(username);

-- Dedupe users with the same email
WITH ranked_users AS (
    SELECT
        id,
        ROW_NUMBER() OVER (
            PARTITION BY email
            ORDER BY created_at ASC, id ASC
        ) AS rn
    FROM public.secured_user
    WHERE email IS NOT NULL
)
DELETE FROM public.secured_user
WHERE id IN (
    SELECT id
    FROM ranked_users
    WHERE rn > 1
);

ALTER TABLE public.secured_user
ADD CONSTRAINT secured_user_email_unique UNIQUE (email);

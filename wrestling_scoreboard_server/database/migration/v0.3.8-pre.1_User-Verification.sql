alter table public.secured_user
    add is_email_verified bool default false not null;

alter table public.secured_user
    add email_verification_code VARCHAR;

alter table public.secured_user
    add email_verification_code_expiration_date timestamptz;

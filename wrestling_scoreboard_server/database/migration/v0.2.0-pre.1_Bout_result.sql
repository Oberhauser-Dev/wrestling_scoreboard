UPDATE public.bout SET bout_result = 'vsu'::bout_result WHERE bout_result = 'vsu1';
UPDATE public.bout SET bout_result = 'vpo'::bout_result WHERE bout_result = 'vpo1';

-- https://stackoverflow.com/a/47305844/5164462
-- DROP TYPE bout_result;
-- create type bout_result as enum ('vfa', 'vin', 'vca', 'vsu', 'vpo', 'vfo', 'dsq', 'dsq2');
-- alter type bout_result owner to wrestling;

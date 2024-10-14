create table public.bout_result_rule
(
    id                           serial
        constraint bout_result_rule_pk
            primary key,
    bout_config_id               integer     not null
        constraint bout_result_rule_bout_config_id_fk
            references public.bout_config,
    bout_result                  bout_result not null,
    winner_technical_points      smallint,
    loser_technical_points       smallint,
    technical_points_difference  smallint,
    winner_classification_points smallint    not null,
    loser_classification_points  smallint    not null
);

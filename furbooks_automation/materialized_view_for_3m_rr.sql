
create materialized view furlenco_analytics.materialized_tables.furbooks_snapshot_movement_3months as 
SELECT id, recognition_type,  accountable_entity_id, accountable_entity_type, state,
            substring(start_date, 1, 10) as start_date, substring(end_date, 1, 10) as end_date, 
            substring(to_be_recognised_on, 1, 10) as to_be_recognised_on, substring(recognised_at + interval '330 minutes', 1, 10) as recognised_at,
            external_reference_type, external_reference_id,
            monetary_components, substring(created_at + interval '330 minutes', 1, 10) as created_at,
            monetary_components_postTaxAmount, 
            monetary_components_taxableAmount 
FROM furlenco_silver.furbooks_evolve.revenue_recognitions
WHERE state not in ('CANCELLED', 'INVALIDATED')
AND vertical = 'FURLENCO_RENTAL'
AND start_date >= DATE('2025-09-01')
AND start_date < DATE('2025-12-01');

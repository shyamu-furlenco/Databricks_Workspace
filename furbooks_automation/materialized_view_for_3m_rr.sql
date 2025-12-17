create materialized view furlenco_silver.furlenco_analytics.furbooks_snapshot_movement_3m as 
SELECT id, recognition_type,  accountable_entity_id, accountable_entity_type,
            start_date, end_date, to_be_recognised_on, recognised_at, 
            external_reference_type, external_reference_id,
            monetary_components, created_at, updated_at,
            monetary_components_postTaxAmount, 
            monetary_components_taxableAmount 
FROM furlenco_silver.furbooks_evolve.revenue_recognitions
WHERE state not in ('CANCELLED', 'INVALIDATED')
AND vertical = 'FURLENCO_RENTAL'
AND start_date >= DATE('2025-09-01')
AND start_date < DATE('2025-12-01')





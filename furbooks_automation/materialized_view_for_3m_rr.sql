create materialized view furlenco_silver.furlenco_analytics.furbooks_snapshot_movement_3m as 
SELECT * 
FROM furlenco_silver.furbooks_evolve.revenue_recognitions
WHERE state not in ('CANCELLED', 'INVALIDATED')
AND vertical = 'FURLENCO_RENTAL'
AND created_at + interval '330 minutes' >= DATE('2025-10-01')
AND created_at + interval '330 minutes' < DATE('2025-12-01')

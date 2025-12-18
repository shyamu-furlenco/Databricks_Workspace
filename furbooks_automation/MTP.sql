 with mtp_revenue as (
 SELECT accountable_entity_id, accountable_entity_type, start_date, end_date, state,
    to_be_recognised_on, DATE_TRUNC('month', recognised_at) as recognised_at,
    monetary_components_taxableAmount as taxable_amount
 FROM furlenco_silver.furlenco_analytics.furbooks_snapshot_movement_3m
 WHERE external_reference_type = 'RETURN'
)
SELECT substring(recognised_at, 1, 10) as recognised_at, SUM(taxable_amount) as taxable_amount
FROM mtp_revenue
GROUP BY recognised_at
ORDER BY recognised_at desc;
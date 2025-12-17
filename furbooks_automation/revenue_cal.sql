with normal_billing as (
SELECT  DATE_TRUNC('month', start_date) as month_start,
        monetary_components_taxableAmount as taxable_amount
FROM furlenco_silver.furlenco_analytics.furbooks_snapshot_movement_3m
WHERE accountable_entity_type in ('ATTACHMENT','ITEM')
AND external_reference_type  <> 'RETURN'
)
SELECT month_start,
       SUM(taxable_amount) as total_taxable_amount
FROM normal_billing
GROUP BY month_start
ORDER BY month_start desc;
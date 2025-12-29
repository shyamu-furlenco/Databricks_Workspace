with normal_billing as (
SELECT DATE_TRUNC('month', start_date) as month_start,
        monetary_components_taxableAmount as taxable_amount
FROM furlenco_analytics.materialized_tables.furbooks_snapshot_movement_3months
WHERE accountable_entity_type in ('ATTACHMENT','ITEM')
AND external_reference_type  <> 'RETURN'
),
vas_revenue as (
    SELECT DATE_TRUNC('month', start_date) as month_start,
            monetary_components_taxableAmount as taxable_amount
    FROM furlenco_analytics.materialized_tables.furbooks_snapshot_movement_3months
    WHERE accountable_entity_type in ('VALUE_ADDED_SERVICE')
)
SELECT substring(month_start, 1, 10) as month_start,
       SUM(taxable_amount)::float as total_revenue
FROM (
    SELECT month_start, taxable_amount FROM normal_billing
    UNION ALL
    SELECT month_start, taxable_amount FROM vas_revenue
) combined_revenue
GROUP BY month_start
ORDER BY month_start desc;
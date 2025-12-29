
with vas_revenue as (
    SELECT substring(DATE_TRUNC('month', start_date), 1,10) as month_start, state,
            monetary_components_taxableAmount as taxable_amount
    FROM furlenco_silver.furlenco_analytics.furbooks_snapshot_movement_3months
    WHERE accountable_entity_type in ('VALUE_ADDED_SERVICE')
)
SELECT month_start,
       SUM(taxable_amount)::long as total_taxable_amount
FROM vas_revenue
GROUP BY month_start
ORDER BY month_start desc;


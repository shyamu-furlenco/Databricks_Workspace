WITH monthly_aggregates AS (
    SELECT 
        DATE_TRUNC('month', start_date) as month_start,
        SUM(monetary_components_taxableAmount) as normal_revenue
    FROM furlenco_analytics.materialized_tables.furbooks_snapshot_movement_3months
    GROUP BY 1
)
, revenue_bridge AS (
    SELECT 
        month_start,
        normal_revenue as closing_revenue,
        -- This retrieves the closing_revenue of the previous month
        LAG(normal_revenue,1,0) OVER (ORDER BY month_start) as opening_revenue
    FROM monthly_aggregates
)
SELECT 
    substring(month_start::string, 1, 10) as month,
    COALESCE(opening_revenue, 0) as opening_revenue,
    closing_revenue,
    (closing_revenue - COALESCE(opening_revenue, 0)) as net_movement
FROM revenue_bridge
ORDER BY month_start DESC;

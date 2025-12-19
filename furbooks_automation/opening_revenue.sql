WITH monthly_aggregates AS (
    SELECT 
        DATE_TRUNC('month', start_date) as month_start,
        SUM(CASE WHEN accountable_entity_type IN ('ATTACHMENT', 'ITEM') AND external_reference_type <> 'RETURN' 
                 THEN monetary_components_taxableAmount ELSE 0 END) as normal_revenue,
        SUM(CASE WHEN accountable_entity_type = 'VALUE_ADDED_SERVICE' 
                 THEN monetary_components_taxableAmount ELSE 0 END) as vas_revenue
    FROM furlenco_silver.furlenco_analytics.furbooks_snapshot_movement_3m
    GROUP BY 1
),
revenue_bridge AS (
    SELECT 
        month_start,
        (normal_revenue + vas_revenue) as closing_revenue,
        -- This retrieves the closing_revenue of the previous month
        LAG(normal_revenue + vas_revenue) OVER (ORDER BY month_start) as opening_revenue
    FROM monthly_aggregates
)
SELECT 
    substring(month_start::string, 1, 10) as month,
    COALESCE(opening_revenue, 0) as opening_revenue,
    closing_revenue,
    (closing_revenue - COALESCE(opening_revenue, 0)) as net_movement
FROM revenue_bridge
ORDER BY month_start DESC;

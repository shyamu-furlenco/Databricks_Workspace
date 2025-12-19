with base as (
SELECT
  recognition_type AS recognition_type,
  accountable_entity_id AS accountable_entity_id,
  accountable_entity_type AS accountable_entity_type,
  start_date AS start_date,
  end_date AS end_date,
  ROUND((end_date-start_date)/30.45) as tenures,
  state AS state,
  vertical AS vertical,
  external_reference_type AS external_reference_type,
  recognition_frequency AS recognition_frequency,
  monetary_components AS monetary_components,
  created_at AS created_at
FROM
  furbooks_evolve.revenue_recognition_schedules
WHERE state <> 'CANCELLED'
   	AND state <> 'INVALIDATED'
  	AND start_date >= 'May 01, 2024'
    AND accountable_entity_type in ('ITEM')
	-- AND accountable_entity_id = 2155079
)
SELECT *
FROM base 
WHERE accountable_entity_id not in (SELECT accountable_entity_id from base where tenures = 2) 
AND (recognition_type <> 'ACCRUAL' and start_date > current_date)
order by start_date desc

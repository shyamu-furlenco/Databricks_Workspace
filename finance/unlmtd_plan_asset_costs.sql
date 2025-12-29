


SELECT
  p.id AS plan_id,
  p.name as plan_name,
  o.id AS order_id,
  p.display_id AS plan_display_id,
  o.display_id AS order_display_id,
  p.user_id,
  get_json_object(p.user_details,'$.name') as user_name, 
  get_json_object(p.user_details,'$.emailId') as email,
  get_json_object(p.user_details,'$.contactNo') as contact_no,
  sa.city,
  p.state AS plan_state,
  o.state AS order_state,
  p.tenure_in_months,
  p.created_at + interval '330 minutes' AS plan_created_at,
  o.created_at + interval '330 minutes' AS order_created_at,
  p.activation_date,
  o.source AS order_source,
  get_json_object(p.logistics_attributes_snapshot,'$.totalVolumeInCft') as cft,
  get_json_object(o.user_details,'$.displayId') as fur_id,
  get_json_object(o.payment_details,'$.payableAfterPaymentOffers.byCashPreTax') as byCashPreTax_from_order
FROM
  order_management_systems_evolve.plans AS p
  INNER JOIN order_management_systems_evolve.orders AS o ON p.id = o.plan_id
  LEFT JOIN order_management_systems_evolve.Snapshotted_Addresses as sa 
  ON p.snapshotted_delivery_address_id = sa.id
WHERE 1=1 
AND o.payment_details is not null
-- and plan_id = 21750

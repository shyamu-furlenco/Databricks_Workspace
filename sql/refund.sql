%sql
SELECT * 
FROM  `furlenco_silver`.`refunds_evolve`.`refund_transactions` 
WHERE 1=1 
AND (created_at + interval '330 minutes') >= DATE('2025-04-01') 
AND (created_at + interval '330 minutes') < DATE('2025-12-01')
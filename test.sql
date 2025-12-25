USE team_2_db_4420;
/* =========================================================
   HUST Partnership Management System — Test & EOY Analysis
   MySQL (run after you load schema + insert data)
   ========================================================= */

/* -------------------------
   0) Quick schema smoke tests
   ------------------------- */

-- Basic table row counts (helps confirm the DB loaded)
SELECT 'partner' AS table_name, COUNT(*) AS n FROM partner
UNION ALL SELECT 'organization_unit', COUNT(*) FROM organization_unit
UNION ALL SELECT 'affiliation', COUNT(*) FROM affiliation
UNION ALL SELECT 'agreement', COUNT(*) FROM agreement
UNION ALL SELECT 'contact_point', COUNT(*) FROM contact_point
UNION ALL SELECT 'agreement_status_history', COUNT(*) FROM agreement_status_history
UNION ALL SELECT 'collaboration_event', COUNT(*) FROM collaboration_event
UNION ALL SELECT 'contribution', COUNT(*) FROM contribution
UNION ALL SELECT 'invoice', COUNT(*) FROM invoice
UNION ALL SELECT 'payment', COUNT(*) FROM payment
UNION ALL SELECT 'feedback', COUNT(*) FROM feedback;

/* -------------------------
   1) Requirement compliance checks
   (Project spec expects minimum volumes)
   ------------------------- */

-- 1.1 Partners: at least 10, includes both persons and organizations
SELECT
  COUNT(*) AS total_partners,
  SUM(partner_type = 'person') AS person_partners,
  SUM(partner_type = 'organization') AS org_partners
FROM partner;

-- 1.2 Org units: at least 5
SELECT COUNT(*) AS total_units FROM organization_unit;

-- 1.3 Events: at least 10
SELECT COUNT(*) AS total_events FROM collaboration_event;

-- 1.4 Contributions: at least 10
SELECT COUNT(*) AS total_contributions FROM contribution;

-- 1.5 Invoices: at least 10
SELECT COUNT(*) AS total_invoices FROM invoice;

-- 1.6 Payments should exist for invoices (can be 1..many depending on your design)
SELECT
  COUNT(*) AS total_payments,
  COUNT(DISTINCT event_id, invoice_seq) AS invoices_with_payments
FROM payment;

-- 1.7 Feedback: multiple records across events (from organization_unit)
SELECT
  COUNT(*) AS total_feedback,
  COUNT(DISTINCT event_id) AS events_with_feedback,
  COUNT(DISTINCT unit_id) AS unit_with_feedback
FROM feedback;


/* -------------------------
   2) Data-quality / integrity tests
   (These should return 0 rows if clean)
   ------------------------- */

-- 2.1 Duplicate primary keys (should be impossible if PKs exist; still useful if you imported raw data)
SELECT partner_id, COUNT(*) AS cnt
FROM partner
GROUP BY partner_id
HAVING COUNT(*) > 1;

-- 2.2 Invalid enum-like values (partner_type, partner_status)
SELECT partner_id, partner_name, partner_type, partner_status
FROM partner
WHERE partner_type NOT IN ('person','organization')
   OR partner_status NOT IN ('prospect','active','inactive');

-- 2.3 Orphan affiliations (affiliation.partner_id or affiliation.unit_id missing)
SELECT a.*
FROM affiliation a
LEFT JOIN partner p ON a.partner_id = p.partner_id
LEFT JOIN organization_unit o ON a.unit_id = o.unit_id
WHERE p.partner_id IS NULL OR o.unit_id IS NULL;

-- 2.4 Orphan agreements (agreement.partner_id missing)
SELECT ag.*
FROM agreement ag
LEFT JOIN partner p ON ag.partner_id = p.partner_id
WHERE p.partner_id IS NULL;

-- 2.5 Orphan primary collab_partner records (event lacks a valid primary partner)
SELECT cp.*
FROM collab_partner cp
LEFT JOIN collaboration_event e ON cp.event_id = e.event_id
LEFT JOIN partner p ON cp.partner_id = p.partner_id
WHERE cp.is_primary = TRUE
  AND (e.event_id IS NULL OR p.partner_id IS NULL);

-- 2.6 Orphan contributions (contribution.partner_id missing)
SELECT c.*
FROM contribution c
LEFT JOIN partner p ON c.partner_id = p.partner_id
WHERE p.partner_id IS NULL;

-- 2.7 Orphan invoices (invoice.event_id missing)
SELECT i.*
FROM invoice i
LEFT JOIN collaboration_event e ON i.event_id = e.event_id
WHERE e.event_id IS NULL;

-- 2.8 Orphan payments (missing parent invoice)
SELECT pay.*
FROM payment pay
LEFT JOIN invoice i
  ON pay.event_id = i.event_id
 AND pay.invoice_seq = i.invoice_seq
WHERE i.event_id IS NULL;

-- 2.9 Orphan feedback (feedback.event_id missing)
SELECT f.*
FROM feedback f
LEFT JOIN collaboration_event e ON f.event_id = e.event_id
WHERE e.event_id IS NULL;

/* -------------------------
   3) End-of-year (EOY) analysis dashboard
   Notes:
   - Change the year in the WHERE clauses as needed.
   - Assumes DATE/DATETIME columns: 
     event_start_date (or event_start), contribution_date, invoice_issue_date, payment_date, feedback_date.
   ------------------------- */

-- 3.0 Set the analysis year (edit once per year)
SET @analysis_year := 2024;

-- 3.1 Partner portfolio overview
SELECT
  partner_type,
  partner_status,
  COUNT(*) AS n
FROM partner
GROUP BY partner_type, partner_status
ORDER BY partner_type, partner_status;

-- 3.2 Affiliations: partners by unit scope (school/faculty/lab)
SELECT
  o.unit_scope,
  COUNT(DISTINCT a.partner_id) AS distinct_partners,
  COUNT(*) AS total_affiliations
FROM affiliation a
JOIN organization_unit o ON a.unit_id = o.unit_id
GROUP BY o.unit_scope
ORDER BY total_affiliations DESC;

-- 3.3 Events in the analysis year: totals by event type
SELECT
  e.event_type,
  COUNT(*) AS n_events,
  SUM(IFNULL(e.participants_num, 0)) AS total_participants
FROM collaboration_event e
WHERE YEAR(e.event_start_time) = @analysis_year
GROUP BY e.event_type
ORDER BY n_events DESC;

-- 3.4 Top partners by number of events (primary partner)
SELECT
  p.partner_id,
  p.partner_name,
  p.partner_type,
  COUNT(*) AS n_events
FROM collab_partner cp
JOIN collaboration_event e ON cp.event_id = e.event_id
JOIN partner p ON cp.partner_id = p.partner_id
WHERE cp.is_primary = TRUE
  AND YEAR(e.event_start_time) = @analysis_year
GROUP BY p.partner_id, p.partner_name, p.partner_type
ORDER BY n_events DESC, p.partner_name ASC
LIMIT 10;

-- 3.5 Contributions in the analysis year: cash vs in-kind + total value
SELECT
  c.contribution_type,
  COUNT(*) AS n_contributions,
  SUM(IFNULL(c.contribution_estimated_value, 0)) AS total_estimated_value
FROM contribution c
WHERE YEAR(c.contribution_date) = @analysis_year
GROUP BY c.contribution_type
ORDER BY total_estimated_value DESC;

-- 3.6 Top partners by contributed value (estimated)
SELECT
  p.partner_id,
  p.partner_name,
  p.partner_type,
  SUM(IFNULL(c.contribution_estimated_value, 0)) AS total_estimated_value,
  COUNT(*) AS n_contributions
FROM contribution c
JOIN partner p ON c.partner_id = p.partner_id
WHERE YEAR(c.contribution_date) = @analysis_year
GROUP BY p.partner_id, p.partner_name, p.partner_type
ORDER BY total_estimated_value DESC
LIMIT 10;

-- 3.7 Billing: invoice status counts and total amount
SELECT
  i.invoice_status,
  COUNT(*) AS n_invoices,
  SUM(IFNULL(i.invoice_amount, 0)) AS total_amount
FROM invoice i
WHERE YEAR(i.invoice_issue_date) = @analysis_year
GROUP BY i.invoice_status
ORDER BY n_invoices DESC;

-- 3.8 Billing: invoices with outstanding balance (amount - payments)
SELECT
  i.event_id,
  i.invoice_seq,
  i.invoice_amount AS invoice_amount,
  IFNULL(SUM(pmt.payment_amount), 0) AS paid_amount,
  (i.invoice_amount - IFNULL(SUM(pmt.payment_amount), 0)) AS outstanding_amount
FROM invoice i
LEFT JOIN payment pmt
  ON pmt.event_id = i.event_id
 AND pmt.invoice_seq = i.invoice_seq
WHERE YEAR(i.invoice_issue_date) = @analysis_year
GROUP BY i.event_id, i.invoice_seq, i.invoice_amount
HAVING outstanding_amount > 0
ORDER BY outstanding_amount DESC;

-- 3.9 Feedback in the analysis year: overall distribution
SELECT
  f.feedback_rate,
  COUNT(*) AS n
FROM feedback f
WHERE YEAR(f.feedback_date) = @analysis_year
GROUP BY f.feedback_rate
ORDER BY f.feedback_rate;

-- 3.10 Partner “quality score” (avg rating across events in the analysis year)
SELECT
  p.partner_id,
  p.partner_name,
  COUNT(*) AS n_feedback,
  ROUND(AVG(f.feedback_rate), 2) AS avg_rating
FROM feedback f
JOIN collab_partner cp ON f.event_id = cp.event_id AND cp.is_primary = TRUE
JOIN partner p ON cp.partner_id = p.partner_id
WHERE YEAR(f.feedback_date) = @analysis_year
GROUP BY p.partner_id, p.partner_name
HAVING n_feedback >= 1
ORDER BY avg_rating DESC, n_feedback DESC
LIMIT 10;

-- 3.11 EOY summary “one row” dashboard (events, contribution value, invoice total, payments total)
SELECT
  @analysis_year AS analysis_year,
  (SELECT COUNT(*) FROM collaboration_event e WHERE YEAR(e.event_start_time) = @analysis_year) AS n_events,
  (SELECT SUM(IFNULL(c.contribution_estimated_value, 0)) FROM contribution c WHERE YEAR(c.contribution_date) = @analysis_year) AS total_contribution_value,
  (SELECT SUM(IFNULL(i.invoice_amount, 0)) FROM invoice i WHERE YEAR(i.invoice_issue_date) = @analysis_year) AS total_invoiced_amount,
  (SELECT SUM(IFNULL(pmt.payment_amount, 0)) FROM payment pmt WHERE YEAR(pmt.payment_date) = @analysis_year) AS total_paid_amount;

/* ============================================================
   HUST Collaboration Database
   Sample Dataset – FK-safe insertion script
   Assumption: All tables are already created
   ============================================================ */

-- Make the script re-runnable: clear data first with FK checks off
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE payment;
TRUNCATE TABLE invoice;
TRUNCATE TABLE agreement_status_history;
TRUNCATE TABLE feedback;
TRUNCATE TABLE contribution;
TRUNCATE TABLE collab_partner;
TRUNCATE TABLE collaboration_event;
TRUNCATE TABLE affiliation_contact;
TRUNCATE TABLE contact_point;
TRUNCATE TABLE affiliation;
TRUNCATE TABLE agreement;
TRUNCATE TABLE organization;
TRUNCATE TABLE partner;
TRUNCATE TABLE center;
TRUNCATE TABLE faculty;
TRUNCATE TABLE school;
TRUNCATE TABLE university;
TRUNCATE TABLE organization_unit;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 1. Organization_Unit (Strong Entity)
-- ============================================================
INSERT IGNORE INTO  organization_unit (unit_id, unit_name, unit_scope, status, established_date) VALUES
(100000001,'HUST','university','active','1956-03-06'),
(100000002,'School of IT','school','active','2000-01-01'),
(100000003,'Faculty of CS','faculty','active','2001-01-01'),
(100000004,'AI Research Center','center','active','2018-05-01'),
(100000005,'Faculty of EE','faculty','active','1998-09-01');

-- ============================================================
-- 2. University (Subtype of Organization_Unit)
-- ============================================================
INSERT IGNORE INTO  university (university_id, legal_name, country, city, president_name) VALUES
(100000001,'Hanoi University of Science and Technology','Vietnam','Hanoi','Huynh Quyet Thang');

-- ============================================================
-- 3. School (Subtype of Organization_Unit)
-- ============================================================
INSERT IGNORE INTO  school (school_id, academic_focus, dean_name, student_count, faculty_count, university_id) VALUES
(100000002,'Information Technology','Nguyen Van Minh',5000,300,100000001);

-- ============================================================
-- 4. Faculty (Subtype of Organization_Unit)
-- ============================================================
INSERT IGNORE INTO  faculty (faculty_id, faculty_code, head_of_faculty, discipline, tenure_staff_count, research_staff_count, school_id) VALUES
(100000003,'CS01','Tran Duc Anh','Computer Science',80,40,100000002),
(100000005,'EE01','Pham Tuan','Electrical Engineering',70,30,100000002);

-- ============================================================
-- 5. Center (Subtype of Organization_Unit)
-- ============================================================
INSERT IGNORE INTO  center (center_id, center_type, num_fund_received, director_name) VALUES
(100000004,'research',2500000.00,'Le Quang Hung');

-- ============================================================
-- 6. Partner (Supertype: Person + Organization)
-- ============================================================
INSERT IGNORE INTO  partner (partner_id, partner_name, partner_type, partner_status, partner_website, sector, arrangement_frequency) VALUES
(200000001,'Viettel Group','organization','active','https://viettel.com.vn','telecom',12),
(200000002,'FPT Corporation','organization','active','https://fpt.com.vn','technology',10),
(200000003,'VNPT','organization','active','https://vnpt.vn','telecom',8),
(200000004,'Samsung Vietnam','organization','active','https://samsung.com','electronics',6),
(200000005,'Intel Vietnam','organization','prospect','https://intel.com','semiconductor',4),
(200000006,'Nguyen Van Thanh','person','active',NULL,NULL,2),
(200000007,'Tran Thi Loc','person','active',NULL,NULL,1),
(200000008,'Le Quoc Viet','person','inactive',NULL,NULL,0),
(200000009,'Pham Minh Vu','person','active',NULL,NULL,3),
(200000010,'Le Hoang Anh','person','prospect',NULL,NULL,1),
(200000011,'Nguyen Thi Thanh Tu','person','active',NULL,'academia',2),
(200000012,'Huynh Thi Thanh Binh','person','active',NULL,'academia',3),
(200000013,'Pham Van Hai','person','active',NULL,'academia',2),
(200000014,'Nguyen Huy Hoang','person','active',NULL,'academia',1),
(200000015,'Dang Quang Hieu','person','active',NULL,'academia',1);


-- ============================================================
-- 7. Organization (Subtype of Partner)
-- ============================================================
INSERT IGNORE INTO  organization (partner_id, organization_taxcode) VALUES
(200000001,'0100109106'),
(200000002,'0100234001'),
(200000003,'0100111123'),
(200000004,'0100288899'),
(200000005,'0100556677');

-- ============================================================
-- 8. Collaboration_Event
-- ============================================================
INSERT IGNORE INTO  collaboration_event (event_id, event_title, event_type, event_location, event_start_time, event_end_time, participants_num) VALUES
(300000001,'AI Workshop','workshop','Hanoi','2024-03-10','2024-03-12',120),
(300000002,'Industry Talk','seminar','HUST','2024-04-05',NULL,200),
(300000003,'Hackathon','competition','HUST','2024-05-01','2024-05-03',150),
(300000004,'Research Meetup','meeting','Hanoi','2024-06-15',NULL,80),
(300000005,'Tech Expo','exhibition','HCMC','2024-07-20','2024-07-22',500),
(300000006,'Startup Pitch','pitch','HUST','2024-08-01',NULL,60),
(300000007,'AI Training','training','Hanoi','2024-09-10','2024-09-15',40),
(300000008,'IoT Demo','demo','HUST','2024-10-05',NULL,90),
(300000009,'Research Review','review','HUST','2024-11-01',NULL,30),
(300000010,'Annual Summit','conference','Hanoi','2024-12-01','2024-12-03',600);

-- ============================================================
-- 9. Invoice (Weak Entity: depends on Collaboration_Event)
-- ============================================================
INSERT IGNORE INTO  invoice (event_id, invoice_seq, invoice_issue_date, invoice_amount, invoice_status) VALUES
(300000001,1,'2024-03-01',50000,'paid'),
(300000002,1,'2024-04-01',20000,'unpaid'),
(300000003,1,'2024-05-01',30000,'paid'),
(300000004,1,'2024-06-01',15000,'paid'),
(300000005,1,'2024-07-01',80000,'paid'),
(300000006,1,'2024-08-01',10000,'unpaid'),
(300000007,1,'2024-09-01',12000,'paid'),
(300000008,1,'2024-10-01',18000,'paid'),
(300000009,1,'2024-11-01',9000,'paid'),
(300000010,1,'2024-12-01',100000,'unpaid');

-- ============================================================
-- 10. Payment (Weak Entity, Composite PK)
-- ============================================================
INSERT IGNORE INTO  payment (event_id, invoice_seq, payment_seq, payment_date, payment_method, payment_amount) VALUES
(300000001,1,1,'2024-03-05','bank transfer',50000),
(300000003,1,1,'2024-05-05','cash',30000),
(300000004,1,1,'2024-06-10','e-wallet',15000),
(300000005,1,1,'2024-07-05','bank transfer',80000),
(300000007,1,1,'2024-09-05','cash',12000),
(300000008,1,1,'2024-10-08','e-wallet',18000),
(300000009,1,1,'2024-11-06','cash',9000);

-- ============================================================
-- 11. Contribution (Optional FK: event_id nullable)
-- ============================================================
INSERT IGNORE INTO  contribution (contribution_id, event_id, partner_id, contribution_type, contribution_description, contribution_estimated_value, contribution_date) VALUES
(400000001,300000001,200000001,'cash','Event sponsorship',50000,'2024-03-10'),
(400000002,300000002,200000002,'in-kind','Guest speakers',NULL,'2024-04-05'),
(400000003,300000003,200000003,'cash','Prize funding',30000,'2024-05-01'),
(400000004,300000004,200000004,'in-kind','Equipment support',NULL,'2024-06-15'),
(400000005,300000005,200000005,'cash','Expo booth',80000,'2024-07-20'),
(400000006,NULL,200000006,'cash','General donation',5000,'2024-08-01'),
(400000007,300000007,200000007,'in-kind','Training materials',NULL,'2024-09-10'),
(400000008,300000008,200000008,'cash','Demo funding',18000,'2024-10-05'),
(400000009,300000009,200000009,'cash','Research grant',9000,'2024-11-01'),
(400000010,300000010,200000010,'in-kind','Logistics support',NULL,'2024-12-01');

-- ============================================================
-- 12. Feedback (Composite PK, nullable unit_id)
-- ============================================================
INSERT IGNORE INTO  feedback (event_id, feedback_seq_no, unit_id, feedback_rate, feedback_comment, feedback_date) VALUES
(300000001,1,100000003,5,'Excellent organization','2024-03-12'),
(300000001,2,NULL,4,'Good content','2024-03-12'),
(300000003,1,100000002,5,'Very engaging','2024-05-03'),
(300000005,1,NULL,3,'Too crowded','2024-07-22'),
(300000010,1,100000004,5,'Outstanding event','2024-12-03');

-- ============================================================
-- 13. Affiliation
-- ============================================================
INSERT IGNORE INTO  affiliation (affiliation_no, partner_id, unit_id, affiliation_start_date, affiliation_end_date, affiliation_status, affiliation_remark) VALUES
(600000001,200000001,100000001,'2024-01-01',NULL,'ACTIVE','University-level partnership'),
(600000002,200000002,100000002,'2024-02-01',NULL,'ACTIVE','School collaboration'),
(600000003,200000003,100000003,'2024-03-01',NULL,'ACTIVE','Faculty research cooperation'),
(600000004,200000004,100000004,'2024-04-01',NULL,'ACTIVE','Center-based collaboration');

-- ============================================================
-- 14. Agreement
-- ============================================================
INSERT IGNORE INTO  agreement (agreement_id, agreement_title, agreement_type, agreement_start_date, agreement_end_date, agreement_file_link, affiliation_no, partner_id, unit_id) VALUES
(500000001,'AI Research Cooperation','MoU','2024-01-01','2026-01-01','link_ai_mou.pdf',600000001,200000001,100000001),
(500000002,'Industry Training Program','Contract','2024-02-01','2025-02-01','link_training.pdf',600000002,200000002,100000002),
(500000003,'Joint Innovation Lab','MoA','2024-03-15',NULL,'link_lab.pdf',600000003,200000003,100000003);

-- ============================================================
-- 15. Agreement_Status_History
-- ============================================================
INSERT IGNORE INTO  agreement_status_history VALUES
(1,500000001,'draft','signed','2024-01-01','Signed by both parties'),
(2,500000002,'draft','signed','2024-02-01','Approved by legal team'),
(3,500000003,'draft','signed','2024-03-15','Effective immediately');

-- ============================================================
-- 16. Collab_Partner (Event ↔ Partner)
-- ============================================================
INSERT IGNORE INTO  collab_partner (event_id, partner_id, is_primary, priority) VALUES
(300000001,200000001,TRUE,1),
(300000001,200000006,FALSE,2),
(300000003,200000003,TRUE,1),
(300000005,200000004,TRUE,1),
(300000010,200000002,TRUE,1);

-- ============================================================
-- 17. Contact_Point
-- ============================================================
INSERT IGNORE INTO  contact_point (contact_id, contact_name, contact_email, contact_phone, contact_position) VALUES
(700000001,'Nguyen Van Hung','hung@viettel.com.vn','0901000001','Project Manager'),
(700000002,'Tran Thi Hoa','hoa@fpt.com.vn','0901000002','HR Manager'),
(700000003,'Le Minh Quan','quan@samsung.com','0901000003','R&D Director');

-- ============================================================
-- 18. Affiliation_Contact
-- ============================================================
INSERT IGNORE INTO  affiliation_contact (partner_id, affiliation_no, unit_id, contact_id, is_primary, priority) VALUES
(200000001,600000001,100000001,700000001,TRUE,1),
(200000002,600000002,100000002,700000002,TRUE,1),
(200000004,600000004,100000004,700000003,TRUE,1);

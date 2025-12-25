CREATE DATABASE IF NOT EXISTS team_2_db_4420;
USE team_2_db_4420;

-- RUN partner.sql (1)
START TRANSACTION;

CREATE TABLE IF NOT EXISTS partner (
    partner_id INT,
	partner_name VARCHAR(150),
	partner_type VARCHAR(30),
	partner_status ENUM('prospect', 'active', 'inactive'),
	partner_website	VARCHAR(255),
	sector VARCHAR(30),
	arrangement_frequency INT,
	PRIMARY KEY (partner_id)
);

CREATE TABLE IF NOT EXISTS organization (
    partner_id INT,
	organization_taxcode VARCHAR(10) DEFAULT 'unknown',
	PRIMARY KEY (partner_id),
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
	    ON DELETE CASCADE
	    ON UPDATE CASCADE
);

COMMIT;

-- RUN organization_unit.sql (2)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS organization_unit (
    unit_id INT,
	unit_name VARCHAR(100),
	unit_scope VARCHAR(50),
	status ENUM('prospect', 'active', 'inactive'),
	established_date DATE,
	PRIMARY KEY (unit_id)
);

CREATE TABLE IF NOT EXISTS university (
    university_id INT, 
	legal_name VARCHAR(150),
	country VARCHAR(50),
	city VARCHAR(50),
	president_name VARCHAR(100),
	PRIMARY KEY (university_id),
	FOREIGN KEY (university_id) REFERENCES organization_unit (unit_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS school (
    school_id INT,
	academic_focus VARCHAR(100),
	dean_name VARCHAR(100),
	student_count INT,
	faculty_count INT,
	university_id INT,
	PRIMARY KEY (school_id),
	FOREIGN KEY (school_id) REFERENCES organization_unit (unit_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (university_id) REFERENCES university (university_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS faculty (
    faculty_id INT, 
	faculty_code VARCHAR(10),
	head_of_faculty	VARCHAR(150),
	discipline VARCHAR(150),
	tenure_staff_count INT,
	research_staff_count INT,
	school_id INT,
	PRIMARY KEY (faculty_id),
	FOREIGN KEY (faculty_id) REFERENCES organization_unit (unit_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (school_id) REFERENCES school (school_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS center (
    center_id INT,
	center_type	ENUM('research', 'innovation', 'service'),
	num_fund_received DECIMAL(12,2),
	director_name VARCHAR(150),
	PRIMARY KEY (center_id),
	FOREIGN KEY (center_id) REFERENCES organization_unit (unit_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

COMMIT;

-- RUN affiliation.sql (3)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS affiliation (
    affiliation_no INT,
    -- ordinal number of this affiliation for the given partner
    -- (e.g., 1st, 2nd, 3rd affiliation of that partner)

    partner_id INT NOT NULL,
    unit_id INT NOT NULL,

    affiliation_start_date DATE NOT NULL,
    affiliation_end_date DATE,

    affiliation_status ENUM('ACTIVE', 'ENDED') NOT NULL DEFAULT 'ACTIVE',

    affiliation_remark VARCHAR(255),

    PRIMARY KEY (partner_id, affiliation_no, unit_id),

    FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
        ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES organization_unit (unit_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_affiliation_status_date
    CHECK (
        (affiliation_status = 'ACTIVE' AND affiliation_end_date IS NULL)
     OR (affiliation_status = 'ENDED'  AND affiliation_end_date IS NOT NULL)
    )
);

COMMIT;

-- RUN aggrement.sql (4)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS agreement (
    agreement_id INT,
	agreement_title	VARCHAR(200),
	agreement_type VARCHAR(30),
	agreement_start_date DATE NOT NULL,
	agreement_end_date DATE,
	agreement_file_link	VARCHAR(255),
    affiliation_no INT NOT NULL,
	partner_id INT NOT NULL,
	unit_id INT NOT NULL,
	PRIMARY KEY (agreement_id),
    FOREIGN KEY (partner_id, affiliation_no, unit_id) REFERENCES affiliation (partner_id, affiliation_no, unit_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS agreement_status_history (
    status_seq_no INT,
	agreement_id INT,
	previous_status	ENUM('draft', 'signed', 'expired', 'terminated'),
	current_status ENUM('draft', 'signed', 'expired', 'terminated'),
	status_change_time DATE,
	status_change_note VARCHAR(255),
	PRIMARY KEY (status_seq_no, agreement_id),
	FOREIGN KEY (agreement_id) REFERENCES agreement(agreement_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);
COMMIT;

-- RUN contact_point.sql (5)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS contact_point (
    contact_id INT,
	contact_name VARCHAR(150),
	contact_email VARCHAR(150),
	contact_phone VARCHAR(30),
	contact_position VARCHAR(100),
	PRIMARY KEY (contact_id)
);

CREATE TABLE IF NOT EXISTS affiliation_contact (
    partner_id INT,
    affiliation_no INT,
    unit_id INT,
    contact_id INT,

    is_primary BOOL DEFAULT FALSE,
    priority INT DEFAULT 0,

    PRIMARY KEY (partner_id, affiliation_no, unit_id, contact_id),

    FOREIGN KEY (partner_id, affiliation_no, unit_id)
        REFERENCES affiliation (partner_id, affiliation_no, unit_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (contact_id)
        REFERENCES contact_point (contact_id)
        ON DELETE CASCADE
);

COMMIT;


--  RUN collaboration_event.sql (6)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS collaboration_event (
    event_id INT,
	event_title VARCHAR(150),
	event_type VARCHAR(50),
	event_location VARCHAR(100),
	event_start_time DATE NOT NULL,
	event_end_time DATE,
	participants_num INT,
	PRIMARY KEY (event_id)
);

CREATE TABLE IF NOT EXISTS collab_partner (
    event_id INT,
	partner_id INT,
	is_primary BOOL DEFAULT FALSE,
	priority INT DEFAULT 0,
	PRIMARY KEY (event_id, partner_id),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

COMMIT;


-- RUN contribution.sql (7)
START TRANSACTION;

CREATE TABLE IF NOT EXISTS contribution (
    contribution_id INT,
	event_id INT NULL,
	partner_id INT, 
	contribution_type ENUM('cash', 'in-kind'),
	contribution_description VARCHAR(255),
	contribution_estimated_value DECIMAL(12,2),
	contribution_date DATE,
	PRIMARY KEY (contribution_id),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE,
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

COMMIT;


-- RUN feedback.sql (8)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS feedback (
    event_id INT,
	feedback_seq_no	INT,
	unit_id INT NULL,
	feedback_rate INT,
	feedback_comment TEXT,
	feedback_date DATE,
	PRIMARY KEY (event_id, feedback_seq_no),
	CHECK (feedback_rate BETWEEN 1 AND 5),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (unit_id) REFERENCES organization_unit (unit_id)
		ON DELETE SET NULL
		ON UPDATE CASCADE
);

COMMIT;

-- RUN InvoicePayment.sql (9)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS invoice (
    event_id INT,
	invoice_seq INT,
	invoice_issue_date DATE,
	invoice_amount DECIMAL(12,2),
	invoice_status ENUM('paid', 'unpaid', 'cancelled'),
	PRIMARY KEY (event_id, invoice_seq),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS payment (
    event_id INT,
	invoice_seq INT,
 	payment_seq INT,
 	payment_date DATE,
	payment_method ENUM('cash', 'bank transfer', 'e-wallet'),
	payment_amount DECIMAL(12,2),
	PRIMARY KEY (event_id, invoice_seq, payment_seq),
	FOREIGN KEY (event_id, invoice_seq) REFERENCES invoice (event_id, invoice_seq)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

COMMIT;

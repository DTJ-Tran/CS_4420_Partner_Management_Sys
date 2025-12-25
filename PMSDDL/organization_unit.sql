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

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
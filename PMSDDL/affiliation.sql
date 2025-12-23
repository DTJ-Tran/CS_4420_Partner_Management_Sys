START TRANSACTION;

CREATE TABLE affiliation{
    affiliation_no INT,
	partner_id INT,
	unit_id INT,
	affiliation_start_date DATE NOT NULL,
	affiliation_end_date DATE,
	affiliation_remark VARCHAR(255),
	PRIMARY KEY (affiliation_no, partner_id),
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
		ON DELETE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (unit_id) REFERENCES organization_unit (unit_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
}

CREATE TABLE involve{
    affiliation_no INT,
	agreement_id INT,
	PRIMARY KEY (affiliation_no, agreement_id),
	FOREIGN KEY (affiliation_no) REFERENCES affiliation (affiliation_no)
		on DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (agreement_id) REFERENCES agreement (agreement_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
}

COMMIT;

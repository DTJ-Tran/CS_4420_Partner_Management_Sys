START TRANSACTION;

CREATE TABLE contact_point{
    contact_id INT,
	contact_name VARCHAR(150),
	contact_email VARCHAR(150),
	contact_phone VARCHAR(30),
	contact_position VARCHAR(100),
	PRIMARY KEY (contact_id)
}

CREATE TABLE affiliation_contact{
    affiliation_no INT,
	contact_id INT,
	is_primary BOOL DEFAULT FALSE,
	priority INT DEFAULT 0,
	PRIMARY KEY (affiliation_no, contact_id), 
	FOREIGN KEY (affiliation_no) REFERENCES affiliation (affiliation_no)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (contact_id) REFERENCES contact_point (contact_id)
		ON DELETE CASCADE
		ON DELETE CASCADE
}

COMMIT;
START TRANSACTION;

CREATE TABLE partner{
    partner_id INT,
	partner_name VARCHAR(150),
	partner_type VARCHAR(30),
	partner_status ENUM('prospect', 'active', 'inactive'),
	partner_website	VARCHAR(255),
	sector VARCHAR(30),
	arrangment_frequency INT,
	PRIMARY KEY (partner_id)
}

CREATE TABLE organization{
    partner_id INT,
	organization_taxcode VARCHAR(10) DEFAULT 'unknown',
	PRIMARY KEY (partner_id),
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
	    ON DELETE CASCADE
	    ON UPDATE CASCADE
}

COMMIT;
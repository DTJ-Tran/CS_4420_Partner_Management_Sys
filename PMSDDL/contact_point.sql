
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

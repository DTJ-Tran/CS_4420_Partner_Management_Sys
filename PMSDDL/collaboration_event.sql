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
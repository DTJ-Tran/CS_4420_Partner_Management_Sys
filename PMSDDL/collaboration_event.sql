START TRANSACTION;

CREATE TABLE collaboration_event{
    event_id INT,
	event_title VARCHAR(150),
	event_type VARCHAR(50),
	event_location VARCHAR(100),
	event_start_time DATE NOT NULL,
	event_end_time DATE,
	participants_num INT,
	PRIMARY KEY (event_id)
}

CREATE TABLE collab_partner{
    event_id INT,
	partner_id INT,
	is_primary BOOL,
	priority INT,
	PRIMARY KEY (event_id, partner_id),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id),
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
}

COMMIT;
CREATE TABLE contribution{
    contribution_id INT,
	event_id INT NULL,
	partner_id INT, 
	contribution_type ENUM('cash', 'in-kind'),
	contribution_description VARCHAR(255),
	contribution_estimated_value DECIMAL(12,2),
	contribution_date DATE,
	PRIMARY KEY (contribution_id),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id),
	FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
}
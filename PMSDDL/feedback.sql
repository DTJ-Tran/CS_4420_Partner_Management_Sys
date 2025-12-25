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
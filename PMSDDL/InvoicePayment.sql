
-- RUN InvoicePayment.sql (9)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS invoice (
    event_id INT,
	invoice_seq INT,
	invoice_issue_date DATE,
	invoice_amount DECIMAL(12,2),
	invoice_status ENUM('paid', 'unpaid', 'cancelled'),
	PRIMARY KEY (event_id, invoice_seq),
	FOREIGN KEY (event_id) REFERENCES collaboration_event (event_id)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS payment (
    event_id INT,
	invoice_seq INT,
 	payment_seq INT,
 	payment_date DATE,
	payment_method ENUM('cash', 'bank transfer', 'e-wallet'),
	payment_amount DECIMAL(12,2),
	PRIMARY KEY (event_id, invoice_seq, payment_seq),
	FOREIGN KEY (event_id, invoice_seq) REFERENCES invoice (event_id, invoice_seq)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

COMMIT;

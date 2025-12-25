-- RUN affiliation.sql (3)

START TRANSACTION;

CREATE TABLE IF NOT EXISTS affiliation (
    affiliation_no INT,
    -- ordinal number of this affiliation for the given partner
    -- (e.g., 1st, 2nd, 3rd affiliation of that partner)

    partner_id INT NOT NULL,
    unit_id INT NOT NULL,

    affiliation_start_date DATE NOT NULL,
    affiliation_end_date DATE,

    affiliation_status ENUM('ACTIVE', 'ENDED') NOT NULL DEFAULT 'ACTIVE',

    affiliation_remark VARCHAR(255),

    PRIMARY KEY (partner_id, affiliation_no, unit_id),

    FOREIGN KEY (partner_id) REFERENCES partner (partner_id)
        ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES organization_unit (unit_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_affiliation_status_date
    CHECK (
        (affiliation_status = 'ACTIVE' AND affiliation_end_date IS NULL)
     OR (affiliation_status = 'ENDED'  AND affiliation_end_date IS NOT NULL)
    )
);

COMMIT;
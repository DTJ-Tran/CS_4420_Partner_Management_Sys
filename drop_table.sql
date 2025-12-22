SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS
    payment,
    invoice,
    feedback,
    contribution,
    collab_partner,
    collaboration_event,
    affiliation_contact,
    involve,
    affiliation,
    agreement_status_history,
    agreement,
    center,
    faculty,
    school,
    university,
    organization_unit,
    organization,
    contact_point,
    partner;

SET FOREIGN_KEY_CHECKS = 1;
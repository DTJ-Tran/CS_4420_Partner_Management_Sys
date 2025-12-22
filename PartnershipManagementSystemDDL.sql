create table partner
	(partner_id		INT,
	 partner_name		VARCHAR(150),
	 partner_type		VARCHAR(30),
	 partner_status		ENUM('prospect', 'active', 'inactive'),
	 partner_website	VARCHAR(255),
	 sector			VARCHAR(30),
	 arrangment_frequency	INT,
	 primary key (partner_id)
	);

create table organization
	(partner_id		INT,
	 organization_taxcode	VARCHAR(10) NOT NULL,
	 primary key (partner_id),
	 foreign key (partner_id) references partner (partner_id)
		on delete cascade
		on update cascade
	);
	
create table organization_unit
	(unit_id		INT,
	 unit_name		VARCHAR(100),
	 unit_scope		VARCHAR(50),
	 status			ENUM('prospect', 'active', 'inactive'),
	 established_date	DATE,
	 primary key (unit_id)
	);

create table university
	(university_id 		INT, 
	 legal_name		VARCHAR(150),
	 country		VARCHAR(50),
	 city			VARCHAR(50),
	 president_name		VARCHAR(100),
	 primary key (university_id),
	 foreign key (university_id) references organization_unit (unit_id)
		on delete cascade
		on update cascade
	);

create table school
	(school_id		INT,
	 academic_focus		VARCHAR(100),
	 dean_name		VARCHAR(100),
	 student_count		INT,
	 faculty_count		INT,
	 university_id		INT,
	 primary key (school_id),
	 foreign key (school_id) references organization_unit (unit_id)
		on delete cascade
		on update cascade,
	 foreign key (university_id) references university (university_id)
		on delete cascade
		on update cascade
	);

 
create table faculty
	(faculty_id		INT,
	 faculty_code		VARCHAR(10),
	 head_of_faculty	VARCHAR(150),
	 discipline		VARCHAR(150),
	 tenure_staff_count	INT,
	 research_staff_count	INT,
	 school_id		INT,
	 primary key (faculty_id),
	 foreign key (faculty_id) references organization_unit (unit_id)
		on delete cascade,
		on update cascade,
	 foreign key (school_id) references school (school_id),
		on delete cascade
		on update cascade
	);

create table center
	(center_id		INT,
	 center_type		VARCHAR(30),
	 num_fund_received	DECIMAL(12,2),
	 director_name		VARCHAR(150),
	 start_date 		DATE,
	 end_date		DATE,
	 primary key (center_id),
	 foreign key (center_id) references organization_unit (unit_id)
		on delete cascade
		on update cascade
	);

create table agreement
	(agreement_id		INT,
	 agreement_title	VARCHAR(200),
	 agreement_type		VARCHAR(30),
	 agreement_start_date	DATE,
	 agreement_end_date 	DATE,
	 agreement_file_link	VARCHAR(255),
	 primary key (agreement_id)
	);

create table agreement_status_history
	(status_seq_no		INT,
	 agreement_id 		INT,
	 previous_status	ENUM('draft', 'signed', 'expired', 'terminated'),
	 current_status		ENUM('draft', 'signed', 'expired', 'terminated'),
	 status_change_time	DATE,
	 status_change_note	VARCHAR(255),
	 primary key (status_seq_no, agreement_id),
	 foreign key (agreement_id) references agreement(agreement_id)
		on delete cascade
		on update cascade
	);

create table contact_point
	(contact_id		INT,
	 contact_name		VARCHAR(150),
	 contact_email		VARCHAR(150),
	 contact_phone		VARCHAR(30),
	 contact_position 	VARCHAR(100),
	 primary key (contact_id)
	);

create table affiliation
	(affiliation_no			INT,
	 partner_id			INT,
	 unit_id			INT,
	 contact_id			INT,	
	 affiliation_start_date		DATE,
	 affiliation_end_date		DATE,
	 affiliation_remark		VARCHAR(255),
	 primary key (affiliation_no, partner_id, contact_id),
	 foreign key (partner_id) references partner (partner_id)
		on delete cascade
		on update cascade,
	 foreign key (unit_id) references organization_unit (unit_id)
		on delete cascade
		on update cascade,
	 foreign key (contact_id) references affiliation_contact (contact_id)
	);

create table involve
	(affiliation_no		INT,
	 agreement_id		INT,
	 primary key (affiliation_no, agreement_id),
	 foreign key (affiliation_no) references affiliation (affiliation_no),
	 foreign key (agreement_id) references agreement (agreement_id)
	);

create table affiliation_contact
	(affiliation_no		INT,
	 contact_id		INT,
	 priority		INT AUTO INCREMENT,
	 primary key (affiliation_no, contact_id),
	 foreign key (affiliation_no) references affiliation (affiliation_no),
	 foreign key (contact_id) references contact_point (contact_id)
	);

create table collaboration_event
	(event_id		INT,
	 event_title		VARCHAR(150),
	 event_type		VARCHAR(50),
	 event_location		VARCHAR(100),
	 event_start_time	DATE,
	 event_end_time		DATE,
	 participants_num	INT,
	 primary key (event_id)
	);

create table collab_partner
	(event-id		INT,
	 partner_id		INT,
	 priority		INT AUTO INCREMENT,
	 primary key (event_id, partner_id),
	 foreign key (event_id) references collaboration_event (event_id),
	 foreign key (partner_id) references partner (partner_id)
	);

create table contribution
	(contribution_id		INT,
	 event_id			INT NULL,
	 partner_id			INT, 
	 contribution_type 		ENUM('cash', 'in-kind'),
	 contribution_description	VARCHAR(255),
	 contribution_estimated_value	DECIMAL(12,2),
	 contribution_date		DATE,
	 primary key (contribution_id),
	 foreign key (event_id) references collaboration_event (event_id),
	 foreign key (partner_id) references partner (partner_id)
	);

create table feedback
	(event_id 		INT,
	 feedback_seq_no	INT,
	 unit_id		INT,
	 feedback_rate 		INT,
	 feedback-comment	TEXT,
	 feedback_date		DATE,
	 primary key (event_id, feedback_seq_no),
	 check (feedback_rate between 1 and 5),
	 foreign key (event_id) references collaboration_event (event_id),
	 foreign key (unit_id) references organization_unit (unit_id)
	);

create table invoice
	(event_id		INT,
	 invoice_seq		INT,
	 invoice_issue_date	DATE,
	 invoice_amount		DECIMAL(12,2),
	 invoice_status		ENUM('paid', 'unpaid', 'cancelled'),
	 primary key (event_id, invoice_seq),
	 foreign key (event_id) references collaboration_event (event_id)
	); 

create table payment
	(event_id			INT,
	 invoice_seq		INT,
 	 payment_seq		INT,
 	 payment_date		DATE,
	 payment_method		ENUM('cash', 'bank transfer', 'e-wallet'),
	 payment_amount		DECIMAL(12,2),
	 primary key (event_id, invoice_seq, payment_seq),
	 foreign key (event_id) references collaboration_event (event_id),
	 foreign key (invoice_seq) references invoice (invoice_seq)
	);

	 

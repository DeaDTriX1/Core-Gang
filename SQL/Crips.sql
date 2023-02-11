INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_Crips','Crips',1),
	('society_Crips_black', 'Crips black', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_Crips','Crips',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_Crips', 'Crips', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('Crips', 'Crips');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('Crips', 0, 'petit', 'Petit', 200, 'null', 'null'),
('Crips', 1, 'elite', 'Elite', 400, 'null', 'null'),
('Crips', 2, 'bras-droit', 'Bras-Droit', 600, 'null', 'null'),
('Crips', 3, 'boss', 'Boss', 1000, 'null', 'null');
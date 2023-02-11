INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_Vagos','Vagos',1),
	('society_Vagos_black', 'Vagos black', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_Vagos','Vagos',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_Vagos', 'Vagos', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('Vagos', 'Vagos');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('Vagos', 0, 'petit', 'Petit', 200, 'null', 'null'),
('Vagos', 1, 'elite', 'Elite', 400, 'null', 'null'),
('Vagos', 2, 'bras-droit', 'Bras-Droit', 600, 'null', 'null'),
('Vagos', 3, 'boss', 'Boss', 1000, 'null', 'null');
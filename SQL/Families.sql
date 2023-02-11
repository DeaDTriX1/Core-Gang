INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_Families','Families',1),
	('society_Families_black', 'Families black', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_Families','Families',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_Families', 'Families', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('Families', 'Families');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('Families', 0, 'petit', 'Petit', 200, 'null', 'null'),
('Families', 1, 'elite', 'Elite', 400, 'null', 'null'),
('Families', 2, 'bras-droit', 'Bras-Droit', 600, 'null', 'null'),
('Families', 3, 'boss', 'Boss', 1000, 'null', 'null');
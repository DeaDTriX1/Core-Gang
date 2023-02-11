INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_Bloods','Bloods',1),
	('society_Bloods_black', 'Bloods black', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_Bloods','Bloods',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_Bloods', 'Bloods', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('Bloods', 'Bloods');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('Bloods', 0, 'petit', 'Petit', 200, 'null', 'null'),
('Bloods', 1, 'elite', 'Elite', 400, 'null', 'null'),
('Bloods', 2, 'bras-droit', 'Bras-Droit', 600, 'null', 'null'),
('Bloods', 3, 'boss', 'Boss', 1000, 'null', 'null');
INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_Ballas','Ballas',1),
	('society_Ballas_black', 'Ballas black', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_Ballas','Ballas',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_Ballas', 'Ballas', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('Ballas', 'Ballas');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('Ballas', 0, 'petit', 'Petit', 200, 'null', 'null'),
('Ballas', 1, 'elite', 'Elite', 400, 'null', 'null'),
('Ballas', 2, 'bras-droit', 'Bras-Droit', 600, 'null', 'null'),
('Ballas', 3, 'boss', 'Boss', 1000, 'null', 'null');
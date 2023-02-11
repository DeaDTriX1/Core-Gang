INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_Marabunta','Marabunta',1),
	('society_Marabunta_black', 'Marabunta black', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_Marabunta','Marabunta',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_Marabunta', 'Marabunta', 1)
;

INSERT INTO `jobs` (`name`, `label`) VALUES
('Marabunta', 'Marabunta');

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('Marabunta', 0, 'petit', 'Petit', 200, 'null', 'null'),
('Marabunta', 1, 'elite', 'Elite', 400, 'null', 'null'),
('Marabunta', 2, 'bras-droit', 'Bras-Droit', 600, 'null', 'null'),
('Marabunta', 3, 'boss', 'Boss', 1000, 'null', 'null');
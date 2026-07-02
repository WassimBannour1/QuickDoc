-- QuikDoc Database Backup
-- Generated: 2025-06-19T21:34:45.892Z
-- ------------------------------------------------------

-- Table structure for table `categories`
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `owner_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `categories`
INSERT INTO `categories` (`id`, `name`, `owner_id`) VALUES (1, 'Électronique', '2');
INSERT INTO `categories` (`id`, `name`, `owner_id`) VALUES (13, 'testcat', '2');

-- Table structure for table `clients`
DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `CIN` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `clients_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `clients`
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (1, 1, 3, 'Ali', 'Ben Ali', 'ali@example.com', '+21612345678', '123 Rue de Tunis', '2025-04-12 14:05:11', NULL);
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (2, 1, 3, 'Sana', 'Trabelsi', 'sana@example.com', '+21623456789', '456 Avenue Bourguiba', '2025-04-12 14:05:11', NULL);
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (21, 2, 18, 'ahmed', 'mrabet', 'wassbennour876@gmail.com', '94101910', 'sqdsq', '2025-06-11 02:43:30', '45456');
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (22, 2, 1, 'ahmed', 'mrabet', 'wisoghost@gmail.com', '94101910', 'dfsd', '2025-06-19 02:46:12', '140428377');
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (23, 2, 21, 'farah', 'gdaim', 'wassbennour456@gmail.com', '94101910', 'tunisai monastir', '2025-06-19 21:25:47', '14042838');

-- Table structure for table `document`
DROP TABLE IF EXISTS `document`;
CREATE TABLE `document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `remplissage_id` int NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `remplissage_id` (`remplissage_id`),
  CONSTRAINT `document_ibfk_1` FOREIGN KEY (`remplissage_id`) REFERENCES `remplissage` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `document`
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (1, 1, 'uploads/documents/1.pdf', '2025-04-12 13:55:37', 'non envoyée');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (2, 2, 'uploads/documents/2.pdf', '2025-04-12 13:55:37', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (3, 3, 'uploads/documents/2.pdf', '2025-04-12 13:55:38', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (7, 80, 'uploads/documents/1750119930690_Facture_1213211.pdf', '2025-06-17 00:25:30', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (8, 81, 'uploads/documents/1750137594413_Facture_1213211.pdf', '2025-06-17 05:19:54', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (9, 81, 'uploads/documents/1750138098559_Facture_1213211.pdf', '2025-06-17 05:28:18', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (10, 82, 'uploads/documents/1750141993188_Facture_1213211.pdf', '2025-06-17 06:33:13', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (11, 85, 'uploads/documents/1750192372881_Facture_fac8888.pdf', '2025-06-17 20:32:52', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (12, 90, 'uploads/documents/1750268150785_Facture_fac88889.pdf', '2025-06-18 17:35:50', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (13, 92, 'uploads/documents/1750268197202_Facture_dsfsdf.pdf', '2025-06-18 17:36:37', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (14, 93, 'uploads/documents/1750268249039_Facture_test.pdf', '2025-06-18 17:37:29', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (15, 95, 'uploads/documents/1750269330125_Facture_hello .pdf', '2025-06-18 17:55:30', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (16, 87, 'uploads/documents/1750275417487_Facture_fac8888.pdf', '2025-06-18 19:36:57', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (17, 95, 'uploads/documents/1750275503627_Facture_hello .pdf', '2025-06-18 19:38:23', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (18, 96, 'uploads/documents/1750275596384_Facture_wassimtest.pdf', '2025-06-18 19:39:56', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (19, 93, 'uploads/documents/1750275704764_Facture_test.pdf', '2025-06-18 19:41:44', 'Non envoyé');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (20, 97, 'uploads/documents/1750279932713_Facture_aaaadsd.pdf', '2025-06-18 20:52:12', 'non envoyée');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (21, 91, 'uploads/documents/1750297105523_Facture_dsfsdf.pdf', '2025-06-19 01:38:25', 'non envoyée');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (22, 98, 'uploads/documents/1750297149027_Devis_aaaadsd.pdf', '2025-06-19 01:39:09', 'non envoyée');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (23, 99, 'uploads/documents/1750362829103_Facture_aaaadsd.pdf', '2025-06-19 19:53:49', 'non envoyée');

-- Table structure for table `entreprises`
DROP TABLE IF EXISTS `entreprises`;
CREATE TABLE `entreprises` (
  `id` int NOT NULL AUTO_INCREMENT,
  `siret` char(14) NOT NULL,
  `owner_id` int NOT NULL,
  `nom_entreprise` varchar(255) NOT NULL,
  `email_entreprise` varchar(255) DEFAULT NULL,
  `logo_path` varchar(255) DEFAULT NULL,
  `pays` varchar(100) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `adresse` text,
  `code_postal` varchar(20) DEFAULT NULL,
  `devise` varchar(10) DEFAULT 'TND',
  `secteur_activite` varchar(255) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `siret_UNIQUE` (`siret`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `entreprises_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `entreprises`
INSERT INTO `entreprises` (`id`, `siret`, `owner_id`, `nom_entreprise`, `email_entreprise`, `logo_path`, `pays`, `ville`, `adresse`, `code_postal`, `devise`, `secteur_activite`, `telephone`, `created_at`, `updated_at`) VALUES (1, '12345678912346', 2, 'tayara', 'wasss@gmail.comdfdfgaaaa', NULL, 'Tunisiedsfsdfaaa', 'sqdsqaa', 'qsdgdsfertrrraa', '5099', 'EUR', 'qsdsqdsq212aaadsffdgaa', '9410191065', '2025-05-08 19:48:59', '2025-06-19 21:06:00');
INSERT INTO `entreprises` (`id`, `siret`, `owner_id`, `nom_entreprise`, `email_entreprise`, `logo_path`, `pays`, `ville`, `adresse`, `code_postal`, `devise`, `secteur_activite`, `telephone`, `created_at`, `updated_at`) VALUES (3, '12345678910123', 22, 'messoustechnology', NULL, NULL, NULL, NULL, NULL, NULL, 'TND', NULL, NULL, '2025-06-19 18:56:53', '2025-06-19 18:56:53');

-- Table structure for table `notification`
DROP TABLE IF EXISTS `notification`;
CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `document_id` int DEFAULT NULL,
  `message` text NOT NULL,
  `status` enum('unread','read') DEFAULT 'unread',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `sender_id` (`sender_id`),
  KEY `document_id` (`document_id`),
  CONSTRAINT `notification_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `notification_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  CONSTRAINT `notification_ibfk_3` FOREIGN KEY (`document_id`) REFERENCES `document` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `notification`
INSERT INTO `notification` (`id`, `user_id`, `sender_id`, `document_id`, `message`, `status`, `created_at`, `updated_at`) VALUES (1, 1, 2, 1, 'Votre facture a été générée.', 'unread', '2025-04-12 13:56:46', '2025-04-12 14:17:33');
INSERT INTO `notification` (`id`, `user_id`, `sender_id`, `document_id`, `message`, `status`, `created_at`, `updated_at`) VALUES (2, 2, 1, 2, 'Nouveau devis disponible.', 'read', '2025-04-12 13:56:46', '2025-04-12 14:17:33');

-- Table structure for table `products`
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `owner_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` text,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `stock_quantity` int DEFAULT '0',
  `subcategory_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `subcategory_id` (`subcategory_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `products_ibfk_2` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `products`
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (1, 2, 'Laptop HP', 'Ordinateur portable HP 15.6"', '1200.00', 'unité', 10, 1);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (2, 2, 'iPhone 14', 'Smartphone Apple 128Go', '2500.00', 'unité', 4, 1);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (9, 2, 'velo', 'new velo ', '20.00', 'pièce', 3, 1);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (10, 2, 'aaa', 'aaa', '0.17', 'ml', 4, 8);

-- Table structure for table `remplissage`
DROP TABLE IF EXISTS `remplissage`;
CREATE TABLE `remplissage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `entreprise_id` int NOT NULL,
  `client_id` int NOT NULL,
  `template_id` int NOT NULL,
  `owner_id` int DEFAULT NULL,
  `serie_number` varchar(100) DEFAULT NULL,
  `type_document` enum('facture','devis') NOT NULL,
  `montant_ht` decimal(10,2) NOT NULL,
  `total_remise` decimal(10,2) DEFAULT '0.00',
  `total_net_ht` decimal(10,2) GENERATED ALWAYS AS ((`montant_ht` - `total_remise`)) STORED,
  `montant_tva` decimal(10,2) NOT NULL,
  `taux_tva` decimal(5,2) NOT NULL,
  `montant_ttc` decimal(10,2) NOT NULL,
  `details_bancaire` text,
  `date_document` date DEFAULT NULL,
  `avertissement` text,
  `delai_paiement` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `client_id` (`client_id`),
  KEY `template_id` (`template_id`),
  KEY `fk_owner_id` (`owner_id`),
  KEY `fk_entreprise_id` (`entreprise_id`),
  CONSTRAINT `fk_entreprise_id` FOREIGN KEY (`entreprise_id`) REFERENCES `entreprises` (`id`),
  CONSTRAINT `fk_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`),
  CONSTRAINT `remplissage_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  CONSTRAINT `remplissage_ibfk_3` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `remplissage`
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (1, 1, 22, 1, 2, '754', 'facture', '500.00', '0.00', '500.00', '100.00', '20.00', '600.00', NULL, NULL, NULL, '2025-05-14 23:00:00', '2025-04-12 13:52:01', '2025-06-19 02:48:05');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (2, 1, 22, 2, 2, '777', 'devis', '300.00', '0.00', '300.00', '60.00', '20.00', '360.00', NULL, NULL, NULL, NULL, '2025-04-12 13:52:01', '2025-06-19 02:47:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (3, 0, 22, 1, 2, '777', 'devis', '100.00', '0.00', '100.00', '19.00', '19.00', '119.00', NULL, NULL, NULL, '2025-04-30 23:00:00', '2025-04-15 16:25:38', '2025-06-19 02:47:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (5, 0, 22, 2, 2, NULL, 'devis', '150.00', '0.00', '150.00', '28.50', '19.00', '178.50', NULL, NULL, NULL, '2025-05-09 23:00:00', '2025-04-15 16:25:38', '2025-06-19 02:47:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (6, 0, 22, 2, 2, NULL, 'facture', '300.00', '0.00', '300.00', '57.00', '19.00', '357.00', NULL, NULL, NULL, '2025-05-11 23:00:00', '2025-04-15 16:25:38', '2025-06-19 02:47:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (7, 0, 1, 2, 2, NULL, 'devis', '90.00', '0.00', '90.00', '17.10', '19.00', '107.10', NULL, NULL, NULL, '2025-05-14 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (8, 0, 2, 1, 2, NULL, 'facture', '250.00', '0.00', '250.00', '47.50', '19.00', '297.50', NULL, NULL, NULL, '2025-05-19 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (9, 0, 2, 2, 2, NULL, 'devis', '180.00', '0.00', '180.00', '34.20', '19.00', '214.20', NULL, NULL, NULL, '2025-05-21 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (10, 0, 1, 2, 2, NULL, 'facture', '75.00', '0.00', '75.00', '14.25', '19.00', '89.25', NULL, NULL, NULL, '2025-05-24 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (11, 0, 2, 1, 2, NULL, 'devis', '220.00', '0.00', '220.00', '41.80', '19.00', '261.80', NULL, NULL, NULL, '2025-05-27 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (12, 0, 1, 1, 2, NULL, 'facture', '130.00', '0.00', '130.00', '24.70', '19.00', '154.70', NULL, NULL, NULL, '2025-05-29 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (13, 0, 2, 2, 2, NULL, 'devis', '449.06', '0.00', '449.06', '85.32', '19.00', '534.38', NULL, NULL, NULL, '2025-05-29 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (15, 0, 1, 1, 2, NULL, 'facture', '179.18', '0.00', '179.18', '34.04', '19.00', '213.22', NULL, NULL, NULL, '2025-06-01 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (16, 0, 2, 1, 2, NULL, 'devis', '88.15', '0.00', '88.15', '16.75', '19.00', '104.90', NULL, NULL, NULL, '2025-05-22 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (18, 0, 2, 1, 2, NULL, 'devis', '92.92', '0.00', '92.92', '17.65', '19.00', '110.57', NULL, NULL, NULL, '2025-06-20 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (19, 0, 2, 2, 2, NULL, 'facture', '61.52', '0.00', '61.52', '11.69', '19.00', '73.21', NULL, NULL, NULL, '2025-05-29 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (20, 0, 1, 2, 2, NULL, 'facture', '158.87', '0.00', '158.87', '30.19', '19.00', '189.06', NULL, NULL, NULL, '2025-05-28 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (21, 0, 2, 2, 2, NULL, 'facture', '92.76', '0.00', '92.76', '17.62', '19.00', '110.38', NULL, NULL, NULL, '2025-06-22 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (22, 0, 1, 2, 2, NULL, 'facture', '331.10', '0.00', '331.10', '62.91', '19.00', '394.01', NULL, NULL, NULL, '2025-06-07 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (23, 0, 1, 2, 2, NULL, 'facture', '122.55', '0.00', '122.55', '23.29', '19.00', '145.84', NULL, NULL, NULL, '2025-06-05 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (24, 0, 1, 1, 2, NULL, 'facture', '71.94', '0.00', '71.94', '13.67', '19.00', '85.61', NULL, NULL, NULL, '2025-05-20 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (25, 0, 2, 1, 2, NULL, 'facture', '338.64', '0.00', '338.64', '64.34', '19.00', '402.98', NULL, NULL, NULL, '2025-05-05 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (26, 0, 2, 1, 2, NULL, 'devis', '90.18', '0.00', '90.18', '17.13', '19.00', '107.31', NULL, NULL, NULL, '2025-06-12 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (27, 0, 1, 2, 2, NULL, 'facture', '255.77', '0.00', '255.77', '48.60', '19.00', '304.37', NULL, NULL, NULL, '2025-06-12 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (28, 0, 2, 1, 2, NULL, 'facture', '361.64', '0.00', '361.64', '68.71', '19.00', '430.35', NULL, NULL, NULL, '2025-05-23 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (29, 0, 1, 2, 2, NULL, 'facture', '346.71', '0.00', '346.71', '65.88', '19.00', '412.59', NULL, NULL, NULL, '2025-05-31 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (30, 0, 2, 2, 2, NULL, 'devis', '381.00', '0.00', '381.00', '72.39', '19.00', '453.39', NULL, NULL, NULL, '2025-06-27 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (31, 0, 1, 1, 2, NULL, 'facture', '96.88', '0.00', '96.88', '18.41', '19.00', '115.29', NULL, NULL, NULL, '2025-05-23 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (32, 0, 2, 1, 2, NULL, 'facture', '210.79', '0.00', '210.79', '40.05', '19.00', '250.84', NULL, NULL, NULL, '2025-06-17 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (33, 0, 2, 2, 2, NULL, 'facture', '144.74', '0.00', '144.74', '27.50', '19.00', '172.24', NULL, NULL, NULL, '2025-06-22 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (34, 0, 2, 1, 2, NULL, 'devis', '61.59', '0.00', '61.59', '11.70', '19.00', '73.29', NULL, NULL, NULL, '2025-05-29 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (35, 0, 2, 1, 2, NULL, 'devis', '234.07', '0.00', '234.07', '44.47', '19.00', '278.54', NULL, NULL, NULL, '2025-06-19 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (36, 0, 1, 2, 2, NULL, 'facture', '293.45', '0.00', '293.45', '55.76', '19.00', '349.21', NULL, NULL, NULL, '2025-05-07 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (37, 0, 2, 1, 2, NULL, 'facture', '409.12', '0.00', '409.12', '77.73', '19.00', '486.85', NULL, NULL, NULL, '2025-05-10 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (38, 0, 1, 1, 2, NULL, 'devis', '293.67', '0.00', '293.67', '55.80', '19.00', '349.47', NULL, NULL, NULL, '2025-05-30 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (39, 0, 2, 1, 2, NULL, 'devis', '351.32', '0.00', '351.32', '66.75', '19.00', '418.07', NULL, NULL, NULL, '2025-06-27 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (40, 0, 1, 1, 2, NULL, 'devis', '58.69', '0.00', '58.69', '11.15', '19.00', '69.84', NULL, NULL, NULL, '2025-05-13 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (41, 0, 2, 2, 2, NULL, 'facture', '351.20', '0.00', '351.20', '66.73', '19.00', '417.93', NULL, NULL, NULL, '2025-05-20 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (42, 0, 1, 1, 2, NULL, 'facture', '75.14', '0.00', '75.14', '14.28', '19.00', '89.42', NULL, NULL, NULL, '2025-06-20 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (43, 0, 2, 1, 2, NULL, 'facture', '79.53', '0.00', '79.53', '15.11', '19.00', '94.64', NULL, NULL, NULL, '2025-06-09 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (44, 0, 2, 1, 2, NULL, 'devis', '67.94', '0.00', '67.94', '12.91', '19.00', '80.85', NULL, NULL, NULL, '2025-06-05 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (45, 0, 1, 1, 2, NULL, 'facture', '101.74', '0.00', '101.74', '19.33', '19.00', '121.07', NULL, NULL, NULL, '2025-05-31 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (46, 0, 2, 2, 2, NULL, 'facture', '201.28', '0.00', '201.28', '38.24', '19.00', '239.52', NULL, NULL, NULL, '2025-06-28 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (47, 0, 2, 1, 2, NULL, 'facture', '386.08', '0.00', '386.08', '73.36', '19.00', '459.44', NULL, NULL, NULL, '2025-05-26 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (49, 0, 2, 2, 2, NULL, 'facture', '199.41', '0.00', '199.41', '37.89', '19.00', '237.30', NULL, NULL, NULL, '2025-06-03 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (50, 0, 2, 2, 2, NULL, 'devis', '97.67', '0.00', '97.67', '18.56', '19.00', '116.23', NULL, NULL, NULL, '2025-06-20 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (51, 0, 1, 2, 2, NULL, 'facture', '129.31', '0.00', '129.31', '24.57', '19.00', '153.88', NULL, NULL, NULL, '2025-06-27 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (52, 0, 2, 2, 2, NULL, 'devis', '222.62', '0.00', '222.62', '42.30', '19.00', '264.92', NULL, NULL, NULL, '2025-06-12 23:00:00', '2025-04-15 18:11:37', '2025-04-15 18:11:37');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (54, 1, 20, 13, 2, '7575757575757', 'facture', '20.00', '0.01', '19.99', '0.01', '0.00', '20.00', 'fgfdgfd', '2025-06-13 23:00:00', 'fdgfdgfd', NULL, '2025-06-14 20:45:23', '2025-06-14 20:45:23');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (55, 1, 20, 15, 2, '88888888888888', 'facture', '5040.00', '100.00', '4940.00', '20.00', '0.00', '4960.00', 'aaaaaaaaa', '2025-06-13 23:00:00', 'aaaaaaaaaaaaa', NULL, '2025-06-14 22:08:56', '2025-06-14 22:08:56');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (58, 1, 21, 13, 2, '88888888888888', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '25000.00', 'dsqd', '2025-06-12 23:00:00', 'azzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', NULL, '2025-06-14 22:34:10', '2025-06-15 02:15:08');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (60, 1, 21, 16, 2, 'aaaaaaaaaaaaaaaaaaa', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '200.00', 'sdf', '2025-06-11 23:00:00', 'azzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz', NULL, '2025-06-14 22:58:26', '2025-06-15 02:18:07');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (62, 1, 20, 18, 2, 'fac8888', 'facture', '2560.00', '0.00', '2560.00', '0.00', '0.00', '2560.00', '  IBAN : FR7617515900000801892159173
   SWIFT : CEPAFRPP751 
   BANQUE : CAISSE D\'EPARGNE
   Date règlement : 16-11-2023  Mode règlement : Virement bancaire ', '2025-06-14 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €', NULL, '2025-06-15 16:57:51', '2025-06-15 16:57:51');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (64, 1, 21, 18, 2, 'fac8888', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'IBAN : FR7617515900000801892159173
   SWIFT : CEPAFRPP751 
   BANQUE : CAISSE D\'EPARGNE
   Date règlement : 16-11-2023  Mode règlement : Virement bancaire  ', '2025-06-14 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €', NULL, '2025-06-15 19:22:19', '2025-06-15 19:22:19');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (65, 1, 21, 26, 2, 'testone hanudred ', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '25000.00', 'aaaaaaaaa', '2025-06-14 23:00:00', 'aaaaaaaaaaaaaafghfgh', NULL, '2025-06-16 03:29:16', '2025-06-16 20:09:52');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (66, 1, 21, 16, 2, '1213211', 'facture', '20.00', '0.03', '19.97', '0.02', '0.00', '19.99', 'dfsdf', '2025-06-14 23:00:00', 'fdgfdgfd', NULL, '2025-06-16 03:54:55', '2025-06-16 20:10:57');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (67, 1, 21, 16, 2, '1213211', 'facture', '40.00', '0.00', '40.00', '0.00', '0.00', '40.00', 'dfsdf', '2025-06-15 23:00:00', 'fdgfdgfd', NULL, '2025-06-16 03:55:04', '2025-06-16 03:55:04');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (68, 1, 21, 16, 2, 'fac8888', 'facture', '3700.00', '0.00', '3700.00', '0.00', '0.00', '3700.00', 'sdfsdfsd', '2025-06-15 23:00:00', 'dsfsdfsdf', NULL, '2025-06-16 03:58:24', '2025-06-16 03:58:24');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (69, 1, 21, 15, 2, '88888888888888', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aaaaaa', '2025-06-15 23:00:00', 'aaaaaaaaaaaa', NULL, '2025-06-16 20:11:58', '2025-06-16 20:11:58');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (70, 1, 21, 15, 2, '88888888888888', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aaaaaa', '2025-06-15 23:00:00', '45', NULL, '2025-06-16 20:12:54', '2025-06-16 20:12:54');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (71, 1, 21, 26, 2, '88888888888888', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '25000.00', 'aaaaaaaaaaa', '2025-06-14 23:00:00', 'aaaaaaaaaaaa', NULL, '2025-06-16 20:19:58', '2025-06-16 20:51:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (72, 1, 21, 26, 2, 'fac88888', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aaaaaaaaa', '2025-06-15 23:00:00', 'aaaaaaaaaaaa', NULL, '2025-06-16 21:53:23', '2025-06-16 21:53:23');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (73, 1, 21, 26, 2, 'test11', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aaaaaaaaaa', '2025-06-15 23:00:00', 'aaaaaaaaaaaaaaaaaa', NULL, '2025-06-16 22:35:25', '2025-06-16 22:35:25');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (74, 1, 21, 26, 2, 'test12', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aaaaaa', '2025-06-15 23:00:00', 'aaaaaaaaaaaaa', NULL, '2025-06-16 22:41:08', '2025-06-16 22:41:08');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (75, 1, 21, 26, 2, 'test13', 'facture', '20.00', '0.00', '20.00', '0.01', '0.00', '20.01', 'aaaa', '2025-06-15 23:00:00', 'aaaaa', NULL, '2025-06-16 22:44:32', '2025-06-16 22:44:32');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (76, 1, 21, 26, 2, 'test13', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-15 23:00:00', 'a', NULL, '2025-06-16 23:35:09', '2025-06-16 23:35:09');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (77, 1, 21, 26, 2, '88888888888888', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-16 23:00:00', 'a', NULL, '2025-06-17 00:09:43', '2025-06-17 00:09:43');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (78, 1, 21, 26, 2, '1213211', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aa', '2025-06-16 23:00:00', 'a', NULL, '2025-06-17 00:14:20', '2025-06-17 00:14:20');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (79, 1, 21, 26, 2, 'fac8888', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'a', '2025-06-16 23:00:00', 'a', NULL, '2025-06-17 00:14:44', '2025-06-17 00:14:44');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (80, 1, 21, 26, 2, '1213211', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-16 23:00:00', 'a', NULL, '2025-06-17 00:21:56', '2025-06-17 00:21:56');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (81, 1, 21, 15, 2, '1213211', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-16 23:00:00', 'a', NULL, '2025-06-17 05:19:51', '2025-06-17 05:19:51');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (82, 1, 21, 26, 2, '1213211', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-16 23:00:00', 'a', NULL, '2025-06-17 06:33:09', '2025-06-17 06:33:09');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (83, 1, 21, 11, 2, 'xcvxc', 'devis', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 's', '2025-06-16 23:00:00', 's', NULL, '2025-06-17 06:57:26', '2025-06-17 06:57:26');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (84, 1, 21, 26, 2, 'fac8888', 'facture', '3700.00', '0.03', '3699.97', '200.00', '0.00', '3899.97', 'aaa', '2025-06-16 23:00:00', 'aaaaaa', NULL, '2025-06-17 20:31:12', '2025-06-17 20:31:12');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (85, 1, 21, 18, 2, 'fac8888', 'facture', '2520.00', '0.00', '2520.00', '0.00', '0.00', '2520.00', 'aa', '2025-06-16 23:00:00', 'aaa', NULL, '2025-06-17 20:32:07', '2025-06-17 20:32:07');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (86, 1, 21, 13, 2, 'fac8888', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aaaa', '2025-06-17 23:00:00', 'aaaa', NULL, '2025-06-18 17:32:16', '2025-06-18 17:32:16');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (87, 1, 21, 13, 2, 'fac8888', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aaa', '2025-06-17 23:00:00', 'aaaa', NULL, '2025-06-18 17:32:46', '2025-06-18 17:32:46');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (88, 1, 21, 13, 2, 'fac88889', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aaa', '2025-06-17 23:00:00', 'aaaa', NULL, '2025-06-18 17:33:43', '2025-06-18 17:33:43');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (89, 1, 21, 13, 2, 'fac88889', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aaaa', '2025-06-17 23:00:00', 'aaaaa', NULL, '2025-06-18 17:35:05', '2025-06-18 17:35:05');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (90, 1, 21, 13, 2, 'fac88889', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aaaa', '2025-06-17 23:00:00', 'aaaaa', NULL, '2025-06-18 17:35:43', '2025-06-18 17:35:43');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (91, 1, 21, 13, 2, 'dsfsdf', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aaa', '2025-06-17 23:00:00', 'a', NULL, '2025-06-18 17:36:22', '2025-06-18 17:36:22');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (92, 1, 21, 13, 2, 'dsfsdf', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '200.00', 'aaa', '2025-06-16 23:00:00', 'aa', NULL, '2025-06-18 17:36:34', '2025-06-18 18:22:57');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (93, 1, 21, 13, 2, 'test', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aaa', '2025-06-17 23:00:00', 'aaa', NULL, '2025-06-18 17:37:24', '2025-06-18 17:37:24');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (94, 1, 21, 18, 2, 'wassim', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '200.00', 'aa', '2025-06-16 23:00:00', 'aa', NULL, '2025-06-18 17:53:49', '2025-06-18 19:02:55');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (95, 1, 21, 18, 2, 'hello ', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '200.00', 'aa', '2025-06-16 23:00:00', 'aa', NULL, '2025-06-18 17:54:48', '2025-06-18 19:36:50');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (96, 1, 21, 26, 2, 'wassimtest', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aa', '2025-06-17 23:00:00', 'aaa', NULL, '2025-06-18 19:39:53', '2025-06-18 19:39:53');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (97, 1, 21, 18, 2, 'aaaadsd', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aa', '2025-06-17 23:00:00', 'aaa', NULL, '2025-06-18 20:52:08', '2025-06-18 20:52:08');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (98, 1, 22, 11, 2, 'azaza', 'devis', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aa', '2025-06-18 23:00:00', 'aa', NULL, '2025-06-19 01:38:57', '2025-06-19 17:40:26');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (99, 1, 21, 15, 2, 'aaaadsd', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'a', '2025-06-18 23:00:00', 'a', NULL, '2025-06-19 19:53:46', '2025-06-19 19:53:46');

-- Table structure for table `remplissage_products`
DROP TABLE IF EXISTS `remplissage_products`;
CREATE TABLE `remplissage_products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `remplissage_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `ref` int DEFAULT NULL,
  `tva` decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `remplissage_id` (`remplissage_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `fk_remplissage_products_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_remplissage_products_remplissage` FOREIGN KEY (`remplissage_id`) REFERENCES `remplissage` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `remplissage_products`
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (1, 54, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (2, 55, 9, 2, '20.00', '', '40.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (3, 55, 2, 2, '2500.00', '', '5000.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (6, 58, 2, 1, '2500.00', 'unité', '2500.00', 54, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (8, 60, 9, 1, '20.00', 'unité', '20.00', 56, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (10, 62, 9, 3, '20.00', '', '60.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (11, 62, 2, 1, '2500.00', '', '2500.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (12, 64, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (16, 67, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (17, 67, 9, 1, '20.00', '', '20.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (18, 68, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (19, 68, 1, 1, '1200.00', '', '1200.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (20, 65, 2, 1, '2500.00', 'unité', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (21, 66, 9, 1, '20.00', 'unité', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (22, 66, 9, 1, '20.00', 'unité', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (23, 69, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (24, 70, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (26, 71, 2, 1, '2500.00', 'unité', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (27, 72, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (28, 73, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (29, 74, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (30, 75, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (31, 76, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (32, 77, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (33, 78, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (34, 79, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (35, 80, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (36, 81, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (37, 82, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (38, 83, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (39, 84, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (40, 84, 1, 1, '1200.00', '', '1200.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (41, 85, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (42, 85, 9, 1, '20.00', '', '20.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (43, 86, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (44, 87, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (45, 88, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (46, 89, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (47, 90, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (48, 91, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (50, 93, 9, 1, '20.00', '', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (53, 92, 9, 1, '20.00', 'unité', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (54, 94, 9, 1, '20.00', 'unité', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (55, 95, 9, 1, '20.00', 'unité', '20.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (56, 96, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (57, 97, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (58, 98, 2, 1, '2500.00', '', '2500.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (59, 99, 2, 1, '2500.00', '', '2500.00', 1, '20.00');

-- Table structure for table `subcategories`
DROP TABLE IF EXISTS `subcategories`;
CREATE TABLE `subcategories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `subcategories`
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (1, 1, 'Ordinateurs');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (2, 1, 'Téléphones');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (8, 13, 'aaa');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (9, 13, 'bbb');

-- Table structure for table `templates`
DROP TABLE IF EXISTS `templates`;
CREATE TABLE `templates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('predefined','custom') NOT NULL,
  `created_by` int DEFAULT NULL,
  `html_structure` text,
  `design_config` json DEFAULT NULL,
  `preview_image_path` varchar(255) DEFAULT NULL,
  `doc_type` enum('facture','devis') DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isdeleted` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `templates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `templates`
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (11, 'devis perosnliséé', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>devis perosnliséé</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 100px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Texte personnalisé</div><div class="template-element" style="
          position: absolute;
          left: 209.5px;
          top: 297px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_address">{{company_address}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'devis', '2025-06-13 02:48:35', '2025-06-13 02:48:35', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (12, 'devis eprson 2', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>devis eprson 2</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 247.5px;
          top: 410px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_phone">{{company_phone}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'devis', '2025-06-13 02:48:56', '2025-06-13 02:48:56', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (13, 'facture perso', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>facture perso</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 100px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Texte personnalisé</div><div class="template-element" style="
          position: absolute;
          left: 181.5px;
          top: 386px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_phone">{{company_phone}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-13 02:49:28', '2025-06-13 02:49:28', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (14, 'facture perosn 2', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>facture perosn 2</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 222.5px;
          top: 341px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_phone">{{company_phone}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-13 02:49:45', '2025-06-13 02:49:45', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (15, 'fac predefined 1 ', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>fac predefined 1 </title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 100px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Texte personnalisé</div><div class="template-element" style="
          position: absolute;
          left: 312px;
          top: 231px;
          color: undefined;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="logo"><img src="/src/assets/logo.jpg" alt="Logo" style="width: 100px;"></div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-13 02:52:02', '2025-06-13 02:52:02', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (16, 'fac prede 2', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>fac prede 2</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 234px;
          top: 355px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_siret">{{company_siret}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-13 02:52:19', '2025-06-13 02:52:19', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (17, 'devis predefined', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>devis predefined</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 100px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Texte personnalisé</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'devis', '2025-06-13 02:52:57', '2025-06-13 02:52:57', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (18, 'template facture reel', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>template facture reel</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 37.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_name">{{company_name}}</div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 92.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_address">{{company_address}}</div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 149.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_email">{{company_email}}</div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 204.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_siret">{{company_siret}}</div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 261.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_phone">{{company_phone}}</div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 339.37152099609375px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_number">{{document_number}}</div><div class="template-element" style="
          position: absolute;
          left: -0.11114501953125px;
          top: 369.37152099609375px;
          color: #000000;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="divider_3">undefined</div><div class="template-element" style="
          position: absolute;
          left: 617.8888549804688px;
          top: 339.37152099609375px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div><div class="template-element" style="
          position: absolute;
          left: 617.8888549804688px;
          top: 411.9270839691162px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_address">{{client_address}}</div><div class="template-element" style="
          position: absolute;
          left: 617.8888549804688px;
          top: 458.70484924316406px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_phone">{{client_phone}}</div><div class="template-element" style="
          position: absolute;
          left: 617.8888549804688px;
          top: 505.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_email">{{client_email}}</div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 535.1492919921875px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: undefined;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #000000;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div><div class="template-element" style="
          position: absolute;
          left: 49.88885498046875px;
          top: 689.2604141235352px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f8f8ff;
          padding: 5px;
        " data-element-id="bank_info"></div><div class="template-element" style="
          position: absolute;
          left: 23.88885498046875px;
          top: 897.0381927490234px;
          color: #000000;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="divider_5">undefined</div><div class="template-element" style="
          position: absolute;
          left: -0.11114501953125px;
          top: 940.0381927490234px;
          color: #cc0000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #fff8f8;
          padding: 5px;
        " data-element-id="warning">En cas de retard de paiement, une pénalité de 10% sera appliquée.</div><div class="template-element" style="
          position: absolute;
          left: 649.8888549804688px;
          top: 689.2604141235352px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_ht">{{total_ht}}</div><div class="template-element" style="
          position: absolute;
          left: 649.8888549804688px;
          top: 735.1492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_discount">{{total_discount}}</div><div class="template-element" style="
          position: absolute;
          left: 649.8888549804688px;
          top: 788.1493072509766px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_net_ht">{{total_net_ht}}</div><div class="template-element" style="
          position: absolute;
          left: 649.8888549804688px;
          top: 835.6492919921875px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="tva">{{tva}}</div><div class="template-element" style="
          position: absolute;
          left: 649.8888549804688px;
          top: 869.5381927490234px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_ttc">{{total_ttc}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-15 16:55:07', '2025-06-15 16:55:07', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (19, 'factrue reel 2 ', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>factrue reel 2 </title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 275.88885498046875px;
          top: 368.70484924316406px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_name">{{company_name}}</div><div class="template-element" style="
          position: absolute;
          left: 42.88885498046875px;
          top: 38.70484924316406px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: undefined;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #000000;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-15 17:43:08', '2025-06-15 17:43:08', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (20, '2', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>2</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 100px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Texte personnalisé</div><div class="template-element" style="
          position: absolute;
          left: 127.5px;
          top: 230px;
          color: #cc0000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #fff8f8;
          padding: 5px;
        " data-element-id="warning">En cas de retard de paiement, une pénalité de 10% sera appliquée.</div><div class="template-element" style="
          position: absolute;
          left: 51.5px;
          top: 157px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f8f8ff;
          padding: 5px;
        " data-element-id="bank_info">IBAN: FR76 XXXX XXXX XXXX XXXX XXXX XXX
BIC: XXXXXXXX
Banque: Nom de la banque</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-15 20:08:47', '2025-06-15 20:08:47', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (21, '4', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>4</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 100px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Texte personnalisé</div><div class="template-element" style="
          position: absolute;
          left: 234.5px;
          top: 231px;
          color: #cc0000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #fff8f8;
          padding: 5px;
        " data-element-id="warning">{{warning}}</div><div class="template-element" style="
          position: absolute;
          left: 461.5px;
          top: 165px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f8f8ff;
          padding: 5px;
        " data-element-id="bank_info">{{bank_info}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-15 20:16:49', '2025-06-15 20:16:49', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (22, 'test taille', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test taille</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: -2.5px;
          top: -20px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: undefined;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #000000;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row4">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row4">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row4">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row4">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row4">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row4">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row5">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row5">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row5">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row5">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row5">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row5">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row6">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row6">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row6">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row6">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row6">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row6">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row7">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row7">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row7">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row7">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row7">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row7">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row8">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row8">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row8">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row8">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row8">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row8">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row9">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row9">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row9">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row9">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row9">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row9">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div><div class="template-element" style="
          position: absolute;
          left: 28.5px;
          top: 705px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_discount">{{total_discount}}</div><div class="template-element" style="
          position: absolute;
          left: 28.5px;
          top: 762px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_ht">{{total_ht}}</div><div class="template-element" style="
          position: absolute;
          left: 28.5px;
          top: 1652px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_ttc">{{total_ttc}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-15 21:35:17', '2025-06-15 21:35:17', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (23, 'wassim', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>wassim</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: -2.5px;
          top: 0px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: undefined;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #000000;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div><div class="template-element" style="
          position: absolute;
          left: -2.5px;
          top: 157px;
          color: undefined;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="logo"><img src="/src/assets/logo.jpg" alt="Logo" style="width: 100px;"></div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-15 22:01:24', '2025-06-15 22:01:24', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (24, 'testbank', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>testbank</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 176.5px;
          top: 179px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f8f8ff;
          padding: 5px;
        " data-element-id="bank_info">{{bank_info}}</div><div class="template-element" style="
          position: absolute;
          left: 282.5px;
          top: 240px;
          color: #cc0000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #fff8f8;
          padding: 5px;
        " data-element-id="warning">{{warning}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-16 02:35:47', '2025-06-16 02:35:47', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (25, 'test tabeleau', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test tabeleau</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: 2.8853759765625px;
          top: -5.62847900390625px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: undefined;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #000000;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-16 03:18:02', '2025-06-16 03:18:02', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (26, 'test tableau 2', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test tableau 2</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 20px;
            }
            .template-element {
              position: absolute;
            }
          </style>
        </head>
        <body>
          <div class="template-container">
      <div class="template-element" style="
          position: absolute;
          left: -0.1146240234375px;
          top: 5.482635498046875px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: undefined;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #000000;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #f0f0f0; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #000000; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-16 03:19:02', '2025-06-16 03:19:02', NULL);

-- Table structure for table `users`
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','enterprise_admin','client') NOT NULL,
  `verification_code` varchar(6) NOT NULL,
  `verification_code_expired` datetime NOT NULL,
  `reset_code` varchar(6) DEFAULT NULL,
  `reset_code_expired` datetime DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `isActive` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `users`
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (1, 'douaa', 'guetlani', 'wisoghost@gmail.com', 'Wassim123@', 'client', '162473', '2025-03-24 04:59:05', '424137', '2025-04-16 11:19:26', 1, '2025-03-23 04:59:04', NULL);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (2, 'wassim', 'bannour', 'wassbennour123@gmail.com', 'Wassim123@', 'enterprise_admin', '683464', '2025-04-06 15:57:09', NULL, NULL, 1, '2025-04-05 15:57:08', NULL);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (3, 'anwer', 'anwer', 'wassbennour789@gmail.com', 'Wassim123@', 'admin', '000000', '2025-05-08 00:48:36', NULL, NULL, 1, '2025-05-07 00:48:36', NULL);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (21, 'farah', 'gdaim', 'wassbennour456@gmail.com', 'Wassim123@', 'client', '142775', '2025-06-20 18:53:06', NULL, NULL, 1, '2025-06-19 18:53:06', 1);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (22, 'wissem', 'messous', 'wissemmessous@gmail.com', 'Wassim123@', 'enterprise_admin', '542277', '2025-06-20 18:56:54', NULL, NULL, 1, '2025-06-19 18:56:53', 1);


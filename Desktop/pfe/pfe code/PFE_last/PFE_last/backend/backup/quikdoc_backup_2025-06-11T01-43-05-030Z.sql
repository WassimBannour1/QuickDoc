-- QuikDoc Database Backup
-- Generated: 2025-06-11T01:43:05.049Z
-- ------------------------------------------------------

-- Table structure for table `categories`
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `owner_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `categories`
INSERT INTO `categories` (`id`, `name`, `owner_id`) VALUES (1, 'Électronique', '2');

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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `clients`
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (1, NULL, 1, 'Ali', 'Ben Ali', 'ali@example.com', '+21612345678', '123 Rue de Tunis', '2025-04-12 14:05:11', NULL);
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (2, NULL, 2, 'Sana', 'Trabelsi', 'sana@example.com', '+21623456789', '456 Avenue Bourguiba', '2025-04-12 14:05:11', NULL);
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (19, NULL, 2, 'ahmed', 'mrabet', 'wisoghost@gmail.com', '94101910', 'qsdgdsfertrrraa', '2025-06-11 01:29:37', '14042839');

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `document`
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (1, 1, 'uploads/documents/1.pdf', '2025-04-12 13:55:37', 'non envoyée');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`) VALUES (2, 2, 'uploads/documents/2.pdf', '2025-04-12 13:55:37', 'Non envoyé');

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `entreprises`
INSERT INTO `entreprises` (`id`, `siret`, `owner_id`, `nom_entreprise`, `email_entreprise`, `logo_path`, `pays`, `ville`, `adresse`, `code_postal`, `devise`, `secteur_activite`, `telephone`, `created_at`, `updated_at`) VALUES (1, '12345678912346', 2, 'isimmmsq', 'wasss@gmail.comdfdfgaaaa', 'isimmmsq-12345678912346.jpg', 'Tunisiedsfsdfaaa', 'sqdsqaa', 'qsdgdsfertrrraa', '5099', 'EUR', 'qsdsqdsq212aaadsffdgaa', '9410191065', '2025-05-08 19:48:59', '2025-05-09 01:41:50');

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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `products`
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (1, 1, 'Laptop HP', 'Ordinateur portable HP 15.6"', '1200.00', 'unité', 10, 1);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (2, 1, 'iPhone 14', 'Smartphone Apple 128Go', '2500.00', 'unité', 4, 1);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (9, 2, 'velo', 'new velo ', '20.00', 'pièce', 3, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `remplissage`
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (1, 0, 1, 1, 2, '754', 'facture', '500.00', '0.00', '500.00', '100.00', '20.00', '600.00', NULL, NULL, NULL, '2025-05-14 23:00:00', '2025-04-12 13:52:01', '2025-06-05 21:53:26');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (2, 0, 1, 2, 2, NULL, 'devis', '300.00', '0.00', '300.00', '60.00', '20.00', '360.00', NULL, NULL, NULL, NULL, '2025-04-12 13:52:01', '2025-04-17 14:32:19');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (3, 0, 1, 1, 2, NULL, 'devis', '100.00', '0.00', '100.00', '19.00', '19.00', '119.00', NULL, NULL, NULL, '2025-04-30 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (5, 0, 1, 2, 2, NULL, 'devis', '150.00', '0.00', '150.00', '28.50', '19.00', '178.50', NULL, NULL, NULL, '2025-05-09 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (6, 0, 2, 2, 2, NULL, 'facture', '300.00', '0.00', '300.00', '57.00', '19.00', '357.00', NULL, NULL, NULL, '2025-05-11 23:00:00', '2025-04-15 16:25:38', '2025-04-15 16:25:38');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Table structure for table `subcategories`
DROP TABLE IF EXISTS `subcategories`;
CREATE TABLE `subcategories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `subcategories`
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (1, 1, 'Ordinateurs');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (2, 1, 'Téléphones');

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
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `isdeleted` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `templates_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `templates`
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `created_at`, `updated_at`, `isdeleted`) VALUES (5, 'test1', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test1</title>
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
          left: 217.5px;
          top: 174px;
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
          left: 320.5px;
          top: 374px;
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
      ', '[object Object]', NULL, '2025-06-06 02:48:51', '2025-06-06 02:48:51', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `created_at`, `updated_at`, `isdeleted`) VALUES (6, 'test2', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test2</title>
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
          left: 369.5px;
          top: 273px;
          color: undefined;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="logo"><img src="/src/assets/logo.jpg" alt="Logo" style="width: 100px;"></div><div class="template-element" style="
          position: absolute;
          left: 173.5px;
          top: 397px;
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
      ', '[object Object]', NULL, '2025-06-06 02:49:19', '2025-06-06 02:49:19', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `created_at`, `updated_at`, `isdeleted`) VALUES (7, 'test3', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test3</title>
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
          left: 422.5px;
          top: 196px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_2">Texte personnalisé</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, '2025-06-06 02:50:09', '2025-06-06 02:50:09', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `created_at`, `updated_at`, `isdeleted`) VALUES (8, 'test4', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test4</title>
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
          left: 394.5px;
          top: 27px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_2">Texte personnalisé</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, '2025-06-06 02:50:36', '2025-06-06 02:50:36', NULL);

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
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `users`
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (1, 'wass', 'banno', 'wisoghost@gmail.com', 'Wassim123@', 'client', '162473', '2025-03-24 04:59:05', '424137', '2025-04-16 11:19:26', 1, '2025-03-23 04:59:04');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (2, 'wassim', 'bannour', 'wassbennour123@gmail.com', 'Wassim123@', 'enterprise_admin', '683464', '2025-04-06 15:57:09', NULL, NULL, 1, '2025-04-05 15:57:08');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (3, 'Wassim', 'Banno', 'wassbennour789@gmail.com', 'Wassim123@', 'admin', '000000', '2025-05-08 00:48:36', NULL, NULL, 1, '2025-05-07 00:48:36');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (12, 'wassdq', 'sqdsq', 'wassbennour456@gmail.com', 'Wassim123@', 'enterprise_admin', '938255', '2025-04-15 01:42:15', NULL, NULL, 1, '2025-04-14 01:42:14');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (15, 'tawfik ', 'sakka', 'at@gmail.com', 'Wassim123@', 'enterprise_admin', '831109', '2025-04-17 10:51:20', NULL, NULL, 1, '2025-04-16 10:51:19');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (18, 'test', 'test', 'wassbennour876@gmail.com', 'Wassim123@', 'client', '840084', '2025-05-09 19:31:40', NULL, NULL, 1, '2025-05-08 19:31:39');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (19, 'test', 'test2', 'wassbennour693@gmail.com', 'Wassim123@', 'enterprise_admin', '604635', '2025-05-09 19:32:59', NULL, NULL, 1, '2025-05-08 19:32:59');
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`) VALUES (20, 'test2', 'test2', 'wassbennour4545@gmail.com', 'Wassim123@', 'enterprise_admin', '987973', '2025-05-09 19:48:59', NULL, NULL, 0, '2025-05-08 19:48:59');


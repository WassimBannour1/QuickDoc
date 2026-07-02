-- QuikDoc Database Backup
-- Generated: 2025-06-23T05:09:35.970Z
-- ------------------------------------------------------

-- Table structure for table `categories`
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `owner_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `categories`
INSERT INTO `categories` (`id`, `name`, `owner_id`) VALUES (15, 'Électronique	', '22');
INSERT INTO `categories` (`id`, `name`, `owner_id`) VALUES (16, 'Bureautique', '22');
INSERT INTO `categories` (`id`, `name`, `owner_id`) VALUES (17, 'Alimentaire', '22');

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
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `clients`
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (29, 22, 1, 'douaa', 'guetlani', 'wisoghost@gmail.com', '94101910', 'tunisai monastir', '2025-06-21 13:02:02', '111111');
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (31, 22, NULL, 'john', 'doae', 'johndoae@gmail.com', '745465546', 'tunisie monastir', '2025-06-22 17:49:48', '123456789');
INSERT INTO `clients` (`id`, `owner_id`, `user_id`, `name`, `last_name`, `email`, `phone`, `address`, `created_at`, `CIN`) VALUES (32, 22, 21, 'farah', 'gdaim', 'wassbennour456@gmail.com', '94101910', 'tunisie monastir', '2025-06-22 17:50:05', '98646536146');

-- Table structure for table `document`
DROP TABLE IF EXISTS `document`;
CREATE TABLE `document` (
  `id` int NOT NULL AUTO_INCREMENT,
  `remplissage_id` int NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(450) DEFAULT NULL,
  `status_client` varchar(450) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `remplissage_id` (`remplissage_id`),
  CONSTRAINT `document_ibfk_1` FOREIGN KEY (`remplissage_id`) REFERENCES `remplissage` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `document`
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (1, 1, 'uploads/documents/1.pdf', '2025-04-12 13:55:37', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (2, 2, 'uploads/documents/2.pdf', '2025-04-12 13:55:37', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (3, 3, 'uploads/documents/2.pdf', '2025-04-12 13:55:38', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (7, 80, 'uploads/documents/1750119930690_Facture_1213211.pdf', '2025-06-17 00:25:30', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (8, 81, 'uploads/documents/1750137594413_Facture_1213211.pdf', '2025-06-17 05:19:54', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (9, 81, 'uploads/documents/1750138098559_Facture_1213211.pdf', '2025-06-17 05:28:18', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (10, 82, 'uploads/documents/1750141993188_Facture_1213211.pdf', '2025-06-17 06:33:13', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (11, 85, 'uploads/documents/1750192372881_Facture_fac8888.pdf', '2025-06-17 20:32:52', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (12, 90, 'uploads/documents/1750268150785_Facture_fac88889.pdf', '2025-06-18 17:35:50', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (13, 92, 'uploads/documents/1750268197202_Facture_dsfsdf.pdf', '2025-06-18 17:36:37', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (14, 93, 'uploads/documents/1750268249039_Facture_test.pdf', '2025-06-18 17:37:29', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (15, 95, 'uploads/documents/1750269330125_Facture_hello .pdf', '2025-06-18 17:55:30', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (16, 87, 'uploads/documents/1750275417487_Facture_fac8888.pdf', '2025-06-18 19:36:57', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (17, 95, 'uploads/documents/1750275503627_Facture_hello .pdf', '2025-06-18 19:38:23', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (18, 96, 'uploads/documents/1750275596384_Facture_wassimtest.pdf', '2025-06-18 19:39:56', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (19, 93, 'uploads/documents/1750275704764_Facture_test.pdf', '2025-06-18 19:41:44', 'Non envoyé', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (20, 97, 'uploads/documents/1750279932713_Facture_aaaadsd.pdf', '2025-06-18 20:52:12', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (21, 91, 'uploads/documents/1750297105523_Facture_dsfsdf.pdf', '2025-06-19 01:38:25', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (22, 98, 'uploads/documents/1750297149027_Devis_aaaadsd.pdf', '2025-06-19 01:39:09', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (23, 99, 'uploads/documents/1750362829103_Facture_aaaadsd.pdf', '2025-06-19 19:53:49', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (24, 102, 'uploads/documents/1750375077496_Facture_test1.pdf', '2025-06-19 23:17:57', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (25, 100, 'uploads/documents/1750375523537_Facture_aaaadsd.pdf', '2025-06-19 23:25:23', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (26, 103, 'uploads/documents/1750384399220_Facture_testfinal.pdf', '2025-06-20 01:53:19', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (27, 105, 'uploads/documents/1750504909690_Facture_now.pdf', '2025-06-21 11:21:49', 'non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (28, 104, 'uploads/documents/1750505643866_Facture_now.pdf', '2025-06-21 11:34:03', 'Non envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (29, 107, 'uploads/documents/1750506549020_Facture_testchnage document.pdf', '2025-06-21 11:49:09', 'Non payée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (30, 108, 'uploads/documents/1750507869068_Facture_envoye.pdf', '2025-06-21 12:11:09', 'envoyée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (31, 110, 'uploads/documents/1750508727585_Facture_facture.pdf', '2025-06-21 12:25:27', 'Non payée', NULL);
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (37, 116, 'uploads/documents/1750614695617_Devis_devis1.pdf', '2025-06-22 17:51:35', 'Envoyée', 'pending');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (38, 117, 'uploads/documents/1750617138804_Facture_facture.pdf', '2025-06-22 18:32:18', 'Non payée', 'unpaid');
INSERT INTO `document` (`id`, `remplissage_id`, `file_path`, `created_at`, `status`, `status_client`) VALUES (39, 118, 'uploads/documents/1750617205118_Facture_facture2.pdf', '2025-06-22 18:33:25', 'Non payée', 'unpaid');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `entreprises`
INSERT INTO `entreprises` (`id`, `siret`, `owner_id`, `nom_entreprise`, `email_entreprise`, `logo_path`, `pays`, `ville`, `adresse`, `code_postal`, `devise`, `secteur_activite`, `telephone`, `created_at`, `updated_at`) VALUES (1, '12345678912346', 2, 'tayara', 'wasss@gmail.comdfdfgaaaa', NULL, 'Tunisiedsfsdfaaa', 'sqdsqaa', 'qsdgdsfertrrraa', '5099', 'EUR', 'qsdsqdsq212aaadsffdgaa', '9410191065', '2025-05-08 19:48:59', '2025-06-19 21:06:00');
INSERT INTO `entreprises` (`id`, `siret`, `owner_id`, `nom_entreprise`, `email_entreprise`, `logo_path`, `pays`, `ville`, `adresse`, `code_postal`, `devise`, `secteur_activite`, `telephone`, `created_at`, `updated_at`) VALUES (3, '12345678910123', 22, 'messoustechnology', 'wissemmessous@gmail.com', NULL, 'Tunisie', 'monastir', 'bekalta', '5090', 'TND', 'business', '98465458', '2025-06-19 18:56:53', '2025-06-22 06:52:48');
INSERT INTO `entreprises` (`id`, `siret`, `owner_id`, `nom_entreprise`, `email_entreprise`, `logo_path`, `pays`, `ville`, `adresse`, `code_postal`, `devise`, `secteur_activite`, `telephone`, `created_at`, `updated_at`) VALUES (4, '12345678910111', 24, 'technlogyit', NULL, NULL, NULL, NULL, NULL, NULL, 'TND', NULL, NULL, '2025-06-23 04:04:29', '2025-06-23 04:04:29');

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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `products`
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (13, 22, 'iPhone 14', 'Smartphone Apple avec écran Retina', '999.99', 'pièce', 10, 10);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (14, 22, 'MacBook Air M2', 'Ordinateur portable Apple 13"', '1249.00', 'pièce', 4, 11);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (15, 22, 'Agrafeuse', 'Agrafeuse métallique pour usage bureautique', '9.50', 'pièce', 50, 12);
INSERT INTO `products` (`id`, `owner_id`, `name`, `description`, `unit_price`, `unit`, `stock_quantity`, `subcategory_id`) VALUES (16, 22, ' Snacks', 'Snack sucré emballé individuellement', '1.20', 'pièce', 3, 13);

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
) ENGINE=InnoDB AUTO_INCREMENT=126 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `remplissage`
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (1, 1, 22, 1, 2, '754', 'facture', '500.00', '0.00', '500.00', '100.00', '20.00', '600.00', NULL, NULL, NULL, '2025-05-14 23:00:00', '2025-04-12 13:52:01', '2025-06-19 02:48:05');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (2, 1, 22, 2, 2, '777', 'devis', '300.00', '0.00', '300.00', '60.00', '20.00', '360.00', NULL, NULL, NULL, NULL, '2025-04-12 13:52:01', '2025-06-19 02:47:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (3, 0, 22, 1, 2, '777', 'devis', '100.00', '0.00', '100.00', '19.00', '19.00', '119.00', NULL, NULL, NULL, '2025-04-30 23:00:00', '2025-04-15 16:25:38', '2025-06-19 02:47:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (5, 0, 22, 2, 2, NULL, 'devis', '150.00', '0.00', '150.00', '28.50', '19.00', '178.50', NULL, NULL, NULL, '2025-05-09 23:00:00', '2025-04-15 16:25:38', '2025-06-19 02:47:18');
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
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (100, 1, 22, 30, 2, 'aaaadsd', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 's', '2025-06-18 23:00:00', 's', NULL, '2025-06-19 22:20:23', '2025-06-19 23:24:58');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (102, 1, 22, 18, 2, 'test1', 'facture', '1.00', '0.00', '1.00', '0.00', '0.00', '10.00', 'aa', '2025-05-26 23:00:00', 'aa', NULL, '2025-06-19 23:16:39', '2025-06-19 23:17:20');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (103, 1, 24, 36, 2, 'testfinal', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'a', '2025-06-19 23:00:00', 'a', NULL, '2025-06-20 01:53:16', '2025-06-20 01:53:16');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (104, 1, 24, 18, 2, 'wpwpwpwpw', 'facture', '2520.00', '0.00', '2520.00', '0.00', '0.00', '2520.00', 'a', '2025-06-20 23:00:00', 'a', NULL, '2025-06-21 11:20:13', '2025-06-21 12:00:00');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (105, 1, 24, 18, 2, 'now', 'facture', '2520.00', '0.00', '2520.00', '0.00', '0.00', '2520.00', 'a', '2025-06-20 23:00:00', 'a', NULL, '2025-06-21 11:20:18', '2025-06-21 11:20:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (106, 1, 24, 18, 2, 'testfor faut', 'facture', '2520.00', '0.00', '2520.00', '0.00', '0.00', '2520.00', 'a', '2025-06-20 23:00:00', 'a', NULL, '2025-06-21 11:24:12', '2025-06-21 11:24:12');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (107, 1, 24, 18, 2, 'testchnage document', 'facture', '2520.00', '0.00', '2520.00', '0.00', '0.00', '2520.00', 'aa', '2025-06-20 23:00:00', 'aaa', NULL, '2025-06-21 11:49:01', '2025-06-21 11:49:01');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (108, 1, 24, 18, 2, 'envoye', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-20 23:00:00', 'a', NULL, '2025-06-21 12:11:03', '2025-06-21 12:11:03');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (109, 1, 24, 34, 2, 'a', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aa', '2025-06-20 23:00:00', 'aa', NULL, '2025-06-21 12:16:15', '2025-06-21 12:16:15');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (110, 1, 24, 18, 2, 'facture', 'facture', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'a', '2025-06-20 23:00:00', 'a', NULL, '2025-06-21 12:25:24', '2025-06-21 12:25:24');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (111, 1, 24, 11, 2, 'devis', 'devis', '20.00', '0.00', '20.00', '0.00', '0.00', '20.00', 'aa', '2025-06-20 23:00:00', 'aa', NULL, '2025-06-21 12:26:20', '2025-06-21 12:26:20');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (112, 1, 29, 18, 2, 'testfactrueoduaa', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aa', '2025-06-20 23:00:00', 'aa', NULL, '2025-06-21 13:07:12', '2025-06-21 13:07:12');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (113, 1, 29, 17, 2, 'devistestdouaa', 'devis', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'aa', '2025-06-20 23:00:00', 'aa', NULL, '2025-06-21 13:07:50', '2025-06-21 13:07:50');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (114, 1, 24, 18, 2, 'douaa', 'facture', '2500.00', '0.00', '2500.00', '0.00', '0.00', '2500.00', 'j', '2025-06-20 23:00:00', 'j', NULL, '2025-06-21 22:31:48', '2025-06-21 22:31:48');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (115, 3, 24, 35, 22, 'fac8888', 'devis', '999.99', '0.00', '999.99', '0.00', '0.00', '999.99', 'aaa', '2025-06-21 23:00:00', 'aaaa', NULL, '2025-06-22 13:27:55', '2025-06-22 13:27:55');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (116, 3, 29, 48, 22, 'devis1', 'devis', '1001.19', '0.00', '1001.19', '0.00', '0.00', '1001.19', 'iban:123456789', '2025-06-21 23:00:00', 'attention', NULL, '2025-06-22 17:51:28', '2025-06-22 17:51:28');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (117, 3, 29, 49, 22, 'facture', 'facture', '1250.20', '0.00', '1250.20', '0.00', '0.00', '1250.20', ' IBAN : FR7617515900000801892159173', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:32:00', '2025-06-22 18:32:00');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (118, 3, 29, 51, 22, 'facture2', 'facture', '1001.19', '0.00', '1001.19', '0.00', '0.00', '1001.19', '  IBAN : FR7617515900000801892159173', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:33:18', '2025-06-22 18:33:18');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (119, 3, 29, 51, 22, 'fac1548', 'facture', '9.50', '0.00', '9.50', '0.00', '0.00', '9.50', '  IBAN : FR7617515900000801892159173', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:34:04', '2025-06-22 18:34:04');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (120, 3, 29, 48, 22, 'devis65461', 'devis', '1.20', '0.00', '1.20', '0.00', '0.00', '1.20', 'iban:6546161465', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:34:56', '2025-06-22 18:34:56');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (121, 3, 29, 48, 22, 'devis89678', 'devis', '1.20', '0.00', '1.20', '0.00', '0.00', '1.20', 'iban:6546161465', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:35:05', '2025-06-22 18:35:05');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (122, 3, 29, 48, 22, 'devis45242', 'devis', '1.20', '0.00', '1.20', '0.00', '0.00', '1.20', 'iban:6546161465', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:35:15', '2025-06-22 18:35:15');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (123, 3, 29, 49, 22, 'fac7878', 'facture', '2248.99', '0.00', '2248.99', '0.00', '0.00', '2248.99', 'iban:9865446', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:36:27', '2025-06-22 18:36:27');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (124, 3, 29, 49, 22, 'fac9548', 'facture', '2248.99', '0.00', '2248.99', '0.00', '0.00', '2248.99', 'iban:9865446', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:36:35', '2025-06-22 18:36:35');
INSERT INTO `remplissage` (`id`, `entreprise_id`, `client_id`, `template_id`, `owner_id`, `serie_number`, `type_document`, `montant_ht`, `total_remise`, `total_net_ht`, `montant_tva`, `taux_tva`, `montant_ttc`, `details_bancaire`, `date_document`, `avertissement`, `delai_paiement`, `created_at`, `updated_at`) VALUES (125, 3, 29, 49, 22, 'fac942521', 'facture', '2248.99', '0.00', '2248.99', '0.00', '0.00', '2248.99', 'iban:9865446', '2025-06-21 23:00:00', 'En l’absence de paiement, taux de pénalité : Trois fois le taux d’intérêt légal en vigueur à la date d’émission de la facture .
 En cas de retard de paiement, indemnité forfaitaire légale pour frais de recouvrement: 40 €.', NULL, '2025-06-22 18:36:43', '2025-06-22 18:36:43');

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
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `remplissage_products`
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (83, 115, 13, 1, '999.99', '', '999.99', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (84, 116, 13, 1, '999.99', '', '999.99', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (85, 116, 16, 1, '1.20', '', '1.20', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (86, 117, 14, 1, '1249.00', '', '1249.00', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (87, 117, 16, 1, '1.20', '', '1.20', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (88, 118, 13, 1, '999.99', '', '999.99', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (89, 118, 16, 1, '1.20', '', '1.20', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (90, 119, 15, 1, '9.50', '', '9.50', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (91, 120, 16, 1, '1.20', '', '1.20', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (92, 121, 16, 1, '1.20', '', '1.20', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (93, 122, 16, 1, '1.20', '', '1.20', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (94, 123, 13, 1, '999.99', '', '999.99', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (95, 123, 14, 1, '1249.00', '', '1249.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (96, 124, 13, 1, '999.99', '', '999.99', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (97, 124, 14, 1, '1249.00', '', '1249.00', 2, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (98, 125, 13, 1, '999.99', '', '999.99', 1, '20.00');
INSERT INTO `remplissage_products` (`id`, `remplissage_id`, `product_id`, `quantity`, `unit_price`, `unit`, `total_price`, `ref`, `tva`) VALUES (99, 125, 14, 1, '1249.00', '', '1249.00', 2, '20.00');

-- Table structure for table `subcategories`
DROP TABLE IF EXISTS `subcategories`;
CREATE TABLE `subcategories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `subcategories`
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (9, NULL, 'bbb');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (10, 15, 'Smartphones');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (11, 15, 'Ordinateurs');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (12, 16, 'Fournitures de bureau	');
INSERT INTO `subcategories` (`id`, `category_id`, `name`) VALUES (13, 17, 'Snacks');

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
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
      ', '[object Object]', NULL, 'facture', '2025-06-13 02:52:02', '2025-06-22 18:39:07', 1);
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
      ', '[object Object]', NULL, 'facture', '2025-06-13 02:52:19', '2025-06-22 18:39:03', 1);
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
      ', '[object Object]', NULL, 'devis', '2025-06-13 02:52:57', '2025-06-22 18:39:01', 1);
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
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (27, 'testmulter', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>testmulter</title>
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
          left: 37.5px;
          top: 333px;
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
      ', '[object Object]', NULL, 'facture', '2025-06-19 21:47:49', '2025-06-19 22:27:46', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (28, 'testmulteradmin', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>testmulteradmin</title>
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
          left: 44px;
          top: 203px;
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
      ', '[object Object]', NULL, 'facture', '2025-06-19 21:49:35', '2025-06-22 18:38:55', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (29, 'test multer devis', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test multer devis</title>
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
          left: 124.5px;
          top: 308px;
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
      ', '[object Object]', NULL, 'devis', '2025-06-19 21:51:16', '2025-06-19 21:51:53', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (30, 'teste zone texte', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>teste zone texte</title>
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
          top: 220px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">facture:</div><div class="template-element" style="
          position: absolute;
          left: 45.5px;
          top: 304px;
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
      ', '[object Object]', NULL, 'facture', '2025-06-19 22:19:39', '2025-06-19 22:27:22', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (31, 'teste zone texte (copie)', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>teste zone texte</title>
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
          top: 220px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">facture:</div><div class="template-element" style="
          position: absolute;
          left: 45.5px;
          top: 304px;
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
      ', '[object Object]', NULL, 'facture', '2025-06-19 22:26:39', '2025-06-19 22:26:39', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (32, 'teste zone texte (copie)', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>teste zone texte</title>
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
          top: 220px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">facture:</div><div class="template-element" style="
          position: absolute;
          left: 45.5px;
          top: 304px;
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
      ', '[object Object]', NULL, 'facture', '2025-06-19 22:26:42', '2025-06-19 22:26:42', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (33, 'test tableau 2 (copie)', 'custom', 2, '
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
      ', '[object Object]', NULL, 'facture', '2025-06-19 22:28:40', '2025-06-19 22:28:40', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (34, 'test admin creation', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test admin creation</title>
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
          left: 263px;
          top: 344px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div>
          </div>
        </body>
        </html>
      ', '[object Object]', NULL, 'facture', '2025-06-20 00:36:52', '2025-06-22 18:38:52', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (35, 'test creation admin templates ', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test creation admin templates </title>
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
      ', '[object Object]', NULL, 'devis', '2025-06-20 00:38:09', '2025-06-22 18:38:49', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (36, 'a', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>a</title>
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
      ', '[object Object]', NULL, 'facture', '2025-06-20 00:47:00', '2025-06-22 06:54:46', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (37, 'test creation', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test creation</title>
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
          color: #333333;
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
          left: 139.5px;
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
        " data-element-id="bank_info">{{bank_info}}</div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f8f8ff","x":139.5,"y":179,"id":"bank_info"}],"documentType":"facture"}', NULL, 'facture', '2025-06-21 11:18:08', '2025-06-21 11:18:08', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (38, 'test creation', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test creation</title>
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
          left: 139.5px;
          top: 179px;
          color: #333333;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f8f9fa;
          padding: 5px;
        " data-element-id="bank_info">{{bank_info}}</div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f8f9fa","x":139.5,"y":179,"id":"bank_info"}],"documentType":"facture"}', NULL, 'facture', '2025-06-21 11:18:25', '2025-06-21 11:18:25', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (39, 'test creation', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test creation</title>
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
          left: 307.5px;
          top: 556px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"placeholder","label":"Nom Complet Client","icon":"fas fa-user","content":"{{client_fullname}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":307.5,"y":556,"id":"client_fullname"}],"documentType":"facture"}', NULL, 'facture', '2025-06-21 11:19:01', '2025-06-21 11:19:01', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (40, 'test creation', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test creation</title>
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
          left: 275.5px;
          top: 139px;
          color: #333333;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"placeholder","label":"Nom Complet Client","icon":"fas fa-user","content":"{{client_fullname}}","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":275.5,"y":139,"id":"client_fullname"}],"documentType":"facture"}', NULL, 'facture', '2025-06-21 11:19:26', '2025-06-21 11:19:26', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (41, 'test now', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test now</title>
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
          color: #333333;
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
          left: 208.5px;
          top: 231px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f8f8ff","x":208.5,"y":231,"id":"bank_info"}],"documentType":"facture"}', NULL, 'facture', '2025-06-21 22:22:02', '2025-06-21 22:22:02', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (42, 'test now', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test now</title>
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
          left: 208.5px;
          top: 231px;
          color: #333333;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f8f9fa;
          padding: 5px;
        " data-element-id="bank_info">{{bank_info}}</div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f8f9fa","x":208.5,"y":231,"id":"bank_info"}],"documentType":"facture"}', NULL, 'facture', '2025-06-21 22:22:39', '2025-06-21 22:22:39', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (43, 'a', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>a</title>
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
          color: #333333;
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
          left: 300.5px;
          top: 333px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"x":100,"y":100,"id":"text_1","icon":"fas fa-font","type":"text","color":"#333333","label":"Texte","content":"Texte personnalisé","fontSize":16,"fontStyle":"normal","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","textDecoration":"none","backgroundColor":"transparent"},{"type":"logo","label":"Logo","icon":"fas fa-image","src":"/src/assets/logo.jpg","width":100,"x":300.5,"y":333,"id":"logo"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 06:54:42', '2025-06-22 18:38:43', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (44, 'a (copie)', 'custom', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>a</title>
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
          color: #333333;
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
          left: 300.5px;
          top: 333px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"x":100,"y":100,"id":"text_1","icon":"fas fa-font","type":"text","color":"#333333","label":"Texte","content":"Texte personnalisé","fontSize":16,"fontStyle":"normal","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","textDecoration":"none","backgroundColor":"transparent"},{"type":"logo","label":"Logo","icon":"fas fa-image","src":"/src/assets/logo.jpg","width":100,"x":300.5,"y":333,"id":"logo"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 06:55:16', '2025-06-22 06:55:16', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (45, 'test', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>test</title>
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
          color: #333333;
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
          left: 28px;
          top: 240px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #ffffff;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #e74c3c;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #333333; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #333333; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #333333; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #333333; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #333333; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #333333; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #e74c3c; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#333333","secondary":"#ffffff","text":"#333333","accent":"#e74c3c"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#e74c3c","borderStyle":"solid","headerBackgroundColor":"#333333","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":28,"y":240,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"],"backgroundColor":"#ffffff"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 13:06:39', '2025-06-22 13:06:39', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (46, 'hg', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>hg</title>
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
          color: #333333;
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
          left: 174.5px;
          top: 260px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#000000","borderStyle":"solid","headerBackgroundColor":"#f0f0f0","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":174.5,"y":260,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"]}],"documentType":"devis"}', NULL, 'devis', '2025-06-22 13:23:31', '2025-06-22 13:23:31', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (47, 'hg', 'custom', 2, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>hg</title>
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
          color: #2c3e50;
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
          left: 111.5px;
          top: 261px;
          color: #2c3e50;
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
          left: 171.5px;
          top: 449px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #ecf0f1;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #3498db;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #2c3e50; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #2c3e50; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #2c3e50; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #2c3e50; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #2c3e50; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #2c3e50; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #3498db; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div>
          </div>
        </body>
        </html>
      ', '{"colors":{"primary":"#2c3e50","secondary":"#ecf0f1","text":"#2c3e50","accent":"#3498db"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"placeholder","label":"Nom Entreprise","icon":"fas fa-building","content":"{{company_name}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":111.5,"y":261,"id":"company_name"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#3498db","borderStyle":"solid","headerBackgroundColor":"#2c3e50","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":171.5,"y":449,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"],"backgroundColor":"#ecf0f1"}],"documentType":"devis"}', NULL, 'devis', '2025-06-22 13:24:03', '2025-06-22 13:24:03', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (48, 'template devis simple', 'custom', 22, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>template devis simple</title>
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
          left: 17px;
          top: 240px;
          color: #333333;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">devis:</div><div class="template-element" style="
          position: absolute;
          left: 17px;
          top: 20px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_name">{{company_name}}</div><div class="template-element" style="
          position: absolute;
          left: 17px;
          top: 50px;
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
          left: 17px;
          top: 82px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_2">mail:</div><div class="template-element" style="
          position: absolute;
          left: 17px;
          top: 112px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_3">siret:</div><div class="template-element" style="
          position: absolute;
          left: 60px;
          top: 80px;
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
          left: 17px;
          top: 142px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_4">telephone:</div><div class="template-element" style="
          position: absolute;
          left: 100px;
          top: 142px;
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
          left: -20px;
          top: 270px;
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
          left: 70px;
          top: 240px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_number">{{document_number}}</div><div class="template-element" style="
          position: absolute;
          left: 540px;
          top: 240px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div><div class="template-element" style="
          position: absolute;
          left: 540px;
          top: 290px;
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
          left: 540px;
          top: 320px;
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
          left: 540px;
          top: 350px;
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
          left: 160px;
          top: 310px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_date">{{document_date}}</div><div class="template-element" style="
          position: absolute;
          left: 17px;
          top: 310px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_7">date de document:</div><div class="template-element" style="
          position: absolute;
          left: 40px;
          top: 410px;
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
          left: 490px;
          top: 600px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_8">total ht:</div><div class="template-element" style="
          position: absolute;
          left: 630px;
          top: 600px;
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
          left: 630px;
          top: 630px;
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
          left: 630px;
          top: 660px;
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
          left: 630px;
          top: 690px;
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
          left: 630px;
          top: 720px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="total_ttc">{{total_ttc}}</div><div class="template-element" style="
          position: absolute;
          left: 490px;
          top: 630px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_9">total remise:</div><div class="template-element" style="
          position: absolute;
          left: 490px;
          top: 660px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_10">total net h.t:</div><div class="template-element" style="
          position: absolute;
          left: 490px;
          top: 690px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_11">Total TVA:</div><div class="template-element" style="
          position: absolute;
          left: 490px;
          top: 720px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_12">Total TTC:</div><div class="template-element" style="
          position: absolute;
          left: 40px;
          top: 610px;
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
          left: -8px;
          top: 760px;
          color: #000000;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="divider_13">undefined</div><div class="template-element" style="
          position: absolute;
          left: 40px;
          top: 780px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"devis:","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":240,"id":"text_1"},{"type":"placeholder","label":"Nom Entreprise","icon":"fas fa-building","content":"{{company_name}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":20,"id":"company_name"},{"type":"placeholder","label":"Adresse Entreprise","icon":"fas fa-building","content":"{{company_address}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":50,"id":"company_address"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"mail:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":82,"id":"text_2"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"siret:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":112,"id":"text_3"},{"type":"placeholder","label":"Email Entreprise","icon":"fas fa-envelope","content":"{{company_email}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":60,"y":80,"id":"company_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"telephone:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":142,"id":"text_4"},{"type":"placeholder","label":"Téléphone Entreprise","icon":"fas fa-phone","content":"{{company_phone}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":142,"id":"company_phone"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#000000","borderStyle":"solid","x":-20,"y":270,"id":"divider_5"},{"type":"placeholder","label":"Numéro","icon":"fas fa-hashtag","content":"{{document_number}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":70,"y":240,"id":"document_number"},{"type":"placeholder","label":"Nom Complet Client","icon":"fas fa-user","content":"{{client_fullname}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":540,"y":240,"id":"client_fullname"},{"type":"placeholder","label":"Adresse Client","icon":"fas fa-map-marker-alt","content":"{{client_address}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":540,"y":290,"id":"client_address"},{"type":"placeholder","label":"Téléphone Client","icon":"fas fa-phone","content":"{{client_phone}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":540,"y":320,"id":"client_phone"},{"type":"placeholder","label":"Email Client","icon":"fas fa-envelope","content":"{{client_email}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":540,"y":350,"id":"client_email"},{"type":"placeholder","label":"Date Document","icon":"fas fa-calendar-day","content":"{{document_date}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":160,"y":310,"id":"document_date"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"date de document:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":17,"y":310,"id":"text_7"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#000000","borderStyle":"solid","headerBackgroundColor":"#f0f0f0","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":40,"y":410,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"]},{"type":"text","label":"Texte","icon":"fas fa-font","content":"total ht:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":490,"y":600,"id":"text_8"},{"type":"placeholder","label":"Total HT","icon":"fas fa-calculator","content":"{{total_ht}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":630,"y":600,"id":"total_ht"},{"type":"placeholder","label":"Total Remise","icon":"fas fa-tags","content":"{{total_discount}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":630,"y":630,"id":"total_discount"},{"type":"placeholder","label":"Total Net HT","icon":"fas fa-calculator","content":"{{total_net_ht}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":630,"y":660,"id":"total_net_ht"},{"type":"placeholder","label":"TVA","icon":"fas fa-percentage","content":"{{tva}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":630,"y":690,"id":"tva"},{"type":"placeholder","label":"Total TTC","icon":"fas fa-euro-sign","content":"{{total_ttc}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":630,"y":720,"id":"total_ttc"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"total remise:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":490,"y":630,"id":"text_9"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"total net h.t:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":490,"y":660,"id":"text_10"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TVA:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":490,"y":690,"id":"text_11"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TTC:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":490,"y":720,"id":"text_12"},{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f8f8ff","x":40,"y":610,"id":"bank_info"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#000000","borderStyle":"solid","x":-8,"y":760,"id":"divider_13"},{"type":"text","label":"Avertissement","icon":"fas fa-exclamation-triangle","content":"{{warning}}","fontSize":16,"color":"#cc0000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#fff8f8","x":40,"y":780,"id":"warning"}],"documentType":"devis"}', NULL, 'devis', '2025-06-22 17:38:42', '2025-06-22 17:38:42', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (49, 'facture simple', 'custom', 22, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>facture simple</title>
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
          left: 20px;
          top: 80px;
          color: #333333;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Email:</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 20px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_name">{{company_name}}</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 50px;
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
          left: 80px;
          top: 80px;
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
          left: 20px;
          top: 110px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_2">Siret:</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 140px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_3">Telephone:</div><div class="template-element" style="
          position: absolute;
          left: 80px;
          top: 110px;
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
          left: 100px;
          top: 140px;
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
          left: 10px;
          top: 270px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_4">Facture:</div><div class="template-element" style="
          position: absolute;
          left: 0px;
          top: 300px;
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
          left: 80px;
          top: 270px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_number">{{document_number}}</div><div class="template-element" style="
          position: absolute;
          left: 560px;
          top: 270px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div><div class="template-element" style="
          position: absolute;
          left: 560px;
          top: 320px;
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
          left: 560px;
          top: 350px;
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
          left: 560px;
          top: 380px;
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
          left: 10px;
          top: 340px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_6">Date de doucment:</div><div class="template-element" style="
          position: absolute;
          left: 150px;
          top: 340px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_date">{{document_date}}</div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 420px;
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
          left: 30px;
          top: 640px;
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
          left: -18px;
          top: 760px;
          color: #000000;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="divider_7">undefined</div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 780px;
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
          left: 510px;
          top: 590px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_8">Total HT:</div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 620px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_9">Total Remise </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 650px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_10">Total NET H.T </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 680px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_11">Total TVA </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 710px;
          color: #000000;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_12">Total TTC </div><div class="template-element" style="
          position: absolute;
          left: 650px;
          top: 590px;
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
          left: 650px;
          top: 620px;
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
          left: 650px;
          top: 650px;
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
          left: 650px;
          top: 680px;
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
          left: 650px;
          top: 710px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Email:","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":80,"id":"text_1"},{"type":"placeholder","label":"Nom Entreprise","icon":"fas fa-building","content":"{{company_name}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":20,"id":"company_name"},{"type":"placeholder","label":"Adresse Entreprise","icon":"fas fa-building","content":"{{company_address}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":50,"id":"company_address"},{"type":"placeholder","label":"Email Entreprise","icon":"fas fa-envelope","content":"{{company_email}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":80,"id":"company_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Siret:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":110,"id":"text_2"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Telephone:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":140,"id":"text_3"},{"type":"placeholder","label":"SIRET","icon":"fas fa-id-card","content":"{{company_siret}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":110,"id":"company_siret"},{"type":"placeholder","label":"Téléphone Entreprise","icon":"fas fa-phone","content":"{{company_phone}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":140,"id":"company_phone"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Facture:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":10,"y":270,"id":"text_4"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#000000","borderStyle":"solid","x":0,"y":300,"id":"divider_5"},{"type":"placeholder","label":"Numéro","icon":"fas fa-hashtag","content":"{{document_number}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":270,"id":"document_number"},{"type":"placeholder","label":"Nom Complet Client","icon":"fas fa-user","content":"{{client_fullname}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":270,"id":"client_fullname"},{"type":"placeholder","label":"Adresse Client","icon":"fas fa-map-marker-alt","content":"{{client_address}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":320,"id":"client_address"},{"type":"placeholder","label":"Téléphone Client","icon":"fas fa-phone","content":"{{client_phone}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":350,"id":"client_phone"},{"type":"placeholder","label":"Email Client","icon":"fas fa-envelope","content":"{{client_email}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":380,"id":"client_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Date de doucment:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":10,"y":340,"id":"text_6"},{"type":"placeholder","label":"Date Document","icon":"fas fa-calendar-day","content":"{{document_date}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":150,"y":340,"id":"document_date"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#000000","borderStyle":"solid","headerBackgroundColor":"#f0f0f0","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":30,"y":420,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"]},{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f8f8ff","x":30,"y":640,"id":"bank_info"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#000000","borderStyle":"solid","x":-18,"y":760,"id":"divider_7"},{"type":"text","label":"Avertissement","icon":"fas fa-exclamation-triangle","content":"{{warning}}","fontSize":16,"color":"#cc0000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#fff8f8","x":30,"y":780,"id":"warning"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total HT:","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":590,"id":"text_8"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total Remise ","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":620,"id":"text_9"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total NET H.T ","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":650,"id":"text_10"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TVA ","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":680,"id":"text_11"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TTC ","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":710,"id":"text_12"},{"type":"placeholder","label":"Total HT","icon":"fas fa-calculator","content":"{{total_ht}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":590,"id":"total_ht"},{"type":"placeholder","label":"Total Remise","icon":"fas fa-tags","content":"{{total_discount}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":620,"id":"total_discount"},{"type":"placeholder","label":"Total Net HT","icon":"fas fa-calculator","content":"{{total_net_ht}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":650,"id":"total_net_ht"},{"type":"placeholder","label":"TVA","icon":"fas fa-percentage","content":"{{tva}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":680,"id":"tva"},{"type":"placeholder","label":"Total TTC","icon":"fas fa-euro-sign","content":"{{total_ttc}}","fontSize":16,"color":"#000000","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":710,"id":"total_ttc"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 18:26:04', '2025-06-22 18:26:04', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (50, 'facture simple', 'custom', 22, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>facture simple</title>
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
          left: 20px;
          top: 80px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Email:</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 20px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_name">{{company_name}}</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 50px;
          color: #2c3e50;
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
          left: 80px;
          top: 80px;
          color: #2c3e50;
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
          left: 20px;
          top: 110px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_2">Siret:</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 140px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_3">Telephone:</div><div class="template-element" style="
          position: absolute;
          left: 80px;
          top: 110px;
          color: #2c3e50;
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
          left: 100px;
          top: 140px;
          color: #2c3e50;
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
          left: 10px;
          top: 270px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_4">Facture:</div><div class="template-element" style="
          position: absolute;
          left: 0px;
          top: 300px;
          color: #c0392b;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: #f9f9f9;
          padding: 5px;
        " data-element-id="divider_5">undefined</div><div class="template-element" style="
          position: absolute;
          left: 80px;
          top: 270px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_number">{{document_number}}</div><div class="template-element" style="
          position: absolute;
          left: 560px;
          top: 270px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div><div class="template-element" style="
          position: absolute;
          left: 560px;
          top: 320px;
          color: #2c3e50;
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
          left: 560px;
          top: 350px;
          color: #2c3e50;
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
          left: 560px;
          top: 380px;
          color: #2c3e50;
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
          left: 10px;
          top: 340px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_6">Date de doucment:</div><div class="template-element" style="
          position: absolute;
          left: 150px;
          top: 340px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_date">{{document_date}}</div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 420px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f9f9f9;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #f1c40f;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #c0392b; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #c0392b; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #c0392b; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #c0392b; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #c0392b; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #c0392b; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #f1c40f; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 640px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f9f9f9;
          padding: 5px;
        " data-element-id="bank_info">{{bank_info}}</div><div class="template-element" style="
          position: absolute;
          left: -18px;
          top: 760px;
          color: #c0392b;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: #f9f9f9;
          padding: 5px;
        " data-element-id="divider_7">undefined</div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 780px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f9f9f9;
          padding: 5px;
        " data-element-id="warning">{{warning}}</div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 590px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_8">Total HT:</div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 620px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_9">Total Remise </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 650px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_10">Total NET H.T </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 680px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_11">Total TVA </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 710px;
          color: #2c3e50;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_12">Total TTC </div><div class="template-element" style="
          position: absolute;
          left: 650px;
          top: 590px;
          color: #2c3e50;
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
          left: 650px;
          top: 620px;
          color: #2c3e50;
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
          left: 650px;
          top: 650px;
          color: #2c3e50;
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
          left: 650px;
          top: 680px;
          color: #2c3e50;
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
          left: 650px;
          top: 710px;
          color: #2c3e50;
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
      ', '{"colors":{"primary":"#c0392b","secondary":"#f9f9f9","text":"#2c3e50","accent":"#f1c40f"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Email:","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":80,"id":"text_1"},{"type":"placeholder","label":"Nom Entreprise","icon":"fas fa-building","content":"{{company_name}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":20,"id":"company_name"},{"type":"placeholder","label":"Adresse Entreprise","icon":"fas fa-building","content":"{{company_address}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":50,"id":"company_address"},{"type":"placeholder","label":"Email Entreprise","icon":"fas fa-envelope","content":"{{company_email}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":80,"id":"company_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Siret:","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":110,"id":"text_2"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Telephone:","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":140,"id":"text_3"},{"type":"placeholder","label":"SIRET","icon":"fas fa-id-card","content":"{{company_siret}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":110,"id":"company_siret"},{"type":"placeholder","label":"Téléphone Entreprise","icon":"fas fa-phone","content":"{{company_phone}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":140,"id":"company_phone"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Facture:","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":10,"y":270,"id":"text_4"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#c0392b","borderStyle":"solid","x":0,"y":300,"id":"divider_5","backgroundColor":"#f9f9f9"},{"type":"placeholder","label":"Numéro","icon":"fas fa-hashtag","content":"{{document_number}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":270,"id":"document_number"},{"type":"placeholder","label":"Nom Complet Client","icon":"fas fa-user","content":"{{client_fullname}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":270,"id":"client_fullname"},{"type":"placeholder","label":"Adresse Client","icon":"fas fa-map-marker-alt","content":"{{client_address}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":320,"id":"client_address"},{"type":"placeholder","label":"Téléphone Client","icon":"fas fa-phone","content":"{{client_phone}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":350,"id":"client_phone"},{"type":"placeholder","label":"Email Client","icon":"fas fa-envelope","content":"{{client_email}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":380,"id":"client_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Date de doucment:","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":10,"y":340,"id":"text_6"},{"type":"placeholder","label":"Date Document","icon":"fas fa-calendar-day","content":"{{document_date}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":150,"y":340,"id":"document_date"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#f1c40f","borderStyle":"solid","headerBackgroundColor":"#c0392b","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":30,"y":420,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"],"backgroundColor":"#f9f9f9"},{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f9f9f9","x":30,"y":640,"id":"bank_info"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#c0392b","borderStyle":"solid","x":-18,"y":760,"id":"divider_7","backgroundColor":"#f9f9f9"},{"type":"text","label":"Avertissement","icon":"fas fa-exclamation-triangle","content":"{{warning}}","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f9f9f9","x":30,"y":780,"id":"warning"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total HT:","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":590,"id":"text_8"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total Remise ","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":620,"id":"text_9"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total NET H.T ","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":650,"id":"text_10"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TVA ","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":680,"id":"text_11"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TTC ","fontSize":16,"color":"#2c3e50","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":710,"id":"text_12"},{"type":"placeholder","label":"Total HT","icon":"fas fa-calculator","content":"{{total_ht}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":590,"id":"total_ht"},{"type":"placeholder","label":"Total Remise","icon":"fas fa-tags","content":"{{total_discount}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":620,"id":"total_discount"},{"type":"placeholder","label":"Total Net HT","icon":"fas fa-calculator","content":"{{total_net_ht}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":650,"id":"total_net_ht"},{"type":"placeholder","label":"TVA","icon":"fas fa-percentage","content":"{{tva}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":680,"id":"tva"},{"type":"placeholder","label":"Total TTC","icon":"fas fa-euro-sign","content":"{{total_ttc}}","fontSize":16,"color":"#2c3e50","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":710,"id":"total_ttc"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 18:26:17', '2025-06-22 18:26:29', 1);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (51, 'facture coloree', 'custom', 22, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>facture coloree</title>
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
          left: 20px;
          top: 80px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_1">Email:</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 20px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="company_name">{{company_name}}</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 50px;
          color: #34495e;
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
          left: 80px;
          top: 80px;
          color: #34495e;
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
          left: 20px;
          top: 110px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_2">Siret:</div><div class="template-element" style="
          position: absolute;
          left: 20px;
          top: 140px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_3">Telephone:</div><div class="template-element" style="
          position: absolute;
          left: 80px;
          top: 110px;
          color: #34495e;
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
          left: 100px;
          top: 140px;
          color: #34495e;
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
          left: 10px;
          top: 270px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_4">Facture:</div><div class="template-element" style="
          position: absolute;
          left: 0px;
          top: 300px;
          color: #9b59b6;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: #f5f5f5;
          padding: 5px;
        " data-element-id="divider_5">undefined</div><div class="template-element" style="
          position: absolute;
          left: 80px;
          top: 270px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_number">{{document_number}}</div><div class="template-element" style="
          position: absolute;
          left: 560px;
          top: 270px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: bold;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="client_fullname">{{client_fullname}}</div><div class="template-element" style="
          position: absolute;
          left: 560px;
          top: 320px;
          color: #34495e;
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
          left: 560px;
          top: 350px;
          color: #34495e;
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
          left: 560px;
          top: 380px;
          color: #34495e;
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
          left: 10px;
          top: 340px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_6">Date de doucment:</div><div class="template-element" style="
          position: absolute;
          left: 150px;
          top: 340px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: right;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="document_date">{{document_date}}</div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 420px;
          color: #000000;
          font-size: 14px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f5f5f5;
          padding: 5px;
        " data-element-id="tab"><table style="width: 100%; border-collapse: collapse; border-spacing: 0; border: 1px solid #1abc9c;" data-element-id="tab">
            <thead>
              <tr>
                
                  <th style="padding: 8px; background-color: #9b59b6; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_ref">
                    REF
                  </th>
                
                  <th style="padding: 8px; background-color: #9b59b6; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_details">
                    Détails
                  </th>
                
                  <th style="padding: 8px; background-color: #9b59b6; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_quantite">
                    Quantité
                  </th>
                
                  <th style="padding: 8px; background-color: #9b59b6; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_pu_ht">
                    PU HT
                  </th>
                
                  <th style="padding: 8px; background-color: #9b59b6; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_total_ht">
                    Total HT
                  </th>
                
                  <th style="padding: 8px; background-color: #9b59b6; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_tva">
                    TVA
                  </th>
                
              </tr>
            </thead>
            <tbody>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_ref_row1">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_details_row1">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_quantite_row1">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_pu_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_total_ht_row1">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_tva_row1">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_ref_row2">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_details_row2">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_quantite_row2">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_pu_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_total_ht_row2">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_tva_row2">
                      20%
                    </td>
                  
                </tr>
              
                <tr>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_ref_row3">
                      REF123
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_details_row3">
                      Produit exemple
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_quantite_row3">
                      1
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_pu_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_total_ht_row3">
                      100.00 €
                    </td>
                  
                    <td style="padding: 8px; background-color: #ffffff; border: 1px solid #1abc9c; text-align: left;" data-cell-id="tab_tva_row3">
                      20%
                    </td>
                  
                </tr>
              
            </tbody>
          </table></div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 640px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f5f5f5;
          padding: 5px;
        " data-element-id="bank_info">{{bank_info}}</div><div class="template-element" style="
          position: absolute;
          left: -18px;
          top: 760px;
          color: #9b59b6;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: #f5f5f5;
          padding: 5px;
        " data-element-id="divider_7">undefined</div><div class="template-element" style="
          position: absolute;
          left: 30px;
          top: 780px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: #f5f5f5;
          padding: 5px;
        " data-element-id="warning">{{warning}}</div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 590px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_8">Total HT:</div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 620px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_9">Total Remise </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 650px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_10">Total NET H.T </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 680px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_11">Total TVA </div><div class="template-element" style="
          position: absolute;
          left: 510px;
          top: 710px;
          color: #34495e;
          font-size: 16px;
          font-family: Arial, sans-serif;
          text-align: left;
          font-weight: normal;
          font-style: normal;
          text-decoration: none;
          background-color: transparent;
          padding: 5px;
        " data-element-id="text_12">Total TTC </div><div class="template-element" style="
          position: absolute;
          left: 650px;
          top: 590px;
          color: #34495e;
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
          left: 650px;
          top: 620px;
          color: #34495e;
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
          left: 650px;
          top: 650px;
          color: #34495e;
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
          left: 650px;
          top: 680px;
          color: #34495e;
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
          left: 650px;
          top: 710px;
          color: #34495e;
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
      ', '{"colors":{"primary":"#9b59b6","secondary":"#f5f5f5","text":"#34495e","accent":"#1abc9c"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Email:","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":80,"id":"text_1"},{"type":"placeholder","label":"Nom Entreprise","icon":"fas fa-building","content":"{{company_name}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":20,"id":"company_name"},{"type":"placeholder","label":"Adresse Entreprise","icon":"fas fa-building","content":"{{company_address}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":50,"id":"company_address"},{"type":"placeholder","label":"Email Entreprise","icon":"fas fa-envelope","content":"{{company_email}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":80,"id":"company_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Siret:","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":110,"id":"text_2"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Telephone:","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":20,"y":140,"id":"text_3"},{"type":"placeholder","label":"SIRET","icon":"fas fa-id-card","content":"{{company_siret}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":110,"id":"company_siret"},{"type":"placeholder","label":"Téléphone Entreprise","icon":"fas fa-phone","content":"{{company_phone}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":140,"id":"company_phone"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Facture:","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":10,"y":270,"id":"text_4"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#9b59b6","borderStyle":"solid","x":0,"y":300,"id":"divider_5","backgroundColor":"#f5f5f5"},{"type":"placeholder","label":"Numéro","icon":"fas fa-hashtag","content":"{{document_number}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":80,"y":270,"id":"document_number"},{"type":"placeholder","label":"Nom Complet Client","icon":"fas fa-user","content":"{{client_fullname}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"bold","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":270,"id":"client_fullname"},{"type":"placeholder","label":"Adresse Client","icon":"fas fa-map-marker-alt","content":"{{client_address}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":320,"id":"client_address"},{"type":"placeholder","label":"Téléphone Client","icon":"fas fa-phone","content":"{{client_phone}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":350,"id":"client_phone"},{"type":"placeholder","label":"Email Client","icon":"fas fa-envelope","content":"{{client_email}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":560,"y":380,"id":"client_email"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Date de doucment:","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":10,"y":340,"id":"text_6"},{"type":"placeholder","label":"Date Document","icon":"fas fa-calendar-day","content":"{{document_date}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":150,"y":340,"id":"document_date"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#1abc9c","borderStyle":"solid","headerBackgroundColor":"#9b59b6","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":30,"y":420,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"],"backgroundColor":"#f5f5f5"},{"type":"text","label":"Informations Bancaires","icon":"fas fa-university","content":"{{bank_info}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f5f5f5","x":30,"y":640,"id":"bank_info"},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#9b59b6","borderStyle":"solid","x":-18,"y":760,"id":"divider_7","backgroundColor":"#f5f5f5"},{"type":"text","label":"Avertissement","icon":"fas fa-exclamation-triangle","content":"{{warning}}","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"#f5f5f5","x":30,"y":780,"id":"warning"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total HT:","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":590,"id":"text_8"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total Remise ","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":620,"id":"text_9"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total NET H.T ","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":650,"id":"text_10"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TVA ","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":680,"id":"text_11"},{"type":"text","label":"Texte","icon":"fas fa-font","content":"Total TTC ","fontSize":16,"color":"#34495e","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":510,"y":710,"id":"text_12"},{"type":"placeholder","label":"Total HT","icon":"fas fa-calculator","content":"{{total_ht}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":590,"id":"total_ht"},{"type":"placeholder","label":"Total Remise","icon":"fas fa-tags","content":"{{total_discount}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":620,"id":"total_discount"},{"type":"placeholder","label":"Total Net HT","icon":"fas fa-calculator","content":"{{total_net_ht}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":650,"id":"total_net_ht"},{"type":"placeholder","label":"TVA","icon":"fas fa-percentage","content":"{{tva}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":680,"id":"tva"},{"type":"placeholder","label":"Total TTC","icon":"fas fa-euro-sign","content":"{{total_ttc}}","fontSize":16,"color":"#34495e","textAlign":"right","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":650,"y":710,"id":"total_ttc"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 18:28:04', '2025-06-22 18:28:04', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (52, 'template 1', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>template 1</title>
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
          color: #333333;
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
          left: 42px;
          top: 287px;
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
          left: -6px;
          top: 231px;
          color: #000000;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="divider_2">undefined</div><div class="template-element" style="
          position: absolute;
          left: 607px;
          top: 70px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#000000","borderStyle":"solid","headerBackgroundColor":"#f0f0f0","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":42,"y":287,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"]},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#000000","borderStyle":"solid","x":-6,"y":231,"id":"divider_2"},{"type":"logo","label":"Logo","icon":"fas fa-image","src":"/src/assets/logo.jpg","width":100,"x":607,"y":70,"id":"logo"}],"documentType":"facture"}', NULL, 'facture', '2025-06-22 18:39:46', '2025-06-22 18:39:46', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (53, 'template 2', 'predefined', 3, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>template 2</title>
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
          left: 27px;
          top: 42px;
          color: #333333;
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
          left: 27px;
          top: 303px;
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
          left: -21px;
          top: 202px;
          color: #000000;
          font-size: undefinedpx;
          font-family: undefined;
          text-align: undefined;
          font-weight: undefined;
          font-style: undefined;
          text-decoration: undefined;
          background-color: undefined;
          padding: 5px;
        " data-element-id="divider_2">undefined</div><div class="template-element" style="
          position: absolute;
          left: 675px;
          top: 22px;
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
          left: 27px;
          top: 91px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":27,"y":42,"id":"text_1"},{"type":"table","label":"Tableau","icon":"fas fa-table","content":"Tableau produits","rows":4,"columns":6,"cellPadding":8,"borderWidth":1,"borderColor":"#000000","borderStyle":"solid","headerBackgroundColor":"#f0f0f0","cellBackgroundColor":"#ffffff","fontSize":14,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","x":27,"y":303,"width":700,"height":200,"id":"tab","headers":["REF","Détails","Quantité","PU HT","Total HT","TVA"],"headerIds":["tab_ref","tab_details","tab_quantite","tab_pu_ht","tab_total_ht","tab_tva"]},{"type":"divider","label":"Ligne Horizontale","icon":"fas fa-grip-lines","width":796,"height":2.5,"color":"#000000","borderStyle":"solid","x":-21,"y":202,"id":"divider_2"},{"type":"logo","label":"Logo","icon":"fas fa-image","src":"/src/assets/logo.jpg","width":100,"x":675,"y":22,"id":"logo"},{"type":"placeholder","label":"Adresse Entreprise","icon":"fas fa-building","content":"{{company_address}}","fontSize":16,"color":"#000000","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":27,"y":91,"id":"company_address"}],"documentType":"devis"}', NULL, 'devis', '2025-06-22 18:40:27', '2025-06-22 18:40:27', NULL);
INSERT INTO `templates` (`id`, `name`, `type`, `created_by`, `html_structure`, `design_config`, `preview_image_path`, `doc_type`, `created_at`, `updated_at`, `isdeleted`) VALUES (54, 'aaa', 'custom', 24, '
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>aaa</title>
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
          color: #333333;
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
          left: 176.5px;
          top: 272px;
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
      ', '{"colors":{"primary":"#4bc0c0","secondary":"#f8f9fa","text":"#333333","accent":"#ff9f40"},"elements":[{"type":"text","label":"Texte","icon":"fas fa-font","content":"Texte personnalisé","fontSize":16,"color":"#333333","textAlign":"left","fontFamily":"Arial, sans-serif","fontWeight":"normal","fontStyle":"normal","textDecoration":"none","backgroundColor":"transparent","x":100,"y":100,"id":"text_1"},{"type":"logo","label":"Logo","icon":"fas fa-image","src":"/src/assets/logo.jpg","width":100,"x":176.5,"y":272,"id":"logo"}],"documentType":"facture"}', NULL, 'facture', '2025-06-23 04:05:22', '2025-06-23 04:05:22', NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Data for table `users`
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (1, 'douaa', 'guetlani', 'wisoghost@gmail.com', '$2b$10$qFeJ4FZVY6PEWKF1DCLZHO7r0X51MCL5EZZS10w9XxggNNRVosVGO', 'client', '162473', '2025-03-24 04:59:05', NULL, NULL, 1, '2025-03-23 04:59:04', NULL);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (2, 'wassim', 'bannour', 'wassbennour123@gmail.com', '$2b$10$6Txndzd5rYstmb39mM5NZeNU9O9COkcRaUMG0wsocE5mX2Sy8FCiu', 'enterprise_admin', '683464', '2025-04-06 15:57:09', NULL, NULL, 1, '2025-04-05 15:57:08', 1);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (3, 'anwer', 'anwer', 'wassbennour789@gmail.com', '$2b$10$dP77so5NBWFM7lbhSMCmf.0LFST6gZGuA89..rz4pgcQZOYe5hyDy', 'admin', '000000', '2025-05-08 00:48:36', NULL, NULL, 1, '2025-05-07 00:48:36', 1);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (21, 'farah', 'gdaim', 'wassbennour456@gmail.com', '$2b$10$aUkm1H6bxNZle/8jyG1u/OfWTvtY92wj2YyxqaV0QGPz.dORX5uOC', 'client', '142775', '2025-06-20 18:53:06', NULL, NULL, 1, '2025-06-19 18:53:06', 1);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (22, 'wissem', 'messous', 'wissemmessous@gmail.com', '$2b$10$ZeGAQis/r6PycEWgFK.rUezGBs/unSogw8jDB4Hj9Hqf4Um7ocGdO', 'enterprise_admin', '542277', '2025-06-20 18:56:54', NULL, NULL, 1, '2025-06-19 18:56:53', 1);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (23, 'test', 'test', 'test@gmail.com', '$2b$10$WzWb41nw24vFB7x618o8zOhxY57wCPYJNMopwqNbSyzlJ5nece4E6', 'client', '993590', '2025-06-23 19:07:03', NULL, NULL, 1, '2025-06-22 19:07:03', 1);
INSERT INTO `users` (`id`, `first_name`, `last_name`, `email`, `password`, `role`, `verification_code`, `verification_code_expired`, `reset_code`, `reset_code_expired`, `is_verified`, `created_at`, `isActive`) VALUES (24, 'test', 'entreprise', 'testentreprise@gmail.com', '$2b$10$6G1LAVz1haD7QIcQk4anVOIrLZGM02lUj1OjW8e246e6/YtwSe81u', 'enterprise_admin', '546646', '2025-06-24 04:04:29', NULL, NULL, 1, '2025-06-23 04:04:29', 1);


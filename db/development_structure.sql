CREATE TABLE `appgen_order_lineitems` (
  `appgen_order_id` varchar(255) NOT NULL,
  `part_number` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `quantity` int(11) default NULL,
  `price` decimal(20,5) default NULL,
  `discount` decimal(7,2) default NULL,
  `id` varchar(255) NOT NULL default '',
  UNIQUE KEY `index_appgen_order_lineitems_on_id` (`id`),
  KEY `index_appgen_order_lineitems_on_appgen_order_id` (`appgen_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `appgen_order_serials` (
  `id` varchar(255) NOT NULL default '',
  `serial_number` varchar(255) default NULL,
  UNIQUE KEY `index_appgen_order_serials_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `appgen_orders` (
  `id` varchar(255) NOT NULL default '',
  `cust_code` int(11) default NULL,
  `cust_name` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `address3` varchar(255) default NULL,
  `address4` varchar(255) default NULL,
  `cust_po_number` varchar(255) default NULL,
  `ship_date` date default NULL,
  `net_discount` decimal(7,2) default NULL,
  `sub_total` decimal(20,5) default NULL,
  `sales_rep` varchar(255) default NULL,
  UNIQUE KEY `index_appgen_orders_on_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `audits` (
  `id` int(11) NOT NULL auto_increment,
  `auditable_id` int(11) default NULL,
  `auditable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `user_type` varchar(255) default NULL,
  `username` varchar(255) default NULL,
  `action` varchar(255) default NULL,
  `changes` text,
  `version` int(11) default '0',
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `auditable_index` (`auditable_id`,`auditable_type`),
  KEY `user_index` (`user_id`,`user_type`),
  KEY `index_audits_on_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=15255 DEFAULT CHARSET=latin1;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `body` text,
  `commentable_id` bigint(11) default NULL,
  `commentable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=167 DEFAULT CHARSET=latin1;

CREATE TABLE `contracts` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` varchar(255) default NULL,
  `account_name` varchar(255) default NULL,
  `sales_office_name` varchar(255) default NULL,
  `support_office_name` varchar(255) default NULL,
  `said` varchar(255) default NULL,
  `sdc_ref` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `sales_rep_id` bigint(11) default NULL,
  `sales_office` varchar(255) default NULL,
  `support_office` varchar(255) default NULL,
  `cust_po_num` varchar(255) default NULL,
  `payment_terms` varchar(255) default NULL,
  `platform` varchar(255) default NULL,
  `revenue` decimal(20,3) default NULL,
  `annual_hw_rev` decimal(20,3) default NULL,
  `annual_sw_rev` decimal(20,3) default NULL,
  `annual_ce_rev` decimal(20,3) default NULL,
  `annual_sa_rev` decimal(20,3) default NULL,
  `annual_dr_rev` decimal(20,3) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `multiyr_end` date default NULL,
  `expired` tinyint(1) default '0',
  `hw_support_level_id` varchar(255) default NULL,
  `sw_support_level_id` varchar(255) default NULL,
  `updates` varchar(255) default NULL,
  `ce_days` bigint(11) default NULL,
  `sa_days` bigint(11) default NULL,
  `discount_pref_hw` decimal(5,3) default NULL,
  `discount_pref_sw` decimal(5,3) default NULL,
  `discount_pref_srv` decimal(5,3) default NULL,
  `discount_prepay` decimal(5,3) default NULL,
  `discount_multiyear` decimal(5,3) default NULL,
  `discount_ce_day` decimal(5,3) default NULL,
  `discount_sa_day` decimal(5,3) default NULL,
  `replacement_sdc_ref` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `contract_type` varchar(255) default NULL,
  `so_number` varchar(255) default NULL,
  `po_number` varchar(255) default NULL,
  `renewal_sent` date default NULL,
  `po_received` date default NULL,
  `renewal_amount` decimal(20,3) default NULL,
  `address1` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `address3` varchar(255) default NULL,
  `contact_name` varchar(255) default NULL,
  `contact_phone` varchar(255) default NULL,
  `contact_email` varchar(255) default NULL,
  `contact_note` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1125 DEFAULT CHARSET=latin1;

CREATE TABLE `dropdowns` (
  `id` int(11) NOT NULL auto_increment,
  `dd_name` varchar(255) default NULL,
  `filter` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `sort_order` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

CREATE TABLE `hwdb` (
  `id` int(11) NOT NULL auto_increment,
  `part_number` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `list_price` decimal(10,2) default NULL,
  `modified_user_id` int(11) default NULL,
  `modified_at` date default NULL,
  `confirm_date` date default NULL,
  `notes` text,
  PRIMARY KEY  (`id`),
  KEY `index_hwdb_on_part_number` (`part_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `inventory_items` (
  `id` varchar(255) NOT NULL default '',
  `item_code` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `serial_number` varchar(255) default NULL,
  `warehouse` varchar(255) default NULL,
  `location` varchar(255) default NULL,
  `manufacturer` varchar(255) default NULL,
  UNIQUE KEY `tracking` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `inventory_warehouses` (
  `code` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  UNIQUE KEY `index_inventory_warehouses_on_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `io_slots` (
  `id` int(11) NOT NULL auto_increment,
  `server_id` int(11) default NULL,
  `slot_number` int(11) default NULL,
  `path` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `description` varchar(255) default NULL,
  `chassis_number` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=180 DEFAULT CHARSET=latin1;

CREATE TABLE `line_items` (
  `id` int(11) NOT NULL auto_increment,
  `contract_id` bigint(11) default NULL,
  `support_type` varchar(255) default NULL,
  `product_num` varchar(255) default NULL,
  `serial_num` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `begins` date default NULL,
  `ends` date default NULL,
  `qty` bigint(11) default NULL,
  `list_price` decimal(20,3) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `support_provider` varchar(255) default NULL,
  `position` int(11) default NULL,
  `location` varchar(255) default NULL,
  `current_list_price` decimal(20,3) default NULL,
  `effective_price` decimal(20,3) default NULL,
  `note` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_line_items_on_product_num` (`product_num`),
  KEY `index_line_items_on_contract_id` (`contract_id`)
) ENGINE=InnoDB AUTO_INCREMENT=41381 DEFAULT CHARSET=latin1;

CREATE TABLE `locations` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `data` text,
  `resource_id` bigint(11) default NULL,
  `resource_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `opportunities` (
  `id` int(11) NOT NULL auto_increment,
  `sugar_id` varchar(255) default NULL,
  `account_id` varchar(255) default NULL,
  `account_name` varchar(255) default NULL,
  `opp_type` varchar(255) default NULL,
  `name` varchar(255) default NULL,
  `description` text,
  `revenue` decimal(20,3) default NULL,
  `cogs` decimal(20,3) default NULL,
  `probability` decimal(5,3) default NULL,
  `status` varchar(255) default NULL,
  `modified_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `permissions` (
  `role_id` int(11) default NULL,
  `user_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  KEY `index_permissions_on_role_id` (`role_id`),
  KEY `index_permissions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `product_deals` (
  `id` int(11) NOT NULL auto_increment,
  `job_number` varchar(255) default NULL,
  `sugar_opp_id` bigint(11) default NULL,
  `account_id` varchar(255) default NULL,
  `account_name` varchar(255) default NULL,
  `invoice_number` varchar(255) default NULL,
  `revenue` decimal(20,3) default NULL,
  `cogs` decimal(20,3) default NULL,
  `freight` decimal(20,3) default NULL,
  `status` varchar(255) default NULL,
  `modified_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `relationships` (
  `id` int(11) NOT NULL auto_increment,
  `successor_id` bigint(11) default NULL,
  `predecessor_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=624 DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `servers` (
  `id` int(11) NOT NULL auto_increment,
  `model_name` varchar(255) default NULL,
  `server_line` varchar(255) default NULL,
  `tier` int(11) default NULL,
  `sockets` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

CREATE TABLE `swdb` (
  `id` int(11) NOT NULL auto_increment,
  `part_number` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `phone_price` decimal(10,2) default NULL,
  `update_price` decimal(10,2) default NULL,
  `modified_user_id` int(11) default NULL,
  `modified_at` date default NULL,
  `confirm_date` date default NULL,
  `notes` text,
  PRIMARY KEY  (`id`),
  KEY `index_swdb_on_part_number` (`part_number`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `swlist_blacklists` (
  `id` int(11) NOT NULL auto_increment,
  `pattern` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=413 DEFAULT CHARSET=latin1;

CREATE TABLE `swlist_whitelists` (
  `id` int(11) NOT NULL auto_increment,
  `pattern` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=latin1;

CREATE TABLE `swproducts` (
  `id` int(11) NOT NULL auto_increment,
  `product_number` varchar(255) default NULL,
  `license_type` varchar(255) default NULL,
  `tier` int(11) default NULL,
  `license_product` varchar(255) default NULL,
  `swlist_whitelist_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `explanation` text,
  `server_line` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=latin1;

CREATE TABLE `upfront_orders` (
  `id` int(11) NOT NULL auto_increment,
  `appgen_order_id` varchar(255) default NULL,
  `has_upfront_support` tinyint(1) default '1',
  `completed` tinyint(1) default '0',
  `contract_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_upfront_orders_on_appgen_order_id` (`appgen_order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `office` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `role` bigint(11) default NULL,
  `sugar_id` varchar(255) default NULL,
  `crypted_password` varchar(40) default NULL,
  `salt` varchar(40) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_token_expires_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('12');

INSERT INTO schema_migrations (version) VALUES ('13');

INSERT INTO schema_migrations (version) VALUES ('14');

INSERT INTO schema_migrations (version) VALUES ('15');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20080715111807');

INSERT INTO schema_migrations (version) VALUES ('20080715135045');

INSERT INTO schema_migrations (version) VALUES ('20080716104302');

INSERT INTO schema_migrations (version) VALUES ('20080717121425');

INSERT INTO schema_migrations (version) VALUES ('20080722021451');

INSERT INTO schema_migrations (version) VALUES ('20080818123555');

INSERT INTO schema_migrations (version) VALUES ('20080820134309');

INSERT INTO schema_migrations (version) VALUES ('20080822002505');

INSERT INTO schema_migrations (version) VALUES ('20080822134126');

INSERT INTO schema_migrations (version) VALUES ('20080830165634');

INSERT INTO schema_migrations (version) VALUES ('20080924100947');

INSERT INTO schema_migrations (version) VALUES ('20080924114817');

INSERT INTO schema_migrations (version) VALUES ('20080925121340');

INSERT INTO schema_migrations (version) VALUES ('20081110195705');

INSERT INTO schema_migrations (version) VALUES ('20081119132936');

INSERT INTO schema_migrations (version) VALUES ('20090210225003');

INSERT INTO schema_migrations (version) VALUES ('20090210225604');

INSERT INTO schema_migrations (version) VALUES ('20090404165604');

INSERT INTO schema_migrations (version) VALUES ('20090421174554');

INSERT INTO schema_migrations (version) VALUES ('20090423134602');

INSERT INTO schema_migrations (version) VALUES ('20090424022731');

INSERT INTO schema_migrations (version) VALUES ('20090424154445');

INSERT INTO schema_migrations (version) VALUES ('20090429175216');

INSERT INTO schema_migrations (version) VALUES ('20090522132353');

INSERT INTO schema_migrations (version) VALUES ('20090605031037');

INSERT INTO schema_migrations (version) VALUES ('20090608212720');

INSERT INTO schema_migrations (version) VALUES ('20090609193451');

INSERT INTO schema_migrations (version) VALUES ('20090609193539');

INSERT INTO schema_migrations (version) VALUES ('20090701194308');

INSERT INTO schema_migrations (version) VALUES ('20090720132405');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');
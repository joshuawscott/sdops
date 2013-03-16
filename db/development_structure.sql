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
) ENGINE=InnoDB AUTO_INCREMENT=270454 DEFAULT CHARSET=latin1;

CREATE TABLE `comments` (
  `id` int(11) NOT NULL auto_increment,
  `body` text,
  `commentable_id` bigint(11) default NULL,
  `commentable_type` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `user` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4815 DEFAULT CHARSET=latin1;

CREATE TABLE `commissions` (
  `id` int(11) NOT NULL auto_increment,
  `commissionable_id` int(11) default NULL,
  `commissionable_type` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `percentage` decimal(10,0) default NULL,
  `notes` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `approval` varchar(255) default NULL,
  `approval_date` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1063 DEFAULT CHARSET=latin1;

CREATE TABLE `dropdowns` (
  `id` int(11) NOT NULL auto_increment,
  `dd_name` varchar(255) default NULL,
  `filter` varchar(255) default NULL,
  `label` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `sort_order` bigint(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;

CREATE TABLE `footprints_categories` (
  `id` int(11) NOT NULL auto_increment,
  `subsystem` varchar(255) default NULL,
  `main_category` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `sub_category` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `goals` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `sales_office` varchar(255) default NULL,
  `sales_office_name` varchar(255) default NULL,
  `amount` decimal(20,2) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `periodicity` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `hwdb` (
  `id` int(11) NOT NULL auto_increment,
  `part_number` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `list_price` decimal(10,2) default NULL,
  `modified_user_id` int(11) default NULL,
  `modified_at` date default NULL,
  `confirm_date` date default NULL,
  `notes` text,
  `manufacturer_line_id` int(11) default NULL,
  `tlci` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_hwdb_on_part_number` (`part_number`)
) ENGINE=InnoDB AUTO_INCREMENT=12802 DEFAULT CHARSET=latin1;

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

CREATE TABLE `invoice_payments` (
  `id` int(11) NOT NULL auto_increment,
  `invoice_id` int(11) default NULL,
  `payment_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL auto_increment,
  `invoiceable_id` int(11) default NULL,
  `invoiceable_type` varchar(255) default NULL,
  `appgen_cust_number` int(11) default NULL,
  `invoice_number` varchar(255) default NULL,
  `invoice_date` date default NULL,
  `invoice_amount` decimal(10,0) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
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
) ENGINE=InnoDB AUTO_INCREMENT=303 DEFAULT CHARSET=latin1;

CREATE TABLE `line_items` (
  `id` int(11) NOT NULL auto_increment,
  `support_deal_id` bigint(11) default NULL,
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
  `subcontract_id` int(11) default NULL,
  `subcontract_cost` decimal(20,2) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_line_items_on_product_num` (`product_num`),
  KEY `index_line_items_on_contract_id` (`support_deal_id`),
  KEY `index_line_items_on_location` (`location`),
  KEY `support_type_position_support_deal_id` (`support_type`,`position`,`support_deal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=179346 DEFAULT CHARSET=latin1;

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

CREATE TABLE `managed_deal_elements` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `hostname` varchar(255) default NULL,
  `ip_address` varchar(255) default NULL,
  `serial_number` varchar(255) default NULL,
  `footprints_id` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `managed_deal_items` (
  `id` int(11) NOT NULL auto_increment,
  `managed_deal_element_id` int(11) default NULL,
  `managed_deal_id` int(11) default NULL,
  `managed_service_id` int(11) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `monthly_price` decimal(10,0) default NULL,
  `description` varchar(255) default NULL,
  `remediation` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `managed_deals` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` varchar(255) default NULL,
  `end_user_id` varchar(255) default NULL,
  `sales_office_id` varchar(255) default NULL,
  `sales_rep_id` varchar(255) default NULL,
  `customer_po_number` varchar(255) default NULL,
  `payment_terms` varchar(255) default NULL,
  `initial_annual_revenue` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  `renewal_created` date default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `managed_services` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `category` varchar(255) default NULL,
  `version` varchar(255) default NULL,
  `description` text,
  `monthly_cost` decimal(10,0) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `manufacturer_lines` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `manufacturer_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=latin1;

CREATE TABLE `manufacturers` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

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

CREATE TABLE `payments` (
  `id` int(11) NOT NULL auto_increment,
  `appgen_cust_number` int(11) default NULL,
  `payment_number` varchar(255) default NULL,
  `payment_date` date default NULL,
  `payment_amount` decimal(10,0) default NULL,
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
  `other_costs` decimal(20,3) default NULL,
  `status` varchar(255) default NULL,
  `modified_by` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `sales_office` varchar(255) default NULL,
  `sales_office_name` varchar(255) default NULL,
  `customer_po` varchar(255) default NULL,
  `customer_po_date` date default NULL,
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `relationships` (
  `id` int(11) NOT NULL auto_increment,
  `successor_id` bigint(11) default NULL,
  `predecessor_id` bigint(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2495 DEFAULT CHARSET=latin1;

CREATE TABLE `roles` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

CREATE TABLE `subcontractors` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `contact_name` varchar(255) default NULL,
  `contact_email` varchar(255) default NULL,
  `contact_phone_work` varchar(255) default NULL,
  `contact_phone_mobile` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `address1` varchar(255) default NULL,
  `address2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `postalcode` varchar(255) default NULL,
  `country` varchar(255) default NULL,
  `note` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

CREATE TABLE `subcontracts` (
  `id` int(11) NOT NULL auto_increment,
  `subcontractor_id` int(11) default NULL,
  `customer_number` varchar(255) default NULL,
  `site_number` varchar(255) default NULL,
  `sales_order_number` varchar(255) default NULL,
  `description` varchar(255) default NULL,
  `quote_number` varchar(255) default NULL,
  `sourcedirect_po_number` varchar(255) default NULL,
  `cost` decimal(20,2) default NULL,
  `hw_response_time` varchar(255) default NULL,
  `sw_response_time` varchar(255) default NULL,
  `hw_repair_time` varchar(255) default NULL,
  `hw_coverage_days` varchar(255) default NULL,
  `sw_coverage_days` varchar(255) default NULL,
  `hw_coverage_hours` varchar(255) default NULL,
  `sw_coverage_hours` varchar(255) default NULL,
  `parts_provided` tinyint(1) default NULL,
  `labor_provided` tinyint(1) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `start_date` date default NULL,
  `end_date` date default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=305 DEFAULT CHARSET=latin1;

CREATE TABLE `support_deals` (
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
  `new_business_dollars` decimal(10,0) default NULL,
  `type` varchar(255) default NULL,
  `list_price_increase` decimal(5,3) default NULL,
  `renewal_created` date default NULL,
  `basic_remote_monitoring` tinyint(1) default NULL,
  `basic_backup_auditing` tinyint(1) default NULL,
  `primary_ce_id` int(11) default NULL,
  `end_user_id` varchar(255) default NULL,
  `site_survey_date` date default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_support_deals_on_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3730 DEFAULT CHARSET=latin1;

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
  `manufacturer_line_id` int(11) default NULL,
  `tlci` tinyint(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_swdb_on_part_number` (`part_number`)
) ENGINE=InnoDB AUTO_INCREMENT=3652 DEFAULT CHARSET=latin1;

CREATE TABLE `swlist_blacklists` (
  `id` int(11) NOT NULL auto_increment,
  `pattern` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=457 DEFAULT CHARSET=latin1;

CREATE TABLE `swlist_whitelists` (
  `id` int(11) NOT NULL auto_increment,
  `pattern` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=94 DEFAULT CHARSET=latin1;

CREATE TABLE `upfront_orders` (
  `id` int(11) NOT NULL auto_increment,
  `appgen_order_id` varchar(255) default NULL,
  `has_upfront_support` tinyint(1) default '1',
  `completed` tinyint(1) default '0',
  `support_deal_id` int(11) default NULL,
  `fishbowl_so_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_upfront_orders_on_appgen_order_id` (`appgen_order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1198 DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=latin1;

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

INSERT INTO schema_migrations (version) VALUES ('20090807140338');

INSERT INTO schema_migrations (version) VALUES ('20090811172226');

INSERT INTO schema_migrations (version) VALUES ('20090817165008');

INSERT INTO schema_migrations (version) VALUES ('20090917183835');

INSERT INTO schema_migrations (version) VALUES ('20090919185947');

INSERT INTO schema_migrations (version) VALUES ('20091024133521');

INSERT INTO schema_migrations (version) VALUES ('20091026213314');

INSERT INTO schema_migrations (version) VALUES ('20091026215214');

INSERT INTO schema_migrations (version) VALUES ('20091027154115');

INSERT INTO schema_migrations (version) VALUES ('20091027161818');

INSERT INTO schema_migrations (version) VALUES ('20091027172353');

INSERT INTO schema_migrations (version) VALUES ('20091105154609');

INSERT INTO schema_migrations (version) VALUES ('20100408150049');

INSERT INTO schema_migrations (version) VALUES ('20100408150121');

INSERT INTO schema_migrations (version) VALUES ('20100408163955');

INSERT INTO schema_migrations (version) VALUES ('20100408164011');

INSERT INTO schema_migrations (version) VALUES ('20101109181937');

INSERT INTO schema_migrations (version) VALUES ('20110617202631');

INSERT INTO schema_migrations (version) VALUES ('20110718134005');

INSERT INTO schema_migrations (version) VALUES ('20111108164115');

INSERT INTO schema_migrations (version) VALUES ('20120117153011');

INSERT INTO schema_migrations (version) VALUES ('20120227214532');

INSERT INTO schema_migrations (version) VALUES ('20120725145159');

INSERT INTO schema_migrations (version) VALUES ('20120727153246');

INSERT INTO schema_migrations (version) VALUES ('20120914191859');

INSERT INTO schema_migrations (version) VALUES ('20130104222842');

INSERT INTO schema_migrations (version) VALUES ('20130205231221');

INSERT INTO schema_migrations (version) VALUES ('20130206135807');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');
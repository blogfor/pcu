<?php
/*
	Project: Abandoned Cart Recovery
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 95 $)

*/

if (!defined('PHP_EOF')) {
	define('PHP_EOF', "\n");
}

require_once(DIR_SYSTEM . 'engine/ka_installer.php');

class ControllerKaExtensionsKaAcr extends KaInstaller {

	protected $error;
	
	protected $extension_version = '2.3.4';
	protected $min_store_version = '1.5.2';
	protected $max_store_version = '1.5.6.9';
	protected $tables;
	protected $xml_file = "ka_acr.xml";
	
	// temporary vars
	protected $last_error;

	public function getTitle() {
		$this->loadLanguage('ka_extensions/ka_acr');
		
		$str = str_replace('{{version}}', $this->extension_version, $this->language->get('extension_title'));
		return $str;
	}

	
	protected function init() {

 		$this->tables = array();
	
 		$this->tables = array(

 			'ka_abandoned_carts' => array(
 				'is_new' => true,
 				'fields' => array(
 					'abandoned_cart_id' => array(
 						'type' => 'int(11)',
 					),
 					'customer_id' => array(
 						'type' => 'int(11)',
 					),
 					'store_id' => array(
 						'type' => 'int(11)'
 					),
 					'email' => array(
 						'type' => 'varchar(255)',
 					),
 					'firstname' => array(
 						'type' => 'varchar(128)',
 					),
 					'lastname' => array(
 						'type' => 'varchar(128)',
 					),
 					'last_visited' => array(
 						'type' =>  'datetime',
 					),
 					'last_reminded' => array(
 						'type' => 'datetime',
 					),
 					'acr_token' => array(
 						'type' => 'varchar(255)',
 					),
 					'acr_subscribed' => array(
 						'type' => 'tinyint(1)',
					),
					'link_opened' => array(
						'type' => 'datetime',
					),
					'cart' => array(
						'type' => 'text',
					),
					'language_id' => array(
						'type' => 'int(11)',
					),
					'salt' => array(
						'type' => 'varchar(16)',
					),
					'order_id' => array(
						'type' => 'int(11)',
					),
				),
				'indexes' => array(
					'PRIMARY' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_abandoned_carts` ADD PRIMARY KEY (`abandoned_cart_id`)",
					),
					'customer_id' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_abandoned_carts` ADD UNIQUE KEY (`customer_id`,`store_id`,`email`)",
					),
					'last_visited' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_abandoned_carts` ADD KEY (`last_visited`)",
					),
				),
			),					
					
			'ka_reminder_emails' => array(
				'is_new' => true,
				'fields' => array(
					'reminder_email_id' => array(
						'type' => 'int(11)',
					),
					'last_edited' => array(
						'type' => 'datetime',
					),
					'last_submitted' => array(
						'type' => 'datetime',
					),
					'sort_order' => array(
						'type' => 'int(11)',
					),
					'enabled' => array(
						'type' => 'tinyint(1)',
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_reminder_emails` ADD `enabled` TINYINT( 1 ) NOT NULL DEFAULT '0'",
					),
					'send_in_hours' => array(
						'type' => 'int(11)',
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_reminder_emails` ADD `send_in_hours` INT( 11 ) NOT NULL DEFAULT '0'",
					),
				),
				'indexes' => array(
					'PRIMARY' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_reminder_emails` ADD PRIMARY KEY (`reminder_email_id`)",
					),
				),
			),
			
			'ka_reminder_emails_descr' => array(
				'is_new' => true,
				'fields' => array(
					'reminder_email_id' => array(
						'type' => 'int(11)',
					),
					'language_id' => array(
						'type' => 'int(11)',
					),
					'name' => array(
						'type' => 'varchar(128)',
					),
					'subject' => array(
						'type' => 'varchar(255)',
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_reminder_emails_descr` ADD `subject` VARCHAR( 255 ) NOT NULL ",
					),
					'description' => array(
						'type' => 'text',
					),
				),
				'indexes' => array(
					'PRIMARY' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_reminder_emails_descr` ADD PRIMARY KEY (`reminder_email_id`,`language_id`)",
					),
				),
			),
			
			'ka_tokens' => array(
				'is_new' => true,
				'fields' => array(
					'abandoned_cart_id' => array(
						'type' => 'int(11)',
					),
					'token' => array(
						'type' => 'varchar(255)',
					),
					'created_at' => array(
						'type' => 'datetime',
					),
				),
				'indexes' => array(
					'PRIMARY' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_tokens` ADD PRIMARY KEY (`abandoned_cart_id`,`token`)",
					),
					'token' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_tokens` ADD INDEX (`token`)",
					),
				),
			),			
		);
 		
		$this->tables['ka_reminder_emails']['query'] = "
			CREATE TABLE `" . DB_PREFIX . "ka_reminder_emails` (
			  `reminder_email_id` int(11) NOT NULL AUTO_INCREMENT,
			  `last_edited` datetime NOT NULL,
			  `last_submitted` datetime NOT NULL,
			  `sort_order` int(11) NOT NULL,
			  `enabled` tinyint(1) NOT NULL DEFAULT '0',
			  `send_in_hours` int(11) NOT NULL DEFAULT '0',			  
			  PRIMARY KEY (`reminder_email_id`),
			  KEY `sort_order` (`sort_order`),
			  KEY `enabled` (`enabled`)
			);
		";

		$this->tables['ka_abandoned_carts']['query'] = "
			CREATE TABLE `" . DB_PREFIX . "ka_abandoned_carts` (
				`abandoned_cart_id` int(11) NOT NULL AUTO_INCREMENT,
				`customer_id` int(11) NOT NULL,
				`store_id` int(11) NOT NULL,
				`email` varchar(255) NOT NULL,
				`firstname` varchar(128) NOT NULL,
				`lastname` varchar(128) NOT NULL,
				`last_visited` datetime NOT NULL,
				`last_reminded` datetime NOT NULL,
				`acr_token` varchar(255) NOT NULL,
				`acr_subscribed` tinyint(1) NOT NULL DEFAULT '1',
				`link_opened` datetime NOT NULL,
				`cart` text NOT NULL,
				`language_id` int(11) NOT NULL,
				`salt` varchar(16) NOT NULL,
				`order_id` int(11) NOT NULL,
				PRIMARY KEY (`abandoned_cart_id`),
				UNIQUE KEY `customer_id` (`customer_id`,`store_id`,`email`),
				KEY `last_visited` (`last_visited`)
			);
		";
						
		$this->tables['ka_reminder_emails_descr']['query'] = "
			CREATE TABLE `" . DB_PREFIX . "ka_reminder_emails_descr` (
			  `reminder_email_id` int(11) NOT NULL,
			  `language_id` int(11) NOT NULL,
			  `name` varchar(128) NOT NULL,
			  `subject` varchar(255) NOT NULL,
			  `description` text NOT NULL,
			  PRIMARY KEY (`reminder_email_id`,`language_id`)
			);
		";

		$this->tables['ka_tokens']['query'] = "
			CREATE TABLE `" . DB_PREFIX . "ka_tokens` (
			`abandoned_cart_id` int(11) NOT NULL,
			`token` varchar(255) NOT NULL,
			`created_at` datetime NOT NULL,
			PRIMARY KEY (`abandoned_cart_id`,`token`),
			KEY `token` (`token`)
			);
		";
						
		return true;
	}


	public function index() {
		$this->loadLanguage('ka_extensions/ka_acr');

		$this->load->model('sale/ka_abandoned_carts');
		$this->load->model('tool/ka_tasks');
		
		$heading_title = $this->getTitle();
		$this->document->setTitle($heading_title);
		
		$this->load->model('setting/setting');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {

			if (!isset($this->request->post['ka_acr_auto_login_link'])) {
				$this->request->post['ka_acr_auto_login_link'] = '';
			}
			if (!isset($this->request->post['ka_acr_show_unsubscribed'])) {
				$this->request->post['ka_acr_show_unsubscribed'] = '';
			}
			if (empty($this->request->post['ka_acr_link_expires_in_hours'])) {
				$this->request->post['ka_acr_link_expires_in_hours'] = 24;
			}
			if (!isset($this->request->post['ka_acr_show_carts_wo_delay'])) {
				$this->request->post['ka_acr_show_carts_wo_delay'] = 'N';
			}
				
			$this->model_setting_setting->editSetting('ka_acr', $this->request->post);
			$this->addTopMessage($this->language->get('Settings have been stored sucessfully.'));
									
			$this->redirect($this->url->link('extension/ka_extensions', 'token=' . $this->session->data['token'], 'SSL'));
			
		} elseif ($this->request->server['REQUEST_METHOD'] == 'POST') {
			$this->data = $this->request->post;

		} else {
			$this->data['ka_acr_link_expires_in_hours'] = $this->config->get('ka_acr_link_expires_in_hours');
			$this->data['ka_acr_auto_login_link']       = $this->config->get('ka_acr_auto_login_link');
			$this->data['ka_acr_show_unsubscribed']     = $this->config->get('ka_acr_show_unsubscribed');
			$this->data['ka_acr_show_carts_wo_delay']   = $this->config->get('ka_acr_show_carts_wo_delay');
			$this->data['ka_acr_images_in_emails']      = $this->config->get('ka_acr_images_in_emails');
		}

		$this->data['heading_title']   = $heading_title;

		$this->data['button_save']     = $this->language->get('button_save');
		$this->data['button_cancel']   = $this->language->get('button_cancel');

		$this->data['extension_version'] = $this->extension_version;
		$this->data['error']             = $this->error;

		$this->data['install_status'] = $this->model_sale_ka_abandoned_carts->getTaskInstallStatus($tasks);
		if ($this->data['install_status'] == 'task_installed') {
			$scheduler_status = $this->model_tool_ka_tasks->getCronjobInstallStatus();
			if ($scheduler_status != 'cronjob_installed') {
				$this->data['install_status'] = 'scheduler_not_configured';
			}
		}
		
 		if (isset($this->error['warning'])) {
			$this->data['error_warning'] = $this->error['warning'];
		} else {
			$this->data['error_warning'] = '';
		}

		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
			'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
			'separator' => false
		);

  		$this->data['breadcrumbs'][] = array(
	 		'text'      => $this->language->get('Ka Extensions'),
			'href'      => $this->url->link('extension/ka_extensions', 'token=' . $this->session->data['token'], 'SSL'),
   			'separator' => ' :: '
 		);
		
 		$this->data['breadcrumbs'][] = array(
	 		'text'      => $heading_title,
			'href'      => $this->url->link('ka_extensions/ka_acr', 'token=' . $this->session->data['token'], 'SSL'),
   			'separator' => ' :: '
 		);
		
		$this->data['action'] = $this->url->link('ka_extensions/ka_acr', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['cancel'] = $this->url->link('extension/ka_extensions', 'token=' . $this->session->data['token'], 'SSL');
		
		$this->data['emails_url'] = $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'], 'SSL');

		$this->template = 'ka_extensions/ka_acr.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

		
	protected function validate() {
		if (!$this->user->hasPermission('modify', 'ka_extensions/ka_acr')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}
		
		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}
	

	public function install() {

		$this->init();
		
		//install task scheduler
		if (!$this->db->isKaInstalled('ka_scheduler')) {
		
			$this->addTopMessage('Task Scheduler extension has to be installed first', 'E');
			return false;
		}


		if (!parent::install()) {
			return false;
		}
		
		$this->load->model('tool/ka_tasks');
		$task = array(
			'name'        => 'Abandoned Cart Recovery',
			'module'      => 'sale/ka_abandoned_carts',
			'period_type' => 'hour',
			'active' => 'Y',
		);
		
		$this->model_tool_ka_tasks->installTask($task, true);

		$this->load->model('setting/extension');
		$this->load->model('setting/setting');
		
		$rec = array(
			'ka_acr_link_expires_in_hours' => 72,
			'ka_acr_auto_login_link' => 'Y',
			'ka_acr_show_unsubscribed' => 'Y',
			'ka_acr_show_carts_wo_delay' => 'N'
		);
		$this->model_setting_setting->editSetting('ka_acr', $rec);
		
		$this->load->model('user/user_group');
		$this->model_user_user_group->addPermission($this->user->getId(), 'access', 'sale/ka_abandoned_carts');
		$this->model_user_user_group->addPermission($this->user->getId(), 'modify', 'sale/ka_abandoned_carts');
		
		$this->model_user_user_group->addPermission($this->user->getId(), 'access', 'localisation/ka_reminder_emails');
		$this->model_user_user_group->addPermission($this->user->getId(), 'modify', 'localisation/ka_reminder_emails');

		$this->load->model('localisation/ka_reminder_emails');
		$this->model_localisation_ka_reminder_emails->prefillReminderEmails();

		$this->load->model('sale/ka_abandoned_carts');
		$this->model_sale_ka_abandoned_carts->importStandardCarts();
		
		return true;
	}

	public function uninstall() {
		$this->load->model('tool/ka_tasks');
		
		$tasks = $this->model_tool_ka_tasks->enumTasks('sale/ka_abandoned_carts');
		if (!empty($tasks)) {
			foreach($tasks as $tk => $tv) {
				$this->model_tool_ka_tasks->uninstallTask($tv['task_id']);
			}
		}
		
		$this->load->model('setting/setting');
	}
}
?>
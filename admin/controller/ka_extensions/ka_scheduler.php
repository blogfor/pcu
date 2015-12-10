<?php
/*
	Project: Task Scheduler
	Author : karapuz <support@ka-station.com>

	Version: 1 ($Revision: 54 $)

*/

if (!defined('PHP_EOF')) {
	define('PHP_EOF', "\n");
}

require_once(DIR_SYSTEM . 'engine/ka_installer.php');

class ControllerKaExtensionsKaScheduler extends KaInstaller {

	protected $extension_version = '1.4.3';
	protected $min_store_version = '1.5.1';
	protected $max_store_version = '1.5.6.9';
	protected $tables;
	protected $xml_file = "ka_scheduler.xml";
	
	// temporary vars
	protected $error;

	public function getTitle() {
		$this->loadLanguage('ka_extensions/ka_scheduler');
		
		$this->load->model('tool/ka_tasks');
		$version = $this->extension_version;
		if ($this->model_tool_ka_tasks->isLite()) {
			$version .= ' Lite';
		}
		
		$str = str_replace('{{version}}', $version, $this->language->get('extension_title'));
		return $str;
	}

	
	protected function init() {

 		$this->tables = array();
	
 		$this->tables = array(
 		
 			'ka_tasks' => array(
 				'is_new' => true,
 				'fields' => array(
  					'task_id' => array(
  						'type' => 'int(11)',
  					),
  					'name' => array(
  						'type' => 'varchar(128)',
  					),
  					'active' => array(
  						'type' => "enum('N','Y')",
  					),
  					'priority' => array(
  						'type' => 'int(11)',
  					),
  					'module' => array(
  						'type' => 'varchar(255)',
  					),
  					'operation' => array(
  						'type' => 'varchar(128)',
  					),
  					'params' => array(
  						'type' => 'text',
  					),
  					'period_type' => array(
  						'type' => "enum('hour','day','week','month','year')",
  					),
  					'period_at_min' => array(
  						'type' => 'int(4)',
  					),
  					'period_at_hour' => array(
  						'type' => 'int(4)',
  					),
  					'period_at_day' => array(
  						'type' => 'int(4)',
  					),
  					'period_at_dow' => array(
  						'type' => 'int(4)',
  					),
  					'period_at_month' => array(
  						'type' => 'int(4)',
  					),
  					'start_at' => array(
  						'type' => 'datetime',
  					),
  					'end_at' => array(
  						'type' => 'datetime',
  					),
  					'stat' => array(
  						'type' => 'mediumblob',
  					),
  					'complete_count' => array(
  						'type' => 'int(11)',
  					),
  					'run_status' => array(
  						'type' => "enum('not_started','working','not_finished')",
  					),
  					'first_run' => array(
  						'type' => 'datetime',
  					),
  					'last_run' => array(
  						'type' => 'datetime',
  					),
  					'fail_count' => array(
  						'type' => 'int(11)',
  					),
  					'run_count' => array(
  						'type' => 'int(11)',
  					),
  					'session_data' => array(
  						'type' => 'mediumblob',
  					),
  				),
				'indexes' => array(
					'PRIMARY' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_tasks` ADD PRIMARY KEY (`task_id`)",
					),
					'name' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_tasks` ADD INDEX (`name`)",
					),
					'last_run' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_tasks` ADD INDEX (`last_run`)",
					),
					'priority' => array(
						'query' => "ALTER TABLE `" . DB_PREFIX . "ka_tasks` ADD INDEX (`priority`)",
					),
				),
			),
		); 		
 		
		$this->tables['ka_tasks']['query'] = "
			CREATE TABLE `" . DB_PREFIX . "ka_tasks` (
			  `task_id` int(11) NOT NULL AUTO_INCREMENT,
			  `name` varchar(128) NOT NULL,
			  `active` enum('N','Y') NOT NULL,
			  `priority` int(11) NOT NULL,
			  `module` varchar(255) DEFAULT NULL,
			  `operation` varchar(128) DEFAULT NULL,
			  `params` text NOT NULL,
			  `period_type` enum('hour','day','week','month','year') DEFAULT 'day',
			  `period_at_min` int(4) NOT NULL,
			  `period_at_hour` int(4) NOT NULL,
			  `period_at_day` int(4) NOT NULL,
			  `period_at_dow` int(4) NOT NULL,
			  `period_at_month` int(4) NOT NULL,
			  `start_at` datetime NOT NULL,
			  `end_at` datetime NOT NULL,
			  `stat` mediumblob NOT NULL,
			  `complete_count` int(11) NOT NULL,
			  `run_status` enum('not_started','working','not_finished') NOT NULL,
			  `first_run` datetime NOT NULL,
			  `last_run` datetime NOT NULL,
			  `fail_count` int(11) NOT NULL,
			  `run_count` int(11) NOT NULL,
			  `session_data` mediumblob NOT NULL,
			  PRIMARY KEY (`task_id`),
			  KEY `name` (`name`),
			  KEY `last_run` (`last_run`),
			  KEY `priority` (`priority`)
			);
		";

		return true;
	}

	
	public function index() {
		$this->loadLanguage('ka_extensions/ka_scheduler');
		$this->load->model('tool/ka_tasks');

		// handle autoinstall actions
		//
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && !empty($this->request->post['mode'])) {
		
			if ($this->request->post['mode'] == 'install') {
			
				$this->model_tool_ka_tasks->installCronjob();
				
			} elseif ($this->request->post['mode'] == 'uninstall') {
			
				$this->model_tool_ka_tasks->deleteCronjob();
				
			} elseif ($this->request->post['mode'] == 'reinstall') {
			
				if ($this->model_tool_ka_tasks->deleteCronjob()) {
					$this->model_tool_ka_tasks->installCronjob();
				}
			}

			$this->redirect($this->url->link('ka_extensions/ka_scheduler', 'token=' . $this->session->data['token'], 'SSL'));
		}
		
		$heading_title = $this->getTitle();
		$this->document->setTitle($heading_title);
		
		$this->load->model('setting/setting');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {

			if (empty($this->request->post['ka_ts_send_email_on_completion'])) {
				$this->request->post['ka_ts_send_email_on_completion'] = '';
			}
				
			$this->model_setting_setting->editSetting('ka_scheduler', $this->request->post);
			$this->addTopMessage($this->language->get('Settings have been stored sucessfully.'));
									
			$this->redirect($this->url->link('extension/ka_extensions', 'token=' . $this->session->data['token'], 'SSL'));
			
		} elseif ($this->request->server['REQUEST_METHOD'] == 'POST') {
			$this->data = $this->request->post;

		} else {
			$this->data['ka_ts_run_scheduler_key']        = $this->config->get('ka_ts_run_scheduler_key');
			$this->data['ka_ts_send_email_on_completion'] = $this->config->get('ka_ts_send_email_on_completion');

			$this->data['ka_ts_stop_task_after_n_minutes']    = $this->config->get('ka_ts_stop_task_after_n_minutes');
			$this->data['ka_ts_stop_task_after_n_failures']   = $this->config->get('ka_ts_stop_task_after_n_failures');
			$this->data['ka_ts_task_is_dead_after_n_minutes'] = $this->config->get('ka_ts_task_is_dead_after_n_minutes');
		}

		$cronjob_install_status = $this->model_tool_ka_tasks->getCronjobInstallStatus();
		$this->data['cronjob_install_status'] = $cronjob_install_status;
						
		$this->data['heading_title']   = $heading_title;
	
		$this->data['button_save']     = $this->language->get('button_save');		
		$this->data['button_cancel']   = $this->language->get('button_cancel');

		$this->data['extension_version']        = $this->extension_version;
		$this->data['run_scheduler'] = $this->url->link('catalog/ka_run_scheduler', 'key='. $this->data['ka_ts_run_scheduler_key'], 'SSL');
		$this->data['error'] = $this->error;
		
		
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
			'href'      => $this->url->link('ka_extensions/ka_scheduler', 'token=' . $this->session->data['token'], 'SSL'),
   			'separator' => ' :: '
 		);
		
		$this->data['action'] = $this->url->link('ka_extensions/ka_scheduler', 'token=' . $this->session->data['token'], 'SSL');
		$this->data['cancel'] = $this->url->link('extension/ka_extensions', 'token=' . $this->session->data['token'], 'SSL');

		$this->template = 'ka_extensions/ka_scheduler.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
	}

		
	protected function validate() {
		if (!$this->user->hasPermission('modify', 'ka_extensions/ka_scheduler')) {
			$this->addTopMessage($this->language->get('error_permission'), 'E');
			return false;
		}
		
		if (empty($this->request->post['ka_ts_run_scheduler_key'])) {
			$this->error['ka_ts_run_scheduler_key'] = 'The key is empty. This value is required for security reasons.';
		}
		
		$stop_activity = (int)$this->request->post['ka_ts_stop_task_after_n_minutes'];
		if ($stop_activity < 1 || $stop_activity > 360) {
			$this->error['ka_ts_stop_task_after_n_minutes'] = 'The value should be between 1 and 360 minutes';
		}
		
		$stop_fails = (int)$this->request->post['ka_ts_stop_task_after_n_failures'];
		if ($stop_fails < 1 || $stop_fails > 10) {
			$this->error['ka_ts_stop_task_after_n_failures'] = 'The value should be between 1 and 10 times';
		}

		if (!empty($stop_activity)) {
			$dead = (int)$this->request->post['ka_ts_task_is_dead_after_n_minutes'];
			if ($dead < 1 || $dead > $stop_activity) {
				$this->error['ka_ts_task_is_dead_after_n_minutes'] = "The value should be between 1 and $stop_activity minutes";
			}
		}
				
		if (!$this->error) {
			return true;
		} else {
			return false;
		}
	}
	

	public function install() {

		if (parent::install()) {
			$this->load->model('setting/setting');
			
			$rec = array(
				'ka_ts_run_scheduler_key'            => rand(0, 99999),
				'ka_ts_stop_task_after_n_minutes'    => 30,
				'ka_ts_stop_task_after_n_failures'   => 2,
				'ka_ts_task_is_dead_after_n_minutes' => 5,
				'ka_ts_send_email_on_completion'     => 'Y',
			);
		
			$this->model_setting_setting->editSetting('ka_scheduler', $rec);
		
			$this->load->model('user/user_group');
			$this->model_user_user_group->addPermission($this->user->getId(), 'access', 'tool/ka_tasks');
			$this->model_user_user_group->addPermission($this->user->getId(), 'modify', 'tool/ka_tasks');
			
			return true;
		} 
		
		return false;
	}

	public function uninstall() {
		$this->load->model('setting/setting');
		$this->model_setting_setting->deleteSetting('ka_scheduler_hidden');
	}	
}
?>
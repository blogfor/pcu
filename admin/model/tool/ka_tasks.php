<?php 
/*
	Project: Task Scheduler
	Author : karapuz <support@ka-station.com>

	Version: 1 ($Revision: 53 $)

*/

require_once(DIR_SYSTEM . 'library/ka_db.php');

if (!function_exists('utf8_strlen')) {
	function utf8_strlen($string) {
		return strlen(utf8_decode($string));
	}
}

class ModelToolKaTasks extends Model {

	protected $config_group    = 'ka_scheduler_hidden';
	protected $config_store_id = 0;
	protected $log_file        = 'ka_scheduler.log';

	protected $kadb;
	protected $custom_log;
	
	// temporary variables
	protected $wget_path;
	protected $crontab_path;
	protected $last_error;

	function __construct($registry) {
		parent::__construct($registry);
		
		$this->custom_log = new Log($this->log_file);
		$this->kadb = new KaDb($this->db);	
	}

	
	public function logMessage($msg) {
		$this->custom_log->write($msg);
	}

	
	public function getSqlNow() {
		$qry = $this->db->query("SELECT NOW() as now_val");
		if (empty($qry->row)) {
			trigger_error("getNow fails.");
		}
		
		return $qry->row['now_val'];
	}


	public function isLite() {
		if (!file_exists(DIR_TEMPLATE . '/tool/ka_task_form.tpl')) {
			return true;
		}
		
		return false;
	}

	/*
		http://stackoverflow.com/questions/3938120/check-if-exec-is-disabled
	*/
	public function isExecAvailable() {
		static $available;

		if (!isset($available)) {
			$available = true;
			if (ini_get('safe_mode')) {
				$available = false;
			} else {
				$d = ini_get('disable_functions');
				$s = ini_get('suhosin.executor.func.blacklist');
				if ("$d$s") {
					$array = preg_split('/,\s*/', "$d,$s");
					if (in_array('exec', $array)) {
						$available = false;
					}
				}
			}
		}

		return $available;
	}
	
	
	public function customExec($command, &$output, &$return_var) {
	
		if (!$this->isExecAvailable()) {
			$output     = '';
			$return_var = '';

			return false;
		}
		
		$res = exec($command, $output, $return_var);
	
		return $res;
	}

			
	public function calcNextRun($now, $t) {
	
		$d = getdate($now);
		
		$rec = array();
		
		if ($t['period_type'] == 'year') {
			$rec = array(
				'minutes' => $t['period_at_min'],
				'hours'   => $t['period_at_hour'],
				'mday'    => $t['period_at_day'],
				'mon'     => $t['period_at_month'],
				'mon'     => $t['period_at_month'],
				'year'    => $d['year'] + 1,
			);
			
		} elseif ($t['period_type'] == 'month') {
			$rec = array(
				'minutes' => $t['period_at_min'],
				'hours'   => $t['period_at_hour'],
				'mday'    => $t['period_at_day'],
				'mon'     => intval($d['mon']) + 1,
			);
			
		} elseif ($t['period_type'] == 'day') {
			$rec = array(
				'minutes' => $t['period_at_min'],
				'hours'   => $t['period_at_hour'],
				'mday'    => $d['mday'] + 1,
			);

		} elseif ($t['period_type'] == 'hour') {
			$rec = array(
				'minutes' => $t['period_at_min'],
				'hours'   => $d['hours'] + 1,
			);
		
		} elseif ($t['period_type'] == 'week') {
			$wday = ($d['wday'] + 1);
			$mday = (7 + $t['period_at_dow'] - $wday);
			if ($mday > 7)
				 $mday = $mday % 7;

			$rec = array(
				'minutes' => $t['period_at_min'],
				'hours'   => $t['period_at_hour'],
				'mday' => ($d['mday'] + $mday)
			);
		}

		$d = array_merge($d, $rec);
		

		$ret = mktime ($d['hours'], $d['minutes'], 0, $d['mon'], $d['mday'], $d['year']);
		
		return $ret;
	}
	
	
	public function changeTaskStatus($task_id, $status) {
	
		$rec = array(
			'run_status' => $status
		);
		
		if ($status == 'not_started') {
			$rec['fail_count'] = 0;
		}
		
		$this->kadb->queryUpdate('ka_tasks', $rec, "task_id = '$task_id'");	
	}
	
	
	public function stopTask($task_id) {
	
		$task = $this->getTask($task_id);
		if (empty($task) || !in_array($task['run_status'], array('working', 'not_finished'))) {
			return false;
		}

		$this->load->model($task['module']);
		$name = 'model_' . str_replace('/', '_', $task['module']);

		$this->logMessage("stopTask function started for task_id = $task_id");
		
		if (method_exists($this->$name, 'stopSchedulerOperation')) {
			$this->$name->stopSchedulerOperation($current_task['operation']);
		}
		
		$this->changeTaskStatus($task_id, 'not_started');

		$this->logMessage("stopTask function finished for task_id = $task_id");
		return true;
	}
	

	public function saveTask($data) {

		if (empty($data)) {
			return false;
		}	
	
		$valid_columns = array(
			'task_id', 'name', 'active', 'priority', 'module', 'operation', 'params',
			'period_type', 'period_at_min', 'period_at_hour', 'period_at_day', 'period_at_dow',
			'period_at_month', 'start_at', 'end_at'
		);
	
		$rec = array();
		foreach ($data as $dk => $dv) {
			if (in_array($dk, $valid_columns)) {
				$rec[$dk] = $dv;
			}
		}
		
		if (isset($rec['params'])) {
			$rec['params'] = serialize($rec['params']);
		}
		
		if (empty($data['task_id'])) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "ka_tasks SET 
				module = '" . $this->db->escape($data['module']) . "'"
			);
			$task_id = $this->db->getLastId();
		} else {
			$task_id = $data['task_id'];
		}
		unset($rec['task_id']);
			
		$this->kadb->queryUpdate('ka_tasks', $rec, "task_id = '$task_id'");
		
		return $task_id;
	}
	
	
	public function deleteTask($task_id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "ka_tasks WHERE task_id = '" . (int)$task_id . "'");
	}

		
	public function getTask($task_id, $decode = false) {
	
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "ka_tasks 
			WHERE task_id = '" . (int)$task_id . "'"
		);
		
		if (!empty($query->row)) {
			$query->row['params'] = unserialize($query->row['params']);
			$query->row['stat'] = unserialize($query->row['stat']);
		}
		
		if ($decode && !empty($query->row['params'])) {
			foreach ($query->row['params'] as &$p) {
				$p = htmlspecialchars_decode($p);
			}
		}
		
		return $query->row;
	}

	
	protected function getRecords($data) {

		if (empty($data['fields'])) {
			trigger_error("ka_scheduler: No fields data in getRecords() function");
			return false;
		}
	
		$sql = "SELECT " . $data['fields'] . " FROM " . DB_PREFIX . "ka_tasks kt ";
		
		if (!empty($data['where'])) {
			$sql .= " WHERE " . $data['where'];
		}
		
		if (!empty($data['sort'])) {
			$sql .= " ORDER BY " . $data['sort'];
			
			if (!empty($data['order'])) {
				$sql .= ' ' . $data['order'];
			}
		}
		
		if (isset($data['start']) || isset($data['limit'])) {
			if ($data['start'] < 0) {
				$data['start'] = 0;
			}				

			if ($data['limit'] < 1) {
				$data['limit'] = 20;
			}
		
			$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];

		}

		$query = $this->db->query($sql);
		
		return $query;
	}
	
	
	public function getTasks($data = array()) {
	
		$data['fields'] = '*';

		$qry = $this->getRecords($data);
		
		return $qry->rows;
	}
	
	
	public function getTasksTotal($params) {
	
      	$data['fields'] = 'COUNT(*) AS total';
      	
		$qry = $this->getRecords($data);
		
		return $qry->row['total'];
	}
	

	public function isSchedulerModel($model) {
	
		$file = KaVQMod::modCheck(DIR_APPLICATION . 'model/' . $model . '.php');
		
		$class = 'Model' . preg_replace('/[^a-zA-Z0-9]/', '', $model);
		
		if (!file_exists($file)) {
			return false;
		}
			
		$content = file_get_contents($file);
		if (!preg_match("/class[\s]*$class\s/i", $content)) {
			return false;
		}
		
		@include_once($file);

		if (!class_exists($class)) {
			return false;
		}
		
		$methods = get_class_methods($class);
		if (empty($methods)) {
			return false;
		}
		
		if (in_array('runSchedulerOperation', $methods)) {
			return true;
		}
			
		return false;
	}


	/*
	
		RETURNS:
			on error   - false
			on success - array with module (model) names:
						$models = array(
							'1' => 'catalog/product',
							'2' => 'catalog/category',
							'3' => 'user/user'
						);
	*/
	public function getSchedulerModules() {

		// get scheduler models
		//	
		$models = array();
		
		$files = glob(DIR_APPLICATION . 'model/*/*.php');
		
		foreach ($files as $file) {
			$data = explode('/', dirname($file));
			$model = end($data) . '/' . basename($file, '.php');
			
			$models[] = $model;
		}
		
		if (empty($models)) {
			return false;
		}
		
		$scheduler_models = array();
		foreach ($models as $model) {
			if (!$this->isSchedulerModel($model)) {
				continue;
			}
			
			$scheduler_models[$model] = $model;
		}
		
		return $scheduler_models;
	}
	
	
	public function getSchedulerOperations($module) {
		
		if (!$this->isSchedulerModel($module)) {
			return false;
		}
		
		$this->load->model($module);
		$name = 'model_' . str_replace('/', '_', $module);
		
		if (method_exists($this->$name, 'requestSchedulerOperations')) {
			$ops = $this->$name->requestSchedulerOperations();
		} else {
			$ops = array();
		}

		return $ops;
	}

	/*
		EXAMPLE:
		$params = array(
			'param1' => array(
				'title' => 'Parameter 1',
				'type' => 'select',
				'options' => array(
					'key1' => 'value1',
					'key2' => 'value2'
				),
				'required' => true,
			),
			'param2' => array(
				'title' => 'Parameter 2',
				'type' => 'select',
				'options' => array(
					'key3' => 'value3',
					'key4' => 'value4'
				),
				'required' => true,
			),
		);
	*/
	public function getOperationParams($module, $operation) {
	
		if (!$this->isSchedulerModel($module)) {
			return false;
		}
		
		$this->load->model($module);
		$name = 'model_' . str_replace('/', '_', $module);

		if (method_exists($this->$name, 'requestSchedulerOperationParams')) {				
			$params = $this->$name->requestSchedulerOperationParams($operation);
		} else {
			$params = array();
		}
		
		return $params;
	}
	
	
	public function getPeriodTypes() {
	
		$types = array(
			'hour'   => $this->language->get('Hour'),
			'day'    => $this->language->get('Day'),
			'week'   => $this->language->get('Week'),
			'month'  => $this->language->get('Month'),
			'year'   => $this->language->get('Year'),
		);
		
		return $types;
	}

	public function getPeriodMinutes() {
		$res = range(0, 59);
		return $res;
	}

	public function getPeriodHours() {
		$res = range(0, 23);
		return $res;
	}

	public function getPeriodDays() {
		$res = range(1, 31);
		$res = array_combine($res, $res);
		return $res;
	}
			
	public function getPeriodDows() {
		$res = array(
			'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
		);
		$res = array_combine(range(1, 7), $res);
		
		return $res;
	}

	public function getPeriodMonths() {
		$res = range(1, 12);
		$res = array_combine($res, $res);
		
		return $res;
	}


	public function getConfigHidden($key) {
		
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "setting WHERE 
			store_id = '" . (int)$this->config_store_id . "' 
			AND `group` = '" . $this->db->escape($this->config_group) . "'
			AND `key` = '" . $this->db->escape($key) . "'"
		);

		if (empty($query->row)) {
			return null;
		}
		
		if ($query->row['serialized']) {
			$value = unserialize($query->row['value']);
		} else {
			$value = $query->row['value'];
		}
		
		return $value;
	}
			
	
	public function setConfigHidden($key, $value) {
	
		$this->db->query("DELETE FROM " . DB_PREFIX . "setting WHERE 
			store_id = '" . (int)$this->config_store_id . "' 
			AND `group` = '" . $this->db->escape($this->config_group) . "'
			AND `key` = '" . $this->db->escape($key) . "'"
		);
		
		$serialized = 0;
		if (is_array($value)) {
			$value = serialize($value);
			$serialized = 1;
		}
				
		$this->db->query("INSERT INTO " . DB_PREFIX . "setting SET 
			store_id = '" . (int)$this->config_store_id . "', 
			`group` = '" . $this->db->escape($this->config_group) . "', 
			`key` = '" . $this->db->escape($key) . "', 
			`value` = '" . $this->db->escape($value) . "',
			serialized = '$serialized'"
		);
	}

	
	public function installTask($task, $replace = false) {

		if (empty($task['module'])) {
			$this->lastError = 'Invalid parameters';
			return false;
		}
		
		if ($replace) {
			$this->db->query("DELETE FROM " . DB_PREFIX . "ka_tasks WHERE
				module = '" . $this->db->escape($task['module']) . "'");			
		}
		
		$this->saveTask($task);
	}


	public function uninstallTask($task_id) {
		$this->deleteTask($task_id);
	}
	

	public function enumTasks($module) {
	
		$data['fields'] = '*';
		$data['where']  = "module = '" . $this->db->escape($module) . "'";

		$res = $this->getRecords($data);
		
		return $res->rows;
	}
	
	
	/*
		returns a text code:
			'crontab_not_found' - warning
			'wget_not_found'    - warning
						
			'cronjob_not_found' - warning
			'wrong_cronjob'     - error
			
			'cronjob_installed' - ok
	*/
	public function getCronjobInstallStatus() {
		
		// check availability of the 'crontab' command
		//
		$res = $out = false;
		$this->customExec("which crontab", $out, $res);
		
		if (!empty($res) || empty($out)) {
			return 'crontab_not_found';
		}
		$this->crontab_path = $out[0];

		
		// check availability of the 'wget' command
		//
		$res = $out = false;
		$this->customExec("which wget", $out, $res);
		if (!empty($res)) {
			return 'wget_not_found';
		}
		$this->wget_path = $out[0];

		$status = $this->examineCrontabFile();
		
		return $status;
	}
	
	
	/*
		Returns:
			'cronjob_not_found' - 
			'wrong_cronjob'     - 			
			'cronjob_installed' - 			
	*/	
	protected function examineCrontabFile() {
		$res = 'cronjob_not_found';
	
		if (empty($this->crontab_path) || empty($this->wget_path)) {
			return $res;
		}
	
		$st = $out = false;
		$this->customExec($this->crontab_path . " -l", $out, $st);

		if (!empty($st)) {
			return $res;
		}

		if (empty($out)) {
			return 'cronjob_not_found';
		}
		
		$script_key   = $this->config->get('ka_ts_run_scheduler_key');
		
		$script_found = false;
		$wget_found   = false;
		
		$key_valid    = false;
		$wget_valid   = false;
		
		$lines = $out;

		foreach ($lines as $lk => $line) {
			
			$key       = '';
			$wget_path = '';
	
			if (preg_match("/catalog\/ka_run_scheduler/", $line, $matches)) {
				$script_found = true;
				if (preg_match("/key=([\S]*)[\"]/", $line, $matches)) {
					if ($matches[1] == $script_key) {
						$key_valid = true;
					}
										
					if (preg_match("/(\S*)\/wget/", $line, $matches)) {
						$wget_found = true;
						if ($matches[0] == $this->wget_path) {
							$wget_valid = true;
							break;
						} else {
							$wget_valid = false;
						}
					}
				}
			}
		}
	
		if (!$script_found) {
			return 'cronjob_not_found';
		}
		
		if ($key_valid && $wget_valid) {
			return 'cronjob_installed';
		}
		
		return 'wrong_cronjob';
	}
	

	/*
		Returns 
			true  - on success
			false - on failre
			
			Additional information can be found in the last_error variable;
	*/
	public function installCronjob() {
		$status = $this->getCronjobInstallStatus();

		$this->last_error = '';		
		if (in_array($status, array('crontab_not_found', 'wget_not_found'))) {
			$this->last_error = 'Cronjob cannot be installed on the server';
			return false;
		}

		$st = $crontab_content = false;
		$this->customExec($this->crontab_path . " -l", $crontab_content, $st);
		if (!empty($st)) {
			$this->last_error = 'Cronjob cannot be installed on the server';
			return false;
		}

		// another example of cronjob line:
		//
		// /usr/bin/wget -O /dev/null "http://ka-station.com/test1541/admin/index.php?route=catalog/ka_run_scheduler&key=123" -q --no-check-certificate
		//
		$cronjob_line = "*/2 * * * * " . $this->wget_path . " -O - \"" .
			HTTP_SERVER . 
			"index.php?route=catalog/ka_run_scheduler&key=" .
			$this->config->get('ka_ts_run_scheduler_key') .
			"\" --no-check-certificate >/dev/null 2>&1"
		;
		
		$lines = $crontab_content;
		$lines[] = $cronjob_line;
		$crontab_content = implode(PHP_EOF, $lines) . PHP_EOF;
	
		$file = tempnam(DIR_CACHE, 'cron_');
		if (file_put_contents($file, $crontab_content) === FALSE) {
			$this->last_error = "Cannot create a temporary crontab file";
			return false;
		}
		$out = $st = false;
		$this->customExec($this->crontab_path . " " . $file, $out, $st);		
		@unlink($file);
		if (!empty($st)) {
			$this->last_error = 'Cronjob cannot be installed on the server';
			return false;
		}

		return true;			
	}
	
	
	public function deleteCronjob() {
		$status = $this->getCronjobInstallStatus();

		$this->last_error = '';		
		if (in_array($status, array('crontab_not_found'))) {
			$this->last_error = 'Crontab does not exist on the server';
			return false;
		}

		$crontab_content = $st = false;
		$this->customExec($this->crontab_path . " -l", $crontab_content, $st);
		if (!empty($st)) {
			$this->last_error = 'Crontab file is not available on the server';
			return false;
		}

		$lines = $crontab_content;
		$new_lines = array();
		
		foreach ($lines as $lk => $lv) {
			
			if (!preg_match("/catalog\/ka_run_scheduler/", $lv, $matches)) {
				$new_lines[] = $lv;
			}
		}
		$crontab_content = implode(PHP_EOF, $new_lines) . PHP_EOF;
	
		$file = tempnam(DIR_CACHE, 'cron_');
		if (file_put_contents($file, $crontab_content) === FALSE) {
			$this->last_error = "Cannot create a temporary crontab file";
			return false;
		}
		$out = $st = '';
		$this->customExec($this->crontab_path . " " . $file, $out, $st);	
		@unlink($file);
		if (!empty($st)) {
			$this->last_error = 'New crontab file cannot be installed on the server';
			return false;
		}

		return true;			
	}
	
}

?>
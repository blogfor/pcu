<?php
/*
	Project: Task Scheduler
	Author : karapuz <support@ka-station.com>

	Version: 1 ($Revision: 44 $)

*/

require_once(DIR_SYSTEM . 'engine/ka_controller.php');

class ControllerToolKaTasks extends KaController { 

	protected function onLoad() {
		$this->loadLanguage('ka_extensions/ka_scheduler');
		$this->load->model('localisation/language');
		$this->load->model('tool/ka_tasks');
	}

			
  	public function index() {
  	
    	$this->document->setTitle($this->language->get('Task Scheduler'));
    	$this->getList();
  	}


  	public function save() {

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {

      		$this->model_tool_ka_tasks->saveTask($this->request->post);
		  	
			$url = '';
			if (isset($this->session->data['ka_tasks_url'])) {
				$url = $this->session->data['ka_tasks_url'];
			}
			
   	  		$this->redirect($this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
    	$this->getForm();
  	}
  		

  	public function stop() {

		if (!empty($this->request->get['task_id'])) {
	   		$this->model_tool_ka_tasks->stopTask($this->request->get['task_id']);
		  	
			$url = '';
			if (isset($this->session->data['ka_tasks_url'])) {
				$url = $this->session->data['ka_tasks_url'];
			}
			
   	  		$this->redirect($this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
    	$this->getForm();
  	}
  	
  	public function stat() {
  	
    	$this->getTaskStat();
  	}

  	  	  	  	
  	public function delete() {

		$url = '';
		if (isset($this->session->data['ka_tasks_url'])) {
			$url = $this->session->data['ka_tasks_url'];
		}
  			
    	if (isset($this->request->post['selected']) && $this->validateDelete()) {
			foreach ($this->request->post['selected'] as $task_id) {
				$this->model_tool_ka_tasks->deleteTask($task_id);
			}
			
			$this->session->data['success'] = $this->language->get('text_success');
		}
		
		$this->redirect($this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'));
  	}

  	
  	public function updateList() {

		$url = '';
		if (isset($this->session->data['ka_tasks_url'])) {
			$url = $this->session->data['ka_tasks_url'];
		}
  			
    	if (isset($this->request->post['tasks']) && $this->validateUpdateList()) {
    	
			foreach ($this->request->post['tasks'] as $task_id => $task) {
				
				$rec = array(
					'task_id'  => $task_id,
					'active'   => (isset($task['active']) ? 'Y':'N'),
					'priority' => $task['priority'],
				);
				$this->model_tool_ka_tasks->saveTask($rec);
			}
			
			$this->session->data['success'] = $this->language->get('text_success');
		}
		
		$this->redirect($this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'));
  	}
  	    
  	
  	private function getList() {

  		$params = array(
  			'sort'  => 'priority', 
  			'order' => 'ASC', 
  			'page'  => '1'
  		);
  		
  		$url_array = array();
  		foreach ($params as $k => $v) {
			if (isset($this->request->get[$k])) {
				$params[$k] = $this->request->get[$k];				
	  		}
	  		$url_array[$k] = $k . '=' . $params[$k];
	  	}
		$url = '&' . implode('&', $url_array);
		$this->session->data['ka_tasks_url'] = $url;
		
	  	if ($params['order'] == 'ASC') {
	  		$url_array['order'] = 'order=DESC';
	  	} else {
	  		$url_array['order'] = 'order=ASC';
	  	}
	  	$url_array['sort'] = 'sort=kt.name';
		$this->data['sort_name'] = $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
		
		$url_array['sort'] = 'sort=kt.priority';
		$this->data['sort_priority'] = $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
			  				
  		$this->data['breadcrumbs'] = array();
   		$this->data['breadcrumbs'][] = array(
       			'text'      => $this->language->get('text_home'),
				'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      			'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       			'text'      => $this->language->get('Tasks'),
				'href'      => $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      			'separator' => ' :: '
   		);

   		$is_lite = $this->data['is_lite'] = $this->model_tool_ka_tasks->isLite();
		$this->data['insert']        = $this->url->link('tool/ka_tasks/save', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['update_list']   = $this->url->link('tool/ka_tasks/updateList', 'token=' . $this->session->data['token'] . $url, 'SSL');	
		$this->data['delete']        = $this->url->link('tool/ka_tasks/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');	
		$this->data['run_scheduler'] = $this->url->link('catalog/ka_run_scheduler', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		$this->data['tasks'] = array();

		$last_scheduler_run = $this->config->get('ka_ts_last_scheduler_run');
		if (!empty($last_scheduler_run)) {
			$this->data['last_scheduler_run'] = date($this->language->get('date_format_short'), strtotime($last_scheduler_run)) 
				. ' ' . date($this->language->get('time_format'), strtotime($last_scheduler_run));
		} else {
			$this->data['last_scheduler_run'] = $this->language->get('Never');
		}
		
		$params['start'] = ($params['page'] - 1) * $this->config->get('config_admin_limit');
		$params['limit'] = $this->config->get('config_admin_limit');
		
		$tasks_total = $this->model_tool_ka_tasks->getTasksTotal($params);
		
		$results = $this->model_tool_ka_tasks->getTasks($params);
 
		foreach ($results as $result) {
			$action = array();
			
			if (!$is_lite) {
				$action[] = array(
					'text' => $this->language->get('text_edit'),
					'href' => $this->url->link('tool/ka_tasks/save', 'token=' . $this->session->data['token'] . '&task_id=' . $result['task_id'] . $url, 'SSL')
				);
			}
			
			if (in_array($result['run_status'], array('working', 'not_finished'))) {
				$action[] = array(
					'text' => $this->language->get('Stop'),
					'href' => $this->url->link('tool/ka_tasks/stop', 'token=' . $this->session->data['token'] . '&task_id=' . $result['task_id'] . $url, 'SSL')
				);
			} else {
				$action[] = array(
					'text' => $this->language->get('Run Manually'),
					'href' => $this->url->link('catalog/ka_run_scheduler', 'token=' . $this->session->data['token'] . '&task_id=' . $result['task_id'], 'SSL'),
				);
			}

			$last_start = strtotime($result['last_run']);
			if ($result['last_run'] != '0000-00-00 00:00:00') {
				$last_start = date($this->language->get('date_format_short'), $last_start) 
					. ' ' . date($this->language->get('time_format'), $last_start);
			} else {
				$last_start = $this->language->get('Never');
			}
									
			$this->data['tasks'][] = array(
				'task_id'   => $result['task_id'],
				'name'           => $result['name'],
				'last_start'     => $last_start,
				'status'         => $result['run_status'],
				'complete_count' => $result['complete_count'],
				'active'         => $result['active'],
				'priority'       => $result['priority'],
				'stat_link'      => $this->url->link('tool/ka_tasks/stat', 'token=' . $this->session->data['token'] . '&task_id=' . $result['task_id'] . $url, 'SSL'),
				'selected'       => isset($this->request->post['selected']) && in_array($result['task_id'], $this->request->post['selected']),
				'action'         => $action
			);
		}	

		$statuses = array(
			'not_started'  => 'Idle',
			'working'      => 'Working',
			'not_finished' => 'In Progress',
		);
		$this->data['statuses'] = $statuses;
		
		$this->data['text_no_results'] = $this->language->get('No Results');
		
		$pagination = new Pagination();
		$pagination->total = $tasks_total;
		$pagination->page  = $params['page'];
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text  = $this->language->get('text_pagination');
		$pagination->url   = $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();
		$this->data['params'] = $params;
		
		$this->template = 'tool/ka_tasks_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}
  	
  	
  	private function getForm() {

		$step = 1;
  	    
		$url = '';
		if (isset($this->session->data['ka_tasks_url'])) {
			$url = $this->session->data['ka_tasks_url'];
		}

	
		if (isset($this->request->get['task_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$task = $this->model_tool_ka_tasks->getTask($this->request->get['task_id']);
			
		} elseif ($this->request->server['REQUEST_METHOD'] == 'POST') {
		
			$task = $this->request->post;
			
		} else {
			$task = array(
				'name'       => '',
				'module'     => '',
				'operation'  => '',
				'priority' => '',
				'period_type' => 'day',
				'period_at_min' => 0,
				'period_at_hour' => 0,
				'period_at_day' => 0,
				'period_at_dow' => 0,
				'period_at_month' => 0,
				'active' => 'Y',
				
				'start_at' => date("Y-m-d 00:00"),
				'end_at' => '',
			);
		}
		
		$this->data['task'] = $task;
		
		$this->data['modules'] = $this->model_tool_ka_tasks->getSchedulerModules();
		
		$this->data['operations'] = array();
		if (!empty($task['module'])) {
			$this->data['operations'] = $this->model_tool_ka_tasks->getSchedulerOperations($task['module']);
			$step = 2;
		}
		
		$this->data['op_params'] = array();
		if (!empty($task['operation']) || ($step == 2 && empty($this->data['operations']))) {
			$this->data['op_params'] = $this->model_tool_ka_tasks->getOperationParams($task['module'], $task['operation']);
			$step = 3;
		}
		
		$this->data['period_types'] = $this->model_tool_ka_tasks->getPeriodTypes();
		
		$this->data['minutes'] = $this->model_tool_ka_tasks->getPeriodMinutes();
		$this->data['hours']   = $this->model_tool_ka_tasks->getPeriodHours();
		$this->data['days']    = $this->model_tool_ka_tasks->getPeriodDays();
		$this->data['dows']    = $this->model_tool_ka_tasks->getPeriodDows();
		$this->data['months']  = $this->model_tool_ka_tasks->getPeriodMonths();

		$this->data['is_end_at'] = (strtotime($task['end_at']) > 0);
		
		$this->data['step'] = $step;
		
  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),    		
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Tasks'),
			'href'      => $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);
   		
   		$this->data['breadcrumbs'][] = array(
       		'text'      => $task['name'],
   		);
   				
		$this->data['action'] = $this->url->link('tool/ka_tasks/save', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['cancel'] = $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['languages'] = $this->model_localisation_language->getLanguages();

		$this->template = 'tool/ka_task_form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());	
  	}


	private function validateForm() {
	
    	if (!$this->user->hasPermission('modify', 'tool/ka_tasks')) {
      		$this->addTopMessage('Permission error');
      		return false;
    	}
	
   		if (empty($this->request->post['name'])) {
       		$this->addTopMessage('Name is empty', 'E');
       		return false;
    	}
    	
    	if (utf8_strlen($this->request->post['name']) < 3) {    		
    		$this->addTopMessage('Name should be not less than 3 characters', 'E');
    		return false;
    	}

    	if (empty($this->request->post['module'])) {
    		$this->addTopMessage('Module is not selected', 'E');
    		return false;
    	}
    	
    	$operations = $this->model_tool_ka_tasks->getSchedulerOperations($this->request->post['module']);
    	
    	if (empty($this->request->post['operation'])) {
	    	$operation = '';
	    } else {
    		$operation = $this->request->post['operation'];
    	}
    	
    	if (!empty($operations) && empty($operation)) {
    		if ($this->request->post['step'] > 1) {
	    		$this->addTopMessage('Operation is not selected', 'E');
	    	}
    		return false;
    	}
    	
    	$params = $this->model_tool_ka_tasks->getOperationParams($this->request->post['module'], $operation);
    	
    	if (!empty($params)) {
    		foreach ($params as $k => $param) {
    			if (!empty($param['required']) && empty($this->request->post['params'][$k])) 
    			{
    				if ($this->request->post['step'] > 2) {
	    				$this->addTopMessage('Required operation parameters are empty', 'E');
	    			}
    				return false;
    			}
    		}
    	}

    	return true;
	}
  	  
  	private function validateDelete() {
		if (!$this->user->hasPermission('modify', 'tool/ka_tasks')) {
      		$this->error['warning'] = $this->language->get('error_permission');
    	}
		
		if (!$this->error) { 
	  		return true;
		} else {
	  		return false;
		}
  	}

  	  	
  	private function validateUpdateList() {
		if (!$this->user->hasPermission('modify', 'tool/ka_tasks')) {
      		$this->error['warning'] = $this->language->get('error_permission');
    	}
		
		if (!$this->error) { 
	  		return true;
		} else {
	  		return false;
		}
  	}
  	
  	
  	private function getTaskStat() {

		$url = '';
		if (isset($this->session->data['ka_tasks_url'])) {
			$url = $this->session->data['ka_tasks_url'];
		}
	
		if (isset($this->request->get['task_id'])) {
			$task = $this->model_tool_ka_tasks->getTask($this->request->get['task_id']);
			
		} else {
			$this->redirect($this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'));		
		}
		
		$this->data['task'] = $task;
		
  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),    		
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Tasks'),
			'href'      => $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['cancel'] = $this->url->link('tool/ka_tasks', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['languages'] = $this->model_localisation_language->getLanguages();

		$this->template = 'tool/ka_task_stat.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());	
  	}
  	
}
?>
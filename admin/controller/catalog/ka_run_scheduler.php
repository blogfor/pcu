<?php
/*
	Project: Task Scheduler
	Author : karapuz <support@ka-station.com>

	Version: 1 ($Revision: 53 $)

*/

require_once(DIR_SYSTEM . 'library/ka_mail.php');


class ControllerCatalogKaRunScheduler extends Controller {

	protected $last_scheduler_run;
	protected $current_task;
	
	protected $last_error;
	
	protected function redirect_page($location) {
		if (!headers_sent() && !$this->user->isLogged()) {
			$this->redirect($location);
		} else {
			echo "<html";
		    echo "<head><meta http-equiv=\"Refresh\" content=\"0;URL=" . $location ."\" /></head>";
			echo "<body>";		    
			$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: task (id: " . $this->current_task['task_id'] 
				. ") is not finished.  Redirect count: " . $this->current_task['run_count'] . "..."
			);
			echo $msg;
			echo "</body></html";
						
		    flush();
		}
		exit;
	}


	protected function stopTask($task_id) {
		$this->model_tool_ka_tasks->stopTask($task_id);
	}
	
	/*
		PARAMS:
			$task_id   - execute this task forcedly (if no other tasks run)
	
		Returns:
			task array - on success
			false      - on error. Additional information can be found in the $this->last_error;
	
	*/		
	protected function fetchTask($task_id = 0) {
		
		$task_id = intval($task_id);
		$this->last_error = '';
		
		// time in 'working' or 'not_finished' states.
		//
		$max_alive_time = (int) $this->config->get('ka_ts_stop_task_after_n_minutes');
		
		$max_fails      = (int) $this->config->get('ka_ts_stop_task_after_n_failures');
		
		// time in 'working' state without updating the session variable
		//
		$max_working_time  = (int) $this->config->get('ka_ts_task_is_dead_after_n_minutes');
		$now               = strtotime($this->model_tool_ka_tasks->getSqlNow());

		if ($max_alive_time <= 0 || $max_alive_time > 360) {
			$max_alive_time = 40;
		}
		
		if ($max_working_time <= 0 || $max_working_time > 60) {
			$max_working_time = 10;
		}
		
		if ($max_fails <= 0 || $max_fails > 10) {
			$max_fails = 3;
		}
		
		// convert parameters to seconds
		//
		$max_working_time *= 60;
		$max_alive_time   *= 60;
	
		// check the last executed task
		//
		$current_task = false;

		$last_task_id = $this->model_tool_ka_tasks->getConfigHidden('ka_ts_last_task_id');
		$last_task    = $this->model_tool_ka_tasks->getTask($last_task_id, true);

		if (!empty($last_task)) {

			$last_task_run  = strtotime($last_task['last_run']);
			$first_task_run = strtotime($last_task['first_run']);

			if (in_array($last_task['run_status'], array('not_started'))) {
				// nothing to do, find the next task
				
			} elseif (in_array($last_task['run_status'], array('not_finished', 'working'))) {

				// prevent overloading the server if some script starts redirection too often
				//
				if ($last_task['run_count'] >= 10 && 
					($now - $first_task_run < 60))
				{
					// completely stop the task
					$this->stopTask($last_task_id);
					$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: stopping the '$last_task[name]' ($last_task[task_id]) task (too many redirections for a short period of time)");
					$this->log->write($msg);
					return false;
				}
			
				if ($now - $first_task_run > $max_alive_time) {
					// completely stop the task
					$this->stopTask($last_task_id);
					$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: stopping the '$last_task[name]' ($last_task[task_id]) task. It exceeded 'max_alive_time'.");
					$this->log->write($msg);
					return false;
				}

				
				if (in_array($last_task['run_status'], array('working'))) {
			
					if ($now - $last_task_run > $max_working_time) {
					
						if ($last_task['fail_count'] > $max_fails) {

							$this->model_tool_ka_tasks->stopTask($last_task_id);
							$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: The '$last_task[name]' ($last_task[task_id]) task had too many fails. Stopped.");
							return false;
							
						} else {
							
							$this->model_tool_ka_tasks->changeTaskStatus($last_task_id, 'not_finished');
							$this->db->query("UPDATE " . DB_PREFIX . "ka_tasks 
								SET fail_count = fail_count + 1
								WHERE task_id = '$last_task_id'"
							);
							$current_task = $this->model_tool_ka_tasks->getTask($last_task_id, true);
							$this->model_tool_ka_tasks->logMessage("Task (" . $current_task['task_id'] . ") is dead. Resurrection.");
						}
												
					} else {
						// evertyhing is ok, waiting for completion
						$this->model_tool_ka_tasks->logMessage("Task Scheduler: the last task ($last_task[task_id]:$last_task[name]) working");
						$this->last_error = "the task ($last_task[task_id]:$last_task[name]) is running";
						return false;
					}
				} else {
					// task is waiting for its next start
					//
					$current_task = $last_task;
				}
				
			} else {
				$this->model_tool_ka_tasks->logMessage($e = "ERROR: the Last task has an unknown run_status ($last_task[run_status]). Stopped.");
				trigger_error($e, E_USER_ERROR);
			}
		}

		if ($task_id && !empty($current_task)) {
			if ($current_task['task_id'] != $task_id) {
				$this->last_error = "the last task is not completed yet";
				return false;
			}
		}
				
		// if the current_task is not found yet, then pick up a task from the list
		//
		if (empty($current_task)) {

			if ($task_id) {
				$task_condition = " AND task_id = '" . intval($task_id) . "'";
			} else {
				$task_condition = "
						AND active = 'Y'
						AND start_at <= NOW()
						AND IF(end_at > 0, end_at > NOW(), TRUE)
				";
			}			
				
			$qry = $this->db->query("SELECT task_id, period_type, period_at_min, 
				period_at_hour, period_at_day, period_at_dow, period_at_month,
				last_run
				FROM " . DB_PREFIX . "ka_tasks
				WHERE
					run_status NOT IN ('working')
					$task_condition
				ORDER BY
					last_run ASC, priority DESC
				"
			);
			
			if (!empty($qry->row)) {
				
				foreach ($qry->rows as $t) {
					$last_run = strtotime($t['last_run']);
					
					$next_run = $this->model_tool_ka_tasks->calcNextRun($last_run, $t);
					
					if (empty($next_run)) {
						$this->model_tool_ka_tasks->logMessage("Wrong next run parameter for task $t[task_id]");
						continue;
					}
					
					if ($now >= $next_run || $task_id) {
						$current_task = $this->model_tool_ka_tasks->getTask($t['task_id'], true);
						if (!empty($current_task)) {
							break;
						}
					}
				}
			}
			
			if (empty($current_task)) {
				$this->last_error = "no task to run";
			}
		}
		
		return $current_task;
	}
		
	/* possible task statuses
			not_started -
			not_finished -
	*/
	public function index() {

		$this->load->model('tool/ka_tasks');
		$this->model_tool_ka_tasks->logMessage("Task Scheduler: started");

		if (!$this->user->isLogged() && (empty($this->request->get['key']) || 
			$this->request->get['key'] != $this->config->get('ka_ts_run_scheduler_key'))
		) {
			echo "Task Scheduler: wrong key.";
			$this->model_tool_ka_tasks->logMessage("WARNING: key is not valid or not found");
			return;
		}

		$sql_now = $this->model_tool_ka_tasks->getSqlNow();
		
		$this->last_scheduler_run = strtotime($this->model_tool_ka_tasks->getConfigHidden('ka_ts_last_scheduler_run'));
		$this->model_tool_ka_tasks->setConfigHidden('ka_ts_last_scheduler_run', $sql_now);

		//
		// STAGE 1: find a task to run
		//

		$task_id = (isset($this->request->get['task_id'])) ? $this->request->get['task_id']:0;
		$this->current_task = $current_task = $this->fetchTask($task_id);
		
		// scheduler does not have any active tasks or they do not require start now
		//
		if (empty($current_task)) {
			$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: " . $this->last_error);
			echo $msg;
		 	return false;
		}
		
		$this->model_tool_ka_tasks->logMessage("Task Scheduler: fetched task: taskid = $current_task[task_id], task module $current_task[module]");

		//
		// STAGE 2: run the found task
		//
		
		// mark the task as started
		//
		if ($current_task['run_status'] == 'not_started') {
			$this->db->query("UPDATE " . DB_PREFIX . "ka_tasks SET 
				first_run = NOW(), run_count = 0 
				WHERE task_id = '$current_task[task_id]'"
			);
			$this->model_tool_ka_tasks->setConfigHidden('ka_ts_last_task_id', $current_task['task_id']);
		}
		
		// check if the task can realy start
		//
		if (!$this->model_tool_ka_tasks->isSchedulerModel($current_task['module'])) {
			$this->model_tool_ka_tasks->changeTaskStatus($current_task['task_id'], 'not_started');			
		
			$this->model_tool_ka_tasks->logMessage($msg = "WARNING: module $current_task[module] cannot be uploaded, it is not compatible with Task Scheduler API");
			$this->log->write($msg);
			
			return false;
		}

		$this->old_session_data = $this->session->data;
		
		$session = new Session();
		$this->registry->set('session', $session);
		
		if (empty($current_task['run_status']) || $current_task['run_status'] == 'not_started') {
			$stat = array();
			$session->data['token'] = md5(mt_rand());
			
		} elseif ($current_task['run_status'] == 'not_finished') {
			$stat = $current_task['stat'];
			$this->session->data = unserialize($current_task['session_data']);
			
		} else {
			$this->model_tool_ka_tasks->changeTaskStatus($current_task['task_id'], 'not_started');
			$this->model_tool_ka_tasks->logMessage($e = "ERROR: Unknown run_status ($current_task[run_status]). Reset to not_started.");
			trigger_error($e);
			return false;
		}
		
		$this->load->model($current_task['module']);	
		$name = 'model_' . str_replace('/', '_', $current_task['module']);

		if (!is_object($this->$name)) {
			$this->model_tool_ka_tasks->logMessage($msg = "WARNING: model $name cannot be uploaded for unkown reason. Model object does not exist.");
			$this->log->write($msg);
			
			$this->model_tool_ka_tasks->changeTaskStatus($current_task['task_id'], 'not_started');
			
			return false;
		}
		
		// switch the task to 'working' status
		//
		$this->model_tool_ka_tasks->changeTaskStatus($current_task['task_id'], 'working');

		/*
			supported results:
				array(
					'result'       - not_finished/finished;
					'next_task_id' - optional
				)
				
				string             - not_finished/finished
				
			$stat - should be received by reference and statistics results will be returned
					as a hash array.
		*/
		$next_task_id = 0;		
		$res = '';
		
		$run_result = $this->$name->runSchedulerOperation($current_task['operation'], $current_task['params'], $stat);
		if (is_array($run_result)) {
			$res = $run_result['result'];
			if (isset($run_result['next_task_id'])) { 
				$next_task_id = $run_result['next_task_id'];
			}
		} else {
			$res = $run_result;
		}

		//
		// STAGE 3: save results
		//
		                                  	
		$stat = serialize($stat);
			
		$complete_count_sql = '';
		if ($res == 'finished') {
			$session_data = '';
			$run_status = 'not_started';
			$complete_count_sql = "complete_count = complete_count + 1,";
			
		} elseif ($res == 'not_finished') {
			$session_data = serialize($this->session->data);
			$run_status = 'not_finished';
			
		} else {
			$this->model_tool_ka_tasks->logMessage($e = "ERROR: Unknown function result ($res). Stopped.");
			trigger_error($e, E_USER_ERROR);
		}
		
		$this->session->data = $this->old_session_data;
		
		$this->db->query("UPDATE " . DB_PREFIX . "ka_tasks
			SET
				stat = '" . $this->db->escape($stat) . "',
				session_data = '" . $this->db->escape($session_data) . "',
				run_status = '$run_status',
				run_count = run_count + 1,
				$complete_count_sql
				last_run = now()
			WHERE
				task_id = '$current_task[task_id]'
		");

		//
		// STAGE 4: redict the page to the next run if required
		//		
		$url = "key=" . $this->config->get('ka_ts_run_scheduler_key');
		if (!empty($this->session->data['token'])) {
			$url = $url . '&token=' . $this->session->data['token'];
		}
		
		if ($res == 'not_finished') {
			
			$location = $this->url->link('catalog/ka_run_scheduler', $url, 'SSL');
			$run_count = $this->current_task['run_count'] + 1;
			$this->model_tool_ka_tasks->logMessage("Task Scheduler: task is not finished, (run_count: $run_count) redirecting...");
			$this->redirect_page($location);

		} elseif ($res == 'finished') {
			
			$task = $this->model_tool_ka_tasks->getTask($current_task['task_id'], true);

			if ($this->config->get('ka_ts_send_email_on_completion') == 'Y') {
				$ka_mail = new KaMail($this->registry);
				$ka_mail->data['task'] = $task;
			
				$ka_mail->send($this->config->get('config_email'), $this->config->get('config_email'),
					$this->language->get('Task is complete'), 'ka_task_complete.tpl'
				);
			}
			
			$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: task (id: $current_task[task_id]) is finished.");
			echo $msg . "<br />";
			
			if (!empty($next_task_id)) {
				$location = $this->url->link('catalog/ka_run_scheduler', $url . '&task_id=' . $next_task_id, 'SSL');
				$this->model_tool_ka_tasks->logMessage("Task Scheduler: Next task called (next_task_id: $next_task_id) redirecting...");
				$this->redirect_page($location);
			}
		}

		$this->model_tool_ka_tasks->logMessage($msg = "Task Scheduler: script ends.");
		echo $msg;
  	}
}
?>
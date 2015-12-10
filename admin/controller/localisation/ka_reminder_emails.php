<?php 
/*
	Project: Abandoned Cart Recovery
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 77 $)

*/

require_once(DIR_SYSTEM . 'engine/ka_controller.php');

class ControllerLocalisationKaReminderEmails extends KaController { 

	function onLoad() {
	
		if (!$this->db->isKaInstalled('ka_acr')) {
			$this->redirect($this->url->link('account/login', '', 'SSL'));
		}
		
		$this->loadLanguage('ka_extensions/ka_acr');
		$this->load->model('localisation/language');
		$this->load->model('localisation/ka_reminder_emails');
	}

	
  	public function index() {
  		$this->document->setTitle($this->language->get('Cart Reminder Email Templates'));
    	$this->getList();
  	}

  	
  	protected function getList() {
  	
  		// define sort and order parameters
  		//
  		$params = array(
  			'sort'  => 'name', 
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
		$this->session->data['reminder_emails_url'] = $url;

	  	if ($params['order'] == 'ASC') {
	  		$url_array['order'] = 'order=DESC';
	  	} else {
	  		$url_array['order'] = 'order=ASC';
	  	}

	  	$url_array['sort'] = 'sort=name';
		$this->data['sort_name'] = $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
		
		// generate breadcrumbs
		//
  		$this->data['breadcrumbs'] = array();

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Reminder Emails'),
			'href'      => $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);

		// links for actions
		//   									
		$this->data['update'] = $this->url->link('localisation/ka_reminder_emails/update_list', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['insert'] = $this->url->link('localisation/ka_reminder_emails/save', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['delete'] = $this->url->link('localisation/ka_reminder_emails/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');	

		// collect the data to display
		//
		$this->data['reminder_emails'] = array();

		$params['start'] = ($params['page'] - 1) * $this->config->get('config_admin_limit');
		$params['limit'] = $this->config->get('config_admin_limit');
		
		$reminder_email_total = $this->model_localisation_ka_reminder_emails->getTotalReminderEmails();
	
		$results = $this->model_localisation_ka_reminder_emails->getReminderEmails($params);
 
    	foreach ($results as $result) {
			$action = array();
			
			$action[] = array(
				'text' => $this->language->get('text_edit'),
				'href' => $this->url->link('localisation/ka_reminder_emails/save', 'token=' . $this->session->data['token'] . '&reminder_email_id=' . $result['reminder_email_id'] . $url, 'SSL')
			);

			 $rec = array(
				'reminder_email_id' => $result['reminder_email_id'],
				'name'            => $result['name'] . (($result['reminder_email_id'] == $this->config->get('config_ka_reminder_email_id')) ? $this->language->get('text_default') : null),
				'send_in_hours'   => $result['send_in_hours'],
				'enabled'         => $result['enabled'],
				'selected'        => isset($this->request->post['selected']) && in_array($result['reminder_email_id'], $this->request->post['selected']),
				'action'          => $action
			);
			
			if ($result['last_edited'] != '0000-00-00 00:00:00') {
				$rec['last_edited']    = date($this->language->get('date_format_short'), strtotime($result['last_edited']));
			}
			if ($result['last_submitted'] != '0000-00-00 00:00:00') {
				$rec['last_submitted'] = date($this->language->get('date_format_short'), strtotime($result['last_submitted']));
			}
			
			$this->data['reminder_emails'][] = $rec;
		}
 
		$pagination = new Pagination();
		$pagination->total = $reminder_email_total;
		$pagination->page  = $params['page'];
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text  = $this->language->get('text_pagination');
		$pagination->url   = $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');
			
		$this->data['pagination'] = $pagination->render();
		$this->data['params']     = $params;

		$this->template = 'localisation/ka_reminder_email_list.tpl';		
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());
  	}


  	public function save() {
  	
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateForm()) {
		
			$email = $this->request->post;
			if (!isset($email['enabled'])) {
				$email['enabled'] = 0;
			}
		
      		$this->model_localisation_ka_reminder_emails->saveReminderEmail($email);
		  	
			$url = '';
			if (isset($this->session->data['reminder_emails_url'])) {
				$url = $this->session->data['reminder_emails_url'];
			}
			
      		$this->redirect($this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
    	$this->getForm();
  	}
  		

  	public function update_list() {

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validateList()) {
		
			// update enabled flag and send_in_hours
			//
			
			if (!empty($this->request->post['emails'])) {
				foreach ($this->request->post['emails'] as $k => $email) {
				
					if (!isset($email['enabled'])) {
						$email['enabled'] = 0;
					}				
					$email['reminder_email_id'] = $k;
					
					$this->model_localisation_ka_reminder_emails->saveReminderEmail($email);
				}
			}
		
			$url = '';
			if (isset($this->session->data['reminder_emails_url'])) {
				$url = $this->session->data['reminder_emails_url'];
			}
			$this->addTopMessage("Operation has been completed successfully");
			
      		$this->redirect($this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
	
    	$this->getList();
  	}
  		
  	
  	protected function getForm() {
    
		$url = '';
		if (isset($this->session->data['reminder_emails_url'])) {
			$url = $this->session->data['reminder_emails_url'];
		}

		if (isset($this->request->get['reminder_email_id']) && ($this->request->server['REQUEST_METHOD'] != 'POST')) {
			$reminder_email = $this->model_localisation_ka_reminder_emails->getReminderEmail($this->request->get['reminder_email_id']);
		} else {
			$reminder_email = array(
				'name'          => 'unknown',
				'subject'       => '',
				'description'   => '',
				'send_in_hours' => 24,
				'enabled'       => 0,				
			);
		}

		if (isset($this->request->post['reminder_email_description'])) {
			$reminder_email['descriptions'] = $this->request->post['reminder_email_description'];
		} elseif (isset($this->request->get['reminder_email_id'])) {
			$reminder_email['descriptions'] = $this->model_localisation_ka_reminder_emails->getReminderEmailDescriptions($this->request->get['reminder_email_id']);
		} else {
			$reminder_email['descriptions'][$this->config->get('config_language_id')] = array(
				'name' => '',
				'subject' => '',
				'description' => ''
			);
		}
		if (isset($this->request->post['update_last_edited'])) {
			$reminder_email['update_last_edited'] = true;
		}
		if (isset($this->request->post['send_in_hours'])) {
			$reminder_email['send_in_hours'] = $this->request->post['send_in_hours'];
		}
		if (isset($this->request->post['enabled'])) {
			$reminder_email['enabled'] = true;
		}
		
		//it is used for breadcrumb (not in the form fields)
		//
		if (!empty($reminder_email['descriptions'][$this->config->get('config_language_id')]['name'])) {
			$reminder_email['name'] = $reminder_email['descriptions'][$this->config->get('config_language_id')]['name'];
		} else {
			$reminder_email['name'] = '';
		}
		
		$this->data['reminder_email'] = $reminder_email;
		
  		$this->data['breadcrumbs'] = array();
   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Reminder Emails'),
			'href'      => $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL'),
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $reminder_email['name'],
   		);

		$this->data['token']  = $this->session->data['token'];
		$this->data['action'] = $this->url->link('localisation/ka_reminder_emails/save', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['cancel'] = $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['languages'] = $this->model_localisation_language->getLanguages();

		$this->template = 'localisation/ka_reminder_email_form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());	
  	}


  	protected function validateForm() {
  	
    	if (!$this->user->hasPermission('modify', 'localisation/ka_reminder_emails')) {
      		$this->addTopMessage('Permission error');
      		return false;
    	}
	
    	foreach ($this->request->post['reminder_email_description'] as $language_id => $value) {
      		if ((strlen(trim($value['name'])) < 1) || (strlen(trim($value['description'])) < 1)
      			|| (strlen(trim($value['subject'])) < 1)
      		) {
        		$this->addTopMessage('Name, subject and description fields should not be empty', 'E');
        		return false;
      		}
    	}
    	
    	return true;		
	}
	
	
  	protected function validateList() {
  	
    	if (!$this->user->hasPermission('modify', 'localisation/ka_reminder_emails')) {
      		$this->addTopMessage('Permission error');
      		return false;
    	}
	
    	return true;		
	}
	
	
  	public function delete() {

		$url = '';
		if (isset($this->session->data['reminder_emails_url'])) {
			$url = $this->session->data['reminder_emails_url'];
		}
  			
    	if (isset($this->request->post['selected']) && $this->validateDelete()) {
			foreach ($this->request->post['selected'] as $reminder_email_id) {
				$this->model_localisation_ka_reminder_emails->deleteReminderEmail($reminder_email_id);
			}
			
			$this->addTopMessage('Records were deleted successfully');
		} else {
			$this->addTopMessage('Operation failed', 'E');
		}
			
		$this->redirect($this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL'));
  	}

  		
  	private function validateDelete() {
		if (!$this->user->hasPermission('modify', 'localisation/ka_reminder_emails')) {
      		return false;
    	}
		
    	return true;
  	}
}
?>
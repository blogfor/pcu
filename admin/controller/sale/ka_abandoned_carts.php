<?php
/*
	Project: Abandoned Cart Recovery
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 79 $)

*/

require_once(DIR_SYSTEM . 'engine/ka_controller.php');

class ControllerSaleKaAbandonedCarts extends KaController {

	protected $errors = array();
   
	function onLoad() {
		$this->loadLanguage('ka_extensions/ka_acr');
		$this->load->model('localisation/language');
		$this->load->model('sale/ka_abandoned_carts');
		
		$this->registry->set('encryption', new Encryption($this->config->get('config_encryption')));
	}
	
	
  	public function index() {
  	
		$url = '';
		if (isset($this->session->data['abandoned_carts_url'])) {
			$url = $this->session->data['abandoned_carts_url'];
		}
  	
    	$this->document->setTitle($this->language->get('Abandoned Carts'));
    	$this->getList();

    	$this->model_sale_ka_abandoned_carts->getTaskInstallStatus($task);
    	
		if (!empty($task)) {
			if ($task['last_run'] != '0000-00-00 00:00:00') {
				$last_start = date($this->language->get('date_format_short'), strtotime($task['last_run'])) 
					. ' ' . date($this->language->get('time_format'), strtotime($task['last_run']));
			} else {
				$last_start = $this->language->get('Never');
			}
			
			$task['last_run'] = $last_start;
		}	

    	$this->data['task'] = $task;
    	
		$this->template = 'sale/ka_abandoned_carts_list.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
		
		$this->response->setOutput($this->render());
  	}

  	
  	public function view() {
  	
	   	$this->getForm();
	   	
  	}

  	
  	public function send() {

		$url = '';
		if (isset($this->session->data['abandoned_carts_url'])) {
			$url = $this->session->data['abandoned_carts_url'];
		}
  	
  		if ($this->request->server['REQUEST_METHOD'] == 'POST') {
				
			if (isset($this->request->post['selected']) && $this->validateModify()) {
				foreach ($this->request->post['selected'] as $pos => $abandoned_cart_id) {
					$this->model_sale_ka_abandoned_carts->sendReminder($abandoned_cart_id, $this->request->post['reminder_email_id']);
				}
			}

			$this->session->data['reminder_email_id'] = $this->request->post['reminder_email_id'];
			
			$this->addTopMessage("Operation has been completed successfully");
		}
		
		$this->redirect($this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL'));
  	}


  	public function delete() {

		$url = '';
		if (isset($this->session->data['abandoned_carts_url'])) {
			$url = $this->session->data['abandoned_carts_url'];
		}
  	
  		if ($this->request->server['REQUEST_METHOD'] == 'POST') {				
			if (isset($this->request->post['selected']) && $this->validateModify()) {
				foreach ($this->request->post['selected'] as $pos => $abandoned_cart_id) {
					$this->model_sale_ka_abandoned_carts->deleteReminder($abandoned_cart_id);
				}
			}

			$this->addTopMessage("Operation has been completed successfully");					
		}
		
		$this->redirect($this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL'));
  	}
  	  	
 	
  	protected function getList() {

  		$params = array(
  			'sort'  => 'last_visited',
  			'order' => 'ASC',
  			'page'  => '1',
  			'filter_customer_name'  => '',
  			'filter_customer_email' => '',
  			'filter_last_visited'   => '',
  		);
  		
  		$url_array = array();
  		foreach ($params as $k => $v) {
			if (isset($this->request->get[$k])) {
				$params[$k]    = $this->request->get[$k];
				$url_array[$k] = $k . '=' . $params[$k];
	  		}
	  	}
		$url = '&' . implode('&', $url_array);
		$this->session->data['abandoned_carts_url'] = $url;
		
	  	if ($params['order'] == 'ASC') {
	  		$url_array['order'] = 'order=DESC';
	  	} else {
	  		$url_array['order'] = 'order=ASC';
	  	}
		$url_array['sort']                = 'sort=customer_name';
		$this->data['sort_name']          = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
		$url_array['sort']                = 'sort=c.email';
		$this->data['sort_email']         = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
	  	$url_array['sort']                = 'sort=last_visited';
		$this->data['sort_last_visited']  = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
		$url_array['sort']                = 'sort=last_reminded';		
		$this->data['sort_last_reminded'] = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
		$url_array['sort']                = 'sort=link_opened';
		$this->data['sort_link_opened']   = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . '&' . implode('&', $url_array), 'SSL');
		
  		$this->data['breadcrumbs'] = array();
   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Abandoned Carts'),
			'href'      => $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);

		$this->data['action_send'] = $this->url->link('sale/ka_abandoned_carts/send', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['action_delete'] = $this->url->link('sale/ka_abandoned_carts/delete', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['reminder_emails_url'] = $this->url->link('localisation/ka_reminder_emails', 'token=' . $this->session->data['token'] . $url, 'SSL');

		$this->data['carts'] = array();
		
		$params['start'] = ($params['page'] - 1) * $this->config->get('config_admin_limit');
		$params['limit'] = $this->config->get('config_admin_limit');
		$params['hide_unsubscribed'] = ($this->config->get('ka_acr_show_unsubscribed') != 'Y');
		$carts_total = $this->model_sale_ka_abandoned_carts->getAbandonedCartsTotal($params);
		$results     = $this->model_sale_ka_abandoned_carts->getAbandonedCarts($params);
 
    	foreach ($results as $result) {
			$action = array();
			
			$action[] = array(
				'text' => $this->language->get('View'),
				'href' => $this->url->link('sale/ka_abandoned_carts/view', 'token=' . $this->session->data['token'] . '&abandoned_cart_id=' . $result['abandoned_cart_id'] . $url, 'SSL')
			);
			$result['action']        = $action;
			if ($result['last_visited'] == '0000-00-00 00:00:00') {
				$result['last_visited'] = 'n/a';
			} else {
				$result['last_visited']  = date($this->language->get('date_format_short'), strtotime($result['last_visited']));
			}
			if ($result['last_reminded'] == '0000-00-00 00:00:00') {
				$result['last_reminded'] = 'n/a';
			} else {
				$result['last_reminded'] = date($this->language->get('date_format_short'), strtotime($result['last_reminded']));
			}

			if (is_numeric($result['next_reminder'])) {
				$result['next_reminder'] = 'in ' . $result['next_reminder'] . ' hours';
			} else {
				$result['next_reminder'] = $this->language->get($result['next_reminder']);
			}		
			
			if ($result['link_opened'] == '0000-00-00 00:00:00') {
				$result['link_opened'] = 'n/a';
			} else {
				$result['link_opened']  = date($this->language->get('date_format_short'), strtotime($result['link_opened']));
			}
			
			if (!empty($result['customer_id'])) {
				$result['customer_link'] = $this->url->link('sale/customer/update', 'token=' . $this->session->data['token'] . '&customer_id=' . $result['customer_id'], 'SSL');
			}
			
			$this->data['carts'][] = $result;
		}
		
		$this->data['text_no_results']  = $this->language->get('No Results');
		
		// load reminder emails
		//
		$this->load->model('localisation/ka_reminder_emails');
		$reminder_emails = $this->model_localisation_ka_reminder_emails->getReminderEmails();
		if (!empty($reminder_emails)) {
			foreach ($reminder_emails as $rek => $rev) {
				$this->data['reminder_emails'][$rev['reminder_email_id']] = $rev['name'];
			}
		}
		if (isset($this->session->data['reminder_email_id'])) {
			$this->data['reminder_email_id'] = $this->session->data['reminder_email_id'];
		} else {
			$this->data['reminder_email_id'] = 0;
		}
		
		$pagination = new Pagination();
		$pagination->total = $carts_total;
		$pagination->page  = $params['page'];
		$pagination->limit = $this->config->get('config_admin_limit');
		$pagination->text  = $this->language->get('text_pagination');
		$pagination->url   = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url . '&page={page}', 'SSL');

		$this->data['pagination'] = $pagination->render();
		$this->data['params'] = $params;
		$this->data['token'] = $this->session->data['token'];
  	}

  	  	
  	protected function getForm() {

		$url = '';
		if (isset($this->session->data['abandoned_carts_url'])) {
			$url = $this->session->data['abandoned_carts_url'];
		}
		
		if (empty($this->request->get['abandoned_cart_id'])) {
			$this->addTopMessage("Cart was not found");
	  		$this->redirect($this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL'));
		}
		
		$cart = $this->model_sale_ka_abandoned_carts->getAbandonedCart($this->request->get['abandoned_cart_id']);

		if (!empty($cart['products'])) {
			foreach ($cart['products'] as $product) {
				$option_data = array();
				
				foreach ($product['option'] as $option) {
					if ($option['type'] != 'file') {
						$value = $option['option_value'];
					} else {
						$filename = $this->encryption->decrypt($option['option_value']);
						
						$value = utf8_substr($filename, 0, utf8_strrpos($filename, '.'));
					}				
					
					$option_data[] = array(								   
						'name'  => $option['name'],
						'value' => (utf8_strlen($value) > 20 ? utf8_substr($value, 0, 20) . '..' : $value),
						'type'  => $option['type']
					);
					
				}
				$this->data['products'][] = array(
					'key'      => $product['key'],
					'name'     => $product['name'],
					'model'    => $product['model'], 
					'option'   => $option_data,
					'quantity' => $product['quantity'],
					'href'     => $this->url->link('product/product', 'product_id=' . $product['product_id'])
				);				
			}
		} else {
			$this->data['products'] = false;
		}
		
		$this->data['cart']  = $cart;
		
  		$this->data['breadcrumbs'] = array();
   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home', 'token=' . $this->session->data['token'], 'SSL'),    		
      		'separator' => false
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Abandoned Carts'),
			'href'      => $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);

   		$this->data['breadcrumbs'][] = array(
       		'text'      => $this->language->get('Cart'),
			'href'      => $this->url->link('sale/ka_abandoned_carts/view', 'token=' . $this->session->data['token'] . $url, 'SSL'),
      		'separator' => ' :: '
   		);
   				
		$this->data['back']        = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL');
		$this->data['action']      = $this->url->link('sale/ka_abandoned_carts', 'token=' . $this->session->data['token'] . $url, 'SSL');
		
		$this->template = 'sale/ka_abandoned_cart_form.tpl';
		$this->children = array(
			'common/header',
			'common/footer'
		);
				
		$this->response->setOutput($this->render());	
  	}

 	
	protected function validateForm() {
    	if (!$this->user->hasPermission('modify', 'sale/ka_abandoned_carts')) {
      		$this->addTopMessage('Permission error');
      		return false;
    	}
    	
    	return true;		
	}


  	protected function validateModify() {
		if (!$this->user->hasPermission('modify', 'sale/ka_abandoned_carts')) {
      		$this->errors['warning'] = $this->language->get('error_permission');
    	}
		
		if (!empty($this->errors)) { 
	  		return false;
	  	}

	  	return true;
  	}
}
?>
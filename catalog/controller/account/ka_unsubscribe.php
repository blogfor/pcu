<?php 
/*
	Project: Abandoned Cart Reminder
	
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 48 $)

*/

require_once(DIR_SYSTEM . 'engine/ka_controller.php');

class ControllerAccountKaUnsubscribe extends KaController { 

	/*
		GET PARAMETERS:
			- acr_token
	*/
	public function index() {

		$this->language->load('account/ka_acr');
		$this->language->load('account/account');
		
		$this->load->model('account/customer');
		
		$this->document->setTitle($this->language->get('Unsubscribe'));

		$customer = false;
		if (!empty($this->request->get['acr_token'])) {
			$customer = $this->model_account_customer->getCustomerByAcrToken($this->request->get['acr_token']);
		}

		if (!empty($customer)) {
			if ($customer['acr_subscribed'] == 1) {
				$this->model_account_customer->unsubscribeFromAcr($customer['customer_id']);
				$this->data['status'] = 'ok';
			} else {
				$this->data['status'] = 'not_subscribed';
			}
		} else {
			$this->data['status'] = 'not_found';
		}
		
      	$this->data['breadcrumbs'] = array();
      	$this->data['breadcrumbs'][] = array(
        	'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home'),
        	'separator' => false
      	); 

      	$this->data['breadcrumbs'][] = array(       	
        	'text'      => $this->language->get('Unsubscribe'),
			'href'      => $this->url->link('account/ka_unsubscribe', ''),
        	'separator' => $this->language->get('text_separator')
      	);
		
		$this->template = $this->findTemplate('/template/account/ka_unsubscribe.tpl');

		$this->children = array(
			'common/column_left',
			'common/column_right',
			'common/content_top',
			'common/content_bottom',
			'common/footer',
			'common/header'		
		);
				
		$this->response->setOutput($this->render());
  	}
}
?>
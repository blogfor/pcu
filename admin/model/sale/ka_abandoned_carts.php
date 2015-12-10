<?php
/*
	Project: Abandoned Cart Recovery
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 89 $)

*/

require_once(KaVQMod::modCheck(DIR_SYSTEM . 'library/ka_db.php'));
require_once(KaVQMod::modCheck(DIR_SYSTEM . 'library/ka_mail.php'));
require_once(KaVQMod::modCheck(DIR_SYSTEM . 'engine/ka_model.php'));
require_once(KaVQMod::modCheck(DIR_SYSTEM . 'library/cart.php'));
require_once(KaVQMod::modCheck(DIR_SYSTEM . 'library/tax.php'));
require_once(KaVQMod::modCheck(DIR_SYSTEM . 'library/customer.php'));

class ModelSaleKaAbandonedCarts extends KaModel {

	public static $max_reminder_delay = 2160; // in hours

	public static $token_prefix = 'ka-';

	protected $kadb = null;

	protected function onLoad() {
		$this->kadb = new KaDb($this->db);
		$this->load->model('sale/customer');
		$this->load->model('localisation/language');
		$this->loadLanguage('ka_extensions/ka_acr');
		
		$this->registry->set('encryption', new Encryption($this->config->get('config_encryption')));
	}


	protected function queryHash($qry_string, $key) {
	
		$qry = $this->db->query($qry_string);
		if (empty($qry->rows)) {
			return false;
		}
		
		$res = array();
		if (!isset($qry->row[$key])) {
			trigger_error("queryWithKey: key not found ($key)");
			return false;
		}
		
		foreach ($qry->rows as $row) {
			if (isset($row[$key])) {
				$res[$row[$key]] = $row;
			}
		}
		
		return $res;
	}

		
	public function deleteReminder($id) {
	
		$id = (int)$id;

		$qry = $this->db->query("SELECT * FROM " . DB_PREFIX . "ka_abandoned_carts WHERE
			abandoned_cart_id = '$id'"
		);
				
		if (empty($qry->row)) {
			return false;
		}
		
		if (intval($qry->row['customer_id']) == 0) {
		
			$this->db->query("DELETE FROM " . DB_PREFIX . "ka_abandoned_carts 
				WHERE abandoned_cart_id = '$id'"
			);
		
		} else {
			$this->db->query("UPDATE " . DB_PREFIX . "ka_abandoned_carts SET cart = '' 
				WHERE abandoned_cart_id = '$id'"
			);
		}

		return true;
	}
	
	public function getStore($store_id) {
	
		$query = $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "store WHERE store_id = '" . (int)$store_id . "'");
		
		$store = array();		
		if (!empty($query->row)) {
			$store['store_name']   = $query->row['name'];
			$store['store_url']    = $query->row['url'] . 'index.php?route=account/login';
			$store['http_catalog'] = $query->row['url'];
			
		} else {
			$store['store_name'] = $this->config->get('config_name');
			$url = (defined('HTTP_CATALOG')) ? HTTP_CATALOG : HTTP_SERVER;
			$store['store_url']  = $url . 'index.php?route=account/login';
			$store['http_catalog']    = $url;
		}
		
		return $store;	
	}
	

	//karapuz: before:function editCustomer($customer_id,
	/*
		PARAMETERS:
			customer - array with customer_id. Customer_id cannot be empty here.
			
		RETURN:
			abandoned_cart_id - on success
			false - on error
	*/
	public function insertAbandonedCart($customer) {

		if (empty($customer['customer_id']) || empty($customer['email'])) {
			return false;
		}
		
		$customer_id = (int)$customer['customer_id'];
		$language_id = (int)(isset($customer['language_id'])) ? $customer['language_id'] : $this->config->get('config_language_id');
		$store_id    = (int)(isset($customer['store_id'])) ? $customer['store_id'] : $this->config->get('config_store_id');
		$salt        = Customer::generateAcrSalt();
		
		$str = '';
		if (!empty($customer['firstname'])) {
			$str .= "firstname = '" . $this->db->escape($customer['firstname']) . "',";
		}
		if (!empty($customer['lastname'])) {
			$str .= "lastname = '" . $this->db->escape($customer['lastname']) . "',";
		}
		if (!empty($customer['cart'])) {
			$str .= "cart = '" . $this->db->escape($customer['cart']) . "',";
		}
		if (!empty($customer['last_visited'])) {
			$str .= "last_visited = '" . $customer['last_visited'] . "',";
		}
		
		$this->db->query("INSERT INTO " . DB_PREFIX . "ka_abandoned_carts SET 
			$str
			customer_id = '" . $customer_id . "',
			language_id = '" . $language_id . "',
			email = '" . $this->db->escape($customer['email']) . "',
			store_id = '$store_id',
			salt = '" . $this->db->escape($salt) . "',
			acr_subscribed = '" . (isset($customer['acr_subscribed']) ? 1 : 0) . "'"
		);

		$abandoned_cart_id = $this->db->getLastId();
		
		return $abandoned_cart_id;
	}

		
	public function updateAbandonedCart($abandoned_cart_id, $customer) {

		$abandoned_cart_id = (int)$abandoned_cart_id;
		
		$qry = $this->db->query("SELECT abandoned_cart_id FROM " . DB_PREFIX . "ka_abandoned_carts 
			WHERE abandoned_cart_id = '$abandoned_cart_id'"
		);
		if (empty($qry->row)) {
			return false;
		}
		
		$this->db->query("UPDATE " . DB_PREFIX . "ka_abandoned_carts SET
			acr_subscribed = '" . (!empty($customer['acr_subscribed']) ? 1 : 0) . "'
			WHERE abandoned_cart_id = '$abandoned_cart_id'"
		);
		
		return true;
	}


	public function getAbandonedCartByCustomer($customer_id, $store_id = null) {

		$customer_id = (int)$customer_id;
		
		if (is_null($store_id)) {
			$store_id    = $this->config->get('config_store_id');
		}

		$qry = $this->db->query("SELECT abandoned_cart_id FROM " . DB_PREFIX . "ka_abandoned_carts 
			WHERE customer_id = '$customer_id' AND store_id = '" . (int)$store_id . "'"
		);
		
		if (empty($qry->row)) {
			return false;
		}
		
		return $qry->row['abandoned_cart_id'];
	}
	
			
	public function getAbandonedCart($abandoned_cart_id) {

		$qry = $this->db->query("SELECT * FROM " . DB_PREFIX . "ka_abandoned_carts WHERE
			abandoned_cart_id = '" . intval($abandoned_cart_id) . "'"
		);
		
		if (empty($qry->row['cart'])) {
			return false;
		}
		$abandoned_cart = $qry->row;
		
		if (!empty($abandoned_cart['cart'])) {
			$abandoned_cart['cart'] = unserialize($abandoned_cart['cart']);
		}

		if (!empty($abandoned_cart['customer_id'])) {
		
			$this->load->model('sale/customer');
			$customer = $this->model_sale_customer->getCustomer($abandoned_cart['customer_id']);
			
		} else {
			$customer = array(
				'firstname' => $abandoned_cart['firstname'],
				'lastname'  => $abandoned_cart['lastname'],
				'email' => $abandoned_cart['email'],
			);
		}
		$abandoned_cart['customer'] = $customer;
		$this->getCartProducts($abandoned_cart);

		return $abandoned_cart;
	}
	
	
	/*
		add information about products to the abandoned_cart array
	*/
	public function getCartProducts(&$abandoned_cart) {

		$result = array();

		if (empty($abandoned_cart)) {
			return false;
		}
		
		if (!empty($abandoned_cart['cart'])) {
		
			$registry = $this->registry;
			$_session_data = $this->session->data;
			
			$session  = $registry->get('session');
			$session->data['cart'] = $abandoned_cart['cart'];
			$registry->set('session', $session);
			$registry->set('customer', new Customer($registry));
			$registry->set('tax', new Tax($registry));
			$cart = new Cart($registry);
			$abandoned_cart['products'] = $cart->getProducts();
			
			if (!empty($abandoned_cart['products'])) {
			
				foreach ($abandoned_cart['products'] as &$product) {
					$price = $this->tax->calculate($product['price'], $product['tax_class_id'], $this->config->get('config_tax'));
					$product['price'] = $price;
					$product['total'] = $price * $product['quantity'];
				}
			}
			
			$this->session->data = $_session_data;
			
		} else {
			$abandoned_cart['products'] = array();
		}

		return $result;
	}
	
	
	protected function getRecords($data) {

		if (empty($data['fields'])) {
			return false;
		}
			
		$sql = "SELECT " . $data['fields'] . " FROM " . DB_PREFIX . "ka_abandoned_carts ac
			LEFT JOIN " . DB_PREFIX . "customer c ON ac.customer_id = c.customer_id
		";
		
		$where = array();
		if (!empty($data['filter_customer_name'])) {
			$where[] = "LCASE(CONCAT(ac.firstname, ' ', ac.lastname)) LIKE '%" . $data['filter_customer_name'] . "%'";
		}
		if (!empty($data['filter_customer_email'])) {
			$where[] = "ac.email LIKE '%" . $data['filter_customer_email'] . "%'";
		}
		if (!empty($data['filter_last_visited'])) {
			$where[] = "TIMESTAMPDIFF(DAY, NOW(), ac.last_visited) <= " . intval($data['filter_last_visited']);
		}
		
		// empty cart is an array like this: 'a:0:{}'
		//
		$where[] = "LENGTH(ac.cart) > 6";
		
		// treat carts as abandoned if customer activity was more than 1 hour ago
		// one hour constant is used for displaying online_customers in the report
		//
		if ($this->config->get('ka_acr_show_carts_wo_delay') != 'Y') {
			$where[] = "TIMESTAMPDIFF(HOUR, ac.last_visited, NOW()) > 0";
		}
		
		if (!empty($data['hide_unsubscribed'])) {
			$where[] = "ac.acr_subscribed = 1";
		}

		if (!empty($data['where'])) {
			$where[] = $data['where'];
		}		
				
		if (!empty($where)) {
			$sql .= " WHERE " . implode(" AND ", $where);
		}
		
		if (!empty($data['sort'])) {
			$sql .= " ORDER BY " . $data['sort'];
			
			if (!empty($data['order'])) {
				$sql .= ' ' . $data['order'];
			}
		}
		
		if (!empty($data['having'])) {
			$sql .= ' HAVING ' . $data['having'];
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

		
	public function getAbandonedCarts($data = array()) {

		$data['fields'] = "ac.*, CONCAT(ac.firstname, ' ', ac.lastname) AS customer_name, 
		TIMESTAMPDIFF(HOUR, ac.last_visited, NOW()) AS hours_since_visit,
		IF(ac.last_reminded <> '0000-00-00 00:00:00', TIMESTAMPDIFF(HOUR, ac.last_visited, ac.last_reminded), 0) AS hours_to_last_reminder,
		ac.email, ac.last_visited, ac.last_reminded, ac.link_opened";

		$qry = $this->getRecords($data);
		if (empty($qry->rows)) {
			return array();
		}
		
		$reminders = $this->getActiveRemindersByHours();
		$hours = array_keys($reminders);
		$first_reminder = reset($hours);
		$final_reminder  = end($hours);

		foreach ($qry->rows as &$row) {
		
			if ($row['hours_to_last_reminder'] < 0) {
				$row['hours_to_last_reminder'] = 0;
			}
		
			if (empty($hours)) {
				$row['next_reminder'] = 'n/a';
				continue;
			}
			
			if (!intval($row['acr_subscribed'])) {
				$row['next_reminder'] = 'not subscribed';
				continue;
			}

			if ($final_reminder <= $row['hours_to_last_reminder']) {
				$row['next_reminder'] = 'all sent';
				continue;
			}

			$row['next_reminder'] = 'all sent';
			
			foreach ($hours as $hour) {
									
				if ($hour <= $row['hours_to_last_reminder']) {
					continue;
				}
			
				$row['reminder']      = $reminders[$hour];				
				$row['next_reminder'] = $hour - $row['hours_since_visit'];
				
				if ($row['next_reminder'] <= 0) {
					if (abs($row['next_reminder']) <= self::$max_reminder_delay) {
						$row['next_reminder'] = 'ready to send';
					} else {
						$row['next_reminder'] = 'all sent';
					}
				}
				break;
			}
		}
		
		return $qry->rows;
	}
	

	public function getAbandonedCartsTotal($data) {
	
		unset($data['sort'], $data['order'], $data['start'], $data['limit']);
		
      	$data['fields'] = 'COUNT(ac.abandoned_cart_id) AS total';
      	      	
		$qry = $this->getRecords($data);
		
		return $qry->row['total'];
	}
	

	public function loadTempLanguage($language_id) {
	
		$qry = $this->db->query("SELECT * FROM `" . DB_PREFIX . "language`
		 	WHERE language_id = '" . intval($language_id) . "'"
		);

		if (empty($qry->row)) {
			return false;
		}
		
		$language_code      = $qry->row['code'];
		$language_filename  = $qry->row['filename'];
		$language_directory = $qry->row['directory'];

		$language = new Language($language_directory);
		$language->load($language_filename);
		
		return $language;
	}

	protected function getImagePath($image) {
	
		$image_url = $this->model_tool_image->resize($image, $this->config->get('config_image_cart_width'), $this->config->get('config_image_cart_height'));
		
		$image_path = preg_replace("/.*\/image\/(.*)$/i", "$1", $image_url);

		return $image_path;	
	}	
	
	public function sendReminder($abandoned_cart_id, $reminder_email_id) {

		$this->lastError = '';
		$this->load->model('tool/image');
		
		$abandoned_cart = $this->getAbandonedCart($abandoned_cart_id);
		
		if (empty($abandoned_cart)) {
			$this->lastError = "sendReminder: Abandoned cart ($abandoned_cart_id) not found";
			return false;
		}
		
		$customer = $abandoned_cart['customer'];
		if (empty($customer)) {
			$this->lastError = "sendReminder: Customer record is empty, abandoned_cart_id ($abandoned_cart_id)";
			return false;
		}
		
		// change language if required
		//
		$old_language    = null;
		$old_language_id = 0;
		$language_id     = $abandoned_cart['language_id'];
		
		if ($language_id && $language_id != $this->config->get('config_language_id')) {
			$language = $this->loadTempLanguage($language_id);
			if (!empty($language)) {
				$old_language    = $this->registry->get('language');
				$old_language_id = $this->config->get('config_language_id');
				$this->registry->set('language', $language);
				$this->config->set('config_language_id', $language_id);
			}
		}
		
		$this->language->load('ka_extensions/ka_acr');
		
		$ka_mail = new KaMail($this->registry, $abandoned_cart['store_id']);

		// do not remind about empty cart
		//
		if (empty($abandoned_cart['products'])) {
			return false;
		}
		

		$subtotal = 0;
	
		foreach ($abandoned_cart['products'] as $product) {
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

			$product['image'] = $this->getImagePath($product['image']);
			$cid = 'product_' . $product['product_id'] . '_image';
			$ka_mail->images[$cid] = $product['image'];

			$ka_mail->data['products'][] = array(
				'key'      => $product['key'],
				'name'     => $product['name'],
				'image_cid' => $cid,
				'model'    => $product['model'], 
				'option'   => $option_data,
				'quantity' => $product['quantity'],
				'price'    => $this->currency->format($product['price']),
				'total'    => $this->currency->format($product['total']),
				'href'     => $this->url->link('product/product', 'product_id=' . $product['product_id'])
			);

			$subtotal += $product['total'];			
		}
		
		$ka_mail->data['subtotal'] = $this->currency->format($subtotal);
		
		$ka_mail->data['customer'] = $customer;
		
		$store = $this->getStore($abandoned_cart['store_id']);
		
		$token = self::$token_prefix . $this->generateKaToken($abandoned_cart['abandoned_cart_id']);
		$ka_mail->data['cart_url'] = $store['http_catalog'] . 'index.php?route=account/login&token=' . $token;

		$token = $this->generateAcrToken($abandoned_cart['abandoned_cart_id']);
		$ka_mail->data['unsubscribe_url'] = $store['http_catalog'] . 'index.php?route=account/ka_unsubscribe&acr_token=' . $token;

		$extra = array();
		$extra['images_in_emails'] = $this->config->get('ka_acr_images_in_emails');
		
		$is_sent = false;
		$this->load->model('localisation/ka_reminder_emails');
		$reminder_email = $this->model_localisation_ka_reminder_emails->getReminderEmail($reminder_email_id);
		if (!empty($reminder_email)) {
			if (empty($reminder_email['subject'])) {
				$reminder_email['subject'] = $this->language->get('You have some items in the cart');
			}
			$ka_mail->data['description'] = $reminder_email['description'];
			$ka_mail->send('', $customer['email'], $reminder_email['subject'], 'ka_cart_reminder.tpl', $extra);
			$this->model_localisation_ka_reminder_emails->updateLastSubmitted($reminder_email['reminder_email_id']);
			$is_sent = true;
		}
		
		//restore language
		//
		if (!empty($old_language)) {
			$this->config->set('config_language_id', $old_language_id);
			$this->registry->set('language', $old_language);
		}
		
		return $is_sent;
	}


	protected function generateKaToken($abandoned_cart_id) {

		$abandoned_cart_id = intval($abandoned_cart_id);
	
		// find the record
		//
		$qry = $this->db->query("SELECT abandoned_cart_id, salt FROM " . DB_PREFIX . "ka_abandoned_carts 
			WHERE abandoned_cart_id = '$abandoned_cart_id'"
		);
		
		if (empty($qry->row)) {
			trigger_error('generateKaToken: data is not found');
			return false;
		}
		
		$salt = (empty($qry->row['salt'])) ? rand() : $qry->row['salt'];
		
		// generate a token
		//
		$token = md5(rand() . $salt);
		
		$link_array = array(
			'user_id'  => $qry->row['abandoned_cart_id'],
			'token'    => $token,
		);
		$res = base64_encode(serialize($link_array));

		$this->db->query("DELETE FROM " . DB_PREFIX . "ka_tokens WHERE
			abandoned_cart_id = '" . intval($qry->row['abandoned_cart_id']) . "'"
		);
		
		$this->db->query("INSERT INTO " . DB_PREFIX . "ka_tokens SET
				abandoned_cart_id = '" . $qry->row['abandoned_cart_id'] . "',
				token = '" . $res . "',
				created_at = NOW()"
		);

		return $res;	

	}

	/*
		It is used for unsubscribe links
		
	*/	
	protected function generateAcrToken($abandoned_cart_id) {

		$abandoned_cart_id = intval($abandoned_cart_id);
	
		// find the record
		//
		$qry = $this->db->query("SELECT abandoned_cart_id, salt FROM " . DB_PREFIX . "ka_abandoned_carts 
			WHERE abandoned_cart_id = '$abandoned_cart_id'"
		);
		
		if (empty($qry->row)) {
			trigger_error('generateAcrToken: data is not found');
			return false;
		}
		
		$salt = (empty($qry->row['salt'])) ? rand() : $qry->row['salt'];
		
		// generate a token
		//
		$token = md5(rand() . $salt);
		
		$link_array = array(
			'user_id'  => $qry->row['abandoned_cart_id'],
			'token'    => $token,
		);
		$res = base64_encode(serialize($link_array));

		$this->db->query("UPDATE " . DB_PREFIX . "ka_abandoned_carts SET
			acr_token = '" . $res . "',
			link_opened = '',
			last_reminded = NOW()
			WHERE
			abandoned_cart_id = '" . $qry->row['abandoned_cart_id'] . "'"
		);

		return $res;
	}


	public function getActiveRemindersByHours() {
	
		$reminders = $this->queryHash("SELECT kre.* FROM " . DB_PREFIX . "ka_reminder_emails kre
			WHERE `enabled` = 1
			GROUP BY send_in_hours
			ORDER BY send_in_hours ASC", "send_in_hours"
		);
		
		if (empty($reminders)) {
			$reminders = array();
		}
		
		return $reminders;
	}
		
				
	public function runSchedulerOperation($operation, $params, &$stat) {
		
		$now = time();

		if (empty($stat)) {
			$stat['Carts Emailed']   = 0;
		}
				
		$reminders = $this->getActiveRemindersByHours();
		if (empty($reminders)) {
			$stat['Message'] = 'No reminder emails available';
			return 'finished';
		}

		$hours = array_keys($reminders);
		$first_reminder = reset($hours);
		$final_reminder = end($hours);
		
		$data = array();

		$data['hide_unsubscribed'] = 1;
		$data['having'] = "
				hours_since_visit >= '$first_reminder'
				AND (hours_to_last_reminder = 0 OR hours_to_last_reminder - hours_since_visit <= '$final_reminder')
		";
		
		$carts = $this->getAbandonedCarts($data);
		
		if (empty($carts)) {
			return 'finished';
		}

		foreach ($carts as $ck => $cv) {

			if ($cv['next_reminder'] != 'ready to send') {
				continue;
			}
		
			if ($this->sendReminder($cv['abandoned_cart_id'], $cv['reminder']['reminder_email_id'])) {
				$stat['Carts Emailed']++;
			}
			
			if (time() - $now > 20) {
				return 'not_finished';
			}
		}
		
		return 'finished';
	}
	
	/*
	RETURNS:
		string - 'task_installed', 'task_not_installed', 'scheduler_not_installed'.	
		
	*/
	public function getTaskInstallStatus(&$task) {
		$task = false;
			
		if (!$this->db->isKaInstalled('ka_scheduler')) {
			return 'scheduler_not_installed';
		}
		
		$this->load->model('tool/ka_tasks');
		
		$tasks = $this->model_tool_ka_tasks->enumTasks('sale/ka_abandoned_carts');
		if (empty($tasks)) {
			return 'task_not_installed';
		}
		
		$task = reset($tasks);
		
		return 'task_installed';
	}

		
	public function importStandardCarts() {

		$added = 0;
			
		$qry = $this->db->query("SELECT * FROM " . DB_PREFIX ."customer WHERE
			LENGTH(cart) > 6 
			AND customer_id NOT IN 
				(SELECT customer_id FROM " . DB_PREFIX . "ka_abandoned_carts)
			"
		);
	
		if (empty($qry->rows)) {
			return $added;
		}

		foreach ($qry->rows as $row) {
			$row['last_visited']   = $row['date_added'];
			$row['acr_subscribed'] = 1;
			if ($this->insertAbandonedCart($row)) {
				$added++;
			}
		}
			
		return $added;
	}
	
}
?>
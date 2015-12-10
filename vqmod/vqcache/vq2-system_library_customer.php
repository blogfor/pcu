<?php
class Customer {
	private $customer_id;
	private $firstname;
	private $lastname;
	private $email;
	private $telephone;
	private $fax;
	private $newsletter;
	private $customer_group_id;
	private $address_id;
	
  	public function __construct($registry) {
		$this->config = $registry->get('config');
		$this->db = $registry->get('db');
		$this->request = $registry->get('request');
		$this->session = $registry->get('session');
				
		if (isset($this->session->data['customer_id'])) { 
			$customer_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "customer WHERE customer_id = '" . (int)$this->session->data['customer_id'] . "' AND status = '1'");
			
			if ($customer_query->num_rows) {
				$this->customer_id = $customer_query->row['customer_id'];
				$this->firstname = $customer_query->row['firstname'];
				$this->lastname = $customer_query->row['lastname'];
				$this->email = $customer_query->row['email'];
				$this->telephone = $customer_query->row['telephone'];
				$this->fax = $customer_query->row['fax'];
				$this->newsletter = $customer_query->row['newsletter'];
				$this->customer_group_id = $customer_query->row['customer_group_id'];
				$this->address_id = $customer_query->row['address_id'];
							
      			$this->db->query("UPDATE " . DB_PREFIX . "customer SET cart = '" . $this->db->escape(isset($this->session->data['cart']) ? serialize($this->session->data['cart']) : '') . "', wishlist = '" . $this->db->escape(isset($this->session->data['wishlist']) ? serialize($this->session->data['wishlist']) : '') . "', ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "' WHERE customer_id = '" . (int)$this->customer_id . "'");
				//karapuz
				if ($this->db->isKaInstalled('ka_acr')) {
					$this->saveAbandonedCart();
				}
				///karapuz
			
				$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "customer_ip WHERE customer_id = '" . (int)$this->session->data['customer_id'] . "' AND ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "'");
				
				if (!$query->num_rows) {
					$this->db->query("INSERT INTO " . DB_PREFIX . "customer_ip SET customer_id = '" . (int)$this->session->data['customer_id'] . "', ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "', date_added = NOW()");
				}
			} else {
				$this->logout();
			}
  		}
	}
		
  	public function login($email, $password, $override = false) {
		if ($override) {
			$customer_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "customer where LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "' AND status = '1'");
		} else {
			$customer_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "customer WHERE LOWER(email) = '" . $this->db->escape(utf8_strtolower($email)) . "' AND (password = SHA1(CONCAT(salt, SHA1(CONCAT(salt, SHA1('" . $this->db->escape($password) . "'))))) OR password = '" . $this->db->escape(md5($password)) . "') AND status = '1' AND approved = '1'");
		}
		
		if ($customer_query->num_rows) {
			$this->session->data['customer_id'] = $customer_query->row['customer_id'];	
		    
			if ($customer_query->row['cart'] && is_string($customer_query->row['cart'])) {
				$cart = unserialize($customer_query->row['cart']);
				
				foreach ($cart as $key => $value) {
					if (!array_key_exists($key, $this->session->data['cart'])) {
						$this->session->data['cart'][$key] = $value;
					} else {
						$this->session->data['cart'][$key] += $value;
					}
				}			
			}

			if ($customer_query->row['wishlist'] && is_string($customer_query->row['wishlist'])) {
				if (!isset($this->session->data['wishlist'])) {
					$this->session->data['wishlist'] = array();
				}
								
				$wishlist = unserialize($customer_query->row['wishlist']);
			
				foreach ($wishlist as $product_id) {
					if (!in_array($product_id, $this->session->data['wishlist'])) {
						$this->session->data['wishlist'][] = $product_id;
					}
				}			
			}
									
			$this->customer_id = $customer_query->row['customer_id'];
			$this->firstname = $customer_query->row['firstname'];
			$this->lastname = $customer_query->row['lastname'];
			$this->email = $customer_query->row['email'];
			$this->telephone = $customer_query->row['telephone'];
			$this->fax = $customer_query->row['fax'];
			$this->newsletter = $customer_query->row['newsletter'];
			$this->customer_group_id = $customer_query->row['customer_group_id'];
			$this->address_id = $customer_query->row['address_id'];
          	
			$this->db->query("UPDATE " . DB_PREFIX . "customer SET ip = '" . $this->db->escape($this->request->server['REMOTE_ADDR']) . "' WHERE customer_id = '" . (int)$this->customer_id . "'");
			
	  		return true;
    	} else {
      		return false;
    	}
  	}
  	
	public function logout() {
		$this->db->query("UPDATE " . DB_PREFIX . "customer SET cart = '" . $this->db->escape(isset($this->session->data['cart']) ? serialize($this->session->data['cart']) : '') . "', wishlist = '" . $this->db->escape(isset($this->session->data['wishlist']) ? serialize($this->session->data['wishlist']) : '') . "' WHERE customer_id = '" . (int)$this->customer_id . "'");
		
		unset($this->session->data['customer_id']);
		//karapuz
  		if ($this->db->isKaInstalled('ka_acr')) {
  			$this->session->data['ka_abandoned_info'] = false;
  		}
  		///karapuz

		$this->customer_id = '';
		$this->firstname = '';
		$this->lastname = '';
		$this->email = '';
		$this->telephone = '';
		$this->fax = '';
		$this->newsletter = '';
		$this->customer_group_id = '';
		$this->address_id = '';
  	}
  
  	public function isLogged() {
    	return $this->customer_id;
  	}

  	public function getId() {
    	return $this->customer_id;
  	}
      
  	public function getFirstName() {
		return $this->firstname;
  	}
  
  	public function getLastName() {
		return $this->lastname;
  	}
  
	//karapuz
	public static $ka_token_prefix = 'ka-';
	
  	public function loginGuest($abandoned_cart) {
  	
  		if (empty($abandoned_cart)) {
  			trigger_error("loginGuest: empty parameter");
  			return false;
  		}
  	
  		$this->session->data['cart'] = array();

		if (!empty($abandoned_cart['cart'])) {
								
			foreach ($abandoned_cart['cart'] as $key => $value) {
				if (!array_key_exists($key, $this->session->data['cart'])) {
					$this->session->data['cart'][$key] = $value;
				} else {
					$this->session->data['cart'][$key] += $value;
				}
			}			
		}
		
		return true;
  	}
	
  	
  	public function clearAbandonedCartByOrderid($order_id) {
  		
  		$qry = $this->db->query("SELECT abandoned_cart_id FROM " . DB_PREFIX . "ka_abandoned_carts WHERE 
  			order_id = '" . intval($order_id) . "'"
  		);
  		
  		if (!empty($qry->row)) {
  			$this->clearAbandonedCart($qry->row['abandoned_cart_id']);
  			return true;
  		}
  		
  		return false;
  	}
  	
  	
  	public function clearAbandonedCart($abandoned_cart_id = null, $hard_clearing = false) {
  	
  		if ($abandoned_cart_id === null) {
  			if (!empty($this->session->data['ka_abandoned_info'])) {
  				$abandoned_cart_id = $this->session->data['ka_abandoned_info']['abandoned_cart_id'];
  				
  				if (empty($this->session->data['ka_abandoned_info']['customer_id'])) {
  					$hard_clearing = true;
  				}
  			}
  		}
  	
  		if ($hard_clearing) {
			$this->db->query("DELETE FROM " . DB_PREFIX . "ka_abandoned_carts WHERE
				abandoned_cart_id = " . intval($abandoned_cart_id)
			);
		} else {
			$this->db->query("UPDATE " . DB_PREFIX . "ka_abandoned_carts SET
				cart = '' WHERE
					abandoned_cart_id = " . intval($abandoned_cart_id)
			);
		}
  	}
  	
	/*
		regular users can be identified by customer_id.
		guest users have customer_id = 0, store_id = <store_id>, email = <email>.
	
		PARAMETERS:
			$cart     - array
			$customer - array
	*/
	
	public function saveAbandonedCart($cart = null, $customer = null, $order_id = 0) {
		static $last_cart_hash = null;

		// 1/3 initialization
		//		
		if ($cart === null) {
			if (empty($this->session->data['cart'])) {
				$cart = array();
			} else {
				$cart = $this->session->data['cart'];
			}
		}
		
		if (empty($this->session->data['ka_abandoned_info'])) {
			$this->session->data['ka_abandoned_info'] = array(
				'abandoned_cart_id' => 0,
				'customer_id'       => 0
			);
		}
	
		if ($customer === null) {
			
			if (!empty($this->customer_id)) {
			
				$customer = array(
					'customer_id' => $this->customer_id,
					'firstname'   => $this->firstname,
					'lastname'    => $this->lastname,
					'email'       => $this->email
				);
			} elseif (!empty($this->session->data['ka_abandoned_info']['abandoned_cart_id'])) {
				$qry = $this->db->query("SELECT customer_id, firstname, lastname, email FROM " . DB_PREFIX . "ka_abandoned_carts
					WHERE abandoned_cart_id = " . intval($this->session->data['ka_abandoned_info']['abandoned_cart_id'])
				);
					
				$customer = $qry->row;
			}
		}

		if (empty($customer['email'])) {
			return false;
		}

		// 2/3 find abandoned cart record or create a new one
		//
		$customer_id = (empty($customer['customer_id']) ? 0 : intval($customer['customer_id']));
		$language_id = $this->config->get('config_language_id');
		$email       = $customer['email'];
		$store_id    = $this->config->get('config_store_id');

		// skip saving cart for previously used parameters
		//
		$cart_hash = md5(serialize($cart) . $customer_id . $email . $order_id);
		if (is_null($last_cart_hash)) {
			$last_cart_hash = $cart_hash;
		} else {
			if ($cart_hash == $last_cart_hash) {
				return true;
			}
		}
		
		$where = "customer_id = '" . intval($customer_id) . "'";
		if (empty($customer_id)) {
			$where .= " AND store_id = '" . intval($store_id) . "' AND email = '" . $this->db->escape($email) . "'";
		}
		$qry = $this->db->query("SELECT abandoned_cart_id FROM " . DB_PREFIX . "ka_abandoned_carts 
			WHERE $where"
		);
		
		if (empty($qry->row)) {
			$salt = self::generateAcrSalt();
		
			$this->db->query("INSERT INTO " . DB_PREFIX . "ka_abandoned_carts SET
				salt = '" . $this->db->escape($salt) . "',
				customer_id = '" . intval($customer_id) . "',
				store_id = '" . intval($store_id) . "',
				email = '" . $this->db->escape($email) . "'"
			);
			
			$abandoned_cart_id = $this->db->getLastId();
			
		} else {
			$abandoned_cart_id = $qry->row['abandoned_cart_id'];
		}
		
		// Delete old abandoned cart for guest users if the id does not match the current user.
		// We do not delete abandoned carts of registered users.
		//
		if (!empty($this->session->data['ka_abandoned_info']['abandoned_cart_id'])
			&& empty($this->session->data['ka_abandoned_info']['customer_id'])
		) 
		{
			if ($abandoned_cart_id != $this->session->data['ka_abandoned_info']['abandoned_cart_id']) 
			{
				$this->clearAbandonedCart($this->session->data['ka_abandoned_info']['abandoned_cart_id'], true);
			}
		}

		$this->session->data['ka_abandoned_info'] = array(
			'abandoned_cart_id' => $abandoned_cart_id,
			'customer_id'       => $customer_id
		);
		
		// 3/3 Update the record with new data
		//
		foreach (array('firstname', 'lastname', 'email') as $v) {
			$customer[$v] = (isset($customer[$v]) ? trim($customer[$v]) : '');
		}
		
		$this->db->query("UPDATE " . DB_PREFIX . "ka_abandoned_carts SET
			language_id = '" .intval($language_id) ."',
			email = '" . $this->db->escape($customer['email']) . "',
			firstname = '" . $this->db->escape($customer['firstname']) . "',
			lastname = '" . $this->db->escape($customer['lastname']) . "',
			cart = '" . $this->db->escape(isset($cart) ? serialize($cart) : '') . "',
			order_id = " . intval($order_id) . ",
			last_visited = NOW()
			WHERE abandoned_cart_id = '" . intval($abandoned_cart_id) ."'"
		);

		return true;
	}
	
	public static function generateAcrSalt() {
		$salt = substr(md5(uniqid(rand(), true)), 0, 16);
		
		return $salt;
	}
	///karapuz
  	public function getEmail() {
		return $this->email;
  	}
  
  	public function getTelephone() {
		return $this->telephone;
  	}
  
  	public function getFax() {
		return $this->fax;
  	}
	
  	public function getNewsletter() {
		return $this->newsletter;	
  	}

  	public function getCustomerGroupId() {
		return $this->customer_group_id;	
  	}
	
  	public function getAddressId() {
		return $this->address_id;	
  	}
	
  	public function getBalance() {
		$query = $this->db->query("SELECT SUM(amount) AS total FROM " . DB_PREFIX . "customer_transaction WHERE customer_id = '" . (int)$this->customer_id . "'");
	
		return $query->row['total'];
  	}	
		
  	public function getRewardPoints() {
		$query = $this->db->query("SELECT SUM(points) AS total FROM " . DB_PREFIX . "customer_reward WHERE customer_id = '" . (int)$this->customer_id . "'");
	
		return $query->row['total'];	
  	}	
}
?>
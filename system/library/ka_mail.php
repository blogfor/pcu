<?php
/*
	Project: Ka Extensions
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 44 $)

*/
class KaMail {
	public $mail;
	public $sender;
	public $data;
	public $images;
	public $http_catalog;
	public $registry;

	function __construct($registry, $store_id = 0) {
	
		$this->language = $registry->get('language');
		$this->global_config = $registry->get('config');
		$this->db       = $registry->get('db');
		$this->request  = $registry->get('request');
		$this->session  = $registry->get('session');
		$this->log      = $registry->get('log');
	
		$this->mail = new Mail(); 
		$this->mail->protocol  = $this->global_config->get('config_mail_protocol');
		$this->mail->parameter = $this->global_config->get('config_mail_parameter');
		$this->mail->hostname  = $this->global_config->get('config_smtp_host');
		$this->mail->username  = $this->global_config->get('config_smtp_username');
		$this->mail->password  = $this->global_config->get('config_smtp_password');
		$this->mail->port      = $this->global_config->get('config_smtp_port');
		$this->mail->timeout   = $this->global_config->get('config_smtp_timeout');
		
		$query = $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "store WHERE store_id = '" . (int)$store_id . "'");
		
		if (!empty($query->row)) {
			$this->data['store_name'] = $query->row['name'];
			$this->data['sender']     = $query->row['name'];
			$this->data['store_url']  = $query->row['url'] . 'index.php?route=account/login';
			$this->http_catalog = $query->row['url'];

			$query =  $this->db->query("SELECT DISTINCT * FROM " . DB_PREFIX . "setting WHERE 
				store_id = '" . (int)$store_id . "' AND `group` = 'config'"
			);
			$this->config = new Config();
			foreach ($query->rows as $setting) {
				if (!$setting['serialized']) {
					$this->config->set($setting['key'], $setting['value']);
				} else {
					$this->config->set($setting['key'], unserialize($setting['value']));
				}
			}
			
		} else {
			$this->config = &$this->global_config;
			$this->data['store_name'] = $this->config->get('config_name');
			$url = (defined('HTTP_CATALOG')) ? HTTP_CATALOG : HTTP_SERVER;
			$this->http_catalog = $url;
			$this->data['store_url']  = $url . 'index.php?route=account/login';
		}
		
		$this->data['config'] = &$this->config;
	}

	
	public function send($from, $to, $subject, $tpl, $extra = array()) {

		if (empty($from)) {
			$from = $this->config->get('config_email');
		}

		if (empty($this->data['sender'])) {
			$sender = $this->config->get('config_name');
		} else {
			$sender = $this->data['sender'];
		}

		// HTML Mail
		$template = new Template();
		$template->data = $this->data;
		$template->language = $this->language;
		
		$template->data['subject'] = $subject;
		$this->images['logo'] = $this->config->get('config_logo');

		$html = $text = '';

 		$tpl_path_default = $tpl_path = ''; 		
 		if (!defined('HTTP_CATALOG')) { // if it is front-end
 			$tpl_path         = $this->config->get('config_template') . "/template/";
 			$tpl_path_default = "default/template/" . $tpl;
 		}

		if (file_exists(DIR_TEMPLATE . $tpl_path . "mail/text/" . $tpl)) {
			$text = $template->fetch($tpl_path. "mail/text/" . $tpl);
		} else if (file_exists(DIR_TEMPLATE . $tpl_path_default. "mail/text/" . $tpl)) {
			$text = $template->fetch($tpl_path_default. "mail/text/" . $tpl);
		}

		
		if (!empty($this->images)) {
			$image_location = $this->http_catalog . 'image/';
			foreach ($this->images as $ik => $iv) {
				if (file_exists(DIR_IMAGE . $iv)) {
					
					if (empty($extra['images_in_emails'])  || $extra['images_in_emails'] != 'links') {
						$filename = DIR_IMAGE . $iv;
						$template->data['_images'][$ik] = $template->data[$ik] = 'cid:' . urlencode($filename);
						$this->mail->addAttachment($filename);
					} else {
						$template->data['_images'][$ik] = $template->data[$ik] = $image_location . $iv;
					}
				}
			}
		}

		if (file_exists(DIR_TEMPLATE . $tpl_path . "mail/" . $tpl)) {
			$html = $template->fetch($tpl_path . "mail/" . $tpl);
		} else if (file_exists(DIR_TEMPLATE . $tpl_path_default . "mail/" . $tpl)) {
			$html = $template->fetch($tpl_path_default . "mail/" . $tpl);
		}

		if (empty($html) && empty($text)) {
			$this->log->write("WARNING: None of email templates is found: $tpl");
			return false;
		}

		$this->mail->setTo($to);
		$this->mail->setFrom($from);
		$this->mail->setSender($sender);
		$this->mail->setSubject($subject);
		$this->mail->setText($text);
		$this->mail->setHtml($html);

		$this->mail->send();
		
		return true;
	}
}
?>
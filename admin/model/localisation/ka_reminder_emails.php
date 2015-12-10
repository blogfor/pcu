<?php 
/*
	Project: Abandoned Cart Recovery
	Author : karapuz <support@ka-station.com>

	Version: 2 ($Revision: 74 $)

*/
require_once(KaVQMod::modCheck(DIR_SYSTEM . 'engine/ka_model.php'));

class ModelLocalisationKaReminderEmails extends KaModel {

	protected function getRecords($data, $language_id = 0) {

		if (empty($data['fields'])) {
			trigger_error("ka_acr: No fields data in getRecords() function");
			return false;
		}
		
		if (!$language_id) {
			$language_id = $this->config->get('config_language_id');
		}
	
		$sql = "SELECT " . $data['fields'] . " FROM " . DB_PREFIX . "ka_reminder_emails re 
			LEFT JOIN " . DB_PREFIX . "ka_reminder_emails_descr red
				ON (re.reminder_email_id = red.reminder_email_id 
				AND red.language_id = " . (int)$language_id . ")
		";
		
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

	
	public function getReminderEmails($data = array()) {
	
		$data['fields'] = 'red.*, re.*';

		$qry = $this->getRecords($data);

		return $qry->rows;
	}

	public function getTotalReminderEmails() {
	
      	$data['fields'] = 'COUNT(*) AS total';
      	
		$qry = $this->getRecords($data);
		
		return $qry->row['total'];
	}
		

	public function deleteReminderEmail($reminder_email_id) {
		$this->db->query("DELETE FROM " . DB_PREFIX . "ka_reminder_emails WHERE reminder_email_id = '" . (int)$reminder_email_id . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "ka_reminder_emails_descr WHERE reminder_email_id = '" . (int)$reminder_email_id . "'");
	}

	
	public function getReminderEmail($reminder_email_id, $language_id = 0) {
	
		if ($language_id == 0) {
			$language_id = $this->config->get('config_language_id');
		}
	
		$query = $this->db->query("SELECT red.*, re.* FROM " . DB_PREFIX . "ka_reminder_emails re
			LEFT JOIN " . DB_PREFIX . "ka_reminder_emails_descr red ON
				re.reminder_email_id = red.reminder_email_id AND language_id = '" . intval($language_id) . "'
			WHERE re.reminder_email_id = '" . (int)$reminder_email_id . "'"
		);
		
		if (empty($query->row)) {
			return false;
		}
		
		return $query->row;
	}

	
	public function getReminderEmailDescriptions($reminder_email_id) {
		$reminder_email_data = array();
		
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "ka_reminder_emails_descr WHERE reminder_email_id = '" . (int)$reminder_email_id . "'");
		
		foreach ($query->rows as $result) {
			$reminder_email_data[$result['language_id']] = array(
				'name'        => $result['name'],
				'subject'     => $result['subject'],
				'description' => $result['description']
			);
		}
		
		return $reminder_email_data;
	}

	
	public function updateLastSubmitted($reminder_email_id, $data = '') {
	
		if (empty($data)) {
			$str = "NOW()";
		} else {
			$str = "'" . $this->db->escape($data) . "'";
		}

		$this->db->query("UPDATE " . DB_PREFIX . "ka_reminder_emails SET 
			last_submitted = $str 
			WHERE reminder_email_id = '" . (int)$reminder_email_id . "'"
		);
	}
	
		
	public function saveReminderEmail($data) {

		if (empty($data['reminder_email_id'])) {
			$this->db->query("INSERT INTO " . DB_PREFIX . "ka_reminder_emails SET 
				last_edited = NOW()"
			);
			$reminder_email_id = $this->db->getLastId();
		} else {
			$reminder_email_id = $data['reminder_email_id'];
		}

		$update = array();
		if (isset($data['sort_order'])) {
			$update[] = "sort_order = '" . intval($data['sort_order']) . "'";
		}
				
		if (isset($data['send_in_hours'])) {
			$update[] = "send_in_hours = '" . intval($data['send_in_hours']) . "'";
		}

		if (isset($data['enabled'])) {
			$update[] = "enabled = " . intval($data['enabled']);
		}
				
		if (!empty($data['update_last_edited'])) {
			$update[] = "last_edited = NOW(), last_submitted = '0000-00-00 00:00:00'";
		}
		
		$this->db->query("UPDATE " . DB_PREFIX . "ka_reminder_emails SET "
			. implode(", ", $update)
			. " WHERE reminder_email_id = '" . (int)$reminder_email_id . "'"
		);

		if (!empty($data['reminder_email_description'])) {							
			$this->db->query("DELETE FROM " . DB_PREFIX . "ka_reminder_emails_descr 
				WHERE reminder_email_id = '" . (int)$reminder_email_id . "'"
			);
			
			foreach ($data['reminder_email_description'] as $language_id => $value) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "ka_reminder_emails_descr SET 
					reminder_email_id = '" . (int)$reminder_email_id . "', 
					language_id = '" . (int)$language_id . "', 
					name = '" . $this->db->escape($value['name']) . "',
					subject = '" . $this->db->escape($value['subject']) . "',
					description = '" . $this->db->escape($value['description']) . "'"
				);
			}
		}
		
		return $reminder_email_id;
	}
	
	
	public function prefillReminderEmails() {
	
		$qry = $this->db->query("SELECT kre.reminder_email_id FROM " . DB_PREFIX . "ka_reminder_emails_descr kred
			INNER JOIN " . DB_PREFIX . "ka_reminder_emails kre ON kred.reminder_email_id = kre.reminder_email_id
			 WHERE kred.name like 'Standard text'
		");
		if (!empty($qry->rows)) {
			return false;
		}

		$in_hours = (int)$this->config->get('ka_acr_remind_in_hours');
		if (empty($in_hours)) {
			$in_hours = 24;
		}
		
		$default_email = array(
			'enabled' => 1,
			'send_in_hours' => $in_hours,
		);
		
		$this->load->model('localisation/language');
		$this->load->model('sale/ka_abandoned_carts');
		
		$descriptions = array();		
		$langs = $this->model_localisation_language->getLanguages();		
		foreach ($langs as $lang) {
			if ($lang['status'] == 1) {
				$tmp_lang = $this->model_sale_ka_abandoned_carts->loadTempLanguage($lang['language_id']);
				$tmp_lang->load('ka_extensions/ka_acr');
				$descriptions[$lang['language_id']] = array(
					'name' => 'Standard text',
					'subject' => $tmp_lang->get('You have some items in the cart'),
					'description' => $tmp_lang->get('reminder_email_description')
				);
			}
		}
		
		if (empty($descriptions)) {
			trigger_error("No active languages found in the store");
			return false;
		}
		
		$default_email['reminder_email_description'] = $descriptions;
		$this->saveReminderEmail($default_email);
	}
	
}
?>
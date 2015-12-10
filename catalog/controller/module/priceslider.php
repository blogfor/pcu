<?php  
class ControllerModulePriceSlider extends Controller {
	protected function index($setting) {
		$this->language->load('module/priceslider');
		$this->children = array(
			'module/language',
			'module/currency',
			'module/cart'
		);
    	$this->data['heading_title'] = sprintf($this->language->get('heading_title'), $this->config->get('config_name'));
    	$this->data['text_filter_price']=$this->language->get('text_filter_price');
	
		if ($setting['upperlimit']) {
			$this->data['upperlimit'] = $setting['upperlimit'];
                }
                else
                {
                    $this->data['upperlimit'] = 10000;
                }
			
		
		if ($setting['lowerlimit']) {
			$this->data['lowerlimit'] = $setting['lowerlimit'];
                }
                else
                {
                    $this->data['lowerlimit'] = 0;
                }	

	
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/priceslider.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/priceslider.tpl';
		} else {
			$this->template = 'default/template/module/priceslider.tpl';
		}
		
		$this->render();
	}
}
?><?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
?>

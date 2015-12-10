<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 79 $)

*/
?>
<?php echo $header; ?>
<div id="content">

  <?php echo $ka_top; ?>

  <div class="box">
    <div class="heading">
      <h1><img src="view/image/order.png" alt="" /><?php echo $this->language->get('Abandoned Carts'); ?></h1>
      <div class="buttons">
      	<a onclick="$('#form').attr('action', '<?php echo $action_delete; ?>'); $('#form').submit();" class="button"><?php echo $this->language->get('button_delete'); ?></a>
      </div>
    </div>
    
    <div class="content">
    
      <table>
        <tr>
          <td><b>Automatic Script Execution Status:</b></td>
          
          <td>
          <?php if (!empty($task)) { ?>
            Installed
          <?php } else { ?>
            Not Installed
          <?php } ?>
          </td>
        </tr>
        <tr>
          <td><b>Last Script Run:</b></td>
          <td>
            <?php if (!empty($task)) { ?>
              <?php echo $task['last_run'];  ?>
            <?php } else { ?>
              n/a
            <?php } ?>
           </td>          
        </tr>
      </table>
          
      <form action="<?php echo $action_send; ?>" method="post" enctype="multipart/form-data" id="form">
      
        <table class="list">        
          <thead>
            <tr>
              <td width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
              
              <td class="left"><?php if ($params['sort'] == 'customer_name') { ?>
                <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($params['order']); ?>"><?php echo $this->language->get('Name'); ?></a>
                <?php } else { ?>
                <a href="<?php echo $sort_name; ?>"><?php echo $this->language->get('Name'); ?></a>
                <?php } ?>
              </td>
              <td class="left"><?php if ($params['sort'] == 'c.email') { ?>
                <a href="<?php echo $sort_email; ?>" class="<?php echo strtolower($params['order']); ?>"><?php echo $this->language->get('Email'); ?></a>
                <?php } else { ?>
                <a href="<?php echo $sort_email; ?>"><?php echo $this->language->get('Email'); ?></a>
                <?php } ?>
              </td>
              <td class="left" style="width: 100px">
                  <a href="<?php echo $sort_last_visited; ?>" <?php if ($params['sort'] == 'last_visited') { ?> class="<?php echo strtolower($params['order']); ?>"<?php } ?>>
                  <?php echo $this->language->get('Last Visited'); ?>
                  </a>
              </td>
              <td class="left" style="width: 100px">
                  <a href="<?php echo $sort_last_reminded; ?>" <?php if ($params['sort'] == 'last_reminded') { ?> class="<?php echo strtolower($params['order']); ?>"<?php } ?>>
                  <?php echo $this->language->get('Last Reminded'); ?>
                  </a>
              </td>
              <td class="left" style="width: 100px">
                  <?php echo $this->language->get('Next Reminder'); ?>
                  </a>
              </td>
              <td class="left" style="width: 100px">
                  <a href="<?php echo $sort_link_opened; ?>" <?php if ($params['sort'] == 'link_opened') { ?> class="<?php echo strtolower($params['order']); ?>"<?php } ?>>
                  <?php echo $this->language->get('Link Opened'); ?>
                  </a>
              </td>
              <td class="right" style="width: 100px"><?php echo $this->language->get('Action'); ?></td>
            </tr>
          </thead>
          
          <tbody>
            <tr class="filter">
              <td>&nbsp;</td>
              <td><input type="text" name="filter_customer_name" value="<?php echo $params['filter_customer_name']; ?>" /></td>
              <td><input type="text" name="filter_customer_email" value="<?php echo $params['filter_customer_email']; ?>" /></td>
              <td align="left">
                <select name="filter_last_visited">
                  <option value="">&nbsp;</option>
                  <option <?php if ($params['filter_last_visited'] == '7') { ?>selected="selected" <?php } ?>value="7">Last Week</option>
                  <option <?php if ($params['filter_last_visited'] == '14') { ?>selected="selected" <?php } ?>value="14">Last 2 Weeks</option>
                  <option <?php if ($params['filter_last_visited'] == '30') { ?>selected="selected" <?php } ?>value="30">Last Month</option>
                </select>
              </td>
              <td align="left">&nbsp;</td>
              <td align="left">&nbsp;</td>
              <td align="left">&nbsp;</td>
              <td align="right"><a onclick="filter();" class="button"><?php echo $this->language->get('Filter'); ?></a></td>
            </tr>
          
            <?php if (!empty($carts)) { ?>
            <?php foreach ($carts as $cart) { ?>
            <tr>
              <td style="text-align: center;"><?php if (!empty($cart['selected'])) { ?>
                <input type="checkbox" name="selected[]" value="<?php echo $cart['abandoned_cart_id']; ?>" checked="checked" />
                <?php } else { ?>
                <input type="checkbox" name="selected[]" value="<?php echo $cart['abandoned_cart_id']; ?>" />
                <?php } ?></td>
              <td class="left">
                <?php if (isset($cart['customer_link'])) { ?>
                  <a href="<?php echo $cart['customer_link']; ?>" target="_blank"><?php echo $cart['customer_name']; ?></a>
                <?php } else { 
                    echo $cart['customer_name'];                  
                  }
                ?>
              </td>
              <td class="left"><?php echo $cart['email']; ?></td>
              <td class="left"><?php echo $cart['last_visited']; ?></td>
              <td class="left"><?php echo $cart['last_reminded']; ?></td>
              <td class="left"><?php echo $cart['next_reminder']; ?></td>
              <td class="left"><?php echo $cart['link_opened']; ?></td>
              
              <td class="right">
                <?php foreach ($cart['action'] as $action) { ?>
                  [ <a href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
                <?php } ?></td>
            </tr>
            <?php } ?>
            <?php } else { ?>
            <tr>
              <td class="center" colspan="8"><?php echo $text_no_results; ?></td>
            </tr>
            <?php } ?>
          </tbody>
        </table>
        
        <div class="pagination"><?php echo $pagination; ?></div>      
        <br /><br />
        <div class="buttons">
          Reminder Email: 
          <?php if (!empty($reminder_emails)) { ?>
            <?php $this->showTemplate('ka_extensions/select.tpl', 
              array('name' => 'reminder_email_id', 
                'value' => $reminder_email_id, 
                'options' => $reminder_emails)); 
            ?>
            <a onclick="$('form').submit();" class="button">Send Email to Checked Customers</a>
            <br />
          <?php } ?>            
          <br /><span class="help">Manage reminder emails <a href="<?php echo $reminder_emails_url; ?>">here</a>.</span>
        </div>
      </form>
    </div>
  </div>
</div>

<script type="text/javascript"><!--

function filter() {
  url = 'index.php?route=sale/ka_abandoned_carts&token=<?php echo $token; ?>';
  
  var filter_customer_name = $('input[name=\'filter_customer_name\']').attr('value');
  if (filter_customer_name) {
    url += '&filter_customer_name=' + encodeURIComponent(filter_customer_name);
  }
  
  var filter_customer_email = $('input[name=\'filter_customer_email\']').attr('value');
  if (filter_customer_email) {
    url += '&filter_customer_email=' + encodeURIComponent(filter_customer_email);
  }

  var filter_last_visited = $('select[name=\'filter_last_visited\']').attr('value');
  if (filter_last_visited) {
    url += '&filter_last_visited=' + encodeURIComponent(filter_last_visited);
  }
    
  location = url;
}

//--></script> 

<?php echo $footer; ?>
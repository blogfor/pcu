<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 70 $)

*/
?>
<?php echo $header; ?>
<div id="content">

  <?php echo $ka_top; ?>

  <div class="box">
    <div class="heading">
      <h1><img src="view/image/order.png" alt="" /> <?php echo $this->language->get('Cart Reminder Emails'); ?></h1>
      <div class="buttons">
        <a onclick="$('form').attr('action', '<?php echo $update; ?>').submit();" class="button"><?php echo $this->language->get('Update'); ?></a>
        <a onclick="location = '<?php echo $insert; ?>'" class="button"><?php echo $this->language->get('Insert'); ?></a>
        <a onclick="$('form').submit();" class="button"><?php echo $this->language->get('Delete'); ?></a>
      </div>
    </div>
    
    <div class="content">
      <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
     
        <table class="list">
          <thead>
            <tr>
              <td width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
              
              <td class="left">
                <?php if ($params['sort'] == 'name') { ?>
                  <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($params['order']); ?>">Name</a>
                <?php } else { ?>
                  <a href="<?php echo $sort_name; ?>">Name</a>
                <?php } ?>
              </td>
              
              <td class="left" width="100px">Send In N Hours</td>
              <td class="left" width="30px">Enabled</td>
              
              <td class="left" width="100px">Last Submitted</td>
              <td class="right" width="100px"><?php echo $this->language->get('Action'); ?></td>
            </tr>
          </thead>
          
          <tbody>
            <?php if ($reminder_emails) { ?>
            <?php foreach ($reminder_emails as $re) { ?>
            <tr>
              <td style="text-align: center;"><?php if ($re['selected']) { ?>
                <input type="checkbox" name="selected[]" value="<?php echo $re['reminder_email_id']; ?>" checked="checked" />
                <?php } else { ?>
                <input type="checkbox" name="selected[]" value="<?php echo $re['reminder_email_id']; ?>" />
                <?php } ?>
              </td>              
              <td class="left"><?php echo $re['name']; ?></td>
              <td class="center">
	              <input type="text" size="10" name="emails[<?php echo $re['reminder_email_id'];?>][send_in_hours]" value="<?php echo $re['send_in_hours']; ?>" />
              </td>
              <td class="center"><input type="checkbox" name="emails[<?php echo $re['reminder_email_id'];?>][enabled]" value="1" <?php if (!empty($re['enabled'])) { ?> checked="checked" <?php } ?> /> </td>
              
              <td class="left">
              	<?php echo (!empty($re['last_submitted'])) ? $re['last_submitted'] : $this->language->get('n/a'); ?>
              </td>              
              <td class="right"><?php foreach ($re['action'] as $action) { ?>
                [ <a href="<?php echo $action['href']; ?>"><?php echo $action['text']; ?></a> ]
                <?php } ?>
              </td>
            </tr>
            <?php } ?>
            <?php } else { ?>
            <tr>
              <td class="center" colspan="6"><?php echo $this->language->get('No Results'); ?></td>
            </tr>
            <?php } ?>
          </tbody>
        </table>
      </form>
      <div class="pagination"><?php echo $pagination; ?></div>
    </div>
    
  </div>
</div>
<?php echo $footer; ?> 
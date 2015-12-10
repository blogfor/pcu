<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 91 $)

*/
?>
<?php echo $header; ?>

<div id="content">

  <?php echo $ka_top; ?>
  
  <div class="box">
    <div class="heading">
      <h1><img src="view/image/order.png" alt="" /> <?php echo $this->language->get('Reminder Email'); ?></h1>
      <div class="buttons"><a onclick="$('#form').submit();" class="button"><?php echo $this->language->get('Save'); ?></a>
      <a onclick="location = '<?php echo $cancel; ?>';" class="button"><?php echo $this->language->get('Cancel'); ?></a>
    </div>
    </div>
    <div class="content">
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
  
        <?php if (!empty($reminder_email['reminder_email_id'])) { ?>
          <input type="hidden" name="reminder_email_id" value="<?php echo $reminder_email['reminder_email_id']; ?>" />
        <?php } ?>
            
        <table class="form">
          <tr>
            <td><span class="required">*</span> <?php echo $this->language->get('Name'); ?></td>
            <td><?php foreach ($languages as $language) { ?>
              <input type="text" maxsize="255" size="100" name="reminder_email_description[<?php echo $language['language_id']; ?>][name]" value="<?php echo isset($reminder_email['descriptions'][$language['language_id']]) ? $reminder_email['descriptions'][$language['language_id']]['name'] : ''; ?>" />
              <img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /><br />
              <?php if (isset($error_name[$language['language_id']])) { ?>
                <span class="error"><?php echo $error_name[$language['language_id']]; ?></span><br />
              <?php } ?>
              <?php } ?>
            </td>
          </tr>
                                    
          <tr>
            <td><span class="required">*</span> <?php echo $this->language->get('Subject'); ?></td>
            <td><?php foreach ($languages as $language) { ?>
              <input type="text" maxsize="255" size="100" name="reminder_email_description[<?php echo $language['language_id']; ?>][subject]" value="<?php echo isset($reminder_email['descriptions'][$language['language_id']]) ? $reminder_email['descriptions'][$language['language_id']]['subject'] : ''; ?>" />
              <img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /><br />
              <?php if (isset($error_subject[$language['language_id']])) { ?>
                <span class="error"><?php echo $error_subject[$language['language_id']]; ?></span><br />
              <?php } ?>
              <?php } ?>
            </td>
          </tr>
            
          <tr>
            <td>
              <span class="required">*</span> <?php echo $this->language->get('Description'); ?>
              <span class="help">This text will appear below greeting and above the product list.</span>
            </td>
            <td><?php foreach ($languages as $language) { ?>
              <textarea cols="60" rows="8" id="reminder_email_description<?php echo $language['language_id']; ?>" name="reminder_email_description[<?php echo $language['language_id']; ?>][description]"><?php echo isset($reminder_email['descriptions'][$language['language_id']]) ? $reminder_email['descriptions'][$language['language_id']]['description'] : ''; ?></textarea>
              <img src="view/image/flags/<?php echo $language['image']; ?>" title="<?php echo $language['name']; ?>" /><br />
              <?php if (isset($error_name[$language['language_id']])) { ?>
                <span class="error"><?php echo $error_description[$language['language_id']]; ?></span><br />
              <?php } ?>
              <?php } ?>
            </td>
          </tr>
          <tr>
            <td><?php echo $this->language->get('Send in N Hours'); ?></td>
            <td>
              <input type="text" name="send_in_hours" value="<?php echo $reminder_email['send_in_hours']; ?>" />
            </td>
          </tr>
          <tr>
            <td><?php echo $this->language->get('Update Last Edited Date'); ?></td>
            <td>
              <input type="checkbox" name="update_last_edited" value="Y" <?php if (!empty($reminder_email['update_last_edited'])) { ?> checked="checked" <?php } ?> />
            </td>
          </tr>
          <tr>
            <td><?php echo $this->language->get('Enabled'); ?></td>
            <td>
              <input type="checkbox" name="enabled" value="1" <?php if (!empty($reminder_email['enabled'])) { ?> checked="checked" <?php } ?> />
            </td>
          </tr>
        </table>
      </form>
    </div>
  </div>
</div>

<script type="text/javascript" src="view/javascript/ckeditor/ckeditor.js"></script> 
<script type="text/javascript"><!--
<?php foreach ($languages as $language) { ?>
CKEDITOR.replace('reminder_email_description<?php echo $language['language_id']; ?>', {
  filebrowserBrowseUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
  filebrowserImageBrowseUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
  filebrowserFlashBrowseUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
  filebrowserUploadUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
  filebrowserImageUploadUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>',
  filebrowserFlashUploadUrl: 'index.php?route=common/filemanager&token=<?php echo $token; ?>'
});
<?php } ?>
//--></script> 

<?php echo $footer; ?>
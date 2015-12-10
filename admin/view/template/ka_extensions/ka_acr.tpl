<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 93 $)

*/?>
<?php echo $header; ?>

<style>
#service_line {
  width: 100%;
  background-color: #EFEFEF;
}

table.list td.msg_warning {
  background-color: yellow;
  color: black;
}

table.list td.msg_ok {
  background-color: #7FFF00;
  color: black;
}

table.list td.msg_error {
  background-color: red;
  color: black;
}

</style>

<div id="content">
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>

  <?php if ($error_warning) { ?>
  <div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>

<div class="box">

  <div class="heading">
    <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
      <div class="buttons">
        <a onclick="$('#form').submit();" class="button"><span><?php echo $button_save; ?></span></a>
        <a onclick="location = '<?php echo $cancel; ?>';" class="button"><span><?php echo $button_cancel; ?></span></a>
      </div>
  </div>
  
  <div class="content">
    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
      <input type="hidden" name="mode" value="" id="mode" />
      
      <div id="service_line">
      <table>
        <tr>
          <td><b>Full Version</b>: <?php echo $extension_version; ?>&nbsp;&nbsp;&nbsp;</td>
          <td><b>Author</b>: karapuz&nbsp;&nbsp;&nbsp;</td>
          <td><b>Contact Us</b>: <a href="mailto:support@ka-station.com">via email</a>&nbsp;&nbsp;&nbsp;</td>
          <td><a href="https://www.ka-station.com/index.php?route=information/contact" target="_blank">via secure form at www.ka-station.com</a>&nbsp;&nbsp;&nbsp;</td>
        </tr>
      </table>
      </div>
      
      <table id="module" class="list">
        <thead> 
          <tr>
            <td class="left">Setting</td>
            <td>Value</td>
          </tr>
        </thead>
        <tbody>

         <?php if ($install_status == 'scheduler_not_installed') { ?>
           <tr>
             <td class="left msg_error" colspan="2"><b>ERROR:</b> Task Scheduler extension is not found.</td>
           </tr>
         <?php } elseif ($install_status == 'task_not_installed') { ?>
           <tr>
             <td class="left msg_error" colspan="2"><b>ERROR:</b> Automatic script execution is not installed. Please re-install the extension. If the error is still present, contact a developer.</td>
           </tr>
         <?php } elseif ($install_status == 'scheduler_not_configured') { ?>
           <tr>
             <td class="left msg_warning" colspan="2"><b>WARNING:</b> Check configuration of the 'Task Scheduler' module to make sure that it runs periodically.</td>
           </tr>
         <?php } elseif ($install_status == 'task_installed') { ?>
           <tr>
             <td class="left msg_ok" colspan="2"><b>SUCCESS:</b> Automatic script execution is installed properly.</td>
           </tr>
         <?php } ?>
                
          <tr>
            <td class="left" width="60%">Remind after N hours
            </td>
            <td class="left" width="40%">
            	A list of reminder emails and their time can be managed on 
            	the <a href="<?php echo $emails_url; ?>" target="_blank">reminder emails</a> page.
            </td>
          </tr>

          <tr>
            <td class="left">Generate link with auto login</td>
            <td class="left">
              <input type="checkbox" name="ka_acr_auto_login_link" value="Y" <?php if (isset($ka_acr_auto_login_link) && $ka_acr_auto_login_link == 'Y') { ?> checked="checked" <?php }; ?> onclick="javascript: onAutoLoginUpdate();" />
            </td>
          </tr>

          <tr id="link_expires_block" <?php if (empty($ka_acr_auto_login_link)) { ?> style="display:none" <?php } ?>>
            <td class="left" width="60%">Auto-login link expires in N hours</td>
            <td class="left"  width="40%">
              <input type="text" name="ka_acr_link_expires_in_hours" value="<?php echo $ka_acr_link_expires_in_hours; ?>" />
            </td>
          </tr>
          
          <tr>
            <td class="left">Show carts of unsubscribed customers on the abandoned carts page</td>
            <td class="left">
              <input type="checkbox" name="ka_acr_show_unsubscribed" value="Y" <?php if (isset($ka_acr_auto_login_link) && $ka_acr_show_unsubscribed == 'Y') { ?> checked="checked" <?php }; ?> />
            </td>
          </tr>
          <tr>
            <td class="left">Show carts without 1 hour delay</td>
            <td class="left">
              <input type="checkbox" name="ka_acr_show_carts_wo_delay" value="Y" <?php if (isset($ka_acr_show_carts_wo_delay) && $ka_acr_show_carts_wo_delay == 'Y') { ?> checked="checked" <?php }; ?> />
            </td>
          </tr>
          
          <tr>
            <td class="left">Include images in emails as</td>
            <td class="left" width="40%">
            	<select name="ka_acr_images_in_emails">
            		<option <?php if ($ka_acr_images_in_emails == 'attachments') { ?> selected="selected" <?php } ?>value="attachments">attachments</option>
            		<option <?php if ($ka_acr_images_in_emails == 'links') { ?> selected="selected" <?php } ?>value="links">links</option>
            	</select>
            </td>
          </tr>
          
        </tbody>
      </table>
    </form>
  </div>
</div>

<script type="text/javascript"><!--

function onAutoLoginUpdate() {

  if ($("input[name=ka_acr_auto_login_link]").prop('checked')) {
    $('#link_expires_block').fadeIn(300);
  } else {
    $('#link_expires_block').fadeOut(300);
  }
}

//--></script>

<?php echo $footer; ?>
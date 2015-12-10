<?php
/*
  Project: Task Scheduler
  Author : karapuz <support@ka-station.com>

  Version: 1.0 ($Revision: 48 $)

*/?>
<?php echo $header; ?>

<style>
.cron_notice {
  
}

table.list td.msg_not_found {
  background-color: yellow;
  color: black;
}

table.list td.msg_installed {
  background-color: #7FFF00;
  color: black;
}

table.list td.msg_wrong {
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

          <?php if ($cronjob_install_status == 'crontab_not_found') { ?>
            <tr>
              <td class="left msg_not_found" colspan="2"><b>WARNING:</b> crontab command is not found. Make sure the script is called periodically from an external site.</td>
            </tr>
          <?php } elseif ($cronjob_install_status == 'wget_not_found') { ?>
            <tr>
              <td class="left msg_not_found" colspan="2"><b>WARNING:</b> wget command is not found on the server. Make sure the script is called periodically from an external site.</td>
            </tr>
          <?php } elseif ($cronjob_install_status == 'cronjob_not_found') { ?>
            <tr>
              <td class="left msg_not_found" colspan="2"><b>WARNING:</b> Cronjob record is not found on the server.</td>
            </tr>
            <tr>
              <td class="left">Automatic cronjob installation
              </td>
              <td class="left">
                <input type="button"  value="Install" onclick="javascript: $('#mode').attr('value', 'install'); $('#form').submit();" />
              </td>
            </tr>
          <?php } elseif ($cronjob_install_status == 'wrong_cronjob') { ?>
            <tr>
              <td class="left msg_wrong" colspan="2"><b>WARNING:</b> cronjob record exists but it cannot be confirmed as valid.</td>
            </tr>
            <tr>
              <td class="left">Automatic cronjob installation
              </td>
              <td class="left">
                <input type="button"  value="Re-install" onclick="javascript: $('#mode').attr('value', 'reinstall'); $('#form').submit();" />
              </td>
            </tr>            
          <?php } elseif ($cronjob_install_status == 'cronjob_installed') { ?>
            <tr>
              <td class="left msg_installed" colspan="2"><b>INFO:</b> Cronjob is installed successfully.</td>
            </tr>
            <tr>
              <td class="left">Automatic cronjob installation
              </td>
              <td class="left">
                <input type="button"  value="Uninstall" onclick="javascript: $('#mode').attr('value', 'uninstall'); $('#form').submit();" />
              </td>
            </tr>
          <?php } ?>
          
          <tr>
            <td class="left" width="60%">Version          
            </td>
            <td class="left" width="40%">
              <?php echo $extension_version; ?>
            </td>
          </tr>
          
          <tr>
            <td class="left">'Run Scheduler' Key
            </td>
            <td class="left">
              <input type="text" name="ka_ts_run_scheduler_key" value="<?php echo $ka_ts_run_scheduler_key; ?>" />
              <?php if (!empty($error['ka_ts_run_scheduler_key'])) { ?>
                <span class="error"><?php echo $error['ka_ts_run_scheduler_key'];?></span>
              <?php } ?>
            </td>
          </tr>

          <tr>
            <td class="left">Stop Task After 'N' Minutes Activity
            </td>
            <td class="left">
              <input type="text" name="ka_ts_stop_task_after_n_minutes" value="<?php echo $ka_ts_stop_task_after_n_minutes; ?>" />
              <?php if (!empty($error['ka_ts_stop_task_after_n_minutes'])) { ?>
                <span class="error"><?php echo $error['ka_ts_stop_task_after_n_minutes'];?></span>
              <?php } ?>
            </td>
          </tr>

          <tr>
            <td class="left">Stop Task After 'N' Failures
            </td>
            <td class="left">
              <input type="text" name="ka_ts_stop_task_after_n_failures" value="<?php echo $ka_ts_stop_task_after_n_failures; ?>" />
              <?php if (!empty($error['ka_ts_stop_task_after_n_failures'])) { ?>
                <span class="error"><?php echo $error['ka_ts_stop_task_after_n_failures'];?></span>
              <?php } ?>
            </td>
          </tr>
          
          <tr>
            <td class="left">Treat Task As Dead If It Does Not Respond After N Minutes
            </td>
            <td class="left">
              <input type="text" name="ka_ts_task_is_dead_after_n_minutes" value="<?php echo $ka_ts_task_is_dead_after_n_minutes; ?>" />
              <?php if (!empty($error['ka_ts_task_is_dead_after_n_minutes'])) { ?>
                <span class="error"><?php echo $error['ka_ts_task_is_dead_after_n_minutes'];?></span>
              <?php } ?>
            </td>
          </tr>
                              
          <tr>
            <td class="left">Send E-mail to Administrator on Task Completion
            </td>
            <td class="left">
              <input type="checkbox" name="ka_ts_send_email_on_completion" value="Y" <?php if (isset($ka_ts_send_email_on_completion) && $ka_ts_send_email_on_completion == 'Y') { ?> checked="checked" <?php }; ?> />
            </td>
          </tr>

          <tr>
            <td class="left" colspan="2">
              <div class="attention">
              To make this module work you have to run the following script periodically 
              <br />
              <b><?php echo $run_scheduler; ?></b>
              <br />
              <h3>Option 1</h3>              
              Convenient way to implement it is to add script execution into 
              <a href="http://en.wikipedia.org/wiki/Cron" target="_new">cron jobs</a>              
              in your hosting control panel. The request can be processed by 
              <a href="http://en.wikipedia.org/wiki/Wget" target="_new">wget</a> console command.
              <br />
              The line in cron job list may look like this:
              <br />
              <b>/usr/bin/wget -O /dev/null "<?php echo $run_scheduler; ?>"</b>
              <br />
              'wget' application should be available at the specified path.
              
              <br /><br />
              Cron job execution period depends on your needs and hosting restrictions but 
              it is recommended to execute the script every 10-60 minutes.
              If no work required then no significant resources will be consumed.
              <br />
              <h3>Option 2</h3>
              Another way is to use an external service like "EasyCron" for calling a cron task.
              In case of using "EasyCron" you should consider purchasing a 'Starter' plan there 
              because cronjob execution may require up to 60 seconds timeout. <br />
              
              If you would like to proceed with installation of the task execution
              at 'EasyCron' service please click '<a target="_blank" href="http://www.easycron.com/clickschedule?ref=12676&url=<?php echo urlencode(html_entity_decode($run_scheduler)); ?>&specifiedBy=2&specifiedValue=*/10%20*%20*%20*%20*">install EasyCron</a>'. 
              Keep in mind that we are not responsible for communcation with this service 
              because it is run by an independent company.
              </div>
            </td>
          </tr>

        </tbody>
      </table>
    </form>
  </div>
</div>

<script type="text/javascript"><!--

//--></script>

<?php echo $footer; ?>
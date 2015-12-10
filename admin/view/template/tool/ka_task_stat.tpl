<?php
/*
  Project: Task Scheduler
  Author : karapuz <support@ka-station.com>

  Version: 1 ($Revision: 20 $)

*/
?>
<?php echo $header; ?>
<div id="content">

  <?php echo $ka_top; ?>
  
  <div class="box">

    <div class="heading">
      <h1><img src="view/image/order.png" alt="" /> Task Statistics</h1>
      <div class="buttons">
        <a onclick="location = '<?php echo $cancel; ?>';" class="button"><span><?php echo $this->language->get('Back'); ?></span></a>
      </div>
    </div>
    
    <div class="content">
      <form action="" method="post" enctype="multipart/form-data" id="form">

        <?php if (!empty($task['task_id'])) { ?>
          <input type="hidden" name="task_id" value="<?php echo $task['task_id']; ?>" />
        <?php } ?>

        <table class="form">
        
          <tr>
            <td>Name</td>
            <td>
              <?php echo $task['name']; ?>
            </td>
          </tr>

          <?php if (!empty($task['stat'])) { ?>
            <?php foreach ($task['stat'] as $name => $stat) { ?>
        <tr>
        <td><?php echo $name; ?></td>
        <td>
          <?php echo $stat; ?>
        </td>
        </tr>
      <?php } ?>
          <?php } ?>                    
        </table>
      </form>
    </div>
  </div>
</div>

<?php echo $footer; ?>
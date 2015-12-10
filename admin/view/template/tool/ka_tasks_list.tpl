<?php
/*
  Project: Task Scheduler
  Author : karapuz <support@ka-station.com>

  Version: 1 ($Revision: 36 $)

*/
?>
<?php echo $header; ?>
<div id="content">

  <?php echo $ka_top; ?>

  <div class="box">
    <div class="heading">
      <h1><img src="view/image/order.png" alt="" />Tasks</h1>
      
      <?php if (empty($is_lite)) { ?>
        <div class="buttons">
          <a onclick="location = '<?php echo $insert; ?>'" class="button"><span>Insert</span></a>
          <a onclick="javascript: $('form').attr('action', '<?php echo $update_list; ?>').submit();" class="button"><span>Update</span></a>
          <a onclick="$('form').submit();" class="button"><span>Delete</span></a>        
        </div>
      <?php } ?>
    </div>
    
    <div class="content">

      <table>
        <tr>
          <td>Last Scheduler Start:</td>
          <td><?php echo $last_scheduler_run; ?></td>
        </tr>
        <tr>
          <td>Manual Start:</td>
          <td><a href="<?php echo $run_scheduler;?>" target="_blank">Go</a></td>
        </tr>
      </table>
      <br />

      <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form">
        <table class="list">
        
          <thead>
            <tr>
              <td width="1" style="text-align: center;"><input type="checkbox" onclick="$('input[name*=\'selected\']').attr('checked', this.checked);" /></td>
              <td class="left" width="40%">
                <?php if ($params['sort'] == 'ct.name') { ?>
                  <a href="<?php echo $sort_name; ?>" class="<?php echo strtolower($params['order']); ?>">Name</a>
                <?php } else { ?>
                  <a href="<?php echo $sort_name; ?>">Name</a>
                <?php } ?></td>
                
              <td class="left">
                Last Start
              </td>
              <td class="left">
                Status
              </td>
              <td class="left">
                Completions
              </td>
              <td class="left">
                Active
              </td>              
              <td class="right">
                <?php if ($params['sort'] == 'ct.priority') { ?>
                  <a href="<?php echo $sort_priority; ?>" class="<?php echo strtolower($params['order']); ?>">Priority</a>
                <?php } else { ?>
                  <a href="<?php echo $sort_priority; ?>">Priority</a>
                <?php } ?></td>
              <td class="right">Action</td>
            </tr>
          </thead>
          
          <tbody>
            <?php if (!empty($tasks)) { ?>
            <?php foreach ($tasks as $t) { ?>
            <tr>
              <td style="text-align: center;"><?php if ($t['selected']) { ?>
                <input type="checkbox" name="selected[]" value="<?php echo $t['task_id']; ?>" checked="checked" />
                <?php } else { ?>
                <input type="checkbox" name="selected[]" value="<?php echo $t['task_id']; ?>" />
                <?php } ?></td>
              <td class="left"><?php echo $t['name']; ?></td>
              
              <td class="left">
                <a href="<?php echo $t['stat_link'];?>"><?php echo $t['last_start']; ?></a>
              </td>              
              <td class="left">
          <?php $this->showTemplate('ka_extensions/select.tpl', 
          array(
              'value' => $t['status'], 
              'options' => $statuses)
          );
          ?>
              </td>
              <td class="left">
                <?php echo $t['complete_count']; ?>
              </td>
              <td class="left">
                <?php if (empty($is_lite)) { ?>
                  <input type="checkbox" name="tasks[<?php echo $t['task_id']; ?>][active]" value="Y" <?php if ($t['active'] == 'Y') { ?> checked="checked" <?php } ?> />
                <?php } else { ?>
                  <?php if ($t['active'] == 'Y') { ?>yes<?php } else { ?>no<?php } ?>
                <?php } ?>
              </td>

              <td class="right">
                <?php if (empty($is_lite)) { ?>
                  <input type="text" size="6" name="tasks[<?php echo $t['task_id']; ?>][priority]" value="<?php echo $t['priority']; ?>" />
                <?php } else { ?>
                  <?php echo $t['priority']; ?>
                <?php } ?>
              </td>
              <td class="right">
                <?php foreach ($t['action'] as $action) { ?>
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
      </form>
      <div class="pagination"><?php echo $pagination; ?></div>
    </div>
    
  </div>
</div>
<?php echo $footer; ?>
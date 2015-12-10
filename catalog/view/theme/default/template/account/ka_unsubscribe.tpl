<?php
/*
  Project: Abanodned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 48 $)

*/
?>
<?php echo $header; ?>

<?php echo $column_left; ?><?php echo $column_right; ?>
<div id="content"><?php echo $content_top; ?>
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
    <h1><?php echo $this->language->get('Cart Reminder Notifications'); ?></h1>
  
  <?php if ($status == 'ok') { ?>
    <h2><?php echo $this->language->get('You Have Unsubscribed Successfully'); ?></h2>
    
  <?php } elseif ($status == 'not_subscribed') { ?>
    <h2><?php echo $this->language->get('You are not subscribed for these notifications.'); ?></h2>
    
  <?php } elseif ($status == 'not_found') { ?>
    <h2><?php echo $this->language->get('No record found.'); ?></h2>
  <?php } ?>
  
  <?php echo $content_bottom; ?></div>
<?php echo $footer; ?> 
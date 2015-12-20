<?php echo $header; ?>
<!-- Start Page Banner -->
<div class="page-banner no-subtitle">
<div class="container">
<div class="row">
<div class="col-md-6">
    <h2><?php echo $heading_title; ?></h2>
</div>
<div class="col-md-6" style="text-align: right;">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>                                            
</div>
</div>
</div>
</div>
		<!-- End Page Banner -->


<?php if ($success) { ?>
<div class="success container"><?php echo $success; ?></div>
<?php } ?>
<?php if ($error_warning) { ?>
<div class="warning container"><?php echo $error_warning; ?></div>
<?php } ?>



<div id="content">
    <div class="container">
        <?php echo $content_top; ?>
        <?php echo $column_left; ?>
		<?php echo $column_right; ?>        
        
          <?php foreach ($addresses as $result) { ?>
          
          <div class="content col-lg-8">
            <table style="width: 100%; border-bottom:1px #ccc solid; margin-bottom:20px;">
              <tr>
                <td style="padding:5px 0"><?php echo $result['address']; ?></td>
                <td style="text-align: right;"><a href="<?php echo $result['update']; ?>" class="button"><?php echo $button_edit; ?></a> &nbsp; <a href="<?php echo $result['delete']; ?>" class="button"><?php echo $button_delete; ?></a></td>
              </tr>
            </table>
          </div>
          <?php } ?>
          
         
 
 
          <div class="buttons">
            <div class=""><a href="<?php echo $back; ?>" class="button"><?php echo $button_back; ?></a></div>
            <div class=""><a href="<?php echo $insert; ?>" class="button"><?php echo $button_new_address; ?></a></div>
          </div>
          <?php echo $content_bottom; ?>
    </div>  
</div>
<?php echo $footer; ?>
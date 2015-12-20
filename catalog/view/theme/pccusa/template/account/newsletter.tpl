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
        
<div id="content">
 <div class="container">
<?php echo $content_top; ?>
<?php echo $column_left; ?>
<?php echo $column_right; ?>
 <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data">
    <div class="content">
      <table class="form">
        <tr>
          <td><?php echo $entry_newsletter; ?></td>
          <td><?php if ($newsletter) { ?>
            <input type="radio" name="newsletter" value="1" checked="checked" />
            <?php echo $text_yes; ?>&nbsp;
            <input type="radio" name="newsletter" value="0" />
            <?php echo $text_no; ?>
            <?php } else { ?>
            <input type="radio" name="newsletter" value="1" />
            <?php echo $text_yes; ?>&nbsp;
            <input type="radio" name="newsletter" value="0" checked="checked" />
            <?php echo $text_no; ?>
            <?php } ?></td>
        </tr>
      </table>
    </div>
    <div class="buttons">
      <div class="left"><a href="<?php echo $back; ?>" class="button"><?php echo $button_back; ?></a></div>
      <div class="right"><input type="submit" value="<?php echo $button_continue; ?>" class="button" /></div>
    </div>
  </form>
  <?php echo $content_bottom; ?>
  </div>
</div>  
<?php echo $footer; ?>
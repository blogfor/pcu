<?php echo $header; ?>
<?php //echo $column_left; ?>
<?php //echo $column_right; ?>

    <!-- PAGE HEADER TITLE  -->
<div class="page-banner no-subtitle">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                 <h2><?php echo $heading_title; ?></h2>
            </div>
            <div class="col-md-6 bredcamp">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
            <?php } ?>
            </div>
        </div>
    </div>
</div>
    <!-- End PAGE HEADER TITLE -->
    

<div id="content" class="container">
<?php //echo $content_top; ?>

  <div class="content"><?php echo $text_error; ?></div>
  <div class="buttons">
    <div class="right"><a href="<?php echo $continue; ?>" class="button"><?php echo $button_continue; ?></a></div>
  </div>
  <?php echo $content_bottom; ?></div>
<?php echo $footer; ?>
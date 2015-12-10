<style type="text/css">
.nivo-controlNav { margin-right:<?php echo -25-count($banners)*10; ?>px }
</style>

<div class="slideshow" >
  <div id="slideshow<?php echo $module; ?>" class="nivoSlider" >
    <?php foreach ($banners as $banner) { ?>
    <?php if ($banner['link']) { ?>
    <a href="<?php echo $banner['link']; ?>">
        <img src="<?php echo $banner['image']; ?>" alt="<?php echo $banner['title']; ?>"  /></a>
    <?php } else { ?>
    <img src="<?php echo $banner['image']; ?>" alt="<?php echo $banner['title']; ?>" />
    <?php } ?>
    <?php } ?>
   
  </div>
  <div class="shadow-slideshow"></div>
</div>
<!-- style="width: <?php echo $width; ?>px; height: <?php echo $height; ?>px;" -->

<style>
    .nivoSlider{
        width:100% !important;
        height: 380px !important;
        display: block;
    }
</style>
    

<script type="text/javascript">
/*var w=$(window).innerWidth()-40;      
if(w<600){
$('.slideshow').css({ "width": w });
$('.slideshow .nivoSlider').css({ "width": w });
}*/
            
            <!--
$(document).ready(function() {
	$('#slideshow<?php echo $module; ?>').nivoSlider();
});
-->
</script>
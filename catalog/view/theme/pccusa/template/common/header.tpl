<!DOCTYPE html>
<html dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>">
<head>
<meta charset="UTF-8" />
<title><?php echo $title; ?></title>
<base href="<?php echo $base; ?>" />
<?php if ($description) { ?>
<meta name="description" content="<?php echo $description; ?>" />
<?php } ?>
<?php if ($keywords) { ?>
<meta name="keywords" content="<?php echo $keywords; ?>" />
<?php } ?>
<?php if ($icon) { ?>
<link href="<?php echo $icon; ?>" rel="icon" />
<?php } ?>
<?php foreach ($links as $link) { ?>
<link href="<?php echo $link['href']; ?>" rel="<?php echo $link['rel']; ?>" />
<?php } ?>
<link rel="stylesheet" type="text/css" href="catalog/view/theme/pccusa/stylesheet/stylesheet.css" />
<?php foreach ($styles as $style) { ?>
<link rel="<?php echo $style['rel']; ?>" type="text/css" href="<?php echo $style['href']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>


<!-- Bootstrap CSS  -->
<link rel="stylesheet" href="catalog/view/theme/pccusa/asset/css/bootstrap.css" type="text/css" media="screen">
<link rel="stylesheet" href="catalog/view/theme/pccusa/css/font-awesome.css" type="text/css" media="screen">
<link rel="stylesheet" href="catalog/view/theme/pccusa/fonts/stylesheet.css" type="text/css" media="screen">

<link rel="stylesheet" type="text/css" href="catalog/view/theme/pccusa/css/animate.css" media="screen">
<link rel="stylesheet" type="text/css" href="catalog/view/theme/pccusa/css/red.css" title="red" media="screen" />
<link rel="stylesheet" type="text/css" href="catalog/view/theme/pccusa/css/style.css" media="screen">
<link rel="stylesheet" type="text/css" href="catalog/view/theme/pccusa/css/responsive.css" media="screen">
<link rel="stylesheet" type="text/css" href="catalog/view/theme/pccusa/css/custom.css" media="screen">
<link href="catalog/view/theme/pccusa/css/owl.carousel.css" rel='stylesheet' type='text/css'>



<script type="text/javascript" src="catalog/view/javascript/jquery/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/jquery-ui-1.8.16.custom.min.js"></script>
<link rel="stylesheet" type="text/css" href="catalog/view/javascript/jquery/ui/themes/ui-lightness/jquery-ui-1.8.16.custom.css" />
<script type="text/javascript" src="catalog/view/javascript/common.js"></script>
<?php foreach ($scripts as $script) { ?>
<script type="text/javascript" src="<?php echo $script; ?>"></script>



<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.migrate.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/modernizrr.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/asset/js/bootstrap.min.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.fitvids.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/owl.carousel.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/nivo-lightbox.min.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.isotope.min.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.appear.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/count-to.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.textillate.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.lettering.js"></script>

<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.nicescroll.min.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/jquery.parallax.js"></script>
<script type="text/javascript" src="catalog/view/theme/pccusa/js/script.js"></script>

<?php } ?>
<!--[if IE 7]> 
<link rel="stylesheet" type="text/css" href="catalog/view/theme/default/stylesheet/ie7.css" />
<![endif]-->
<!--[if lt IE 7]>
<link rel="stylesheet" type="text/css" href="catalog/view/theme/default/stylesheet/ie6.css" />
<script type="text/javascript" src="catalog/view/javascript/DD_belatedPNG_0.0.8a-min.js"></script>
<script type="text/javascript">
DD_belatedPNG.fix('#logo img');
</script>
<![endif]-->

<?php if ($stores) { ?>
<script type="text/javascript">
$(document).ready(function() {
<?php foreach ($stores as $store) { ?>
$('body').prepend('<iframe src="<?php echo $store; ?>" style="display: none;"></iframe>');
<?php } ?>
});
</script>
<?php } ?>
<?php echo $google_analytics; ?>


<!--[if IE 8]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
<!--[if lt IE 9]><script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->

<!--CustomScrollbar-->
<link rel="stylesheet" href="catalog/view/theme/pccusa/css/jquery.mCustomScrollbar.css">
<script src="catalog/view/theme/pccusa/js/jquery.mCustomScrollbar.concat.min.js" type="text/javascript"></script>
<script>
	jQuery(function($){
		$(window).load(function(){
			$("#brand .panel-body").mCustomScrollbar({
				setHeight:200,
				theme:"dark-3"
			});			
			$("#accordion .panel-body").mCustomScrollbar({
				setHeight:250,
				theme:"dark-3"
			});			
			 jQuery('#accordion .panel-heading a[data-toggle="collapse"]').on('click', function () {   
				jQuery('#accordion .panel-heading a[data-toggle="collapse"]').removeClass('actives');
				$(this).addClass('collapse');
				jQuery('#accordion .panel-heading a[data-toggle="collapse"]').addClass('actives');
				$(this).removeClass('collapse');
			 });			 
		});
	});
</script>
</head>


<body>

<!-- Container -->
<div id="container"> 
  
  <!-- Start Header -->
  <div class="hidden-header"></div>
  <header class="clearfix"> 
    
    <!-- Start Top Bar -->
    <div class="top-bar dark-bar">
      <div class="container">
        <div class="row">
          <div class="col-md-5"> 
            <ul class="contact-details">
              <li> 
              <?php if (!$logged) { ?>
                    <?php echo $text_welcome; ?>
                    <?php } else { ?>
                    <?php echo $text_logged; ?>
                    <?php } ?>
              </li>
            </ul>
          </div>
          <div class="col-md-7"> 
            <ul class="topbar-right">
              <li> <a class="" data-placement="bottom" title="" href="<?php echo $home; ?>"><?php echo $text_home; ?></a> </li>
              <li> <a class="" data-placement="bottom" title="" href="<?php echo $wishlist; ?>" id="wishlist-total"><?php echo $text_wishlist; ?></a> </li>
              <li> <a class="" data-placement="bottom" title="" href="<?php echo $account; ?>"><?php echo $text_account; ?></a> </li>
              <li> <a class="" data-placement="bottom" title="" href="<?php echo $shopping_cart; ?>"><?php echo $text_shopping_cart; ?></a> </li>
              <li> <a class="" data-placement="bottom" title="" href="<?php echo $checkout; ?>"><?php echo $text_checkout; ?></a> </li>
              <li> <a class="" data-placement="bottom" title="" href="#">Contact Us</a> </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    <!-- End Top Bar --> 
    
    <!-- Start Header -->
    <div class="navbar navbar-default navbar-top">
      <div class="container">
        <div class="navbar-header clearfix"> 
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse"> <i class="fa fa-bars"></i> </button>
          <div class="navbar-brandlogo">
          <a class="navbar-brand navbar-brandlogo" href="<?php echo $home; ?>">
          <img alt="PC Chandra" src="catalog/view/theme/pccusa/images/logo.png"></a> 
          </div>
        </div>
      </div>
      
      <div class="container">
      <div class="row">


          <div class="navbar-collapse collapse"> 
          
            <?php if ($categories) { ?>
            
              <ul  class="nav navbar-nav">
                <?php foreach ($categories as $category) { ?>
                <li><a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
                  <?php if ($category['children']) { ?>

                    <?php for ($i = 0; $i < count($category['children']);) { ?>
                    <ul class="dropdown">
                      <?php $j = $i + ceil(count($category['children']) / $category['column']); ?>
                      <?php for (; $i < $j; $i++) { ?>
                      <?php if (isset($category['children'][$i])) { ?>
                          <li>
                              <a href="<?php echo $category['children'][$i]['href']; ?>">
                              <?php echo $category['children'][$i]['name']; ?></a>
                          </li>
                      <?php } ?>
                      <?php } ?>
                    </ul>
                    <?php } ?>
                  
                  <?php } ?>
                </li>
                <?php } ?>
              </ul>
          
		<?php } ?>
                <!-- Search Widget -->
                <div class="widget widget-search  navbar-right">
                <form action="#">
                    <input type="search" placeholder="Enter Keywords..." />
                    <button class="search-btn" type="submit"><i class="fa fa-search"></i></button>
                </form>
                 
                </div>
                
               
  
          </div>
      </div>
      </div>
      
    </div>
    <!-- End Header --> 
    
  </header>
  <!-- End Header --> 
  
    <?php if ($error) { ?>    
    <div class="warning">
    <?php echo $error ?><img src="catalog/view/theme/default/image/close.png" alt="" class="close" />
    </div>
    
    <?php } ?>
    <div id="notification"></div>
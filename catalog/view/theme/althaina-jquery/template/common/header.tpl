<?php if (isset($_SERVER['HTTP_USER_AGENT']) && !strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE 6')) echo '<?xml version="1.0" encoding="UTF-8"?>'. "\n"; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="<?php echo $direction; ?>" lang="<?php echo $lang; ?>" xml:lang="<?php echo $lang; ?>"><head>
<title><?php echo $title; ?></title>

<meta name="robots" content="noindex, nofollow">
<meta name="googlebot" content="noindex"/>
<meta name="googlebot-news" content="nosnippet"/>
        


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
<meta name="HandheldFriendly" content="True" /><meta name="MobileOptimized" content="320" />	
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1" />    
<link rel="stylesheet" type="text/css" href="catalog/view/theme/althaina/stylesheet/stylesheet.css" />
<link rel="stylesheet" type="text/css" href="catalog/view/theme/althaina/stylesheet/facebook.css" />
<?php foreach ($styles as $style) { ?>
<link rel="<?php echo $style['rel']; ?>" type="text/css" href="<?php echo $style['href']; ?>" media="<?php echo $style['media']; ?>" />
<?php } ?>
<script type="text/javascript" src="catalog/view/javascript/jquery/jquery-1.9.1.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/jquery-ui-1.8.16.custom.min.js"></script>
<link rel="stylesheet" type="text/css" href="catalog/view/javascript/jquery/ui/themes/ui-lightness/jquery-ui-1.8.16.custom.css" />
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/external/jquery.cookie.js"></script>
<script type="text/javascript" src="catalog/view/javascript/jquery/colorbox/jquery.colorbox.js"></script>
<link rel="stylesheet" type="text/css" href="catalog/view/javascript/jquery/colorbox/colorbox.css" media="screen" />
<script type="text/javascript" src="catalog/view/javascript/jquery/tabs.js"></script>
<script type="text/javascript" src="catalog/view/javascript/common.js"></script>
<?php foreach ($scripts as $script) { ?>
<script type="text/javascript" src="<?php echo $script; ?>"></script>
<?php } ?>

 <script type="text/javascript" src="catalog/view/javascript/jquery/jquery.jcarousel.min.js"></script>
 <link rel="stylesheet" type="text/css" href="catalog/view/theme/althaina/stylesheet/carousel.css" media="screen">
 <link rel="stylesheet" type="text/css" href="catalog/view/theme/althaina/stylesheet/bx_styles.css" />
<script src="catalog/view/theme/althaina/js/jquery.bxSlider.min.js" type="text/javascript"> </script>

<!-- RESPONSIVE CHANGES -->
<script src="catalog/view/theme/althaina/js/bootstrap.js" type="text/javascript"></script>
<script src="catalog/view/theme/althaina/js/bootstrap.min.js" type="text/javascript"> </script>
<link rel="stylesheet" type="text/css" href="catalog/view/theme/althaina/stylesheet/bootstrap.css" />

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
<?php echo $google_analytics; ?>
</head>
<body>
<!-- Main Wrapper -->
<div class="main-wrapper"  >
<!-- Main Header -->
<div class="main-header">
<!-- TOP HEADER -->
    <div class="top-header">
        <div class="top-header-inner container">
            <div class="row">
            <div id="welcome"  class="col-md-4">
                <?php if (!$logged) { ?>
                <?php echo $text_welcome; ?>
                <?php } else { ?>
                <?php echo $text_logged; ?>
                <?php } ?>
            </div>
            
               <?php echo $currency; ?>
               <?php echo $language; ?>
              <?php echo $cart; ?>
            </div>  
            
            <div class="clear"></div>
        </div>
    </div>



<nav class="navbar navbar-inverse" role="navigation" style="">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
            
            <?php if ($logo) { ?>
                <a class="navbar-brand" href="<?php echo $home; ?>"><img src="<?php echo $logo; ?>" title="<?php echo $name; ?>" alt="<?php echo $name; ?>" /></a>
            <?php } ?>
         
        </div>

        <div class="collapse navbar-collapse navbar-ex1-collapse">
          <ul class="nav navbar-nav navbar-right">
            <li><a class="home" href="<?php echo $home; ?>">Home</a></li>
            <li><a href="<?php echo $wishlist; ?>" id="wishlist-total"><?php echo $text_wishlist; ?></a></li>
            <li><a href="<?php echo $account; ?>"><?php echo $text_account; ?></a></li>
            <li><a href="<?php echo $shopping_cart; ?>"><?php echo $text_shopping_cart; ?></a></li>
            <li><a class="checkout-link" href="<?php echo $checkout; ?>"><?php echo $text_checkout; ?></a></li>
            <li><a href="<?php echo $this->url->link('information/contact'); ?>"><?php echo $this->language->get('text_contact'); ?></a></li>
          </ul>
        </div><!-- /.navbar-collapse -->
      </div><!-- /.container -->
</nav>



<!-- BOTTOM HEADER -->
	<!-- <div  class="bottom-header">
		<div class="bottom-header-inner" id="header">
 			 <?php if ($logo) { ?>
 			 <div id="logo"><a href="<?php echo $home; ?>"><img src="<?php echo $logo; ?>" title="<?php echo $name; ?>" alt="<?php echo $name; ?>" /></a></div>
  			 <?php } ?>
  
			 <div class="links">
 <a class="home" href="<?php echo $home; ?>"></a>
 <a href="<?php echo $wishlist; ?>" id="wishlist-total"><?php echo $text_wishlist; ?></a>
 <a href="<?php echo $account; ?>"><?php echo $text_account; ?></a>
 <a href="<?php echo $shopping_cart; ?>"><?php echo $text_shopping_cart; ?></a>
 <a  class="checkout-link" href="<?php echo $checkout; ?>"><?php echo $text_checkout; ?></a>
 <a href="<?php echo $this->url->link('information/contact'); ?>"> <?php echo $this->language->get('text_contact'); ?></a>
 </div>
  
<div id="search">
    <div class="button-search"></div>
    <input type="text" name="search" placeholder="<?php echo $text_search; ?>" value="<?php echo $search; ?>" />
</div>
	</div>
    
  <div class="clear"></div>
  
  
</div> --> <!-- END BOTTOM HEADER -->


<?php if ($categories) { ?>
	<div class="menu-main">
        <div id="menu" class="container">
          <ul>
            <?php foreach ($categories as $category) { ?>
            <li><a href="<?php echo $category['href']; ?>"><?php echo $category['name']; ?></a>
              <?php if ($category['children']) { ?>
              <div class="ab">
                <?php for ($i = 0; $i < count($category['children']);) { ?>
                <ul >
                  <?php $j = $i + ceil(count($category['children']) / $category['column']); ?>
                  <?php for (; $i < $j; $i++) { ?>
                  <?php if (isset($category['children'][$i])) { ?>
                  <li><a href="<?php echo $category['children'][$i]['href']; ?>"><?php echo $category['children'][$i]['name']; ?></a></li>
                  <?php } ?>
                  <?php } ?>
                </ul>
                <?php } ?>
              </div>
              <?php } ?>
            </li>
            <?php } ?>
            <li style=" border-right:none; background:none !important"><a></a></li>
          </ul>
            
        <div class="col-md-2 pull-right">
        <div id="search" class="">
          <div class="button-search"></div>
          <input type="text" name="search" placeholder="<?php echo $text_search; ?>" value="<?php echo $search; ?>" />
        </div>
        </div>  
            
            
        </div>
        <div class="shadow-menu"></div>
	</div>
<?php } ?>
</div><!--End Main Header -->

<!--  Wrapper -->
<div class="wrapper container">
	<div id="notification"></div>
	<div id="container">


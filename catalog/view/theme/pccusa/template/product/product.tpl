<?php echo $header; ?>

    <!-- PAGE HEADER TITLE  -->
<div class="page-banner no-subtitle">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                 <h2>Product Details</h2>
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
    
    

    <!--body-cont-->
    <div id="content" >
      <div class="container">
        <div class="row"> 
          <!--panel---------------------------------->
          <div class="col-lg-12 col-md-12 col-sm-12 padd0"> 

            <!--zoom-img-->
            <div class="row  marTop2">
                <!--left---------zoom-->
                <div class="col-lg-5 col-md-5 col-sm-5">
                  <?php if ($thumb || $images) { ?>
                  <div class="">
                    <?php if ($thumb) { ?>
                    <div class="image"><a href="<?php echo $popup; ?>" title="<?php echo $heading_title; ?>" class="colorbox"><img src="<?php echo $thumb; ?>" title="<?php echo $heading_title; ?>" alt="<?php echo $heading_title; ?>" class="picZoomer-pic" id="image" /></a></div>
                    <?php } ?>
                    
                    <?php if ($images) { ?>
                    <div class="image-additional">
                      <?php foreach ($images as $image) { ?>
                      <a href="<?php echo $image['popup']; ?>" title="<?php echo $heading_title; ?>" class="colorbox"><img src="<?php echo $image['thumb']; ?>" title="<?php echo $heading_title; ?>" alt="<?php echo $heading_title; ?>" /></a>
                      <?php } ?>
                    </div>
                    <?php } ?>
                  </div>
                  <?php } ?>
                </div>
            

                <!--right-->
                <div class="col-lg-7 col-md-7 col-sm-7 product-details">
                    <h3><?php echo $heading_title; ?> <!-- <small>(Ring)</small> --></h3>

                    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
                    <div class="row">
                    <div class="col-lg-4 col-md-12">
                        <?php if ($manufacturer) { ?>
                        <span class="manufacturer-box"><?php echo $text_manufacturer; ?></span> <a href="<?php echo $manufacturers; ?>"><strong><?php echo $manufacturer; ?></strong></a><br />
                        <?php } ?>
                        <span class="model-box"><?php echo $text_model; ?></span><strong> <?php echo $model; ?></strong><br />
                        <?php if ($reward) { ?>
                        <span class="reward-box"><?php echo $text_reward; ?></span> <strong><?php echo $reward; ?></strong><br />
                        <?php } ?>
                        <span><?php echo $text_stock; ?></span> <?php echo $stock; ?>     
                    </div>
                    
                     <div class="col-lg-8 col-md-12">
                        <div class="col-md-12 row rating-review-box">
                        <div><img src="catalog/view/theme/default/image/stars-<?php echo $rating; ?>.png" alt="<?php echo $reviews; ?>" />&nbsp;&nbsp;<a onclick="$('a[href=\'#tab-review\']').trigger('click');"><?php echo $reviews; ?></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a onclick="$('a[href=\'#tab-review\']').trigger('click');"><?php echo $text_write; ?></a></div>
                        </div>
                        <div class="col-md-12 row sharethis-box">
                            <div class="share"><!-- AddThis Button BEGIN -->
                            <div class="addthis_default_style"><a class="addthis_button_compact"><?php echo $text_share; ?></a> <a class="addthis_button_email"></a><a class="addthis_button_print"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_twitter"></a></div>
                            <script type="text/javascript" src="//s7.addthis.com/js/250/addthis_widget.js"></script> 
                            <!-- AddThis Button END --> 
                            </div>
                        </div>
                     </div>
                        
                    </div>
                    
                    
                    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
                    <div class="row"> 
                    <div class="col-lg-4 col-md-12">
                     	<?php if ($price) { ?>
                          <div class="price">
                          <?php echo $text_price; ?>
                            <?php if (!$special) { ?>
                            <?php echo $price; ?>
                            <?php } else { ?>
                            <span class="price-old">
                            <?php echo $price; ?></span> 
                            <span class="price-new"><?php echo $special; ?>
                            </span>
                            <?php } ?>
                            
                            <?php if ($tax) { ?>
                            <span class="price-tax">
                            <?php echo $text_tax; ?> <?php echo $tax; ?></span>
                            <?php } ?>
                            
                            <?php if ($points) { ?>
                            <span class="reward">
                            <small><?php echo $text_points; ?> <?php echo $points; ?></small>
                            </span>
                            <?php } ?>
                            
                            <?php if ($discounts) { ?>                            
                            <div class="discount">
                              <?php foreach ($discounts as $discount) { ?>
                              <?php echo sprintf($text_discount, $discount['quantity'], $discount['price']); ?>                              <?php } ?>
                              
                            </div>
                            <?php } ?>
                          </div>
      					<?php } ?>
      
                    
                     <div class="product-info">
                        <div class="cart">
                        <div><?php echo $text_qty; ?>
                          <input type="text" name="quantity" size="2" value="<?php echo $minimum; ?>" class="numberonly"/>
                          <input type="hidden" name="product_id" size="2" value="<?php echo $product_id; ?>" />
                          &nbsp;
                          <input type="button" value="<?php echo $button_cart; ?>" id="button-cart" class="button" />                         
                         
                        </div>
                        <?php if ($minimum > 1) { ?>
                        <div class="minimum"><?php echo $text_minimum; ?></div>
                        <?php } ?>
                      </div>
                      </div>
                     
                      
            
      
                    </div>
                    <div class="col-lg-8 col-md-12 row">
                    	<div class="col-md-12 compair-box">
                        <span>
                        <a onclick="addToCompare('<?php echo $product_id; ?>');">
                        <img src="catalog/view/theme/pccusa/images/add-fileb.png" alt="">
                        <?php echo $button_compare; ?>
                        </a>
                        </span>
                        </div>
                        
                        <div class="col-md-12  wishlist-box">
                        <span>
                        <a onclick="addToWishList('<?php echo $product_id; ?>');">
                        <img src="catalog/view/theme/pccusa/images/ico-gbox.png" alt="">
                        <?php echo $button_wishlist; ?>
                        </a>
                        </span>
                        </div>      
                    </div>                      
                                    
                    </div>
                    
                    <div class="" style="margin-top:30px; margin-bottom:10px; clear:both;"><!-- Divider --></div>                   
                    <!---PRODUCT DETAILS CONTENT -------------------------------------->  
                         
                    <?php if ($attribute_groups) { ?>
                    <div id="tab-attribute" class="tab-pane fade in active">
                      <div class="table-responsive">
                        <table class="attribute table table-bordered table-striped" style="width: 100%;" >
                          <?php foreach ($attribute_groups as $attribute_group) { ?>
                          <thead>
                            <tr>
                              <td colspan="2" class="attribute_header"><?php echo $attribute_group['name']; ?></td>
                            </tr>
                          </thead>
                          <tbody>
                            <?php foreach ($attribute_group['attribute'] as $attribute) { ?>
                            <tr>
                              <td width="40%"><?php echo $attribute['name']; ?></td>
                              <td style="text-align:left; padding-left:20px;"><?php echo $attribute['text']; ?></td>
                            </tr>
                            <?php } ?>
                          </tbody>
                          <?php } ?>
                        </table>
                      </div>
                    </div>
                    <?php } ?>
                    
                    <!--END PRODUCT DETAILS-->    
                        <?php if ($tags) { ?>
                        <div class="tags">
                        <b><?php echo $text_tags; ?></b>
                          <?php for ($i = 0; $i < count($tags); $i++) { ?>
                          <?php if ($i < (count($tags) - 1)) { ?>
                          <a href="<?php echo $tags[$i]['href']; ?>"><?php echo $tags[$i]['tag']; ?></a>,
                          <?php } else { ?>
                          <a href="<?php echo $tags[$i]['href']; ?>"><?php echo $tags[$i]['tag']; ?></a>
                          <?php } ?>
                          <?php } ?>
                        </div>
                        <?php } ?>           
            		<!---TAB CONTENT END ---------------------------------->            
                    <div class="">
                        <strong>Warranty:</strong> 1 year manufacturer warranty for any damage
                    </div>
                  
            </div><!--row-->
            <!--zoom-img-end--> 

            </div><!--panel-->


        </div>
      </div>
    </div>
    <!--body-cont-end-->
    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
    
    <?php echo $content_bottom; ?>  
    <!--Comments Sections-->
    <!-- <div id="content" >
          <div class="container">            
            <div class="row  marTop2">
            <div class="col-lg-12 col-md-12 col-sm-12">
            
                    <div class="blogHeader" id="reviews">
                        <h4 class="pull-left">Reviews of Samsung Galaxy Grand Max (Marble White, 16GB)</h4>
                        <div class="text-right pull-right">Showing Reviews: 1-5 of 10</div>
                    </div>
                    
                    
                    <div class="well2">
                    <div>Have you used this product? Rate it NOW 
                    <span class="padd8"><a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a></span></div>
                    <h4><img src="images/productsDtls/edit.png" alt=""> Leave a Comment:</h4>
                        <form role="form">
                        <a class="pull-left paddright2" href="#"> <img class="media-object" src="images/productsDtls/thumbs.png" alt=""></a>
                  <div class="media-body">
                                <div class="form-group"> <textarea class="form-control inptexare" rows="3"></textarea></div>
                                <button type="submit" class="btn btn-primary">Submit</button>
                            </div>
                        </form>
                    </div>
    
                    <hr>
    
                   
                    
                    <div class="media well3">
                        <a class="pull-left" href="#">
                            <img class="media-object" src="images/productsDtls/thumbs.png" alt="">
                        </a>
                        <div class="media-body">
                            <h4 class="media-heading">John Doe <small>2 June, 2015M</small><span class="padd8"><a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a></span> </h4>
                            <div class="media-bodyin">Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</div>
                            <h4 class="media-heading"><small>Was this review helpful?<span class="padd8"><img src="images/up.png" alt=""> Yes</span> <span class="padd8"><img src="images/dwn.png" alt=""> No</span></small></h4>
                            
                        </div>
                    </div>
                    
                   
                    <div class="media well3">
                        <a class="pull-left" href="#">
                            <img class="media-object" src="images/productsDtls/thumbs.png" alt="">
                        </a>
                        <div class="media-body">
                            <h4 class="media-heading">John Doe <small>2 June, 2015M</small><span class="padd8">
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a></span> </h4>
                            <div class="media-bodyin">Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</div>
                            <h4 class="media-heading"><small>Was this review helpful?<span class="padd8"><img src="images/up.png" alt=""> Yes</span> <span class="padd8"><img src="images/dwn.png" alt=""> No</span></small></h4>
                            
                        </div>
                    </div>
                    
                    
                    <div class="media well3">
                        <a class="pull-left" href="#">
                            <img class="media-object" src="images/productsDtls/thumbs.png" alt="">
                        </a>
                        <div class="media-body">
                            <h4 class="media-heading">John Doe <small>2 June, 2015M</small><span class="padd8">
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a></span> </h4>
                            <div class="media-bodyin">Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</div>
                            <h4 class="media-heading"><small>Was this review helpful?<span class="padd8"><img src="images/up.png" alt=""> Yes</span> <span class="padd8"><img src="images/dwn.png" alt=""> No</span></small></h4>
                            
                        </div>
                    </div>
                    
                   
                    <div class="media well3">
                        <a class="pull-left" href="#">
                            <img class="media-object" src="images/productsDtls/thumbs.png" alt="">
                        </a>
                        <div class="media-body">
                            <h4 class="media-heading">John Doe <small>2 June, 2015M</small><span class="padd8">
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a>
                            <a href="#"><i class="fa fa-star"></i></a></span> </h4>
                            <div class="media-bodyin">Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</div>
                            <h4 class="media-heading"><small>Was this review helpful?<span class="padd8"><img src="images/up.png" alt=""> Yes</span> <span class="padd8"><img src="images/dwn.png" alt=""> No</span></small></h4>
                            
                            <div class="media well3">
                                <a class="pull-left" href="#">
                                    <img class="media-object" src="images/productsDtls/thumbs.png" alt="">
                                </a>
                                <div class="media-body">
                                    <h4 class="media-heading">John Doe <small>2 June, 2015M</small><span class="padd8">
                                    <a href="#"><i class="fa fa-star"></i></a>
                                    <a href="#"><i class="fa fa-star"></i></a>
                                    <a href="#"><i class="fa fa-star"></i></a>
                                    <a href="#"><i class="fa fa-star"></i></a>
                                    <a href="#"><i class="fa fa-star"></i></a></span> </h4>
                                        <div class="media-bodyin">Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra turpis. Fusce condimentum nunc ac nisi vulputate fringilla. Donec lacinia congue felis in faucibus.</div>
                                        <h4 class="media-heading"><small>Was this review helpful?<span class="padd8"><img src="images/up.png" alt=""> Yes</span> <span class="padd8"><img src="images/dwn.png" alt=""> No</span></small></h4>
                                        
                                    </div>
                                </div>
                               
                        </div>
                    </div>
                    <div><button type="button" class="btn btn-themebl btn-lg btn-block">Show All Reviews</button></div>
                    
            </div> 
            </div>
            
          </div>
        </div>-->
    <!--body-cont-end-->



<script type="text/javascript"><!--
$(document).ready(function() {
	$('.colorbox').colorbox({
		overlayClose: true,
		opacity: 0.5,
		rel: "colorbox"
	});
});
//--></script> 
<script type="text/javascript"><!--

$('select[name="profile_id"], input[name="quantity"]').change(function(){
    $.ajax({
		url: 'index.php?route=product/product/getRecurringDescription',
		type: 'post',
		data: $('input[name="product_id"], input[name="quantity"], select[name="profile_id"]'),
		dataType: 'json',
        beforeSend: function() {
            $('#profile-description').html('');
        },
		success: function(json) {
			$('.success, .warning, .attention, information, .error').remove();
            
			if (json['success']) {
                $('#profile-description').html(json['success']);
			}	
		}
	});
});
    
$('#button-cart').bind('click', function() {
	
	$.ajax({
		url: 'index.php?route=checkout/cart/add',
		type: 'post',
		data: $('.product-info input[type=\'text\'], .product-info input[type=\'hidden\'], .product-info input[type=\'radio\']:checked, .product-info input[type=\'checkbox\']:checked, .product-info select, .product-info textarea'),
		dataType: 'json',
		success: function(json) {
			$('.success, .warning, .attention, information, .error').remove();
			
			if (json['error']) {
				if (json['error']['option']) {
					for (i in json['error']['option']) {
						$('#option-' + i).after('<span class="error">' + json['error']['option'][i] + '</span>');
					}
				}
                
                if (json['error']['profile']) {
                    $('select[name="profile_id"]').after('<span class="error">' + json['error']['profile'] + '</span>');
                }
			} 
			
			if (json['success']) {
				$('#notification').html('<div class="success" style="display: none;">' + json['success'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');
					
				$('.success').fadeIn('slow');
					
				$('#cart-total').html(json['total']);
				
				$('html, body').animate({ scrollTop: 0 }, 'slow'); 
			}	
		}
	});
});
//--></script>
<?php if ($options) { ?>
<script type="text/javascript" src="catalog/view/javascript/jquery/ajaxupload.js"></script>
<?php foreach ($options as $option) { ?>
<?php if ($option['type'] == 'file') { ?>
<script type="text/javascript"><!--
new AjaxUpload('#button-option-<?php echo $option['product_option_id']; ?>', {
	action: 'index.php?route=product/product/upload',
	name: 'file',
	autoSubmit: true,
	responseType: 'json',
	onSubmit: function(file, extension) {
		$('#button-option-<?php echo $option['product_option_id']; ?>').after('<img src="catalog/view/theme/default/image/loading.gif" class="loading" style="padding-left: 5px;" />');
		$('#button-option-<?php echo $option['product_option_id']; ?>').attr('disabled', true);
	},
	onComplete: function(file, json) {
		$('#button-option-<?php echo $option['product_option_id']; ?>').attr('disabled', false);
		
		$('.error').remove();
		
		if (json['success']) {
			alert(json['success']);
			
			$('input[name=\'option[<?php echo $option['product_option_id']; ?>]\']').attr('value', json['file']);
		}
		
		if (json['error']) {
			$('#option-<?php echo $option['product_option_id']; ?>').after('<span class="error">' + json['error'] + '</span>');
		}
		
		$('.loading').remove();	
	}
});
//--></script>
<?php } ?>
<?php } ?>
<?php } ?>
<script type="text/javascript"><!--
$('#review .pagination a').live('click', function() {
	$('#review').fadeOut('slow');
		
	$('#review').load(this.href);
	
	$('#review').fadeIn('slow');
	
	return false;
});			

$('#review').load('index.php?route=product/product/review&product_id=<?php echo $product_id; ?>');

$('#button-review').bind('click', function() {
	$.ajax({
		url: 'index.php?route=product/product/write&product_id=<?php echo $product_id; ?>',
		type: 'post',
		dataType: 'json',
		data: 'name=' + encodeURIComponent($('input[name=\'name\']').val()) + '&text=' + encodeURIComponent($('textarea[name=\'text\']').val()) + '&rating=' + encodeURIComponent($('input[name=\'rating\']:checked').val() ? $('input[name=\'rating\']:checked').val() : '') + '&captcha=' + encodeURIComponent($('input[name=\'captcha\']').val()),
		beforeSend: function() {
			$('.success, .warning').remove();
			$('#button-review').attr('disabled', true);
			$('#review-title').after('<div class="attention"><img src="catalog/view/theme/default/image/loading.gif" alt="" /> <?php echo $text_wait; ?></div>');
		},
		complete: function() {
			$('#button-review').attr('disabled', false);
			$('.attention').remove();
		},
		success: function(data) {
			if (data['error']) {
				$('#review-title').after('<div class="warning container">' + data['error'] + '</div>');
			}
			
			if (data['success']) {
				$('#review-title').after('<div class="success container">' + data['success'] + '</div>');
								
				$('input[name=\'name\']').val('');
				$('textarea[name=\'text\']').val('');
				$('input[name=\'rating\']:checked').attr('checked', '');
				$('input[name=\'captcha\']').val('');
			}
		}
	});
});
//--></script> 
<script type="text/javascript"><!--
$('#tabs a').tabs();
//--></script> 
<script type="text/javascript" src="catalog/view/javascript/jquery/ui/jquery-ui-timepicker-addon.js"></script> 
<script type="text/javascript"><!--
$(document).ready(function() {
	if ($.browser.msie && $.browser.version == 6) {
		$('.date, .datetime, .time').bgIframe();
	}

	$('.date').datepicker({dateFormat: 'yy-mm-dd'});
	$('.datetime').datetimepicker({
		dateFormat: 'yy-mm-dd',
		timeFormat: 'h:m'
	});
	$('.time').timepicker({timeFormat: 'h:m'});
});
//--></script> 
<?php echo $footer; ?>
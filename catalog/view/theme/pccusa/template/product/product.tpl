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

                <div style=""><!--zoom-->
                 <?php if ($thumb || $images) { ?>
                 <?php if ($thumb) { ?>
                    <div class="picZoomer">
                        <img class="image" src="<?php echo $thumb; ?>" title="<?php echo $heading_title; ?>" alt="<?php echo $heading_title; ?>" id="image" />
                    </div>
                 <?php } ?>

                 <?php if ($images) { ?>
                    <ul class="piclist" id="piclist_zoom">
                        <?php foreach ($images as $image) { ?>
                        <li class="item">
                            <img src="<?php echo $image['thumb']; ?>" title="<?php echo $heading_title; ?>" alt="<?php echo $heading_title; ?>" />
                        </li>
                        <?php } ?>                        
                    </ul>
                    <?php } ?>
                 <?php } ?>                 
                </div>                    

                </div>

                <!--right-->
                <div class="col-lg-7 col-md-7 col-sm-7 product-details">
                    <h3><?php echo $heading_title; ?> <!-- <small>(Ring)</small> --></h3>

                    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
                    <div class="row">
                        <div class="col-md-6">
                        <div><img src="catalog/view/theme/default/image/stars-<?php echo $rating; ?>.png" alt="<?php echo $reviews; ?>" />&nbsp;&nbsp;<a onclick="$('a[href=\'#tab-review\']').trigger('click');"><?php echo $reviews; ?></a>&nbsp;&nbsp;|&nbsp;&nbsp;<a onclick="$('a[href=\'#tab-review\']').trigger('click');"><?php echo $text_write; ?></a></div>
                        </div>
                        <div class="col-md-6">
                            <div class="share"><!-- AddThis Button BEGIN -->
                            <div class="addthis_default_style"><a class="addthis_button_compact"><?php echo $text_share; ?></a> <a class="addthis_button_email"></a><a class="addthis_button_print"></a> <a class="addthis_button_facebook"></a> <a class="addthis_button_twitter"></a></div>
                            <script type="text/javascript" src="//s7.addthis.com/js/250/addthis_widget.js"></script> 
                            <!-- AddThis Button END --> 
                            </div>
                        </div>
                    </div>
                    
                    
                    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
                    <div class="row">
                        <!--<div class="col-md-4 text-cent"><span><a href="#"><img src="catalog/view/theme/pccusa/images/edit.png" alt="">Write a review</a></span> </div> -->
                        <div class="col-md-4 text-cent"><span><a onclick="addToCompare('<?php echo $product_id; ?>');"><img src="catalog/view/theme/pccusa/images/add-fileb.png" alt=""><?php echo $button_compare; ?></a></span></div>
                        <div class="col-md-4 text-cent"><span><a onclick="addToWishList('<?php echo $product_id; ?>');"><img src="catalog/view/theme/pccusa/images/ico-gbox.png" alt=""><?php echo $button_wishlist; ?></a></span></div>
                  
                    </div>
                    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
                    <div class="">

                          <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-hover">
                                        <thead>
                                            <tr>
                                                <th colspan="2">Specifications</th>
                                                <th colspan="2">Description</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>Metal</td>
                                                <td>Gold</td>
                                                <td>Alture (D)</td>
                                                <td>7.4 mm</td>
                                            </tr>
                                            <tr>
                                                <td>Segmento</td>
                                                <td>Feminino</td>
                                                <td>Largura Aro (A)</td>
                                                <td>5.6 mm</td>
                                            </tr>
                                            <tr>
                                                <td>Pedras</td>
                                                <td>Espinelio</td>
                                                <td>Espessure (B)</td>
                                                <td>1.1 mm</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>

                    </div>
                    <div class="">
                        <strong>Warranty:</strong> 1 year manufacturer warranty for any damage
                    </div>
                    <div class="hr5" style="margin-top:30px; margin-bottom:25px;"><!-- Divider --></div>
                   
    <div class="product-info">               
    <div class="right">
      <div class="description">
        <?php if ($manufacturer) { ?>
        <span><?php echo $text_manufacturer; ?></span> <a href="<?php echo $manufacturers; ?>"><?php echo $manufacturer; ?></a><br />
        <?php } ?>
        <span><?php echo $text_model; ?></span> <?php echo $model; ?><br />
        <?php if ($reward) { ?>
        <span><?php echo $text_reward; ?></span> <?php echo $reward; ?><br />
        <?php } ?>
        <span><?php echo $text_stock; ?></span> <?php echo $stock; ?></div>
      <?php if ($price) { ?>
      <div class="price"><?php echo $text_price; ?>
        <?php if (!$special) { ?>
        <?php echo $price; ?>
        <?php } else { ?>
        <span class="price-old"><?php echo $price; ?></span> <span class="price-new"><?php echo $special; ?></span>
        <?php } ?>
        <br />
        <?php if ($tax) { ?>
        <span class="price-tax"><?php echo $text_tax; ?> <?php echo $tax; ?></span><br />
        <?php } ?>
        <?php if ($points) { ?>
        <span class="reward"><small><?php echo $text_points; ?> <?php echo $points; ?></small></span><br />
        <?php } ?>
        <?php if ($discounts) { ?>
        <br />
        <div class="discount">
          <?php foreach ($discounts as $discount) { ?>
          <?php echo sprintf($text_discount, $discount['quantity'], $discount['price']); ?><br />
          <?php } ?>
        </div>
        <?php } ?>
      </div>
      <?php } ?>
      <?php if ($profiles): ?>
      <div class="option">
          <h2><span class="required">*</span><?php echo $text_payment_profile ?></h2>
          <br />
          <select name="profile_id">
              <option value=""><?php echo $text_select; ?></option>
              <?php foreach ($profiles as $profile): ?>
              <option value="<?php echo $profile['profile_id'] ?>"><?php echo $profile['name'] ?></option>
              <?php endforeach; ?>
          </select>
          <br />
          <br />
          <span id="profile-description"></span>
          <br />
          <br />
      </div>
      <?php endif; ?>
      
      
      <?php if ($options) { ?>
      <div class="options">
        <h2><?php echo $text_option; ?></h2>
        <br />
        <?php foreach ($options as $option) { ?>
        <?php if ($option['type'] == 'select') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <select name="option[<?php echo $option['product_option_id']; ?>]">
            <option value=""><?php echo $text_select; ?></option>
            <?php foreach ($option['option_value'] as $option_value) { ?>
            <option value="<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
            <?php if ($option_value['price']) { ?>
            (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
            <?php } ?>
            </option>
            <?php } ?>
          </select>
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'radio') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <?php foreach ($option['option_value'] as $option_value) { ?>
          <input type="radio" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option_value['product_option_value_id']; ?>" id="option-value-<?php echo $option_value['product_option_value_id']; ?>" />
          <label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
            <?php if ($option_value['price']) { ?>
            (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
            <?php } ?>
          </label>
          <br />
          <?php } ?>
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'checkbox') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <?php foreach ($option['option_value'] as $option_value) { ?>
          <input type="checkbox" name="option[<?php echo $option['product_option_id']; ?>][]" value="<?php echo $option_value['product_option_value_id']; ?>" id="option-value-<?php echo $option_value['product_option_value_id']; ?>" />
          <label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
            <?php if ($option_value['price']) { ?>
            (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
            <?php } ?>
          </label>
          <br />
          <?php } ?>
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'image') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <table class="option-image">
            <?php foreach ($option['option_value'] as $option_value) { ?>
            <tr>
              <td style="width: 1px;"><input type="radio" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option_value['product_option_value_id']; ?>" id="option-value-<?php echo $option_value['product_option_value_id']; ?>" /></td>
              <td><label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><img src="<?php echo $option_value['image']; ?>" alt="<?php echo $option_value['name'] . ($option_value['price'] ? ' ' . $option_value['price_prefix'] . $option_value['price'] : ''); ?>" /></label></td>
              <td><label for="option-value-<?php echo $option_value['product_option_value_id']; ?>"><?php echo $option_value['name']; ?>
                  <?php if ($option_value['price']) { ?>
                  (<?php echo $option_value['price_prefix']; ?><?php echo $option_value['price']; ?>)
                  <?php } ?>
                </label></td>
            </tr>
            <?php } ?>
          </table>
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'text') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" />
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'textarea') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <textarea name="option[<?php echo $option['product_option_id']; ?>]" cols="40" rows="5"><?php echo $option['option_value']; ?></textarea>
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'file') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <input type="button" value="<?php echo $button_upload; ?>" id="button-option-<?php echo $option['product_option_id']; ?>" class="button">
          <input type="hidden" name="option[<?php echo $option['product_option_id']; ?>]" value="" />
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'date') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" class="date" />
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'datetime') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" class="datetime" />
        </div>
        <br />
        <?php } ?>
        <?php if ($option['type'] == 'time') { ?>
        <div id="option-<?php echo $option['product_option_id']; ?>" class="option">
          <?php if ($option['required']) { ?>
          <span class="required">*</span>
          <?php } ?>
          <b><?php echo $option['name']; ?>:</b><br />
          <input type="text" name="option[<?php echo $option['product_option_id']; ?>]" value="<?php echo $option['option_value']; ?>" class="time" />
        </div>
        <br />
        <?php } ?>
        <?php } ?>
      </div>
      <?php } ?>
      <div class="cart">
        <div><?php echo $text_qty; ?>
          <input type="text" name="quantity" size="2" value="<?php echo $minimum; ?>" />
          <input type="hidden" name="product_id" size="2" value="<?php echo $product_id; ?>" />
          &nbsp;
          <input type="button" value="<?php echo $button_cart; ?>" id="button-cart" class="button" />
         
         
        </div>
        <?php if ($minimum > 1) { ?>
        <div class="minimum"><?php echo $text_minimum; ?></div>
        <?php } ?>
      </div>
      <?php if ($review_status) { ?>
      <div class="review">
        
        
      </div>
      <?php } ?>
    </div>
        
    </div>     
                <!--                         
                   <div class="row">
                        <div class="col-lg-6 col-md-6 col-sm-6">
                            <div><h2>$ 11,499</h2></div>
                            <div>EMI starts from $ 558</div>
                            <div class="martopbtm2">
                                <input name="Add to Cart" type="button" class="btn btn_black" value="Add to Cart">
                              
                                <button type="submit" class="btn btn_black">Shop Now</button>
                            </div>
                            <div><h4>10 day Replacement Guarantee</h4></div>
                        </div>
                        <div class="col-lg-6 col-md-6 col-sm-6">
                            <div class="clearfix">
                                <h4>Check availability at your location</h4>
                                <div class="row">
                                <form class="navbar-form navbar-left" role="search">
                                    <div class="form-group">
                                        <input type="text" class="form-control height34" placeholder="Enter Pincode">
                                    </div>
                                    <button type="submit" class="btn btn-theme">Check</button>
                                </form>
                                </div>
                            </div> 
                            <div class="marTop2">
                                <h4>Cash on delivery</h4>
                                May be available! <br/>Enter Pincode to confirm. 
                            </div>
                      </div>
                    </div>
                -->
                </div>

            </div><!--row-->
            <!--zoom-img-end--> 

            </div><!--panel-->


        </div>
      </div>
    </div>
    <!--body-cont-end-->
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
				$('#review-title').after('<div class="warning">' + data['error'] + '</div>');
			}
			
			if (data['success']) {
				$('#review-title').after('<div class="success">' + data['success'] + '</div>');
								
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
<?php echo $header; ?>

<?php echo $column_right; ?>

	
		<!-- Start Page Banner -->
		<div class="page-banner no-subtitle">
			<div class="container">
				<div class="row">
					<div class="col-md-6">
						<h2>Product Listing</h2>
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


		<!-- Start Content -->
		<div id="content">
			<div class="container">
				<div class="row">
					
					
                    <!--Sidebar ****************************-->
                    <div class="col-md-3 sidebar left-sidebar" id="left-sidebar" >
                	 <?php echo $column_left; ?>
                     </div>
               		<!--End sidebar-->
                    
                    
                    
                    
                    <!-- Start right panel ****************************-->
                	<div class="col-md-9">
                    
                
					<!-- Start Big Heading -->
                    <div class="big-title text-center">
                      <h3>Showing <?php echo $heading_title; ?> <strong>(<?php echo count($products); ?>)</strong> results</h3>
                    </div>
                    <!-- End Big Heading --> 
                    <!-- Some Text -->
                    <p class="text-center">
                    <?php if ($description) { ?>
                    <?php echo $description; ?>
                    <?php } ?>
                    </p>
                    
                    <!-- Divider -->
        			<div class="hr5" style="margin-top:30px; margin-bottom:20px;"></div>
                    <div class="">
                        <div class=" text-center m-b">
                        	<button type="button" class="btn btn-default">Popularity</button>
							<button type="button" class="btn btn-default">High Price</button>
                            <button type="button" class="btn btn-default">Low Price</button>
                            <button type="button" class="btn btn-default">Discounts</button>
                            <button type="button" class="btn btn-default">New Arrival</button>
                        </div>
                    </div>
                    <!-- Divider -->
                    <div class="hr5" style="margin-top:20px; margin-bottom:20px;"></div>
                    
                    <!-- Start Recent Projects Carousel -->
                    
                    <ul id="portfolio-list" data-animated="fadeIn">
                        <?php foreach ($products as $product) { ?>
                        <li>
                            
                          <?php if ($product['thumb']) { ?>                          
                          <div class="image product-thumb-image">
                              <a href="<?php echo $product['href']; ?>">
                                  <img src="<?php echo $product['thumb']; ?>" title="<?php echo $product['name']; ?>" alt="<?php echo $product['name']; ?>" />
                              </a>
                          </div>
                          <?php } ?>
                            <div class="portfolio-details"> 
                                    <a href="<?php echo $product['href']; ?>">
                                        <h4><?php echo $product['name']; ?></h4>
                                        <span class="thr">$ 700</span> <span><?php echo $product['price']; ?></span>
                                    </a> 
                            </div>
                            <div class="portfolio-item-content"> <span class="header"><?php echo $product['name']; ?></span>
                            <p class="body"><?php echo $product['description']; ?></p>
                            <p class="m-tb15"><a href="<?php echo $product['href']; ?>"><button type="button" class="btn btn-danger">View Details</button></a></p>
                            
                            <p class="wishlist"><a onclick="addToWishList('<?php echo $product['product_id']; ?>');"><?php echo $button_wishlist; ?></a></p>
                            <p class="compare"><a onclick="addToCompare('<?php echo $product['product_id']; ?>');"><?php echo $button_compare; ?></a></p>
                            <?php if ($product['rating']) { ?>
                             <div class="rating"><img src="catalog/view/theme/default/image/stars-<?php echo $product['rating']; ?>.png" alt="<?php echo $product['reviews']; ?>" /></div>
                            <?php } ?>
                            </div>
                        <a href="script:void(0);"  onclick="addToCart('<?php echo $product['product_id']; ?>');"><i class="fa fa-shopping-cart more"></i></a> 
                       
                        </li>
                        <?php } ?>
                    </ul>
                    
                    <!-- End Recent Projects Carousel --> 
                    
                    <!-- Divider -->
                    <div class="hr1" style="margin-bottom:30px;"></div>
                    
                    <!-- Button in Center -->
                    <!-- <p class="text-center"><a href="#" class="btn-system btn-medium border-btn"><i class="icon-brush"></i> Load More</a></p>-->
                    <?php if(count($products)>0){ ?>
                    <div class="pagination"><?php echo $pagination; ?></div>
                    <?php } ?>
                   
<?php if (!$categories && !$products) { ?>
<div class="content"><?php echo $text_empty; ?></div>
<div class="buttons">
  <div class="right"><a href="<?php echo $continue; ?>" class="button"><?php echo $button_continue; ?></a></div>
</div>
<?php } ?>
                   
                   
                   
                    </div>
                	<!-- End right panel -->
					
                    
				</div>
			</div>
		</div>
		<!-- End Content -->
		


<?php echo $content_bottom; ?>
  
  
<script type="text/javascript"><!--
function display(view) {
	if (view == 'list') {
		$('.product-grid').attr('class', 'product-list');
		
		$('.product-list > div').each(function(index, element) {
			html  = '<div class="right">';
			html += '  <div class="cart">' + $(element).find('.cart').html() + '</div>';
			html += '  <div class="wishlist">' + $(element).find('.wishlist').html() + '</div>';
			html += '  <div class="compare">' + $(element).find('.compare').html() + '</div>';
			html += '</div>';			
			
			html += '<div class="left">';
			
			var image = $(element).find('.image').html();
			
			if (image != null) { 
				html += '<div class="image">' + image + '</div>';
			}
			
			var price = $(element).find('.price').html();
			
			if (price != null) {
				html += '<div class="price">' + price  + '</div>';
			}
					
			html += '  <div class="name">' + $(element).find('.name').html() + '</div>';
			html += '  <div class="description">' + $(element).find('.description').html() + '</div>';
			
			var rating = $(element).find('.rating').html();
			
			if (rating != null) {
				html += '<div class="rating">' + rating + '</div>';
			}
				
			html += '</div>';
						
			$(element).html(html);
		});		
		
		$('.display').html('<b><?php echo $text_display; ?></b> <?php echo $text_list; ?> <b>/</b> <a onclick="display(\'grid\');"><?php echo $text_grid; ?></a>');
		
		$.totalStorage('display', 'list'); 
	} else {
		$('.product-list').attr('class', 'product-grid');
		
		$('.product-grid > div').each(function(index, element) {
			html = '';
			
			var image = $(element).find('.image').html();
			
			if (image != null) {
				html += '<div class="image">' + image + '</div>';
			}
			
			html += '<div class="name">' + $(element).find('.name').html() + '</div>';
			html += '<div class="description">' + $(element).find('.description').html() + '</div>';
			
			var price = $(element).find('.price').html();
			
			if (price != null) {
				html += '<div class="price">' + price  + '</div>';
			}
			
			var rating = $(element).find('.rating').html();
			
			if (rating != null) {
				html += '<div class="rating">' + rating + '</div>';
			}
						
			html += '<div class="cart">' + $(element).find('.cart').html() + '</div>';
			html += '<div class="wishlist">' + $(element).find('.wishlist').html() + '</div>';
			html += '<div class="compare">' + $(element).find('.compare').html() + '</div>';
			
			$(element).html(html);
		});	
					
		$('.display').html('<b><?php echo $text_display; ?></b> <a onclick="display(\'list\');"><?php echo $text_list; ?></a> <b>/</b> <?php echo $text_grid; ?>');
		
		$.totalStorage('display', 'grid');
	}
}

view = $.totalStorage('display');

if (view) {
	display(view);
} else {
	display('list');
}
//--></script> 
<?php echo $footer; ?>
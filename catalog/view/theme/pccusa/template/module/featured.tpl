  <!-- Start Featured Collection -->
  <div id="content">
    <div class="container"> 

      <!-- Start Big Heading -->
      <div class="big-title text-center"><h1>Featured Collection</h1></div>
      <!-- End Big Heading --> 
        
        <!--Start Featured Collection-->
        <div class="recent-projects">
          <div class="projects-carousel touch-carousel navigation-3"> 
            
            <?php foreach ($products as $product) { ?>
                <div class="owl-item" style="width: 285px;"><div class="portfolio-item item">
                      <div class="portfolio-border"> 
                            <div class="portfolio-thumb"> 
                                <a class="lightbox" data-lightbox-type="ajax" href="<?php echo $product['thumb']; ?>">
                                <div class="thumb-overlay"><i class="fa fa-arrows-alt"></i></div>
                                <img alt="<?php echo $product['name']; ?>" src="<?php echo $product['thumb']; ?>"> </a> 
                            </div>
                            <div class="portfolio-details"> 
                            <a href="<?php echo $product['href']; ?>"><h4> <?php echo $product['name']; ?></h4>
                              <?php if (!$product['special']) { ?>
                              <span><?php echo $product['price']; ?></span>
                              <?php } else { ?>
                              <span class="price-old"><?php echo $product['price']; ?></span> 
                              <span class="price-new thr"><?php echo $product['special']; ?></span>
                              <?php } ?>
                            </a> 
                            </div>
                            <div class="cart btn btn-system btn-large btn-black btn-lg">
                            <input type="button" value="<?php echo $button_cart; ?>" onclick="addToCart('<?php echo $product['product_id']; ?>');" class="button btn btn-system btn-large btn-black btn-lg" />
                            </div>
                            
                      </div>
                </div>
             	</div>
            
            <?php } ?>
            
            
        
            
          </div>
        </div>
        <!--End Featured Collection--> 
      
    </div>
  </div>
  <!-- End Featured Collection --> 
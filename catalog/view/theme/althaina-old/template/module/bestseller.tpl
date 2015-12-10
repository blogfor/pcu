<div class="box">
  <div class="box-heading"><span><?php echo $heading_title; ?></span></div>
  <div class="box-content">
    <div class="box-product " >
      <?php foreach ($products as $product) { ?>
     
      <div class="box-product-in">
        <?php if ($product['thumb']) { ?>
        <div class="image"><a href="<?php echo $product['href']; ?>"><img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>" title="<?php echo $product['name']; ?>" /></a></div>
        <?php } ?>
          <div class="rating"><img src="catalog/view/theme/althaina/image/stars-<?php echo $product['rating']; ?>.png" alt="<?php echo $product['reviews']; ?>" /></div>
        <div class="name"><a href="<?php echo $product['href']; ?>"><?php echo $product['name']; ?></a></div>
        <?php if ($product['price']) { ?>
        <div class="price">
          <?php if (!$product['special']) { ?>
          <?php echo $product['price']; ?>
          <?php } else { ?>
          <span class="special-pro"></span>
          <span class="price-old"><?php echo $product['price']; ?></span> <span class="price-new"><?php echo $product['special']; ?></span>
          <?php } ?>
        </div>
        <?php } ?> 
       
        <div class="box-csc"> 
          <a onclick="addToCart('<?php echo $product['product_id']; ?>');" class="button" title="Add to Cart"><?php echo $button_cart; ?></a>
         <a class="wish-icon" title="Add to Wishlist" onclick="addToWishList('<?php echo $product['product_id']; ?>');"></a>
         <a class="compare-icon" title="Add to Compare" onclick="addToCompare('<?php echo $product['product_id']; ?>');"></a></div>        

      </div>
      <?php } ?>
     </div>
    
  </div>
</div>


<div class="clear"></div></div></div><!-- End Wrapper -->
<!-- Bottom Footer -->
<div id="bottom-footer">
<?php
$design = 'COPYRIGHT © 2012 Design by <a href="http://focusthemes.com">Focusthemes</a>'; ?>
<div id="footer">
   <!--  About Us --> 
     <?php if ($informations) { ?>
  <div class="column">
    <h3><?php echo $text_information; ?></h3>
    <ul>
      <?php foreach ($informations as $information) { ?>
      <li><a href="<?php echo $information['href']; ?>"><?php echo $information['title']; ?></a></li>
      <?php } ?>
    </ul>
  </div>
  <?php } ?>
  <div class="column">
    <h3><?php echo $text_service; ?></h3>
    <ul>
      <li><a href="<?php echo $contact; ?>"><?php echo $text_contact; ?></a></li>
      <li><a href="<?php echo $return; ?>"><?php echo $text_return; ?></a></li>
      <li><a href="<?php echo $sitemap; ?>"><?php echo $text_sitemap; ?></a></li>
    </ul>
  </div>
  <div class="column">
    <h3><?php echo $text_extra; ?></h3>
    <ul>
      <li><a href="<?php echo $manufacturer; ?>"><?php echo $text_manufacturer; ?></a></li>
      <li><a href="<?php echo $voucher; ?>"><?php echo $text_voucher; ?></a></li>
      <li><a href="<?php echo $affiliate; ?>"><?php echo $text_affiliate; ?></a></li>
      <li><a href="<?php echo $special; ?>"><?php echo $text_special; ?></a></li>
    </ul>
  </div>
  <div class="column">
    <h3><?php echo $text_account; ?></h3>
    <ul>
      <li><a href="<?php echo $account; ?>"><?php echo $text_account; ?></a></li>
      <li><a href="<?php echo $order; ?>"><?php echo $text_order; ?></a></li>
      <li><a href="<?php echo $wishlist; ?>"><?php echo $text_wishlist; ?></a></li>
      <li><a href="<?php echo $newsletter; ?>"><?php echo $text_newsletter; ?></a></li>
    </ul>
  </div>
 

</div>
<div class="powered-main">
<div id="powered"> 
    
    <!--  Payment -->         
   
     <div class="payment">
    
      <a title="" href="" target="_blank"  >   
      <img src="catalog/view/theme/althaina/image/payment.png"></a>

    </div> 
    
    <div class="copyright">
    <?php if($this->config->get('althaina_copyright')) { echo $this->config->get('althaina_copyright'); } else {echo $design;  }?>
    </div>
<div class="back-to-top" id="back-top"><a title="Back to Top" href="javascript:void(0)" class="backtotop"></a></div>
</div></div></div><!--End Bottom Footer --></div>
<!--Scroll back to top-->
<script type='text/javascript'>
$(function () {
		$(window).scroll(function () {
			if ($(this).scrollTop() > 100) {
				$('#back-top').fadeIn();
			} else {
				$('#back-top').fadeOut();
			}
		});
		});
jQuery('.backtotop').click(function(){
	jQuery('html, body').animate({scrollTop:0}, 'slow');
});

</script>
<!--end of Scroll back to top-->

</body></html>
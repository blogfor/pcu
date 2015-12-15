<?php echo $header; ?>
<?php //echo $column_left; ?>
<?php //echo $column_right; ?>


<style>
.page_heading {
	padding:2px 2px !important;
}
</style>

<style>
    .map {
        min-width: 300px;
        min-height: 300px;
        width: 100%;
        height: 100%;
    }

    .header {
        background-color: #F5F5F5;
        color: #333;
        height: 70px;
        font-size: 27px;
        padding: 10px;
    }
	span.error{
	width: 370px;
    display: block;
    text-align: center;
    line-height: 30px;
    color: red;
	margin:0 auto;
	}
	
</style>




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
    
 <br clear="all" />   
    
    
    
<div class="class="pmagn3">
    <div class="container">
      <div id="main_fullwidth_content" class="col-sm-12">
        <div class="collection-scope">
          
        
          
          <div class="page_content">
          
          <div class="row">
        <div class="col-md-6">
            <div class="well well-sm">
            <form action="<?php echo $action; ?>" class="form-horizontal" method="post" enctype="multipart/form-data">
               
                    <fieldset>
                        <legend class="text-center header">Send us your message </legend>
                        
                        <div class="form-group">
                            <div class="col-md-10 col-md-offset-1">
                                <input id="lname" name="name" type="text"  value="<?php echo $name; ?>" placeholder="Name" class="form-control">                                
                            </div>
                            
                            <?php if ($error_name) { ?>
                            <span class="error"><?php echo $error_name; ?></span>
                            <?php } ?>
                        </div>

                        <div class="form-group">
                            <div class="col-md-10 col-md-offset-1">
                                <input id="email" name="email" type="text" placeholder="Email Address" class="form-control" value="<?php echo $email; ?>" >
                            </div>
                            <?php if ($error_email) { ?>
                            <span class="error"><?php echo $error_email; ?></span>
                            <?php } ?>
                        </div>

                        <div class="form-group">
                            <div class="col-md-10 col-md-offset-1">
                                <input id="phone" name="phone" type="text" placeholder="Phone" class="form-control">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-10 col-md-offset-1">
                                <textarea class="form-control" id="enquiry" name="enquiry" placeholder="Enter your massage for us here. We will get back to you within 2 business days." rows="7"></textarea>
                            </div>
                        </div>
                        
                   
    
    
    					
                        
                        <div class="form-group">
                            <div class="col-md-4 col-md-offset-1">
                               <img src="index.php?route=information/contact/captcha" alt="" />
                            </div>
                            
                            <div class="col-md-5 col-md-offset-1">
                               <input type="text" name="captcha" value="<?php echo $captcha; ?>" class="form-control" placeholder="<?php echo $entry_captcha; ?>"/>
                            </div>
                            <?php if ($error_captcha) { ?>
                            <span class="error"><?php echo $error_captcha; ?></span>
                            <?php } ?>
                            
                        </div>
                        
    

                        <div class="form-group">
                            <div class="col-md-12 text-center">
                               
                                 <input type="submit" value="<?php echo $button_continue; ?>" class="btn btn-primary btn-lg"/>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
        </div>
        <div class="col-md-6">
            <div>
                <div class="panel panel-default">
                    <div class="text-center header">Our Office</div>
                    <div class="panel-body text-center">
                        <h4>CORPORATE OFFICE</h4>
                        <div>
P-154A, NAZRUL ISLAM AVENUE, <br />
CIT SCHEME VIIM, KOLKATA - 700054, <br />
Email:support@pcchandraindia.com, <br />

                        </div>
                        <hr />
                        <div id="map1" class="map">
                        </div>
                    </div>
                </div>
            </div>
        </div>
   		 </div>
          
          
     
  
<script src="http://maps.google.com/maps/api/js?sensor=false"></script>

<script type="text/javascript">
    jQuery(function ($) {
        function init_map1() {
            var myLocation = new google.maps.LatLng(22.589824, 88.392197);
			
			
            var mapOptions = {
                center: myLocation,
                zoom: 16
            };
            var marker = new google.maps.Marker({
                position: myLocation,
                title: "Property Location"
            });
            var map = new google.maps.Map(document.getElementById("map1"),
                mapOptions);
            marker.setMap(map);
        }
		
        //init_map1();
		setTimeout(init_map1, 5000);
    });
</script>

  <?php //echo $description; ?>
          	
          	</div>
 		</div>
  
   <?php echo $content_bottom; ?> 
   </div>
      </div>
    </div>
    
   
<?php echo $footer; ?>
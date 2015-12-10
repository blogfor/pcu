<div class="contenta">
<?php
if (!function_exists('curPageURL')) {
function curPageURL() {
$pageURL = 'http';
if (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == 'on') {$pageURL .= "s";}
$pageURL .= "://";
if ($_SERVER["SERVER_PORT"] != "80") {
$pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
} else {
$pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
}
return $pageURL;
}
}
?>
<style>
#refinebyprice
{ 
    padding:0 10px 0;
}

#refinebyprice input{
    background: transparent;
    border: none;
    padding: 5px 0px;
    font-weight: bold;
    
}
#slider-range
{
margin-top:10px;
}
.help-txt-heading
{
font-size: 10px; 
color:#000;
}
.help-txt
{
font-size: 10px;
font-weight: bold;
color:#ff6600;

}
.buttonclear
{
margin:0 10px 10px 35px;
}
#amount
{
font-size:18px; 
opacity:0; 
border: 0; 
color: #ff6600;
font-weight: bold;
}
</style>
<div class="box">
		<div class="box-heading"><?php echo $text_filter_price; ?></div>
	        <div id="refinebyprice" class="box-content">
	            <label for="amount"></label>
	            <span class="help-txt-heading">Min - Max:</span>
                    <span class="help-txt">
                    <?php
                    if (isset($this->session->data['lower'])&&isset($this->session->data['higher']))
                    {
                    $datalowercategory=$this->session->data['lower'];
                    $datahighercategory=$this->session->data['higher'];
                    }
                    else
                    { 
                    $datalowercategory=$lowerlimit;
                    $datahighercategory=$upperlimit;
                    
                    }?>
                    <?php echo $this->currency->format($datalowercategory );?> - <?php echo $this->currency->format($datahighercategory);?></span><br>
                    <div id="slider-range"></div>
                    <input type="text" id="amount" readonly="" maxlength="20"/>
                    <a class="buttonclear button" onclick="resetslider()">Reset</a>
	        </div>
	    </div>
   
<script>
    var target;
  $(function() {
    
    var queryString = window.location.search;
    if  (queryString.indexOf("route") != -1)
     {
      target='index.php?route=product/category&path='+'<?php if(isset($_GET['path'])){ echo $_GET['path']; }?>';
      } else {
      target='<?php echo curPageURL();?>';
      }  
      
    $( "#slider-range" ).slider({
      range: true,
      min: <?php echo $lowerlimit ?> ,
      max: <?php echo $upperlimit ?>,
      values: [ "<?php echo $datalowercategory;?>", "<?php echo $datahighercategory;?>" ],
      slide: function( event, ui ) { $("#amount").css("opacity","1"); $( "#amount" ).val(  + ui.values[ 0 ] + " - " + ui.values[ 1 ] ); },
      change : function (event, ui) {
                           $.ajax({
				url: target,
				dataType:'html',
				type: 'get',
				data:{ lower:ui.values[ 0 ], higher:ui.values[ 1 ]},
				success: function(html) {
				   location.reload();
				}
                                
			    }); 
                            
                            }
                             
});
                           

    
    $( "#amount" ).val(  + $( "#slider-range" ).slider( "values", 0 ) +
      " - " + $( "#slider-range" ).slider( "values", 1 ) );
});



function resetslider() {
  var $slider = $("#slider-range");
  $( "#slider-range" ).slider({
      change : function (event, ui) {
			    $.ajax({
				url: target,
				dataType:'html',
				type: 'get',
				data:{ lower:"<?php echo $lowerlimit; ?>", higher:"<?php echo $upperlimit; ?>"}				                           
			    });			
}
    });
    $slider.slider("values", 0, "15");
     location.reload();
}

 </script>

</div>
<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 48 $)

*/
?>
<?php echo $header; ?>
<div id="content">

  <?php echo $ka_top; ?>
  
  <div class="box">

    <div class="heading">
      <h1><img src="view/image/order.png" alt="" />Cart</h1>
      <div class="buttons">
        <a onclick="location = '<?php echo $back; ?>';" class="button"><?php echo $this->language->get('Back'); ?></a>
      </div>
    </div>
    
    <div class="content">
      <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
        
        <table class="list">
          <thead>
            <tr>
              <td class="left">Model</td>
              <td class="left">Name</td>
              <td class="left">Qty</td>
            </tr>
          </thead>
          <tbody>
            <?php
             if (!empty($products)) { ?>
              <?php foreach ($products as $p) { ?>
                <tr>
                  <td class="left"><?php echo $p['model']; ?></td>
                  <td class="left"><?php echo $p['name']; ?>
                    <div>
                      <?php foreach ($p['option'] as $option) { ?>
                      - <small><?php echo $option['name']; ?> <?php echo $option['value']; ?></small><br />
                      <?php } ?>
                    </div>                  
                  </td>
                  <td class="left"><?php echo $p['quantity']; ?></td>                  
                </tr>
              <?php } ?>
            <?php } else { ?>
            <tr>
              <td class="center" colspan="5">No results</td>
            </tr>
            <?php } ?>
          </tbody>
        </table>
        
      </form>
    </div>
  </div>
</div>
<?php echo $footer; ?>
<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 92 $)
*/
?>

<?php echo $this->fetch('mail/ka_acr_header.tpl'); ?>

  <br />
  
  <p><?php echo str_replace(array('{fname}', '{lname}'), array($customer['firstname'], $customer['lastname']), $this->language->get('text_dear_customer')); ?></p>
  
  <p><?php echo htmlspecialchars_decode($description); ?></p>
  
        <table>
          <thead>
            <tr>
              <th width="80px"><?php echo $this->language->get('Model'); ?></th>
            	<th width="120px"><?php echo $this->language->get('Image'); ?></th>
              <th width="200px"><?php echo $this->language->get('Name'); ?></th>
              <th width="60px"><?php echo $this->language->get('Price'); ?></th>
              <th width="60px"><?php echo $this->language->get('Qty'); ?></th>
              <th width="80px"><?php echo $this->language->get('Total'); ?></th>
            </tr>
          </thead>
          <tbody>
            <?php if (!empty($products)) { ?>
              <?php foreach ($products as $p) { ?>
                <tr>
                  <td><?php echo $p['model']; ?></td>
                  <td><img src="<?php echo $_images[$p['image_cid']]; ?>" width="100px" /></td>
                  
                  <td><?php echo $p['name']; ?>
                    <div>
                      <?php foreach ($p['option'] as $option) { ?>
                      - <small><?php echo $option['name']; ?> <?php echo $option['value']; ?></small><br />
                      <?php } ?>
                    </div>                  
                  </td>
                  <td class="center"><?php echo $p['price']; ?></td>
                  <td class="center"><?php echo $p['quantity']; ?></td>
                  <td class="right"><?php echo $p['total']; ?></td>
                </tr>
              <?php } ?>
              
              <tr>
                <td class="right" colspan="6"><b><?php echo $this->language->get('Subtotal'); ?>: <?php echo $subtotal; ?></b></td>
              </tr>
            <?php } else { ?>
            <tr>
              <td class="center" colspan="6"><?php echo $this->language->get('No Results'); ?></td>
            </tr>
            <?php } ?>
          </tbody>
        </table>

  <br />
  <p>
    <?php echo str_replace('{cart_url}', $cart_url, $this->language->get('text_click_to_finish')); ?> 
  </p>

<?php echo $this->fetch('mail/ka_acr_footer.tpl'); ?>
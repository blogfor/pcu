<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 48 $)
*/
?>

--
<p><?php echo $this->language->get('text_footer'); ?></p>
<?php if (!empty($unsubscribe_url)) { ?>
<p class="notice">
<?php echo str_replace('{unsubscribe_url}', $unsubscribe_url, $this->language->get('text_to_unsubscribe')); ?>
</p>
<?php } ?>

</div>
</body>
</html>
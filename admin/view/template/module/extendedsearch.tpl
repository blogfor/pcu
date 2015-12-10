<?php echo $header; ?>
<div id="content">
<div class="breadcrumb">
  <?php foreach ($breadcrumbs as $breadcrumb) { ?>
  <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
  <?php } ?>
</div>
<?php if ($error_warning) { ?>
<div class="warning"><?php echo $error_warning; ?></div>
<?php } ?>
<div class="box">
  <div class="heading">
    <h1><img src="view/image/module.png" alt="" /> <?php echo $heading_title; ?></h1>
    <div class="buttons"><a onclick="$('#form').submit();" class="button"><span><?php echo $button_save; ?></span></a><a onclick="location = '<?php echo $cancel; ?>';" class="button"><span><?php echo $button_cancel; ?></span></a></div>
  </div>
  <div class="content">
    <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form">
      <table id="module" class="list">
        <thead>
          <tr>
				<td class="left" ><?php echo $entry_status; ?></td>
          </tr>
        </thead>
		<tr>
            	 <td class="left"><select name="<?php echo ('extendedsearch_status'); ?>" >
                 <?php if (($this->config->get('extendedsearch_status')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>
		</tr>
</table>

<table id="module" class="list">
<h2><?php echo $text_extsearch; ?></h2>
        <thead>
          <tr>
            <td class="left" ></td>
			<td class="left" ><?php echo $entry_model; ?></td>
            <td class="left" ><?php echo $entry_sku; ?></td>
            <td class="left" ><?php echo $entry_upc; ?></td>
            <td class="left" ><?php echo $entry_ean; ?></td>
          </tr>
        </thead>
		<tr>

		 <td class="left"></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_model'); ?>" >
                 <?php if (($this->config->get('extendedsearch_model')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_sku'); ?>" >
                 <?php if (($this->config->get('extendedsearch_sku')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_upc'); ?>" >
                 <?php if (($this->config->get('extendedsearch_upc')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>
				 
		 <td class="left"><select name="<?php echo ('extendedsearch_ean'); ?>" >
                 <?php if (($this->config->get('extendedsearch_ean')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>
		</tr>
        <thead>
          <tr>
            <td class="left" ><?php echo $entry_jan; ?></td>
            <td class="left" ><?php echo $entry_isbn; ?></td>
            <td class="left" ><?php echo $entry_mpn; ?></td>
			<td class="left" ><?php echo $entry_location; ?></td>
			<td class="left" ><?php echo $entry_attr; ?></td>
          </tr>
        </thead>
		<tr>

		 <td class="left"><select name="<?php echo ('extendedsearch_jan'); ?>" >
                 <?php if (($this->config->get('extendedsearch_jan')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_isbn'); ?>" >
                 <?php if (($this->config->get('extendedsearch_isbn')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_mpn'); ?>" >
                 <?php if (($this->config->get('extendedsearch_mpn')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_location'); ?>" >
                 <?php if (($this->config->get('extendedsearch_location')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		 <td class="left"><select name="<?php echo ('extendedsearch_attr'); ?>" >
                 <?php if (($this->config->get('extendedsearch_attr')) > 0) { ?>
                 <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                 <option value="0"><?php echo $text_disabled; ?></option>
                 <?php } else { ?>
                 <option value="1"><?php echo $text_enabled; ?></option>
                 <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
                 <?php } ?>
              	 </select></td>

		</tr>
</table>

	
      </table>
    </form>

  </div>
</div>

<?php echo $footer; ?>
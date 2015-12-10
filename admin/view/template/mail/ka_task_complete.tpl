<?php
/*
  Project: Cron
  Author : karapuz <support@ka-station.com>

  Version: 1 ($Revision: 35 $)
*/
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><?php echo htmlspecialchars($subject); ?></title>
<style type="text/css">
body {
  color: #000000;
  font-family: Arial, Helvetica, sans-serif;
}
body, td, th, input, textarea, select, a {
  font-size: 12px;
}
p {
  margin-top: 0px;
  margin-bottom: 20px;
}
a, a:visited, a b {
  color: #378DC1;
  text-decoration: underline;
  cursor: pointer;
}
a:hover {
  text-decoration: none;
}
a img {
  border: none;
}
#container {
  width: 680px;
}
#logo {
  margin-bottom: 20px;
}

table.short-list {
  border-collapse: collapse;
  width: 400px;
  border-top: 1px solid #DDDDDD;
  border-left: 1px solid #DDDDDD;
  margin-bottom: 20px;
}

table.list {
  border-collapse: collapse;
  width: 100%;
  border-top: 1px solid #DDDDDD;
  border-left: 1px solid #DDDDDD;
  margin-bottom: 20px;
}

table td {
  border-right: 1px solid #DDDDDD;
  border-bottom: 1px solid #DDDDDD;
}

table thead td {
  background-color: #EFEFEF;
  padding: 0px 5px;
}

table thead td a, thead td {
  text-decoration: none;
  color: #222222;
  font-weight: bold;
}

table tbody td a {
  text-decoration: underline;
}
table tbody td {
  vertical-align: top;
  padding: 0px 5px;
}
table .left {
  text-align: left;
  padding: 7px;
}

table .right {
  text-align: right;
  padding: 7px;
}

table .center {
  text-align: center;
  padding: 7px;
}

</style>
</head>
<body>
<div id="container">
  <a href="<?php echo $store_url; ?>" title="<?php echo $store_name; ?>"><img src="<?php echo $logo; ?>" alt="<?php echo $store_name; ?>" id="logo" /></a>

  <p>Dear Administrator,</p>
  
  <p>A task is complete. There are complete details below:</p>

  <table class="short-list">
    <tbody>

      <tr>
        <td class="left" width="30%"><b>Task Name:</b></td>
        <td class="left" width="70%"><?php echo $task['name']; ?></td>
      </tr>
      
      <?php if (!empty($task['stat'])) { ?>
        <?php foreach ($task['stat'] as $name => $stat) { ?>
      <tr>
          <td class="left" width="30%"><b><?php echo $name; ?>:</b></td>
          <td class="left" width="70%"><?php echo $stat; ?></td>
      </tr>
    <?php } ?>
      <?php } ?>                    
      
    </tbody>
  </table>
  
  <p>If you do not want to recieve these email notifications please adjust the module settings in your store.</p>
</div>
</body>
</html>
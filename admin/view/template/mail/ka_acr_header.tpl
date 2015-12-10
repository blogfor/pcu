<?php
/*
  Project: Abandoned Cart Recovery
  Author : karapuz <support@ka-station.com>

  Version: 2 ($Revision: 48 $)
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
  border: none;
}

table {
  border-collapse: collapse;
  width: 100%;
  border: 1px solid #DDDDDD;
  margin-bottom: 20px;
}

table tbody td {
  vertical-align: top;
  padding: 7px 5px;
  border: 1px solid #DDDDDD;
}

table thead th {
  background-color: #EFEFEF;
  padding: 2px 5px;
  text-decoration: none;
  color: #222222;
  font-weight: bold;
  border: 1px solid #DDDDDD;
}

table .right  { text-align: right; padding: 7px; }
table .center { text-align: center; }

p.notice {
  color: gray;
  font-size: 10px;
}

</style>

</head>
<body>
<div id="container">
  <a href="<?php echo $store_url; ?>" title="<?php echo $store_name; ?>"><img src="<?php echo $logo; ?>" alt="<?php echo $store_name; ?>" id="logo" /></a>
  <br />
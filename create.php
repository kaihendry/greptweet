<?php
$HTTP_HOST = $_SERVER['SERVER_NAME'];

$id = strtolower($_GET["id"]);
$id = preg_replace("/[^a-z0-9_]+/", "", $id);
if(empty($id)) {
	die("Missing twitter id argument");
}
?>

<!DOCTYPE html>
<html>
 <head>
  <meta charset="utf-8" />
  <title>Fetching tweets of <?php echo $id; ?></title>
  <link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css">
</head>
<body>
<div class="container">
<div class="content">

<?php
if (is_dir("u/$id")) {
	echo "<h1 class='alert alert-info'>Attempting to update $id</h1>";
} else {
	if (!mkdir("u/$id", 0777, true)) {
		die("Failed to create u/$id directory.");
	}
}

chdir("u/$id");
symlink ("../../index.html", "index.html");
symlink ("../../grep.php", "grep.php");

if (strpos($id, '_') !== false) {
echo "<a href=\"http://$HTTP_HOST/u/$id\"><h1 class=\"alert alert-success\">Goto http://$HTTP_HOST/u/$id to grep!</h1></a>";
} else {
echo "<a href=\"http://$id.$HTTP_HOST\"><h1 class=\"alert alert-success\">Goto http://$id.$HTTP_HOST to grep!</h1></a>";
}

symlink ("$id.txt.gz", "tweets.txt.gz");
echo `sed -e "s,TIMESTAMP,$(date)," ../../greptweet.appcache > greptweet.appcache`;

echo "<pre>";
echo `../../fetch-tweets.sh $id & disown`;

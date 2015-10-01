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
</head>
<body>
<div class="container">
<div class="content">

<?php
if (is_dir("u/$id")) {
	echo "<h1>Attempting to update $id</h1>";
} else {
	if (!mkdir("u/$id", 0777, true)) {
		die("Failed to create u/$id directory.");
	}
}

chdir("u/$id");
symlink ("../../index.html", "index.html");
symlink ("../../grep.php", "grep.php");

if (strpos($id, '_') !== false) {
echo "<a href=\"/u/$id/\"><h1 class=\"alert alert-success\">Goto http://$HTTP_HOST/u/$id to grep!</h1></a>";
} else {
echo "<a href=\"/u/$id/\"><h1 class=\"alert alert-success\">Goto http://$id.$HTTP_HOST to grep!</h1></a>";
}

echo `sed -e "s,TIMESTAMP,$(date)," ../../greptweet.appcache > greptweet.appcache`;

$logfile = "fetch-" . time() . ".log";
exec(sprintf("../../fetch-tweets.sh %s > %s 2>&1 &", $id, $logfile));
?>
<p>Fetching tweets can take time! And it's limited by Twitter to 3200 maximum at any one time. Please view the <a href=/u/<?php echo "$id/$logfile";?>>logfile</a> to see its progress.</p>

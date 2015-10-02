<?php
if (preg_match('#^/u/#', $_SERVER["REQUEST_URI"])) {
$username = basename($_SERVER["REQUEST_URI"]);
	if ((!empty($username)) && (strlen($username < 16)) && preg_match('/^[A-Za-z0-9_]+$/', $username)) {
	header("Location:http://" . $_SERVER["HTTP_HOST"] . "/f/" . $username);
	die();
	}
}
?>
<img style="width: 20%;" src=/icons/greptweet_birdie.svg>
<h1>Error <?php echo $_SERVER["REQUEST_URI"]; ?></h1>

<?php
if (preg_match('#^/u/#', $_SERVER["REQUEST_URI"])) {
$username = basename($_SERVER["REQUEST_URI"]);
	if ((!empty($username)) && (strlen($username < 16)) && preg_match('/^[A-Za-z0-9_]+$/', $username)) {
		header("HTTP/1.1 303 See Other");
		header("Location:http://" . $_SERVER["HTTP_HOST"] . "/f/" . strtolower($username));
		die();
	}
}
http_response_code(404);
?>
<img style="width: 20%;" src=/icons/greptweet_birdie.svg>
<h1>404 error <?php echo $_SERVER["REQUEST_URI"]; ?></h1>

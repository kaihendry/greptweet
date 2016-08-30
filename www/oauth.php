#!/usr/bin/env php
<?php

if (empty($argv[1])) { exit(1); }
$urlargs = $argv[1];

function fetch($query){
	$url = "https://api.twitter.com/1.1/statuses/user_timeline.json?";
	$headers = array(
		"GET /1.1/statuses/user_timeline.json?".$query." HTTP/1.1",
		"Host: api.twitter.com",
		"Authorization: Bearer ".getenv('access_token')."",
	);
	$ch = curl_init();  // setup a curl
	curl_setopt($ch, CURLOPT_URL, $url.$query);  // set url to send to
	curl_setopt($ch, CURLOPT_HTTPHEADER, $headers); // set custom headers
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); // return output
	curl_setopt($ch, CURLOPT_HEADER, true);
	$content = curl_exec($ch);
	list($header, $json) = explode("\r\n\r\n", $content, 2);
	curl_close($ch);

	file_put_contents('php://stderr', $header . "\n\n");

	// No results returned, Twitter API issue
	if (strlen($json) == 2) { exit(1); };

	return $json;

}

print fetch($urlargs); //  search for the work 'test'
?>

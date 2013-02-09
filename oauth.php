#!/usr/bin/env php
<?php

if (empty($argv[1])) { exit(1); }

$urlargs = $argv[1];
parse_str($urlargs, $merge_to_oauth);

function buildBaseString($baseURI, $method, $params) {
    $r = array();
    ksort($params);
    foreach($params as $key=>$value){
        $r[] = "$key=" . rawurlencode($value);
    }
    return $method."&" . rawurlencode($baseURI) . '&' . rawurlencode(implode('&', $r));
}

function buildAuthorizationHeader($oauth) {
    $r = 'Authorization: OAuth ';
    $values = array();
    foreach($oauth as $key=>$value)
        $values[] = "$key=\"" . rawurlencode($value) . "\"";
    $r .= implode(', ', $values);
    return $r;
}

$url = "https://api.twitter.com/1.1/statuses/user_timeline.json";

// Get $oauth_access_token, $oauth_access_token_secret, $consumer_key, $consumer_secret
include("secret.php");

$oauth = array( 'oauth_consumer_key' => $consumer_key,
                'oauth_nonce' => time(),
                'oauth_signature_method' => 'HMAC-SHA1',
                'oauth_token' => $oauth_access_token,
                'oauth_timestamp' => time(),
                'oauth_version' => '1.0');

$oauth = array_merge($oauth, $merge_to_oauth);

$base_info = buildBaseString($url, 'GET', $oauth);
$composite_key = rawurlencode($consumer_secret) . '&' . rawurlencode($oauth_access_token_secret);
$oauth_signature = base64_encode(hash_hmac('sha1', $base_info, $composite_key, true));
$oauth['oauth_signature'] = $oauth_signature;

// Make Requests
$header = array(buildAuthorizationHeader($oauth), 'Expect:');


$feed = curl_init();
$options = array( CURLOPT_HTTPHEADER => $header,
				  CURLOPT_URL => $url . '?'. $urlargs,
				  CURLOPT_HEADER => true,
				  CURLOPT_RETURNTRANSFER => true,
				  CURLOPT_SSL_VERIFYPEER => false);

curl_setopt_array($feed, $options);
$content = curl_exec($feed);
list($header, $json) = explode("\r\n\r\n", $content, 2);
curl_close($feed);

file_put_contents('php://stderr', $header . "\n\n");

// No results returned, Twitter API issue
if (strlen($json) == 2) { exit(1); };

echo $json;
// $twitter_data = json_decode($json);
// print_r ($twitter_data);

?>

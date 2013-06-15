#!/usr/bin/env php
<?php
$json_string = file_get_contents("php://stdin");
$foo = json_decode($json_string);
for ($i=0; $i<count($foo); $i++){
    echo $foo[$i]->id_str . "|";
    echo $foo[$i]->created_at . "|";
    $tweet = $foo[$i]->text;
	if (!empty($foo[$i]->entities->urls)) {
		foreach($foo[$i]->entities->urls as $u) {
		//print_r($u->url);
		////print_r($u->expanded_url);
		$tweet = str_replace($u->url,$u->expanded_url,$tweet);
	}
	}
	if (!empty($foo[$i]->entities->media)) {
		foreach($foo[$i]->entities->media as $m) {
		//print_r($u->url);
		////print_r($u->expanded_url);
		$tweet = str_replace($m->url,$m->media_url,$tweet);
	}
	}
	echo $tweet . "\n";
}
//print_r($foo);
//$pp = json_encode($foo, JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES);
//echo $pp;
?>

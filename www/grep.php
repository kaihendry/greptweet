<?php
header('Content-type: application/json');
if (empty($_GET['q'])) { die(); }

// Is this the correct way to sanitise args to shell from PHP?
$QUERY=escapeshellarg($_GET['q']);

// Debug Logging
//$fp = fopen('debug.log', 'a');
//fwrite($fp, $_GET['q'] . " : " . $QUERY . "\n");
//fclose($fp);

exec("zgrep -Fhi $QUERY tweets.txt", $array);
$data = json_encode($array);
echo $_GET['jsoncallback'] . '(' . $data . ');';
?>

<?php
header('Content-type: application/json');
if (empty($_GET['q'])) { die(); }

// Is this the correct way to sanitise args to shell from PHP?
$QUERY=escapeshellarg($_GET['q']);

// Debug Logging
//$fp = fopen('debug.log', 'a');
//fwrite($fp, $_GET['q'] . " : " . $QUERY . "\n");
//fclose($fp);

exec("gunzip -c tweets.txt.gz | grep -Fhi $QUERY", $array);
$data = json_encode($array);
echo $_GET['jsoncallback'] . '(' . $data . ');';
?>

<?
if (empty($_GET['q'])) { die(); }
$QUERY=urldecode(escapeshellarg(urlencode($_GET['q'])));
//$fp = fopen('debug.log', 'a');
//fwrite($fp, $_GET['q'] . " : " . $QUERY . "\n");
//fclose($fp);
exec("grep -hi $QUERY *.txt", $array);
$data = json_encode($array);
echo $_GET['jsoncallback'] . '(' . $data . ');';
?>

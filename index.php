<!DOCTYPE HTML>
<html><head>
<meta charset="utf-8">
<title>GrepTweet</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="format-detection" content="telephone=no">
<link rel="icon" href="/favicon.ico">
<meta name="description" content="Download and search your tweets - no password login required!">
<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" href="/bootstrap/css/bootstrap-theme.min.css">

</head>

<body>

<div class="container">


<div class="content">
<div class="page-header">
<h1><a href="http://twitter.com/greptweet">@Greptweet</a> <small>you can search your tweets</small></h1>
</div>

<form name="f" action="create.php" method="get">

<div class="well">

<div class="clearfix">
<label for="username">Twitter username</label>

<div class="input-group input-group-lg">
<span class="input-group-addon">@</span>
<input class="form-control" id="username" type="text" name="id" required placeholder="kaihendry">
</div>

<div class="input">
</div>
</div>

<button class="btn btn-primary btn-lg" id="b" onclick="submitPressed()">Fetch tweets</button>
</div>

</form>

<footer>
<p>Please <a href="https://github.com/kaihendry/Greptweet">report issues and contribute on Github</a> :)</p>
<p><span class="label-danger label">Move to nginx</span> To fix <a href="https://github.com/kaihendry/greptweet/issues/43">#43</a>, I have moved greptweet to a new ext4 based server running nginx. When creating a new account, nginx will timeout on long running processes. The fetch should still work, but we need to refactor the UX.</p>
<p>Version: <a href=https://github.com/kaihendry/Greptweet/commit/<?php include("version.txt"); ?>>
<?php include("version.txt"); ?>
</a></p>
</footer>

</div>
</div>


</body>
</html>

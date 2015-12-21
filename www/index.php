<!DOCTYPE HTML>
<html><head>
<meta charset="utf-8">
<title>GrepTweet</title>
<meta name=viewport content="width=device-width, initial-scale=1">
<meta name="mobile-web-app-capable" content="yes">
<meta name="format-detection" content="telephone=no">
<meta name="apple-mobile-web-app-title" content="GrepTweet">
<link rel=icon href=/icons/greptweet_birdie.png sizes="500x500" type="image/png">
<link rel=icon href=/icons/greptweet_birdie.svg sizes="any" type="image/svg+xml">
<link href="/icons/120x120.png" sizes="120x120" rel="apple-touch-icon">
<meta name="description" content="Download and search your tweets - no password login required!">
<link href="/style.css" rel="stylesheet">
</head>

<body>

<h1><a href="http://twitter.com/greptweet">@Greptweet</a> <small>you can search your tweets</small></h1>

<form name="f" action="create.php" method="get">
<label for="username">Twitter username</label>
<input id="username" type="text" name="id" autofocus required placeholder="kaihendry">

<button class="btn btn-primary btn-lg" id="b" type="submit">Fetch tweets</button>
</form>

<footer>
<p><a href=tut-video.html>Tutorial screencast</a></p>
<p>Version: <a href=https://github.com/kaihendry/Greptweet/commit/<?php include("version.txt"); ?>>
<?php include("version.txt"); ?>
</a></p>
</footer>

</body>
</html>

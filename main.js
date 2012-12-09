var l = []; // avoid expensive $.get for local searches
function search(query, lines) {
	var results = "<p class=\"label\">Searched for: " + query + "</p><ol>";
	for (var i = 0; i < lines.length; i++) {
		tweet = lines[i].split('|');
		var re = new RegExp(query, 'i');

		if (tweet.length == 2) {
			if (tweet[1].match(re)) {
				results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(1) + "</a></li>";
			}
		} else {
			if (tweet[2] !== undefined && tweet[2].match(re)) {
				results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(2) + "</a></li>";
			}
		}

	}
	$('#results').prepend(results + "</ol>");
}

function grep(query) {

	if (typeof applicationCache !== 'undefined' && applicationCache.status == 1) {

		// If we have a cache, lets do this locally
		console.log("Using applicationCache");
		if (l.length > 0) {
			search(query, l);
		} else {
			$.get('tweets.txt', function(data) {
				l = data.split("\n");
				search(query, l);
			});
		}

	} else {

		// Client doesn't support appcache or it's not in sync, so lets search on the server
		console.log("Using grep.php");
		$.getJSON("/u/" + NAME + "/grep.php?jsoncallback=?", {
			q: query
		},
		function(data) {
			search(query, data);
		}).error(function(x) { console.log("AJAX JSON-P error: ", x); });

	}
}

$(document).ready(function() {

	NAME = window.location.pathname.split('/')[2];
	$("#name").html(NAME);

	appletouchicon = document.createElement('link');
	appletouchicon.setAttribute("rel", "apple-touch-icon");
	appletouchicon.setAttribute("href", "https://api.twitter.com/1/users/profile_image?screen_name=" + NAME + "&size=bigger");
	document.getElementsByTagName("head")[0].appendChild(appletouchicon);

	$("input[type=search]").change(function() {
		query = this.value;
		window.location.hash = query;
	});

	if (window.location.search || window.location.hash) {
		if (!window.location.hash) {
			window.location.hash = window.location.search.substr(1);
		}
		searchquery = window.decodeURIComponent(window.location.hash.substr(1));
		$("input[type=search]").val(searchquery);
		grep(searchquery);
	}

	$("input[type=text]").focus();

	footer = '<p><a href="' + NAME + '.txt" class="btn primary"><i class="icon-download"></i> Download</a>';
	footer += '<a href="' + "/f/" + NAME + '" class="btn"><i class="icon-refresh"></i> Update</a></p>';
	$("#source").html(footer);
	document.title = NAME;

	document.cookie = 'u=' + NAME + '; expires=Thu, 2 Aug 2021 20:47:11 UTC; path=/';
	$("#home").click(function() {
		document.cookie = 'u=' + NAME + '; expires=Thu, 2 Aug 2001 20:47:11 UTC; path=/';
	});

});

$(window).bind('hashchange', function() {
		console.log("Hash change: ", window.location.hash);
		searchquery = window.location.hash.substr(1);
		$("input[type=search]").val(searchquery);
		grep(searchquery);
});

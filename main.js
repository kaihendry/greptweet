var l = []; // avoid expensive $.get
function search(query, lines) {
	var results = "<p class=\"label\">Searched for: " + query + "</p><ol>";
	for (var i = 0; i < lines.length; i++) {
		tweet = lines[i].split('|');
		var re = new RegExp(query, 'i');

		switch (tweet.length)
		{
			case 3:
			if (tweet[2].match(re)) {
				results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(2) + "</a></li>";
			}
			break;
			case 2:
			if (tweet[1].match(re)) {
				results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(1) + "</a></li>";
			}
			break;
			default:
				console.log('ODD: ' + tweet);
		}

	}
	$('#results').prepend(results + "</ol>");
}

function grep(query) {

	if (navigator.onLine) {

		$.getJSON("/u/" + NAME + "/grep.php?jsoncallback=?", {
			q: query
		},
		function(data) {
			console.log("from grep.php: " + data);
			search(query, data);
		});

	} else {

		if (l.length > 0) {
			search(query, l);
		} else {
			$.get('tweets.txt', function(data) {
				l = data.split("\n");
				search(query, l);
			});
		}

	}
}

$(document).ready(function() {

	NAME = window.location.pathname.split('/')[2];
	$("#name").html(NAME);

	$("input[type=search]").change(function() {
		query = this.value;
		// TODO: APPCACHE BUG
		// window.location.search = query; // Triggers Reload the page to get source for: http://greptweet/u/kaihendry/?food
		grep(query);
	});

	if (window.location.search) {
		searchquery = window.decodeURIComponent(window.location.search.substr(1));
		$("input[type=search]").val(searchquery);
		grep(searchquery);
	}

	$("input[type=text]").focus();

	footer = '<p><a href="' + NAME + '.txt" class="btn primary"><i class="icon-download"></i> Download</a>';
	footer += '<a href="' + "/create.cgi?id=" + NAME + '" class="btn"><i class="icon-refresh"></i> Update</a></p>';
	$("#source").html(footer);
	document.title = "Greptweet " + NAME;

	document.cookie = 'u=' + NAME + '; expires=Thu, 2 Aug 2021 20:47:11 UTC; path=/';
	$("#home").click(function() {
		document.cookie = 'u=' + NAME + '; expires=Thu, 2 Aug 2001 20:47:11 UTC; path=/';
	});

});


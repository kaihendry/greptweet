function grep(query) {

	if (navigator.onLine) {

		$.getJSON("/u/" + NAME + "/grep.php?jsoncallback=?", {
			q: query
		},
		function(data) {
			var results = "<p class=\"label\">Searched for: " + query + "</p><ol>";
			for (var i in data) {
				tweet = data[i].split('|');
				if (tweet.length > 2) {
					results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(2) + "</a></li>"; // With datetime
				} else {
					results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(1) + "</a></li>"; // Old style
				}
			}
			$('#results').prepend(results + "</ol>");
		});

	} else {

if (! lines)  {
		$.get('tweets.txt', function(data) {
			lines = data.split("\n");
		});
}

			var results = "<p class=\"label\">Searched for: " + query + "</p><ol>";
			for (var i = 0; i < lines.length - 1; i++) {
				tweet = lines[i].split('|');
				var re = new RegExp(query, 'i');
				if (tweet[2].match(re)) {
					results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet.slice(2) + "</a></li>";
				}
			}
			$('#results').prepend(results + "</ol>");


	}
}

	$(document).ready(function() {

		NAME = window.location.pathname.split('/')[2];
		$("#name").html(NAME);

		$("input[type=search]").change(function() {
			query = this.value;
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


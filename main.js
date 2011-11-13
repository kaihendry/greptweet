function grep(query) {

	$.getJSON("/u/" + NAME + "/grep.php?q=" + query + "&jsoncallback=?", function(data) {
		var results = "<p>Searched for: " + query + "</p><ol>";
		for (i in data) {
			// TODO, fix bug: https://twitter.com/#!/pixelbeat_/status/5120018968
			tweet = data[i].split('|');
			if (tweet.length > 2) {
			results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet[2] + "</a></li>"; // With datetime
			} else {
			results += "<li><a href=\"http://twitter.com/" + NAME + "/status/" + tweet[0] + "\">" + tweet[1] + "</a></li>"; // Old style
			}
		}
		$('#results').prepend(results + "</ol>");
	});

}

$(document).ready(function() {

	NAME = window.location.pathname.split('/')[2];

	$("input[type=text]").change(function() {
		query = this.value;
		window.location.search = query;
		grep(query);
	});

	if (window.location.search) {
		searchquery = window.decodeURIComponent(window.location.search.substr(1));
		$("input[type=text]").val(searchquery);
		grep(searchquery);
	}

	$("input[type=text]").focus();

	$("#source").html("<a href=\"" + NAME + "\.txt\">" + NAME + " simple text backup file</a>");

});


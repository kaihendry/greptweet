function grep(query) {

	$.getJSON("/u/" + NAME + "/grep.php?jsoncallback=?", { q: query }, function(data) {
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

}

$(document).ready(function() {

	NAME = window.location.pathname.split('/')[2];
	$("#name").html(NAME);

	$("input[type=search]").change(function() {
		query = this.value;
		console.log(query);
		window.location.search = query;
		grep(query);
	});

	if (window.location.search) {
		searchquery = window.decodeURIComponent(window.location.search.substr(1));
		$("input[type=search]").val(searchquery);
		grep(searchquery);
	}

	$("input[type=text]").focus();

	footer = '<p><a href="' + NAME + '.txt" class="btn primary"><i class="icon-download"></i> Download</a>';
	footer += '<a href="' + "/create.cgi?id=" + NAME +'" class="btn"><i class="icon-refresh"></i> Update</a></p>'
	$("#source").html(footer);
	document.title = "Greptweet " + NAME;

});


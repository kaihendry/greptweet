function massage() {
	humane.timeout = 5000;
	humane("Please wait...");
	humane("Still loading...");
}

function submitPressed() {
	if (document.forms.f.checkValidity()) {
		b = document.getElementById("b");
		b.disabled = true;
		massage();
		document.forms.f.submit();
	}
}


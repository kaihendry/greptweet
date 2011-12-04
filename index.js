function submitPressed() {
	if (document.forms.f.checkValidity()) {
		$("#b").button('loading');
		document.forms.f.submit();
	}
}

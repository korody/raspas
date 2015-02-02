$( document ).on('ready page:load', function() {
	$('#user_email').remoteValidate({
		url: '/validate',
		attribute: 'email',
	});

	$('#user_display_username').remoteValidate({
		url: '/validate',
		attribute: 'display_username',
	});
});

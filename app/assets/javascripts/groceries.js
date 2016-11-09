document.addEventListener("turbolinks:load", function() {
	$('[data-toggle="popover"]').popover();
	
	$('.edit_list input[type=submit]').remove();
	$('.edit_list input[type=checkbox]').click(function() {
			$(this).parent('form').submit();
	});
});

$(function() {
	$('.edit_list input[type=submit]').remove();
	$('.edit_list input[type=checkbox]').click(function() {
			$(this).parent('form').submit();
	});
});

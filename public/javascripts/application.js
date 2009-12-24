$(function() {
	$('.comment_message').each(function(i, comment_message){
		comment_message = $(comment_message);
		console.log(comment_message);
		comment_message.focus(function(){
			if (!comment_message.hasClass("activate")) {
					comment_message.addClass("activate").animate({height:"120px"}, 200, null, function(){
						comment_message.get(0).select();
					});
			}
			return true;
		});
	});	
});

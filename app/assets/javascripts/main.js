$( document ).ready(function() {
	$("#email_users_search").on("ajax:success", function(e, data, status, xhr){
	  var email_search = $(this).parent(".email_search");
	  email_search.find('.result').show();
	  if(data && data["user"]) {
		$('.result').html("<b>"+data['user']['name']+"</b> "+"("+data['user']['email']+")");
	  	if(!data["can_be_invited"]){
	  		$('.result').append("<p>Этот пользователь не может быть приглашен</p>")
	  	}
	  	else {
		  	var inv = email_search.children(".invitation");
		  	inv.show();
		  	inv.find('#invitation_user_id').val(data['user']['id']);
	  	}
	  }
	  else {
	  	$('.result').html('Пользователь не найден');
	  }
	});

	// $("div#update_city ul li a").click(function(e){
	// 	div = $(this).closest("div");
 //    $.ajax({
 //        type: div.data("method"),
 //        url: div.data("action"),
 //        data: { "city_id": $(this).data("value") },
 //        success: function(data){}
 //    });            
	// });

	addFormDropdown("div#update_city");

	function addFormDropdown(selector, successFunction){
		el = $(selector);
		if(el.data("action")){
			dataString = el.find("ul").data("name") + "=";
			method = el.data("method") || "post";
			el.find('a').click(function(e){
				e.preventDefault();
		    $.ajax({
		        type: method,
		        url: el.data("action"),
		        data: dataString + $(this).data("value"),
		        success: successFunction
		    });            
			});
		}
	}

});
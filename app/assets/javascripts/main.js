$( document ).ready(function() {
	$('a.disabled').click(function(e){
		e.preventDefault();
		e.stopPropagation();
	})


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

	addFormDropdown("div#update_city");
	addFormLink("a.get_teams_list", displayTeamsList);

	function displayTeamsList(data){
		console.log(data);
		var modalBody = 'Пока нет команд';
		if(data.length > 0){
			modalBody = $.map(data, function(val, i){
				return (i+1) + ". " + val.name;
			}).join("<br>");
		}
		$('#teams_list').find('.modal-body').html(modalBody);
	}

	function addFormLink(selector, successFunction){	
		$(selector).click(function(e){
			el = $(this);
			if(el.data("action")){
				dataString = el.data("name") + "=";
				method = el.data("method") || "get";
		    $.ajax({
	        type: method,
	        url: el.data("action"),
	        data: dataString + $(this).data("value"),
	        success: successFunction
		    });            
			}
		});
	}

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
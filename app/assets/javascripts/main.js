$( document ).ready(function() {
	$('a.disabled').click(function(e){
		e.preventDefault();
		e.stopPropagation();
	})


	$('.start_edit').on('click', function(e){
		e.preventDefault();
		var editable = $(this).parent().find('.editable');
		editable.attr('contenteditable', 'true');
		var range = document.createRange();
		var sel = window.getSelection();
		var pos = editable.text().length;
		range.setStart(editable[0].childNodes[0], pos);
		range.collapse(true);
		sel.removeAllRanges();
    sel.addRange(range);
    editable[0].focus();
	});

	$('.editable').keydown(function(event){
		if(event.keyCode == 13){
			event.preventDefault();
			var editable = $(this);
			editable.attr('contenteditable', 'false');
			editable.data('');

			if(editable.data("action")){
				dataString = editable.data("name") + "=";
				method = editable.data("method") || "put";
		    $.ajax({
	        type: method,
	        url: editable.data("action"),
	        data: dataString + editable.text(),
	        success: function(){}
		    });            
			}
		}
	});

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

	$(".remove_member").on("ajax:success", function(e, data, status, xhr){
		$('#member_' + data['member']['id']).remove();
	});

	$(".remove_invitation").on("ajax:success", function(e, data, status, xhr){
		$('#invitation_' + data['invitation']['id']).remove();
	});

	addFormDropdown("div#update_city");
	addFormDropdown("div#games_filter");
	addFormLink("a.get_teams_list", displayTeamsList);

	function displayTeamsList(data){
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

	// function addFormDropdown(selector, successFunction){
	// 	el = $(selector);
	// 	if(el.data("action")){
	// 		dataString = el.find("ul").data("name") + "=";
	// 		method = el.data("method") || "post";
	// 		el.find('a').click(function(e){
	// 			e.preventDefault();
	// 	    $.ajax({
	// 	        type: method,
	// 	        url: el.data("action"),
	// 	        data: dataString + $(this).data("value"),
	// 	        success: successFunction
	// 	    });            
	// 		});
	// 	}
	// }


	function addFormDropdown(selector, successFunction){		
		$(selector).find('a').click(function(e){
			el = $(selector);
			method = el.data("method") || "post";
			e.preventDefault();
			clicked_link = $(this);
			clicked_link_ul = clicked_link.parents('ul');
			el = clicked_link.parents(selector).first();
			if(el.data("action")){
				dataString = [clicked_link_ul.data('name') + '=' + clicked_link.data('value')];
				el.find("ul").not(clicked_link_ul).each(function(){
					dataString.push($(this).data('name') + '=' + $(this).parent().find('span').data('current-value'));
				});
				$.ajax({
	        type: method,
	        url: el.data("action"),
	        data: dataString.join('&'),
	        success: successFunction
		    });
			}
		});
	}

	$('.modal').on('show.bs.modal', function () {
    if ($(document).height() > $(window).height()) {
      // no-scroll
      $('body').addClass("modal-open-noscroll");
    }
    else { 
      $('body').removeClass("modal-open-noscroll");
    }
  });

  $('.modal').on('hide.bs.modal', function () {
      $('body').removeClass("modal-open-noscroll");
  });

  var cb = new Clipboard('#copy_button');
  cb.on('success', function(event) {
  	$(event.trigger).attr('disabled', true)
    event.trigger.textContent = 'Скопировано';
    window.setTimeout(function() {
        event.trigger.textContent = 'Копировать';
        $(event.trigger).attr('disabled', false)
    }, 2000);
});

});
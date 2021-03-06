
$( document ).ready(function() {
	$('a.disabled').click(function(e){
		e.preventDefault();
		e.stopPropagation();
	})

	$('[data-toggle="tab"],[data-toggle="pill"]').click(function() {
	    $(this).parent().children('.active[data-toggle="tab"],.active[data-toggle="pill"]').removeClass('active');
	    $(this).addClass('current');
	});
	$('.start_edit').on('click', function(e){
		e.preventDefault();
		$(this).toggle();
		$(this).parent().find('.save').toggle();
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
	$('.save').on('click', function(e){
		e.preventDefault();
		var editable = $(this).parent().find('.editable');
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
		$(this).toggle();
		$(this).parent().find('.start_edit').toggle();
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

	$(".make_boatswain").on("ajax:success", function(e, data, status, xhr){
		$('.faceParth .boatswain').removeClass('boatswain');
		$('#member_' + data['member']['id'] + ' p').addClass('boatswain');
		$('#member_' + data['member']['id'] + ' p')
	});

	$(".make_captain").on("ajax:success", function(e, data, status, xhr){
		$('.faceParth .captain').removeClass('captain');
		$('#member_' + data['member']['id'] + ' p').addClass('captain');
		$('#member_' + data['member']['id'] + ' p')
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

	var edit_form = $('#edit_user');
	if(edit_form.length > 0){
		fields_for_confirmation = ["user_email", "user_password"];
		var email = edit_form.find('#user_email').val();
		$('#edit_user').on('keyup', '#user_email', function(){
			var form = $(this).parents('form');
			var passes = form.find('.email_changed');
			if($(this).val() != email){
				passes.slideDown('fast');
				passes.find('input').attr('required', true);
			}
			else if(!$("#user_password").val()){
				passes.slideUp('fast');
				passes.find('input').removeAttr('required');
				passes.find('input').val('');
			}
		});
		$('#edit_user').on('keyup', '#user_password', function(){
			var form = $(this).parents('form');
			var passes = form.find('.password_changed');
			if($(this).val()){
				passes.slideDown('fast');
				passes.find('input').attr('required', true);
			}
			else if($("#user_email").val() == email ){
				passes.slideUp('fast');
				passes.find('input').removeAttr('required');
				passes.find('input').val('');
			}
			else{
				passes = passes.not('.email_changed');
				passes.slideUp('fast');
				passes.find('input').removeAttr('required');
				passes.find('input').val('');
			}
		});
	}
	$('.center').slick({
	  centerMode: true,
	  centerPadding: '60px',
	  slidesToShow: 3,
	  slidesToScroll: 1,
	  responsive: [
	    {
	      breakpoint: 768,
	      settings: {
	        arrows: false,
	        centerMode: true,
	        centerPadding: '40px',
	        slidesToShow: 3
	      }
	    },
	    {
	      breakpoint: 480,
	      settings: {
	        arrows: false,
	        centerMode: true,
	        centerPadding: '40px',
	        slidesToShow: 1
	      }
	    }
	  ]
	});

	function showFile(e) {
		// console.log('e', e);
    	var files = e.target.files;
    	// console.log('files', files);
	    for (var i = 0; i<1;  i++) {
	    	var f = files[i];
	   	  console.log(f);
	   	  console.log(f.type.match('image.*'));
	      if (!f.type.match('image.*')) continue;
	      var fr = new FileReader();
	      fr.onload = (function(theFile) {
	        return function(e) {
	          $('.add-image').html("");
	          $('.avatarWrap').css({'background-image': 'url(' + e.target.result + ')','border':'3px dashed transparent'});
	        };
	      })(f);

	      fr.readAsDataURL(f);
	    }
  	}


	$( "#user_avatar" ).change(function(event) {
		showFile(event);
	});

});

var a2a_config = a2a_config || {};
a2a_config.locale = "ru";

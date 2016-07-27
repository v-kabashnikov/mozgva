$ ->
  $("form#sign_up_user").find("input[type=submit]").click( (event) ->
    error_messages = [];
    form = $(this).parents('form').first();
    if(form.find('#user_name').val().length > 0 && form.find('#user_email').val().length > 0 )
      event.preventDefault();
      if(!form.find("#user_pers_agree").prop( "checked" ))
        console.log(1)
        error_messages.push "Вы должны согласиться с обработкой персональных данных"
      if(!form.find("#user_user_agree").prop( "checked" ))
        console.log(2)
        error_messages.push "Вы должны согласиться с пользовательским соглашением"
      console.log(error_messages)
      if error_messages.length > 0
        msg = "<div class='alert alert-danger pull-left text-left'>" + error_messages.join('<br>') + "</div>";
        form.parents('.modal').find('.modal-footer').html(msg)
      else
        form.submit();
  )
  $("form#sign_in_user, form#sign_up_user").bind("ajax:success", (event, xhr, settings) ->
    window.location = '/'
  ).bind("ajax:error", (event, xhr, settings, exceptions) ->
    $(".error_label").remove();
    $(this).children(".input_wrapper").removeClass("has_error");
    error_messages = [];
    if xhr.responseJSON['error']      
      error_messages = "<div class='alert alert-danger pull-left text-left'>" + xhr.responseJSON['error'] + "</div>"
    else if xhr.responseJSON['errors']
      form = $(this);
      $.each(xhr.responseJSON["errors"], (v, k) ->
        el = form.find("#user_" + v).parent(".input_wrapper").first();
        el.addClass("has_error");
        el.prepend('<label class="error_label">' + k + '</label>');
      )
    else
      "<div class='alert alert-danger pull-left'>Unknown error</div>"
    $(this).parents('.modal').find('.modal-footer').html(error_messages)
  )
$ ->
  $("#send_confirmation_form,#check_confirmation_form").submit(()->
    clear_errors($(this).parents('.modal'))
  )
  $("#send_confirmation_form").bind("ajax:success", (event, xhr, settings) ->
    $(this).find('#user_phone').val(xhr["user"]["phone"])
    $(this).find('input[type=submit]').slideUp()
    $(this).parents('.modal-body').find('#check_confirmation').slideDown('fast')
  ).bind("ajax:error", (event, xhr, settings, exceptions) ->
    # $(".error_label").remove();
    # $(this).children(".input_wrapper").removeClass("has_error");
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
  $("#check_confirmation_form").bind("ajax:success", (event, xhr, settings) ->
    $(this).parents('#phone_confirmation').modal('hide')
    $('#team_modal').modal('show')
  ).bind("ajax:error", (event, xhr, settings, exceptions) ->
    error_messages = [];
    if xhr.responseJSON['error']      
      error_messages = "<div class='alert alert-danger pull-left text-left'>" + xhr.responseJSON['error'] + "</div>"
    else if xhr.responseJSON['errors']
      form = $(this);
      $.each(xhr.responseJSON["errors"], (v, k) ->
        el = form.find('#' + v).parent(".input_wrapper").first();
        el.addClass("has_error");
        el.prepend('<label class="error_label">' + k + '</label>');
      )
    else
      "<div class='alert alert-danger pull-left'>Unknown error</div>"
    $(this).parents('.modal').find('.modal-footer').html(error_messages)
  )
  $('#fix_phone').click( (event) ->
    event.preventDefault()
    $(this).parents('#check_confirmation').slideUp('fast')
    $('#send_confirmation_form').find('input[type=submit]').slideDown()
    clear_errors($(this).parents('.modal'))
    $(this).parents('#check_confirmation_form').find('#code').val('')
  )

  clear_errors = (modal)->
    modal.find(".error_label").remove()
    modal.find(".input_wrapper").removeClass("has_error")
    modal.find(".modal-footer .alert").remove()
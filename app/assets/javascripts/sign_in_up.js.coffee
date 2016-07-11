$ ->
  $("form#sign_in_user, form#sign_up_user").bind("ajax:success", (event, xhr, settings) ->
    window.location = '/'
  ).bind("ajax:error", (event, xhr, settings, exceptions) ->
    $(".error-label").remove();
    $(this).children(".form-group").removeClass("has-error has-feedback");
    error_messages = [];
    if xhr.responseJSON['error']      
      error_messages = "<div class='alert alert-danger pull-left alert-m'>" + xhr.responseJSON['error'] + "</div>"
    else if xhr.responseJSON['errors']
      form = $(this);
      $.each(xhr.responseJSON["errors"], (v, k) ->
        el = form.find("#user_" + v).parent(".form-group").first();
        el.addClass("has-error has-feedback");
        el.prepend('<label class="control-label error-label">' + k + '</label>');
      )
    else
      "<div class='alert alert-danger pull-left alert-m'>Unknown error</div>"
    $(this).parents('.modal').find('.modal-footer').html(error_messages)
  )
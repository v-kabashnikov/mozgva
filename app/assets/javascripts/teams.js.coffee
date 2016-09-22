$ ->
  show_errors = (event, xhr, settings, exceptions) ->
    $(".error-label").remove();
    $(this).children(".form-group").removeClass("has-error has-feedback");
    msg = '';
    if(xhr.responseJSON['error'])
      msg = "<div class='alert alert-danger pull-left text-left'>" + xhr.responseJSON['error'] + "</div>"
    else if xhr.responseJSON['errors']      
      msg = "<div class='alert alert-danger pull-left text-left'>" + xhr.responseJSON['errors'].join('<br>') + "</div>"
    else
      msg = "<div class='alert alert-danger pull-left'>Unknown error</div>"
    $(this).parents('.modal').find('.modal-footer').html(msg)

  hide_errors = (selector) ->
    $(selector).children(".error-label").remove()
    $(selector).children(".form-group").removeClass("has-error has-feedback")
    $(selector).parents(".modal").find('.modal-footer').html('')

  $("form#new_team").bind("ajax:success", (event, xhr, settings) ->
    window.location = '/team'
  ).bind("ajax:error", show_errors)
  $("form.edit_team").bind("ajax:success", (event, xhr, settings) ->
    $("#team_name_header").html(xhr['team']['name'])
    $("#team_modal").modal('hide')
  ).bind("ajax:error", show_errors)

  $("#take_team_form").on('click', 'input[type=submit]', (e) ->
    $(this).parents().find('.warning_text').hide()
    hide_errors("#take_team_form")
    if $(this).hasClass('need_confirmation')
      e.preventDefault()
      $(this).parents().find('.warning_text').show()
      $(this).removeClass('need_confirmation')
  );

  $("#take_team_form").bind("ajax:success", (event, xhr, settings) ->
    location.reload();
  ).bind("ajax:error", show_errors)
  
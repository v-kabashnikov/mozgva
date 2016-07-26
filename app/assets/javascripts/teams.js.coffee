$ ->
  show_errors = (event, xhr, settings, exceptions) ->
    $(".error-label").remove();
    $(this).children(".form-group").removeClass("has-error has-feedback");
    msg = '';
    if xhr.responseJSON['errors']      
      msg = "<div class='alert alert-danger pull-left text-left'>" + xhr.responseJSON['errors'].join('<br>') + "</div>"
    else
      msg = "<div class='alert alert-danger pull-left'>Unknown error</div>"
    $(this).parents('.modal').find('.modal-footer').html(msg)

  $("form#new_team").bind("ajax:success", (event, xhr, settings) ->
    window.location = '/team'
  ).bind("ajax:error", show_errors)
  $("form.edit_team").bind("ajax:success", (event, xhr, settings) ->
    $("#team_name_header").html(xhr['team']['name'])
    $("#team_modal").modal('hide')
  ).bind("ajax:error", show_errors)
  
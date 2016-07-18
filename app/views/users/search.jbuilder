json.user @user
json.can_be_invited @user.can_be_invited?(current_user.team) if @user

class MembersController < ApplicationController
  def destroy
    if !current_user.member.captain?
      member = Member.find(params[:id])
      this_member = current_user.member
      member.destroy
      if this_member == member
        redirect_to root_url
      else
        render json: { status: :ok, member: { id: member.id } }
      end
    else
      redirect_to my_team_url
    end
  end

  def set_boatswain
    member = Member.find(params[:id])
    if current_user.member.team_role == 'captain' && current_user.member.team == member.team
      member.team.members.where(team_role: 'boatswain').update(team_role: nil)
      member.update(team_role: 'boatswain')
      render json: { status: :ok, member: { id: member.id } }
    end
  end

  def set_captain
    member = Member.find(params[:id])
    if current_user.member.team_role == 'captain' && current_user.member.team == member.team
      member.team.members.where(team_role: 'captain').update(team_role: nil)
      member.update(team_role: 'captain')
      redirect_to my_team_url
    end
  end

end

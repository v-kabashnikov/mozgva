class MembersController < ApplicationController
  def destroy
    member = Member.find(params[:id])
    member.destroy
    render json: { status: :ok, member: { id: member.id } }
  end

  def set_boatswain
    member = Member.find(params[:id])
    if current_user.member.team_role == 'captain' && current_user.member.team == member.team
      member.team.members.where(team_role: 'boatswain').update(team_role: nil)
      member.update(team_role: 'boatswain')
      render json: { status: :ok, member: { id: member.id } }
    end
  end
end

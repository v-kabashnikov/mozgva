class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [:invite_reg]
  before_action :set_invitation, only: [:accept, :decline, :destroy]

  def create
    inv = Invitation.create(invitation_params.merge(inviter: current_user, team: current_user.team))
    if inv.errors.present?
      flash[:errors] = inv.errors.messages
    end
    redirect_to :back
  end

  def accept
    current_user.accept @invitation
    redirect_to :back
  end

  def decline
    current_user.decline @invitation
    redirect_to :back
  end

  def destroy
    @invitation.destroy
    render json: { status: :ok, invitation: { id: @invitation.id } }
  end

  def invite_reg
    # team = Team.find_by(invite: params[:invite])
    # if team
    #   if current_user
    #     Member.create(user: current_user, team: team)
    #     redirect_to my_team_path
    #   else
    #     redirect_to new_user_registration_path(invite: params[:invite])
    #   end
    # else
    #   flash[:errors] = ['Неверный код инвайта']
    #   redirect_to new_user_registration_path
    # end
    # redirect_to new_user_registration_path(invite: params[:invite])
    redirect_to new_user_registration_path(invite: params[:invite])
  end

  private
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def invitation_params
    params[:invitation].permit(:user_id)
  end
end

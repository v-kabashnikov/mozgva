class InvitationsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_invitation, only: [:accept, :decline]

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

	private
	def set_invitation
		@invitation = Invitation.find(params[:id])
	end

	def invitation_params
		params[:invitation].permit(:user_id)
	end
end
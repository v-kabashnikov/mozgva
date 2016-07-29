class MemberController < ApplicationController
	def destroy
		member = Member.find(params[:id])
		member.destroy
		render json: { status: :ok, member: { id: member.id } }
	end
end
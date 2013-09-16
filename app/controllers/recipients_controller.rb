class RecipientsController < ApplicationController

	def index
		@recipients = Recipient.find(:all, :joins => [:team], :order => 'teams.name')
	end

	def new
		@recipient = Recipient.new
	end

	def create
		emails = params[:recipient][:email].split(",")
		team_id = params[:recipient][:team_id]

		emails.each do |email|
			Recipient.find_or_create_by_email(email: email.strip, team_id: team_id)
		end

		redirect_to root_path
	end
end
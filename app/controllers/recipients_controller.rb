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
		team_name = Team.find(team_id).name

		gb = Gibbon::API.new('a7ae9403bbec1533e0a67c0b46a08a12-us7')
		list_id = gb.lists.list({:filters => {:list_name => team_name}})["data"].first["id"]
		all_universities_list_id = gb.lists.list({:filters => {:list_name => "All Universities"}})["data"].first["id"]

		emails.each do |email|
			Recipient.find_or_create_by_email(email: email.strip, team_id: team_id)
			gb.lists.subscribe({:id => list_id, :email => {:email => email.strip}, :double_optin => false})
			gb.lists.subscribe({:id => all_universities_list_id, :email => {:email => email.strip}, :double_optin => false})
		end

		redirect_to root_path
	end
end
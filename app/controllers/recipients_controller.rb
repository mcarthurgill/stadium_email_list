class RecipientsController < ApplicationController

	def index
		@recipients = Recipient.find(:all, :joins => [:team], :order => 'teams.name')
	end

	def new
		@recipient = Recipient.new
	end

	def create
		emails = parse_for_emails_or_phone_numbers(params[:recipient][:email])
		team_id = params[:recipient][:team_id]
		team_name = Team.find(team_id).name

		gb = Gibbon::API.new('a7ae9403bbec1533e0a67c0b46a08a12-us7')
		gb.timeout = 5
		gb.throws_exceptions = false
		list_id = gb.lists.list({:filters => {:list_name => team_name}})["data"].first["id"]
		all_universities_list_id = gb.lists.list({:filters => {:list_name => "All Universities"}})["data"].first["id"]

		emails.each do |email|
			Recipient.find_or_create_by_email(email: email.strip.downcase, team_id: team_id)
			#gb.lists.subscribe({:id => list_id, :email => {:email => email.strip}, :double_optin => false})
			#gb.lists.subscribe({:id => all_universities_list_id, :email => {:email => email.strip}, :double_optin => false})
		end

		redirect_to root_path
	end


	protected
	def parse_for_emails_or_phone_numbers text

  	  if !text
    	return []
  	  end
      #explode string
	  text_array = text.split(
	    /\s*[,;]\s* # comma or semicolon, optionally surrounded by whitespace
	    |           # or
	    \s{1,}      # one or more whitespace characters
	    |           # or
	    [\r\n]+     # any number of newline characters
	    /x)

  	  new_array = []
	  text_array.each do |s|

  		#look at each string
  		s.downcase!
  		s = s.gsub(" ", "")
  		s = s.gsub(",", "")
  		s = s.gsub(";", "")
  		s = s.gsub("+", "")
  		s = s.gsub("-", "")
  		s = s.gsub("(", "")
  		s = s.gsub(")", "")
  		s = s.gsub("[", "")
  		s = s.gsub("]", "")
  		s = s.gsub("#", "")

  		if s =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  			new_array << s
  		elsif s.scan(/<([^<>]*)>/imu).flatten.count > 0
  			email_within = s.scan(/<([^<>]*)>/imu).flatten
  			email_within.each do |ew|
  				if ew =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  					new_array << ew
  				end
  			end
  		end

	  	end

	  	return new_array
	end

	
end
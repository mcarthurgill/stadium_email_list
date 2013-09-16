class Recipient < ActiveRecord::Base
	attr_accessible :email, :team_id
	belongs_to :team
end
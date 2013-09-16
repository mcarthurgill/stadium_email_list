module ApplicationHelper
	def team_names_and_values
		return_array = []
		Team.all.each do |team|
			return_array << [team.name, team.id]
		end
		return_array.sort
	end
end

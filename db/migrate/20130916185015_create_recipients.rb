class CreateRecipients < ActiveRecord::Migration
	create_table :recipients do |t|
		t.string :email
		t.integer :team_id

		t.timestamps
	end
end

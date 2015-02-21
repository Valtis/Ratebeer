class AddBannedToUser < ActiveRecord::Migration
  def change
    add_column :users, :banned, :boolean

    User.all.each do |user|
      user.update_attribute(:banned, false)
    end

  end
end

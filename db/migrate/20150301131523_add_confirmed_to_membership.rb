class AddConfirmedToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :confirmed, :boolean

    Membership.all.each do |m|
      m.update_attribute(:confirmed, true)
    end
  end
end

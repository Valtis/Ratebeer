class UpdateBeerStyle < ActiveRecord::Migration
  def change
    change_table :beers do |t|
      t.rename :style, :old_style
      t.integer :style_id
    end

    Beer.all.each do |br|
      style = Style.find_by name: br.old_style
      br.style_id = style.id
      br.save
    end



    remove_column :beers, :old_style
  end
end

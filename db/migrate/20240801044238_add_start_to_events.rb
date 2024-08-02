class AddStartToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :start, :datetime
  end
end

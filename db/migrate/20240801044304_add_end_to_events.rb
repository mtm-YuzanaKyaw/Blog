class AddEndToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :end, :datetime
  end
end

class DropEvents < ActiveRecord::Migration[7.1]
  def change
    drop_table :events
  end
end

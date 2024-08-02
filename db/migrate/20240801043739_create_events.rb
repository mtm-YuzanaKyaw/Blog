class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :summary
      t.string :google_event_id
      t.string :calendar_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

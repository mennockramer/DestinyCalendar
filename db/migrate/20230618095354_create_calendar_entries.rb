class CreateCalendarEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.string :name
      t.string :icon_path
      t.date :start_date
      t.string :type

      t.timestamps
    end
  end
end

class AddSourceToCalendarEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :calendar_entries, :source, :string
  end
end

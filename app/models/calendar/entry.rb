class Calendar::Entry < ApplicationRecord
  validates :name, :start_date, presence: true


  def end_date
    raise "Calendar::Entry has no end date, use the Daily/Weekly/Event subclasses as appropriate"
  end
end

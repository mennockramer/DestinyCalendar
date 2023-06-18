class Calendar::Entry < ApplicationRecord
  def end_date
    raise "Calendar::Entry has no end date, use the Daily/Weekly/Event subclasses as appropriate"
  end
end

class CalendarEntry < ApplicationRecord
  validates :name, :start_date, presence: true
  
  def self.inherited(subclass)
    super
    def subclass.model_name
      superclass.model_name
    end
  end

  def end_date
    raise "CalendarEntry has no end date, use the Daily/Weekly/Event subclasses as appropriate"
  end
end

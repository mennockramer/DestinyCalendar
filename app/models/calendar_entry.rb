class CalendarEntry < ApplicationRecord
  
  VALID_SOURCES = ['seed', 'live', 'manual']

  validates :name, :start_date, :source, presence: true
  validates :source, inclusion: { in: VALID_SOURCES }

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

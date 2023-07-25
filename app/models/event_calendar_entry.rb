class EventCalendarEntry < CalendarEntry
  def end_date
    start_date + 3.weeks
  end
end

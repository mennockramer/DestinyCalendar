class DailyCalendarEntry < CalendarEntry
  def end_date
    start_date + 1.days
  end
end

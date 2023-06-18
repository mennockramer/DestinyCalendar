class Calendar::DailyEntry < Calendar::Entry
  def end_date
    start_date + 1.days
  end
end

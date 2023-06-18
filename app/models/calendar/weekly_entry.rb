class Calendar::WeeklyEntry < Calendar::Entry
  def end_date
    start_date + 1.weeks
  end
end

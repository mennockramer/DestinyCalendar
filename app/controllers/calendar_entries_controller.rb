class CalendarEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :

  def index
    @seed_calendar_entries = CalendarEntry.where(source: :seed)
    @manual_calendar_entries = CalendarEntry.where(source: :manual)
    @live_calendar_entries = CalendarEntry.where(source: :live)
  end

  def show 
    @calendar_entry = CalendarEntry.find(params[:id])
  end

  def new
    @calendar_entry = CalendarEntry.new
  end

  def create
    @calendar_entry = CalendarEntry.new(calendar_entry_params.merge({source: :manual}))

    if @calendar_entry.save
      redirect_to @calendar_entry
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @calendar_entry = CalendarEntry.find(params[:id])
  end

  def update
    @calendar_entry = CalendarEntry.find(params[:id])

    if @calendar_entry.update(calendar_entry_params)
      redirect_to @calendar_entry
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @calendar_entry = CalendarEntry.find(params[:id])
    @calendar_entry.destroy

    redirect_to calendar_entries_url, status: :see_other
  end

  private
    def calendar_entry_params
      params.require(:calendar_entry).permit(:name, :icon_path, :start_date, :type)
    end

   
end

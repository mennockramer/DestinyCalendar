class CalendarController < ApplicationController
  def index
    current_season_manifest = DESTINY_MANIFEST.season(Restiny.get("Settings").dig("destiny2CoreSettings", "currentSeasonHash"))
    @current_season_start = current_season_manifest["startDate"].to_date
    @current_season_end = current_season_manifest["endDate"].to_date
    @current_season_last_day = @current_season_end - 1.days
    @current_season_length = @current_season_end - @current_season_start
    @current_season_name = current_season_manifest.dig("displayProperties", "name")
    @current_season_number = current_season_manifest["seasonNumber"]
    
    if Time.now.utc > Time.now.utc.to_date.to_datetime + 17/24r #after daily reset
      @destiny_today = Time.now.utc.to_date
    else
      @destiny_today = Time.now.utc.to_date - 1.days 
    end

  end
end

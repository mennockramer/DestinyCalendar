class CalendarController < ApplicationController
  require "mini_magick"

  def index
    current_season_manifest = DESTINY_MANIFEST.season(Restiny.api_get("Settings").dig("destiny2CoreSettings", "currentSeasonHash"))
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

    @daily_calendar_entries  = DailyCalendarEntry.all.group_by(&:start_date)
    @weekly_calendar_entries = WeeklyCalendarEntry.all.group_by(&:start_date)
    @event_calendar_entries  = EventCalendarEntry.all.group_by(&:start_date)

    #DRY out? add length check to form?
    if /^[0-9A-F]{6}$/.match(params[:table_background_hex_colour])
      @table_background_hex_colour = params[:table_background_hex_colour]
    else
      @table_background_hex_colour = "000000"
    end
    if /^[0-9A-F]{6}$/.match(params[:table_text_hex_colour])
      @table_text_hex_colour = params[:table_text_hex_colour]
    else
      @table_text_hex_colour = "FFFFFF"
    end
    if /^[0-9A-F]{6}$/.match(params[:table_highlight_hex_colour])
      @table_highlight_hex_colour = params[:table_highlight_hex_colour]
    else
      @table_highlight_hex_colour = "7F7F7F"
    end
    
    if params[:table_background_image_url] =~ /\A#{URI::regexp}\z/
      @table_background_image_url= params[:table_background_image_url]
    end
   
    if params[:table_auto_colour] == "1" #because checkboxes are 
      if params[:table_background_image_url] =~ /\A#{URI::regexp}\z/
        begin
          image =  MiniMagick::Image.open(@table_background_image_url)
          bg_colour_ints = image.scale(1).get_pixels.flatten
        rescue  MiniMagick::Invalid => e #catch ImageMagick not being installed
          puts e
          bg_colour_ints = @table_background_hex_colour.match(/(..)(..)(..)/).captures.map(&:hex) #failover to set bg colour if image parsing fails
        end
      else
        bg_colour_ints = @table_background_hex_colour.match(/(..)(..)(..)/).captures.map(&:hex)
      end
        #currently just inversion, probably a better logic
        is_bright = bg_colour_ints.sum() > 382
        @table_text_hex_colour = (is_bright ? "000000" : "FFFFFF")
    end  


    respond_to do |format|
      
      format.turbo_stream do
        puts "If this shows in console, somehow Turbo is working"
        render 'index', locals: @locals
      end
      format.html {}
    end

  end
end

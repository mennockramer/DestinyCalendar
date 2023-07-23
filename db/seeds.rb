# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

CalendarEntry.where(source: :seed).destroy_all

@current_season_manifest = DESTINY_MANIFEST.season(Restiny.api_get("Settings").dig("destiny2CoreSettings", "currentSeasonHash"))
@current_season_start = @current_season_manifest["startDate"].to_date
@current_season_end = @current_season_manifest["endDate"].to_date
@current_season_last_day = @current_season_end - 1.days
@current_season_number = @current_season_manifest["seasonNumber"]

@season_days = @current_season_start.upto(@current_season_last_day)
@season_tuesdays = @season_days.each_slice(7).map(&:first)

#relevant dates setup
if DateTime.now.utc > Date.today.to_datetime + 17/24r #after daily reset
  @destiny_today = Date.today
else
  @destiny_today = Date.yesterday
end

if @destiny_today.tuesday?
  @last_weekly_reset = @destiny_today
else
  @last_weekly_reset = @destiny_today.prev_occurring(:tuesday)
end

# import known rotations from file
@known_rotations = YAML::load(open([Rails.root, "config/known_rotations.yml"].join("/")))

#Current values
current_weekly_rotator_names = {}

Restiny.api_get("Destiny2/Milestones").each {  |m, mi| 
  result = DESTINY_MANIFEST.milestone(mi["milestoneHash"])
  if result.dig("displayProperties","name") == "Nightfall Weekly Score"   
    current_weekly_rotator_names["nightfall-strikes"] = DESTINY_MANIFEST.activity(mi["activities"][0]["activityHash"]).dig("displayProperties","description")
  end
  unless mi["activities"].nil?
    mi["activities"].each { |a|           
      unless a["challengeObjectiveHashes"].nil? || a["challengeObjectiveHashes"].empty?
        a["challengeObjectiveHashes"].each {|c|
          objective_result = DESTINY_MANIFEST.objective(c)
          if objective_result.dig("displayProperties","name") == "Weekly Dungeon Challenge" 
            current_weekly_rotator_names["dungeons"] = result.dig("displayProperties","name").to_s
          end
          if objective_result.dig("displayProperties","name") == "Weekly Raid Challenge" 
            current_weekly_rotator_names["raids"] = result.dig("displayProperties","name").to_s
          end
        }
      end
    }
  end
}

#https://github.com/Bungie-net/api/issues/1836 <- Grasp Of Avarice not showing in public milestones - workaround below, assumes no rotator = GoA
unless current_weekly_rotator_names.has_key?("dungeons")
  current_weekly_rotator_names["dungeons"] = "Grasp of Avarice"
end

def generate_rotations(known_date_activity_name, rotator_name, known_date, type)
  rotations = @known_rotations.dig("season-#{@current_season_number}",rotator_name)
  if rotations.nil? || rotations.empty?
    puts "Rotations not defined for Season #{@current_season_number} #{rotator_name}"
  else
    if type == :weekly
      @season_tuesdays.each{ |day|
        CalendarEntry.create(name: rotations.rotate(rotations.index(known_date_activity_name) + ((day - known_date).to_i))[0], 
                            start_date: day, type: WeeklyCalendarEntry, source: 'seed')
      }
    elsif type == :daily
      @season_days.each{ |day|
        CalendarEntry.create(name: rotations.rotate(rotations.index(known_date_activity_name) + ((day - known_date).to_i))[0], 
                            start_date: day, type: DailyCalendarEntry, source: 'seed')
      }
    end
  end
end

if @known_rotations["season-#{@current_season_number}"].empty?
  raise "Rotations for this season not yet defined in config/known_rotations.yml"
else

  current_weekly_rotator_names.each { |rotator_name, activity_name|
    generate_rotations(activity_name, rotator_name, @last_weekly_reset, :weekly)
  }

  unless @known_rotations["season-#{@current_season_number}"]["legend-lost-sector-locations"].empty? #not known until fully cycled once, may be missing
    #based off first day value as no value can be pulled from the API for current
    generate_rotations(@known_rotations["season-#{@current_season_number}"]["legend-lost-sector-locations"][0],
                        "legend-lost-sector-locations", @current_season_start, :daily )
  end
  
end

puts "#{WeeklyCalendarEntry.where(source: :seed).count} WeeklyCalendarEntries seeded"
puts "#{DailyCalendarEntry.where(source: :seed).count} DailyCalendarEntries seeded"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

CalendarEntry.destroy_all

current_season_manifest = DESTINY_MANIFEST.season(Restiny.get("Settings").dig("destiny2CoreSettings", "currentSeasonHash"))
current_season_start = current_season_manifest["startDate"].to_date
current_season_end = current_season_manifest["endDate"].to_date
current_season_last_day = current_season_end - 1.days
current_season_number = current_season_manifest["seasonNumber"]

season_days = current_season_start.upto(current_season_last_day)
season_tuesdays = season_days.each_slice(7).map(&:first)

#relevant dates setup
if DateTime.now.utc > Date.today.to_datetime + 17/24r #after daily reset
  destiny_today = Date.today
else
  destiny_today = Date.yesterday
end

if destiny_today.tuesday?
  last_weekly_reset = destiny_today
else
  last_weekly_reset = destiny_today.prev_occurring(:tuesday)
end

# import known rotations from file
known_rotations = YAML::load(open([Rails.root, "config/known_rotations.yml"].join("/")))

#Current Raid and Dungeon
current_dungeon_rotator_name = ""
current_raid_rotator_name = ""

Restiny.get_profile(4611686018483247082, 3 , [202]).dig(
  "characterProgressions","data","2305843009402586408","milestones"
).each { |m, mi|
  if mi["startDate"]
    if mi["startDate"]< Time.now && Time.now < mi["endDate"]
      result = DESTINY_MANIFEST.milestone(mi["milestoneHash"])
      unless mi["activities"].nil?
        mi["activities"].each { |a|           
          unless a["challenges"].nil? || a["challenges"].empty?
            a["challenges"].each {|c|
              objective_result = DESTINY_MANIFEST.objective(c.dig("objective", "objectiveHash"))
              if objective_result.dig("displayProperties","name") == "Weekly Dungeon Challenge" 
                current_dungeon_rotator_name = result.dig("displayProperties","name").to_s
              end
              if objective_result.dig("displayProperties","name") == "Weekly Raid Challenge" 
                current_raid_rotator_name = result.dig("displayProperties","name").to_s
              end
            }
          end
        }
      end
    end
  end
}
#https://github.com/Bungie-net/api/issues/1836 <- Grasp Of Avarice not showing in public milestones
#using my own profile milestones as a workaround
#delete the above and uncomment the line below once fixed by Bungie
# Restiny.get("Destiny2/Milestones").each {  |m, mi| 
#   if mi["startDate"]
#     if mi["startDate"]< Time.now && Time.now < mi["endDate"]
#       result = DESTINY_MANIFEST.milestone(mi["milestoneHash"])
#       unless mi["activities"].nil?
#         mi["activities"].each { |a|           
#           unless a["challengeObjectiveHashes"].nil? || a["challengeObjectiveHashes"].empty?
#             a["challengeObjectiveHashes"].each {|c|
#               objective_result = DESTINY_MANIFEST.objective(c)
#               if objective_result.dig("displayProperties","name") == "Weekly Dungeon Challenge" 
#                 @weekly_dungeon_rotator_name = result.dig("displayProperties","name").to_s
#               end
#               if objective_result.dig("displayProperties","name") == "Weekly Raid Challenge" 
#                 @weekly_raid_rotator_name = result.dig("displayProperties","name").to_s
#               end
#             }
#           end
#         }
#       end
#     end
#   end
# }

season_tuesdays.each{ |tuesday|
  week_offset = (tuesday - last_weekly_reset).to_i # 0 if current week, -1 if last week, 1 if next week, etc

  #Raids
  raid_rotator_array = known_rotations["season-#{current_season_number}"]["raids"]
  current_raid_rotator_index = raid_rotator_array.index(current_raid_rotator_name)
  raid_name = raid_rotator_array.rotate(current_raid_rotator_index + week_offset)[0]
  CalendarEntry.create(name: raid_name, start_date: tuesday, type: WeeklyCalendarEntry)

  #Dungeons
  dungeon_rotator_array = known_rotations["season-#{current_season_number}"]["dungeons"]
  current_dungeon_rotator_index = dungeon_rotator_array.index(current_dungeon_rotator_name)
  dungeon_name = dungeon_rotator_array.rotate(current_dungeon_rotator_index + week_offset)[0]
  CalendarEntry.create(name: dungeon_name, start_date: tuesday, type: WeeklyCalendarEntry)


}

puts "#{WeeklyCalendarEntry.count} WeeklyCalendarEntries present"
puts "#{DailyCalendarEntry.count} DailyCalendarEntries present"
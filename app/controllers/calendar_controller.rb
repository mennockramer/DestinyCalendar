class CalendarController < ApplicationController
  def index
    @weekly_dungeon_rotator_name = ""
    @weekly_raid_rotator_name = ""

    Restiny.get("Destiny2/Milestones").each {  |m, mi| 
      if mi["startDate"]
        if mi["startDate"]< Time.now && Time.now < mi["endDate"]
          result = DESTINY_MANIFEST.milestone(mi["milestoneHash"])
          unless mi["activities"].nil?
            mi["activities"].each { |a|           
              unless a["challengeObjectiveHashes"].empty?
                a["challengeObjectiveHashes"].each {|c|
                  objective_result = DESTINY_MANIFEST.objective(c)
                  if objective_result.dig("displayProperties","name") == "Weekly Dungeon Challenge" #weekly dungeon rotator # ST, prophecy
                    @weekly_dungeon_rotator_name = result.dig("displayProperties","name").to_s
                  end
                  if objective_result.dig("displayProperties","name") == "Weekly Raid Challenge" #weekly raid rotator # vog?, vow
                    @weekly_raid_rotator_name = result.dig("displayProperties","name").to_s
                  end
                }
              end
            }
          end
        end
      end
    }

    current_season_manifest = DESTINY_MANIFEST.season(Restiny.get("Settings").dig("destiny2CoreSettings", "currentSeasonHash"))
    @current_season_start = current_season_manifest["startDate"].to_date
    @current_season_end = current_season_manifest["endDate"].to_date
    @current_season_last_day = @current_season_end - 1.days
    @current_season_length = @current_season_end - @current_season_start
    @current_season_name = current_season_manifest.dig("displayProperties", "name")
    @current_season_number = current_season_manifest["seasonNumber"]
    

  end
end

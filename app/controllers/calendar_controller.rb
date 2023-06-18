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
                  if c == 3838169295 #weekly dungeon rotator
                    @weekly_dungeon_rotator_name = result.dig("displayProperties","name").to_s
                  end
                  if c == 3180884403 #weekly raid rotator
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
    @current_season_name = current_season_manifest.dig("displayProperties", "name")
    @current_season_number = current_season_manifest["seasonNumber"]
    

  end
end

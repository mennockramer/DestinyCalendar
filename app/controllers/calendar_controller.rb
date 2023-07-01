class CalendarController < ApplicationController
  def index
    @weekly_dungeon_rotator_name = ""
    @weekly_raid_rotator_name = ""

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
                    @weekly_dungeon_rotator_name = result.dig("displayProperties","name").to_s
                  end
                  if objective_result.dig("displayProperties","name") == "Weekly Raid Challenge" 
                    @weekly_raid_rotator_name = result.dig("displayProperties","name").to_s
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

    current_season_manifest = DESTINY_MANIFEST.season(Restiny.get("Settings").dig("destiny2CoreSettings", "currentSeasonHash"))
    @current_season_start = current_season_manifest["startDate"].to_date
    @current_season_end = current_season_manifest["endDate"].to_date
    @current_season_last_day = @current_season_end - 1.days
    @current_season_length = @current_season_end - @current_season_start
    @current_season_name = current_season_manifest.dig("displayProperties", "name")
    @current_season_number = current_season_manifest["seasonNumber"]
    

  end
end

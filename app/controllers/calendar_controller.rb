class CalendarController < ApplicationController
  def index
    @response = Restiny.get_user_by_membership_id("4611686018483247082")
  end
end

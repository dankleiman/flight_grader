class AirportsController < ApplicationController

  def show
    @airport = Airport.find(params[:id])
    @carriers = OriginAirport.find(params[:id]).carriers.uniq
  end
end

class AirportsController < ApplicationController

  def show
    @airport = Airport.find(params[:id])
    @carriers = @airport.carriers
  end
end

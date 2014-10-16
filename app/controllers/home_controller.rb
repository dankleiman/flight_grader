class HomeController < ApplicationController

  def index
    @carriers = Carrier.active.order(:position)
    @airports = Airport.active
  end
end

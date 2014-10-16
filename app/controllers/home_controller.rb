class HomeController < ApplicationController

  def index
    # @carriers = Carrier.all.
    @airports = Airport.active
  end
end

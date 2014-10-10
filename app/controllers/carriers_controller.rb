class CarriersController < ApplicationController

  def show
    @carrier = Carrier.find(params[:id])
  end
end

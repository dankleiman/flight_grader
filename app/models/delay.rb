class Delay < ActiveRecord::Base
  belongs_to :flight
  belongs_to :delay_cause

end

class Event < ApplicationRecord
  belongs_to :user
  attr_accessor :start_date, :end_date, :start_time, :end_time
end

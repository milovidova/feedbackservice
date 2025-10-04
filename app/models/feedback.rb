class Feedback < ApplicationRecord
  belongs_to :project
  belongs_to :user
end
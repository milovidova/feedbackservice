class Project < ApplicationRecord
  belongs_to :user
  has_many :feedbacks
  mount_uploader :image, ProjectImageUploader
end
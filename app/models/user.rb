class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects
  has_many :feedbacks

  before_create :set_jti

  def projects_count
    projects.count
  end

  def feedbacks_on_my_projects_count
    Feedback.joins(:project).where(projects: { user_id: id }).count
  end

  def my_feedbacks_count
    feedbacks.count
  end

  private

  def set_jti
    self.jti ||= SecureRandom.uuid
  end
end
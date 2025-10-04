class AddFieldsToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :user_id, :integer
    add_column :projects, :title, :string
    add_column :projects, :image, :string
    add_column :projects, :description, :text
    add_column :projects, :category, :string
    add_column :projects, :feedback_request, :text
  end
end
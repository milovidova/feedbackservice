class PagesController < ApplicationController
  def about
  end
  
  def profile
  end
  
  def articles
    @user = current_user
    @projects = current_user.projects
    @feedbacks = current_user.feedbacks
  end

  def article1
    
  end
 def article2
    
  end
  def article3
    
  end
  def article4
    
  end
  def article5
    
  end
  def article6
    
  end
  def create
    @project = Project.new
  end
end
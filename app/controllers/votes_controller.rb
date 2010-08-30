class VotesController < ApplicationController
  load_and_authorize_resource
  
  def create    
    Vote.create(:user_id => current_user.id, :deal_id => params[:deal_id])
    redirect_to deals_path
  end
  
end

class VotesController < ApplicationController
  authorize_resource
  
  def create    
    Vote.create(:user_id => current_user.id, :deal_id => params[:deal_id])
    @deal = Deal.find(params[:deal_id])
  end
  
end

class VotesController < ApplicationController
  load_resource :deal
  load_and_authorize_resource
  
  def create    
    Vote.create(:user_id => current_user.id, :deal_id => @deal.id)
    @deal.reload
  end
  
end

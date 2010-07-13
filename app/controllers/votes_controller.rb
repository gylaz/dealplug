class VotesController < ApplicationController
  load_and_authorize_resource
  
  def create
    @vote = Vote.create(:user_id => current_user.id, :deal_id => params[:deal_id], :up => params[:up])
    puts @vote.errors.full_messages
    redirect_to deals_path
  end
  
  def update
  end

end

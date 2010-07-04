class DealsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource
  
  def index
    @deals = Deal.latest.popular
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deals }
    end
  end

  def show
  end

  def new
    @deal.url = "http://"
  end

  def edit
  end
  
  def create
    @deal.user = current_user
    if @deal.save
      redirect_to(@deal, :notice => 'Deal was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    respond_to do |format|
      if @deal.update_attributes(params[:deal])
        format.html { redirect_to(@deal, :notice => 'Deal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @deal.destroy
    redirect_to(deals_url)
  end
end

class DealsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  load_and_authorize_resource
  
  def index
    @page = params[:page] || 1
    if params[:popular]
      @deals = Deal.popular.paginate(:page => params[:page], :per_page => 20)
    else
      @deals = Deal.latest.paginate(:page => params[:page], :per_page => 20)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deals }
    end
  end

  def new
    @deal.url = "http://"
  end

  def create
    @deal.user = current_user
    @deal.points = 1
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

require 'spec_helper'

describe DealsController do
  let(:user) { Factory(:user) }
  let(:deal) { Factory(:deal, :user => user) }

  describe "index" do
    before { get :index }
    it { response.should be_success }
    it { assigns(:deals).should_not be_nil }
  end

  context "with login" do
    before { sign_in user }

    describe "show" do
      before { get :show, :id => deal.id }
      it { response.should be_success }
      it { assigns(:deal).should_not be_nil }
    end

    describe "new" do
      before { get :new }
      it { response.should render_template 'new' }
      it { assigns(:deal).should be_new_record }
    end

    describe "create" do
      before { put :create, :deal => deal.attributes }
      it { response.should redirect_to(deal_path(assigns(:deal))) }
      it { assigns(:deal).should_not be_new_record }
    end

    describe "edit" do
      before { get :edit, :id => deal.id }
      it { response.should render_template 'edit' }
      it { assigns(:deal).should_not be_nil }
    end

    describe "update" do
      before {
        post :update, :id => deal.id,
          :deal => deal.attributes.merge(:title => 'Edited')
      }
      it { response.should redirect_to(deal_path(assigns(:deal))) }
      it { deal.reload.title.should == 'Edited' }
    end

    describe "destroy" do
      before { delete :destroy, :id => deal.id }
      it { response.should redirect_to deals_path }
      it { Deal.find_by_id(deal.id).should be_nil }
    end
  end
end

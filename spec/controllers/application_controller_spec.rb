require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe ApplicationController, 'setting the current site' do
  before do
    Domain.delete_all
  end

  class ApplicationController
    def site_test
    end
  end

  it 'should set an instance variable for the current site based upon the domain' do
    domain = Domain.generate!
    @request.host = domain.name
    get :site_test
    assigns[:current_site].should == domain.site
  end

  it 'should set a helper method for the current site based upon the domain' do
    domain = Domain.generate!
    @request.host = domain.name
    get :site_test
    controller.current_site.should == domain.site
  end
end

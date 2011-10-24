require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe ActiveRecord::Base do
  it 'should be able to store and retrieve current site' do
    site = Site.generate!
    ActiveRecord::Base.current_site = site
    ActiveRecord::Base.current_site.should == site
  end
end

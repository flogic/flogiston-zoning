require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Layout do
  before do
    @layout = Layout.spawn
  end

  describe 'associations' do
    it 'should belong to site' do
      @layout.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @layout.update_attributes!(:site => site)
      @layout.reload
      @layout.site.should == site
    end
  end
end

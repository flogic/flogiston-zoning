require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Asset do
  before do
    @asset = Asset.spawn
  end

  describe 'associations' do
    it 'should belong to site' do
      @asset.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @asset.update_attributes!(:site => site)
      @asset.reload
      @asset.site.should == site
    end
  end
end

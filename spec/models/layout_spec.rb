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

  describe 'validations' do
    it 'should error on duplicate handles for the same site' do
      obj = Layout.generate!(:site => Site.generate!)
      dup = Layout.generate( :site => obj.site, :handle => obj.handle)
      dup.errors.should be_invalid(:handle)
    end

    it 'should allow the same handle for a different site' do
      obj = Layout.generate!(:site => Site.generate!)
      dup = Layout.generate( :site => Site.generate!, :handle => obj.handle)
      dup.errors.should_not be_invalid(:handle)
    end
  end
end

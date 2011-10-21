require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe AbstractPage do
  before do
    @abstract_page = AbstractPage.spawn
  end

  describe 'associations' do
    it 'should belong to site' do
      @abstract_page.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @abstract_page.update_attributes!(:site => site)
      @abstract_page.reload
      @abstract_page.site.should == site
    end
  end

  describe 'validations' do
    it 'should error on duplicate handles for the same site' do
      obj = AbstractPage.generate!(:site => Site.generate!)
      dup = AbstractPage.generate( :site => obj.site, :handle => obj.handle)
      dup.errors.should be_invalid(:handle)
    end

    it 'should allow the same handle for a different site' do
      obj = AbstractPage.generate!(:site => Site.generate!)
      dup = AbstractPage.generate( :site => Site.generate!, :handle => obj.handle)
      dup.errors.should_not be_invalid(:handle)
    end
  end
end

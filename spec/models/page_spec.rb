require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Page do
  before do
    @page = Page.spawn
  end

  describe 'associations' do
    it 'should belong to site' do
      @page.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @page.update_attributes!(:site => site)
      @page.reload
      @page.site.should == site
    end
  end

  describe 'validations' do
    it 'should error on duplicate handles for the same site' do
      obj = Page.generate!(:site => Site.generate!)
      dup = Page.generate( :site => obj.site, :handle => obj.handle)
      dup.errors.should be_invalid(:handle)
    end

    it 'should allow the same handle for a different site' do
      obj = Page.generate!(:site => Site.generate!)
      dup = Page.generate( :site => Site.generate!, :handle => obj.handle)
      dup.errors.should_not be_invalid(:handle)
    end
  end
end

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
end

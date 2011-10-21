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
end

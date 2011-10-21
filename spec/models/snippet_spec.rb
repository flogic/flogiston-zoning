require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Snippet do
  before do
    @snippet = Snippet.spawn
  end

  describe 'associations' do
    it 'should belong to site' do
      @snippet.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @snippet.update_attributes!(:site => site)
      @snippet.reload
      @snippet.site.should == site
    end
  end
end

require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Template do
  before do
    @template = Template.spawn
  end

  describe 'associations' do
    it 'should belong to site' do
      @template.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @template.update_attributes!(:site => site)
      @template.reload
      @template.site.should == site
    end
  end
end

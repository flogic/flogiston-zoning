require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Domain do
  before :each do
    @domain = Domain.spawn
  end

  describe 'attributes' do
    it 'should have a name' do
      @domain.should respond_to(:name)
    end

    it 'should allow setting and retrieving the name' do
      @domain.name = 'test.name.com'
      @domain.save!
      @domain.reload.name.should == 'test.name.com'
    end
  end

  describe 'associations' do
    it 'should belong to site' do
      @domain.should respond_to(:site)
    end

    it 'should allow setting and retrieving the site' do
      site = Site.generate!
      @domain.update_attributes!(:site => site)
      @domain.reload
      @domain.site.should == site
    end
  end

  describe 'validations' do
    it 'should require a name' do
      domain = Domain.new(:name => nil)
      domain.valid?
      domain.errors.should be_invalid(:name)
    end

    it 'should accept a name' do
      domain = Domain.new(:name => 'testing.name.co.uk')
      domain.valid?
      domain.errors.should_not be_invalid(:name)
    end

    it 'should require names to be unique' do
      Domain.generate!(:name => 'duplicate.name.com')
      dup = Domain.generate(:name => 'duplicate.name.com')
      dup.errors.should be_invalid(:name)
    end

    it 'should require a site' do
      domain = Domain.new(:site => nil)
      domain.valid?
      domain.errors.should be_invalid(:site)
    end

    it 'should accept a site' do
      domain = Domain.new(:site => Site.generate!)
      domain.valid?
      domain.errors.should_not be_invalid(:site)
    end
  end
end

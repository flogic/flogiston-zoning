require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Site do
  before :each do
    @site = Site.spawn
  end

  describe 'attributes' do
    it 'should have a name' do
      @site.should respond_to(:name)
    end

    it 'should allow setting and retrieving the name' do
      @site.name = 'test.name.com'
      @site.save!
      @site.reload.name.should == 'test.name.com'
    end

    it 'should have a handle' do
      @site.should respond_to(:handle)
    end

    it 'should allow setting and retrieving the handle' do
      @site.handle = 'test_handle'
      @site.save!
      @site.reload.handle.should == 'test_handle'
    end
  end

  describe 'associations' do
    it 'should have domains' do
      @site.should respond_to(:domains)
    end

    it 'should allow retrieving domains' do
      @site = Site.generate!
      @domains = Array.new(3) { Domain.generate!(:site => @site) }
      @site.domains.sort_by(&:id).should == @domains.sort_by(&:id)
    end
  end

  describe 'validations' do
    it 'should require a name' do
      site = Site.new(:name => nil)
      site.valid?
      site.errors.should be_invalid(:name)
    end

    it 'should accept a name' do
      site = Site.new(:name => 'testing.name.co.uk')
      site.valid?
      site.errors.should_not be_invalid(:name)
    end

    it 'should require names to be unique' do
      Site.generate!(:name => 'duplicate.name.com')
      dup = Site.generate(:name => 'duplicate.name.com')
      dup.errors.should be_invalid(:name)
    end

    it 'should require a handle' do
      site = Site.new(:handle => nil)
      site.valid?
      site.errors.should be_invalid(:handle)
    end

    it 'should accept a handle' do
      site = Site.new(:handle => 'Some Testing Handle')
      site.valid?
      site.errors.should_not be_invalid(:handle)
    end

    it 'should require handles to be unique' do
      Site.generate!(:handle => 'duplicate handle')
      dup = Site.generate(:handle => 'duplicate handle')
      dup.errors.should be_invalid(:handle)
    end
  end

  it 'should be able to retrieve a site for a given domain name' do
    Site.should respond_to(:for_domain)
  end

  describe 'retrieving a site for a given domain name' do
    it 'should accept a domain name' do
      lambda { Site.for_domain('testing.co.il') }.should_not raise_error(ArgumentError)
    end

    it 'should require a domain name' do
      lambda { Site.for_domain }.should raise_error(ArgumentError)
    end

    it 'should return the site for the given domain' do
      domain = Domain.generate!
      Site.for_domain(domain.name).should == domain.site
    end

    it 'should return nil if no such domain exists' do
      Domain.delete_all
      Site.for_domain('help.com').should be_nil
    end
  end
end

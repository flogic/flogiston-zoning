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

    it 'should require a name' do
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
end

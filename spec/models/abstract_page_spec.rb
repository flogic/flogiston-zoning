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

  describe 'scoping' do
    describe 'initializing' do
      describe 'when current site is set' do
        before do
          @site = Site.generate!
          ActiveRecord::Base.current_site = @site
        end

        after do
          ActiveRecord::Base.current_site = nil
        end

        it 'should automatically associate to the current site' do
          AbstractPage.new.site.should == @site
        end

        it 'should not allow associating to a different site' do
          AbstractPage.new(:site => Site.generate!).site.should == @site
        end

        it 'should not allow associating to a different site via the ID' do
          AbstractPage.new(:site_id => Site.generate!.id).site.should == @site
        end

        it 'should not allow associating to no site' do
          AbstractPage.new(:site => nil).site.should == @site
        end

        it 'should not allow associating to no site via the ID' do
          AbstractPage.new(:site_id => nil).site.should == @site
        end
      end

      describe 'when current site is not set' do
        before do
          ActiveRecord::Base.current_site = nil
        end

        it 'should not automatically associate to a site' do
          AbstractPage.new.site.should == nil
        end

        it 'should allow manually setting a site' do
          site = Site.generate!
          AbstractPage.new(:site => site).site.should == site
        end

        it 'should allow manually setting a site via the ID attribute' do
          site = Site.generate!
          AbstractPage.new(:site_id => site.id).site.should == site
        end
      end
    end

    describe 'finding' do
      before do
        AbstractPage.delete_all
        Site.delete_all

        @sites = Array.new(3) { Site.generate! }
        @sites.each { |s|  2.times { AbstractPage.generate!(:site => s) } }
        @things = AbstractPage.all
      end

      describe 'when current site is set' do
        before do
          ActiveRecord::Base.current_site = @sites.first
        end

        after do
          ActiveRecord::Base.current_site = nil
        end

        it 'should return stored objects for the current site' do
          AbstractPage.all.sort_by(&:id).should == @things.first(2).sort_by(&:id)
        end

        it 'should return the right number of stored objects for the current site' do
          AbstractPage.all.length.should == 2
        end

        it 'should count stored objects for the current site' do
          AbstractPage.count.should == 2
        end

        it 'should take extra conditions' do
          AbstractPage.all(:conditions => { :handle => @things[1].handle }).should == [@things[1]]
        end

        it 'should take extra conditions when counting' do
          AbstractPage.count(:conditions => { :handle => @things[1].handle }).should == 1
        end
      end

      describe 'when current site is not set' do
        before do
          ActiveRecord::Base.current_site = nil
        end

        it 'should return stored objects' do
          AbstractPage.all.sort_by(&:id).should == @things.sort_by(&:id)
        end

        it 'should return the right number of stored objects' do
          AbstractPage.all.length.should == 3*2
        end

        it 'should count all stored objects' do
          AbstractPage.count.should == 3*2
        end

        it 'should take extra conditions' do
          AbstractPage.all(:conditions => { :handle => @things[1].handle }).should == [@things[1]]
        end

        it 'should take extra conditions when counting' do
          AbstractPage.count(:conditions => { :handle => @things[1].handle }).should == 1
        end
      end
    end
  end
end

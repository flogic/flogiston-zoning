test_site = Site.create!(:name => 'testing', :handle => 'testing')
Domain.create!(:name => 'test.host', :site => test_site)

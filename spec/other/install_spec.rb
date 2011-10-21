require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))
require 'fileutils'

def test_plugin_path(relative)
  File.expand_path(File.join(File.dirname(__FILE__), '..', '..', relative))
end

def test_rails_path(relative)
  File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', '..', relative))
end

describe 'the plugin install.rb script' do
  before :each do
    FileUtils.stubs(:mkdir)
    FileUtils.stubs(:copy)
    FileUtils.stubs(:cp_r)
    File.stubs(:directory?).returns(true)
    self.stubs(:system).returns(true)
    self.stubs(:puts).returns(true)
  end

  def do_install
    eval File.read(File.join(File.dirname(__FILE__), *%w[.. .. install.rb ]))
  end

  it "should copy the plugin's db migrations to the RAILS_ROOT db/migrate directory" do
    FileUtils.expects(:cp_r).with(test_plugin_path('db/migrate'), test_rails_path('db'))
    do_install
  end

  it "should have rails run the plugin installation template" do
    self.expects(:system).with("rake rails:template LOCATION=#{test_plugin_path('templates/plugin-install.rb')}")
    do_install
  end

  it 'should display the contents of the plugin README file' do
    self.stubs(:readme_contents).returns('README CONTENTS')
    self.expects(:puts).with('README CONTENTS')
    do_install
  end

  describe 'readme_contents' do
    it 'should work without arguments' do
      do_install
      lambda { readme_contents }.should_not raise_error(ArgumentError)
    end

    it 'should accept no arguments' do
      do_install
      lambda { readme_contents(:foo) }.should raise_error(ArgumentError)
    end

    it 'should read the plugin README.markdown file' do
      do_install
      IO.expects(:read).with(test_plugin_path('README.markdown'))
      readme_contents
    end

    it 'should return the contents of the plugin README.markdown file' do
      do_install
      IO.stubs(:read).with(test_plugin_path('README.markdown')).returns('README CONTENTS')
      readme_contents.should == 'README CONTENTS'
    end
  end
end

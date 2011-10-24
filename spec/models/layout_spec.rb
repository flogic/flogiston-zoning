require File.expand_path(File.join(File.dirname(__FILE__), *%w[.. spec_helper]))

describe Layout do
  before do
    @model = Layout
  end

  it_should_behave_like 'a zoned model'
end

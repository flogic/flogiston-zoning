class Domain
  generator_for :name, :start => 'test000001.name.com' do |prev|
    parts = prev.split('.')
    parts[0].succ!
    parts.join('.')
  end
end

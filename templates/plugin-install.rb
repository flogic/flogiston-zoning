other_plugins = %w[assets cms].collect { |n|  "flogiston-#{n}" }

other_plugins.each do |name|
  plugin name, :git => "git://github.com/flogic/#{name}.git"
end

Dir["#{RAILS_ROOT}/vendor/plugins/flogiston-zoning/app/models/flogiston/*.rb"].each do |f|
  filename = File.basename(f, '.rb')
  model_name = filename.camelize

  if File.exist?("app/models/#{filename}.rb")
    puts "*** model #{filename}.rb exists. Ensure it defines #{model_name} < Flogiston::#{model_name}. ***"
  else
    file "app/models/#{filename}.rb", <<-eof
class #{model_name} < Flogiston::#{model_name}
end
    eof
  end
end

paths = other_plugins.collect { |name|  "#{RAILS_ROOT}/vendor/plugins/#{name}/app/models/flogiston/*.rb" }
Dir[*paths].each do |f|
  filename = File.basename(f, '.rb')
  model_name = filename.camelize
  filepath = "#{RAILS_ROOT}/app/models/#{filename}.rb"

  if File.exist?(filepath)
    lines = File.readlines(filepath)
    lines.reject! { |l|  l.match(/^\s*extend Flogiston::Zoning/) }

    extended = false
    lines.each do |l|
      if l.match(/^\s*class #{model_name} < Flogiston::#{model_name}/)
        l << "  extend Flogiston::Zoning\n"
        extended = true
        break
      end
    end

    if extended
      puts "extending #{filename}.rb with zoning"
      File.open(filepath, 'w') do |f|
        f.print lines.join
      end
    else
      puts "*** model #{filename}.rb does not define #{model_name} < Flogiston::#{model_name}. ***"
    end
  else
    puts "*** model #{filename}.rb does not exist. This is strange and confusing. Make sure #{other_plugins.join('/')} are installed. ***"
  end
end

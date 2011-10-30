namespace :flogiston do
  namespace :zoning do
    namespace :db do
      desc 'Load necessary zoning data'
      task :seed => :environment do
        seed_path = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. .. db seeds]))
        require seed_path
      end
    end
  end
end

namespace :db do
  namespace :test do
    task :prepare do
      Rake::Task['flogiston:zoning:db:seed'].invoke
    end
  end
end

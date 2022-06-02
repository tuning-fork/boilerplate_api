# lib/tasks/custom_seed.rake
namespace :db do
    namespace :seed do
      task :single => :environment do
        filename = Dir[File.join(Rails.root, 'db', 'seeds', "#{ENV['SEED']}.seeds.rb")][0]
        puts "Seeding #{filename}..."
        load(filename) if File.exist?(filename)
      end
    end
  end

# to use run: 
# rake db:seed:single SEED=<seed_name_without_.seeds.rb>
# so for example: 
# rake db:seed:single SEED=<reviewers>


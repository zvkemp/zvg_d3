require "bundler/gem_tasks"

namespace :coffee do
  namespace :compile do
    task :default => :all
    task :all => [:samples, :source, :spec] do
    end

    task :samples do
      puts 'building samples...'
      `mkdir -p samples/js`
      `coffee -o samples/js -c samples/coffee`
    end

    task :source do
      puts 'building source...'
      `mkdir -p js`
      `coffee -o js -c app/assets/javascripts`
    end

    task :spec do
      puts 'building spec...'
      `mkdir -p spec/js`
      `coffee -o spec/js -c spec/coffee`
    end
  end
end

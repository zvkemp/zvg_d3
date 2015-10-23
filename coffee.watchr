require 'rake'
load 'Rakefile'
watch('.*\.coffee') { |md| Rake::Task["coffee:compile:all"].invoke }

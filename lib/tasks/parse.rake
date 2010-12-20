namespace :parse do
  task :slickdeals => :environment do
    Deal.scan_and_populate
  end
end

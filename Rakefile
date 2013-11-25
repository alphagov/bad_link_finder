require "gem_publisher"

desc "Publish gem to RubyGems"
task :publish_gem do |t|
  published_gem = GemPublisher.publish_if_updated("bad_link_finder.gemspec", :rubygems)
  puts "Published #{published_gem}" if published_gem
end

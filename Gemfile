source 'https://rubygems.org'

source 'https://rails-assets.org' do
  gem 'rails-assets-leaflet-iiif', '~> 0.0.3'
  gem 'rails-assets-readmore'
end

# Specify your gem's dependencies in geoblacklight.gemspec
gemspec

# If we don't specify 2.11.0 we'll end up with sprockets 2.12.0 in the main
# Gemfile.lock but since sass-rails gets generated (rails new) into the test app
# it'll want sprockets 2.11.0 and we'll have a conflict
gem 'sprockets', '2.11.0'

# If we don't specify 3.2.15 we'll end up with sass 3.3.2 in the main
# Gemfile.lock but since sass-rails gets generated (rails new) into the test app
# it'll want sass 3.2.0 and we'll have a conflict
gem 'sass', '~> 3.2.0'
gem 'bootstrap-sass', ">= 3.2"

group :test do
  # Peg simplecov to < 0.8 until this is resolved:
  # https://github.com/colszowka/simplecov/issues/281
  gem 'simplecov', '~> 0.7.1', require: false
  gem 'coveralls', require: false
end

# load local rails test instance Gemfile
file = File.expand_path("Gemfile", ENV['ENGINE_CART_DESTINATION'] || ENV['RAILS_ROOT'] || File.expand_path("../spec/internal", __FILE__))
if File.exists?(file)
  puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
  instance_eval File.read(file)
end

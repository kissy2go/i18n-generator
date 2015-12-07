$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rspec/given'
require 'rails/generators'
%w[
  action_controller
  action_view
].each do |framework|
  require "#{framework}/railtie"
end
require 'ammeter/init'
require 'i18n-generator'

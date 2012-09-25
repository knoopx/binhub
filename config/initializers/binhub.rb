require 'binhub/nntp'

BinHub::NNTP.configure do |config|
  config.server_address = ENV['BINHUB_ADDRESS']
  config.server_port = ENV['BINHUB_PORT'] || 119
  config.server_username = ENV['BINHUB_USERNAME']
  config.server_password = ENV['BINHUB_PASSWORD']
end
#!/usr/bin/env ruby

##
# Retrieve the Folding@home stats for the provided doner username.
#
# https://stats.foldingathome.org/api
#

require 'date'
require 'json'

require 'faraday'

FAH_HEADERS = { 'Content-Type' => 'application/json' }
USERNAME = ARGV[0]

faraday = Faraday.new('https://stats.foldingathome.org', headers: FAH_HEADERS, request: { timeout: 5 }) do |conn|
  conn.request(
    :retry,
    max: 10,
    interval: 0.5,
    interval_randomness: 0.5,
    backoff_factor: 2,
    retry_statuses: [502]
  )
  # conn.response :logger
end


puts "Checking Folding@home stats for #{USERNAME}"

res = faraday.get "/api/donor/#{USERNAME}"

puts res.body

#!/usr/bin/env ruby

require 'net/http'

host = ARGV[0]
port = (ARGV[1] || 443)
cert = nil

Net::HTTP.start(host, port, use_ssl: true) do |http|
  cert = http.peer_cert
end

puts cert.to_s

#!/usr/bin/env ruby
##
# Print out the certificate details for the provided host [port].
# Also include the certificate in PEM format.
#
# Equivelant to
# echo | openssl s_client -servername $host -connect $host:443 2>/dev/null | openssl x509 -text

require 'net/http'

host = ARGV[0]
port = (ARGV[1] || 443)
cert = nil

Net::HTTP.start(host, port, use_ssl: true, verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
  # https://ruby-doc.org/stdlib/libdoc/openssl/rdoc/OpenSSL/X509/Certificate.html
  cert = http.peer_cert
end

puts cert.to_text

puts "\n\nPEM format:",
     cert.to_s

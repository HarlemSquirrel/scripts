#!/usr/bin/env ruby

##
# Check the provided SSL certificate and private key to see if they are a valid pair.
#
# The certificate and key are expected to be DER or PEM-encoded.
# https://ruby-doc.org/stdlib-2.7.1/libdoc/openssl/rdoc/OpenSSL/X509/Certificate.html
# https://ruby-doc.org/stdlib-2.7.1/libdoc/openssl/rdoc/OpenSSL/PKey/RSA.html
#


require 'openssl'

cert_file = ARGV[0]
key_file = ARGV[1]

key = OpenSSL::PKey::RSA.new File.read(key_file)
cert = OpenSSL::X509::Certificate.new File.read(cert_file)

##
# Color methods for strings
#
module ColorizableString
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end
end

String.include ColorizableString

if cert.check_private_key key
  puts "It's a match!".green
  exit 0
end

puts "The provided certificate and key do not appear to match.".red
exit 1

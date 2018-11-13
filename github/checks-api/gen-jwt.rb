#!/usr/bin/env ruby
#

app_id, path_to_pem = ARGV

require 'openssl'
require 'jwt'  # https://rubygems.org/gems/jwt

# Private key contents
private_pem = File.read(path_to_pem)
private_key = OpenSSL::PKey::RSA.new(private_pem)

now = Time.now.to_i - 600

# Generate the JWT
payload = {
  # issued at time
  iat: now,
  # JWT expiration time (10 minute maximum)
  exp: now + (10 * 60),
  # GitHub App's identifier
  iss: app_id
}

jwt = JWT.encode(payload, private_key, "RS256")
puts jwt

require 'openssl'

raw = File.read "ca.crt"
ca_cert = OpenSSL::X509::Certificate.new(raw)

# Parse public key from CA
ca_key = ca_cert.public_key
if !(ca_key.instance_of? OpenSSL::PKey::EC) then
    puts "CA NOT ECC"
    puts "Type: " + key.inspect
    exit
end

# Set new group with fake generator G = Q
ca_key.private_key = 1
group = ca_key.group
group.set_generator(ca_key.public_key, group.order, group.cofactor)
group.asn1_flag = OpenSSL::PKey::EC::EXPLICIT_CURVE
ca_key.group = group

puts ca_key.to_pem
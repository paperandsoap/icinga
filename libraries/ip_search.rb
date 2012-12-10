require 'ipaddr'

def private_addresses_for_node(node_def)
  local_addresses = []
  return local_addresses if node_def['network'] == nil # node may have no ohai data yet
  private_ranges = ['192.168.0.0/16', '172.16.0.0/12', '10.0.0.0/8'].map { |ip_str| IPAddr.new(ip_str) }
  node_def['network']['interfaces'].each_pair do |ifname, ifdata|
    if ! ifdata['addresses'] ; then next; end
    ifdata['addresses'].keys.each { |ip_str|
      begin
        if private_ranges.any? { |range| range.include?(IPAddr.new(ip_str)) }
          local_addresses << ip_str
        end
      rescue ArgumentError
        nil # not all addresses are IP; ignore exceptions
      end
    }
  end
  return local_addresses
end

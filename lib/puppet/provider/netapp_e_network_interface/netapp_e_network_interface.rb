require 'puppet/provider/netapp_e'

Puppet::Type.type(:netapp_e_network_interface).provide(:netapp_e_network_interface, :parent => Puppet::Provider::Netapp_e) do
  @doc = 'Manage netapp e series storage systems'

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  mk_resource_methods

  def self.instances
    response = transport.get_network_interfaces
    response.each.collect do |net_int|
      new(:id => net_int['interfaceRef'],
          :macaddr => net_int['macAddr'],
          :controller => net_int['controllerRef'],
          :storagesystem => net_int['storagesystem'],
          :interfacename => net_int['interfaceName'],
          :ipv4 => net_int['ipv4Enabled'].to_s.to_sym,
          :ipv4address => net_int['ipv4Address'],
          :ipv4mask => net_int['ipv4SubnetMask'],
          :ipv4gateway => net_int['ipv4GatewayAddress'],
          :ipv4config => net_int['ipv4AddressConfigMethod'],
          :ipv6 => net_int['ipv6Enabled'].to_s.to_sym,
          :ipv6address => net_int['ipv6LocalAddress'],
          :ipv6config  => net_int['ipv6AddressConfigMethod'],
          :ipv6routableaddr => net_int['ipv6AddressConfigMethod'],
          :remoteaccess => net_int['rloginEnabled'].to_s.to_sym,
          :speed => net_int['speedSetting']
         )
    end
  rescue => detail
    raise Puppet::Error, "#{detail}"
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.macaddr]
        if resource[:storagesystem] == prov.storagesystem
          resource.provider = prov
        end
      end
    end
  end

  def ipv4=(value)
    @property_flush[:ipv4] = value
  end

  def ipv4address=(value)
    @property_flush[:ipv4address] = value
  end

  def ipv4mask=(value)
    @property_flush[:ipv4mask] = value
  end

  def ipv4gateway=(value)
    @property_flush[:ipv4gateway] = value
  end

  def ipv4config=(value)
    @property_flush[:ipv4config] = value
  end

  def ipv6=(value)
    @property_flush[:ipv6] = value
  end

  def ipv6address=(value)
    @property_flush[:ipv6address] = value
  end

  def ipv6config=(value)
    @property_flush[:ipv6config] = value
  end

  def ipv6routableaddr=(value)
    @property_flush[:ipv6routableaddr] = value
  end

  def remoteaccess=(value)
    @property_flush[:remoteaccess] = value
  end

  def speed=(value)
    @property_flush[:speed] = value
  end

  def flush
    if not @property_flush.empty?
      request_body = {}
      request_body[:controllerRef] = @property_hash[:controller]
      request_body[:interfaceRef] = @property_hash[:id]
      request_body[:ipv4Enabled] = resource[:ipv4] if @property_flush[:ipv4]
      request_body[:ipv4Address] = resource[:ipv4address] if @property_flush[:ipv4address]
      request_body[:ipv4SubnetMask] = resource[:ipv4mask] if @property_flush[:ipv4mask]
      request_body[:ipv4gateway] = resource[:ipv4gateway] if @property_flush[:ipv4gateway]
      request_body[:ipv4AddressConfigMethod] = resource[:ipv4config] if @property_flush[:ipv4config]
      request_body[:ipv6Enabled] = resource[:ipv6] if @property_flush[:ipv6]
      request_body[:ipv6LocalAddress] = resource[:ipv6address] if @property_flush[:ipv6address]
      request_body[:ipv6AddressConfigMethod] = resource[:ipv6config] if @property_flush[:ipv6config]
      request_body[:ipv6GatewayAddress] = resource[:ipv6gateway] if @property_flush[:ipv6gateway]
      request_body[:ipv6StaticRoutableAddress] = resource[:ipv6routableaddr] if @property_flush[:ipv6routableaddr]
      request_body[:speedSetting] = resource[:speed] if @property_flush[:speed]
      request_body[:enableRemoteAccess] = resource[:remoteaccess] if @property_flush[:remoteaccess]
      transport.update_ethernet_interface(resource[:storagesystem], request_body)
    end
  rescue => detail
    raise Puppet::Error, "#{detail}"
  end
end

require 'puppet/util/network_device'
Puppet::Type.newtype(:netapp_e_storage_pool) do
  @doc = 'Manage Netapp E series storage disk pool'

  apply_to_device
  ensurable

  validate do
    raise Puppet::Error, 'You must specify a storage system id.' unless @parameters.include?(:storagesystem)
    raise Puppet::Error, 'You must specify a name for storage pool.' unless @parameters.include?(:name)
    raise Puppet::Error, 'You must specify a array of disk ids.' unless @parameters.include?(:diskids)
    raise Puppet::Error, 'You must specify a raid level.' unless @parameters.include?(:raidlevel)
  end

  newparam(:name, :namevar => true) do
    desc 'The user-label to assign to the new storage pool.'
  end

  newparam(:diskids, :array_matching => :all) do
    desc 'The identifiers of the disk drives to use for creating the storage pool.'
  end

  newparam(:storagesystem) do
    desc 'Storage system ID'
  end

  newproperty(:id, :readonly => true) do
    desc 'Disk pool id.'
  end

  newproperty(:raidlevel) do
    desc 'The RAID configuration for the new storage pool.'
    newvalues('raidUnsupported', 'raidAll', 'raid0', 'raid1',
              'raid3', 'raid5', 'raid6', 'raidDiskPool', '__UNDEFINED')
  end

  newparam(:erasedrives, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    desc 'Security-enabled drives that were previously part of a secured storage pool must be erased before they can be re-used. Enable to automatically erase such drives.'
    defaultto :false
  end
end

Facter.add(:nm_connections, :type => :aggregate) do
  nmcli = '/bin/nmcli' #Facter.value('nm_nmcli_path')
  if nmcli
    chunk(:connections) do
      interfaces = {}

      cmd = "#{nmcli} -g uuid,name,device connection show --active"
      Facter::Core::Execution.execute(cmd).split(%r{\n+}).each do |conn|
        uuid,name,device = conn.split(':', 3)
        interfaces[device.strip] = {:uuid => uuid.strip, :name => name.strip}
      end

      interfaces
    end
  end
end

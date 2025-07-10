Facter.add(:nm_nmcli_path) do
  setcode do
    Facter::Core::Execution.execute('which nmcli')
  end
end

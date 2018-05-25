Vagrant.configure(2) do |config|
  config.ssh.username = 'op'

  config.vm.provider('libvirt') do |libvirt|
    libvirt.memory = 2048
    libvirt.cpus   = 2
    libvirt.nested = true
    libvirt.graphics_type = 'spice'
  end
end

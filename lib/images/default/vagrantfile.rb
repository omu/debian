<%# vim: set ft=eruby: -%>
<%- skip if !param.vagrantfile && param.username == 'vagrant' -%>
# frozen_string_literal: true

<%- unless param.username == 'vagrant' -%>
Vagrant.configure('2') do |config|
  config.ssh.username = '<%= param.username %>'
end
<%- end -%>

<%= param.vagrantfile -%>

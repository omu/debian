<%# vim: set ft=eruby: -%>
<%- skip if !meta.vagrantfile && meta.username == 'vagrant' -%>
# frozen_string_literal: true

<%- unless meta.username == 'vagrant' -%>
Vagrant.configure('2') do |config|
  config.ssh.username = '<%= meta.username %>'
end
<%- end -%>

<%= meta.vagrantfile -%>

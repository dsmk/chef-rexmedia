#include_recipe 'yum-epel'

plex_version = node['rexden']['plex_version']
plex_pkg = "plexmediaserver-#{plex_version}.x86_64.rpm"
plex_url = "http://downloads.plex.tv/plex-media-server/#{plex_version}/#{plex_pkg}"

remote_file "/root/#{plex_pkg}" do
  source plex_url
  owner 'root'
  group 'root'
  action :create
end

rpm_package 'plexmediaserver' do
  source "/root/#{plex_pkg}"
  action :install
end

service 'plexmediaserver' do
  action [ :enable, :start ]
end

[ 'Library', 
  'Library/Application Support',
  'Library/Application Support/Plex Media Server'
].each do |dir|
  directory "/var/lib/plexmediaserver/#{dir}" do
    user "plex"
    group "plex"
    mode "0755"
  end
end

if false
  template "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml" do
    source "plex/Preferences.xml.erb"
    user "plex"
    group "plex"
    mode "0600"
    notifies :restart, 'service[plexmediaserver]', :imediately
  end
end

template "/etc/sysconfig/PlexMediaServer" do
  source "plex/PlexMediaServer.erb"
  user "plex"
  group "plex"
  mode "0600"
  notifies :restart, 'service[plexmediaserver]', :immediately
end

execute 'plex-firewalld-install' do
    action :nothing
    command "/usr/bin/firewall-cmd --reload ; /usr/bin/firewall-cmd --add-service=plex --permanent ; /usr/bin/firewall-cmd --reload"
end

cookbook_file '/etc/firewalld/services/plex.xml' do
    source 'firewall-plex.xml'
    user 'root'
    group 'root'
    mode '0444'
    only_if "/usr/bin/systemctl status firewalld"
    notifies :run, 'execute[plex-firewalld-install]', :immediately
end

# vi: expandtab ts=2 

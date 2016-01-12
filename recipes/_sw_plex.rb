include_recipe 'yum-epel'

%w{
 perl-CGI-Session 
}.each do |pkg| 
  package pkg
end

logitech_version = node['rexden']['logitech_version']
logitech_url = "http://downloads.slimdevices.com/LogitechMediaServer_v#{logitech_version}/logitechmediaserver-#{logitech_version}-1.noarch.rpm"

remote_file "/root/logitechmediaserver-#{logitech_version}-1.noarch.rpm" do
  source logitech_url
  owner 'root'
  group 'root'
  action :create
end

rpm_package 'logitechmediaserver' do
  source "/root//logitechmediaserver-#{logitech_version}-1.noarch.rpm"
  action :install
end

link '/usr/share/perl5/vendor_perl/Slim' do
  to '/usr/lib/perl5/vendor_perl/Slim'
end

service 'squeezeboxserver' do
  action [ :enable, :start ]
end

execute 'logitech-firewalld-install' do
    action :nothing
    command "/usr/bin/firewall-cmd --reload ; /usr/bin/firewall-cmd --add-service=logitech --permanent ; /usr/bin/firewall-cmd --reload"
end

cookbook_file '/etc/firewalld/services/logitech.xml' do
    source 'firewall-plex.xml'
    user 'root'
    group 'root'
    mode '0444'
    only_if "/usr/bin/systemctl status firewalld"
    notifies :run, 'execute[logitech-firewalld-install]', :immediately
end

# vi: expandtab ts=2 

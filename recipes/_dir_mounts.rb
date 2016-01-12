include_recipe 'rexcore::_nfs_client'

mroot = node['rexden']['media_root']
mnfs = node['rexden']['media_nfs_prefix']

directory "#{mroot}/music" do
  owner "root"
  group "root"
end

node['rexden']['media_directories'].each do |m|
  fullpath = "#{mroot}/#{m[:path]}"
  fullnfs = "#{mnfs}/#{m[:nfs]}"

  #log "fullpath=#{fullpath} fullnfs=#{fullnfs}"

  if not m[:dir_skip] then
    directory fullpath
  end

  mount fullpath do
    device fullnfs
    fstype 'nfs'
    options 'defaults,ro'
    action [ :enable, :mount ]
  end

end

# vi: expandtab ts=2 

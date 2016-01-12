if node['rexden']['media_mount'] then
  include_recipe 'rexmedia::_dir_mounts'
else
  include_recipe 'rexmedia::_dir_local'
end

# vi: expandtab ts=2 

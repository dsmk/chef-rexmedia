mroot = node['rexden']['media_root']

directory "#{mroot}/music" do
  owner "root"
  group "root"
end

node['rexden']['media_directories'].each do |m|
  fullpath = "#{mroot}/#{m[:path]}"

  directory fullpath

  file "#{fullpath}/.test" do
    content "test"
  end

end

# vi: expandtab ts=2 

package "zsh" do
  action :install
end

package "tmux" do
  action :install
end

package "git"
# dotfiles
git "dotfiles" do
  user "#{node[:user]}"
  destination "/home/#{node[:user]}"
  repository "https://github.com/taroooyan/dotfiles.git"
  not_if "test -d /home/#{node[:user]}/dotfiles"
end
# execute "dotfiles setup" do
#   user "#{node[:user]}"
#   cwd "/home/#{node[:user]}/dotfiles"
#   command "./setup.sh"
# end

package "vim"
# NeoBundle
directory "/home/#{node[:user]}/.vim/bundle" do
  user "#{node[:user]}"
  mode "755"
  not_if "test -d /home/#{node[:user]}/.vim/bundle"
end
git "/home/#{node[:user]}" do
  user "#{node[:user]}"
  destination "/home/#{node[:user]}/.vim/bundle/neobundle.vim"
  repository "git://github.com/Shougo/neobundle.vim"
end

execute "Download Go" do
  user "#{node[:user]}"
  cwd "/tmp"
  command "curl -O https://storage.googleapis.com/golang/go1.7.4.linux-amd64.tar.gz; tar xvf go1.7.4.linux-amd64.tar.gz"
end
execute "Install Go" do
  user "root"
  cwd "/tmp"
  command "chown -R root:root ./go; mv ./go /usr/local"
  not_if "test -e /usr/local/go/bin/go"
end

execute "Install ghq" do
  user "#{node[:user]}"
  command "export GOPATH=$HOME; /usr/local/go/bin/go get github.com/motemen/ghq"
end


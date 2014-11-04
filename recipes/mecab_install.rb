dir = '/usr/local/src/mecab/'
tar = 'mecab-0.996.tar.gz'
src = "https://mecab.googlecode.com/files/#{tar}"

directory dir do
  action :create
  not_if "ls -d #{dir}"
end

remote_file dir + tar do
  source src
  not_if 'ls /usr/local/bin/mecab'
end

bash 'install_mecab' do
  user 'root'
  cwd dir
  code <<-EOH
tar mecab-0.996.tar.gz
cd mecab-0.996
./configure --with-charset=utf-8
make
make install
chown vagrant:vagrant /usr/local/lib/libmecab.so.2
bash -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr-local.conf'
ldconfig
  EOH
  not_if 'ls /usr/local/bin/redis-server'
end

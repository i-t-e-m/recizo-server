#centos7用develop環境実行sh

yum install -y wget git bzip2
yum install -y gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel
mkdir /usr/local
cd /usr/local
git clone https://github.com/sstephenson/rbenv.git rbenv
echo 'export RBENV_ROOT="/usr/local/rbenv"' >> /etc/profile
echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> /etc/profile
echo 'eval "$(rbenv init -)"' >> /etc/profile

source /etc/profile

firewall-cmd --add-port=3000/tcp --zone=public --permanent
firewall-cmd --reload

mkdir rbenv/shims rbenv/versions rbenv/plugins
cd rbenv/plugins
git clone https://github.com/sstephenson/ruby-build.git ruby-build
rbenv install -v 2.3.1
rbenv rehash
rbenv global 2.3.1
gem update --system
gem install --no-ri --no-rdoc rails
gem install bundler
rbenv rehash

wget https://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
rpm -ivh pgdg-centos96-9.6-3.noarch.rpm 
yum list postgresql96*
yum install -y postgresql96.x86_64 postgresql96-devel.x86_64 postgresql96-libs.x86_64 postgresql96-server.x86_64


mkdir -p /database/data
chown -R postgres:postgres /database/data
su -l postgres -c '/usr/pgsql-9.6/bin/initdb --encoding=UTF8 --no-locale'
systemctl enable postgresql-9.6
systemctl start postgresql-9.6


psql -U postgres -c 'CREATE ROLE root;'

psql -U postgres -c 'alter role root login;'
psql -U postgres -c 'alter role root createdb;'


cd ~/recizo-server-master
bundle config build.pg --with-pg-config=/usr/pgsql-9.6/bin/pg_config
bundle install --path vendor/bundle

bundle exec rake db:create
bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile

cp lib/tasks/secrets/environment.json.sample lib/tasks/secrets/environment.json
cp lib/tasks/secrets/client_secrets.json lib/tasks/secrets/client_secrets.json
mkdir ~/run

bundle exec rails s


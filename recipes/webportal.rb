#
# Cookbook Name:: virtualbox-install
# Recipe:: webportal
#
# Copyright 2012, Ringo De Smet
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

chef_gem 'chef-vault' do
  compile_time true if respond_to?(:compile_time)
end

require 'chef-vault'

# The phpvirtualbox webportal requires the Virtualbox webservice api to be active
include_recipe "virtualbox-install::webservice"

# This recipe requires the apache2 cookbook to be available
include_recipe "apache2"
include_recipe "apache2::mod_php"

vbox_version = node['virtualbox']['version']
phpvirtualbox_build = node['virtualbox']['webportal']['versions'][vbox_version]
phpvirtualbox_version = "#{vbox_version}-#{phpvirtualbox_build}"
phpvirtualbox_source = node['virtualbox']['webportal']['source']

remote_file "#{Chef::Config['file_cache_path']}/phpvirtualbox-#{phpvirtualbox_version}.zip" do
  source "#{phpvirtualbox_source}/phpvirtualbox-#{phpvirtualbox_version}.zip"
  mode "0644"
end

package "unzip" do
  action :install
end

bash "extract-phpvirtualbox" do
  code <<-EOH
  cd /tmp
  rm -rf phpvirtualbox
  mkdir phpvirtualbox
  cd phpvirtualbox
  unzip #{Chef::Config['file_cache_path']}/phpvirtualbox-#{phpvirtualbox_version}.zip
  mkdir -p #{node['virtualbox']['webportal']['installdir']}
  mv -f phpvirtualbox-#{phpvirtualbox_version} #{node['virtualbox']['webportal']['installdir']}/phpvirtualbox
  cd ..
  rm -rf phpvirtualbox
  EOH
end

if node['virtualbox']['webportal']['enable-apache2-default-site']
  bash "enable-apache2-default-site" do
    code <<-EOH
      if [ ! -f /etc/apache2/sites-enabled/default ]; then
        ln -s /etc/apache2/sites-available/default /etc/apache2/sites-enabled/default
      else
        exit 0
      fi
    EOH
  end
end

item = ChefVault::Item.load("passwords", "virtualbox")

template "#{node['virtualbox']['webportal']['installdir']}/phpvirtualbox/config.php" do
  source   "config.php.erb"
  mode     "0644"
  notifies :restart, "service[apache2]", :immediately
  variables(password: item['password'])
end

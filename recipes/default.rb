#
# Cookbook Name:: virtualbox-install
# Recipe:: default
#
# Copyright 2011-2013, Joshua Timberman
# Copyright 2018, Kyle McGovern
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

case node['platform_family']
when 'mac_os_x'

  sha256sum = vbox_sha256sum(node['virtualbox']['url'])

  dmg_package 'VirtualBox' do
    source node['virtualbox']['url']
    checksum sha256sum
    type 'pkg'
  end

when 'windows'

  sha256sum = vbox_sha256sum(node['virtualbox']['url'])
  win_pkg_version = node['virtualbox']['version']
  Chef::Log.debug("Inspecting windows package version: #{win_pkg_version.inspect}")

  windows_package "Oracle VM VirtualBox #{win_pkg_version}" do
    action :install
    source node['virtualbox']['url']
    checksum sha256sum
    installer_type :custom
    options "-s"
  end

when 'debian'

  apt_repository 'oracle-virtualbox' do
    uri node['virtualbox']['url']
    key node['virtualbox']['gpg_key']
    distribution node['lsb']['codename']
    components ['contrib']
  end

  package "virtualbox-#{node['virtualbox']['version']}"
  package 'dkms'

when 'rhel', 'fedora'

  yum_repository 'oracle-virtualbox' do
    description "#{node['platform_family']} $releasever - $basearch - Virtualbox" 
    baseurl node['virtualbox']['url']
    gpgkey node['virtualbox']['gpg_key']
    gpgcheck true
  end

  package "VirtualBox-#{node['virtualbox']['version']}"

end

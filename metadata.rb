name             'virtualbox-install'
maintainer       'Kyle McGovern'
maintainer_email 'spion06@gmail.com'
license          'Apache 2.0'
description      'Installs virtualbox'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'
chef_version     '>= 12.14'

%w{ubuntu debian centos redhat mac_os_x windows fedora}.each do |os|
  supports os
end

depends 'dmg'
depends 'windows'
depends 'apt'
depends 'apache2'

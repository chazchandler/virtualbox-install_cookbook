# changelog

## v1.0.4
* Add chefignore

## v1.0.3

* Update `yum` dependency to version 3

## v1.0.2

* Changed libshadow-ruby18 dependency to ruby-shadow gem
* Changed phpVirtualBox password to use "rawpassword" value from data bag
* Added attribute: node['virtualbox']['webportal']['enable-apache2-default-site']
* Fixed config.php installation directory to use node['virtualbox']['webportal']['installdir']

## v1.0.1

* Update install source for phpvirtualbox.

## v1.0

* Use platform_family attribute to expand platform support.
* Use Oracle's VirtualBox package repositories for Debian / RHEL, and
  the Opscode apt/yum cookbook resources accordingly.
* Add Vbox::Helpers module in libraries/.
* Add additional platforms supported
* Add dependencies on required per-platform cookbooks (required for
 Chef 11's chef-solo).

## v0.7.2:

* Update OS X installer to use new pkg format - thanks josephholsten.

## v0.7.0:

* Add Windows support
* No more "open source edition" - extension pack must now be downloaded
  separately from Oracle.
* Optionally install PHP web porta.

## v0.6.0:

* Install via Sun's package archive in Ubuntu
* Optionally install open-source edition from the Ubuntu repository
* Tested in Ubuntu 11.04

## v0.5.0:

* initial version, tested on OSX only

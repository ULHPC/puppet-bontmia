# File::      <tt>bontmia.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: bontmia
#
# Configure and manage bontmia
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of bontmia
# $sudo::   *Default*: false.   Execute rsync with sudo on the remote host
# $prefix:: Installation directory
#
# == Actions:
#
# Install and configure bontmia
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
# You can specialize the various aspects of the configuration, the installation
# prefix is a mandatory parameter, for instance:
#
#         class { 'bontmia':
#             ensure => 'present',
#             prefix => '/data/',
#             sudo   => true
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class bontmia(
    $prefix,
    $ensure = $bontmia::params::ensure,
    $sudo   = $bontmia::params::sudo
)
inherits bontmia::params
{
    info ("Configuring bontmia (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("bontmia 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        'debian', 'ubuntu':         { include ::bontmia::common::debian }
        'redhat', 'fedora', 'centos', 'rocky': { include ::bontmia::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}


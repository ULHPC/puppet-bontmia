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
#     import bontmia
#
# You can then specialize the various aspects of the configuration,
# for instance:
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
    $ensure = $bontmia::params::ensure,
    $prefix,
    $sudo   = $bontmia::params::sudo
)
inherits bontmia::params
{
    info ("Configuring bontmia (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("bontmia 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include bontmia::common::debian }
        redhat, fedora, centos: { include bontmia::common::redhat }
        default: {
            fail("Module ${module_name} is not supported on ${::operatingsystem}")
        }
    }
}


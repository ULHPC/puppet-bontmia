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
        debian, ubuntu:         { include bontmia::debian }
        redhat, fedora, centos: { include bontmia::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: bontmia::common
#
# Base class to be inherited by the other bontmia classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class bontmia::common {

    # Load the variables used in this module. Check the bontmia-params.pp file
    require bontmia::params

    if $bontmia::ensure == 'present' {

        exec { "mkdir -p ${bontmia::prefix}":
            path    => [ '/bin', '/usr/bin' ],
            unless  => "test -d ${bontmia::prefix}",
        }

        file { "${bontmia::prefix}":
            ensure  => 'directory',
            owner   => "${bontmia::params::configfile_owner}",
            group   => "${bontmia::params::configfile_group}",
            mode    => "${bontmia::params::configfile_mode}",
            require => Exec["mkdir -p ${bontmia::prefix}"]
        } ->
        exec { 'install_bontmia':
            command => "curl -Lo - ${bontmia::params::url} | tar xzvf -",
            cwd     => "${bontmia::prefix}",
            path    => '/usr/bin:/bin:/sbin',
            creates => "${bontmia::prefix}/${bontmia::params::install_dir}",
            user    => "${bontmia::params::configfile_owner}",
        } -> # arcfour hack, double the ssh bandwidth...
        exec { "sed -i 's/-e \"ssh/-e \"ssh -c arcfour/' ${bontmia::prefix}/${bontmia::params::install_dir}/bontmia":
            path    => "/usr/bin:/usr/sbin:/bin",
            unless  => "grep arcfour ${bontmia::prefix}/${bontmia::params::install_dir}/bontmia",
        }

        # Prepare the log directory
        file { "${bontmia::params::logdir}":
            ensure => 'directory',
            owner  => "${bontmia::params::logdir_owner}",
            group  => "${bontmia::params::logdir_group}",
            mode   => "${bontmia::params::logdir_mode}",
            require => Exec['install_bontmia'],
        }

    }
    else
    {
        # Here $bontmia::ensure is 'absent'

    }

}


# ------------------------------------------------------------------------------
# = Class: bontmia::debian
#
# Specialization class for Debian systems
class bontmia::debian inherits bontmia::common { }

# ------------------------------------------------------------------------------
# = Class: bontmia::redhat
#
# Specialization class for Redhat systems
class bontmia::redhat inherits bontmia::common { }




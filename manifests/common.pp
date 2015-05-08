# File::      <tt>bontmia.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
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
            path   => [ '/bin', '/usr/bin' ],
            unless => "test -d ${bontmia::prefix}",
        }

        file { $bontmia::prefix:
            ensure  => 'directory',
            owner   => $bontmia::params::configfile_owner,
            group   => $bontmia::params::configfile_group,
            mode    => $bontmia::params::configfile_mode,
            require => Exec["mkdir -p ${bontmia::prefix}"]
        } ->
        exec { 'install_bontmia':
            command => "curl -Lo - ${bontmia::params::url} | tar xzvf -",
            cwd     => $bontmia::prefix,
            path    => '/usr/bin:/bin:/sbin',
            creates => "${bontmia::prefix}/${bontmia::params::install_dir}",
            user    => $bontmia::params::configfile_owner,
        }

        # Prepare the log directory
        file { $bontmia::params::logdir:
            ensure  => 'directory',
            owner   => $bontmia::params::logdir_owner,
            group   => $bontmia::params::logdir_group,
            mode    => $bontmia::params::logdir_mode,
            require => Exec['install_bontmia'],
        }

    }
    else
    {
        # Here $bontmia::ensure is 'absent'
        exec { 'remove_bontmia':
            command => "rm -rf ${bontmia::prefix}/${bontmia::params::install_dir} ${bontmia::params::logdir}",
            path    => '/usr/bin:/bin:/sbin',
            onlyif  => "test -d ${bontmia::prefix}/${bontmia::params::install_dir} || test -d ${bontmia::params::logdir}",
        }

    }

}


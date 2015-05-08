# File::      <tt>bontmia-target.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Defines: bontmia::target
#
# Configure and manage a backup using bontmia
#
# == Pre-requisites
#
# * The class 'bontmia' should have been instanciated
#
# == Parameters:
#
# [*ensure*]
#   default to 'present', can be 'absent'.
#
# [*dest_dir*]
#   Destination directory of the backup
#
# [*src_dir*], [*src_host*], [*src_user*], [*src_port*]
#   Defines the backup source.
#   If src_host is not set, it assumes that we want to backup the local directory src_dir
#
# [*rotation_days*], [*rotation_weeks*], [*rotation_months*], [*rotation_years*]
#   Set-up the rotation policy with these values, see the bontmia documentation for more information
#
# [*cron_minute*], [*cron_hour*], [*cron_weekday*], [*cron_monthday*], [*cron_month*]
#   Set-up a cronjob with these settings
#
# [*email*]
#   Send the execution output to this email address
#
# == Sample usage:
#
#     include "bontmia"
#
# You can then add a target specification as follows:
#
#    class { 'bontmia':
#        ensure => 'present',
#        prefix => '/data/test2',
#        sudo   => true
#    }
#
#    bontmia::target{ 'backup_hcartiaux':
#        ensure   => 'present',
#        dest_dir => '/data/test2/hcartiaux',
#        src_user => 'localadmin',
#        src_host => 'nfs.chaos',
#        src_dir  => '/export/users/homedirs/hcartiaux',
#        src_port => '8022',
#        days     => '7',
#        weeks    => '4',
#        months   => '12',
#        years    => '2',
#        email    => 'hpc-sysadmins@uni.lu'
#     }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# [Remember: No empty lines between comments and class definition]
#
define bontmia::target(
    $dest_dir,
    $src_dir,
    $ensure          = 'present',
    $src_host        = '',
    $src_user        = 'localadmin',
    $src_port        = '8022',
    $rotation_days   = '7',
    $rotation_weeks  = '4',
    $rotation_months = '12',
    $rotation_years  = '2',
    $cron_minute     = '4',
    $cron_hour       = '4',
    $cron_weekday    = '*',
    $cron_monthday   = '*',
    $cron_month      = '*',
    $email           = ''
)
{
    include bontmia::params

    # $name is provided at define invocation
    $basename = $name

    $src_dir_array = any2array($src_dir)

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("bontmia::target 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    if ($bontmia::ensure != $ensure) {
        if ($bontmia::ensure != 'present') {
            fail("Cannot configure a bontmia '${basename}' as bontmia::ensure is NOT set to present (but ${bontmia::ensure})")
        }
    }

    # bash script
    file { "${bontmia::prefix}/${basename}.sh":
        ensure  => $ensure,
        owner   => $bontmia::params::configfile_owner,
        group   => $bontmia::params::configfile_group,
        mode    => $bontmia::params::configfile_mode,
        content => template('bontmia/backup.sh.erb'),
        require => Exec['install_bontmia']
    }

    exec { "mkdir -p ${dest_dir}":
        path   => [ '/bin', '/usr/bin' ],
        unless => "test -d ${dest_dir}",
    }
    file { $dest_dir:
        ensure  => 'directory',
        owner   => $bontmia::params::configfile_owner,
        group   => $bontmia::params::configfile_group,
        mode    => $bontmia::params::configfile_mode,
        require => Exec["mkdir -p ${dest_dir}"]
    }

    # cronjob
    cron { "bontmia-backup-${basename}":
        ensure      => $ensure,
        command     => "${bontmia::prefix}/${basename}.sh",
        user        => $bontmia::params::bontmia_user,
        minute      => $cron_minute,
        hour        => $cron_hour,
        weekday     => $cron_weekday,
        monthday    => $cron_monthday,
        month       => $cron_month,
        environment => "MAILTO=\"${email}\""
    }

}


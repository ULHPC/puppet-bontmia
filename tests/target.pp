# File::      <tt>target.pp</tt>
# Author::    H. Cartiaux (Hyacinthe.Cartiaux@uni.lu)
# Copyright:: Copyright (c) 2015 H. Cartiaux
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/target.pp
#
#
node default {

    class { 'bontmia':
        ensure => 'present',
        prefix => '/tmp/bontmia',
    }

    # Chaos
    bontmia::target{ 'backup_etc_dir':
        ensure          => 'present',
        src_dir         => '/etc/',
        dest_dir        => '/tmp/backup',
        rotation_days   => '7',
        rotation_weeks  => '2',
        rotation_months => '6',
        rotation_years  => '1',
        cron_hour       => '3',
        cron_minute     => '0',
    }
}

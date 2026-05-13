# Bontmia Puppet Module

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/bontmia.svg)](https://forge.puppetlabs.com/ulhpc/bontmia)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|centos-lightgrey.svg)

Configure and manage bontmia

      Copyright (c) 2026 UL HPC Team <hpc-sysadmins@uni.lu>


| [Project Page](https://github.com/ULHPC/puppet-bontmia) | [Sources](https://github.com/ULHPC/puppet-bontmia) | [Issues](https://github.com/ULHPC/puppet-bontmia/issues) |

## Synopsis

This module configures a bontmia installation and the backup tasks.

This module implements the following elements:
Note that we use a [forked version of bontmia](https://github.com/hcartiaux/bontmia).

* __Puppet classes__:
    - `bontmia`
    - `bontmia::common`
    - `bontmia::common::debian`
    - `bontmia::common::redhat`
    - `bontmia::params`

* __Puppet definitions__:
    - `bontmia::target`

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp).

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)

## General Parameters

See:

* [manifests/params.pp](manifests/params.pp)
* the headers of [manifests/bontmia.pp](manifests/bontmia.pp)
* the headers of [manifests/target.pp](manifests/target.pp)

## Overview and Usage

### class `bontmia`

     class { 'bontmia':
         ensure => 'present',
         prefix => '/data/bontmia',
         sudo   => true
     }

### definition `bontmia::target`

The definition `bontmia::target` permits to set-up one backup task.
This definition accepts the following parameters:

* `ensure`: default to 'present', can be 'absent'.
* `dest_dir`: destination directory of the backup
* `src_dir`, `src_host`, `src_user`, `src_port`: defines the backup source.
  If `src_host` is not set, it assumes that we want to backup the local directory `src_dir`.

* `rotation_days`, `rotation_weeks`, `rotation_months`, `rotation_years`:
  set-up the rotation policy with these values, see the bontmia documentation for more information

* `cron_minute`, `cron_hour`, `cron_weekday`, `cron_monthday`, `cron_month`:
  set-up a cronjob with these settings

* `email`: send the execution output to this email address

Example:

     bontmia::target{ 'backup_hcartiaux':
         ensure   => 'present',
         dest_dir => '/data/test/hcartiaux',
         src_user => 'localadmin',
         src_host => 'nfs.chaos',
         src_dir  => '/export/users/homedirs/hcartiaux',
         src_port => '2222',
         days     => '7',
         weeks    => '4',
         months   => '12',
         years    => '2',
         email    => 'hpc-sysadmins@uni.lu'
     }

## Librarian-Puppet / R10K Setup

You can of course configure the bontmia module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/bontmia"

or, if you prefer to work on the git version:

     mod "ULHPC/bontmia",
         :git => 'https://github.com/ULHPC/puppet-bontmia',
         :ref => 'main'

## Developments / Issues / Contributing to the code

This Puppet Module has been implemented in the context of the [UL HPC](http://hpc.uni.lu) Platform of the [University of Luxembourg](http://www.uni.lu).
It relies on [Vox Pupuli modulesync](https://github.com/voxpupuli/modulesync) for its organization.

You can submit bugs / issues / feature requests using the [ULHPC/bontmia Puppet Module Tracker](https://github.com/ULHPC/puppet-bontmia/issues).
You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests).

## Licence

This project and the sources proposed within this repository are released under the terms of the [GPL-3.0](LICENCE) licence.


[![Licence](https://www.gnu.org/graphics/gplv3-88x31.png)](LICENSE)

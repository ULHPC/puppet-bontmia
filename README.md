-*- mode: markdown; mode: auto-fill; fill-column: 80 -*-

# Bontmia Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/bontmia.svg)](https://forge.puppetlabs.com/ulhpc/bontmia)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|centos-lightgrey.svg)

Configure and manage bontmia

      Copyright (c) 2015 H. Cartiaux <hpc-sysadmins@uni.lu>
      

* [Online Project Page](https://github.com/ULHPC/puppet-bontmia)  -- [Sources](https://github.com/ULHPC/puppet-bontmia) -- [Issues](https://github.com/ULHPC/puppet-bontmia/issues)

## Synopsis

This module configures a bontmia installation and the backup tasks.

Note that we use a [forked version of bontmia](https://github.com/hcartiaux/bontmia).

It implements the following elements:

* __classes__:
  * `bontmia`
* __definitions__:
  * `bontmia::target`
 
The various operations of this repository are piloted from a `Rakefile` which
assumes that you have [RVM](https://rvm.io/) installed on your system.

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

You can of course configure ULHPC-sudo in your `Puppetfile` to make it 
available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/bontmia"

or, if you prefer to work on the git version: 

     mod "ULHPC/bontmia", 
         :git => https://github.com/ULHPC/puppet-bontmia,
         :ref => production 

## Issues / Feature request

You can submit bug / issues / feature request using the 
[ULHPC/bontmia Puppet Module Tracker](https://github.com/ULHPC/puppet-bontmia/issues). 


## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module
is organized.
These elements are detailed on [`doc/contributing.md`](doc/contributing.md)

You are more than welcome to contribute to its development by 
[sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Tests on Vagrant box

The best way to test this module in a non-intrusive way is to rely on
[Vagrant](http://www.vagrantup.com/). The `Vagrantfile` at the root of the
repository pilot the provisioning of the vagrant box and relies on boxes
generated through my [vagrant-vms](https://github.com/falkor/vagrant-vms)
repository.  
Once cloned, run 

      $> rake packer:Debian:init
      
To create a template. Select the version matching the once mentioned on the
`Vagrantfile` (`7.6.0-amd64` for instance)
Then run 

      $> rake packer:Debian:build
      
This shall generate the vagrant box `debian-7.6.0-amd64.box` that you can then
add to your box lists: 

      $> vagrant box add debian-7.6.0-amd64  packer/debian-7.6.0-amd64/debian-7.6.0-amd64.box

Now you can run `vagrant up` from this repository to boot the VM, provision it
to be ready to test this module (see the [`.vagrant_init.rb`](.vagrant_init.rb)
script). For instance, you can test the manifests of the `tests/` directory
within the VM: 

      $> vagrant ssh 
      [...]
      (vagrant)$> sudo puppet apply -t /vagrant/tests/init.pp
      
Run `vagrant halt` (or `vagrant destroy`) to stop (or kill) the VM once you've
finished to play with it. 

## Resources

### Git 

You should become familiar (if not yet) with Git. Consider these resources: 

* [Git book](http://book.git-scm.com/index.html)
* [Github:help](http://help.github.com/mac-set-up-git/)
* [Git reference](http://gitref.org/)


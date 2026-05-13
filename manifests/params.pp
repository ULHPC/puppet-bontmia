# File::      <tt>bontmia-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: bontmia::params
#
# In this class are defined as variables values that are used in other
# bontmia classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class bontmia::params {
  ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
  # (Here are set the defaults, provide your custom variables externally)
  # (The default used is in the line with '')
  ###########################################

  # ensure the presence (or absence) of bontmia
  $ensure = 'present'

  $sudo = false

  #### MODULE INTERNAL VARIABLES  #########
  # (Modify to adapt to unsupported OSes)
  #######################################

  # ensure the presence (or absence) of bontmia
  $url = 'https://github.com/hcartiaux/bontmia/archive/v0.18.1.tar.gz'

  # ensure the presence (or absence) of bontmia
  $install_dir = 'bontmia-0.18.1'

  # Log directory
  $logdir = $facts['os']['name'] ? {
    default => '/var/log/bontmia'
  }
  $logdir_mode = $facts['os']['name'] ? {
    default => '750',
  }
  $logdir_owner = $facts['os']['name'] ? {
    default => 'root',
  }
  $logdir_group = $facts['os']['name'] ? {
    default => 'adm',
  }

  $configfile = $facts['os']['name'] ? {
    default => '/etc/bontmia.conf',
  }
  $configfile_init = $facts['os']['name'] ? {
    /(?i-mx:ubuntu|debian)/ => '/etc/default/bontmia',
    default                 => '/etc/sysconfig/bontmia'
  }
  $configfile_mode = $facts['os']['name'] ? {
    default => '0700',
  }
  $configfile_owner = $facts['os']['name'] ? {
    default => 'root',
  }
  $configfile_group = $facts['os']['name'] ? {
    default => 'root',
  }

  $bontmia_user = $facts['os']['name'] ? {
    default => 'root',
  }
}

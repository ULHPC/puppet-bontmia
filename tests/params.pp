# File::      <tt>params.pp</tt>
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
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include 'bontmia::params'

$names = ["ensure ", "sudo ", "url ", "install_dir ", "logdir ", "logdir_mode ", "logdir_owner ", "logdir_group ", "configfile ", "configfile_init ", "configfile_mode ", "configfile_owner ", "configfile_group ", "bontmia_user "]

notice("bontmia::params::ensure  = ${bontmia::params::ensure }")
notice("bontmia::params::sudo  = ${bontmia::params::sudo }")
notice("bontmia::params::url  = ${bontmia::params::url }")
notice("bontmia::params::install_dir  = ${bontmia::params::install_dir }")
notice("bontmia::params::logdir  = ${bontmia::params::logdir }")
notice("bontmia::params::logdir_mode  = ${bontmia::params::logdir_mode }")
notice("bontmia::params::logdir_owner  = ${bontmia::params::logdir_owner }")
notice("bontmia::params::logdir_group  = ${bontmia::params::logdir_group }")
notice("bontmia::params::configfile  = ${bontmia::params::configfile }")
notice("bontmia::params::configfile_init  = ${bontmia::params::configfile_init }")
notice("bontmia::params::configfile_mode  = ${bontmia::params::configfile_mode }")
notice("bontmia::params::configfile_owner  = ${bontmia::params::configfile_owner }")
notice("bontmia::params::configfile_group  = ${bontmia::params::configfile_group }")
notice("bontmia::params::bontmia_user  = ${bontmia::params::bontmia_user }")

#each($names) |$v| {
#    $var = "bontmia::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}

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

$names = ['ensure', 'protocol', 'port', 'packagename']

notice("bontmia::params::ensure = ${bontmia::params::ensure}")
notice("bontmia::params::protocol = ${bontmia::params::protocol}")
notice("bontmia::params::port = ${bontmia::params::port}")
notice("bontmia::params::packagename = ${bontmia::params::packagename}")

#each($names) |$v| {
#    $var = "bontmia::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}

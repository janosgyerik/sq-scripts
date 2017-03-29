#!/usr/bin/perl

$num = $ARGV[0];
print $num, '_' x ($num - length("$num"))

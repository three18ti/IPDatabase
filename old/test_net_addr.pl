#!/usr/bin/perl
use 5.010;

use strict;
use warnings;

use NetAddr::IP::Util qw(:ipv4);

my $packed = inet_aton('192.168.0.5');

my $unpacked = inet_ntoa($packed);

say "Packed: $packed";
say "Unpacked: $unpacked";

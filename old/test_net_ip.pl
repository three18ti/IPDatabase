#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use Math::BigInt;
use Net::IP qw(:PROC);

# OO Interface
my $ip = Net::IP->new('192.168.0.0/24') or die Net::IP::Error;

say "IP  : "        . $ip->ip;
say "Sho : "        . $ip->short;
say "Bin : "        . $ip->binip;
say "Int : "        . $ip->intip;
say "Hex : "        . $ip->hexip;
say "Mask: "        . $ip->mask;
say "Hex Mask: "    . $ip->hexmask;
say "Last: "        . $ip->last_ip;
say "Len : "        . $ip->prefixlen;
say "Size: "        . $ip->size;
say "Type: "        . $ip->iptype;
say "Rev:  "        . $ip->reverse_ip;
say "LBin: "        . $ip->last_bin;
say "LInt: "        . $ip->last_int;
say "Find Prefixes: ";
my @list = $ip->find_prefixes('192.168.0.255');
#map { say } $ip->find_prefixes('192.168.1.24');
map { say } @list;
#do {
#    say $ip->ip;
#} while ++$ip;


# Procedureal Inteface
say "Procedureal Interface";
my $binip = ip_iptobin '192.168.0.20', 4;
my $back_to_ip = ip_bintoip $binip, 4;

my $intip = ip_bintoint $binip;

my $back_to_bin = ip_inttobin $intip, 4;
my $last_back_to_ip = ip_bintoip $back_to_bin, 4;


say $binip;
say $back_to_ip;

say $intip;
say $back_to_bin;
say $last_back_to_ip;

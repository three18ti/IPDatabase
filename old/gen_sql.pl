#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use Net::IP qw(:PROC);

my $index = 0;
foreach my $range ( '192.168.0.2 - 192.168.0.5', '10.10.0.2 - 10.10.0.5', '172.0.10.2 - 172.0.10.5', ) {
    my $ip = Net::IP->new($range) or die Net::IP::Error;
    do {    
        $index++;
        say "INSERT INTO \"ip\" VALUES($index, " . $ip->intip . ", '' );";
    } while ++$ip;
}

#my $ip = Net::IP->new('192.168.0.2 - 192.168.0.5');
#do {
#    say $ip->ip;
#} while ++$ip;

$index = 0;
foreach my $gateway ( '192.168.0.0', '10.10.0.0', '172.0.10.0' ) {
    my $ip = Net::IP->new($gateway) or die Net::IP::Error;

    say $ip->intip;
}

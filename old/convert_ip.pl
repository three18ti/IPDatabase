#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use Net::IP qw(:PROC);

foreach my $address (@ARGV) {
    my $ip = Net::IP->new($address);
    say $ip->intip;
}

__END__

my $network = $ip->ip;
$ip++;
my $gateway = $ip->ip;
$ip++;

my @usable;
do {
    push @usable, $ip->ip;
} while ++$ip;

my $broadcast = pop @usable;

say "Network:\t$network";
say "Gateway:\t$gateway";
say "Broadcast:\t$broadcast";
say "Usable Range: ";
map { say "\t\t$_"} @usable;



__END__
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

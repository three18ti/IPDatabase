#!/usr/bin/perl
use 5.010;
use strict;
use warnings;

use Socket;

sub ip2long {
    return unpack("l*", pack("l*", unpack("N*", inet_aton(shift))));
}

sub long2ip {
    return inet_ntoa(pack("N*", shift));
}

my $ip_id = 13;

my (@ip_insert, @ip_subnet_insert);

foreach ( 6 .. 255 ) {
    my $ip = "192.168.0.$_";
    push @ip_insert, "INSERT INTO \"ip\" VALUES($ip_id, '$ip', '' );";
    push @ip_subnet_insert, "INSERT INTO \"ip_subnet\" VALUES(1, $ip_id);";
    $ip_id++;
}

map { say } @ip_insert;
map { say } @ip_subnet_insert;

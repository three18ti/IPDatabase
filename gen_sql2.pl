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

my $ip_id = 1;

my (@ip_insert, @ip_subnet_insert);

#foreach ( 6 .. 255 ) {
foreach (qw( 192.168.0.2 192.168.0.3 192.168.0.4 192.168.0.5 10.10.0.2 10.10.0.3 10.10.0.4 10.10.0.5 172.0.10.2 172.0.10.3 172.0.10.4 172.0.10.5 )){

    my $ip = ip2long $_;
    push @ip_insert, "INSERT INTO \"ip\" VALUES($ip_id, $ip, '' );";
    push @ip_subnet_insert, "INSERT INTO \"ip_subnet\" VALUES(1, $ip_id);";
    $ip_id++;
}

map { say } @ip_insert;
map { say } @ip_subnet_insert;


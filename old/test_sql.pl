#!/usr/bin/perl
use DBI;
use 5.010;
use strict;
use warnings;

use Data::Dumper::GUI;

use NetAddr::IP::Util qw(:ipv4);


sub random_letter {
    my @letters = ('a'..'z');
    my $random_letter = $letters[int rand @letters];
}

my $dbh = DBI->connect("dbi:SQLite:dbname=foo.sqlite","","");

my $sth = $dbh->prepare("INSERT INTO server(name) VALUES(?)");
my $last_id_sth = $dbh->prepare("SELECT last_insert_rowid()");

my $name = random_letter . random_letter . random_letter . random_letter;

$sth->execute($name);

my $last_row_id = $dbh->func('last_insert_rowid');

my $packed = inet_aton('192.168.0.5');

say "Last row id: $last_row_id";

my $ip_sth = $dbh->prepare("INSERT INTO ips(ip) VALUES(?)");

$ip_sth->execute( $packed );

my $ip_select_sth = $dbh->prepare("SELECT * FROM ips WHERE id = ?");

$ip_select_sth->execute( '1' );

my ($id, $ip) = $ip_select_sth->fetchrow_array;

say "ID: $id";
say "IP: " . inet_ntoa $ip;

#print Dumper $dbh;




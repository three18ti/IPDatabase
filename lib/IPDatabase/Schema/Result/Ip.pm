use utf8;
package IPDatabase::Schema::Result::Ip;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IPDatabase::Schema::Result::Ip

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<ip>

=cut

__PACKAGE__->table("ip");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 ip

  data_type: 'varchar'
  is_nullable: 1

=head2 notes

  data_type: 'varchar'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ip",
  { data_type => "varchar", is_nullable => 1 },
  "notes",
  { data_type => "varchar", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<ip_unique>

=over 4

=item * L</ip>

=back

=cut

__PACKAGE__->add_unique_constraint("ip_unique", ["ip"]);

=head1 RELATIONS

=head2 ip_subnets

Type: has_many

Related object: L<IPDatabase::Schema::Result::IpSubnet>

=cut

__PACKAGE__->has_many(
  "ip_subnets",
  "IPDatabase::Schema::Result::IpSubnet",
  { "foreign.ip_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 server_ips

Type: has_many

Related object: L<IPDatabase::Schema::Result::ServerIp>

=cut

__PACKAGE__->has_many(
  "server_ips",
  "IPDatabase::Schema::Result::ServerIp",
  { "foreign.ip_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-08-11 01:44:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2CFjvOTNGqzDNIIzekJQdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

use utf8;
package IPDatabase::Schema::Result::Subnet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IPDatabase::Schema::Result::Subnet

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<subnet>

=cut

__PACKAGE__->table("subnet");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 network

  data_type: 'varchar'
  is_nullable: 1

=head2 gateway

  data_type: 'varchar'
  is_nullable: 1

=head2 broadcast

  data_type: 'varchar'
  is_nullable: 1

=head2 prefix

  data_type: 'varchar'
  is_nullable: 1

=head2 netmask

  data_type: 'varchar'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "network",
  { data_type => "varchar", is_nullable => 1 },
  "gateway",
  { data_type => "varchar", is_nullable => 1 },
  "broadcast",
  { data_type => "varchar", is_nullable => 1 },
  "prefix",
  { data_type => "varchar", is_nullable => 1 },
  "netmask",
  { data_type => "varchar", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<broadcast_unique>

=over 4

=item * L</broadcast>

=back

=cut

__PACKAGE__->add_unique_constraint("broadcast_unique", ["broadcast"]);

=head2 C<gateway_unique>

=over 4

=item * L</gateway>

=back

=cut

__PACKAGE__->add_unique_constraint("gateway_unique", ["gateway"]);

=head2 C<network_unique>

=over 4

=item * L</network>

=back

=cut

__PACKAGE__->add_unique_constraint("network_unique", ["network"]);

=head1 RELATIONS

=head2 ip_subnets

Type: has_many

Related object: L<IPDatabase::Schema::Result::IpSubnet>

=cut

__PACKAGE__->has_many(
  "ip_subnets",
  "IPDatabase::Schema::Result::IpSubnet",
  { "foreign.subnet_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 vlan_subnets

Type: has_many

Related object: L<IPDatabase::Schema::Result::VlanSubnet>

=cut

__PACKAGE__->has_many(
  "vlan_subnets",
  "IPDatabase::Schema::Result::VlanSubnet",
  { "foreign.subnet_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-08-11 01:44:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0egKF7qg7bdYfJwjx3xYkA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

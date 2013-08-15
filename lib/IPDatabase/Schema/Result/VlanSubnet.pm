use utf8;
package IPDatabase::Schema::Result::VlanSubnet;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IPDatabase::Schema::Result::VlanSubnet

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<vlan_subnets>

=cut

__PACKAGE__->table("vlan_subnets");

=head1 ACCESSORS

=head2 vlan_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 subnet_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "vlan_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "subnet_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 RELATIONS

=head2 subnet

Type: belongs_to

Related object: L<IPDatabase::Schema::Result::Subnet>

=cut

__PACKAGE__->belongs_to(
  "subnet",
  "IPDatabase::Schema::Result::Subnet",
  { id => "subnet_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
);

=head2 vlan

Type: belongs_to

Related object: L<IPDatabase::Schema::Result::Vlan>

=cut

__PACKAGE__->belongs_to(
  "vlan",
  "IPDatabase::Schema::Result::Vlan",
  { id => "vlan_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-08-11 01:44:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bmY5Sxqmmg6luBtUoKGl8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

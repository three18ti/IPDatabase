use utf8;
package IPDatabase::Schema::Result::Vlan;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

IPDatabase::Schema::Result::Vlan

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<vlan>

=cut

__PACKAGE__->table("vlan");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 vlan

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "vlan",
  { data_type => "integer", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 vlan_subnets

Type: has_many

Related object: L<IPDatabase::Schema::Result::VlanSubnet>

=cut

__PACKAGE__->has_many(
  "vlan_subnets",
  "IPDatabase::Schema::Result::VlanSubnet",
  { "foreign.vlan_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07036 @ 2013-08-11 01:44:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F4PYju7XnRBzlKZjgesSng


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;

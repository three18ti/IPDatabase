package IPDatabase;
use Socket;
use strict;
use warnings;
use Template::Stash;
use Dancer ':syntax';
use Net::IP qw(:PROC);
use Dancer::Plugin::Database;
use Dancer::Plugin::FlashMessage;

our $VERSION = '0.1';

get '/' => sub {
    template 'index.tt';
#    redirect '/people';
};

get '/overview' => sub {
    # get subnet info
    my $subnet_sql =  qq{
                    SELECT vlan.vlan, subnet.id, subnet.network, subnet.prefix 
                    FROM vlan
                    LEFT JOIN vlan_subnets ON vlan.id = vlan_subnets.vlan_id
                    LEFT JOIN subnet ON vlan_subnets.subnet_id = subnet.id
    };
    my $subnet_sth = database->prepare($subnet_sql);
    $subnet_sth->execute or die $subnet_sth->errstr;
    my $subnets = {};
#    while ( my ($vlan, $subnet_id, $network, $prefix, $gateway, $broadcast, $netmask) 
    while ( my ($vlan, $subnet_id, $network, $prefix, )  = $subnet_sth->fetchrow_array ) {
        push @{$subnets->{$vlan}}, { 
            id          => $subnet_id, 
            prefix      => $prefix, 
            network     => $network, 
#            gateway     => $gateway,
#            netmask     => $netmask,
#            broadcast   => $broadcast,
        };
    }  

    # Get vlan info
    my $vlan_sql = 'SELECT id, vlan, comment from vlan';
    my $vlan_sth = database->prepare( $vlan_sql );
    $vlan_sth->execute or die $vlan_sth->errstr;
    my $vlans = ();

    while ( my ($vlan_id, $vlan, $comment) = $vlan_sth->fetchrow_array ) {
        push @$vlans, { 
            id => $vlan_id, 
            name => $vlan, 
            comment => $comment,
            subnets => \@{$subnets->{$vlan}}
        };
    }

    template 'overview.tt' => { vlans => $vlans };    
};

get '/view_vlan/:vlan_id' => sub {
    my $vlan_id = params->{'vlan_id'};

    # get vlan name
    my $vlan_sql = qq{ SELECT vlan.vlan, vlan.comment FROM vlan WHERE vlan.id = ? };
    my $vlan_sth = database->prepare($vlan_sql);
    $vlan_sth->execute( $vlan_id ) or die $vlan_sth->errstr;

    # get subnet info
    my $subnet_sql =  qq{ 
                    SELECT subnet.id, subnet.network, subnet.prefix,
                    subnet.gateway, subnet.broadcast, subnet.netmask, subnet.comment
                    FROM vlan
                    LEFT JOIN vlan_subnets ON vlan.id = vlan_subnets.vlan_id
                    LEFT JOIN subnet ON vlan_subnets.subnet_id = subnet.id
                    WHERE vlan.id = ?
    };
    my $subnet_sth = database->prepare($subnet_sql);
    $subnet_sth->execute( $vlan_id ) or die $subnet_sth->errstr;
    my $subnets = ();
    while (my $row = $subnet_sth->fetchrow_hashref) {
        push @{$subnets}, $row;
    }
    @{$subnets} = sort { $a->{network} cmp $b->{network} } @{$subnets};

    template 'view_vlan.tt' => {
        vlan    => $vlan_sth->fetchrow_hashref,
        subnets => $subnets,
    };
};

get '/subnet/:subnet_id' => sub {
    my $subnet_id = params->{'subnet_id'};

    # get subnet information
    my $subnet_sql = qq{ 
                    SELECT subnet.network, subnet.gateway, subnet.broadcast, subnet.prefix,
                    subnet.netmask, subnet.comment
                    FROM subnet
                    WHERE subnet.id = ? 
    };
    my $subnet_sth = database->prepare( $subnet_sql );
    $subnet_sth->execute( $subnet_id ) or die $subnet_sth->errstr;
    my $subnet = $subnet_sth->fetchrow_hashref;
    
    # get ips
    my $ips_sql = qq{ 
                    SELECT ip.id, ip.ip, server.id AS 'server_id', server.name
                    FROM ip_subnet
                    LEFT JOIN ip ON ip_subnet.ip_id = ip.id
                    LEFT JOIN server_ips ON ip.id = server_ips.ip_id
                    LEFT JOIN server ON server_ips.server_id = server.id
                    WHERE ip_subnet.subnet_id = ?
    };
    my $ips_sth = database->prepare( $ips_sql );
    $ips_sth->execute( $subnet_id ) or die $ips_sth->errstr;
#    my $ips = $ips_sth->fetchall_hashref( 'ip.ip' );

    template 'subnet_view.tt' => {
        subnet  => $subnet,
        ips     => $ips_sth->fetchall_hashref( 'ip' ),
    };
};

get '/subnet/new'   => sub {
    template 'subnet_new.tt' => {

    };
};

post '/subnet/add'  => sub {
    
    my ($network, $gateway, $braodcast, $netmask, $usable, )
        = gen_subnet( params->{'subnet'}, params->{'prefix'} );

    my $subnet_sql = qq{
        INSERT INTO subnet(network, gateway, broadcast, prefix, netmask)
        VALUES ( ?, ?, ?, ?, ? );
    };
    my $subnet_sth = database->prepare($subnet_sql);
    $subnet_sth->execute($network, $gateway, $broadcast, params->{'prefix'}, $netmask);
    my $subnet_id = last_row;

    my $ip_sql = qq{
        INSERT INTO ip(ip)
        VALUES ( ? )
    };
    my $ip_sth = database->prepare($ip_sql);

    my $ip_subnet_sql = qq{
        INSERT INTO ip_subnet(subnet_id, ip_id)
        VALUES ( ?, ? )
    };
    my $ip_subnet_sth = database->prepare($ip_subnet_sql);

    foreach my $ip ( @$usable ) {
        $ip_sth->execute($ip)
        my $ip_id = last_row;
        $ip_subnet_sth->execute($subnet_id, $ip_id);
    }
    redirect "/subnet/$subnet_id";
};

get '/view_ip' => sub {
    my $sql = qq{ 
                    SELECT server.id, server.name, ip.id, ip.ip 
                    FROM server 
                    LEFT JOIN server_ips ON server.id = server_ips.server_id 
                    LEFT JOIN ip on server_ips.ip_id = ip.id
    };
    my $sth = database->prepare( $sql );
    $sth->execute or die $sth->errstr;

    my $entries = process_view_ip($sth);
    
    template 'view_ips.tt' => {
#        'entries'  => $sth->fetchall_hashref('ip'),
        'entries'   => $entries,
    };
};

sub process_view_ip {
    my $sth = shift;
    my $entries = ();
    while ( my ($server_id, $server_name, $ip_id, $ip) = $sth->fetchrow_array) {
        push @{$entries}, { 
            server => {
                id      => $server_id,
                name    => $server_name,
            },
            ip => {
                id      => $ip_id,
                ip      => $ip,
            },
        };
    }
    return $entries;
}

get '/view_server/:server_id' => sub {
    my $server_id = params->{'server_id'};

    # Get server name
    my $server_sql = qq{ SELECT server.name, server.notes FROM server WHERE server.id = ? };
    my $name_sth = database->prepare( $server_sql );
    $name_sth->execute( $server_id ) or die $name_sth->errstr;
    my ($server_name, $comments) = $name_sth->fetchrow_array;

    # Get ips
    my $sql = qq{ 
                    SELECT ip.ip 
                    FROM server_ips 
                    LEFT JOIN ip ON server_ips.ip_id = ip.id 
                    WHERE server_id = ?
    };
    my $sth = database->prepare( $sql );
    $sth->execute( $server_id ) or die $sth->errstr;
    my $ips;
    while ( my ($ip) = $sth->fetchrow_array ) {
        push @{$ips}, $ip;
    }

    template 'view_server.tt' => {
        server  => {
            name        => $server_name,
            comments    => $comments,
        },
        ips             => $ips,
    };
};

any ['get', 'post'] => '/login' => sub {
    if ( request->method eq 'POST' ) {
        if ( params->{'username'} ne setting('username')
            || params->{'password'} ne setting('password') ) {
           flash error => 'Invalid username or password';
        }
        else {
            session 'logged_in' => true;
            flash message => 'You are logged in.';
            redirect '/';
        }
    }

    template 'login.tt' => { };
};

any ['get', 'post' ] => '/logout' => sub {
    session->destroy;
    flash message => 'You have been logged out.';
    redirect '/';
};

$Template::Stash::SCALAR_OPS->{ long2ip } = sub { inet_ntoa (pack ("N*", shift)) };
$Template::Stash::SCALAR_OPS->{ int2ip } = sub { ip_bintoip ip_inttobin (shift, 4), 4 };


sub ip2long { unpack( "l*", pack( "l*", unpack( "N*", inet_aton( shift )))) }

sub last_row { database->func('last_insert_rowid') }

sub gen_subnet {
    my $network = shift;
    my $prefix = shift;
    
    my $ip = Net::IP->new($network . $prefix);

    my $network = $ip->intip;
    $ip++;
    my $gateway = $ip->intip;
    $ip++;
    
    my $usable = ();
    do {
        push @$usable, $ip->intip;
    } while ++$ip;

    my $broadcast = pop @$usable;

    my $netmask = ip_bintoint $ip->ipmask, 4;

    return $network, $gateway, $braodcast, $netmask, $usable,;
}

true;

__END__

# Experiment in getting last insert id
get '/view_ip/:ip_id' => sub {
    my $random_letter = sub {
        my @letters = ('a'..'z');
        my $random_letter = $letters[int rand @letters];
    };

    my $sql = qq{
                    SELECT server.id, server.name, ip.id, ip.ip
                    FROM ip
                    LEFT JOIN server_ips ON ip.id = server_ips.server_id
                    LEFT JOIN server on server_ips.server_id = server.id
                    WHERE ip.id = ?
    };

    my $insert_sql = qq{
                    INSERT INTO server(name)
                    VALUES( ? );
    };

    my $sth = database->prepare($insert_sql);
    $sth->execute( $random_letter->() . $random_letter->() . $random_letter->() . $random_letter->());
    my $var = database->func('last_insert_rowid');

    template 'view_ip.tt' => {
        var => $var,
    };
    
};



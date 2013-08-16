package IPDatabase;
use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::FlashMessage;

our $VERSION = '0.1';

get '/' => sub {
    template 'index.tt';
#    redirect '/people';
};

get '/overview' => sub {
    my $vlan_sql = 'SELECT vlan from vlan';
    my $vlan_sth = database->prepare( $vlan_sql );
    $vlan_sth->execute or die $vlan_sth->errstr;
    my $vlans = ();

    while ( my ($entry) = $vlan_sth->fetchall_arrayref ) {
        push @$vlans, shift $entry;
    }

#    map { push @$vlans, $_ } $vlan_sth->fetchall_arrayref;
#    $vlans = shift @$vlans;
#    @$vlans = map { shift $_ } @$vlans;

#    push @$vlans, $_ while $vlan_sth->fetchall_arrayref;

    template 'overview.tt' => { vlans => $vlans };    
};

get '/view_ip' => sub {
    my $sql = 'SELECT server.id, server.name, ip.id, ip.ip FROM server LEFT JOIN server_ips ON server.id = server_ips.server_id LEFT JOIN ip on server_ips.ip_id = ip.id';
    my $sth = database->prepare( $sql );
    $sth->execute or die $sth->errstr;

    my $entries = process_view_ip($sth);
    
    template 'view_ips.tt' => {
#        'entries'  => $sth->fetchall_hashref('ip'),
        'entries'   => $entries,
    };
};

get '/view_ip/:ip_id' => sub {
    my $sql = '';
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
    my $server_sql = 'SELECT server.name FROM server WHERE server.id = ?';
    my $name_sth = database->prepare( $server_sql );
    $name_sth->execute( $server_id );
    my ($server_name, $comments) = $name_sth->fetchrow_array;

    # Get ips
    my $sql = 'SELECT ip.ip FROM server_ips LEFT JOIN ip ON server_ips.ip_id = ip.id WHERE server_id = ?';
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

true;

package IPDatabase;
use Dancer ':syntax';
use Dancer::Plugin::SimpleCRUD;

our $VERSION = '0.1';

simple_crud(
    db_connection_name  => 'foo',
    record_title    => 'Server',
    db_table        => 'server',
    prefix          => '/server',
    deleteable      => 'yes',
    sortable        => 'yes',
    downloadable    => 1,
    foreign_keys    => {
        server_ips  => {
            table           => 'ip',
            key_column      => 'id',
            label_column    => 'ip',
        }
    },
);

simple_crud(
    record_title => 'Person',
    db_table => 'people',
    db_connection_name => 'foo',
    prefix => '/people',
    acceptable_values => {
        gender => [ qw( Male Female ) ],
    },
    deletable => 'yes',
    sortable => 'yes',
    paginate => 5,
    downloadable => 1,
    foreign_keys => {
        employer_id => {
            table        => 'employer',
            key_column   => 'id',
            label_column => 'name',
        },
    },
    custom_columns => {
        mailto_link => {
            raw_column => 'email',
            transform  => sub { my $email = shift; return "<a href='mailto:$email'>mail</a>"; },
        },
        full_name => {
            raw_column => "(first_name || ' ' || last_name)",
            transform => sub { return shift }, # (unnecessary, btw, as this is the default)
        },
    },
    auth => {
        view => {
            require_login => 1,
        },
        edit => {
            require_role => 'editor',
        },
    },
);

simple_crud(
    record_title    => 'Employer',
    db_table        => 'employer',
    db_connection_name  => 'foo',
    prefix          => '/employer',
);

get '/' => sub {
    template 'index';
#    redirect '/people';
};

true;

PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

DROP TABLE IF EXISTS server;
CREATE TABLE server (
    id          INTEGER PRIMARY KEY,
    name        VARCHAR UNIQUE,
    notes       VARCHAR
);

DROP TABLE IF EXISTS ip;
CREATE TABLE ip (
    id          INTEGER PRIMARY KEY,
    ip          INTEGER UNIQUE,
    notes       VARCHAR
);

DROP TABLE IF EXISTS subnet;
CREATE TABLE subnet (
    id          INTEGER PRIMARY KEY,
    network     INTEGER UNIQUE,
    gateway     INTEGER UNIQUE,
    broadcast   INTEGER UNIQUE,
    prefix      VARCHAR,
    netmask     INTEGER,
    comment     VARCHAR
);

DROP TABLE IF EXISTS vlan;
CREATE TABLE vlan (
    id          INTEGER PRIMARY KEY,
    vlan        INTEGER,
    title       VARCHAR,
    comment     VARCHAR
);

DROP TABLE IF EXISTS vlan_subnets;
CREATE TABLE vlan_subnets (
    vlan_id     INTEGER,
    subnet_id   INTEGER,
    FOREIGN KEY(vlan_id)    REFERENCES vlan(id)     ON DELETE CASCADE,
    FOREIGN KEY(subnet_id)  REFERENCES subnet(id)   ON DELETE CASCADE
);


DROP TABLE IF EXISTS ip_subnet;
CREATE TABLE ip_subnet (
    subnet_id   INTEGER,
    ip_id       INTEGER,
    FOREIGN KEY(subnet_id)  REFERENCES subnet(id)   ON DELETE CASCADE,
    FOREIGN KEY(ip_id)      REFERENCES ip(id)       ON DELETE CASCADE
);

DROP TABLE IF EXISTS server_ips;
CREATE TABLE server_ips (
    server_id   INTEGER,
    ip_id       INTEGER,
    FOREIGN KEY(server_id)  REFERENCES server(id)   ON DELETE CASCADE,
    FOREIGN KEY(ip_id)      REFERENCES ip(id)       ON DELETE CASCADE
);

CREATE INDEX subnet_index       ON ip_subnet(subnet_id);
CREATE INDEX ip_subnet_index    ON ip_subnet(ip_id);
CREATE INDEX server_index       ON server_ips(server_id);
CREATE INDEX ip_index           ON server_ips(ip_id);
CREATE INDEX vlan_index         ON vlan_subnets(vlan_id);
CREATE INDEX subnet_vlan_index  ON vlan_subnets(subnet_id);

INSERT INTO "server" VALUES(1, 'abc-123', '' );
INSERT INTO "server" VALUES(2, 'def-456', '' );
INSERT INTO "server" VALUES(3, 'hij-654', '' );
INSERT INTO "server" VALUES(4, 'zxc-576', '' );
INSERT INTO "server" VALUES(5, 'fgh-753', '' );

INSERT INTO "vlan" VALUES(1, 000, 'Unassigned', '' ); 
INSERT INTO "vlan" VALUES(2, 100, 'Foo',        '' ); 
INSERT INTO "vlan" VALUES(3, 130, 'Public',     '' ); 
INSERT INTO "vlan" VALUES(4, 131, 'Private',    '' ); 

INSERT INTO "ip" VALUES(1, 3232235522, '' );
INSERT INTO "ip" VALUES(2, 3232235523, '' );
INSERT INTO "ip" VALUES(3, 3232235524, '' );
INSERT INTO "ip" VALUES(4, 3232235525, '' );
INSERT INTO "ip" VALUES(5, 168427522, '' );
INSERT INTO "ip" VALUES(6, 168427523, '' );
INSERT INTO "ip" VALUES(7, 168427524, '' );
INSERT INTO "ip" VALUES(8, 168427525, '' );
INSERT INTO "ip" VALUES(9, 2885683714, '' );
INSERT INTO "ip" VALUES(10, 2885683715, '' );
INSERT INTO "ip" VALUES(11, 2885683716, '' );
INSERT INTO "ip" VALUES(12, 2885683717, '' );

INSERT INTO "subnet" VALUES(1, '3232235520', '3232235521', '3232235775', '/24', '4294967040', '');
INSERT INTO "subnet" VALUES(2, '168427520', '168427521', '168427775', '/24', '4294967040', '');
INSERT INTO "subnet" VALUES(3, '2885683712', '2885683713', '2885683967', '/24', '4294967040', '');

INSERT INTO "vlan_subnets" VALUES(2, 1);
INSERT INTO "vlan_subnets" VALUES(2, 2);
INSERT INTO "vlan_subnets" VALUES(3, 3);

INSERT INTO "ip_subnet" VALUES(1, 1);
INSERT INTO "ip_subnet" VALUES(1, 2);
INSERT INTO "ip_subnet" VALUES(1, 3);
INSERT INTO "ip_subnet" VALUES(1, 4);
INSERT INTO "ip_subnet" VALUES(2, 5);
INSERT INTO "ip_subnet" VALUES(2, 6);
INSERT INTO "ip_subnet" VALUES(2, 7);
INSERT INTO "ip_subnet" VALUES(2, 8);
INSERT INTO "ip_subnet" VALUES(3, 9);
INSERT INTO "ip_subnet" VALUES(3, 10);
INSERT INTO "ip_subnet" VALUES(3, 11);
INSERT INTO "ip_subnet" VALUES(3, 12);

INSERT INTO "server_ips" VALUES(1, 1);
INSERT INTO "server_ips" VALUES(2, 2);
INSERT INTO "server_ips" VALUES(3, 3);
INSERT INTO "server_ips" VALUES(3, 4);
INSERT INTO "server_ips" VALUES(4, 5);
INSERT INTO "server_ips" VALUES(4, 6);
INSERT INTO "server_ips" VALUES(4, 7);
INSERT INTO "server_ips" VALUES(4, 8);
INSERT INTO "server_ips" VALUES(5, 9);
INSERT INTO "server_ips" VALUES(5, 10);
INSERT INTO "server_ips" VALUES(5, 11);
INSERT INTO "server_ips" VALUES(5, 12);

COMMIT;


/* get server name and ips */
SELECT server.name, ip.ip
FROM server
LEFT JOIN server_ips ON server.id = server_ips.server_id
LEFT JOIN ip on server_ips.ip_id = ip.id;

/* Find server name based on IP */
SELECT server.name
FROM server
LEFT JOIN server_ips ON server.id = server_ips.server_id
LEFT JOIN ip on server_ips.ip_id = ip.id
WHERE ip.ip = '192.168.0.2';

/* get ip and subnet */
SELECT ip.ip, subnet.network, subnet.gateway, subnet.broadcast, subnet.prefix, subnet.netmask
FROM ip
LEFT JOIN ip_subnet ON ip.id = ip_subnet.ip_id
LEFT JOIN subnet ON ip_subnet.subnet_id = subnet.id;

/* Get Vlans and IP addresses */
SELECT vlan.vlan, subnet.network
FROM vlan
LEFT JOIN vlan_subnets ON vlan.id = vlan_subnets.vlan_id
LEFT JOIN subnet ON vlan_subnets.subnet_id = subnet.id;

/* Select IPs subnets and VLANs */
SELECT ip.ip, subnet.network, subnet.gateway, subnet.broadcast, vlan.vlan
FROM ip
LEFT JOIN ip_subnet ON ip.id = ip_subnet.ip_id
LEFT JOIN subnet ON ip_subnet.subnet_id = subnet.id
LEFT JOIN vlan_subnets ON subnet.id = vlan_subnets.subnet_id
LEFT JOIN vlan ON vlan_subnets.vlan_id = vlan.id;

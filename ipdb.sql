PRAGMA foreign_keys = ON;
BEGIN TRANSACTION;

DROP TABLE IF EXISTS server;
CREATE TABLE server (
    id INTEGER PRIMARY KEY,
    name VARCHAR
);

DROP TABLE IF EXISTS ip;
CREATE TABLE ip (
    id INTEGER PRIMARY KEY,
    ip          VARCHAR
);

DROP TABLE IF EXISTS subnet;
CREATE TABLE subnet (
    id INTEGER PRIMARY KEY,
    prefix      VARCHAR,
    netmask     VARCHAR,
    network     VARCHAR,
    gateway     VARCHAR,
    broadcast   VARCHAR
);

DROP TABLE IF EXISTS ip_subnet;
CREATE TABLE ip_subnet (
    subnet_id   INTEGER,
    ip_id       INTEGER,
    FOREIGN KEY(subnet_id) REFERENCES subnet(id) ON DELETE CASCADE,
    FOREIGN KEY(ip_id) REFERENCES ip(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS server_ips;
CREATE TABLE server_ips (
    server_id   INTEGER,
    ip_id       INTEGER,
    FOREIGN KEY(server_id) REFERENCES server(id) ON DELETE CASCADE,
    FOREIGN KEY(ip_id) REFERENCES ip(id) ON DELETE CASCADE
);

CREATE INDEX subnet_index ON ip_subnet(subnet_id);
CREATE INDEX ip_subnet_index ON ip_subnet(ip_id);
CREATE INDEX server_index ON server_ips(server_id);
CREATE INDEX ip_index ON server_ips(ip_id);

INSERT INTO "server" VALUES(1, 'y0319p118' );
INSERT INTO "server" VALUES(2, 'y0319p119' );
INSERT INTO "server" VALUES(3, 'y0319t05' );
INSERT INTO "server" VALUES(4, 'y0319t09' );

INSERT INTO "ip" VALUES(1, '192.168.0.2' );
INSERT INTO "ip" VALUES(2, '192.168.0.3' );
INSERT INTO "ip" VALUES(3, '192.168.0.4' );
INSERT INTO "ip" VALUES(4, '192.168.0.5' );
INSERT INTO "ip" VALUES(5, '10.10.0.2' );
INSERT INTO "ip" VALUES(6, '10.10.0.3' );
INSERT INTO "ip" VALUES(7, '10.10.0.4' );
INSERT INTO "ip" VALUES(8, '10.10.0.5' );

INSERT INTO "subnet" VALUES(1, '/24', '255.255.255.0', '192.168.0.0', '192.168.0.1', '192.168.0.255');
INSERT INTO "subnet" VALUES(2, '/24', '255.255.255.0', '10.10.0.0', '10.10.0.1', '10.10.0.255');

INSERT INTO "ip_subnet" VALUES(1, 1);
INSERT INTO "ip_subnet" VALUES(1, 2);
INSERT INTO "ip_subnet" VALUES(1, 3);
INSERT INTO "ip_subnet" VALUES(1, 4);
INSERT INTO "ip_subnet" VALUES(2, 5);
INSERT INTO "ip_subnet" VALUES(2, 6);
INSERT INTO "ip_subnet" VALUES(2, 7);
INSERT INTO "ip_subnet" VALUES(2, 8);

INSERT INTO "server_ips" VALUES(1, 1);
INSERT INTO "server_ips" VALUES(2, 2);
INSERT INTO "server_ips" VALUES(3, 3);
INSERT INTO "server_ips" VALUES(3, 4);
INSERT INTO "server_ips" VALUES(4, 5);
INSERT INTO "server_ips" VALUES(4, 6);
INSERT INTO "server_ips" VALUES(4, 7);
INSERT INTO "server_ips" VALUES(4, 8);

COMMIT;


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

# Subnet Calculator

Subnetting calculator written in Bash. Calculates first host, last host, network, and broadcast address. Work in progress

### Sample usage & output

```
zylai:~ zylai$ ./subnet.sh 
Enter IPv4: 6.141.159.137
Enter subnet mask in CIDR notation: 14
Network: 6.140.0.0
Broadcast: 6.143.255.255
First host: 209.128.0.1  <----- this is incorrect, being worked on at the moment
Last host: 209.255.255.6  <----- this is incorrect, being worked on at the moment
```

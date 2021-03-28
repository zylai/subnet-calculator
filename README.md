# Subnet Calculator

### Work in progress

Subnetting calculator written in Bash using basic UNIX tools. Calculates first host, last host, network, and broadcast address. Also includes generator that generates practice problems and checks your answer (work in progress). Tested with Ubuntu 18 and macOS Catalina (10.15).

### Sample usage & output

```
$ ./subnet.sh 
Enter IPv4: 6.141.159.137
Enter subnet mask in CIDR notation: 14
----------RESULTS----------
Network: 6.140.0.0
First host: 6.140.0.1
Last host: 6.143.255.254
Broadcast: 6.143.255.255
---------------------------
```

### Roadmap
- Finish practice problem generator
- Better way to calculate first & last host
  - Currently, the script just takes the last octet and adds or minus 1. This causes overflow issues.

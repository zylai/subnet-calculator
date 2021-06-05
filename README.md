# Subnet Calculator

Subnetting calculator written in Bash using basic UNIX tools. Calculates first host, last host, network, and broadcast address. Also includes generator that generates practice problems and checks your answer. 

Tested with Ubuntu 20.04 (Bash 4.4.20) and up, and macOS 10.15 Catalina (Bash 3.2.57) and up.

### Usage & sample output

```
$ ./subnet.sh
Enter IPv4: 186.242.12.66
Enter subnet mask in CIDR notation: 20
-----------------------------
Network: 186.242.0.0
First host: 186.242.0.1
Last host: 186.242.15.254
Broadcast: 186.242.15.255
```

Or, just pass the entire IP and CIDR as an input:

```
$ ./subnet.sh 186.242.12.66/20
Network: 186.242.0.0
First host: 186.242.0.1
Last host: 186.242.15.254
Broadcast: 186.242.15.255
```

Practice problem generator and answer checker:

```
$ ./practice.sh 
238.149.197.28/22
Enter your solution in the following format: Network/First/Last/Broadcast
-> 238.149.196.0/238.149.196.1/238.149.199.255/238.149.199.255        
--------------------------------------------------
network: 238.149.196.0 — CORRECT
first: 238.149.196.1 — CORRECT
last: 238.149.199.254 — INCORRECT
broadcast: 238.149.199.255 — CORRECT
```

### Roadmap
- Re-write some code in `subnet.sh` to utilize loops when splicing/merging IP address to/from octets

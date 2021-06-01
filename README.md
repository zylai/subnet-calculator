# Subnet Calculator

### Practice problem generator is a work-in-progress. Subnet calculator is complete and tested working.

Subnetting calculator written in Bash using basic UNIX tools. Calculates first host, last host, network, and broadcast address. Also includes generator that generates practice problems (complete) and checks your answer (work in progress). 

Tested with Ubuntu 18 (Bash version 4.4.20) and macOS 10.15 Catalina (Bash version 3.2.57).

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

Or, just pass the entire IP and CIDR as an input

```
$ ./subnet.sh 186.242.12.66/20
Network: 186.242.0.0
First host: 186.242.0.1
Last host: 186.242.15.254
Broadcast: 186.242.15.255
```

### Roadmap
- Finish practice problem generator
- Re-factor some code in `subnet.sh` to utilize loops when splicing/merging IP address to/from octets

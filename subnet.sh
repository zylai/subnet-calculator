#!/bin/bash

convert2binary() {
	for octet in 1 2 3 4
	do
		converted=$converted$(echo "obase=2;`echo $1 | cut -d'.' -f$octet`" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}')"."
	done

	# remove last trailing dot https://unix.stackexchange.com/a/229994
	echo $converted | sed 's/.$//'
}

printf "Enter IPv4: "
read ipv4

printf "Enter subnet mask or CIDR: "
read mask

# https://stackoverflow.com/a/25969006
ipv4_regex='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# https://stackoverflow.com/a/18710850
if ! [[ $ipv4 =~ $ipv4_regex ]]
then
	echo "Invalid IPv4 address"
	exit 1
fi

convert2binary $ipv4

#d_ipo1=`echo $ipv4 | cut -d'.' -f1`
#d_ipo2=`echo $ipv4 | cut -d'.' -f2`
#d_ipo3=`echo $ipv4 | cut -d'.' -f3`
#d_ipo4=`echo $ipv4 | cut -d'.' -f4`

# https://stackoverflow.com/a/12633807
#b_ipo1=`echo "obase=2;$d_ipo1" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`
#b_ipo2=`echo "obase=2;$d_ipo2" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`
#b_ipo3=`echo "obase=2;$d_ipo3" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`
#b_ipo4=`echo "obase=2;$d_ipo4" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`

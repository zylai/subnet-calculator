#!/bin/bash

# https://stackoverflow.com/a/10768196
dec2ip () {
    local ip dec=$@
    for e in {3..0}
    do
        ((octet = dec / (256 ** e) ))
        ((dec -= octet * 256 ** e))
        ip+=$delim$octet
        delim=.
    done
    printf '%s\n' "$ip"
}

# https://stackoverflow.com/a/10768196
ip2dec () {
    local a b c d ip=$@
    IFS=. read -r a b c d <<< "$ip"
    printf '%d\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

ip4dec2binary() {
	for octet in 1 2 3 4
	do
		converted=$converted$(echo "obase=2;`echo $1 | cut -d'.' -f$octet`" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}')"."
	done

	# remove last trailing dot https://unix.stackexchange.com/a/229994
	echo $converted | sed 's/.$//'
}

if [[ $# == 0 ]] || [[ $# -gt 2 ]]
then
	printf "Enter IPv4: "
	read ipv4_decimal
fi

if [[ $# == 1 ]]
then
	echo "$1" | grep "/" &>/dev/null
	if [[ $? == 1 ]]
	then
		echo "Invalid IPv4 & CIDR mask format"
		exit 1
		# TODO: instead of hard exit, assume input is IP address only and prompt user for mask
	fi
	ipv4_decimal=`echo "$1" | cut -f1 -d"/"`
	user_input_mask=`echo "$1" | cut -f2 -d"/"`
fi

if [[ $# == 2 ]]
then
	ipv4_decimal=`echo "$1"`
	user_input_mask=`echo "$2"`
fi

# Check if user input is valid IP
# https://stackoverflow.com/a/25969006
ipv4_decimal_regex='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# https://stackoverflow.com/a/18710850
if ! [[ "$ipv4_decimal" =~ $ipv4_decimal_regex ]]
then
	echo "Invalid IPv4 address"
	exit 1
fi

if [[ $# == 0 ]] || [[ $# -gt 2 ]]
then
	printf "Enter subnet mask in CIDR notation: "
	read user_input_mask
	echo "-----------------------------"
fi

mask_decimal=`echo $user_input_mask | tr -d "/"`

if ! [[ "$mask_decimal" -le 32 ]]
then
	echo "Invalid subnet mask"
	exit 1
fi

ipv4_binary=`ip4dec2binary $ipv4_decimal`
ipv4_binary_no_dots=`echo $ipv4_binary | tr -d "."`

ipv4_decimal_octet_1=`echo $ipv4_decimal | cut -d'.' -f1`
ipv4_decimal_octet_2=`echo $ipv4_decimal | cut -d'.' -f2`
ipv4_decimal_octet_3=`echo $ipv4_decimal | cut -d'.' -f3`
ipv4_decimal_octet_4=`echo $ipv4_decimal | cut -d'.' -f4`

ipv4_binary_octet_1=`echo $ipv4_binary | cut -d'.' -f1`
ipv4_binary_octet_2=`echo $ipv4_binary | cut -d'.' -f2`
ipv4_binary_octet_3=`echo $ipv4_binary | cut -d'.' -f3`
ipv4_binary_octet_4=`echo $ipv4_binary | cut -d'.' -f4`

mask_decimal_remainder=`echo "32-$mask_decimal" | bc`

# Create string of repeated 0s (network address) or 1s (broadcast address)
# https://stackoverflow.com/a/3212714
mask_binary_remainder_zeros=`len=$mask_decimal_remainder ch='0'; printf '%*s' "$len" | tr ' ' "$ch"`
mask_binary_remainder_ones=`len=$mask_decimal_remainder ch='1'; printf '%*s' "$len" | tr ' ' "$ch"`

# Split the binary string at position of the subnet mask
# For example, if the CIDR mask is /10, get the first 10 characters and discard everything else
calculated_binary_ipv4_partial=`echo $ipv4_binary_no_dots | cut -c -$mask_decimal`

# Fill the split binary string with trailing zeros (network) or ones (broadcast) so it's back at 32 chars
calculated_ipv4_binary_network_addr_no_dots=$calculated_binary_ipv4_partial$mask_binary_remainder_zeros
calculated_ipv4_binary_broadcast_addr_no_dots=$calculated_binary_ipv4_partial$mask_binary_remainder_ones

# Split everything back to octets and convert to decimal
# Binary to decimal: https://unix.stackexchange.com/a/65286
calculated_ipv4_binary_network_addr_octet_1=`echo $calculated_ipv4_binary_network_addr_no_dots | cut -c 1-8`
calculated_ipv4_binary_network_addr_octet_2=`echo $calculated_ipv4_binary_network_addr_no_dots | cut -c 9-16`
calculated_ipv4_binary_network_addr_octet_3=`echo $calculated_ipv4_binary_network_addr_no_dots | cut -c 17-24`
calculated_ipv4_binary_network_addr_octet_4=`echo $calculated_ipv4_binary_network_addr_no_dots | cut -c 25-32`

calculated_ipv4_decimal_network_addr_octet_1=`echo "$((2#$calculated_ipv4_binary_network_addr_octet_1))"`
calculated_ipv4_decimal_network_addr_octet_2=`echo "$((2#$calculated_ipv4_binary_network_addr_octet_2))"`
calculated_ipv4_decimal_network_addr_octet_3=`echo "$((2#$calculated_ipv4_binary_network_addr_octet_3))"`
calculated_ipv4_decimal_network_addr_octet_4=`echo "$((2#$calculated_ipv4_binary_network_addr_octet_4))"`

calculated_ipv4_binary_broadcast_addr_octet_1=`echo $calculated_ipv4_binary_broadcast_addr_no_dots | cut -c 1-8`
calculated_ipv4_binary_broadcast_addr_octet_2=`echo $calculated_ipv4_binary_broadcast_addr_no_dots | cut -c 9-16`
calculated_ipv4_binary_broadcast_addr_octet_3=`echo $calculated_ipv4_binary_broadcast_addr_no_dots | cut -c 17-24`
calculated_ipv4_binary_broadcast_addr_octet_4=`echo $calculated_ipv4_binary_broadcast_addr_no_dots | cut -c 25-32`

calculated_ipv4_decimal_broadcast_addr_octet_1=`echo "$((2#$calculated_ipv4_binary_broadcast_addr_octet_1))"`
calculated_ipv4_decimal_broadcast_addr_octet_2=`echo "$((2#$calculated_ipv4_binary_broadcast_addr_octet_2))"`
calculated_ipv4_decimal_broadcast_addr_octet_3=`echo "$((2#$calculated_ipv4_binary_broadcast_addr_octet_3))"`
calculated_ipv4_decimal_broadcast_addr_octet_4=`echo "$((2#$calculated_ipv4_binary_broadcast_addr_octet_4))"`

result_network_addr="$calculated_ipv4_decimal_network_addr_octet_1.$calculated_ipv4_decimal_network_addr_octet_2.$calculated_ipv4_decimal_network_addr_octet_3.$calculated_ipv4_decimal_network_addr_octet_4"
result_broadcast_addr="$calculated_ipv4_decimal_broadcast_addr_octet_1.$calculated_ipv4_decimal_broadcast_addr_octet_2.$calculated_ipv4_decimal_broadcast_addr_octet_3.$calculated_ipv4_decimal_broadcast_addr_octet_4"
result_first_addr=$(dec2ip `echo "$(ip2dec $result_network_addr)+1" | bc`)
result_last_addr=$(dec2ip `echo "$(ip2dec $result_broadcast_addr)-1" | bc`)

# TODO: Special case for calculating /31 and /32

#echo "----------RESULTS----------"
echo "Network: $result_network_addr"
echo "First host: $result_first_addr"
echo "Last host: $result_last_addr"
echo "Broadcast: $result_broadcast_addr"
#echo "---------------------------"

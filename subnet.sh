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
read ipv4_decimal

# Check if user input is valid IP
# https://stackoverflow.com/a/25969006
ipv4_decimal_regex='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# https://stackoverflow.com/a/18710850
if ! [[ "$ipv4_decimal" =~ $ipv4_decimal_regex ]]
then
	echo "Invalid IPv4 address"
	exit 1
fi

printf "Enter subnet mask in CIDR notation: "
read user_input_mask

mask_decimal=`echo $user_input_mask | tr -d "/"`

if ! [[ "$mask_decimal" -le 32 ]]
then
	echo "Invalid subnet mask"
	exit 1
fi

ipv4_binary=`convert2binary $ipv4_decimal`
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

# Create string of repeated 0s or 1s
# https://stackoverflow.com/a/3212714
mask_binary_remainder_zeros=`len=$mask_decimal_remainder ch='0'; printf '%*s' "$len" | tr ' ' "$ch"`
mask_binary_remainder_ones=`len=$mask_decimal_remainder ch='1'; printf '%*s' "$len" | tr ' ' "$ch"`

# Split the binary string at position of the subnet mask
calculated_binary_ipv4_partial=`echo $ipv4_binary_no_dots | cut -c -$mask_decimal`

# Fill the split binary string with trailing zeros or ones so it's back at 32 chars
calculated_ipv4_binary_network_addr_no_dots=$calculated_binary_ipv4_partial$mask_binary_remainder_zeros
calculated_ipv4_binary_broadcast_addr_no_dots=$calculated_binary_ipv4_partial$mask_binary_remainder_ones

# Convert back to decimal first and perform +1 and -1 operation (to find the first and last host) using echo "obase=2;1001010011101+1" | bc
# https://unix.stackexchange.com/a/65286
calculated_ipv4_decimal_network_addr_added_value=`echo "$((2#$calculated_ipv4_binary_network_addr_no_dots))"`
calculated_ipv4_decimal_broadcast_addr_added_value=`echo "$((2#$calculated_ipv4_binary_broadcast_addr_no_dots))"`

calculated_ipv4_binary_first_host_no_dots=`echo "obase=2;$calculated_ipv4_decimal_network_addr_added_value+1" | bc`
calculated_ipv4_binary_last_host_no_dots=`echo "obase=2;$calculated_ipv4_decimal_broadcast_addr_added_value-1" | bc`

# Split everything back to octets and convert to decimal
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

calculated_ipv4_binary_first_host_octet_1=`echo $calculated_ipv4_binary_first_host_no_dots | cut -c 1-8`
calculated_ipv4_binary_first_host_octet_2=`echo $calculated_ipv4_binary_first_host_no_dots | cut -c 9-16`
calculated_ipv4_binary_first_host_octet_3=`echo $calculated_ipv4_binary_first_host_no_dots | cut -c 17-24`
calculated_ipv4_binary_first_host_octet_4=`echo $calculated_ipv4_binary_first_host_no_dots | cut -c 25-32`

calculated_ipv4_decimal_first_host_octet_1=`echo "$((2#$calculated_ipv4_binary_first_host_octet_1))"`
calculated_ipv4_decimal_first_host_octet_2=`echo "$((2#$calculated_ipv4_binary_first_host_octet_2))"`
calculated_ipv4_decimal_first_host_octet_3=`echo "$((2#$calculated_ipv4_binary_first_host_octet_3))"`
calculated_ipv4_decimal_first_host_octet_4=`echo "$((2#$calculated_ipv4_binary_first_host_octet_4))"`

calculated_ipv4_binary_last_host_octet_1=`echo $calculated_ipv4_binary_last_host_no_dots | cut -c 1-8`
calculated_ipv4_binary_last_host_octet_2=`echo $calculated_ipv4_binary_last_host_no_dots | cut -c 9-16`
calculated_ipv4_binary_last_host_octet_3=`echo $calculated_ipv4_binary_last_host_no_dots | cut -c 17-24`
calculated_ipv4_binary_last_host_octet_4=`echo $calculated_ipv4_binary_last_host_no_dots | cut -c 25-32`

calculated_ipv4_decimal_last_host_octet_1=`echo "$((2#$calculated_ipv4_binary_last_host_octet_1))"`
calculated_ipv4_decimal_last_host_octet_2=`echo "$((2#$calculated_ipv4_binary_last_host_octet_2))"`
calculated_ipv4_decimal_last_host_octet_3=`echo "$((2#$calculated_ipv4_binary_last_host_octet_3))"`
calculated_ipv4_decimal_last_host_octet_4=`echo "$((2#$calculated_ipv4_binary_last_host_octet_4))"`

echo "Network: $calculated_ipv4_decimal_network_addr_octet_1.$calculated_ipv4_decimal_network_addr_octet_2.$calculated_ipv4_decimal_network_addr_octet_3.$calculated_ipv4_decimal_network_addr_octet_4"
echo "Broadcast: $calculated_ipv4_decimal_broadcast_addr_octet_1.$calculated_ipv4_decimal_broadcast_addr_octet_2.$calculated_ipv4_decimal_broadcast_addr_octet_3.$calculated_ipv4_decimal_broadcast_addr_octet_4"
echo "First host: $calculated_ipv4_decimal_first_host_octet_1.$calculated_ipv4_decimal_first_host_octet_2.$calculated_ipv4_decimal_first_host_octet_3.$calculated_ipv4_decimal_first_host_octet_4"
echo "Last host: $calculated_ipv4_decimal_last_host_octet_1.$calculated_ipv4_decimal_last_host_octet_2.$calculated_ipv4_decimal_last_host_octet_3.$calculated_ipv4_decimal_last_host_octet_4"


# https://stackoverflow.com/a/12633807
#b_ipo1=`echo "obase=2;$d_ipo1" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`
#b_ipo2=`echo "obase=2;$d_ipo2" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`
#b_ipo3=`echo "obase=2;$d_ipo3" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`
#b_ipo4=`echo "obase=2;$d_ipo4" | bc | awk '{ len = (8 - length % 8) % 8; printf "%.*s%s\n", len, "00000000", $0}'`

#!/bin/bash

# Generate a random IP, first octet cannot be 0
# https://blog.eduonix.com/shell-scripting/generating-random-numbers-in-linux-shell-scripting/
ip=`echo "$(($(($RANDOM%254))+1)).$((RANDOM%255)).$((RANDOM%255)).$((RANDOM%255))"`

# Generate a random CIDR mask, excluding /8 /16 /24 /31 /32 because that's just too easy
mask=`printf "9\n10\n11\n12\n13\n14\n15\n17\n18\n19\n20\n21\n22\n23\n25\n26\n27\n28\n29\n30" | sort -R | head -n1`

problem="$ip/$mask"
echo "$problem"

echo "Enter your solution in the following format: Network/First/Last/Broadcast"
printf "-"
printf "> "

read input

answer=`./subnet.sh $problem` # does not work, cannot save multi-line output

echo $answer

answer_network=`echo $answer | grep "Network:" | cut -f2 -d" "`
answer_first=`echo $answer | grep "First:" | cut -f2 -d" "`
answer_last=`echo $answer | grep "Last:" | cut -f2 -d" "`
answer_broadcast=`echo $answer | grep "Broadcast:" | cut -f2 -d" "`

echo $answer_network
echo $answer_first
echo $answer_last
echo $answer_broadcast

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

read response

response_network=`echo $response | cut -f1 -d/`
response_first=`echo $response | cut -f2 -d/`
response_last=`echo $response | cut -f3 -d/`
response_broadcast=`echo $response | cut -f4 -d/`

answer="`./subnet.sh $problem | tr -d '\n [a-z][A-Z]'`"

answer_network=`echo $answer | cut -f2 -d:`
answer_first=`echo $answer | cut -f3 -d:`
answer_last=`echo $answer | cut -f4 -d:`
answer_broadcast=`echo $answer | cut -f5 -d:`

echo $response_network
echo $response_first
echo $response_last
echo $response_broadcast

echo $answer_network
echo $answer_first
echo $answer_last
echo $answer_broadcast

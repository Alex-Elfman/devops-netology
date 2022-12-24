#!/usr/bin/env bash
hosts=(192.168.0.1 173.194.222.113 87.250.250.24)
timeout=5
result=0

while (($result == 0))
do
    for p in ${hosts[@]}
    do
	curl -Is --connect-timeout $timeout $p:80 >/dev/null
	result=$?
	if (($result != 0))
	then
	    echo " ERROR on " $p status=$result >>error.log
	fi
    done
done

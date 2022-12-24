#!/usr/bin/env bash
hosts=(192.168.0.1 173.194.222.113 87.250.250.24)
timeout=5
for i in {1..5}
do
date >>hosts.log
    for h in ${hosts[@]}
    do
	curl -Is --connect-timeout $timeout $h:80 >/dev/null
        echo "    check" $h status=$? >>hosts.log
    done
done

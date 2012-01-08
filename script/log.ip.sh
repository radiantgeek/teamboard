grep 192\.168 <log.txt | grep GET | grep -v json > log.ip 
awk '/for (.*) at/ {print $5}' log.ip >log.ip.only
sort log.ip.only | uniq
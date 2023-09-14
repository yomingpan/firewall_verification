# firewall_verification

preapare your firewall rules as be a file, firewall.txt.
the format is as below.

```
tcp:www.google.com:80,443
tcp:taltwx.tatw.nctu.edu.tw: 22,29,80,90,443,255
tcp:mqttprod.nctu.edu.tw:1885,6000
udp:dnsprod.nctu.edu.tw:53
tcp:www.google.com:123
```


# you can use those command to verify the firewall rules separately.

```
./check_ports.sh -f firewall.txt
./check_ports.sh -f firewall.txt -v
./check_ports.sh -f firewall.txt -vv
```

#!/bin/bash
architecture=$(uname -a)
physicalcpu=$(grep "physical id" /proc/cpuinfo | wc -l)
virtualcpu=$(grep "processor" /proc/cpuinfo | wc -l)
fullram=$(free --mega | awk '$1 == "Mem:" {print $2}')
usedram=$(free --mega | awk '$1 == "Mem:" {print $3}')
percentram=$(free | awk '/Mem/{printf("%.2f"), $3/$2*100}')
fulldisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
useddisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
percentdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft += $2} END {printf("%d"), ut/ft*100}')
cpuload=$(top -bn1 | grep '%Cpu' | awk '{printf("%.1f%"), $2 + $4}')
lastboot=$(uptime -s | rev | cut -c 4- | rev)
lvmuse=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
connecttcp=$(ss -neopt state established | wc -l)
userlog=$(users | wc -w)
ipaddress=$(hostname -I)
macaddress=$(ip link show | grep "ether" | cut -c 16- | rev | cut -c 23- | rev)
sudocommands=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "    #Architecture: $architecture
    #CPU physical: $physicalcpu
    #vCPU: $virtualcpu
    #Memory Usage: $usedram/${fullram}MB ($percentram%)
    #Disk Usage: $useddisk/${fulldisk}Gb ($percentdisk%)
    #CPU load: $cpuload
    #Last boot: $lastboot
    #LVM use: $lvmuse
    #Connections TCP: $connecttcp ESTABLISHED
    #User log: $userlog
    #Network: IP $ipaddress ($macaddress)
    #Sudo: $sudocommands cmd"

#!/bin/sh
_DEBUG="on"
DEBUGFILE=/var/log/redis/sentinel_failover.log
VIP='VIPADDRESS'
MASTERIP=${6}
MASK='24'
IFACE='ens192'
MYIP=$(ip -4 -o addr show dev ${IFACE}| grep -v secondary| awk '{split($4,a,"/");print a[1]}')

DEBUG () {
        if [ "$_DEBUG" = "on" ]; then
                $@
        fi
}

set -e
DEBUG date >> ${DEBUGFILE}
DEBUG echo $@ >> ${DEBUGFILE}

DEBUG echo "Master: ${MASTERIP} My IP: ${MYIP}" >> ${DEBUGFILE}
if [ ${MASTERIP} = ${MYIP} ]; then
        if [ $(ip addr show ${IFACE} | grep ${VIP} | wc -l) = 0 ]; then
                sudo /sbin/ip addr add ${VIP}/${MASK} dev ${IFACE}
                DEBUG echo "sudo /sbin/ip addr add ${VIP}/${MASK} dev ${IFACE}" >> ${DEBUGFILE}
                sudo /usr/sbin/arping -q -c 3 -A ${VIP} -I ${IFACE}
        fi
        exit 0
else
        if [ $(ip addr show ${IFACE} | grep ${VIP} | wc -l) != 0 ]; then
                sudo /sbin/ip addr del ${VIP}/${MASK} dev ${IFACE}
                DEBUG echo "sudo /sbin/ip addr del ${VIP}/${MASK} dev ${IFACE}" >> ${DEBUGFILE}
        fi
        exit 0
fi
exit 1

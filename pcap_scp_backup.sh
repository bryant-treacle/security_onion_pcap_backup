#!/bin/bash
# Purpose: This scipt will compress and scp pcaps from the dailylogs generated on the sensors and send them to a QNAP NAS storage 

# Set Variables 
DATE=$(date +%Y-%m-%d)
PCAP_FILES=$(ls /nsm/sensor_data/*/dailylogs/$DATE/)
SENSOR_NAME=$(hostname)

# Get the current list of pcap files
pcap_old()
{
ls /nsm/sensor_data/*/dailylogs/$DATE/ | sort -n -k1.11 > /home/soadmin/pcap_list_old.txt
}

#compress and scp pcaps
compress_scp()
{
while read i; do
    tar -zcvf /home/soadmin/$i-$SENSOR_NAME.tar.gz /nsm/sensor_data/*/dailylogs/$DATE/$i
    scp -i /home/soadmin/.ssh/id_rsa /home/soadmin/$i-$SENSOR_NAME.tar.gz so_admin@22.34.23.30:~
    rm /home/soadmin/$i-SENSOR_NAME.tar.gz
done < /home/soadmin/pcap_list_old.txt
}

pcap_new()
{
ls /nsm/sensor_data/*/dailylogs/$DATE/ | sort -n -k1.11 > /home/soadmin/pcap_list_new.txt
}



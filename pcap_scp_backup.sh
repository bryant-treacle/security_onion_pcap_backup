#!/bin/bash
# Purpose: This scipt will compress and scp pcaps from the dailylogs generated on the sensors and send them to a QNAP NAS storage 
#
# 




# Set Variables 
DATE=$(date +%Y-%m-%d)
PCAP_FILES=$(ls /nsm/sensor_data/*/dailylogs/$DATE/)
SENSOR_NAME=$(hostname)

# Get the current list of pcap files
pcap_old()
{
ls /nsm/sensor_data/*/dailylogs/$DATE/ | sort -n -k1.11 > ~/pcap_list_old.txt
}

#compress and scp pcaps
compress_scp()
{
while read i; do
    tar -zcvf ~/$i-$SENSOR_NAME.tar.gz /nsm/sensor_data/*/dailylogs/$DATE/$i
    scp -i /home/USERNAME/.ssh/id_rsa ~/$i-$SENSOR_NAME.tar.gz USERNAME@IP_ADDRESS:DESTINATION_FILE_PATH
    rm ~/$i-SENSOR_NAME.tar.gz
done < ~/pcap_list_old.txt
}

pcap_new()
{
DATE=$(date +%Y-%m-%d)
ls /nsm/sensor_data/*/dailylogs/$DATE/ | sort -n -k1.11 > ~/pcap_list_new.txt
}

pcap_diff()
{
comm -1 -3 ~/pcap_list_old.txt ~/pcap_list_new.txt > ~/pcap_list_diff.txt
rm -rf ~/pcap_list_old.txt && rm -rf ~/pcap_list_new.txt
mv ~/pcap_list_diff.txt ~/pcap_list_old.txt
}

####################
#    Script Start  #
####################
pcap_old
while true ; do 
    compress_scp
    sleep 600
    pcap_new
    pcap_diff
done



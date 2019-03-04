# Security Onion PCAP Backup
This script will compress and copy the current PCAP in the daily_logs folder and scp them to a remote server. The script requires ssh keys.

#### Step 1. Create a SSH key on sensor(s) you want to offload pcaps from. 
    "ssh-keygen"

#### Step 2. Use ssh-copy-id to send the public key to the Qnap
    "ssh-copy-id -i ~/.ssh/mykey user@host"
    
#### Step 3. Create a cron job to run script @reboot.
    vim /etc/crontab
    "@reboot root <filepath to script>"

#### Step 4. Edit the script and replace the following line with the appropriate information
  "scp -i /home/USERNAME/.ssh/id_rsa ~/$i-$SENSOR_NAME.tar.gz USERNAME@IP_ADDRESS:DESTINATION_FILE_PATH"

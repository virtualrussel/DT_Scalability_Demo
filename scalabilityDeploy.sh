#!/bin/bash

#*********************************

hosts=10
x=1
#*********************************

ec2_ID_array=()

while [ $x -le $hosts ]
do
#set correct user data in file
sed "3s/hostgroup/$x/" scalability_script.txt > scalability_script_tmp.txt

#launch ec2 instance & collect the instance ID (used to get public DNS)
instanceID=($(aws ec2 run-instances --image-id ami-09abb37c944a81153 --count 1 --instance-type t2.medium \
--key-name DTTrainingAttendee --subnet-id subnet-34d79f6c --security-group-ids sg-1b9d1060 \
--user-data file://scalability_script_tmp.txt | jq -r '.Instances | .[].InstanceId'))
ec2_ID_array+=($instanceID)
x=$(( $x + 1 ))

done

rm -rf scalability_script_tmp.txt
#create the terminate instances sh
ec2idaar=${ec2_ID_array[@]}
sed "2s/MYARRAY/$ec2idaar/" terminateInstances.txt > terminateScalabilityInstances.sh

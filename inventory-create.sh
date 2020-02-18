#!/bin/bash
rm inventory/*
terraform-inventory --inventory ./ >> inventory/yandex.ini
cd inventory
cp yandex.ini yandex.ini.bak
sed -i '1d' yandex.ini
sed -i '1d' yandex.ini
sed -i 's/all:vars/master/g' yandex.ini
sed -i 's/external_ip_address_/yandex_/g' yandex.ini
sed -i 's/\=/\ ansible_host\=/g' yandex.ini
sed -i '/vm_1/a \[worker\]' yandex.ini
 
echo "[docker_engine]" >> yandex.ini
echo "yandex_vm_1" >> yandex.ini
echo "yandex_vm_2" >> yandex.ini
echo "yandex_vm_3" >> yandex.ini
echo "" >> yandex.ini
echo "[docker_swarm_manager]" >> yandex.ini
echo "yandex_vm_1 swarm_labels=alpha" >> yandex.ini
echo "" >> yandex.ini
echo "[docker_swarm_worker]" >> yandex.ini
echo "yandex_vm_2 swarm_labels=bravo" >> yandex.ini
echo "yandex_vm_3 swarm_labels=charlie" >> yandex.ini

grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' yandex.ini | head -n 1
echo "please add this ip with following records to your hosts file"
echo "prometheus.local"
echo "grafana.local"
echo "kibana.local"
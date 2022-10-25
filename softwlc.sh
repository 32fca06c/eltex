#установка и настройка keepalived
apt install keepalived
systemctl enable keepalived
systemctl start keepalived
cp /home/eltex/check_ping.sh /etc/keepalived/
cp /home/eltex/keep_notify.sh /etc/keepalived/
cp /home/eltex/mongo_switch.js /etc/keepalived/
nano /etc/keepalived/check_ping.sh
nano /etc/keepalived/keep_notify.sh
nano /etc/keepalived/mongo_switch.js
chmod +x /etc/keepalived/check_ping.sh
chmod +x /etc/keepalived/keep_notify.sh
chmod +x /etc/keepalived/mongo_switch.js
echo ens32>/etc/keepalived/keepalived.conf
echo 10.250.186.5>>/etc/keepalived/keepalived.conf
echo 10.250.186.20>>/etc/keepalived/keepalived.conf
#настройка rsync
#настройка репликации MySQL
#настройка replicaSet MongoDB
#настройка работы Eltex-PCRF в режиме кластера
#изменение конфигурации модулей системы для работы с виртуальным IP

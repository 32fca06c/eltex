#!/bin/bash
 
MYSQL_USER="<mysql_user>"
MYSQL_PASSWORD="<mysql_password>"
 
mongo_set_role() {
    local role="$1"
    if [[ "$(which mongo)" ]]; then
        mongo --quiet --eval "var role=\"$role\"" admin /etc/keepalived/mongo_switch.js
        # Uncomment if using mongodb auth
        #mongo -u<username> -p<password> --quiet --eval "var role=\"$role\"" admin /etc/keepalived/mongo_switch.js
    fi
}
 
if ! lockfile-create --use-pid -r 5 /tmp/keep.mode.lock; then
    echo "Unable to lock"
    echo "Unable to lock" > /tmp/keep.mode.lock.fail
    exit 0
fi
 
case "$1" in
    master)
    #  ems_reload_all
    echo "MASTER" > /tmp/keep.mode
   
    mongo_set_role master
    service eltex-ems restart
    service tomcat8 restart
    service eltex-ngw restart
 
    # рестарт слейва MySQL чтобы при восстановлении связи - сразу получить изменения,
    # а не ждать периодического heartbeat от второго сервера
    mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "stop slave"
    mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "start slave"
  ;;
 backup)
    echo "BACKUP" > /tmp/keep.mode
    mongo_set_role slave
    service mongod restart
    service eltex-ems stop
    service tomcat8 stop
    service eltex-ngw stop
    mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "stop slave"
    mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "start slave"
 ;;
 fault)
    echo "FAULT" > /tmp/keep.mode
    mongo_set_role slave
    service mongod restart
 ;;
 *)
    echo "Usage: $0 {master|backup|fault}"
    exit 1
esac
 
lockfile-remove /tmp/keep.mode.lock;
 
exit 0
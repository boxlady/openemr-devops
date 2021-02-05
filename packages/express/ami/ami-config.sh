#!/bin/sh

MYSQLROOTPWD="${$1:root}"

f () {
    cd /root
    curl -s https://raw.githubusercontent.com/openemr/openemr-devops/master/packages/lightsail/launch.sh | bash -s -- -s 0    
    docker exec -it $(docker ps | grep mysql | cut -f 1 -d " ") mysql --password="$MYSQLROOTPWD" -e "update openemr.users set active=0 where id=1;"
    cp openemr-devops/packages/express/ami/ami-rekey.sh /etc/init.d/ami-rekey
    update-rc.d ami-rekey defaults
    rm /root/.ssh/authorized_keys
    rm /home/ubuntu/.ssh/authorized_keys
    #rm /home/ubuntu/.bash_history
    sync
    shutdown -h now
    exit 0
}

f
echo failure?
exit 1
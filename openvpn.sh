#!/bin/bash
touch /tmp/testfile.txt
sudo apt install openvpn -y
cd /root
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
export AUTO_INSTALL=y
./openvpn-install.sh
echo "installation finished at $(date)">>/tmp/testfile.txt



userlist=(new a asdasd)
for i in ${userlist[@]};do
    MENU_OPTION=1 CLIENT=$i PASS=1 ./openvpn-install.sh
    echo "user added: $i, $i.ovpn">>/tmp/testfile.txt
    mv $i.ovpn /tmp/$i.ovpn
done

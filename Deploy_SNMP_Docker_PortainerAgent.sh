#!/bin/bash
echo "Installing SNMPD"
apt install snmpd -y -q
sleep 2
echo "Backing up SNMPD Config File"
mv /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.backup
sleep 1
echo "Writing New SNMPD Config File"
cat <<EOF > /etc/snmp/snmpd.conf
	sysLocation    Lancaster, NY, USA
	sysContact     Chad Ferge <cferge@gmail.com>
	rocommunity  aurorapublic default
EOF
service snmpd restart
sleep 2
echo "Running APT Update"
sudo apt-get update
sleep 2
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
sleep 2

echo "Updating APT Keyrings"
sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
sudo apt-get update
sleep 2
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sleep 2
docker run -d \
  -p 9001:9001 \
  --name portainer_agent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:latest
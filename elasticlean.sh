#!/bin/bash
echo
echo "  _____  _              _    _  _____  _                     "
echo " |  ___|| |            | |  (_)/  __ \| |                    "
echo " | |__  | |  __ _  ___ | |_  _ | /  \/| |  ___   __ _  _ __  "
echo " |  __| | | / _\` |/ __|| __|| || |    | | / _ \ / _\` || \'_ \ "
echo " | |___ | || (_| |\__ \| |_ | || \__/\| ||  __/| (_| || | | |"
echo " \____/ |_| \__,_||___/ \__||_| \____/|_| \___| \__,_||_| |_|"
echo "       Elasticlean 1.0 - 2018-06-01 Jörgen Bertholdsson"
echo                                                             
echo "Complete removal of the complete Elastic installation including "
echo "all data"
echo "all cofiguration files"
echo "Nginx"
echo
echo -e "\e[31mNote: -NOTHING- of the Elastic stack will be left on the system.\e[0m"
echo -e "\e[31mElasticsearch, Kibana, Logstash and Nginx will be completly purged from you system,\e[0m"
echo -e "\e[31mincluding configuration files and any data.\e[0m"
echo 
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
tput sgr0 # Reset colors to "normal."
 read -r -p "Are you sure? [y/N]" response
 response=${response,,} # tolower
  if [[ $response =~ ^(yes|y) ]]; then
	read -r -p "Do you want to stop services? [y/N]" response
	response=${response,,} # tolower
	if [[ $response =~ ^(yes|y) ]]; then
		echo "Stopping services"
		systemctl stop elasticsearch &> /dev/null
		systemctl stop logstash &> /dev/null
		systemctl stop kibana &> /dev/null
		systemctl stop nginx &> /dev/null
	fi
	read -r -p "Do you want to remove services? [y/N]" response
	response=${response,,} # tolower
    if [[ $response =~ ^(yes|y) ]]; then
		echo "Removing services"
		systemctl disable elasticsearch &> /dev/null
		systemctl disable logstash &> /dev/null
		systemctl disable kibana &> /dev/null
		systemctl disable nginx &> /dev/null
	fi
	read -r -p "Do you want to uninstall packages? [y/N]" response
	response=${response,,} # tolower
    if [[ $response =~ ^(yes|y) ]]; then
		echo "Uninstalling packages"
		yum -y remove elasticsearch &> /dev/null
		yum -y remove logstash &> /dev/null
		yum -y remove kibana &> /dev/null
		yum -y remove nginx &> /dev/null
	fi
	read -r -p "Do you want to delete any leftovers files? [y/N]" response
	response=${response,,} # tolower
    if [[ $response =~ ^(yes|y) ]]; then
		echo "Cleaning up"
		rm -Rf /usr/share/nginx/ /usr/share/kibana/ /usr/share/logstash/ /usr/share/elasticsearch/ &> /dev/null
		rm -Rf /var/log/nginx/ /var/log/kibana/ /var/log/logstash/ /var/log/elasticsearch/ &> /dev/null
		rm -Rf /var/lib/nginx/ /var/lib/kibana/ /var/lib/logstash/ /lib/log/elasticsearch/ &> /dev/null
		rm -Rf /etc/default/logstash /var/cache/nginx/ /usr/lib64/nginx/ &> /dev/null
		rm -Rf /tmp/elasticsearch.* &> /dev/null
	fi
 fi
 echo
 echo "Done."

#!/bin/bash
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
if [ -f "$var_answerfile" ]; then source "$var_answerfile"; fi

################################
##      V A R I A B L E S     ##
################################
# MongoDB
DNS_A=`dig +short $FullName A`
DNS_AAAA=`dig +short $FullName AAAA`

################################
##   S C R I P T  L I S T S   ##
################################
# Lists for Omada Versions
versionlist=(\
  "1" "Install Version 5.9.9" \
  "2" "Install Version 5.8.4" \
  "3" "Install Version 5.7.4" \
  "4" "Install Version 5.6.3" \
  "5" "Install Version 5.5.6" \
  "6" "Install Version 5.4.6" \
  "7" "Install Version 5.3.1" \
  "8" "Install Version 5.1.7" \
  "9" "Install Version 5.0.30"\
)

################################
##       C H E C K U P S      ##
################################
# Check DNS-A and DNS-AAAA Record
if [ -z "$DNS_A" ] && [ -z "$DNS_AAAA" ]; then EchoLog error "Script only supports Domainnames (FQDN) with valid DNS-A and/or DNS-AAAA Record!" && exit 1; fi

# Check DNS-A for privat Network IP
DNS_A_First=`echo $DNS_A | cut -d. -f1`
DNS_A_Second=`echo $DNS_A | cut -d. -f2`
if [ $DNS_A_First -eq 10 ] || [ $DNS_A_First -eq 127 ]; then
  EchoLog error "Script only supports Domainnames (FQDN) with valid DNS-A and/or DNS-AAAA Record for public IPs!"
  exit 1
elif [ $DNS_A_First -eq 192 ] && [ $DNS_A_Second -eq 168 ]; then
  EchoLog error "Script only supports Domainnames (FQDN) with valid DNS-A and/or DNS-AAAA Record for public IPs!"
  exit 1
elif [ $DNS_A_First -eq 169 ] && [ $DNS_A_Second -eq 254 ]; then
  EchoLog error "Script only supports Domainnames (FQDN) with valid DNS-A and/or DNS-AAAA Record for public IPs!"
  exit 1
elif [ $DNS_A_First -eq 172 ] && [ $DNS_A_Second -ge 16 ] && [ $DNS_A_Second -le 31 ]; then
  EchoLog error "Script only supports Domainnames (FQDN) with valid DNS-A and/or DNS-AAAA Record for public IPs!"
  exit 1
fi

###############################
##       M O N G O D B       ##
###############################
# Bind MongoDB GPG Key
if [ ! -d "/etc/apt/keyrings" ]; then mkdir -p "/etc/apt/keyrings"; fi
if [ ! -f "/etc/apt/keyrings/mongodb.gpg" ]; then
  curl -fsSL https://pgp.mongodb.com/server-4.4.asc | gpg --dearmor -o /etc/apt/keyrings/mongodb.gpg
fi

# Bind MongoDB Repository
if [ ! -f "/etc/apt/sources.list.d/mongodb.list" ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/mongodb.gpg] http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb.list > /dev/null
fi

# Update Repository
apt-get update >/dev/null 2>&1

# Install MongoDB
for PACKAGE in openjdk-11-jre-headless mongodb-org jsvc curl certbot; do
  if CheckPackage "${PACKAGE}"; then
    EchoLog info "${PACKAGE} - ${lang_softwaredependencies_alreadyinstalled}"
  else
    if apt-get install -y $PACKAGE >/dev/null 2>&1; then
      EchoLog ok "${PACKAGE} - ${lang_softwaredependencies_installok}"
    else
      EchoLog error "${PACKAGE} - ${lang_softwaredependencies_installfail}"
    fi
  fi
done

mkdir /usr/lib/jvm/java-11-openjdk-amd64/lib/amd64
ln -s /usr/lib/jvm/java-11-openjdk-amd64/lib/server /usr/lib/jvm/java-11-openjdk-amd64/lib/amd64/

menuSelection=$(whiptail --menu --nocancel --backtitle "© 2023 - iThieler's Omada Software Controller Installer" --title " CONFIGURING OMADA SOFTWARE CONTROLLER " "\nWhich version do you want to install?" 20 80 10 "${versionlist[@]}" 3>&1 1>&2 2>&3)

if [[ $menuSelection == "1" ]]; then
  Omada_Version="5.9.9"
  Omada_Date="2023-02-27"
elif [[ $menuSelection == "2" ]]; then
  Omada_Version="5.8.4"
  Omada_Date="2023-01-06"
elif [[ $menuSelection == "3" ]]; then
  Omada_Version="5.7.4"
  Omada_Date="2022-11-21"
elif [[ $menuSelection == "4" ]]; then
  Omada_Version="5.6.3"
  Omada_Date="2022-10-24"
elif [[ $menuSelection == "5" ]]; then
  Omada_Version="5.5.6"
  Omada_Date="2022-08-22"
elif [[ $menuSelection == "6" ]]; then
  Omada_Version="5.4.6"
  Omada_Date="2022-07-29"
elif [[ $menuSelection == "7" ]]; then
  Omada_Version="5.3.1"
  Omada_Date="2022-05-07"
elif [[ $menuSelection == "8" ]]; then
  Omada_Version="5.1.7"
  Omada_Date="2022-03-22"
elif [[ $menuSelection == "9" ]]; then
  Omada_Version="5.0.30"
  Omada_Date="2022-01-20"
elif [[ $menuSelection == "Q" ]]; then
  exit 0
else
  exit 1
fi

###############################
##       C E R T B O T       ##
###############################
# Install certbot via snap
#if snap install core 2>&1 >/dev/null; then
#  snap refresh core &> /dev/null
#  EchoLog ok "install SNAP Core"
#else
#  EchoLog error "install SNAP Core"
#  exit 1
#fi

#if snap install certbot --classic 2>&1 >/dev/null; then
#  ln -s /snap/bin/certbot /usr/bin/certbot
#  EchoLog ok "install Certbot"
#else
#  EchoLog error "install Certbot"
#  exit 1
#fi

if certbot certonly --standalone --agree-tos -d ${FullName} -m ${MailServerTo} -n &> /dev/null; then
  EchoLog ok "create Let's Encrypt certificate"
else
  EchoLog error "create Let's Encrypt certificate"
  exit 1
fi

# Genearte Skript for renew cronjob
cat > /opt/renew_certificate.sh <<EOF
if ! tpeap status | grep -cw "not running" &>/dev/nul; then tpeap stop; fi
rm /opt/tplink/EAPController/data/keystore/*
cp /etc/letsencrypt/live/${FullName}/cert.pem /opt/tplink/EAPController/data/keystore/eap.cer
openssl pkcs12 -export -inkey /etc/letsencrypt/live/${FullName}/privkey.pem -in /etc/letsencrypt/live/${FullName}/cert.pem -certfile /etc/letsencrypt/live/${FullName}/chain.pem -name eap -out omada-certificate.p12 -password pass:tplink &>/dev/nul
keytool -importkeystore -srckeystore omada-certificate.p12 -srcstorepass tplink -srcstoretype pkcs12 -destkeystore /opt/tplink/EAPController/data/keystore/eap.keystore -deststorepass tplink -deststoretype pkcs12 &>/dev/nul
if tpeap status | grep -cw "not running" &>/dev/nul; then
  if tpeap start &>/dev/nul; then exit 0; else exit 1; fi
fi
EOF
chmod +x /opt/renew_certificate.sh
crontab -l &> /dev/null | { cat; echo "15 3 1 * * /opt/renew_certificate.sh"; } | crontab -

###############################
##     O M A D A   S D N     ##
###############################
# Download Omada Software Controller package and install
URL="https://static.tp-link.com/upload/software/$(echo $Omada_Date | cut -d- -f1)/$(echo $Omada_Date | cut -d- -f1,2 | tr -d '-')/$(echo $Omada_Date | cut -d- -f1,2,3 | tr -d '-')/Omada_SDN_Controller_v${Omada_Version}_Linux_x64.deb"
FILE="/root/$(basename "$URL")"
if [ -f "$FILE" ]; then rm -f "$FILE"; fi

if wget -q "$URL" -O "$FILE"; then
    EchoLog ok "download Omada Software Controller package"
  else
    EchoLog error "download Omada Software Controller package"
fi

if dpkg -i "$FILE" &> /dev/null; then
  EchoLog ok "install Omada Software Controller"
else
  EchoLog error "install Omada Software Controller"
  exit 1
fi

if /opt/renew_certificate.sh &> /dev/null; then
  EchoLog ok "WebGUI secured with SSL certificate"
else
  EchoLog error "WebGUI secured with SSL certificate"
fi

if ! tpeap status | grep -cw "not running" &>/dev/nul; then
  EchoLog wait "Omada SDN Controller is now installed!"
  EchoLog no "Please visit the following URL to manage your devices:"
  EchoLog no "https://${FullName}:8043"
  EchoLog wait "Have Fun :-)!"
else
  EchoLog error "Omada SDN Controller could not be installed :-(!"
fi

exit 0

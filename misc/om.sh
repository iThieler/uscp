#!/bin/bash
# Load functions/updates and strt this script
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
if [ -f "$var_answerfile" ]; then source "$var_answerfile"; fi
echo; OmadaLogo; echo

#if ! CheckDNS "${FullName}"; then exit 1; fi

################################
##      V A R I A B L E S     ##
################################
var_certbot_cronfile="/opt/renew_certificate.sh"

################################
##   S C R I P T  L I S T S   ##
################################
# Lists for Omada Versions
omadaversionlist=(\
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
## B A S I C  S E T T I N G S ##
################################
# Bind MongoDB GPG Key
if [ ! -d "/etc/apt/keyrings" ]; then mkdir -p "/etc/apt/keyrings"; fi
if [ ! -f "/etc/apt/keyrings/mongodb.gpg" ]; then
  curl -fsSL https://pgp.mongodb.com/server-4.4.asc | gpg --dearmor -o /etc/apt/keyrings/mongodb.gpg
fi

# Bind MongoDB Repository
if [ ! -f "/etc/apt/sources.list.d/mongodb.list" ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/mongodb.gpg] http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb.list > /dev/null
  apt-get update >/dev/null 2>&1
fi

# Install Software dependencies
for PACKAGE in openjdk-11-jre-headless jsvc curl certbot mongodb-org; do
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

if [ $(dpkg --print-architecture) == "amd64" ]; then
  mkdir /usr/lib/jvm/java-11-openjdk-amd64/lib/amd64
  ln -s /usr/lib/jvm/java-11-openjdk-amd64/lib/server /usr/lib/jvm/java-11-openjdk-amd64/lib/amd64/
elif [ $(dpkg --print-architecture) == "arm64" ]; then
  mkdir /usr/lib/jvm/java-11-openjdk-arm64/lib/arm64
  mkdir /usr/lib/jvm/java-11-openjdk-arm64/lib/aarch64
  ln -s /usr/lib/jvm/java-11-openjdk-arm64/lib/server /usr/lib/jvm/java-11-openjdk-arm64/lib/arm64/
  ln -s /usr/lib/jvm/java-11-openjdk-arm64/lib/server /usr/lib/jvm/java-11-openjdk-arm64/lib/aarch64/
fi

###############################
##       C E R T B O T       ##
###############################
# Generate Certificate
if certbot certonly --standalone --agree-tos -d ${FullName} -m ${MailServerTo} -n &> /dev/null; then
  EchoLog ok "${lang_omada_gencertok}"
else
  EchoLog error "${lang_omada_gencerterror}"
fi

# Genearte Skript for renew cronjob
cat > "$var_certbot_cronfile" <<EOF
if ! tpeap status | grep -cw "not running" &>/dev/nul; then tpeap stop; fi
rm /opt/tplink/EAPController/data/keystore/*
cp /etc/letsencrypt/live/${FullName}/cert.pem /opt/tplink/EAPController/data/keystore/eap.cer
openssl pkcs12 -export -inkey /etc/letsencrypt/live/${FullName}/privkey.pem -in /etc/letsencrypt/live/${FullName}/cert.pem -certfile /etc/letsencrypt/live/${FullName}/chain.pem -name eap -out omada-certificate.p12 -password pass:tplink &>/dev/nul
keytool -importkeystore -srckeystore omada-certificate.p12 -srcstorepass tplink -srcstoretype pkcs12 -destkeystore /opt/tplink/EAPController/data/keystore/eap.keystore -deststorepass tplink -deststoretype pkcs12 &>/dev/nul
if tpeap status | grep -cw "not running" &>/dev/nul; then
  if tpeap start &>/dev/nul; then exit 0; else exit 1; fi
fi
EOF

if [ -f "$var_certbot_cronfile" ]; then
 EchoLog ok "${lang_omada_croncertok}"
  chmod +x "$var_certbot_cronfile"
  crontab -l &> /dev/null | { cat; echo "15 3 1 * * $var_certbot_cronfile"; } | crontab -
else
  EchoLog error "${lang_omada_croncerterror}"
fi

###############################
##     O M A D A   S D N     ##
###############################
# Select Omada Version
menuSelection=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" --title " ${lang_omada_selectversion_title^^} " "\n${lang_omada_selectversion_message}" 20 80 10 "${omadaversionlist[@]}" 3>&1 1>&2 2>&3)

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

# Download Omada Software Controller package and install
URL="https://static.tp-link.com/upload/software/$(echo $Omada_Date | cut -d- -f1)/$(echo $Omada_Date | cut -d- -f1,2 | tr -d '-')/$(echo $Omada_Date | cut -d- -f1,2,3 | tr -d '-')/Omada_SDN_Controller_v${Omada_Version}_Linux_x64.deb"
FILE="/root/$(basename "$URL")"
if [ -f "$FILE" ]; then rm -f "$FILE"; fi

if wget -q "$URL" -O "$FILE"; then
  EchoLog ok "${lang_omada_downloadok}"
else
  EchoLog error "${lang_omada_downloaderror}"
  exit 1
fi

if dpkg -i "$FILE" &> /dev/null; then
  EchoLog ok "${lang_omada_instalok}"
else
  EchoLog error "${lang_omada_instalerror}"
  exit 1
fi

if /opt/renew_certificate.sh &> /dev/null; then
  EchoLog ok "${lang_omada_testrenewcertok}"
else
  EchoLog error "${lang_omada_testrenewcerterror}"
fi

if ! tpeap status | grep -cw "not running" &>/dev/nul; then
  EchoLog ok "${lang_omada_sdnstartok}:"
  EchoLog no "TCP 8088, TCP 8043, TCP 8843, UDP 29810, TCP 29814"
  EchoLog no "${lang_omada_webadress}: https://${FullName}:8043"
  exit 0
else
  EchoLog error "${lang_omada_sdnstarterror}"
  exit 1
fi

exit 0

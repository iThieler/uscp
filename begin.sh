#!/bin/bash
################################
##      V A R I A B L E S     ##
################################
# Requierements
export var_logfile="/root/log_USCP_Script.txt"
export var_githubraw="https://raw.githubusercontent.com/iThieler/uscp"
export var_whipbacktitle="© 2023 - iThieler's Ultimate Server Controllpanel (USCP)"

# Colors
export var_color_nc='\033[0m'
export var_color_red='\033[1;31m'
export var_color_blue='\033[1;34m'
export var_color_green='\033[1;32m'
export var_color_yellow='\033[1;33m'

# Script needed
ConfigRole=false

################################
##   S C R I P T  L I S T S   ##
################################
# Lists for Languages
langlist=(\
  "de" "      Deutsch" \
  "en" "      English" \
)

# Lists for Serverroles
rolelist=(\
  "dc" "      Docker Server with NGINX Proxy Manager" \
  "mc" "      Mailcow Mailserver" \
  "mp" "      MailPiler Mailarchiv" \
  "om" "      TP-Link Omada Software Controller" \
  "ww" "      Webserver based on NGINX with Let's Encrypt" \
  "no" "      Exit" \
)

################################
## B A S I C  S E T T I N G S ##
################################
# Set iThiele's CI - Whiptail Color Sheme
if [ ! -f "/root/.iThielers_NEWT_COLORS" ]; then curl -s "${var_githubraw}/main/reqs/newt_colors_file.txt" > "/root/.iThielers_NEWT_COLORS"; fi
if [ ! -f "/root/.iThielers_NEWT_COLORS_ALERT" ]; then curl -s "${var_githubraw}/main/reqs/newt_colors_alert_file.txt" > "/root/.iThielers_NEWT_COLORS_ALERT"; fi
export NEWT_COLORS_FILE="/root/.iThielers_NEWT_COLORS"

# Set Firstrun Variable
firstrun=true
if [ -f "${var_logfile}" ]; then firstrun=false; fi

# Set User/GUI Language by User input
export language=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" "\nSelect your Language" 20 80 10 "${langlist[@]}" 3>&1 1>&2 2>&3)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)

# Load functions/updates and strt this script
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
apt-get update 2>&1 >/dev/null
HeaderLogo "Ultimate Server Configuration Panel"

################################
## H O S T  V A R I A B L E S ##
################################
OS=$(. /etc/os-release; printf '%s\n' "$ID";)
OSVersion=$(. /etc/os-release; printf '%s\n' "$VERSION_ID";)
OSCodeName=$(. /etc/os-release; printf '%s\n' "$VERSION_CODENAME";)
PrivateIP4=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | grep -E '10.|172.|192.')
PublicIP4=$(curl -4 -s icanhazip.com)
PublicIP6=$(curl -6 -s icanhazip.com)
GivenHostName="$(hostname | cut -d. -f1)"
GivenDomainName=""
if [[ ! "$(hostname | cut -d. -f2-9)" == "${GivenHostName}" ]]; then GivenDomainName="$(hostname | cut -d. -f2-9)"; fi

################################
##       C H E C K U P S      ##
################################
# Check Proxmox
if command -v pveversion >/dev/null 2>&1; then
  if WhipYesNo "${lang_proxmox_button1}" "${lang_proxmox_button2}" "${lang_proxmox_title}" "${lang_proxmox_message}"; then
    EchoLog info "${lang_proxmox_message} - ${lang_proxmox_button1}"
    bash -c "$(curl -s https://raw.githubusercontent.com/iThieler/Proxmox/main/checkup.sh)" -s secondstart
  else
    EchoLog error "${lang_proxmox_message} - ${lang_proxmox_button2}"
  fi
fi

# Check Debian 11 Bullseye
if [ $OSVersion -ne 11 ]; then
  AlertWhipMessage "${lang_erroros_title}" "${lang_erroros_message}"
  exit 1
fi

# Check Internet connection
if ! ping -c1 -W5 google.com &> /dev/null; then
  EchoLog error "${lang_inetconnection_error}"
  exit 1
fi

###############################
## Q U E S T I O N N A I R E ##
###############################
# Hostname
HostName=$(WhipInputbox "${lang_hostname_title}" "${lang_hostname_message}" "${GivenHostName}")
DomainName=$(WhipInputbox "${lang_domainname_title}" "${lang_domainname_message}" "${GivenDomainName}")

# Mailserver for notifications
WhipMessage "${lang_mailserver_title}" "${lang_mailserver_messageboxtext}"
MailServerFQDN=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailserverfqdntext}" "mail.${DomainName}")
MailServerPort=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailserverporttext}" "587")
MailServerFrom=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailserverfromtext}" "notify@${DomainName}")
MailServerTo=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailservertotext}" "monitor@${DomainName}")
MailServerUser=""
MailServerPass=""
MailServerTLS=false
if WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_mailserver_title}" "${lang_mailserver_needloginyesnotext}"; then
  MailServerUser=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_needloginusertext}" "${MailServerFrom}")
  MailServerPass=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_needloginpasstext}" "")
  if WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_mailserver_title}" "${lang_mailserver_needloginsecuretext}"; then MailServerTLS=true; fi
fi

###############################
##       S T A R T U P       ##
###############################
# Set TimeZone
timedatectl set-timezone Europe/Berlin

# Set Hostname
hostnamectl set-hostname "$HostName.$DomainName"
sed -i "s/127.0.1.1 .*/127.0.1.1 $HostName $HostName.$DomainName/" /etc/hosts

# Install and configure Postfix as MTA
if CheckPackage "postfix"; then
    EchoLog info "postfix - ${lang_softwaredependencies_alreadyinstalled}"
else
  debconf-set-selections <<< "postfix postfix/mailname string $HostName.$DomainName"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  if apt-get install -y postfix 2>&1 >/dev/null; then
    EchoLog ok "postfix - ${lang_softwaredependencies_installok}"
  else
    EchoLog error "postfix - ${lang_softwaredependencies_installfail}"
  fi
fi

# Install Software dependencies 
for PACKAGE in fail2ban curl snapd git apticron parted smartmontools mailutils; do
  if CheckPackage "${PACKAGE}"; then
    EchoLog info "${PACKAGE} - ${lang_softwaredependencies_alreadyinstalled}"
  else
    if apt-get install -y $PACKAGE 2>&1 >/dev/null; then
      EchoLog ok "${PACKAGE} - ${lang_softwaredependencies_installok}"
    else
      EchoLog error "${PACKAGE} - ${lang_softwaredependencies_installfail}"
    fi
  fi
done

# Do a Full System update and upgrade if this is the Firstrun on this host
EchoLog wait "${lang_updateupgrade_startup} >>> (apt-get update && apt-get upgrade)"
if UpdateAndUpgrade; then
  EchoLog ok "${lang_updateupgrade_done}"
else
  EchoLog error "${lang_updateupgrade_fail}"
fi

###############################
##       P O S T F I X       ##
###############################
# Configure Postfix with made mail server settings
BackupAndRestoreFile backup "/etc/aliases"
BackupAndRestoreFile backup "/etc/postfix/main.cf"
BackupAndRestoreFile backup "/etc/postfix/canonical"
BackupAndRestoreFile backup "/etc/ssl/certs/ca-certificates.crt"
PostfixConfigured=false

# Change Pistfix configuration to send E-Mails
if grep "root:" /etc/aliases; then
  sed -i "s/^root:.*$/root: $MailServerTo/" /etc/aliases
else
  echo "root: $MailServerTo" >> /etc/aliases
fi
echo "root $MailServerFrom" >> /etc/postfix/canonical
chmod 600 /etc/postfix/canonical
echo [$MailServerFQDN]:$MailServerPort "$MailServerUser":"$MailServerPass" >> /etc/postfix/sasl_passwd
chmod 600 /etc/postfix/sasl_passwd
sed -i "/#/!s/\(relayhost[[:space:]]*=[[:space:]]*\)\(.*\)/\1"[$MailServerFQDN]:"$MailServerPort""/"  /etc/postfix/main.cf
if [ $MailServerTLS ]; then
  postconf smtp_use_tls=yes
else
  postconf smtp_use_tls=no
fi
if ! grep "smtp_sasl_password_maps" /etc/postfix/main.cf; then
  postconf smtp_sasl_password_maps=hash:/etc/postfix/sasl_passwd > /dev/null 2>&1
fi
if ! grep "smtp_tls_CAfile" /etc/postfix/main.cf; then
  postconf smtp_tls_CAfile=/etc/ssl/certs/ca-certificates.crt > /dev/null 2>&1
fi
if ! grep "smtp_sasl_security_options" /etc/postfix/main.cf; then
  postconf smtp_sasl_security_options=noanonymous > /dev/null 2>&1
fi
if ! grep "smtp_sasl_auth_enable" /etc/postfix/main.cf; then
  postconf smtp_sasl_auth_enable=yes > /dev/null 2>&1
fi 
if ! grep "sender_canonical_maps" /etc/postfix/main.cf; then
  postconf sender_canonical_maps=hash:/etc/postfix/canonical > /dev/null 2>&1
fi 
postmap /etc/postfix/sasl_passwd > /dev/null 2>&1
postmap /etc/postfix/canonical > /dev/null 2>&1
systemctl restart postfix  &> /dev/null && systemctl enable postfix  &> /dev/null
rm -rf "/etc/postfix/sasl_passwd"

# Test Postfix settings
echo -e "${lang_testpostfix_sendmessage}" | mail -a "From: \"${HostName}\" <${MailServerFrom}>" -s "[${lang_testpostfix_subjectarray^^}] ${lang_testpostfix_subjecttext}" "$MailServerTo"
if ! WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_testpostfix_whiptitle}" "${lang_testpostfix_whipyesnotext}\n\n${MailServerTo}"; then
  AlertWhipMessage "${lang_testpostfix_whiptitle}" "${lang_testpostfix_whipalertmessage}"
  if grep "SMTPUTF8 is required" "/var/log/mail.log"; then
    if ! grep "smtputf8_enable = no" /etc/postfix/main.cf; then
      postconf smtputf8_enable=no
      postfix reload
    fi
  fi
  echo -e "${lang_testpostfix_sendmessage}" | mail -a "From: \"${HostName}\" <${MailServerFrom}>" -s "[${lang_testpostfix_subjectarray^^}] ${lang_testpostfix_subjecttext}" "$MailServerTo"
  if ! WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_testpostfix_whiptitle}" "${lang_testpostfix_whipyesnotext}\n\n${MailServerTo}"; then
    AlertWhipMessage "${lang_testpostfix_whiptitle}" "${lang_testpostfix_whipalertmessage2}"
    BackupAndRestoreFile restore "/etc/aliases"
    BackupAndRestoreFile restore "/etc/postfix/canonical"
    BackupAndRestoreFile restore "/etc/postfix/main.cf"
    BackupAndRestoreFile restore "/etc/ssl/certs/ca-certificates.crt"
  fi
fi

###############################
##      A P T I C R O N      ##
###############################
# Configure Postfix with made mail server settings
cp /usr/lib/apticron/apticron.conf /etc/apticron/apticron.conf

sed -i "s/EMAIL=\".*/EMAIL=\"$MailServerTo\"/" /etc/apticron/apticron.conf
sed -i "s/# CUSTOM_SUBJECT=\".*/CUSTOM_SUBJECT=\"[${HostName^^}] ${lang_confapticron_customsubject}\"/" /etc/apticron/apticron.conf
sed -i "s/# CUSTOM_NO_UPDATES_SUBJECT=\".*/CUSTOM_NO_UPDATES_SUBJECT=\"[${HostName^^}] ${lang_confapticron_customnoupdatessubject}\"/" /etc/apticron/apticron.conf
sed -i "s/# CUSTOM_FROM=\".*/CUSTOM_FROM=\"$MailServerFrom\"/" /etc/apticron/apticron.conf

###############################
##   S E R V E R   R O L E   ##
###############################
WhipMessage "${lang_configurationcompleted_title}" "${lang_configurationcompleted_message}"
if WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_configurationcompleted_title}" "${lang_configurationcompleted_messageyesno}"; then ConfigRole=true; fi

# Select Server Role
if $ConfigRole; then
  ServerRole=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" "\n${lang_selectserverrole_message}" 20 80 10 "${rolelist[@]}" 3>&1 1>&2 2>&3)
  if [[ $ServerRole == "dc" ]]; then
    # Config Docker Server with NGINX Proxy Manager
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 0
  elif [[ $ServerRole == "mc" ]]; then
    # Mailcow Mailserver
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 0
  elif [[ $ServerRole == "mp" ]]; then
    # MailPiler Mailarchiv
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 0
  elif [[ $ServerRole == "om" ]]; then
    # TP-Link Omada Software Controller
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 0
  elif [[ $ServerRole == "ww" ]]; then
    # Webserver based on NGINX with Let's Encrypt
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 0
  elif [[ $ServerRole == "no" ]]; then
    # Exit
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 0
  else
    # Failure - Cleanup an Exit
    CleanupAll
    EchoLog info "${lang_goodbye}"
    exit 1
  fi
else
  # No Server role desired
  CleanupAll
  EchoLog info "${lang_goodbye}"
  EchoLog no "${lang_logfilepath} >> $var_logfile"
  exit 0
fi

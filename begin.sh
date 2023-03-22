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

# Set TimeZone
timedatectl set-timezone Europe/Berlin

# Set User/GUI Language by User input
export language=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" "\nSelect your Language" 20 80 10 "${langlist[@]}" 3>&1 1>&2 2>&3)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)

# Load functions
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)

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
HostName=$(WhipInputbox "${lang_hostname_title}" "${lang_hostname_message}" "${GivenHostName}")
DomainName=$(WhipInputbox "${lang_domainname_title}" "${lang_domainname_message}" "${GivenDomainName}")

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
if [ $OSVersion -eq 11 ]; then
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
# Mailserver for notifications
WhipMessage "${lang_mailserver_title}" "${lang_mailserver_messageboxtext}"
MailServerFQDN=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailserverfqdntext}" "mail.${DomainName}")
MailServerPort=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailserverporttext}" "587")
MailServerFrom=$(WhipInputbox "${lang_mailserver_title}" "${lang_mailserver_mailserverfromtext}" "notify@${DomainName}")
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
# Install and configure Postfix as MTA
if CheckPackage "postfix"; then
    EchoLog info "postfix - ${lang_softwaredependencies_alreadyinstalled}"
else
  debconf-set-selections <<< "postfix postfix/mailname string your.hostname.com"
  debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
  if apt install -y postfix 2>&1 >/dev/null; then
    EchoLog ok "postfix - ${lang_softwaredependencies_installok}"
  else
    EchoLog error "postfix - ${lang_softwaredependencies_installfail}"
  fi
fi

# Do a Full System update and upgrade if this is the Firstrun on this host
EchoLog wait "${lang_updateupgrade_startup} >>> (apt update && apt upgrade)"
if UpdateAndUpgrade; then
  EchoLog ok "${lang_updateupgrade_done}"
else
  EchoLog error "${lang_updateupgrade_fail}"
fi

# Install Software dependencies 
for PACKAGE in fail2ban curl snapd git apticron parted smartmontools mailutils; do
  if CheckPackage "${PACKAGE}"; then
    EchoLog info "${PACKAGE} - ${lang_softwaredependencies_alreadyinstalled}"
  else
    if apt install -y $PACKAGE 2>&1 >/dev/null; then
      EchoLog ok "${PACKAGE} - ${lang_softwaredependencies_installok}"
    else
      EchoLog error "${PACKAGE} - ${lang_softwaredependencies_installfail}"
    fi
  fi
done

WhipMessage "${lang_configurationcompleted_title}" "${lang_configurationcompleted_message}"
if WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_configurationcompleted_title}" "${lang_configurationcompleted_messageyesno}"; then ConfigRole=true; fi

###############################
##   S E R V E R   R O L E   ##
###############################
# Select Server Role
if $ConfigRole; then
  ServerRole=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" "\n${lang_selectserverrole_message}" 20 80 10 "${rolelist[@]}" 3>&1 1>&2 2>&3)
  if [[ $ServerRole == "dc" ]]; then
    # Config Docker Server with NGINX Proxy Manager
  elif [[ $ServerRole == "mc" ]]; then
    # Mailcow Mailserver
  elif [[ $ServerRole == "mp" ]]; then
    # MailPiler Mailarchiv
  elif [[ $ServerRole == "om" ]]; then
    # TP-Link Omada Software Controller
  elif [[ $ServerRole == "ww" ]]; then
    # Webserver based on NGINX with Let's Encrypt
  elif [[ $ServerRole == "no" ]]; then
    # Exit
    CleanupAll
    exit 0
  else
    # Failure - Cleanup an Exit
    CleanupAll
    exit 1
  fi
else
  # No Server role desired
  CleanupAll
  exit 0
fi

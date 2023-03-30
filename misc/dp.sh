#!/bin/bash

################################
##   S C R I P T  L I S T S   ##
################################
# Lists for choosing Proxy
proxylist=(\
  "npm" "      NGINX Proxy Manager" \
  "tra" "      traefik" \
)

containerlist=(\
  "por" "      Portainer" \
  "yac" "      Yacht" \
  "wud" "      Whats up Docker" \
  "ora" "      Orange HRM" \
  "vik" "      Vikunja" \
)

################################
## B A S I C  S E T T I N G S ##
################################
# Load functions/updates and strt this script
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
apt-get update >/dev/null 2>&1 && echo; DockerLogo; echo
if [ -f "$var_answerfile" ]; then source "$var_answerfile"; fi

# Install Software dependencies 
for PACKAGE in lsb-release gnupg; do
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

###############################
##        D O C K E R        ##
###############################
# Bind Docker GPG Key
if [ ! -d "/etc/apt/keyrings" ]; then mkdir -p "/etc/apt/keyrings"; fi
if [ ! -f "/etc/apt/keyrings/docker.gpg" ]; then
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

# Bind Docker Repository
if [ ! -f "/etc/apt/sources.list.d/docker.list" ]; then
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# Update Repository
apt-get update >/dev/null 2>&1

# Install Docker
for PACKAGE in apparmor docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; do
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

###############################
##  P R O X Y   F O R   D C  ##
###############################
if [ ! -d "/opt/npm/" ] || [ ! -d "/opt/traefik/" ]; then
  InstallProxy=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" --title " ${lang_selectproxyinstall_title^^} " "\n${lang_selectserverrole_message}" 20 80 10 "${proxylist[@]}" 3>&1 1>&2 2>&3)

  # Load needed Docker files
  if [[ "$InstallProxy" == "npm" ]]; then
    mkdir -p /opt/npm/ > /dev/null 2>&1
    wget -qO /opt/npm/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/proxy/npm.yml?raw=true
    cd /opt/npm/
    ports="TCP 80, TCP 81, TCP 443"
  elif [[ "$InstallProxy" == "tra" ]]; then
    mkdir -p /opt/traefik/ > /dev/null 2>&1
    wget -qO /opt/traefik/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/proxy/tra.yml?raw=true
    cd /opt/traefik/
    ports="TCP 80, TCP 8080"
  else
    EchoLog error ""
    exit 1
  fi

  # Start Docker container
  if docker compose up -d --wait > /dev/null 2>&1; then
    EchoLog ok "${lang_containerstarted}"
    EchoLog no "${ports}"
  else
    EchoLog ok "${lang_containernotstarted}"
    exit 1
  fi
fi

#######################################
##  D O C K E R   C O N T A I N E R  ##
#######################################
InstallContainer=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" --title " ${lang_selectcontainer_title^^} " "\n${lang_selectcontainer_message}" 20 80 10 "${containerlist[@]}" 3>&1 1>&2 2>&3)

if [[ "$InstallContainer" == "por" ]]; then
  mkdir -p /opt/protainer/ > /dev/null 2>&1
  wget -qO /opt/protainer/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/manager/portainer.yml?raw=true
  cd /opt/protainer/
  ports="Portainer: TCP 9000, TCP 9943"
  # Start Docker container
  if docker compose up -d --wait > /dev/null 2>&1; then
    EchoLog ok "${lang_containerstarted}"
    EchoLog no "${ports}"
  else
    EchoLog ok "${lang_containernotstarted}"
    exit 1
  fi
elif [[ "$InstallContainer" == "yac" ]]; then
  mkdir -p /opt/protainer/ > /dev/null 2>&1
  wget -qO /opt/yacht/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/manager/yacht.yml?raw=true
  cd /opt/yacht/
  ports="Yacht: TCP 8000"
  # Start Docker container
  if docker compose up -d --wait > /dev/null 2>&1; then
    EchoLog ok "${lang_containerstarted}"
    EchoLog no "${ports}"
  else
    EchoLog ok "${lang_containernotstarted}"
    exit 1
  fi
elif [[ "$InstallContainer" == "wud" ]]; then
  mkdir -p /opt/protainer/ > /dev/null 2>&1
  wget -qO /opt/wud/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/manager/whatsupdocker.yml?raw=true
  cd /opt/wud/
  ports="Whats up Docker: TCP 3000"
  # Start Docker container
  if docker compose up -d --wait > /dev/null 2>&1; then
    EchoLog ok "${lang_containerstarted}"
    EchoLog no "${ports}"
  else
    EchoLog ok "${lang_containernotstarted}"
    exit 1
  fi
elif [[ "$InstallContainer" == "ora" ]]; then
  mkdir -p /opt/orangehrm/ > /dev/null 2>&1
  wget -qO /opt/orangehrm/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/orangehrm.yml?raw=true
  cd /opt/orangehrm/
  ports="Orange HRM: TCP 3000"
  # Start Docker container
  if docker compose up -d --wait > /dev/null 2>&1; then
    EchoLog ok "${lang_containerstarted}"
    EchoLog no "${ports}"
  else
    EchoLog ok "${lang_containernotstarted}"
    exit 1
  fi
elif [[ "$InstallContainer" == "vik" ]]; then
  mkdir -p /opt/vikunja/ > /dev/null 2>&1
  wget -qO /opt/vikunja/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/vikunja.yml?raw=true
  cd /opt/vikunja/
  database="$(GenerateUserName 12)"
  database_user="$(GenerateUserName 12)"
  database_pass="$(GeneratePassword 27)"
  jwt_Secret="$(GeneratePassword 27)"
  sed -i "s/POSTGRES_DB: .*/POSTGRES_DB: $database/" /opt/vikunja/docker-compose.yml
  sed -i "s/POSTGRES_USER: .*/POSTGRES_USER: $database_user/" /opt/vikunja/docker-compose.yml
  sed -i "s/POSTGRES_PASSWORD: .*/POSTGRES_PASSWORD: $database_pass/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_MAILER_HOST: .*/VIKUNJA_MAILER_HOST: $MailServerFQDN/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_MAILER_PORT: .*/VIKUNJA_MAILER_PORT: $MailServerPort/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_MAILER_USERNAME: .*/VIKUNJA_MAILER_USERNAME: $MailServerUser/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_MAILER_PASSWORD: .*/VIKUNJA_MAILER_PASSWORD: $MailServerPass/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_MAILER_FROMEMAIL: .*/VIKUNJA_MAILER_FROMEMAIL: $MailServerFrom/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_DATABASE_PASSWORD: .*/VIKUNJA_DATABASE_PASSWORD: $database_pass/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_DATABASE_USER: .*/VIKUNJA_DATABASE_USER: $database_user/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_DATABASE_DATABASE: .*/VIKUNJA_DATABASE_DATABASE: $database/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_SERVICE_JWTSECRET: .*/VIKUNJA_SERVICE_JWTSECRET: $jwt_Secret/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_SERVICE_TIMEZONE: .*/VIKUNJA_SERVICE_TIMEZONE: $TimeZone/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_SERVICE_FRONTENDURL: .*/VIKUNJA_SERVICE_FRONTENDURL: $TimeZone/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_SERVICE_TIMEZONE: .*/VIKUNJA_SERVICE_TIMEZONE: $TimeZone/" /opt/vikunja/docker-compose.yml
  sed -i "s/VIKUNJA_SERVICE_TIMEZONE: .*/VIKUNJA_SERVICE_TIMEZONE: https://$FullName/" /opt/vikunja/docker-compose.yml
  ports="Vikunja: TCP 4441"
  # Start Docker container
  if docker compose up -d --wait > /dev/null 2>&1; then
    EchoLog ok "${lang_containerstarted}"
    EchoLog no "${ports}"
  else
    EchoLog ok "${lang_containernotstarted}"
    exit 1
  fi
else
  EchoLog error ""
  exit 1
fi

exit 0

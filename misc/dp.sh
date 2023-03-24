#!/bin/bash

################################
##   S C R I P T  L I S T S   ##
################################
# Lists for choosing Proxy
proxylist=(\
  "npm" "      NGINX Proxy Manager" \
  "tra" "      traefik" \
)
################################
## B A S I C  S E T T I N G S ##
################################
# Load functions/updates and strt this script
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
apt-get update >/dev/null 2>&1 && echo; echo
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
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Bind Docker Repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

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
InstallProxy=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" --title " ${lang_selectproxyinstall_title^^} " "\n${lang_selectserverrole_message}" 20 80 10 "${proxylist[@]}" 3>&1 1>&2 2>&3)

if [[ "$InstallProxy" == "npm" ]]; then
  if [ ! -d "/opt/npm" ]; then mkdir -p /opt/npm/ > /dev/null 2>&1; fi
cat > /opt/npm/docker-compose.yml <<EOF
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: "NGINX Proxy Manager"
    restart: always
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOF

    cd /opt/npm/ && docker compose up -d --quiet-pull > /dev/null 2>&1
elif [[ "$InstallProxy" == "tra" ]]; then
  if [ ! -d "/opt/traefik" ]; then mkdir -p /opt/traefik/ > /dev/null 2>&1; fi
cat > /opt/traefik/docker-compose.yml <<EOF
version: '3.3'
services:
  traefik:
    image: "traefik:v2.10"
    container_name: "traefik"
    restart: always
    command:
      #- "--log.level=DEBUG"
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock:ro"
  whoami:
    image: "traefik/whoami"
    container_name: "simple-service"
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
      - "traefik.http.routers.whoami.entrypoints=web"
EOF

    cd /opt/traefik/ && docker compose up -d --quiet-pull > /dev/null 2>&1
fi

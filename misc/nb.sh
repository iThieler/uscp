#!/bin/bash

################################
##      V A R I A B L E S     ##
################################
var_netbox_override="/opt/netbox-docker/docker-compose.override.yml"

################################
## B A S I C  S E T T I N G S ##
################################
# Load functions/updates and strt this script
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
apt-get update >/dev/null 2>&1 && echo; MailcowLogo; echo
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
##        N E T B O X        ##
###############################
cd /opt/
if git clone https://github.com/netbox-community/netbox-docker.git >/dev/null 2>&1; then
  EchoLog ok "${lang_netbox_gitclone_ok}"
else
  EchoLog error "${lang_netbox_gitclone_error}"
  exit 1
fi

# Netbox override file
cat > "$var_netbox_override" <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - "8000:8080"
    # If you want the Nginx unit status page visible from the
    # outside of the container add the following port mapping:
    # - "8001:8081"
    # healthcheck:
      # Time for which the health check can fail after the container is started.
      # This depends mostly on the performance of your database. On the first start,
      # when all tables need to be created the start_period should be higher than on
      # subsequent starts. For the first start after major version upgrades of NetBox
      # the start_period might also need to be set higher.
      # Default value in our docker-compose.yml is 60s
      # start_period: 90s
    environment:
      SKIP_SUPERUSER: "false"
      SUPERUSER_API_TOKEN: "$(GenerateAPIKey 32)"
      SUPERUSER_EMAIL: "${MailServerTo}"
      SUPERUSER_NAME: "$(GenerateUserName 8)"
      SUPERUSER_PASSWORD: "$(GeneratePassword 22)"
EOF

# Load and start Netbox Container
cd "/opt/netbox-docker/"
EchoLog wait "${lang_netbox_loadcontainerwait}"
if docker compose pull; then
  EchoLog ok "${lang_netbox_loadcontainerok}"
else
  EchoLog error "${lang_netbox_loadcontainererror}"
  exit 1
fi

if docker compose up -d; then
  EchoLog ok "${lang_netbox_startcontainerok}"
else
  EchoLog error "${lang_netbox_startcontainererror}"
fi

cd "/root/"

EchoLog info "${lang_netbox_infotext}:"
EchoLog no "docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser"

exit 0

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
  "ral" "      Rally" \
  "vik" "      Vikunja" \
  "lim" "      LimeSurvey" \
  "bas" "      Baserow" \
  "sni" "      Snippet Box" \
  "sit" "      Snipe-IT" \
  "jop" "      Joplin" \
  "Q" "      Beenden" \
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
ports=""
if [ ! -d "/opt/npm/" ] && [ ! -d "/opt/traefik/" ]; then
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
  if docker compose up -d; then
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
function containerinstall() {
  InstallContainer=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" --title " ${lang_selectcontainer_title^^} " "\n${lang_selectcontainer_message}" 20 80 10 "${containerlist[@]}" 3>&1 1>&2 2>&3)

  if [[ "$InstallContainer" == "por" ]]; then
    mkdir -p /opt/portainer/ > /dev/null 2>&1
    wget -qO /opt/portainer/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/manager/portainer.yml?raw=true
    cd /opt/portainer/
    ports="Portainer: TCP 9000, TCP 9943"
    # Start Docker container
    if docker compose up -d --quiet-pull --wait; then
      EchoLog OK "Portainer - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "yac" ]]; then
    mkdir -p /opt/yacht/ > /dev/null 2>&1
    wget -qO /opt/yacht/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/manager/yacht.yml?raw=true
    cd /opt/yacht/
    ports="Yacht: TCP 8000"
    # Start Docker container
    if docker compose up -d --quiet-pull --wait; then
      EchoLog OK "Yacht - ${lang_containerstarted}"
      EchoLog no "${ports}"
      EchoLog no "${lang_global_username}: admin@yacht.local >>> ${lang_global_password}: pass"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "wud" ]]; then
    mkdir -p /opt/wud/ > /dev/null 2>&1
    wget -qO /opt/wud/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/manager/whatsupdocker.yml?raw=true
    cd /opt/wud/
    ports="Whats up Docker: TCP 3000"
    # Start Docker container
    if docker compose up -d --quiet-pull --wait; then
      EchoLog OK "What's up Docker - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "ora" ]]; then
    mkdir -p /opt/orangehrm/ > /dev/null 2>&1
    wget -qO /opt/orangehrm/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/orangehrm.yml?raw=true
    cd /opt/orangehrm/
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    database_rootpass="$(GeneratePassword 27)"
    jwt_Secret="$(GeneratePassword 27)"
    sed -i "s/TZ:.*/TZ: $TimeZone/" /opt/orangehrm/docker-compose.yml
    sed -i "s/MYSQL_ROOT_PASSWORD:.*/MYSQL_ROOT_PASSWORD: $database_rootpass/" /opt/orangehrm/docker-compose.yml
    sed -i "s/MYSQL_DATABASE:.*/MYSQL_DATABASE: $database/" /opt/orangehrm/docker-compose.yml
    sed -i "s/MYSQL_USER:.*/MYSQL_USER: $database_user/" /opt/orangehrm/docker-compose.yml
    sed -i "s/MYSQL_PASSWORD:.*/MYSQL_PASSWORD: $database_pass/" /opt/orangehrm/docker-compose.yml
    sed -i "s/ORANGEHRM_DATABASE_NAME:.*/ORANGEHRM_DATABASE_NAME: $database/" /opt/orangehrm/docker-compose.yml
    sed -i "s/ORANGEHRM_DATABASE_USER:.*/ORANGEHRM_DATABASE_USER: $database_user/" /opt/orangehrm/docker-compose.yml
    sed -i "s/ORANGEHRM_DATABASE_PASSWORD:.*/ORANGEHRM_DATABASE_PASSWORD: $database_pass/" /opt/orangehrm/docker-compose.yml
    ports="Orange HRM: TCP 8797"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "Orange HRM - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "vik" ]]; then
    if ! CheckDNS "${FullName}"; then return 1; fi
    mkdir -p /opt/vikunja/ > /dev/null 2>&1
    wget -qO /opt/vikunja/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/vikunja.yml?raw=true
    cd /opt/vikunja/
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    jwt_Secret="$(GeneratePassword 27)"
    sed -i "s/POSTGRES_DB:.*/POSTGRES_DB: $database/" /opt/vikunja/docker-compose.yml
    sed -i "s/POSTGRES_USER:.*/POSTGRES_USER: $database_user/" /opt/vikunja/docker-compose.yml
    sed -i "s/POSTGRES_PASSWORD:.*/POSTGRES_PASSWORD: $database_pass/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_MAILER_HOST:.*/VIKUNJA_MAILER_HOST: $MailServerFQDN/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_MAILER_PORT:.*/VIKUNJA_MAILER_PORT: $MailServerPort/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_MAILER_USERNAME:.*/VIKUNJA_MAILER_USERNAME: $MailServerUser/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_MAILER_PASSWORD:.*/VIKUNJA_MAILER_PASSWORD: $MailServerPass/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_MAILER_FROMEMAIL:.*/VIKUNJA_MAILER_FROMEMAIL: $MailServerFrom/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_DATABASE_PASSWORD:.*/VIKUNJA_DATABASE_PASSWORD: $database_pass/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_DATABASE_USER:.*/VIKUNJA_DATABASE_USER: $database_user/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_DATABASE_DATABASE:.*/VIKUNJA_DATABASE_DATABASE: $database/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_SERVICE_JWTSECRET:.*/VIKUNJA_SERVICE_JWTSECRET: $jwt_Secret/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_SERVICE_TIMEZONE:.*/VIKUNJA_SERVICE_TIMEZONE: $TimeZone/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_SERVICE_FRONTENDURL:.*/VIKUNJA_SERVICE_FRONTENDURL: https://$FullName/" /opt/vikunja/docker-compose.yml
    sed -i "s/VIKUNJA_API_URL:.*/VIKUNJA_API_URL: https://$FullName/api/v1" /opt/vikunja/docker-compose.yml
    ports="Vikunja: TCP 4441, TCP 3456"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "Vikunja - ${lang_containerstarted}"
      EchoLog no "${ports}"
      EchoLog no "${lang_global_registeruser}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "ral" ]]; then
    if ! CheckDNS "${FullName}"; then return 1; fi
    mkdir -p /opt/rally/ > /dev/null 2>&1
    wget -qO /opt/rally/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/rally.yml?raw=true
    cd /opt/rally/
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    very_secret="$(GeneratePassword 27)"
    sed -i "s/POSTGRES_DB:.*/POSTGRES_DB: $database/" /opt/rally/docker-compose.yml
    sed -i "s/POSTGRES_USER:.*/POSTGRES_USER: $database_user/" /opt/rally/docker-compose.yml
    sed -i "s/POSTGRES_PASSWORD:.*/POSTGRES_PASSWORD: $database_pass/" /opt/rally/docker-compose.yml
    sed -i "s/DATABASE_URL:.*/DATABASE_URL: postgres://$database_user:$database_pass@$database:5432/rallly/" /opt/rally/docker-compose.yml
    sed -i "s/SECRET_PASSWORD:.*/SECRET_PASSWORD: $very_secret/" /opt/rally/docker-compose.yml
    sed -i "s/NEXT_PUBLIC_BASE_URL:.*/NEXT_PUBLIC_BASE_URL: https://$FullName/" /opt/rally/docker-compose.yml
    sed -i "s/SUPPORT_EMAIL:.*/SUPPORT_EMAIL: $MailServerFrom/" /opt/rally/docker-compose.yml
    sed -i "s/SMTP_HOST:.*/SMTP_HOST: $MailServerFQDN/" /opt/rally/docker-compose.yml
    sed -i "s/SMTP_PORT:.*/SMTP_PORT: $MailServerPort/" /opt/rally/docker-compose.yml
    sed -i "s/SMTP_USER:.*/SMTP_USER: $MailServerUser/" /opt/rally/docker-compose.yml
    sed -i "s/SMTP_PWD:.*/SMTP_PWD: $MailServerPass/" /opt/rally/docker-compose.yml
    ports="Rally: TCP 9861"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "Rally - ${lang_containerstarted}"
      EchoLog no "${ports}"
      EchoLog no "${lang_global_registeruser}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "lim" ]]; then
    if ! CheckDNS "${FullName}"; then return 1; fi
    mkdir -p /opt/limesurvey/ > /dev/null 2>&1
    wget -qO /opt/limesurvey/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/limesurvey.yml?raw=true
    cd /opt/limesurvey/
    adminuser=$(WhipInputbox "LimeSurey" "${lang_global_adminuser}" "admin")
    adminpass="$(GeneratePassword 12)"
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    very_secret="$(GeneratePassword 27)"
    sed -i "s/LIMESURVEY_ADMIN_USER:.*/LIMESURVEY_ADMIN_USER: $adminuser/" /opt/limesurvey/docker-compose.yml
    sed -i "s/LIMESURVEY_ADMIN_PASSWORD:.*/LIMESURVEY_ADMIN_PASSWORD: $adminpass/" /opt/limesurvey/docker-compose.yml
    sed -i "s/LIMESURVEY_ADMIN_NAME:.*/LIMESURVEY_ADMIN_NAME: Administrator/" /opt/limesurvey/docker-compose.yml
    sed -i "s/LIMESURVEY_ADMIN_EMAIL:.*/LIMESURVEY_ADMIN_EMAIL: $MailServerTo/" /opt/limesurvey/docker-compose.yml
    sed -i "s/LIMESURVEY_DB_NAME:.*/LIMESURVEY_DB_NAME: $database/" /opt/limesurvey/docker-compose.yml
    sed -i "s/LIMESURVEY_DB_USER:.*/LIMESURVEY_DB_USER: $database_user/" /opt/limesurvey/docker-compose.yml
    sed -i "s/LIMESURVEY_DB_PASSWORD:.*/LIMESURVEY_DB_PASSWORD: $database_pass/" /opt/limesurvey/docker-compose.yml
    sed -i "s/TZ:.*/TZ: $TimeZone/g" /opt/limesurvey/docker-compose.yml
    sed -i "s/BASE_URL:.*/BASE_URL: https://$FullName/" /opt/limesurvey/docker-compose.yml
    sed -i "s/PUBLIC_URL:.*/PUBLIC_URL: https://$FullName/" /opt/limesurvey/docker-compose.yml
    sed -i "s/MYSQL_DATABASE:.*/MYSQL_DATABASE: $database/" /opt/limesurvey/docker-compose.yml
    sed -i "s/MYSQL_USER:.*/MYSQL_USER: $database_user/" /opt/limesurvey/docker-compose.yml
    sed -i "s/MYSQL_PASSWORD:.*/MYSQL_PASSWORD: $database_pass/" /opt/limesurvey/docker-compose.yml
    sed -i "s/MYSQL_ROOT_PASSWORD:.*/MYSQL_ROOT_PASSWORD: $very_secret/" /opt/limesurvey/docker-compose.yml
    ports="LimeSurvey: TCP 8785"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "LimeSurvey - ${lang_containerstarted}"
      EchoLog no "${ports}"
      EchoLog no "${lang_global_username}: $adminuser >>> ${lang_global_password}: $adminpass"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "bas" ]]; then
    if ! CheckDNS "${FullName}"; then return 1; fi
    mkdir -p /opt/baserow/ > /dev/null 2>&1
    wget -qO /opt/baserow/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/limesurvey.yml?raw=true
    cd /opt/baserow/
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    very_secret="$(GeneratePassword 27)"
    sed -i "s/TZ:.*/TZ: $TimeZone/g" /opt/baserow/docker-compose.yml
    sed -i "s/POSTGRES_DB:.*/POSTGRES_DB: $database/" /opt/baserow/docker-compose.yml
    sed -i "s/POSTGRES_USER:.*/POSTGRES_USER: $database_user/" /opt/baserow/docker-compose.yml
    sed -i "s/POSTGRES_PASSWORD:.*/POSTGRES_PASSWORD: $database_pass/" /opt/baserow/docker-compose.yml
    sed -i "s/BASEROW_PUBLIC_URL:.*/BASEROW_PUBLIC_URL: https://$FullName/" /opt/baserow/docker-compose.yml
    sed -i "s/DATABASE_USER:.*/DATABASE_USER: $database_user/" /opt/baserow/docker-compose.yml
    sed -i "s/DATABASE_PASSWORD:.*/DATABASE_PASSWORD: $database_pass/" /opt/baserow/docker-compose.yml
    sed -i "s/DATABASE_NAME:.*/DATABASE_NAME: $database/" /opt/baserow/docker-compose.yml
    sed -i "s/EMAIL_SMTP_HOST:.*/EMAIL_SMTP_HOST: $MailServerFQDN/" /opt/baserow/docker-compose.yml
    sed -i "s/EMAIL_SMTP_PORT:.*/EMAIL_SMTP_PORT: $MailServerPort/" /opt/baserow/docker-compose.yml
    sed -i "s/EMAIL_SMTP_USER:.*/EMAIL_SMTP_USER: $MailServerUser/" /opt/baserow/docker-compose.yml
    sed -i "s/EMAIL_SMTP_PASSWORD:.*/EMAIL_SMTP_PASSWORD: $MailServerPass/" /opt/baserow/docker-compose.yml
    sed -i "s/FROM_EMAIL:.*/FROM_EMAIL: $MailServerFrom/" /opt/baserow/docker-compose.yml
    ports="Baserow: TCP 3888"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "Baserow - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "sni" ]]; then
    mkdir -p /opt/snippetbox/ > /dev/null 2>&1
    wget -qO /opt/snippetbox/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/snippetbox.yml?raw=true
    cd /opt/snippetbox/
    ports="SnippetBox: TCP 5212"
    # Start Docker container
    if docker compose up -d --quiet-pull --wait; then
      EchoLog OK "SnippetBox - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "sit" ]]; then
    if ! CheckDNS "${FullName}"; then return 1; fi
    mkdir -p /opt/snipeit/ > /dev/null 2>&1
    wget -qO /opt/snipeit/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/snipeit.yml?raw=true
    cd /opt/snipeit/
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    very_secret="$(GeneratePassword 27)"
    sed -i "s/MYSQL_ROOT_PASSWORD:.*/MYSQL_ROOT_PASSWORD: $very_secret/" /opt/snipeit/docker-compose.yml
    sed -i "s/MYSQL_DATABASE:.*/MYSQL_DATABASE: $database/" /opt/snipeit/docker-compose.yml
    sed -i "s/MYSQL_USER:.*/MYSQL_USER: $database_user/" /opt/snipeit/docker-compose.yml
    sed -i "s/MYSQL_PASSWORD:.*/MYSQL_PASSWORD: $database_pass/" /opt/snipeit/docker-compose.yml
    sed -i "s/TZ:.*/TZ: $TimeZone/g" /opt/snipeit/docker-compose.yml
    sed -i "s/APP_TIMEZONE:.*/APP_TIMEZONE: $TimeZone/" /opt/snipeit/docker-compose.yml
    sed -i "s/APP_URL:.*/APP_URL: https://$FullName/" /opt/snipeit/docker-compose.yml
    sed -i "s/NGINX_APP_URL:.*/NGINX_APP_URL: https://$FullName/" /opt/snipeit/docker-compose.yml
    sed -i "s/MYSQL_DATABASE:.*/MYSQL_DATABASE: $database/" /opt/snipeit/docker-compose.yml
    sed -i "s/MYSQL_USER:.*/MYSQL_USER: $database_user/" /opt/snipeit/docker-compose.yml
    sed -i "s/MYSQL_PASSWORD:.*/MYSQL_PASSWORD: $database_pass/" /opt/snipeit/docker-compose.yml
    sed -i "s/MAIL_PORT_587_TCP_ADDR:.*/MAIL_PORT_587_TCP_ADDR: $MailServerFQDN/" /opt/snipeit/docker-compose.yml
    sed -i "s/MAIL_PORT_587_TCP_PORT:.*/MAIL_PORT_587_TCP_PORT: $MailServerPort/" /opt/snipeit/docker-compose.yml
    sed -i "s/MAIL_ENV_FROM_ADDR:.*/MAIL_ENV_FROM_ADDR: $MailServerFrom/" /opt/snipeit/docker-compose.yml
    sed -i "s/MAIL_ENV_FROM_NAME:.*/MAIL_ENV_FROM_NAME: Snipe-IT@$HostName/" /opt/snipeit/docker-compose.yml
    sed -i "s/MAIL_ENV_USERNAME:.*/MAIL_ENV_USERNAME: $MailServerUser/" /opt/snipeit/docker-compose.yml
    sed -i "s/MAIL_ENV_PASSWORD:.*/MAIL_ENV_PASSWORD: $MailServerPass/" /opt/snipeit/docker-compose.yml
    ports="Snipe-IT: TCP 1339"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "Snipe-IT - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "jop" ]]; then
    if ! CheckDNS "${FullName}"; then return 1; fi
    mkdir -p /opt/joplin/ > /dev/null 2>&1
    wget -qO /opt/joplin/docker-compose.yml https://github.com/iThieler/uscp/blob/main/conf/dp/productivity/joplin.yml?raw=true
    cd /opt/joplin/
    database="$(GenerateUserName 12)"
    database_user="$(GenerateUserName 12)"
    database_pass="$(GeneratePassword 27)"
    very_secret="$(GeneratePassword 27)"
    sed -i "s/TZ:.*/TZ: $TimeZone/g" /opt/joplin/docker-compose.yml
    sed -i "s/POSTGRES_DB:.*/POSTGRES_DB: $database/" /opt/joplin/docker-compose.yml
    sed -i "s/POSTGRES_USER:.*/POSTGRES_USER: $database_user/" /opt/joplin/docker-compose.yml
    sed -i "s/POSTGRES_PASSWORD:.*/POSTGRES_PASSWORD: $database_pass/" /opt/joplin/docker-compose.yml
    sed -i "s/APP_BASE_URL:.*/APP_BASE_URL: https://$FullName/" /opt/joplin/docker-compose.yml
    sed -i "s/POSTGRES_DATABASE:.*/POSTGRES_DATABASE: $database/" /opt/joplin/docker-compose.yml
    sed -i "s/POSTGRES_USER:.*/POSTGRES_USER: $database_user/" /opt/joplin/docker-compose.yml
    sed -i "s/POSTGRES_PASSWORD:.*/POSTGRES_PASSWORD: $database_pass/" /opt/joplin/docker-compose.yml
    sed -i "s/MAILER_HOST:.*/MAILER_HOST: $MailServerFQDN/" /opt/joplin/docker-compose.yml
    sed -i "s/MAILER_PORT:.*/MAILER_PORT: $MailServerPort/" /opt/joplin/docker-compose.yml
    sed -i "s/MAILER_AUTH_USER:.*/MAILER_AUTH_USER: $MailServerUser/" /opt/joplin/docker-compose.yml
    sed -i "s/MAILER_AUTH_PASSWORD:.*/MAILER_AUTH_PASSWORD: $MailServerPass/" /opt/joplin/docker-compose.yml
    sed -i "s/MAILER_NOREPLY_NAME:.*/MAILER_NOREPLY_NAME: $MailServerFrom/" /opt/joplin/docker-compose.yml
    sed -i "s/MAILER_NOREPLY_EMAIL:.*/MAILER_NOREPLY_EMAIL: $MailServerFrom/" /opt/joplin/docker-compose.yml
    ports="Joplin: TCP 22300"
    # Start Docker container
    if docker compose up -d; then
      EchoLog OK "Joplin - ${lang_containerstarted}"
      EchoLog no "${ports}"
      containerinstall
    else
      EchoLog error "${lang_containernotstarted}"
      exit 1
    fi
  elif [[ "$InstallContainer" == "Q" ]]; then
    exit 0
  else
    EchoLog error "Fehlerhafte eingabe"
    exit 1
  fi
}

containerinstall

exit 0

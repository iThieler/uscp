#!/bin/bash
################################
##      V A R I A B L E S     ##
################################
# Mailcow
var_mailcow_conf="/opt/mailcow-dockerized/mailcow.conf"
var_mailcow_postfix_extra="/opt/mailcow-dockerized/data/conf/postfix/extra.cf"
var_mailcow_index_php="/opt/mailcow-dockerized/data/web/index.php"
var_mailcow_sogo_logo="/opt/mailcow-dockerized/data/conf/sogo/sogo-full.svg"
var_mailcow_mtasts="/opt/mailcow-dockerized/data/web/.well-known/mta-sts.txt"

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

###################################
## S O F T W A R E   D E L E T E ##
###################################
# Postfix
if CheckPackage "postfix"; then
  EchoLog wait "${lang_mailcow_postfix_deletewait}"
  if service postfix stop; then
    EchoLog ok "${lang_mailcow_postfix_stopok}"
    BackupAndRestoreFile recover "/etc/aliases"
    BackupAndRestoreFile recover "/etc/postfix/main.cf"
    BackupAndRestoreFile recover "/etc/ssl/certs/ca-certificates.crt"
    if [ -f "/etc/postfix/canonical" ]; then rm -f "/etc/postfix/canonical"; fi
    if apt-get -y autoremove postfix >/dev/null 2>&1; then
      EchoLog ok "${lang_mailcow_postfix_deleteok}"
    else
      EchoLog error "${lang_mailcow_postfix_deleteerror}"
      exit 1
    fi
  else
    EchoLog error "${lang_mailcow_postfix_stoperror}"
    exit 1
  fi
fi

###############################
##       M A I L C O W       ##
###############################
if [[ ! $(umask) == "0022" ]]; then
  EchoLog error "${lang_mailcow_umask_error}"
  exit 1
fi

cd /opt/
if git clone https://github.com/mailcow/mailcow-dockerized >/dev/null 2>&1; then
  EchoLog ok "${lang_mailcow_gitclone_ok}"
else
  EchoLog error "${lang_mailcow_gitclone_error}"
  exit 1
fi

# Mailcow configuration
if wget -qO $var_mailcow_conf https://github.com/iThieler/uscp/blob/main/conf/mc/mailcow.conf.txt?raw=true; then
  EchoLog ok "${lang_mailcow_getconf_ok}"
  DBName=$(GenerateUserName 12)
  DBUser=$(GenerateUserName 12)
  DBPass=$(GenerateUserName 32)
  DBRoot=$(GenerateUserName 32)
  sed -i "s/MAILCOW_HOSTNAME=.*/MAILCOW_HOSTNAME=$FullName/" $var_mailcow_conf
  sed -i "s/DBNAME=.*/DBNAME=$DBName/" $var_mailcow_conf
  sed -i "s/DBUSER=.*/DBUSER=$DBUser/" $var_mailcow_conf
  sed -i "s/DBPASS=.*/DBPASS=$DBPass/" $var_mailcow_conf
  sed -i "s/DBROOT=.*/DBROOT=$DBRoot/" $var_mailcow_conf
  sed -i "s/ADDITIONAL_SAN=.*/ADDITIONAL_SAN=$HostName.*,mta-sts.*,webmail.*/" $var_mailcow_conf
  sed -i "s/ADDITIONAL_SERVER_NAMES=.*/ADDITIONAL_SERVER_NAMES=$HostName.*,mta-sts.*,webmail.*/" $var_mailcow_conf
else
  EchoLog error "${lang_mailcow_getconf_error}"
  exit 1
fi

# Deactivate TLS1.0 and TLS1.1 because it's fcking old!
cat > "$var_mailcow_postfix_extra" <<EOF
smtp_tls_protocols = !SSLv2, !SSLv3,!TLSv1,!TLSv1.1
smtp_tls_mandatory_protocols = !SSLv2, !SSLv3,!TLSv1,!TLSv1.1
smtpd_tls_protocols = !SSLv2, !SSLv3,!TLSv1,!TLSv1.1
smtpd_tls_mandatory_protocols = !SSLv2, !SSLv3,!TLSv1,!TLSv1.1
lmtp_tls_protocols = !SSLv2, !SSLv3,!TLSv1,!TLSv1.1
lmtp_tls_mandatory_protocols = !SSLv2, !SSLv3,!TLSv1,!TLSv1.1
# SSL/TLS supported ciphers
smtp_tls_ciphers = high
smtp_tls_mandatory_ciphers = high
smtpd_tls_ciphers = high
smtpd_tls_mandatory_ciphers = high
tls_high_cipherlist = tls_high_cipherlist = ECDHE-ECDSA-AES256-GCM-SHA384:TLS_AES_256_GCM_SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:TLS_CHACHA20_POLY1305_SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:TLS_AES_128_GCM_SHA256:ECDHE-RSA-AES256-GCM-SHA384:TLS_AES_256_GCM_SHA384:ECDHE-RSA-CHACHA20-POLY1305:TLS_CHACHA20_POLY1305_SHA256:ECDHE-RSA-AES128-GCM-SHA256:TLS_AES_128_GCM_SHA256
smtpd_tls_eecdh_grade = ultra
EOF
if [ -f "$var_mailcow_postfix_extra" ]; then
  EchoLog ok "${lang_mailcow_deactivatetls_ok}"
else
  EchoLog error "${lang_mailcow_deactivatetls_error}"
  exit 1
fi

# Redirect webmail.domain.tld to SOGo
rm -f "$var_mailcow_index_php"
if wget -qO "$var_mailcow_index_php" https://github.com/iThieler/uscp/blob/main/conf/mc/index.php.txt?raw=true; then
  EchoLog ok "${lang_mailcow_indexmodifiction_ok}"
else
  EchoLog error "${lang_mailcow_indexmodifiction_error}"
fi

# Change Logo on SOGo Login page
if wget -qO "$var_mailcow_sogo_logo" https://github.com/iThieler/uscp/blob/main/conf/mc/sogo-full.svg.txt?raw=true; then
  EchoLog ok "${lang_mailcow_sogologo_changed}"
fi

# Add MTA-STS .well-known
if [ ! -d "/opt/mailcow-dockerized/data/web/.well-known" ]; then mkdir "/opt/mailcow-dockerized/data/web/.well-known"; fi
cat > "$var_mailcow_mtasts" <<EOF
version: STSv1
mode: enforce
max_age: 2419200
mx: $FullName
EOF
if [ -f "$var_mailcow_mtasts" ]; then
  EchoLog ok "${lang_mailcow_mtasts_ok}"
else
  EchoLog error "${lang_mailcow_mtasts_error}"
  exit 1
fi

# Load and start Mailcow Container
cd "/opt/mailcow-dockerized/"
EchoLog wait "${lang_mailcow_loadcontainerwait}"
if docker compose pull; then
  EchoLog ok "${lang_mailcow_loadcontainerok}"
else
  EchoLog error "${lang_mailcow_loadcontainererror}"
  exit 1
fi

if docker compose up -d; then
  EchoLog ok "${lang_mailcow_startcontainerok}"
else
  EchoLog error "${lang_mailcow_startcontainererror}"
fi

cd "/root/"

exit 0

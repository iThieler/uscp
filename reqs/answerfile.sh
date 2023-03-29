#!/bin/bash
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)

###############################
## Q U E S T I O N N A I R E ##
###############################
# Host Variables
TimeZone=$(WhipInputbox "${lang_timezone_title}" "${lang_timezone_message}" "Europe/Berlin")
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
  MailServerPass=$(WhipInputboxPassword "${lang_mailserver_title}" "${lang_mailserver_needloginpasstext}" "")
  if WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${lang_mailserver_title}" "${lang_mailserver_needloginsecuretext}"; then MailServerTLS=true; fi
fi

###############################
##    A N S W E R F I L E    ##
###############################
cat > "$var_answerfile" <<EOF
#!/bin/bash
########### ANSWERFILE - iThieler' ULTIMATE SERVER CONTROL PANEL SCRIPT ###########
## In this file, responses are stored in variables that were made when the user  ##
## executed the script. This makes it easier to re-run the script because the    ##
## user does not have to answer all the questions over and over again.           ##
##                                                                               ##
## Created on $(date)                                    ##
###################################################################################
# Host Variables
TimeZone="${TimeZone}"
HostName="${HostName}"
DomainName="${DomainName}"
FullName="${HostName}.${DomainName}"

# Mailserver Variables
MailServerFQDN="${MailServerFQDN}"
MailServerPort=${MailServerPort}
MailServerFrom="${MailServerFrom}"
MailServerTo="${MailServerTo}"
MailServerUser="${MailServerUser}"
MailServerPass="${MailServerPass}"
MailServerTLS=${MailServerTLS}
EOF

if [ -f "$var_answerfile" ]; then exit 0; else exit 1; fi

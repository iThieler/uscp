#!/bin/bash
#######################################
## b e g i n . S H ##
#######################################
# CHECKUPS
lang_proxmox_title="Proxmox"
lang_proxmox_message="A Proxmox installation has been detected on this system. iThieler's Proxmox Script Collection is opened"
lang_proxmox_button1="All right, here we go"
lang_proxmox_button2="Nah, leave it"
lang_erroros_title="Operating system"
lang_erroros_message="The operating system you are using is not supported by this script"
lang_inetconnection_error="There is a problem with your server's internet connection. However, this is urgently needed by this script"
lang_answerfile_found="Response file found and loaded"
lang_answerfile_genrate_ok="Response file successfully created and saved"
lang_answerfile_generate_error="Failed to generate answer file"

# STARTUP
lang_change_timezone="Change timezone"
lang_change_hostname="Change hostname"
lang_wait_installsoftware="Necessary software will be installed"
lang_updateupgrade_startup="Complete system update"
lang_updateupgrade_done="System update successfully completed"
lang_updateupgrade_fail="System update not successful. Script is terminated"
lang_softwaredependencies_alreadyinstalled="already installed"
lang_softwaredependencies_installok="successfully installed"
lang_softwaredependencies_installfail="could not install"
lang_configurationcompleted_title="Server configuration"
lang_configurationcompleted_message="The basic configuration of the server is completed. In the next step, you can assign a role to the server"
lang_configurationcompleted_messageyesno="Should a corresponding selection dialog be displayed?"

# POSTFIX
lang_testpostfix_sendmessage="This is a test message, sent by the configuration script from the iThieler.Confirm receipt of this email in the configuration script"
lang_testpostfix_subjectarray="Test"
lang_testpostfix_subjecttext="Test message"
lang_testpostfix_whiptitle="Postfix"
lang_testpostfix_whipyesnotext="An email was sent to the specified address. Check the mailbox for receipt. Was the e-mail delivered successfully? (Depending on the provider, this can take up to 15 minutes)"
lang_testpostfix_whipalertmessage="The log file is checked for known errors, an attempt is made to automatically fix any errors found.\n\nAn email is then sent again. Also check the spam folder"
lang_testpostfix_whipalertmessage2="Unfortunately, the error could not be fixed. Check the error log and configure Postfix manually. All changes will be reverted."

# APTICRON
lang_confapticron_customsubject="Updates available"
lang_confapticron_customnoupdatessubject="no update available"

# SERVER ROLE
lang_selectserverrole_title="Server Role"
lang_selectserverrole_message="Choose a role to configure the server for"
lang_serverrole_configerror="Error configuring the server"
lang_serverrole_configundo_ok="Changes made by server role configuration undone"
lang_serverrole_configundo_error="Changes made by server role confuguration could not be reverted"
lang_dockerserver_configok="This server has been configured as a Docker host"
lang_mailserver_configok="This server has been configured as a mail server"
lang_mailarchive_configok="This server has been configured as a mail archive"
lang_omadasdn_configok="This server has been configured with the TP-Link Omada software controller"
lang_webserver_configok="This server has been configured as a web server"

lang_goodbye="That's it, see you next time :-)"
lang_logfilepath="The LOG file is located in the root directory"

#######################################
## M I S C / D P . S H ##
#######################################
lang_selectproxyinstall_title="Proxy"
lang_selectproxyinstall_message="Select the proxy to work with to forward to the various Docker containers"
lang_containerstarted="The selected container has been started successfully. The following ports need to be enabled"
lang_containernotstarted="The selected container could not be started"

#######################################
## M I S C / D T . S H ##
#######################################


#######################################
## M I S C / M C . S H ##
#######################################
# Software delete
lang_mailcow_postfix_deletewait="Remove Postfix and reset configuration"
lang_mailcow_postfix_stopok="Postfix service stopped"
lang_mailcow_postfix_stoperror="Failed to stop Postfix service"
lang_mailcow_postfix_deleteok="Postfix successfully removed"
lang_mailcow_postfix_deleteerror="Postfix could not be removed"

# mailcow
lang_mailcow_umask_error="Prerequisites for Mailcow not met"
lang_mailcow_gitclone_ok="Mailcow repository cloned successfully"
lang_mailcow_gitclone_error="Mailcow could not be obtained from github.com"
lang_mailcow_getconf_ok="Mailcow configuration file loaded"
lang_mailcow_getconf_error="Mailcow configuration file not loaded"
lang_mailcow_deactivatetls_ok="TLS1.0 and TLS 1.1 disabled"
lang_mailcow_deactivatetls_error="Failed to disable TLS 1.0 and TLS1.1"
lang_mailcow_indexmodifiction_ok="index.php modified for webmail.domain.tld forwarding"
lang_mailcow_indexmodifiction_error="index.php could not be modified for webmail.domain.tld forwarding"
lang_mailcow_sogologo_changed="Logo on SOGo login page changed"
lang_mailcow_mtasts_ok="mta-sts has been activated"
lang_mailcow_mtasts_error="mta-sts could not be activated"
lang_mailcow_loadcontainerwait="The required containers are loaded"
lang_mailcow_loadcontainerok="Mailcow downloaded successfully"
lang_mailcow_loadcontainererror="Mailcow could not be downloaded"
lang_mailcow_startcontainerok="Mailcow started successfully"
lang_mailcow_startcontainererror="Mailcow could not be started"

#######################################
## M I S C / M P . S H ##
#######################################


#######################################
##        M I S C / N B . S H        ##
#######################################
lang_netbox_gitclone_ok="Netbox repository successfully cloned"
lang_netbox_gitclone_error="Netbox could not be obtained from github.com"
lang_netbox_loadcontainerwait="The required containers are loaded"
lang_netbox_loadcontainerok="Netbox downloaded successfully"
lang_netbox_loadcontainererror="Netbox could not be downloaded"
lang_netbox_startcontainerok="Netbox successfully started"
lang_netbox_startcontainererror="Netbox could not be started"

#######################################
## M I S C / O M . S H ##
#######################################
# checkups
lang_omada_checkdnserror="This script only supports domain names (FQDN) with valid DNS-A and/or DNS-AAAA record"
lang_omada_checkdnspublicerror="This script only supports domain names (FQDN) with valid DNS-A and/or DNS-AAAA record for public IPs"

# certbot
lang_omada_gencertok="Let's Encrypt certificate has been created"
lang_omada_gencerterror="Let's Encrypt certificate has been created"
lang_omada_croncertok="CronJob file created for certificate renewal"
lang_omada_croncerterror="CronJob file for certificate renewal could not be created"

# Omada SDN
lang_omada_selectversion_title="Omada Version"
lang_omada_selectversion_message="Which version of Omada Software Controller do you want to install?"
lang_omada_downloadok="Installation package downloaded successfully"
lang_omada_downloaderror="Installation package could not be loaded"
lang_omada_instalok="TP-Link Omada Software Controller installed successfully"
lang_omada_instalerror="Error installing Omada Software Controller"
lang_omada_testrenewcertok="The SSL certificate from Let's Encrypt has been successfully renewed"
lang_omada_testrenewcerterror="The SSL certificate could not be renewed"
lang_omada_sdnstartok="The Omada Software Controller was started successfully. The following ports need to be enabled"
lang_omada_sdnstarterror="The Omada Software Controller could not be started"
lang_omada_webadress="Address of the web interface"

#######################################
## M I S C / W W . S H ##
#######################################


#########################################
## R E Q S / A N S W E R F I L E . S H ##
#########################################
# HOST VARIABLES
lang_timezone_title="Timezone"
lang_timezone_message="What is the required timezone?"
lang_hostname_title="Hostname"
lang_hostname_message="What hostname should the server have?"
lang_domainname_title="Host domain name"
lang_domainname_message="What is the domain name to be used?"

# Mailserver for notifications
lang_mailserver_title="Mailserver"
lang_mailserver_messageboxtext="To be able to send notifications, you need to specify the data about a mail server. No matter if self operated or a public one (web.de, gmx.de or gmail.com)."
lang_mailserver_mailserverfqdntext="What is the address to the mail server used?"
lang_mailserver_mailserverporttext="What is the SMTP port for the mail server used?"
lang_mailserver_mailserverfromtext="What is the sender address from which notifications should be sent?"
lang_mailserver_mailservertotext="What is the email address to which notifications should be sent?"
lang_mailserver_needloginyesnotext="Is a login required for the mail server?"
lang_mailserver_needloginusertext="What is the username required for login?"
lang_mailserver_needloginpasstext="What is the password required for login?"
lang_mailserver_needloginsecuretext="Does the mail server require encryption (SSL, STARTTLS or similar)?"

#######################################
## R E Q S / F U N C T I O N S . S H ##
#######################################
# HELPER
lang_checkip_title="IP address"
lang_checkip_mainmessage="The specified IP address is unreachable. Please check ..."
lang_checkip_errormessage="Operation cancelled by user, the IP address is unreachable"
lang_cleanupall_infomessage="System cleanup is in progress"
lang_cleanupall_cleantempfolder="Cleaning up the TEMP folder"
lang_cleanupall_historydata="Cleanup of shell history data"

# SYSTEM WORK
lang_updateupgrade_title="System update and upgrade"
lang_updateupgrade_mainmessage="Full system update is being prepared ..."
lang_updateupgrade_execmessage="Full system update is being executed ..."
lang_backupandrestorefile_file="The file"
lang_backupandrestorefile_bakupfile="was saved in"
lang_backupandrestorefile_restorefile="was restored in"
lang_backupandrestorefile_deletebakfile="The following file backup has been removed"
lang_backupandrestorefile_nobakfile="The requested file could not be restored. No file backup was found."

# BUTTONS
lang_btn_ok="OK"
lang_btn_cancel="Cancel"
lang_btn_yes="Yes"
lang_btn_no="No"

# TEXTS
lang_txt_noinput="There must be an input"
lang_txt_autogeneratepassword="Should an automatically created password be used?"
lang_txt_autogeneratepasswordis="The automatically generated password is"
lang_txt_foundspaces="A password must not contain spaces"

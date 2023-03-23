#!/bin/bash
#######################################
## b e g i n . S H ##
#######################################
# BASIC SETTINGS

# HOST VARIABLES
lang_hostname_title="Host Variables"
lang_hostname_message="What hostname should the server have?"
lang_domainname_title="Host Variables"
lang_domainname_message="What is the domain name to be used?"

# CHECKUPS
lang_proxmox_title="Proxmox"
lang_proxmox_message="A Proxmox installation has been detected on this system. iThieler's Proxmox Script Collection is opened."
lang_proxmox_button1="Alright, here we go."
lang_proxmox_button2="Nah, leave it"
lang_erroros_title="Operating System"
lang_erroros_message="The operating system you are using is not supported by this script."
lang_inetconnection_error="There is a problem with your server's internet connection. However, this is urgently needed by this script."

# QUESTIONNAIRE
lang_mailserver_title="Mailserver"
lang_mailserver_messageboxtext="To be able to send notifications, you need to specify the data about a mail server. No matter if self operated or a public one (web.de, gmx.de or gmail.com)."
lang_mailserver_mailserverfqdntext="What is the address to the mail server used?"
lang_mailserver_mailserverporttext="What is the SMTP port for the mail server used?"
lang_mailserver_mailserverfromtext="What is the sender address from which notifications should be sent?"
lang_mailserver_needloginyesnotext="Is a login required for the mail server?"
lang_mailserver_needloginusertext="What is the username required for login?"
lang_mailserver_needloginpasstext="What is the password required for login?"
lang_mailserver_needloginsecuretext="Does the mail server require encryption (SSL, STARTTLS or similar)?"

# STARTUP
lang_updateupgrade_startup="Full system update"
lang_updateupgrade_done="System update completed successfully".
lang_updateupgrade_fail="System update not successful. Script terminates."
lang_softwaredependencies_alreadyinstalled="already installed"
lang_softwaredependencies_installok="successfully installed".
lang_softwaredependencies_installfail="could not install".
lang_configurationcompleted_title="Server configuration".
lang_configurationcompleted_message="The basic configuration of the server is completed. In the next step, you can assign a role to the server."
lang_configurationcompleted_messageyesno="Should a corresponding selection dialog be displayed?"

# SERVER ROLE
lang_selectserverrole_title="Server Role"
lang_selectserverrole_message="Select a role for which the server should be configured."

lang_goodbye="That's it, see you next time :-)"

#######################################
## R E Q S / F U N C T I O N S . S H ##
#######################################
# HELPER
lang_checkip_title="IP address"
lang_checkip_mainmessage="The specified IP address is unreachable. Please check ..."
lang_checkip_errormessage="Operation cancelled by user, the IP address is unreachable."
lang_cleanupall_infomessage="System cleanup is in progress"
lang_cleanupall_cleantempfolder="Cleaning up the TEMP folder"
lang_cleanupall_historydata="Cleanup of shell history data"

# SYSTEM WORK
lang_updateupgrade_title="System update and upgrade".
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
lang_txt_autogeneratepasswordis="The automatically generated password is:"
lang_txt_foundspaces="A password must not contain spaces"
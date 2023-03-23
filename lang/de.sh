#!/bin/bash
#######################################
##          b e g i n . S H          ##
#######################################
# BASIC SETTINGS

# HOST VARIABLES
lang_hostname_title="Host Variables"
lang_hostname_message="Welchen Hostnamen soll der Server haben?"
lang_domainname_title="Host Variables"
lang_domainname_message="Wie lautet der Domainname, der genutzt werden soll?"

# CHECKUPS
lang_proxmox_title="Proxmox"
lang_proxmox_message="Auf diesem System wurde eine Proxmox Installation erkannt. iThieler's Proxmox Script Collection wird geöffnet."
lang_proxmox_button1="Alles klar, los geht's"
lang_proxmox_button2="Ne, lass mal"
lang_erroros_title="Betriebssystem"
lang_erroros_message="Das genutzte Betriebssystem wird von diesem Skript nicht unterstützt."
lang_inetconnection_error="Es besteht ein Problem mit der Internetverbindung deines Servers. Diese wird von diesem Skript jedoch dringend benötigt."

# QUESTIONNAIRE
lang_mailserver_title="Mailserver"
lang_mailserver_messageboxtext="Um Benachrichtigungen senden zu können, müssen die Daten zu einem Mailserver angegeben werden. Egal ob selbst betrieben oder ein öffentlicher (web.de, gmx.de oder gmail.com)."
lang_mailserver_mailserverfqdntext="Wie lautet die Adresse zu dem genutzten Mailserver?"
lang_mailserver_mailserverporttext="Wie lautet der SMTP-Port für den genutzten Mailserver?"
lang_mailserver_mailserverfromtext="Wie lautet die Absende Adresse, von der Benachrichtigungen gesendet werden sollen?"
lang_mailserver_needloginyesnotext="Wird für den Mailserver ein Login benötigt?"
lang_mailserver_needloginusertext="Wie lautet der Benutzername, der für den Login benötigt wird?"
lang_mailserver_needloginpasstext="Wie lautet das Passwort, welches für den Login benötigt wird?"
lang_mailserver_needloginsecuretext="Benötigt der Mailserver eine Verschlüsselung (SSL, STARTTLS o.Ä.)?"

# STARTUP
lang_updateupgrade_startup="Vollständiges Systemupdate"
lang_updateupgrade_done="Systemupdate erfolgreich abgeschlossen"
lang_updateupgrade_fail="Systemupdate nicht erfolgreich. Skript wird beendet."
lang_softwaredependencies_alreadyinstalled="bereits installiert"
lang_softwaredependencies_installok="erfolgreich installiert"
lang_softwaredependencies_installfail="konnte nicht installiert werden"
lang_configurationcompleted_title="Serverkonfiguration"
lang_configurationcompleted_message="Die Grundkonfiguration des Servers ist beendet. Im nächsten Schritt kann dem Server eine Rolle zugewiesen werden."
lang_configurationcompleted_messageyesno="Soll ein entsprechender Auswahldialog angezeigt werden?"

# SERVER ROLE
lang_selectserverrole_title="Serverrolle"
lang_selectserverrole_message="Wähle eine Rolle für die der Server konfiguriert werden soll."

lang_goodbye="Das war's, bis zum nächsten mal :-)"

#######################################
## R E Q S / F U N C T I O N S . S H ##
#######################################
# HELPER
lang_checkip_title="IP-Adresse"
lang_checkip_mainmessage="Die angegebene IP-Adresse ist nicht erreichbar. Bitte prüfen ..."
lang_checkip_errormessage="Vorgang durch Benutzer abgebrochen, die IP-Adresse ist nicht erreichbar."
lang_cleanupall_infomessage="Systembereinigung wird ausgeführt"
lang_cleanupall_cleantempfolder="Bereinigung des TEMP-Ordner"
lang_cleanupall_historydata="Bereinigung der Shell-Verlaufsdaten"

# SYSTEM WORK
lang_updateupgrade_title="Systemupdate und Upgrade"
lang_updateupgrade_mainmessage="Vollständiges Systemupdate wird vorbereitet ..."
lang_updateupgrade_execmessage="Vollständiges Systemupdate wird ausgeführt ..."
lang_backupandrestorefile_file="Die Datei"
lang_backupandrestorefile_bakupfile="wurde gesichert in"
lang_backupandrestorefile_restorefile="wurde wiederhergestellt in"
lang_backupandrestorefile_deletebakfile="Das folgende Dateibackup wurde entfernt"
lang_backupandrestorefile_nobakfile="Die gewünschte Datei konnte nicht wiederhergestellt werden. Es wurde kein Dateibackup gefunden."

# BUTTONS
lang_btn_ok="OK"
lang_btn_cancel="Abbrechen"
lang_btn_yes="Ja"
lang_btn_no="Nein"

# TEXTS
lang_txt_noinput="Es muss eine Eingabe erfolgen"
lang_txt_autogeneratepassword="Soll ein automatisch erstelltes Passwort genutzt werden?"
lang_txt_autogeneratepasswordis="Das automatisch generierte Passwort lautet:"
lang_txt_foundspaces="Ein Passwort darf keine Leerzeichen enthalten"

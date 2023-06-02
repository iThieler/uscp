#!/bin/bash
#######################################
##            G L O B A L            ##
#######################################
lang_global_username="Benutzername"
lang_global_password="Passwort"
lang_global_adminuser="Welchen Benutzernamen soll der Adminbenutzer haben?"
lang_global_registeruser="Administrator ist der erste registrierte Benutzer"

#######################################
##          b e g i n . S H          ##
#######################################
# CHECKUPS
lang_proxmox_title="Proxmox"
lang_proxmox_message="Auf diesem System wurde eine Proxmox Installation erkannt. iThieler's Proxmox Script Collection wird geöffnet"
lang_proxmox_button1="Alles klar, los geht's"
lang_proxmox_button2="Ne, lass mal"
lang_erroros_title="Betriebssystem"
lang_erroros_message="Das genutzte Betriebssystem wird von diesem Skript nicht unterstützt"
lang_info_os_ok="Betriebssytem wird unterstützt"
lang_inetconnection_error="Es besteht ein Problem mit der Internetverbindung deines Servers. Diese wird von diesem Skript jedoch dringend benötigt"
lang_answerfile_found="Antwortdatei gefunden und geladen"
lang_answerfile_genrate_ok="Antwortdatei erfolgreich erstellt und gespeichert"
lang_answerfile_generate_error="Antwortdatei konnte nicht erstellt werden"

# STARTUP
lang_change_timezone="Ändere Zeitzone"
lang_change_hostname="Ändere Hostname"
lang_wait_installsoftware="Benötigte Software wird installiert"
lang_updateupgrade_startup="Vollständiges Systemupdate"
lang_updateupgrade_done="Systemupdate erfolgreich abgeschlossen"
lang_updateupgrade_fail="Systemupdate nicht erfolgreich. Skript wird beendet"
lang_softwaredependencies_alreadyinstalled="bereits installiert"
lang_softwaredependencies_installok="erfolgreich installiert"
lang_softwaredependencies_installfail="konnte nicht installiert werden"
lang_configurationcompleted_title="Serverkonfiguration"
lang_configurationcompleted_message="Die Grundkonfiguration des Servers ist beendet. Im nächsten Schritt kann dem Server eine Rolle zugewiesen werden"
lang_configurationcompleted_messageyesno="Soll ein entsprechender Auswahldialog angezeigt werden?"

# POSTFIX
lang_testpostfix_sendmessage="Dies ist eine Testnachricht, versendet durch das Konfigurationsskript vom iThieler.\n\nBestätige den Erhalt dieser E-Mail im Konfigurationsskript."
lang_testpostfix_subjectarray="Test"
lang_testpostfix_subjecttext="Testnachricht"
lang_testpostfix_whiptitle="Postfix"
lang_testpostfix_whipyesnotext="Es wurde eine E-Mail an die angegebene Adresse gesendet. Prüfe das Postfach auf erhalt. Wurde die E-Mail erfolgreich zugestellt? (Je nach Anbieter kann dies bis zu 15 Minuten dauern)"
lang_testpostfix_whipalertmessage="Die Protokolldatei wird auf bekannte Fehler geprüft, es wird versucht, gefundene Fehler automatisch zu beheben.\n\nAnschließend wird erneut eine E-Mail gesendet. Überprüfe auch den Spam-Ordner"
lang_testpostfix_whipalertmessage2="Leider konnte der Fehler nicht behoben werden. Prüfe das Fehlerprotokoll und konfiguriere Postfix manuell. Alle Änderungen werden rückgängig gemacht"

# APTICRON
lang_confapticron_customsubject="Updates verfügbar"
lang_confapticron_customnoupdatessubject="kein Update verfügbar"

# SERVER ROLE
lang_selectserverrole_title="Serverrolle"
lang_selectserverrole_message="Wähle eine Rolle für die der Server konfiguriert werden soll"
lang_serverrole_configerror="Fehler bei der Serverkonfiguration"
lang_serverrole_configundo_ok="Änderungen durch Serverrollenkonfigurtaion rückgängig gemacht"
lang_serverrole_configundo_error="Durch Serverrollenkonfuguration gemachte Änderungen konnten nicht rückgängig gemacht werden"
lang_dockerserver_configok="Dieser Server wurde als Docker Host konfiguriert"
lang_mailserver_configok="Dieser Server wurde als Mailserver konfiguriert"
lang_mailarchiv_configok="Dieser Server wurde als Mailarchiv konfiguriert"
lang_omadasdn_configok="Dieser Server wurde mit dem TP-Link Omada Software Controller konfiguriert"
lang_webserver_configok="Dieser Server wurde Webserver konfiguriert"

lang_goodbye="Das war's, bis zum nächsten Mal :-)"
lang_logfilepath="Die LOG-Datei liegt im Root-Verzeichnis"

#######################################
##        M I S C / D P . S H        ##
#######################################
lang_selectproxyinstall_title="Proxy"
lang_selectproxyinstall_message="Wähle den Proxy, mit dem gearbeitet werden soll, um auf die verschiedenen Docker Container weiterzuleiten."
lang_containerstarted="Der ausgewählte Container wurde erfolgreich gestartet. Die folgenden Ports müssen freigegeben werden:"
lang_containernotstarted="Der ausgewählte Container konnte nicht gestartet werden."

#######################################
##        M I S C / D T . S H        ##
#######################################


#######################################
##        M I S C / M C . S H        ##
#######################################
# Software delete
lang_mailcow_postfix_deletewait="Entferne Postfix und setze Konfiguration zurück"
lang_mailcow_postfix_stopok="Postfix Service gestoppt"
lang_mailcow_postfix_stoperror="Postfix Service konnte nicht gestoppt werden"
lang_mailcow_postfix_deleteok="Postfix erfolgreich entfernt"
lang_mailcow_postfix_deleteerror="Postfix konnte nicht entfernt werden"

# Mailcow
lang_mailcow_umask_error="Voraussetzungen für Mailcow nicht erfüllt"
lang_mailcow_gitclone_ok="Mailcow Repository erfolgreich geklont"
lang_mailcow_gitclone_error="Mailcow konnt nicht von github.com bezogen werden"
lang_mailcow_getconf_ok="Mailcow Konfigurationsdatei geladen"
lang_mailcow_getconf_error="Mailcow Konfigurationsdatei nicht geladen"
lang_mailcow_deactivatetls_ok="TLS1.0 und TLS 1.1 deaktiviert"
lang_mailcow_deactivatetls_error="TLS 1.0 und TLS1.1 konnte nicht deaktiviert werden"
lang_mailcow_indexmodifiction_ok="index.php für webmail.domain.tld Weiterleitung modifiziert"
lang_mailcow_indexmodifiction_error="index.php konnte nicht für webmail.domain.tld Weiterleitung modifiziert werden"
lang_mailcow_sogologo_changed="Logo auf der SOGo Login Seite geändert"
lang_mailcow_mtasts_ok="mta-sts wurde aktiviert"
lang_mailcow_mtasts_error="mta-sts konnte nicht aktiviert werden"
lang_mailcow_loadcontainerwait="Die benötigten Container werden geladen"
lang_mailcow_loadcontainerok="Mailcow erfolgreich heruntergeladen"
lang_mailcow_loadcontainererror="Mailcow konnte nicht heruntergeladen werden"
lang_mailcow_startcontainerok="Mailcow erfolgreich gestartet"
lang_mailcow_startcontainererror="Mailcow konnte nicht gestartet werden"

#######################################
##        M I S C / M P . S H        ##
#######################################


#######################################
##        M I S C / N B . S H        ##
#######################################
lang_netbox_gitclone_ok="Netbox Repository erfolgreich geklont"
lang_netbox_gitclone_error="Netbox konnt nicht von github.com bezogen werden"
lang_netbox_loadcontainerwait="Die benötigten Container werden geladen"
lang_netbox_loadcontainerok="Netbox erfolgreich heruntergeladen"
lang_netbox_loadcontainererror="Netbox konnte nicht heruntergeladen werden"
lang_netbox_startcontainerok="Netbox erfolgreich gestartet"
lang_netbox_startcontainererror="Netbox konnte nicht gestartet werden"
lang_betbox_restartafterconfig="Neustart nach Konfigurationsanpassung"
lang_netbox_infotext="Die automatisch erstellten SuperUser Daten können ind er Datei /opt/netbox-docker/docker-compose.override.yml geändert werden, und lauten"
lang_netbox_infotext_api="SuperUser API-Schlüssel:"
lang_netbox_infotext_name="SuperUser Name:        "
lang_netbox_infotext_pass="SuperUser-Passwort:    "

#######################################
##        M I S C / O M . S H        ##
#######################################
# Certbot
lang_omada_gencertok="Let's Encrypt-Zertifikat wurde erstellt"
lang_omada_gencerterror="Let's Encrypt-Zertifikat wurde erstellt"
lang_omada_croncertok="CronJob-Datei zur Zertifikatserneuerung erstellt"
lang_omada_croncerterror="CronJob-Datei zur Zertifikatserneuerung konnte nicht erstellt werden"

# Omada SDN
lang_omada_selectversion_title="Omada Version"
lang_omada_selectversion_message="Welche Version des Omada Software Controller soll installiert werden?"
lang_omada_downloadok="Installationspaket erfolgreich heruntergeladen"
lang_omada_downloaderror="Installationspaket konnte nicht geladen werden"
lang_omada_instalok="TP-Link Omada Software Controller erfolgreich installiert"
lang_omada_instalerror="Fehler bei der Installation des Omada Software Controller"
lang_omada_testrenewcertok="Das SSL-Zertifikat von Let's Encrypt wurde erfolgreich erneuert"
lang_omada_testrenewcerterror="Das SSL-Zertifikat konnte nicht erneuert werden"
lang_omada_sdnstartok="Der Omada Software Controller wurde erfolgreich gestartet. Die folgenden Ports müssen freigegeben werden"
lang_omada_sdnstarterror="Der Omada Software Controller konnte nicht gestartet werden."
lang_omada_webadress="Adresse der Weboberfläche"

#######################################
##        M I S C / W W . S H        ##
#######################################


#########################################
## R E Q S / A N S W E R F I L E . S H ##
#########################################
# HOST VARIABLES
lang_timezone_title="Timezone"
lang_timezone_message="Wie lautet die benötigte Timezone?"
lang_hostname_title="Hostname"
lang_hostname_message="Welchen Hostnamen soll der Server haben?"
lang_domainname_title="Host Domainname"
lang_domainname_message="Wie lautet der Domainname, der genutzt werden soll?"

# Mailserver for notifications
lang_mailserver_title="Mailserver"
lang_mailserver_messageboxtext="Um Benachrichtigungen senden zu können, müssen die Daten zu einem Mailserver angegeben werden. Egal ob selbst betrieben oder ein öffentlicher (web.de, gmx.de oder gmail.com)."
lang_mailserver_mailserverfqdntext="Wie lautet die Adresse zu dem genutzten Mailserver?"
lang_mailserver_mailserverporttext="Wie lautet der SMTP-Port für den genutzten Mailserver?"
lang_mailserver_mailserverfromtext="Wie lautet die Absende Adresse, von der Benachrichtigungen gesendet werden sollen?"
lang_mailserver_mailservertotext="Wie lautet die E-Mail-Adresse, an die Benachrichtigungen gesendet werden sollen?"
lang_mailserver_needloginyesnotext="Wird für den Mailserver ein Login benötigt?"
lang_mailserver_needloginusertext="Wie lautet der Benutzername, der für den Login benötigt wird?"
lang_mailserver_needloginpasstext="Wie lautet das Passwort, welches für den Login benötigt wird?"
lang_mailserver_needloginsecuretext="Benötigt der Mailserver eine Verschlüsselung (SSL, STARTTLS o.Ä.)?"

#######################################
## R E Q S / F U N C T I O N S . S H ##
#######################################
# HELPER
lang_checkip_title="IP-Adresse"
lang_checkip_mainmessage="Die angegebene IP-Adresse ist nicht erreichbar. Bitte prüfen ..."
lang_checkip_errormessage="Vorgang durch Benutzer abgebrochen, die IP-Adresse ist nicht erreichbar."
lang_checkdns_error="Dieses Skript unterstützt nur Domainnamen (FQDN) mit gültigem DNS-A und/oder DNS-AAAA Record"
lang_checkdns_publiciperror="Dieses Skript unterstützt nur Domainnamen (FQDN) mit gültigem DNS-A und/oder DNS-AAAA Record für öffentliche IPs"
lang_cleanupall_infomessage="Systembereinigung wird ausgeführt"
lang_cleanupall_cleantempfolder="Bereinigung des TEMP-Ordners"
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

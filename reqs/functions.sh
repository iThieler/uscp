#!/bin/bash
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)

################################
##         L O G O S          ##
################################
function HeaderLogo() {
  # This function clears the shell prompt and displays the logo with the selected message
  # ----------
  # Call with: HeaderLogo "MESSAGE"       !!! Note - Maximum 35 characters !!!
  # ----------
  clear
  echo -e "
   _ _____ _    _     _         _    
  (_)_   _| |_ (_)___| |___ _ _( )___
  | | | | | ' \| / -_) / -_) '_|/(_-<
  |_| |_| |_||_|_\___|_\___|_|   /__/
  ${1}                                          
"
}

function DockerLogo() {
  # This function displays the docker
  # ----------
  # Call with: DockerLogo
  # ----------
  echo -e "
                     ##        '
               ## ## ##       ==
            ## ## ## ##      ===
        /''''''''''''''''\___/ ===
  ~~~  {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===_ ~~~
        \______ o          __/
          \    \        __/
           \____\______/
  "
  echo "----------" >> "${var_logfile}"
  echo -e "$(date +'%Y-%m-%d  %T')  [CONFIGURE]   Docker Server" >> "${var_logfile}"
  echo "----------" >> "${var_logfile}"
}

function MailcowLogo() {
  echo -e "
                                          ..
  .~~:  ^        ^  :~!:                  JBGP?:
  ?GYB5!BPJYYYY5G&GGB5PP^~~~~~~~~~~~~^~??:B &&B!
  ^Y::&            &^:Y^             ~7^7~~&!.
   .~5  &#      #&  P!.           .~7^  !?? 5
    :&  &P      P#   J~.        :!!:    !BPY^
    J                Y:?7.    ^?!.      !!
    5    &&&&&&&&    G~!^!!^~7~~!~.     !!
    J#P5YJJJJJJJJY5P#P.   .::    ^7!.   !!
    .7JJ7:?JJJJJ:7JJ7.             :7!. !!
    :!7!?JJJJY77!:                 :!!?!!
          ....^7!!?PPPPPJ^~~~~~!!?PPPPP57.
                ..7     J      ::7     Y
                  .^~!!^         .^~!!^.
  "
  echo "----------" >> "${var_logfile}"
  echo -e "$(date +'%Y-%m-%d  %T')  [CONFIGURE]   Mailcow Mailserver" >> "${var_logfile}"
  echo "----------" >> "${var_logfile}"
}

function OmadaLogo() {
  echo -e "
                           .^!?JYYJ7~:
                        .7P##BP5Y5PG#&BJ^
                       :B@P!         ^J#@7
                           ~5B##B###P7         ::
                         .JG7:      ~PG^       #B
   :?555Y7.  .75PP5!7PPP5~   :?5PP5?.   :?5PP5J&B  :?5PP5J:
  7&Y~::~P#^ B&7:^Y@&7:^Y@J ?@P~:^!G&! 7&P!:^!P@B 7&P!^^!P&7
  B#     :@Y.@P   .@G   :@G #@.    :@G B@:    :@B B@:    .@B
  ~BP7~~?GG::@G   :@G   :@G ~#B?!!JB@B ~BBJ!!JB@B ~BBJ!!JB@B
   .!JYYJ~  .7!   .7!   .7!  .!J5YJ!7!   !J55J!7!   ~J55J!7!
  "
  echo "----------" >> "${var_logfile}"
  echo -e "$(date +'%Y-%m-%d  %T')  [CONFIGURE]   TP-Link Omada Software Controller Server" >> "${var_logfile}"
  echo "----------" >> "${var_logfile}"
}

function NetboxLogo() {
  echo -e "
      .?Y7          !5J.                                                         
      ^&@B.        ~&@&~                             :.                          
  :!~. !&:     .!!5P~:.                        .^.  ^@5                          
  .B@@5YP@YYYYYYG@@P          .^:~!^   .~!~:  ^5@J^.^@P:!!:    .^!~:   ^~. .~^   
   :!^  !&:     .GG          ?@BY5@G  ?#5  &J JB@GY:^@&5YP#P: ?#GY5#G^  BG7BG   
        ~&.      5P          ?@?  B@::@&YJYGG. J@!  ^@G   J@?.@#   7@5  !@@&^    
        7&^      5P  :~^     ?@?  G@: ?#       7@GJ:^@#5Y5#G: ?#GY5#G^ J&Y^P&?   
      !@@#YYYYYYB#YY#@@~     .^.  ^^   .~!~!:.  ^!!..^:^!!^    .~!!:  .~^   ^~.  
    .:JG?7^..... PG .^7!.
  .P@@Y         J@@J
  7PY.         ~55~
  "
  echo "----------" >> "${var_logfile}"
  echo -e "$(date +'%Y-%m-%d  %T')  [CONFIGURE]   NetBox Server" >> "${var_logfile}"
  echo "----------" >> "${var_logfile}"
}

################################
##        H E L P E R         ##
################################
function GeneratePassword() {
  # This function generates a random secure password with special characters that also work in Linux
  # ----------
  # Call with: GeneratePassword 27      !!! Note - 27 is the password length in this example !!!
  # ----------
  chars=({0..9} {a..z} {A..Z} "_" "%" "+" "-" ".")
  for i in $(eval echo "{1..$1}"); do
    echo -n "${chars[$(($RANDOM % ${#chars[@]}))]}"
  done 
}

function GenerateUserName() {
  # This function generates a random Username
  # ----------
  # Call with: GenerateUserName 12      !!! Note - 12 is the length of the Username in this example !!!
  # ----------
  chars=({0..9} {a..z} {A..Z})
  for i in $(eval echo "{1..$1}"); do
    echo -n "${chars[$(($RANDOM % ${#chars[@]}))]}"
  done 
}

function GenerateAPIKey() {
  # This function generates a random API-Key
  # ----------
  # Call with: GenerateAPIKey 32      !!! Note - 32 is the length of the API key in this example !!!
  # ----------
  chars=({0..9} {a..f})
  for i in $(eval echo "{1..$1}"); do
    echo -n "${chars[$(($RANDOM % ${#chars[@]}))]}"
  done 
}

function EchoLog() {
  # Function write event to logfile and echo colorized in shell
  # ----------
  # Call with: EchoLog error "message"    >> For error messages
  # Call with: EchoLog wait "message"    >> For wait messages
  # Call with: EchoLog ok "message"    >> For ok messages
  # Call with: EchoLog info "message"    >> For info messages
  # Call with: EchoLog no "message"    >> For messages without any flag
  # ----------
  text=$(echo -e ${2} | sed ':a;N;$!ba;s/\n/ /g' | sed 's/ +/ /g')
  
  if [ ! -f "${var_logfile}" ]; then touch "${var_logfile}"; fi

  if [[ "${1}" == "error" ]]; then
    echo -e "$(date +'%Y-%m-%d  %T')  [${var_color_red}ERROR${var_color_nc}]  $text"
    echo -e "$(date +'%Y-%m-%d  %T')  [ERROR]  $text" >> "${var_logfile}"
  elif [[ "${1}" == "wait" ]]; then
    echo -e "$(date +'%Y-%m-%d  %T')  [${var_color_yellow}WAIT${var_color_nc}]   $text"
    echo -e "$(date +'%Y-%m-%d  %T')  [WAIT]   $text" >> "${var_logfile}"
  elif [[ "${1}" == "ok" ]]; then
    echo -e "$(date +'%Y-%m-%d  %T')  [${var_color_green}OK${var_color_nc}]     $text"
    echo -e "$(date +'%Y-%m-%d  %T')  [OK]     $text" >> "${var_logfile}"
  elif [[ "${1}" == "info" ]]; then
    echo -e "$(date +'%Y-%m-%d  %T')  [${var_color_blue}INFO${var_color_nc}]   $text"
    echo -e "$(date +'%Y-%m-%d  %T')  [INFO]   $text" >> "${var_logfile}"
  elif [[ "${1}" == "no" ]]; then
    echo -e "                               $text"
    echo -e "                               $text" >> "${var_logfile}"
  fi
}

function CheckIP() {
  # This function returns true if the given IP address is reachable, if not, you can check the IP address and change it if necessary.
  # ----------
  # Call with: CheckIP "192.168.0.1"      !!! Note - 192.168.0.1 is the IP address to be checked in this example !!!
  # use in an if-query: if CheckIP "192.168.0.1"; then ipExist=true; else ipExist=false; fi
  # use in an if-query: if CheckIP "${IPVAR}"; then ipExist=true; else ipExist=false; fi
  # ----------
  function ping() { if ping -c 1 $1 &> /dev/null; then true; else false; fi }
  
  ip="${1}"
  while ! ping ${ip}; do
    NEWT_COLORS_FILE=~/.iThielers_NEWT_COLORS_ALERT \
    input=$(whiptail --inputbox --ok-button " ${lang_btn_ok^^} " --cancel-button " ${lang_btn_cancel^^} " --backtitle "${var_whipbacktitle}" --title " ${lang_checkip_title^^} " "\n${lang_checkip_mainmessage}" 0 80 "${ip}" 3>&1 1>&2 2>&3)
    if [ $? -eq 1 ]; then
      EchoLog error "${lang_checkip_errormessage}"
      return 1
    fi
  done

  return 0
}

function CheckDNS() {
  # This function checks if the specified fqdn exists with a valid
  # DNS-A or DNS-AAAA entry, and the stored IP is a public and not
  # a private IP address. This ensures that the server is publicly
  # accessible. Needed e.g. by a mail server.
  # ----------
  # Call with: CheckDNS "sub.domain.tld"
  # ----------
  ipv4=$(dig +short $1 A)
  ipv6=$(dig +short $1 AAAA)

  # Check DNS-A and DNS-AAAA Record
  if [ -z "$ipv4" ] && [ -z "$ipv6" ]; then
    EchoLog error "${lang_checkdns_error}"
    return 1
  fi

  # Check DNS-A for privat Network IPv4
  ipv4_firstblock=`echo $ipv4 | cut -d. -f1`
  ipv4_secondblock=`echo $ipv4 | cut -d. -f2`
  if [ $ipv4_firstblock -eq 10 ] || [ $ipv4_firstblock -eq 127 ]; then
    EchoLog error "${lang_checkdns_publiciperror}"
    return 1
  elif [ $ipv4_firstblock -eq 192 ] && [ $ipv4_secondblock -eq 168 ]; then
    EchoLog error "${lang_checkdns_publiciperror}"
    return 1
  elif [ $ipv4_firstblock -eq 169 ] && [ $ipv4_secondblock -eq 254 ]; then
    EchoLog error "${lang_checkdns_publiciperror}"
    return 1
  elif [ $ipv4_firstblock -eq 172 ] && [ $ipv4_secondblock -ge 16 ] && [ $ipv4_secondblock -le 31 ]; then
    EchoLog error "${lang_checkdns_publiciperror}"
    return 1
  fi

  # Check DNS-AAAA for privat Network IPv6
  if [[ "${ipv6:0:2}" == "fc" ]] || [[ "${ipv6:0:2}" == "fd" ]]; then
    EchoLog error "${lang_checkdns_publiciperror}"
    return 1
  fi

  return 0
}

function CleanupAll() {
  # This function cleans the shell history incl. possibly stored passwords
  # ----------
  # Call with: CleanupAll
  # ----------
  EchoLog wait "${lang_cleanupall_infomessage}"

  if rm -rf /tmp/*; then
    EchoLog ok "${lang_cleanupall_cleantempfolder}"
  else
    EchoLog error "${lang_cleanupall_cleantempfolder}"
    return 1
  fi

  sleep 2
  
  if history -c && history -w; then
    EchoLog ok "${lang_cleanupall_historydata}"
  else
    EchoLog error "${lang_cleanupall_historydata}"
    return 1
  fi

  sleep 3
  return 0
}

################################
##    S Y S T E M  W O R K    ##
################################
function UpdateAndUpgrade() {
  # This function performs a complete system update of the server
  # ----------
  # Call with: UpdateAndUpgrade
  # ----------
  {
    echo -e "XXX\n12\n$lang_updateupgrade_execmessage\nXXX"
    if ! apt-get update 2>&1 >/dev/null; then return 1; fi
    echo -e "XXX\n35\n$lang_updateupgrade_execmessage\nXXX"
    if ! apt-get upgrade -y 2>&1 >/dev/null; then return 1; fi
    echo -e "XXX\n51\n$lang_updateupgrade_execmessage\nXXX"
    if ! apt-get dist-upgrade -y 2>&1 >/dev/null; then return 1; fi
    echo -e "XXX\n74\n$lang_updateupgrade_execmessage\nXXX"
    if ! apt-get autoremove -y 2>&1 >/dev/null; then return 1; fi
    echo -e "XXX\n98\n$lang_updateupgrade_execmessage\nXXX"
  } | whiptail --gauge --backtitle "${var_whipbacktitle}" --title " ${lang_updateupgrade_title^^} " "\n${lang_updateupgrade_mainmessage}" 10 80 0
  
  return 0
}

function BackupAndRestoreFile() {
  # This function creates a file backup and can also restore it
  # ----------
  # Call with: BackupAndRestoreFile backup "path/to/file/filename.ext"    >> Delete Backupfile if exists
  # Call with: BackupAndRestoreFile restore "path/to/file/filename.ext"   >> Delete Backupfile after restore
  # ----------
  file=$2

  if [[ "${1}" == "backup" ]]; then
    if [ -f "${file}.bak" ]; then
      if ! rm -f "${file}.bak"; then return 1; fi
    fi
    if cp "${file}" "${file}.bak" 2>&1 >/dev/null; then
      EchoLog info "${lang_backupandrestorefile_file} ${file} ${lang_backupandrestorefile_bakupfile} ${file}.bak"
      return 0
    else
      return 1
    fi    
  elif [[ "${1}" == "restore" ]]; then
    if [ -f "${file}.bak" ]; then
      if ! rm -f "${file}" 2>&1 >/dev/null; then return 1; fi
      if cp "${file}.bak" "${file}" 2>&1 >/dev/null; then
        EchoLog info "${lang_backupandrestorefile_file} ${file}.bak ${lang_backupandrestorefile_restorefile} ${file}"
        if rm "${file}.bak" 2>&1 >/dev/null; then
          EchoLog info "${lang_backupandrestorefile_deletebakfile} ${file}.bak"
        else
          return 1
        fi
        return 0
      else
        return 1
      fi
    else
      EchoLog error "${lang_backupandrestorefile_nobakfile}"
      return 1
    fi
  fi
}

function CheckPackage() {
  # This function checks if a software package is installed
  # ----------
  # Call with: CheckPackage "package"
  # ----------
  if [ $(dpkg-query -W -f='${Status}' "${1}" 2>/dev/null | grep -c "ok installed") -eq 1 ]; then
    return 0
  else
    return 1
  fi
}

################################
## W H I P T A I L  B O X E S ##
################################
NormalColorFile="/root/.iThielers_NEWT_COLORS"
AlertColorFile="/root/.iThielers_NEWT_COLORS_ALERT"
function WhipMessage() {
  # give an whiptail message box
  # ----------
  # Call with: WhipMessage "title" "message"
  # ----------
  whiptail --msgbox --ok-button " ${lang_btn_ok^^} " --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80
}

function AlertWhipMessage() {
  # give an whiptail message box with Alert colors
  # ----------
  # Call with: AlertWhipMessage "title" "message"
  # ----------
  NEWT_COLORS_FILE=$AlertColorFile \
  whiptail --msgbox --ok-button " ${lang_btn_ok^^} " --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80
}

function WhipYesNo() {
  # give a whiptail question box
  # ----------
  # Call with: WhipYesNo "btn1" "btn2" "title" "message"    >> btn1 = true  btn2 = false
  # ----------
  whiptail --yesno --yes-button " ${1^^} " --no-button " ${2^^} " --backtitle "${var_whipbacktitle}" --title " ${3^^} " "\n${4}" 0 80
  yesno=$?
  if [ ${yesno} -eq 0 ]; then true; else false; fi
}

function AlertWhipYesNo() {
  # give a whiptail question box with Alert colors
  # ----------
  # Call with: AlertWhipYesNo "btn1" "btn2" "title" "message"    >> btn1 = true  btn2 = false
  # ----------
  NEWT_COLORS_FILE=~/.iThielers_NEWT_COLORS_ALERT \
  whiptail --yesno --yes-button " ${1^^} " --no-button " ${2^^} " --backtitle "${var_whipbacktitle}" --title " ${3^^} " "${4}" 0 80
  yesno=$?
  if [ ${yesno} -eq 0 ]; then EchoLog r "${4} ${var_color_blue}${1}${var_color_nc}"; else EchoLog r "${4} ${var_color_blue}${2}${var_color_nc}"; fi
  if [ ${yesno} -eq 0 ]; then true; else false; fi
}

function WhipInputbox() {
  # give a whiptail box with input field
  # ----------
  # Call with: WhipInputbox "title" "message" "default value"   >> default value is optional
  # ----------
  input=$(whiptail --inputbox --ok-button " ${lang_btn_ok^^} " --nocancel --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80 "${3}" 3>&1 1>&2 2>&3)
  if [[ $input == "" ]]; then
    WhipInputbox "$1" "$2\n\n!!! ${lang_txt_noinput} !!!" "${3}"
  else
    echo "${input}"
  fi
}

function AlertWhipInputbox() {
  # give a whiptail box with input field and Alert colors
  # ----------
  # Call with: AlertWhipInputbox "title" "message" "default value"   >> default value is optional
  # ----------
  NEWT_COLORS_FILE=~/.iThielers_NEWT_COLORS_ALERT \
  input=$(whiptail --inputbox --ok-button " ${lang_btn_ok^^} " --nocancel --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80 "${3}" 3>&1 1>&2 2>&3)
  if [[ $input == "" ]]; then
    AlertWhipInputbox "$1" "$2\n\n!!! ${lang_txt_noinput} !!!" "${3}"
  else
    echo "${input}"
  fi
}

function WhipInputboxWithCancel() {
  # give a whiptail box with input field and cancel button
  # ----------
  # Call with: WhipInputboxWithCancel "title" "message" "default value"   >> default value is optional
  # ----------
  input=$(whiptail --inputbox --ok-button " ${lang_btn_ok^^} " --cancel-button " ${lang_btn_cancel^^} " --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80 "${3}" 3>&1 1>&2 2>&3)
  if [ $? -eq 1 ]; then
    echo cancel
  else
    if [[ $input == "" ]]; then
      WhipInputboxWithCancel "$1" "$2\n\n!!! ${lang_txt_noinput} !!!" "$3"
    else
      echo "${input}"
    fi
  fi
}

function AlertWhipInputboxWithCancel() {
  # give a whiptail box with input field and cancel button
  # ----------
  # Call with: AlertWhipInputboxWithCancel "title" "message" "default value"   >> default value is optional
  # ----------
  NEWT_COLORS_FILE=~/.iThielers_NEWT_COLORS_ALERT \
  input=$(whiptail --inputbox --ok-button " ${lang_btn_ok^^} " --cancel-button " ${lang_btn_cancel^^} " --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80 "${3}" 3>&1 1>&2 2>&3)
  if [ $? -eq 1 ]; then
    echo cancel
  else
    if [[ $input == "" ]]; then
      AlertWhipInputboxWithCancel "$1" "$2\n\n!!! ${lang_txt_noinput} !!!" "$3"
    else
      echo "${input}"
    fi
  fi
}

function WhipInputboxPassword() {
  # give a whiptail box with input field for passwords
  # ----------
  # Call with: WhipInputboxPassword "title" "message"
  # ----------
  input=$(whiptail --passwordbox --ok-button " ${lang_btn_ok^^} " --nocancel --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 8 80 "" 3>&1 1>&2 2>&3)
  if [[ "$input" == "" ]]; then
    # If Inputfield is empty
    WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${1}" "${lang_txt_noinput}\n\n${lang_txt_autogeneratepassword}"
    if [ $? -eq 0 ]; then
      input=$(GeneratePassword 27)
      WhipMessage "${1}" "${lang_txt_autogeneratepasswordis}\n\n${input}"
      echo "${input}"
    else
      WhipInputboxPassword "$1" "$2\n\n!!! ${lang_txt_noinput} !!!"
    fi
  else
    pattern=" |'"
    if [[ "$input" =~ $pattern ]]; then
      WhipInputboxPassword "$1" "$2\n\n!!! ${lang_txt_foundspaces} !!!"
    else
      echo "${input}"
    fi
  fi
}

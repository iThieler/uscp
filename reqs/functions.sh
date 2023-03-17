#!/bin/bash

################################
## W H I P T A I L  B O X E S ##
################################
NormalColorFile="/root/.iThielers_NEWT_COLORS"
AlertColorFile="/root/.iThielers_NEWT_COLORS_ALERT"
function WhipMessage() {
  # give an whiptail message box
  # Call with: WhipMessage "title" "message"
  whiptail --msgbox --ok-button " ${lang_btn_ok^^} " --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80
  echoLOG b "${2}"
}

function AlertWhipMessage() {
  # give an whiptail message box with Alert colors
  # Call with: AlertWhipMessage "title" "message"
  NEWT_COLORS_FILE=$AlertColorFile \
  whiptail --msgbox --ok-button " ${lang_btn_ok^^} " --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80
  echoLOG r "${2}"
}

function WhipYesNo() {
  # give a whiptail question box
  # Call with: WhipYesNo "btn1" "btn2" "title" "message"    >> btn1 = true  btn2 = false
  whiptail --yesno --yes-button " ${1^^} " --no-button " ${2^^} " --backtitle "${var_whipbacktitle}" --title " ${3^^} " "\n${4}" 0 80
  yesno=$?
  if [ ${yesno} -eq 0 ]; then true; else false; fi
}

function AlertWhipYesNo() {
  # give a whiptail question box with Alert colors
  # Call with: AlertWhipYesNo "btn1" "btn2" "title" "message"    >> btn1 = true  btn2 = false
  NEWT_COLORS_FILE=~/.iThielers_NEWT_COLORS_ALERT \
  whiptail --yesno --yes-button " ${1^^} " --no-button " ${2^^} " --backtitle "${var_whipbacktitle}" --title " ${3^^} " "${4}" 0 80
  yesno=$?
  if [ ${yesno} -eq 0 ]; then echoLOG r "${4} ${var_color_blue}${1}${var_color_nc}"; else echoLOG r "${4} ${var_color_blue}${2}${var_color_nc}"; fi
  if [ ${yesno} -eq 0 ]; then true; else false; fi
}

function WhipInputbox() {
  # give a whiptail box with input field
  # Call with: WhipInputbox "title" "message" "default value"   >> default value is optional
  input=$(whiptail --inputbox --ok-button " ${lang_btn_ok^^} " --nocancel --backtitle "${var_whipbacktitle}" --title " ${1^^} " "\n${2}" 0 80 "${3}" 3>&1 1>&2 2>&3)
  if [[ $input == "" ]]; then
    WhipInputbox "$1" "$2\n\n!!! ${lang_txt_noinput} !!!" "${3}"
  else
    echo "${input}"
  fi
}

function AlertWhipInputbox() {
  # give a whiptail box with input field and Alert colors
  # Call with: AlertWhipInputbox "title" "message" "default value"   >> default value is optional
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
  # Call with: WhipInputboxWithCancel "title" "message" "default value"   >> default value is optional
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
  # Call with: AlertWhipInputboxWithCancel "title" "message" "default value"   >> default value is optional
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
  # Call with: WhipInputboxPassword "title" "message"
  input=$(whiptail --passwordbox --ok-button " ${lang_btn_ok^^} " --nocancel --backtitle "${var_whipbacktitle}" --title " ${1} " "\n${2}" 0 80 3>&1 1>&2 2>&3)
  if [[ "$input" == "" ]]; then
    # If Inputfield is empty
    WhipYesNo "${lang_btn_yes}" "${lang_btn_no}" "${1}" "${lang_txt_noinput}\n\n${lang_txt_autogeneratepassword}"
    if [ $? -eq 0 ]; then
      input=$(GeneratePassword 26)
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

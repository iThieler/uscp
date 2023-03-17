#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/iThieler/uscp/main/reqs/functions.sh)
source <(curl -s https://raw.githubusercontent.com/iThieler/uscp/main/reqs/variables.sh)
langlist=$(curl -s ${var_githubraw}/main/lang/list)
language=$(whiptail --menu --nocancel --backtitle "${var_whipbacktitle}" "\nSelect your Language" 20 80 10 "${langlist[@]}" 3>&1 1>&2 2>&3)




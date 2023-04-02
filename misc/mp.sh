#!/bin/bash
# Load functions/updates and strt this script
source <(curl -s ${var_githubraw}/main/reqs/functions.sh)
source <(curl -s ${var_githubraw}/main/lang/${language}.sh)
if [ -f "$var_answerfile" ]; then source "$var_answerfile"; fi
echo; MailcowLogo; echo

if ! CheckDNS "${FullName}"; then exit 1; fi

exit 0

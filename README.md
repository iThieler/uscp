<h1 align="center" id="heading">Ultimate Server Configuration Panel</h1>

<p align="center"><sub> Always remember to use due diligence when sourcing scripts and automation tasks from third-party sites. Primarily, I created this script to make setting up Servers easier and also faster for me. If you want to use a script, do it. </sub></p>

<p align="center">
  <a href="https://github.com/iThieler/uscp/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" ></a>
  <a href="https://github.com/iThieler/iThieler/discussions"><img src="https://img.shields.io/badge/%F0%9F%92%AC-Discussions-orange" /></a>
  <a href="https://github.com/iThieler/uscp/blob/master/CHANGELOG.md"><img src="https://img.shields.io/badge/🔶-Changelog-blue" /></a>
  <a href="https://ko-fi.com/U7U3FUTLF"><img src="https://img.shields.io/badge/%E2%98%95-Buy%20me%20a%20coffee-red" /></a>
</p><br><br>

<p align="center"><img src="https://github.com/iThieler/ithieler/blob/master/uscs_logo.png?raw=true" height="100"/></p>

This multilingual script takes care of the startup tasks after installing a new server. What is done?
- Set the timezone to Europe/Berlin (no user interaction yet)
- Set the server name
- Installs and configures Postfix as MTA
- Performs a full systemupdate and upgrade
- Installs basic software if not available
  - fail2ban
  - curl
  - snapd
  - git
  - apticron (notifies when updates are available)
  - parted
  - smartmontools
  - mailutils
- Configuration of a server role
  - Docker Host with Proxy (NGINX Proxy MAnager and traefik)
  - E-Mailserver (Mailcow docerized)
  - E-Mailarchive (Mailpiler)
  - TP-Link SDN (Omada Software Controller)
  - Web server (NGINX) with certbot for Let's Encrypt
 
Run the following in the Shell after a fresh setup. ⚠️ **DEBIAN 11/12 and Ubuntu 20.04/22.04 ONLY**

```bash
bash <(curl -s https://raw.githubusercontent.com/iThieler/uscp/main/begin.sh)
```

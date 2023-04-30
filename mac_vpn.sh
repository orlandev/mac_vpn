#!/bin/sh
MACCHANGER="macchanger"
MAC_FILE_NAME="./mac_save.mc"

if ! command -v ${MACCHANGER} >/dev/null; then
  echo "This script requires ${MACCHANGER} to be installed and on your PATH ..."
  echo "Install ${MACCHANGER} using:"
  echo "- brew update"
  echo "- brew install acrogenesis/macchanger/macchanger"
  exit 1
fi

echo "[ OK ] ${MACCHANGER} INSTALLED"
echo ""


if [ -z "$1" ]; then
  echo "MacVPN - Changer - For Inmersoft Network"
  echo "Use: mac_vpn [ tunnel ] [ device ]"
  echo "tunnel: "
  echo "        - PORTAL:     p"
  echo "        - VPN:        v"
  echo "        - FULL:       f"
  echo "        - ORIGINAL:   o"
  echo ""
  echo "device: "
  echo "      - eth0"
  echo "      - en0"
  echo "      - en1"
  echo "      - wifi0"
  echo "You can see your device executing ifconfig"
  echo "Example:  mac_vpn f en0 -> Set the mac to use FULL Tunnel in the en0 device"
  echo ""
  echo "How regenerate teh mac addresses:"
  echo "Use: mac_vpn.sh r"
  echo ""
  echo "File with Mac addresses:"
  echo ""
  echo "How use the mac addresses generated"
  echo "The script will create a file with three new random mac address values and add them to a file called mac_saved.mc."
  echo "You must take these three mac values and add them to the microtik configuration, one for each of the tunnels used;"
  echo "For example, the first for the PORTAL tunnel, the second for the VPN tunnel and the last for the FULL tunnel."
  echo ""
  exit 1
fi

if [ -z "$2" ]; then
  echo "You need specify the device, example en0, eth0,"
  exit 1
fi


# shellcheck disable=SC2039
if [[ ! -f $MAC_FILE_NAME ]]; then
  echo "Generating new random mac addresses..."

  echo "[ AUTO GENERATED ] Do not delete this file." >$MAC_FILE_NAME

  # shellcheck disable=SC2216
  # shellcheck disable=SC2129
  hexdump -n3 -e'/3 "14:98:77" 3/1 ":%02X"' /dev/random >>${MAC_FILE_NAME} | echo >>${MAC_FILE_NAME}
  # shellcheck disable=SC2216
  hexdump -n3 -e'/3 "14:98:77" 3/1 ":%02X"' /dev/random >>${MAC_FILE_NAME} | echo >>${MAC_FILE_NAME}
  # shellcheck disable=SC2216
  hexdump -n3 -e'/3 "14:98:77" 3/1 ":%02X"' /dev/random >>${MAC_FILE_NAME} | echo >>${MAC_FILE_NAME}

 #Save the original MacAdress
 # shellcheck disable=SC2216
 ifconfig "$2" | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' >> ${MAC_FILE_NAME} | echo >>${MAC_FILE_NAME}

  echo "[ OK ] - Mac addresses"
  echo ""
  echo "Use these mac addresses in the company microtik settings."

  portal_mac=$(sed '3!d' ${MAC_FILE_NAME})
  vpn_mac=$(sed '4!d' ${MAC_FILE_NAME})
  full=$(sed '5!d' ${MAC_FILE_NAME})

  echo "PORTAL: $portal_mac"
  echo "VPN:    $vpn_mac"
  echo "FULL:   $full"
fi


#My original MAC 14:98:77:71:a1:a6


if [ "$1" == "p" ]; then
  portal_mac=$(sed '3!d' ${MAC_FILE_NAME})
  echo "Setting PORTAL mac address: $portal_mac in $2"
  macchanger -m "$portal_mac" "$2"
  exit 0
fi
if [ "$1" == "v" ]; then

  vpn_mac=$(sed '4!d' ${MAC_FILE_NAME})
  echo "Setting VPN mac address: $vpn_mac in $2"
  macchanger -m "$vpn_mac" "$2"
  exit 0
fi
if [ "$1" == "f" ]; then
  full=$(sed '5!d' ${MAC_FILE_NAME})
  echo "Setting FULL mac address: $full in $2"
  macchanger -m "$full" "$2"
  exit 0
fi
if [ "$1" == "o" ]; then
  full=$(sed '6!d' ${MAC_FILE_NAME})
  echo "Setting ORIGINAL mac address: $full in $2"
  macchanger -m "$full" "$2"
  exit 0
fi

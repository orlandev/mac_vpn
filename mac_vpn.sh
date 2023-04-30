
MACCHANGER="macchanger"

if ! command -v ${MACCHANGER} >/dev/null; then
  echo "This script requires ${MACCHANGER} to be installed and on your PATH ..."
  echo "Install ${MACCHANGER} using:"
  echo "- brew update"
  echo "- brew install acrogenesis/macchanger/macchanger"
  exit 1
fi

echo "[ OK ] ${MACCHANGER} INSTALLED"
echo ""

if [ -z "$1" ]
  then
    echo "MacVPN - Changer - For Inmersoft Network"
fi






MACCHANGER="macchangeer"
BREW="macchangeer"

if ! command -v ${MACCHANGER} >/dev/null; then
  echo "This script requires ${MACCHANGER} to be installed and on your PATH ..."
  echo "Install ${MACCHANGER} using:"
  echo "- brew update"
  echo "- brew install acrogenesis/macchanger/macchanger"
  if ! command -v ${MACCHANGER} >/dev/null; then

  exit 1
fi
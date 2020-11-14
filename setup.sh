#!/bin/bash
set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)

case $( uname -s ) in
  Darwin|Linux) bash install.sh;;
  *)      echo "This is non supported Distribution." ; exit 1;;
esac

exit 0

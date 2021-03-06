#!/bin/bash
##############################################################################
###              _   _
###  _   _ _ __ | |_(_)_ __ ___   ___ _ __
### | | | | '_ \| __| | '_ ` _ \ / _ \ '__|
### | |_| | |_) | |_| | | | | | |  __/ |
###  \__,_| .__/ \__|_|_| |_| |_|\___|_|
###       |_|
###
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  2012-2016 Knut Kohl
### @license    MIT License (MIT) http://opensource.org/licenses/MIT
### @version    1.0.0
##############################################################################
pwd=$(dirname $0)

APIURL=https://api.pushover.net/1/messages.json

: ${CURL:=$(which curl)}
[ "$CURL" ] || usage 127 'ERROR: Missing curl binary'

: ${NC:=$(which nc)}
[ "$CURL" ] || usage 127 'ERROR: Missing netcat binary'

function usage {

    [ "$2" ] && echo && echo $2

    echo
    echo "Usage: $0 <config file>"
    echo

    exit $1
}

CONFIG=$1

[ -z "$CONFIG" ] && usage 1 'Missing config file'
[ ! -r "$CONFIG" ] && usage 2 'Invalid config file'

. "$CONFIG"

[ "$USER" ]    || usage 3 'ERROR: Missing user token'
[ "$TOKEN" ]   || usage 4 'ERROR: Missing application token'
[ "$HOST" ]    || usage 4 'ERROR: Missing host(s)'
[ "$MESSAGE" ] || usage 5 'ERROR: Missing message'

HOSTS=$(echo $HOST | sed 's/,/ /g')
PORTS=$(echo ${PORT:-80} | sed 's/,/ /g')

### Initialise loop variable
HOST=

for HOST in $HOSTS; do

    ### Initialise loop variable
    PORT=

    for PORT in $PORTS; do

        $NC -zw 5 $HOST $PORT;

        [ $? -eq 0 ] && continue

        eval MESSAGE="\"$MESSAGE\""

        echo [$(date +'%F %T')] $MESSAGE

        $CURL --silent \
              --form-string user="$USER" --form-string token="$TOKEN" \
              --form-string device="$DEVICE" --form-string title="$TITLE" \
              --form-string message="$MESSAGE" --form-string html=${HTML:-0} \
              --form-string url="$URL" --form-string url_title="$URLTITLE" \
              --form-string priority=${PRIORITY:-0} \
              --form-string sound=${SOUND:-pushover} \
              --form-string timestamp=$(date +%s) $APIURL >/dev/null

    done
done

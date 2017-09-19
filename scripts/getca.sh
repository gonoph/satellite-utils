#!/bin/bash
# Copyright 2015, 2017 Billy Holmes
# This file is part of Satellite-Utils.
# Foobar is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

host=$1
port=$2

: ${port:=443}
: ${host:=localhost}

## this command does the following:
# echo - force the webserver to end it's conversation with us
# openssl s_client - start openssl in client mode
# + showcerts - show all the certs in the chain - even the self signed one
# + servername - give the server name in case of SNI (shared SSL)
# + connect - the host and port to connect
# sed - -n means to suppress output
# + 1st - APPEND the edges of BEGIN and END cert pem format into the hold space
# + 2nd - on the ssl "issuer" line, REPLACE the hold space with that line,
# ++ - then swap the hold and pattern space, then delete the pattern space
# + 3rd - on the last END line, swap the pattern and hold space, then replace
# ++ new lines with % to make it one long line, then print it and start again.
# while - read in the CERT as one line
# + convert % back to new lines
# + pipe through openssl to make it pretty again
##### why?
# If the server response with a long list of certs, the last cert will be the
# CA cert. We use OpenSSL to extract the cert for us, and finally print it
# in a pretty format.
##
echo | openssl s_client -showcerts -servername $host -connect $host:$port 2>/dev/null | \
sed -n \
-e '/^-----BEGIN CERTIFICATE/,/^-----END CERTIFICATE/{H;}' \
-e '/^   i:/{h;x;d;}' \
-e '/^-----END CERTIFICATE/{x;s/\n/%/g;p;d;}' | 
tail -n +2 | while read CERT ; do
  CERT=$(tr '%' '\n' <<< "$CERT")
  openssl x509 -issuer -subject -dates <<< "$CERT"
done

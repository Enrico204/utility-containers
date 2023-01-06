#!/bin/sh

if [ "$RPCHOST" != "" ]; then
    sed -i "s|host: location.protocol.startsWith(\"http\") ? location.hostname : \"localhost\"|host: \"$RPCHOST\"|" /usr/share/caddy/app.js
fi

if [ "$RPCSECRET" != "" ]; then
    sed -i "s|auth: {},|auth: {token: \"$RPCSECRET\"},|" /usr/share/caddy/app.js
fi

if [ "$RPCDIRECT" != "" ]; then
    sed -i "s|directURL: \"\"|directURL: \"$RPCDIRECT\"|" /usr/share/caddy/app.js
fi

exec "$@"
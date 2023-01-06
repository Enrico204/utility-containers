#!/bin/sh

if [ "$RPCSECRET" == "" ]; then
    echo "RPCSECRET variable missing"
    exit 1
fi

exec aria2c --enable-rpc --rpc-listen-all "--rpc-secret=$RPCSECRET" --dir=/storage --log=-

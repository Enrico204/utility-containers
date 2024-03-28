#!/usr/bin/env bash
shopt -s expand_aliases
alias snort="snort -c $HOME/snort3/etc/snort/snort.lua"

cmd="snort -q --talos -r get.pcap"

echo "running:"
echo "$cmd"

eval $cmd


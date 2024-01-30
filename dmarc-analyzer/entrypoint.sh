#!/usr/bin/env bash
set -eou pipefail

if [ ! -e "/cfg/config.yaml" ]; then
    mkdir -p /cfg

    if [ "${IMAP_SERVER:-}" == "" ]; then
        echo "Specify IMAP_SERVER environment variable"
        exit 1
    fi

    if [ "${IMAP_USER:-}" == "" ]; then
        echo "Specify IMAP_USER environment variable"
        exit 1
    fi

    if [ "${IMAP_PASS:-}" == "" ]; then
        echo "Specify IMAP_PASS environment variable"
        exit 1
    fi
    IMAP_MBOX=${IMAP_MBOX:-INBOX}

    cat > /cfg/config.yaml <<EOF
input:
  delete: yes
  dir: "/tmp/dmarc_files/"
  imap:
   server: "$IMAP_SERVER"
   username: "$IMAP_USER"
   password: "$IMAP_PASS"
   mailbox: "$IMAP_MBOX"
   delete: yes

output:
  file: "/out/html/{{ .ID }}.html"
  format: "html_static"

lookup_addr: yes

merge_reports: no

log_debug: no
log_datetime: no
EOF

    SCHEDULE=${SCHEDULE:-"0 0 * * *"}
    cat > /cfg/crontab <<EOF
$SCHEDULE /usr/local/bin/dmarc-report-converter -config /cfg/config.yaml
EOF
fi

if [ "$#" -gt 0 ]; then
    # If arguments are provided, execute the command
    exec "$@"
else
    exec /usr/local/bin/supercronic /cfg/crontab
fi

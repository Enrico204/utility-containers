#!/bin/bash

if [ "$VNCPASS" == "" ]; then
    echo "Please set a password using VNCPASS env variable (optionally, you can set a viewonly password using VIEWONLYPASS)"
    exit 1
fi

if [ "$FFURL" == "" ]; then
    echo "Please set a URL to open using FFURL env variable"
    exit 1
fi

if [ "$GEOM" == "" ]; then
    GEOM=1024x768
fi

# Setup VNC password
mkdir -p "$HOME/.vnc/"
if [ "$VIEWONLYPASS" == "" ]; then
    echo -e "$VNCPASS" | tigervncpasswd -f > "$HOME/.vnc/passwd"
else
    echo -e "$VNCPASS\n$VIEWONLYPASS" | tigervncpasswd -f > "$HOME/.vnc/passwd"
fi
chmod 0600 "$HOME/.vnc/passwd"

# Start VNC server
tigervncserver :0 -rfbport 5900 -localhost no -geometry "$GEOM" -xstartup $(which dwm.hidebar) -AlwaysShared

# Start Firefox in kiosk mode
export DISPLAY=:0
firefox --kiosk "$FFURL"

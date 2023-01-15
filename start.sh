#!/bin/bash
set -e 

SERVER_SETTINGS="$SETTINGS_DIR/$SERVER_SETTINGS_FILE"
HOST_SETTINGS="$SETTINGS_DIR/$HOST_SETTINGS_FILE"
LOG_FILE="${LOGS}/${SERVER_LOG_FILE}"

if [[ ! -f "$LOG_FILE" ]]; then 
    touch "$LOG_FILE"
fi

if [[ ! -d "$SETTINGS_DIR" ]]; then 
   mkdir "$SETTINGS_DIR" 
fi

if [[ ! -d "$SAVES_DIR" ]]; then 
    mkdir "$SAVES_DIR"
fi 

if [[ ! -f "$SERVER_SETTINGS" ]]; then
    echo "Copy default server settings"
    cp  "$DEFAULT_SETTINGS_DIR/$SERVER_SETTINGS_FILE" "$SERVER_SETTINGS"
fi 

if [[ ! -f "$HOST_SETTINGS" ]]; then 
    echo "Copy default host settings"
    cp "$DEFAULT_SETTINGS_DIR/$HOST_SETTINGS_FILE" "$HOST_SETTINGS"
fi

touch "$SETTINGS_DIR/adminlist.txt" "$SETTINGS_DIR/banlist.txt"

if [[ -f "/tmp/.X0-lock" ]]; then 
    rm /tmp/.X0-lock
fi 

echo "Start Xvfb"
Xvfb :0 -screen 0 1024x768x24 -nolisten tcp -nolisten unix &
echo "Start VRising"
DISPLAY=:0.0 wine "$SERVER/VRisingServer.exe" -persistentDataPath "$DATA" -logFile "$LOG_FILE" &> ${LOGS}/wine.log & 
tail -f "$LOG_FILE" 
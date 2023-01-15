FROM cm2network/steamcmd:root
LABEL maintainer="code@pleikys.com"

ARG VCS_REF
ARG BUILD_DATE
ARG BUILD_VERSION

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-url="https://github.com/sigitas-plk/vrising-server"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.vcs-ref=$VCS_REF
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -v logs:/vrising/logs -v data:/vrising/persistentdata -p 9876:9876/udp -p 9877:9876/udp -d sigitaspl/vrising"

ENV APP_ID="1829350" \
    SERVER="/vrising/server" \
    LOGS="/vrising/logs" \
    DATA="/vrising/persistentdata" \
    SERVER_LOG_FILE="VRisingServer.log" \
    SERVER_SETTINGS_FILE="ServerGameSettings.json" \
    HOST_SETTINGS_FILE="ServerHostSettings.json"
ENV SETTINGS_DIR="${DATA}/Settings" \ 
    SAVES_DIR="${DATA}/Saves" \
    DEFAULT_SETTINGS_DIR="${SERVER}/VRisingServer_Data/StreamingAssets/Settings"    

RUN mkdir -p ${SERVER} ${LOGS} ${SETTINGS_DIR} ${SAVES_DIR}

COPY start.sh ${SERVER}/start.sh

RUN chown -R steam:steam ${SERVER} ${LOGS} ${DATA} && \
    chmod 755 ${SERVER}/start.sh

RUN apt update && \
    apt install --no-install-recommends -y xvfb wine && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* 

USER steam

ENV TZ="Europe/London" \
    WINEARCH=win64

RUN ./steamcmd.sh +force_install_dir ${SERVER}\
    +@sSteamCmdForcePlatformType windows \
    +login anonymous \
    app_info_update 1 \
    +app_update ${APP_ID} validate \
    +quit

RUN cp ${DEFAULT_SETTINGS_DIR}/* ${SETTINGS_DIR}/ && \
    touch "${LOGS}/${SERVER_LOG_FILE}"

WORKDIR ${SERVER}
CMD "${SERVER}/start.sh"
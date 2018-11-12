############################################################
# ARK Evolved Server DockerFile                            #
# WARNING: YOU PROBABLY DO NOT WANT TO DO THIS             #
#                                                          #
# Make sure you check out one-click setup Game Hosting     #
# options prior to considering this option.                #
#                                                          #
# Game Hosting Option: https://arkservers.io/              #
#                                                          #
# Based off instructions on:                               #
# - https://ark.gamepedia.com/Dedicated_Server_Setup       #
# - https://developer.valvesoftware.com/wiki/SteamCMD      #
#                                                          #
############################################################

FROM cm2network/steamcmd:latest
LABEL maintainer="dropbeardan (https://github.com/dropbeardan/ARK-Server)"

# Run SteamCMD and install latest ARK server data to /home/steam/servers/ark
# 376030 = Surival Evolved; 445400 = Survival of the Fittest (https://ark.gamepedia.com/Dedicated_Server_Setup)
RUN ./home/steam/steamcmd/steamcmd.sh \
  +login anonymous \
  +force_install_dir /home/steam/servers/ark-survival-evolved \
  +app_update 376030 validate \
  +quit

# Add config to server_start.sh
RUN { \
  echo '#! /bin/bash'; \
  echo './ShooterGameServer TheIsland?listen?SessionName=<server_name>?ServerPassword=<join_password>?ServerAdminPassword=<admin_password>-server -log'; \
  } > /home/steam/servers/ark/server_start.sh

# Convert server_start.sh to an executable
RUN chmod +x server_start.sh

# Set 
ENTRYPOINT ./home/steam/steamcmd/steamcmd.sh \
  +login anonymous \
  +force_install_dir /home/steam/servers/ark-survival-evolved \
  +app_update 376030 \
  +quit && \
  ./home/steam/servers/ark/server_start.sh

# Expose ports
EXPOSE 7777 7778 27015 27020
###########################################################
# Team Fortress 2 Game Server Image
# Debian Version
###########################################################

FROM debian:jessie

LABEL maintainer.author1="Sebastian May <sebastian.may@adesso.de>" \
      maintainer.author2="Patrick Selge <patrick.selge@adesso.de>" \
      version="1.0" \
      description="Team Fortress 2 Game Server"

# variables
ENV TF2_URL "http://media.steampowered.com/client/steamcmd_linux.tar.gz" 

# install dependencies 
RUN apt-get update && apt-get install -y\
    lib32gcc1 \
    curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/tf2

RUN curl -L ${TF2_URL} | tar xvz

COPY src/tf2_ds.txt .

RUN ./steamcmd.sh +runscript tf2_ds.txt

COPY src/server.cfg ./tf2/tf/cfg/

RUN dpkg --add-architecture i386
RUN apt-get update && \
	apt-get install -y libstdc++6:i386 libtinfo5:i386 \
  	libcurl3-gnutls:i386 libncurses5:i386 libgcc1:i386 libz1:i386 libncurses5:i386

RUN ln -s /opt/tf2/linux32 /root/.steam/sdk32

EXPOSE 27015
EXPOSE 27015/udp

CMD tf2/srcds_run -game tf +sv_pure 1 +sv_lan 1 +map ctf_2fort +maxplayers 24
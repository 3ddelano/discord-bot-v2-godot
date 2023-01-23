FROM alpine:latest

# Environment Variables
ENV GODOT_VERSION "3.4.5" # Version of Godot to download

# Updates and installs
RUN apk update
RUN apk add --no-cache bash
RUN apk add --no-cache wget
RUN apk add --no-cache git

# Allow this to run Godot
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk
RUN apk add --allow-untrusted glibc-2.35-r0.apk

# Download Godot, version is set from environment variables
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_server.64.zip \
    && mkdir ~/.cache \
    && mkdir -p ~/.config/godot \
    && unzip Godot_v${GODOT_VERSION}-stable_linux_server.64.zip \
    && mv Godot_v${GODOT_VERSION}-stable_linux_server.64 /usr/local/bin/godot \
    && rm -f Godot_v${GODOT_VERSION}-stable_linux_server.64.zip

# Make directory to run the app from and then run the app
RUN mkdir /godotapp
WORKDIR /godotapp

COPY . .
CMD godot --path .
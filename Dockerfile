FROM alpine:latest

ENV GODOT_VERSION 3.4.5

RUN apk update
RUN apk add --no-cache bash
RUN apk add --no-cache unzip
RUN apk add --no-cache wget

RUN wget --quiet https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk
RUN apk add --force-overwrite --allow-untrusted glibc-2.35-r0.apk

RUN wget --quiet https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip
RUN mkdir ~/.cache
RUN mkdir -p ~/.config/godot
RUN unzip Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip
RUN mv Godot_v${GODOT_VERSION}-stable_linux_headless.64 /usr/local/bin/godot
RUN rm -f Godot_v${GODOT_VERSION}-stable_linux_headless.64.zip

# Make directory to run the app from and then run the app
RUN mkdir /godotapp
WORKDIR /godotapp

COPY . .
CMD godot --path .
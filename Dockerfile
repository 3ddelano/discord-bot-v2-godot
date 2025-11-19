FROM ubuntu:24.04

ENV GODOT_VERSION="4.5.1-stable"

RUN apt-get update && apt-get install -y wget unzip

RUN wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.arm64.zip -O /tmp/godot.zip \
    && unzip /tmp/godot.zip -d /usr/local/bin/ \
    && rm /tmp/godot.zip \
    && mv /usr/local/bin/Godot_v${GODOT_VERSION}_linux.arm64 /usr/local/bin/godot \
    && chmod +x /usr/local/bin/godot

COPY . .

CMD ["godot", "--headless", "--path", "."]
FROM debian:bookworm-slim

ENV GODOT_VERSION 4.5.1
ENV GODOT_EXE_NAME Godot_v${GODOT_VERSION}-stable_linux.arm64

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}-stable/${GODOT_EXE_NAME}.zip
RUN mkdir ~/.cache
RUN mkdir -p ~/.config/godot
RUN unzip ${GODOT_EXE_NAME}.zip
RUN mv ${GODOT_EXE_NAME} /usr/local/bin/godot
RUN rm -f ${GODOT_EXE_NAME}.zip

WORKDIR /godotapp

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY . .

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["godot", "--headless", "--path", "."]
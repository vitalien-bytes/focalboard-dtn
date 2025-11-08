# Étape 1 : Build du serveur Focalboard
FROM golang:1.22 AS builder

WORKDIR /app
RUN apt-get update && apt-get install -y make git

# Clone du dépôt Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .
RUN make server-linux

# Étape 2 : Image finale plus légère
FROM debian:bullseye-slim

WORKDIR /opt/focalboard

# Copie du binaire et du dossier web
COPY --from=builder /app/bin/focalboard-server /bin/focalboard-server
COPY --from=builder /app/webapp /opt/focalboard/webapp

# Ajout du fichier de config (sera fourni par Render Secret File)
COPY config.json /opt/focalboard/config.json

EXPOSE 8000

CMD ["/bin/focalboard-server", "--config", "/opt/focalboard/config.json"]

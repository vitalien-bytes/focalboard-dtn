# Étape 1 : construire le serveur Focalboard
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Installer make et git
RUN apk add --no-cache make git

# Télécharger le code source de Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Compiler le serveur
RUN make server-linux

# Étape 2 : créer l'image finale
FROM alpine:latest

WORKDIR /opt/focalboard

# Copier le binaire compilé
COPY --from=builder /app/bin/focalboard-server ./bin/focalboard-server

# Copier la configuration (le fichier que tu as mis dans ton repo)
COPY ./config.json ./config/config.json

# Exposer le port utilisé par Render
EXPOSE 8000

# Démarrer le serveur
CMD ["./bin/focalboard-server", "--config", "./config/config.json"]

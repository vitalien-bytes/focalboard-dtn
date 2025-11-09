# Étape 1 : construire le serveur Focalboard
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Installer les dépendances
RUN apk add --no-cache make git nodejs npm

# Cloner le dépôt officiel de Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Construire uniquement le backend
RUN make server-linux

# Étape 2 : image finale allégée
FROM alpine:latest

WORKDIR /opt/focalboard

# Copier le binaire compilé
COPY --from=builder /app/bin/focalboard-server ./bin/focalboard-server

# Copier la configuration (depuis ton dépôt GitHub)
COPY ./config.json ./config.json

# Exposer le port pour Render
EXPOSE 8000

# Lancer le serveur avec ton fichier config
CMD ["./bin/focalboard-server", "--config", "./config.json"]

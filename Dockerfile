# Étape 1 : construire le serveur Focalboard
FROM golang:1.21-alpine AS builder

# Installer les dépendances nécessaires
RUN apk add --no-cache make git nodejs npm

# Définir le dossier de travail
WORKDIR /app

# Cloner le dépôt officiel Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Aller dans le dossier du serveur Go
WORKDIR /app/server

# Compiler le serveur
RUN go build -o focalboard-server main.go

# Étape 2 : créer l'image finale allégée
FROM alpine:latest

WORKDIR /opt/focalboard

# Copier le binaire depuis la première étape
COPY --from=builder /app/server/focalboard-server ./focalboard-server

# Copier le fichier de configuration (depuis ton dépôt GitHub)
COPY config.json ./config.json

# Exposer le port pour Render
EXPOSE 8000

# Lancer le serveur avec la config
CMD ["./focalboard-server", "--config", "./config.json"]

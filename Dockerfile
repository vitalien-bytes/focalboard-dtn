# Étape 1 : construire le serveur Focalboard
FROM golang:1.21-alpine AS builder

# Installer les dépendances nécessaires
RUN apk add --no-cache make git nodejs npm

# Dossier de travail principal
WORKDIR /app

# Cloner le dépôt officiel de Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Aller dans le dossier du serveur Go
WORKDIR /app/server

# Télécharger les dépendances Go
RUN go mod download

# ✅ Compiler le serveur depuis le bon dossier (le bon nom actuel)
RUN go build -v -o focalboard-server ./cmd/focalboard-server

# Étape 2 : créer l'image finale allégée
FROM alpine:latest

# Définir le dossier de travail
WORKDIR /opt/focalboard

# Copier le binaire compilé
COPY --from=builder /app/server/focalboard-server ./focalboard-server

# Copier la configuration
COPY config.json ./config.json

# Exposer le port 8000
EXPOSE 8000

# Lancer le serveur
CMD ["./focalboard-server", "--config", "./config.json"]

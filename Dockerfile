# Étape 1 : construire le serveur Focalboard
FROM golang:1.21-alpine AS builder

# Installer les dépendances nécessaires
RUN apk add --no-cache make git nodejs npm

# Définir le dossier de travail
WORKDIR /app

# Cloner le dépôt officiel de Focalboard
RUN git clone https://github.com/mattermost/focalboard.git .

# Aller dans le dossier du serveur Go (là où se trouve go.mod)
WORKDIR /app/server

# Télécharger les dépendances Go
RUN go mod download

# Compiler le serveur
RUN go build -o focalboard-server ./cmd/focalboard-server/main.go

# Étape 2 : créer l'image finale allégée
FROM alpine:latest

WORKDIR /opt/focalboard

# Copier le binaire compilé
COPY --from=builder /app/server/focalboard-server ./focalboard-server

# Copier la configuration depuis ton dépôt GitHub
COPY config.json ./config.json

# Exposer le port 8000 pour Render
EXPOSE 8000

# Lancer le serveur avec la config
CMD ["./focalboard-server", "--config", "./config.json"]

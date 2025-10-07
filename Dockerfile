# Image Node 22
FROM node:22-alpine

# Outils utiles pour certaines dépendances natives et git
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++ \
    bash \
    libc6-compat

# Dossier persistant où l'install déposera l'app
WORKDIR /data

# Port utilisé par l'UI d'installation et par l'app
EXPOSE 8080

# Pas d'ENTRYPOINT: on pilote via 'command' dans docker-compose

# Image Node 22
FROM node:22-alpine

# Outils utiles pour dépendances natives et git
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++ \
    bash \
    libc6-compat

# Variables npm et git pour des installs plus stables et verbeuses si besoin
ENV npm_config_loglevel=warn \
    npm_config_audit=false \
    npm_config_fund=false \
    NPM_CONFIG_FOREGROUND_SCRIPTS=true \
    GIT_TERMINAL_PROMPT=0

# Optionnel: passer un token pour éviter les rate limits GitHub pendant le build
# Utilise: docker build --build-arg GITHUB_TOKEN=ghp_xxx .
ARG GITHUB_TOKEN

# Installer l outil une fois pour toutes afin d éviter npx à chaque run
# Si GITHUB_TOKEN est fourni, on l injecte temporairement dans l URL git pendant l install,
# puis on nettoie la config. Note: le token peut apparaître dans l historique de layer.
RUN set -eux; \
    if [ -n "${GITHUB_TOKEN:-}" ]; then \
      git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"; \
    fi; \
    npm i -g github:adapt-security/at-utils@0.10.0; \
    if [ -n "${GITHUB_TOKEN:-}" ]; then \
      git config --global --unset-all url."https://${GITHUB_TOKEN}@github.com/".insteadof || true; \
    fi

# Dossier de travail persistant où l install déposera l app
WORKDIR /data

# Préparer les permissions quand on utilisera l utilisateur node
RUN mkdir -p /data && chown -R node:node /data

# Exposer le port utilisé par l UI d installation et par l app
EXPOSE 8080

# Passer en utilisateur non privilégié
USER node

# Pas d ENTRYPOINT: piloté via docker-compose command

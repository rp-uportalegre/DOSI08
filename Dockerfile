FROM node:24-alpine AS construcao
WORKDIR /src
COPY package.json ./
COPY site ./site
COPY scripts ./scripts
COPY tests ./tests
ARG VERSAO=local
RUN npm run check && npm test && VERSAO="$VERSAO" npm run build

FROM nginx:stable-alpine
ARG VERSAO=local
LABEL org.opencontainers.image.revision="$VERSAO"
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=construcao --chmod=755 /src/dist/ /usr/share/nginx/html/
HEALTHCHECK --interval=3s --timeout=2s --retries=10   CMD wget -q -O /dev/null http://127.0.0.1/versao.json || exit 1
EXPOSE 80

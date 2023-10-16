FROM node:18 as keycloakify_jar_builder

COPY ./package.json ./yarn.lock /opt/app/

WORKDIR /opt/app

RUN yarn install --frozen-lockfile

COPY ./ /opt/app/

RUN yarn build-keycloak-theme

FROM quay.io/keycloak/keycloak:21.1.2 as builder

WORKDIR /opt/keycloak

COPY --from=keycloakify_jar_builder /opt/app/build_keycloak/target/keycloakify-starter-keycloak-theme-4.7.3.jar /opt/keycloak/providers/

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:21.1.2
COPY --from=builder /opt/keycloak /opt/keycloak/

COPY ./import /opt/keycloak/data/import

ENV KC_HOSTNAME=localhost
EXPOSE 8080
ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev", "--import-realm"]
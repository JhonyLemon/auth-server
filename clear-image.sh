#!/usr/bin/env bash

docker stop auth-server

docker container rm auth-server || true

docker image rm custom-keycloak || true
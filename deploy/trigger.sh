#!/usr/bin/env bash

version=`cat VERSION`
curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "latest"}' -X POST https://registry.hub.docker.com/u/rabaco/nginx-php-fpm/trigger/${TRIGGER_TOKEN}/
curl -H "Content-Type: application/json" --data '{"source_type": "Tag", "source_name": "${version}"}' -X POST https://registry.hub.docker.com/u/rabaco/nginx-php-fpm/trigger/${TRIGGER_TOKEN}/
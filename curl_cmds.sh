#!/bin/bash

# run this on marathon master in /vagrant/
curl -i -H 'Content-Type: application/json' -d@tomcat-testapp.json localhost:8080/v2/apps

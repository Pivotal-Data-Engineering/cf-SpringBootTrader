#!/bin/bash

cf create-service p-circuit-breaker-dashboard standard circuit-breaker-dashboard
cf create-service p-service-registry standard discovery-service
cf create-service p-config-server standard config-server -c '{"git": { "uri": "https://github.com/cdelashmutt-pivotal/cf-SpringBootTrader-config", "cloneOnStart": "true" } }'
cf create-user-provided-service traderdb -p '{"locators": ["10.193.138.105[10000]","10.193.138.106[10000]"]}'

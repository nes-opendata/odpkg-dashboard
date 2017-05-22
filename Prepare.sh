#!/bin/sh

. ./odpkg.env

echo "setting production.yml"
sed -i -e"s|__WP_URL__|$WP_URL|g" ./dashboard/config/settings/production.yml
sed -i -e"s|__CKAN_URL__|$CKAN_URL|g" ./dashboard/config/settings/production.yml
sed -i -e"s|__GOOGLE_ANALYTICS_ID__|$DASHBOARD_GOOGLE_ANALYTICS_ID|g" ./dashboard/config/settings/production.yml
sed -i -e"s|__GOOGLE_MAP_KEY__|$GOOGLE_MAP_KEY|g" ./dashboard/config/settings/production.yml

echo "setting colors"
sed -i -e"s|0097E0|$MAIN_COLOR|ig" ./dashboard/app/assets/stylesheets/map.scss.erb
sed -i -e"s|58C5F9|$SUB_COLOR|ig" ./dashboard/app/assets/stylesheets/map.scss.erb
#!/bin/bash

set -eo pipefail
cd $META_APP_HOME
xcrun altool --upload-app -t ios -f build/GDPR-MetaApp.ipa -u "$APP_STORE_CONNECT_USERNAME" -p "$APP_STORE_CONNECT_PASSWORD" --verbose

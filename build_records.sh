#!/bin/bash
BUNDLE_PATH="/srv/app-dzgy-archive"

# Create BUNDLE_PATH directory if it does not exist
[ ! -d $BUNDLE_PATH ] && mkdir -p $BUNDLE_PATH || :

if [ -d "$BUNDLE_PATH" ]; then
	meteor build --server http://192.168.0.21/dzgy_archive --directory $BUNDLE_PATH --allow-superuser
	cd $BUNDLE_PATH/bundle/programs/server
	rm -rf node_modules
	rm -f npm-shrinkwrap.json
	npm install --registry https://registry.npm.taobao.org -d

else
	echo "!!!=> Failed to create bundle path: $BUNDLE_PATH"
fi
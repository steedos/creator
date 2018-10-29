set DB_SERVER=127.0.0.1
set MONGO_URL=mongodb://%DB_SERVER%/steedos
set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=creator_instances
REM set METEOR_PACKAGE_DIRS=C:\Users\steedos\Documents\meteor_temp_pgs\packages\
REM set ROOT_URL=http://127.0.0.1:5000
REM set ROOT_URL=http://192.168.0.195:5000/creator
set ROOT_URL=http://192.168.0.81:5000
REM meteor run --port 5000
set TOOL_NODE_FLAGS="--max-old-space-size=1800"
set SOCKET_IO_PORT=8080
meteor run --port 5000 --settings settings.json

set DB_SERVER=192.168.0.23
set MONGO_URL=mongodb://%DB_SERVER%/qhd201711091030
REM set MONGO_OPLOG_URL=mongodb://%DB_SERVER%/local
set MULTIPLE_INSTANCES_COLLECTION_NAME=creator_instances
set ROOT_URL=http://192.168.0.60:5000/creator
meteor run --port 5000
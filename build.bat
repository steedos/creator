
cd C:\Users\dell\Documents\GitHub\creator
meteor build --server https://cn.steedos.com/creator --directory C:/Code/Build/creator-build/
cd C:/Code/Build/creator-build/bundle/programs/server
rd /s /q node_modules
npm install --registry https://registry.npm.taobao.org -d

cd C:/Code/Build/creator-build/
pm2 restart pm2.json

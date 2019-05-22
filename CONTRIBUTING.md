# 开发指引

### 运行项目源码
- [安装Meteor](https://www.meteor.com/install)
- [安装yarn](https://yarnpkg.com/zh-Hant/)
- 将项目克隆到本地
- 执行 yarn ，安装依赖包。
- 进入项目文件夹，执行 meteor
- 使用浏览器访问 https://localhost:3000
- 点击创建企业，注册企业账户

### 编译并发布版本
- yarn run build (编译 creator)
- yarn run login (登录npm发布账户)
- 修改 .dist/package.json 中的版本号
- yarn run pub (发布到npm)

express = Npm.require('express');
router = express.Router();
path = Npm.require('path')
fs = Npm.require('fs')

WebApp.connectHandlers.use '/view/encapsulation/xml', (req, res, next) ->

    # // 实现文件下载 
    fileName = req?.query?.filename

    filePath = path.join(__meteor_bootstrap__.serverDir, "../../../export/encapsulation")

    fileAddress = path.join filePath, fileName

    stats = fs.statSync fileAddress

    if stats.isFile()
        res.setHeader("Content-type", "application/octet-stream")
        res.setHeader("Content-Disposition", "attachment;filename=" + encodeURI(fileName))
        fs.createReadStream(fileAddress).pipe(res);
    else
        res.end 404
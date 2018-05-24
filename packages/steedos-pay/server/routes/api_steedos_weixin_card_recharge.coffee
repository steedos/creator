import WXPay from '../lib/wxpay.js'
import util from '../lib/util.js'

JsonRoutes.add 'post', '/api/steedos/weixin/card/recharge', (req, res, next) ->
    try
        current_user_info = payManager.check_authorization(req, res)
        user_id = current_user_info._id

        body = req.body
        console.log 'body: ', body
        totalFee = body.totalFee

        sub_appid = req.headers['appid']
        spaceId = req.headers['x-space-id']

        check totalFee, Number
        check sub_appid, String
        check spaceId, String

        returnData = {}

        listprices = 0
        order_body = '会员充值'

        attach = {}
        attach.record_id = Creator.getCollection('billing_record')._makeNewID()

        sub_openid = ''
        current_user_info.services.weixin.openid.forEach (o) ->
            if not sub_openid and o.appid is sub_appid
                sub_openid = o._id

        sub_mch_id = '1504795791'

        wxpay = WXPay({
            appid: Meteor.settings.billing.appid,
            mch_id: Meteor.settings.billing.mch_id,
            partner_key: Meteor.settings.billing.partner_key #微信商户平台API密钥
        })

        orderData = {
            body: order_body,
            out_trade_no: moment().format('YYYYMMDDHHmmssSSS'),
            total_fee: totalFee,
            spbill_create_ip: '127.0.0.1',
            notify_url: Meteor.absoluteUrl() + 'api/steedos/weixin/card/recharge/notify',
            trade_type: 'JSAPI', # 小程序取值如下：JSAPI
            product_id: moment().format('YYYYMMDDHHmmssSSS'),
            attach: JSON.stringify(attach),
            sub_appid: sub_appid,
            sub_mch_id: sub_mch_id,
            sub_openid: sub_openid
        }

        console.log 'orderData: ', orderData

        result = wxpay.createUnifiedOrder(orderData, Meteor.bindEnvironment(((err, result) ->
                if err
                    console.error err.stack
                if result and result.return_code is 'SUCCESS' and result.result_code is 'SUCCESS'
                    obj = {
                        _id: attach.record_id
                        paid: false
                        info: result
                        total_fee: totalFee
                        owner: user_id
                        space: spaceId
                    }

                    Creator.getCollection('billing_record').insert(obj)

                    returnData.timeStamp = Math.floor(Date.now() / 1000) + ""
                    returnData.nonceStr = util.generateNonceString()
                    returnData.package = "prepay_id=#{result.prepay_id}"
                    returnData.paySign = wxpay.sign({
                        appId: sub_appid
                        timeStamp: returnData.timeStamp
                        nonceStr: returnData.nonceStr
                        package: returnData.package
                        signType: 'MD5'
                    })
                else
                    console.error result
            ), ()->
                console.log 'Failed to bind environment'
            )
        )

        JsonRoutes.sendResult res,
            code: 200
            data: returnData
    catch e
        console.error e.stack
        JsonRoutes.sendResult res,
            code: 200
            data: { errors: [ { errorMessage: e.message } ] }


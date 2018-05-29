import WXPay from '../lib/wxpay.js'
import util from '../lib/util.js'

JsonRoutes.add 'post', '/api/steedos/payway/weixin', (req, res, next) ->
    try
        current_user_info = payManager.check_authorization(req, res)
        user_id = current_user_info._id

        body = req.body
        totalFee = body.totalFee
        cardId = body.cardId

        sub_appid = req.headers['appid']

        check totalFee, Number
        check cardId, String
        check sub_appid, String

        card = Creator.getCollection('vip_card').findOne(cardId, { fields: { space: 1, store: 1 } })

        if not card
            throw new Meteor.Error('error', "未找到会员卡")

        store = Creator.getCollection('vip_store').findOne(card.store, { fields: { mch_id: 1 } })

        if not store
            throw new Meteor.Error('error', "未找到门店")

        # sub_mch_id = '1504795791'
        sub_mch_id = store.mch_id # 由于此字段非必填，所以当此字段值为空时 支付到steedos
        console.log 'sub_mch_id: ', sub_mch_id

        returnData = {}

        order_body = '店内消费'

        attach = {}
        attach.record_id = Creator.getCollection('billing_record')._makeNewID()
        attach.sub_mch_id = sub_mch_id

        sub_openid = ''
        current_user_info.services.weixin.openid.forEach (o) ->
            if not sub_openid and o.appid is sub_appid
                sub_openid = o._id

        out_trade_no = moment().format('YYYYMMDDHHmmssSSS')

        orderData = {
            body: order_body,
            out_trade_no: out_trade_no,
            total_fee: totalFee,
            spbill_create_ip: '127.0.0.1',
            notify_url: Meteor.absoluteUrl() + 'api/steedos/payway/weixin/notify',
            trade_type: 'JSAPI', # 小程序取值如下：JSAPI
            attach: JSON.stringify(attach)
        }

        if _.isEmpty(sub_mch_id)
            # 支付给普通商户
            wxpay = WXPay({
                appid: sub_appid, # 小程序ID
                mch_id: Meteor.settings.billing.normal_mch.mch_id,
                partner_key: Meteor.settings.billing.normal_mch.partner_key #微信商户平台API密钥
            })
            orderData.openid = sub_openid
        else
            # 支付给特约商户
            wxpay = WXPay({
                appid: Meteor.settings.billing.service_mch.appid, # 公众号ID
                mch_id: Meteor.settings.billing.service_mch.mch_id,
                partner_key: Meteor.settings.billing.service_mch.partner_key #微信商户平台API密钥
            })
            orderData.sub_appid = sub_appid
            orderData.sub_mch_id = sub_mch_id
            orderData.sub_openid = sub_openid

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
                        space: card.space
                        store: card.store
                        card: card._id
                        out_trade_no: out_trade_no
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


JsonRoutes.add 'post', '/api/steedos/payway/weixin/notify', (req, res, next) ->
	try
		body = ""
		req.on('data', (chunk)->
			body += chunk
		)
		req.on('end', Meteor.bindEnvironment((()->
				xml2js = Npm.require('xml2js')
				parser = new xml2js.Parser({ trim:true, explicitArray:false, explicitRoot:false })
				parser.parseString(body, (err, result) ->
						# 特别提醒：商户系统对于支付结果通知的内容一定要做签名验证,并校验返回的订单金额是否与商户侧的订单金额一致，防止数据泄漏导致出现“假通知”，造成资金损失
						attach = JSON.parse(result.attach)
						record_id = attach.record_id
						sub_mch_id = attach.sub_mch_id

						if _.isEmpty(sub_mch_id)
							# 支付给普通商户
							wxpay = WXPay({
								appid: Meteor.settings.billing.normal_mch.appid,
								mch_id: Meteor.settings.billing.normal_mch.mch_id,
								partner_key: Meteor.settings.billing.normal_mch.partner_key #微信商户平台API密钥
							})
						else
							# 支付给特约商户
							wxpay = WXPay({
								appid: Meteor.settings.billing.service_mch.appid,
								mch_id: Meteor.settings.billing.service_mch.mch_id,
								partner_key: Meteor.settings.billing.service_mch.partner_key #微信商户平台API密钥
							})

						billRecord = Creator.getCollection('billing_record').findOne(record_id)
						sign = wxpay.sign(_.clone(result))
						if billRecord and billRecord.total_fee is Number(result.total_fee) and sign is result.sign
							Creator.getCollection('billing_record').update({ _id: record_id }, { $set: { paid: true } })
							point = parseInt(billRecord.total_fee/100)
							Creator.getCollection('vip_card').update({ _id: billRecord.card }, { $inc: { points: point } })

						else
							console.error "recharge notify failed"

				)
			), (err)->
				console.error err.stack
				console.log 'Failed to bind environment'
			)
		)

	catch e
		console.error e.stack

	res.writeHead(200, {'Content-Type': 'application/xml'})
	res.end('<xml><return_code><![CDATA[SUCCESS]]></return_code></xml>')


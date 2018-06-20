Export2XML.encapsulation = (_id) ->
	# 档案记录
	record_obj = Creator.Collections["archive_wenshu"].findOne({'_id':_id})
	# 全宗
	fonds_obj = Creator.Collections["archive_fonds"].findOne({'_id':record_obj?.fonds_name})
	# 保管期限
	retention_obj = Creator.Collections["archive_retention"].findOne({'_id':record_obj?.retention_peroid})
	# 类别
	category_obj = Creator.Collections["archive_classification"].findOne({'_id':record_obj?.category_code})
	# 读取正文附件

	# 审计
	audit_list = Creator.Collections["archive_audit"].find({'action_administrative_records_id':record_obj?._id}).fetch()

	if record_obj
		# === 电子文件封装包 - 被签名对象 - 封装内容
		# 来源
		LY = {
			"档案馆名称": record_obj?.archives_name || "",
			"档案馆代码": record_obj?.archives_identifier || "",
			"全宗名称": fonds_obj?.name || "",
			"立档单位名称": record_obj?.fonds_constituting_unit_name || ""
		}
		# 档号
		DH = {
			"全宗号": fonds_obj?.code || "",
			"年度": record_obj?.year || "",
			"保管期限": retention_obj?.name || "",
			"机构": record_obj?.organizational_structure || "",
			"类别号": category_obj?.name || "",
			"页号": record_obj?.page_number || "",
			"保管卷号": record_obj?.file_number || "",
			"分类卷号": record_obj?.classification_number || "",
			"件号": record_obj?.item_number || ""
		}
		# 内容描述
		NRMS = {
			"题名": record_obj?.title || "",
			"并列题名": record_obj?.parallel_title || "",
			"说明题名文字": record_obj?.other_title_information || "",
			"附件题名": record_obj?.annex_title || "",
			"主题词": record_obj?.descriptor || "",
			"关键词": record_obj?.keyword || "",
			"人名": record_obj?.personal_name || "",
			"摘要": record_obj?.abstract || "",
			"文件编号": record_obj?.document_number || "",
			"责任者": record_obj?.author || "",
			"文件日期": record_obj?.document_date?.toISOString() || "",
			"起始日期": record_obj?.start_date?.toISOString() || "",
			"截止日期": record_obj?.closing_date?.toISOString() || "",
			"销毁日期": record_obj?.destroy_date?.toISOString() || "",
			"紧急程度": record_obj?.precedence || "",
			"主送": record_obj?.prinpipal_receiver || "",
			"抄送": record_obj?.other_receivers || "",
			"抄报": record_obj?.report || "",
			"密级": record_obj?.security_classification || "",
			"拟稿人": record_obj?.applicant_name || "",
			"拟稿单位": record_obj?.applicant_organization_name || "",
			"保密期限": record_obj?.secrecy_period || ""
		}
		# 形式特征
		XSTZ = {
			"文件组合类型": record_obj?.document_aggregation || "",
			"卷内文件数": record_obj?.total_number_of_items || "",
			"页数": record_obj?.total_number_of_pages || "",
			"文件类型": record_obj?.document_type || "",
			"文件状态": record_obj?.document_status || "",
			"语种": record_obj?.language || "",
			"电子档案生成方式": record_obj?.orignal_document_creation_way || "",
			"处理标志": record_obj?.produce_flag || "",
			"归档日期": record_obj?.archive_date?.toISOString() || "",
			"归档部门": record_obj?.archive_dept || ""
		}
		# 存储位置
		CCWZ = {
			"当前位置": record_obj?.current_location || "",
			"脱机载体编号": record_obj?.offline_medium_identifier || "",
			"脱机载体存址": record_obj?.offline_medium_storage_location || ""
		}
		# 权限管理
		QXGL = {
			"知识产权说明": record_obj?.intelligent_property_statement || "",
			"授权对象": record_obj?.authorized_agent || "",
			"授权行为": record_obj?.permission_assignment || "",
			"控制标识": record_obj?.control_identifier || ""
		}

		# ===========未完成============
		# 文件数据
		WJSJ = []
		# 读取文档
		WD = {}
		WJSJ.push WD
		# ============未完成===========

		# 文件实体
		WJST = {
			"聚合层次": record_obj?.aggregation_level || "",
			"来源": LY,
			"电子文件号": record_obj?.electronic_record_code || "",
			"档号": DH,
			"内容描述": NRMS,
			"形式特征": XSTZ,
			"存储位置": CCWZ,
			"权限管理": QXGL,
			"文件数据": WJSJ
		}
		# 文件实体关系
		WJSTGX = {
			"实体标识符": record_obj?._id || "",
			"被关联实体标识符": record_obj?.related_archives || ""
		}

		# 文件实体块
		WJSTK = {
			"文件实体": WJST,
			"文件实体关系": WJSTGX
		}


		# 业务实体
		YWST = []
		
		# 人员表
		user_ids = []
		
		if audit_list?.length > 0
			audit_list.forEach (audit_obj)->
				ywobj = {
					"业务标识符": audit_obj?._id || "",
					"机构人员标识符": audit_obj?.action_user || "",
					"业务状态": audit_obj?.business_status || "",
					"业务行为": audit_obj?.business_activity || "",
					"行为时间": audit_obj?.action_time?.toISOString() || "",
					"行为依据": audit_obj?.action_mandate || "",
					"行为描述": audit_obj?.action_description || ""
				}
				YWST.push ywobj
				user_ids.push audit_obj?.action_user
		
		# 业务实体块
		YWSTK = {
			"业务实体":YWST
		}


		# 机构人员实体
		JGRYST = []
		space_user_list = Creator.Collections["space_users"].find({'user':{$in:user_ids}}).fetch()
		if space_user_list?.length > 0
			space_user_list.forEach (space_user_obj)->
				jgryobj = {
					"机构人员标识符": space_user_obj?.user || "",
					"机构人员类型": "内设机构",
					"机构人员名称": space_user_obj?.name || "",
					"组织机构代码": space_user_obj?.company || "",
					"个人职位": space_user_obj?.position || ""
				}
				JGRYST.push jgryobj

		# 机构人员实体块
		JGRYSTK = {
			"机构人员实体":JGRYST
		}

		# 封装内容
		FZNR = {
			"文件实体块": WJSTK,
			"业务实体块": YWSTK,
			"机构人员实体块": JGRYSTK,
		}

		# === 电子文件封装包 - 被签名对象
		# 封装包类型
		fzblx = "原始型"
		# 封装包类型描述
		fzblxms = "本封装包包含电子文件数据及其元数据，原始封装，未经修改"
		if record_obj?.has_xml
			fzblx = "修改型"
			fzblxms = "本封装包包含电子文件数据及其元数据，系修改封装，在保留原封装包的基础上，添加了修改层"
		# 封装包创建时间
		fzbcjsj = new Date
		# 封装包创建单位
		fzbcjdw = "河北港口集团"
		# 被签名对象
		BQMDX = {
			"封装包类型": fzblx,
			"封装包类型描述": fzblxms,
			"封装包创建时间": fzbcjsj.toISOString(),
			"封装包创建单位": fzbcjdw,
			"封装内容":FZNR
		}

		# === 电子签名块
		DZQMK = []

		# === 锁定签名
		SDQM = []

		# 电子文件封装包
		DZWJFZB = {
			"封装包格式描述": "本EEP根据中华人民共和国档案行业标准DA/T HGWS《基于XML的电子文件封装规范》生成",
			"版本": "2018",
			"被签名对象": BQMDX,
			"电子签名块": DZQMK,
			"锁定签名": SDQM
		}

		return DZWJFZB
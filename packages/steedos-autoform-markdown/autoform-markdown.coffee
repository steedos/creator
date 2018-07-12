Template.steedosAfMarkdown.helpers
	markdownStr: (value)->
		return Spacebars.SafeString(marked(value))

Template.steedosAfMarkdown.events
	'click #edit-markdown': (e, t)->
		self = this
		value = AutoForm.getFieldValue(self.name,AutoForm.getFormId())
		option = {}
		if Meteor.settings.public?.markdown?.stackEditURL
			option.url = Meteor.settings.public.markdown.stackEditURL

		stackedit = new Stackedit(option);
		stackedit.openFile({
			name: self.name,
			content: {
				text: value
			}
		})
		stackedit.on('fileChange', (file)->
			$('.markdown-body',$("#"+self.atts.id).parent()).html(Spacebars.SafeString(marked(file.content.text)).string)
			$("#"+self.atts.id).val(file.content.text)
		)

	'dblclick .markdown-body': (e, t)->
		$('#edit-markdown',e.currentTarget.parentNode).click()

AutoForm.addInputType "steedos-markdown", {
	template: "steedosAfMarkdown"
}
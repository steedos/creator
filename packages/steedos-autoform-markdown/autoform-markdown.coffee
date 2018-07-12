Template.steedosAfMarkdown.helpers
	markdownStr: (value)->
		return Spacebars.SafeString(marked(value))

Template.steedosAfMarkdown.onRendered ->
	element = $('#'+ this.data.atts.id)[0]
	Meteor.setTimeout ()->
		simplemde = new SimpleMDE({
			element: element,
			toolbar: ["bold", "italic", "heading", "|", "quote", "unordered-list", "ordered-list", "|", "link", "image", "|", "code", "table", "horizontal-rule", "|", "preview"],
		});
		#simplemde.value(this.data.value)
		element._simplemde = simplemde
	, 200

AutoForm.addInputType "steedos-markdown", {
	template: "steedosAfMarkdown"
	valueOut: ()->
		return this[0]._simplemde.value()
}
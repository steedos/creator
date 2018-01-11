Template.filter_option.helpers 
    fields: ()->
        fields = Creator.getSchema(Session.get("object_name"))._firstLevelSchemaKeys
        return fields

    filter_item: ()->
        return Template.instance().data?.filter_item

    is_selected: (opt, val)->
        if opt == val
            return "selected"


Template.filter_option.events 
    "click .save-filter": (event, template) ->
        field = template.$("#field").val()
        operation = template.$("#operation").val()
        value = template.$("#value").val()
        
        filter = 
            field: field
            operation: operation
            value: value

        index = this.index
        filter_items = Session.get("filter_items")
        filter_items[index] = filter

        Session.set("filter_items", filter_items)
        template.$(".uiPanel--default").css({"top": "-1000px", left: "-1000px"})
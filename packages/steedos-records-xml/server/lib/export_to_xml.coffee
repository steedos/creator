Export2XML = {}

# Export2XML.export("2GBYCkDpgjrRKn9Tu")
Export2XML.export = (_id) ->
    collection = Creator.Collections["archive_wenshu"]
    record_obj = collection.findOne({'_id':_id})
    if record_obj
        obj = {}
        console.log("---------------")
        
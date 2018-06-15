Export2XML = {}

# Export2XML.export("jYCZiiXNooeW8ARo6")
Export2XML.export = (_id) ->
    collection = Creator.Collections["archive_wenshu"]
    record_obj = collection.findOne({'_id':_id})
    if record_obj
        obj = {}
        console.log("---------------")
        
SteedosTable = {};

SteedosTable.formId = "instanceform";

CreatorTable = {};

CreatorTable.getKeySchema = function(field){
    var formId = AutoForm.getFormId();
    var schema = AutoForm.getFormSchema(formId)._schema;
    var keys = CreatorTable.getKeys(field);
    keys = _.map(keys, function(key){
        var key_schema = {};
        key_schema[field + ".$." + key] = schema[field + ".$." + key];
        return key_schema;
    })
    return keys;
}


CreatorTable.getTableValue = function(table) {
    var formId = AutoForm.getFormId();
    var value = [];
    $("tbody tr", $(table)).each(function(){
        var trValue = {}
        $("td", this).each(function(){
			var name = $(".form-control", this).attr("name")
			var key = name.replace(/\w+.\d+.(\w+)/ig, "$1")
            // trValue[name] = AutoForm.getFieldValue(name, formId);
            trValue[name] = "22222"
        })
        value.push(trValue);
    })
    return value;
}


CreatorTable.getThead = function(keys, editable) {
    trs = ""

    keys.forEach(function(sf, index) {

        label = sf;

        trs = trs + "<td nowrap='nowrap' class='title'>" + label + "</td>";

    });

    thead = '<tr>' + trs + '</tr>';

    return thead;
}


CreatorTable.getKeys = function(field) {
    var formId = AutoForm.getFormId()

    if (!AutoForm.getCurrentDataForForm(formId)) {
        return [];
    }

    var ss = AutoForm.getFormSchema(formId);

    var keys = [];

    if (ss.schema(field + ".$").type === Object) {
        keys = ss.objectKeys(SimpleSchema._makeGeneric(field) + '.$')
    }

    return keys;

}





if(Meteor.isClient){
    AutoForm.addInputType("table", {
        template: "afTable",
        valueOut: function() {
            // console.log("valueOut..............")
            // CreatorTable.getTableValue(this);
			return 
        },
        valueConverters: {
            "stringArray": AutoForm.valueConverters.stringToStringArray,
            "number": AutoForm.valueConverters.stringToNumber,
            "numerArray": AutoForm.valueConverters.stringToNumberArray,
            "boolean": AutoForm.valueConverters.stringToBoolean,
            "booleanArray": AutoForm.valueConverters.stringToBooleanArray,
            "date": AutoForm.valueConverters.stringToDate,
            "dateArray": AutoForm.valueConverters.stringToDateArray
        },
        contextAdjust: function(context) {
            if (typeof context.atts.maxlength === 'undefined' && typeof context.max === 'number') {
                context.atts.maxlength = context.max;
            }
            return context;
        }
    });

    Template.afTable.events({
        'tap .creator-table .steedosTable-item-add,.add-item-tr': function(event, template) {

            var field = template.data.name;

            var key_schema = CreatorTable.getKeySchema(field)


            var trField = template.trField.get();

            var index = trField.length;

            trField.push({index: index, value: []})

            template.trField.set(trField);
        },

    });

    Template.afTable.onCreated(function(){
        this.trField = new ReactiveVar([]);
    })

    Template.afTable.rendered = function() {
        var field = this.data.name;

        var keys = CreatorTable.getKeys(field);
        

        var validValue = this.data.value

        validValue = _.map(validValue, function(value, index){
            var _value = {};
            _value.index = index;
            _value.value = value;
            return _value
        })
        this.trField.set(validValue);
        // var validValue = SteedosTable.handleData(field, this.data.value);
        // SteedosTable.setTableValue(field, validValue);

        // $("thead[name='" + field + "Thead']").html(CreatorTable.getThead(field, this.data.atts.editable));
        
        $("thead[name='" + field + "Thead']").html(CreatorTable.getThead(keys, true));

        str = "新增一行";
        addItemTr = "<tr class='add-item-tr'><td colspan='"+keys.length+"'><i class='ion ion-plus-round'></i>"+str+"</td></tr>";

        if (this.data.atts.editable) {
           $("tfoot[name='" + field + "Tfoot']").append(addItemTr);
        }
    };

    Template.afTable.helpers({
        trField: function() {
            if (Template.instance().trField) {
                return Template.instance().trField.get();
            }
        },
        fieldName: function(index, value){
            var field = Template.instance().data.name;
            var keys = CreatorTable.getKeys(field);
            keys = _.map(keys, function(key, i){
                var _value = {};
                _value.name = field + "."+ index +"." + key;
                _value.value = value[i]
                return _value
            });
            return keys
        }
    }); 
}
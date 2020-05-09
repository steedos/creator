AutoForm.addInputType("steedosHtml", {
  template: "afSteedosHtml"
});

Template.afSteedosHtml.helpers({
  attsPlusClass: function() {
    var atts = _.clone(this.atts);
    // Add bootstrap class
    atts = AutoForm.Utility.addClass(atts, "form-control steedos-html");
    return atts;
  }
})
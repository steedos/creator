Meteor.startup ->
  try
    app = require("@steedos/oauth2-messenger").default
    WebApp.connectHandlers.use app
  catch error
    console.error error
  return

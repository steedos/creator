if Meteor.isServer
    @API = new Restivus
        apiPath: '/api/v2/',
        useDefaultAuth: true
        prettyJson: true
        enableCors: false
        defaultHeaders:
          'Content-Type': 'application/json'

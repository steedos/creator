Meteor.startup ->
  try
    express = require('express')
    passport = require('passport')
    OAuth2Strategy = require('passport-oauth').OAuth2Strategy
    router = express.Router()
    app = express()
    mattermost_url = 'http://192.168.1.150'
    client_url = 'http://192.168.1.4:3333'
    client_id = '4e1bmtawsf89fquf8pb1btjadr'
    client_secret = 'hjx5dwp6m38mt89g44s6fguhho'

    passport.use('oauth2', new OAuth2Strategy({
      authorizationURL: "#{mattermost_url}/oauth/authorize"
      tokenURL: "#{mattermost_url}/oauth/access_token"
      clientID: client_id
      clientSecret: client_secret
      callbackURL: "#{client_url}/steedos/oauth2/client/oauth/callback"
    }, (accessToken, refreshToken, profile, done) ->
      # User.findOrCreate(..., function (err, user) {
      #   done(err, user);
      # });
      console.log 'accessToken: ', accessToken
      console.log 'refreshToken: ', refreshToken
      console.log 'profile: ', profile
      done null, {}
      return
    ))

    router.get '/login', passport.authenticate('oauth2')

    router.get '/oauth/callback', (req, res, next) ->
      console.log(1)
      passport.authenticate('oauth2', (err, user) ->
        console.log(2)
        if err
          console.log(err)
          return next(err)
        if req.query.error
          console.error req.query.error
        if !user
          console.error 'no user'
        req.logIn user, (err) ->
          if err
            return next(err)
          console.log 'log in'
          {}
        return
      ) req, res, next
      return

    app.use '/steedos/oauth2/client', router
    WebApp.connectHandlers.use app
  catch error
    console.error error
  return

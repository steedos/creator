@fetch = require("node-fetch")
Meteor.startup ->
  try
    mattermostConfig = Meteor.settings.oauth2.mattermost
    if !mattermostConfig.mattermost_url || !mattermostConfig.client_url || !mattermostConfig.client_id || !mattermostConfig.client_secret
      return
    express = require('express')
    passport = require('passport')
    Strategy = require('passport-oauth2').Strategy
    Client4 = require('mattermost-redux/client').Client4
    router = express.Router()
    app = express()
    mattermost_url = mattermostConfig.mattermost_url
    client_url = mattermostConfig.client_url
    client_id = mattermostConfig.client_id
    client_secret = mattermostConfig.client_secret

    oauth2Strategy = new Strategy({
      authorizationURL: "#{mattermost_url}/oauth/authorize"
      tokenURL: "#{mattermost_url}/oauth/access_token"
      clientID: client_id
      clientSecret: client_secret
      callbackURL: "#{client_url}/steedos/oauth2/client/oauth/callback"
    }, (accessToken, refreshToken, profile, done) ->
      return done(null, profile)
    )
    oauth2Strategy.userProfile = (accessToken, done)->
      Client4.setUrl(mattermost_url)
      Client4.setToken(accessToken)
      Client4.getMe().then((data) ->
          done(null, data)
      ).catch((err) ->
          done(err)
      )

    passport.use(oauth2Strategy)

    passport.serializeUser (user, done) ->
      done(null, user)

    passport.deserializeUser (user, done) ->
      done(null, user)

    router.get '/login', passport.authenticate('oauth2')

    router.get '/oauth/callback', (req, res, next) ->
      passport.authenticate('oauth2', (err, user) ->
        if err
          return next(err)
        if req.query.error
          return next(new Error(req.query.error))
        if !user
          return next(new Error('no user'))

        cookies = req.cookies
        userId = cookies['X-User-Id']
        authToken = cookies['X-Auth-Token']
        if userId and authToken
          hashedToken = Accounts._hashLoginToken(authToken)
          user = Meteor.users.findOne
            _id: userId,
            "services.resume.loginTokens.hashedToken": hashedToken
          if user
            Setup.setAuthCookies(req, res, userId, authToken)
            return res.redirect('/')

        suer = Meteor.users.findOne({ $or: [{'username': user.username}, {'emails.address': user.email}] })
        if suer
          authToken = Accounts._generateStampedLoginToken()
          token = authToken.token
          hashedToken = Accounts._hashStampedToken authToken
          Accounts._insertHashedLoginToken suer._id, hashedToken
          Setup.setAuthCookies(req, res, suer._id, token)
        return res.redirect('/')
      )(req, res, next)
      return

    app.use '/steedos/oauth2/client', router
    WebApp.connectHandlers.use app
  catch error
    console.error error
  return

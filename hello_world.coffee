bogart = require "bogart"

app = bogart.router (get, post, update, destroy) ->
  get('/', ->
    return bogart.html("Hello World")
  )

bogart.start(app)
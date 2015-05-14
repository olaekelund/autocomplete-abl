module.exports =
  provider: null

  activate: ->

  deactivate: ->
    @provider = null

  provide: ->
    unless @provider?
      AblProvider = require('./abl-provider')
      @provider = new AblProvider()

    @provider

NetLocalWorld    = require 'villain/world/net/local'
WorldMap         = require '../../world_map'
EverardIsland    = require '../everard'
allObjects       = require '../../objects/all'
Tank             = require '../../objects/tank'
{decodeBase64}   = require '../base64'
helpers          = require '../../helpers'

# FIXME: Better error handling all around.


## Local game

# The `BoloLocalWorld` class implements a game local to the player's computer/browser.

class BoloLocalWorld extends NetLocalWorld

  authority: yes

  # Callback after resources have been loaded.
  loaded: ->
    @map = WorldMap.load decodeBase64(EverardIsland)
    @commonInitialization()
    @spawnMapObjects()
    @player = @spawn Tank
    @renderer.initHud()
    @loop.start()

  soundEffect: (sfx, x, y, owner) ->
    @renderer.playSound(sfx, x, y, owner)

  mapChanged: (cell, oldType, hadMine, oldLife) ->

  #### Input handlers.

  handleKeydown: (e) ->
    e.preventDefault()
    switch e.which
      when 32 then @player.shooting = yes
      when 37 then @player.turningCounterClockwise = yes
      when 38 then @player.accelerating = yes
      when 39 then @player.turningClockwise = yes
      when 40 then @player.braking = yes

  handleKeyup: (e) ->
    e.preventDefault()
    switch e.which
      when 32 then @player.shooting = no
      when 37 then @player.turningCounterClockwise = no
      when 38 then @player.accelerating = no
      when 39 then @player.turningClockwise = no
      when 40 then @player.braking = no

  buildOrder: (action, trees, cell) ->
    @player.builder.$.performOrder(action, trees, cell)

helpers.extend BoloLocalWorld.prototype, require('./mixin')
allObjects.registerWithWorld BoloLocalWorld.prototype


## Exports
module.exports = BoloLocalWorld

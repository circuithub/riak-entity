Entity = require("../../index").Entity

module.exports = class TestEntity extends Entity

  constructor: (@_id, @prop1, @prop2) ->

  attributes: =>
    prop1: @prop1


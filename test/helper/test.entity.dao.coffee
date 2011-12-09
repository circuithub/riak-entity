Dao = require("../../index").Dao
TestEntity = require "./test.entity"

class TestEntityDao extends Dao

  constructor: (log) -> super "testentity", log

  populateEntity: (meta, attributes) ->
      new TestEntity(meta.key, attributes.prop1, attributes.prop2)

exports.newInstance = (log) -> new TestEntityDao(log)

should = require "should"
testEntityDao = require("./helper/test.entity.dao").newInstance()
TestEntity = require "./helper/test.entity"

describe "TestEntityDao", ->
  describe "#get() after #save()", ->
    entity = new TestEntity("some-random-id", 1, 4)
    before (done) ->
      testEntityDao.save entity, (err, data) ->
        should.not.exist err
        should.exist data
        done err
    it "return matching object", (done) ->
      testEntityDao.get entity.id(), (err, entityFromDao) ->
        should.not.exist err
        entityFromDao.equals(entity).should.be.ok
        done err
    after (done) -> 
      testEntityDao.removeAll()
      done()


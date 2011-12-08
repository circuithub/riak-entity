Dao = require("../../index").Dao

class TestEntityDao extends Dao

  constructor: (log) -> super "test-entities", log

exports.newInstance = (log) -> new TestEntityDao(log)

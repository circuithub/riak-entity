_     = require "underscore"
utils = exports

# Method for finding appropriate link `key` by `tag` name.
# Return `null` if link wasn't found.
utils.getLink = (links, tagName) ->
  link = _.detect links, (link) -> tagName == link.tag
  if link then link.key else null

# Method for finding all appropriate link `key` by `tag` name.
utils.getLinks = (links, tagName) ->
  filtered = _.select links, (link) -> tagName == link.tag
  _.map filtered, (link) -> link.key

# Utility method for building link.
utils.buildLink = (bucket, key, tag) -> {bucket: bucket, key: key, tag: tag}


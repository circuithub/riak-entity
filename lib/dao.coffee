riak  = require "riak-js"
utils = require "./utils"

# Dao
# -----------
# Base class for all Dao classes. Some common methods should be implemented here.
module.exports = class Dao

  constructor: (@bucket, @log = true) ->
    @db = riak.getClient({debug: @log})

  # Get entity by `id`. Callback takes `error` and `entity` object.
  get: (id, callback) =>
    console.log "getting entity with id =", id, "from bucket =", @bucket if @log
    @db.get @bucket, id, (err, attributes, meta) =>
      if err
        callback err
      else
        callback undefined, @populateEntity(meta, attributes)

  # Save entity.
  save: (entity, callback) =>
    console.log "saving entity with id =", entity.id(), "into bucket =", @bucket if @log
    meta =
      links: entity.links()
      index: entity.index()
      contentType: if entity.contentType? then entity.contentType else "application/json"
    console.log "Content-type of the saved doc", meta.contentType
    @db.save @bucket, entity.id(), entity.attributes(), meta, (err, emptyEntity, meta) =>
      if err
        callback err
      else
        console.log "entity was saved in bucket", @bucket, "with id =", entity.id() if @log
        callback undefined, entity

  # Remove entity by `id`.
  remove: (id, callback) => @db.remove @bucket, id, callback

  # Remove all entities from `bucket`.
  removeAll: =>
    @db.getAll @bucket, (err, objects) =>
      if !err
        objects.forEach (object) =>
          console.log "removing entity from bucket", @bucket, "with id =", object.meta.key if @log
          @remove object.meta.key

  # Checks if such key exists in database. Callback takes 2 parameters: `err` and `exists` boolean parameter
  exists: (id, callback) => @db.exists @bucket, id, callback

  # Get all links from entity to some `bucket` under specified `tag`.
  walk: (id, spec, callback) =>
    linkPhases = spec.map (unit) ->
      bucket: unit[0] or '_', tag: unit[1] or '_', keep: unit[2]?
    console.log "walking phases", linkPhases
    @db
      .add({bucket: @bucket, key_filters: [["eq", id]]})
      .link(linkPhases)
      .map(@_map)
      .run(callback)

  links: (id, spec, callback) => @db.links @bucket, id, spec, callback

  # Method for building GitEntity.
  populateEntity: (meta, attributes) ->

  getLink: (links, tag) -> utils.getLink links, tag

  # Default map functions
  _map: (value) ->
    row = value.values[0]
    metadata = row.metadata
    linksArray = metadata["Links"]
    links = ({bucket: link[0], key: link[1], tag: link[2]} for link in linksArray) if linksArray
    entity =
      meta:
        key: value.key
        links: links
        contentType: metadata["content-type"]
        lastModified: Date.parse(metadata["X-Riak-Last-Modified"])
    entity.attributes = JSON.parse(row.data) if entity.meta.contentType == "application/json"
    [entity]


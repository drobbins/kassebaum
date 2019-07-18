@Kassebaum = {}

Kassebaum.generateUniqueShortId = (mrn) ->
    shortId = Random.id(6).toUpperCase() # Generate a Short ID
    while  shortId.match("0") or Patients.findOne(shortId: shortId)
        shortId = Random.id(6).toUpperCase() # Generate another Short ID
    shortId

Kassebaum.hasAttributes = (object, attributes) ->
    _.all attributes, (attribute) -> _.has(object, attribute) && object[attribute]

Kassebaum.authorizedUser = (userId) -> userId && Roles.userIsInRole(userId, ["admin", "procurement-tech"])

String.prototype.toProperCase = () ->
    @replace /\w\S*/g, (txt) -> return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

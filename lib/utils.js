hasAttributes = function (object, attributes) {
    return _.all(attributes, function (attribute) {
        return _.has(object, attribute) && object[attribute];
    });
}

authorizedUser = function (userId) {
   return userId && Roles.userIsInRole(userId, ["admin"]);
}

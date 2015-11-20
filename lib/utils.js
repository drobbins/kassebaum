hasAttributes = function (object, attributes) {
    return _.all(attributes, function (attribute) {
        return _.has(object, attribute) && object[attribute];
    });
}

authorizedUser = function (userId) {
   return userId && Roles.userIsInRole(userId, ["admin", "procurement-tech"]);
}

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

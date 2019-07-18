apiTokens = new Mongo.Collection("api-tokens");

function generateUniqueApiToken() {
    let token;
    do {
        token = Random.id(64);
    } while (apiTokens.findOne({token: token}))
    return token;
}

apiTokens.allow({
    // 'update'(userId){ return Kassebaum.authorizedUser(userId); },
    'remove'(userId){ return Kassebaum.authorizedUser(userId); }
});


Meteor.methods({
    'apiToken.create'(tokenAttributes) {
        if (!this.userId || !Roles.userIsInRole(this.userId, ['admin'])) {
            throw new Meteor.Error(401, "You are not authorized to add api tokens.")
        }

        const token = generateUniqueApiToken();

        apiToken = _.extend(tokenAttributes, {
            token,
            added: new Date().getTime(),
            addedBy: this.userId
        });
        apiTokens.insert(apiToken);
    },
    'apiToken.revoke'(token) {
        if (!this.userId || !Roles.userIsInRole(this.userId, ['admin'])) {
            throw new Meteor.Error(401, "You are not authorized to revoke api tokens.")
        }
        // const apiToken = apiTokens.findOne({token});
        apiTokens.remove({token});
    }
})

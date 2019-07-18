Template.apiTokenRowButtons.events
    "click #revokeTokenButton": ->
        Meteor.call "apiToken.revoke", this.token
        Logs.add "success", "revoked token #{this.token}"

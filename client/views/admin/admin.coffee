Template.admin.events
    "click #changePassword": (e, t) ->
        user = t.$("select[name='changeUserPassword.user']").val()
        password = t.$("input[name='changeUserPassword.password']").val()
        Meteor.call "changeUserPassword", user, password

Template.admin.onRendered () ->
    @$(".userSelect").select2
        data: Meteor.users.find({}).map((user) -> id: user._id, text: user.username)

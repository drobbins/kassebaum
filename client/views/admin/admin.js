import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';

Template.admin.events({
    'click #changePassword'(event, template) {
        const user = template.$("select[name='changeUserPassword.user']").val();
        const password = template.$("input[name='changeUserPassword.password']").val();
        Meteor.call('changeUserPassword', user, password);
    }
});

Template.admin.onRendered(function onRendered() {
    this.$('.userSelect').select2({
        data: Meteor.users.find({}).map((user) => ({ id: user._id, text: user.username }))
    });
});

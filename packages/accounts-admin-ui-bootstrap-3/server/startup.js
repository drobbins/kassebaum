Meteor.startup(function() {
	// create an admin role if it doesn't exist
	Roles.createRole('admin', {unlessExists: true})
});

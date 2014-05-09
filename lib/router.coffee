Router.configure
    layoutTemplate: "layout"
    loadingTemplate: "loading"
    waitOn: ->
        if Meteor.user()
            Meteor.subscribe "patients"
        else
            ready: -> true

Router.map ->
    @route "home",
        path: "/"
        template: "home"
    @route "admin",
        path: "/admin"
        template: "accountsAdmin"
        onBeforeAction: ->
            if Meteor.loggingIn()
                @render @loadingTemplate
            else if not Roles.userIsInRole Meteor.user(), ["admin"]
                @redirect "/"
    @route "listPatients",
        path: "/patients"
        template: "listPatients"
    @route "addPatient",
        path: "/patients/new"
        template: "addPatient"
    @route "viewPatient",
        path: "/patients/:_id"
        template: "viewPatient"
        data: -> Patients.findOne @params._id
    @route "editPatient",
        path: "/patients/:_id/edit"
        template: "editPatient"
        data: -> Patients.findOne @params._id

requireLogin = (pause) ->
    if not Meteor.user()
        if Meteor.loggingIn()
            @render @loadingTemplate
        else
            @render "accessDenied"
        pause()

Router.onBeforeAction "loading"
Router.onBeforeAction requireLogin, except: ["home", "accessDenied"]

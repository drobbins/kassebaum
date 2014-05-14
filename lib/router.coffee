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
    @route "modules",
        path: "/modules"
        template: "modules"
        onBeforeAction: ->
            HTTP.get "http://minervajs.org/lib", (error, result) ->
                Session.set "minervaModules", result.data
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
        waitOn: -> [
            Meteor.subscribe "observations", @params._id
            Meteor.subscribe "observationFiles", @params._id
        ]
    @route "editPatient",
        path: "/patients/:_id/edit"
        template: "editPatient"
        data: -> Patients.findOne @params._id
    @route "editObservation",
        path: "/patients/:patientId/observations/:_id"
        template: "editObservation"
        data: -> Observations.findOne @params._id
        waitOn: -> [
            Meteor.subscribe "observationDetail", @params._id
            Meteor.subscribe "observationDetailFiles", @params._id
        ]

requireLogin = ->
    if not Meteor.user()
        if Meteor.loggingIn()
            @render @loadingTemplate
        else
            Alerts.add "Please log in to proceed."
            @redirect "/"

Router.onBeforeAction "loading"
Router.onBeforeAction requireLogin, except: ["home", "accessDenied", "modules"]

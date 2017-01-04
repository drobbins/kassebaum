Router.configure
    layoutTemplate: "layout"
    loadingTemplate: "loading"

Router.map ->
    @route "home",
        path: "/"
        template: "home"
    @route "admin",
        path: "/admin"
        template: "admin"
        onBeforeAction: ->
            if Meteor.loggingIn()
                @render @loadingTemplate
            else if not Roles.userIsInRole Meteor.user(), ["admin"]
                @redirect "/"
            @next()
    @route "logs",
        path: "/logs"
        template: "logs"
    @route "listPatients",
        path: "/patients"
        template: "listPatients"
    @route "listDeletedPatients",
        path: "/patients/deleted"
        template: "listDeletedPatients"
    @route "listPatientsPrint",
        path: "/patients/print"
        template: "listPatientsPrint"
        waitOn: ->
            Meteor.subscribe "patientsById", Session.get("selectedPatientsList")
    @route "addPatient",
        path: "/patients/new"
        template: "addPatient"
        data: {}
    @route "viewPatient",
        path: "/patients/:_id"
        template: "viewPatient"
        data: -> Patients.findOne @params._id
        waitOn: ->
            Meteor.subscribe "patientById", @params._id
    @route "editPatient",
        path: "/patients/:_id/edit"
        template: "editPatient"
        data: -> Patients.findOne @params._id
        waitOn: ->
            Meteor.subscribe "patientById", @params._id

requireLogin = ->
    if not Meteor.user()
        if Meteor.loggingIn()
            @render @loadingTemplate
        else
            Alert.add "Please log in to proceed.", "danger"
            @redirect "/"
    @next()

requireAdmin = ->
    if not Roles.userIsInRole Meteor.user(), ["admin"]
        Alert.add "You do not have sufficient privileges to proceed.", "danger"
        @redirect "/"
    @next()

requireProcurementTech = ->
    if not Roles.userIsInRole Meteor.user(), ["admin", "procurement-tech"]
        Alert.add "You do not have sufficient privileges to proceed.", "danger"
        @redirect "/"
    @next()

logNavigation = ->
    if Meteor.user()
        Logs.add "info", "loaded #{@.url}"

Router.onBeforeAction requireAdmin, only: ["logs", "admin"]
Router.onBeforeAction requireProcurementTech, except: ["home", "accessDenied", "modules", "addPatient"]
Router.onBeforeAction requireLogin, except: ["home", "accessDenied", "modules"]
Router.onBeforeAction "loading"
Router.onAfterAction logNavigation, except: ["home", "accessDenied", "modules"]

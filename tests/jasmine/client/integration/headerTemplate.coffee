describe "Header template", ->

    beforeEach waitForRouter

    it "should not show any nav buttons when not logged in", ->
        div = document.createElement "DIV"
        Blaze.render Template.header, div
        expect($(div).find(".navbar-nav").first().find("li a")[0]).not.toBeDefined()
        expect($(div).find(".navbar-right li a").length).toBe 2 # login link buttons are ok

    it "should be able to login as a tech", (done) ->
        Meteor.loginWithPassword "kallie", "password", (err) ->
            expect(err).toBeUndefined()
            done()

    it "should display add patient nav button to techs", ->
        div = document.createElement "DIV"
        Blaze.render Template.header, div
        button = $(div).find(".navbar-nav").first().find("li a").first()
        expect(button.text()).toBe "Add Patient"
        expect(button.attr("href")).toBe "/patients/new"

    it "should be able to logout", (done) ->
        Meteor.logout done

    it "should be able to login as an admin", (done) ->
        Meteor.loginWithPassword "admin", "password", (err) ->
            expect(err).toBeUndefined()
            done()

    it "should be able to logout", (done) ->
        Meteor.logout done
describe "Header template", ->

    it "should not show any nav buttons when not logged in", ->
        div = document.createElement "DIV"
        Blaze.render Template.header, div
        expect($(div).find(".navbar-nav").first().find("li a")[0]).not.toBeDefined()
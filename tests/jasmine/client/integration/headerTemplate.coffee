describe "Header template", ->

    it "should not show any nav buttons when not logged in", ->
        div = document.createElement "DIV"
        Blaze.render Template.header, div
        expect($(div).find(".navButtons li a")[0]).not.toBeDefined()
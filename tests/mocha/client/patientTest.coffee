if MochaWeb
    MochaWeb.testOnly ->
        describe "Sanity Test", ->
            it "it equal", ->
                Meteor.flush()
                chai.assert.equal "dogs", "dogs"
            it "it definitely equal", ->
                Meteor.flush()
                chai.assert.equal "waffles", "waffles"

if MochaWeb then MochaWeb.testOnly ->

        assert = chai.assert

        describe "Patient collection", ->

            it "is present", ->
                assert.instanceOf Patients, Meteor.Collection

        describe "patient method", ->

            patient =
                firstName: "TestBob"
                lastName: "McTesty"
                mrn: "11223344556677008899"

            it "fails if not logged in", (done) ->
                Meteor.call "patient", { lastName: patient.lastName, mrn: patient.mrn }, (err) ->
                    try
                        assert.equal err.message, "You need to log in to add patients [401]"
                        done()
                    catch err
                        done(err)

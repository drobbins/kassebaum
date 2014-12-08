describe "patients publish function", ->

    patients = Meteor.publishFunctions.patients

    it "publishes nothing for unauthorized users.", ->
        global.authorizedUser = jasmine.createSpy().and.returnValue false
        expect(patients()).toBeUndefined()

    it "publishes all patients for authorized users.", ->
        foundPatients = ["patient1", "patient2"]
        global.authorizedUser = jasmine.createSpy().and.returnValue true
        spyOn Patients, "find"
            .and.returnValue foundPatients
        expect(patients()).toEqual foundPatients
        expect(Patients.find).toHaveBeenCalledWith()
describe "Template instancesOfProcurementForm \"created\" event handler", ->

    context = data: {}

    beforeEach ->
        Template.instancesOfProcurementForm.created.bind(context)()

    it "adds an instancesOfProcurementCollection to data", ->
        expect(context.data.instancesOfProcurementCollection).toBeDefined()

    it "places a single instancesOfProcurement in instancesOfProcurementCollection with todays date", ->
        today = moment(Date.now()).startOf("day").valueOf()
        expect(context.data.instancesOfProcurementCollection.find().count()).toEqual 1
        iop = context.data.instancesOfProcurementCollection.findOne()
        expect(iop.date).toEqual today
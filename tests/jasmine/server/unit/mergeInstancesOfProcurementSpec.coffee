describe "mergeInstancesOfProcurement utility method", ->

    it "exists", ->
        expect(!!mergeInstancesOfProcurement).toBe true

    it "merges two arrays of numbers without duplication", ->
        array1 = ["111", "222", "333", "444"]
        array2 = ["111", "555", "666", "333"]
        mergedArray = ["111", "222", "333", "444", "555", "666"]
        expect(mergeInstancesOfProcurement array1, array2).toEqual mergedArray

    it "merges two arrays instancesOfProcurement without duplication", ->
        # see data definions below
        expect(mergeInstancesOfProcurement iopArray1, iopArray2).toEqual mergedIopArray

iop1 = _id: "abc123", surgicalPathologyNumber: "123412341234", date: 1423749837282
iop2 = _id: "efg456", surgicalPathologyNumber: "567856785678", date: 1423749980139
iop3 = _id: "hij789", surgicalPathologyNumber: "901290129012", date: 1423934032945
iop4 = _id: "klm012", surgicalPathologyNumber: "345634563456", date: 1423634523423
iop5 = _id: "nop345", surgicalPathologyNumber: "789078907890", date: 1423812358349

iopArray1 = [iop1, iop2, iop3]
iopArray2 = [iop2, iop3, iop4, iop5]
mergedIopArray = [iop1, iop2, iop3, iop4, iop5]
describe "mergeSurgicalPathologyNumbers utility method", ->

    it "exists", ->
        expect(!!mergeSurgicalPathologyNumbers).toBe true

    it "merges two arrays (of surgical pathology numbers..) without duplication", ->
        array1 = ["111", "222", "333", "444"]
        array2 = ["111", "555", "666", "333"]
        mergedArray = ["111", "222", "333", "444", "555", "666"]
        expect(mergeSurgicalPathologyNumbers array1, array2).toEqual mergedArray
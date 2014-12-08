describe "hasAttributes utility function", ->

    obj2 =
        name: "Bob"
        age: 10

    obj4 =
        name: "Fred"
        age: 100
        language: "Frerman"
        atHome: true

    it "returns true if the object has (only) all the attributes", ->
        expect(hasAttributes obj2, ["name", "age"]).toBe true
    
    it "returns true if the object has (more than) all the attributes", ->
        expect(hasAttributes obj4, ["name", "age"]).toBe true
    
    it "returns true if the object does not have all the attributes", ->
        expect(hasAttributes obj2, ["name", "age", "gender"]).toBe false
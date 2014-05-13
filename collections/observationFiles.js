var observationFileStore = new FS.Store.GridFS("observationFiles");

ObservationFiles = new FS.Collection("observationFiles", {
    stores: [observationFileStore]
});

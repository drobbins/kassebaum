Meteor.npmRequire = function (packageName) {
    switch (packageName) {
    case "hashids":
      return function () {
          this.encrypt = function () {
              return Math.floor(Math.random()*1000000000000).toString()
          };
      }; // Return a stub for the package if you want
    default:
      return {};
    }
}

const API_PREFIX = "/api/1.0"

// WebApp.connectHandlers.use(API_PREFIX+'/hello', (req, res, next) => {
//   res.writeHead(200);
//   res.end(`Hello world from: ${Meteor.release}\n` + JSON.stringify(Meteor.user(),2));
// });

Meteor.methods({
    'test.getUser'(){
        return Meteor.userId();
    }
});

WebApp.connectHandlers.use(API_PREFIX+'/hello', async (req, res, next) => {
    let json = {}
    try{
        json = await Meteor.call("test.getUser");
        console.log(json);
    } catch(e) {
        console.error('/hello - err:\n',e);
    }



  // do something with json/body

  res.writeHead(200);
  res.end(`Hello world from: ${Meteor.release}`);
})

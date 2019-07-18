const API_PREFIX = "/api/1.0"

/**
* Authorization Middleware.
*
* This handler must occur first, as handlers are executed in order.
*
* All API requires require a token.
*/
WebApp.connectHandlers.use(async (req, res, next) => {
    const token = req.query.token
    let confirmedToken = false;

    try {
        confirmedToken = await Meteor.call("apiToken.confirm", token)
    } catch(e) {
        console.error('API Token Error - err:\n',e);
    }

    if (confirmedToken) {
        next();
    } else {
        res.writeHead(401)
        res.end(`Token missing or unauthorized.`)
    }
})

WebApp.connectHandlers.use(API_PREFIX+'/hello', (req, res, next) => {
  res.writeHead(200);
  res.end(`Hello authorized user from: ${Meteor.release}`);
})

WebApp.connectHandlers.use(API_PREFIX+'/patients', (req, res, next) => {
    let json = {}
    // try{
    //     json = await Meteor.call("test.getUser");
    //     console.log(json);
    // } catch(e) {
    //     console.error('/hello - err:\n',e);
    // }
    // do something with json/body

    console.log(JSON.stringify(req.query, 2));
    console.log(Object.keys(req));

    res.writeHead(200);
    res.end(`Hello Patient`);
})

import { WebApp } from 'meteor/webapp';
import bodyParser from 'body-parser';

const API_PREFIX = "/api/1.0"

/**
* Authorization Middleware.
*
* This handler must occur first, as handlers are executed in order.
*
* All API requires require a token.
*/
WebApp.connectHandlers.use(API_PREFIX, async (req, res, next) => {
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

WebApp.connectHandlers.use(bodyParser.json())

WebApp.connectHandlers.use(API_PREFIX+'/patients', async (req, res, next) => {
    let results = [];
    try{
        results = await Meteor.call("addPatientByAPI", req.body);
        res.writeHead(200);
        res.end(EJSON.stringify(results, {indent: true}));
    } catch(e) {
        res.writeHead(500);
        res.end("Server was unable to process request:\n", e);
        console.error('Uncaught error in /patients:\n',e);
    }
})

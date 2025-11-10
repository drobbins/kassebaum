import { Template } from 'meteor/templating';
import { Router } from 'meteor/iron:router';

Template.registerHelper('activeRouteClass', (routeName) =>
    (Router.current()?.route?.name === routeName ? 'active' : '')
);

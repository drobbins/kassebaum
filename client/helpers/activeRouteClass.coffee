UI.registerHelper "activeRouteClass", (routeName) ->
    "active" if Router.current()?.route?.name is routeName

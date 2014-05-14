loadScript = (url) ->
    $ "body"
        .append $("<script>").attr "src", url
    Modules.insert url: url

Template.modules.events
    "submit form": (e) ->
        e.preventDefault()
        loadScript $("[name=scriptUrl]").val()
    "click button": (e) ->
        e.preventDefault()
        loadScript $(e.target).attr "url"

Template.moduleList.modules = -> Modules.find()

Template.modules.helpers
    minervaModules: -> Session.get "minervaModules"

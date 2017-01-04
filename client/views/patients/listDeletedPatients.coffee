Template.listDeletedPatients.rendered = ->
    initializeDatePickers()
    if Session.get "startDate"
        $("[name=startDate]").datepicker("update", new Date(Session.get "startDate"))
    if Session.get "endDate"
        $("[name=endDate]").datepicker("update", new Date(Session.get "endDate"))

Template.listDeletedPatients.helpers
    tabularSelector: () ->
        startDate = Session.get "startDate"
        endDate = Session.get "endDate"
        dateQuery =
            deleted: true
            instancesOfProcurement:
                $elemMatch:
                    $and: []
        if startDate then dateQuery.instancesOfProcurement.$elemMatch.$and.push date: $gte: startDate
        if endDate then dateQuery.instancesOfProcurement.$elemMatch.$and.push date: $lte: endDate
        if startDate or endDate
            return dateQuery
        else
            return {deleted: true}
    selectedPatientsList: () -> if Session.get("selectedPatientsList")?.length > 0 then true else false

Template.listDeletedPatients.events
    "change input[name=startDate],input[name=endDate]": ->
        Session.set "startDate", $("[name=startDate]").datepicker("getDate")?.getTime()
        endDate = $("[name=endDate]").datepicker("getDate")?.getTime()
        if endDate then Session.set "endDate", moment(endDate).endOf("day").valueOf()
    "click #clearDateFilters": ->
        $("[name=startDate]").datepicker("clearDates")
        $("[name=endDate]").datepicker("clearDates")
        Session.set "endDate"
        Session.set "startDate"
    "click button#clearSelection": -> Session.set "selectedPatientsList", []

window.getHumanizedDuration = (start, end) ->
    start = moment start
    end = moment end
    if (years = end.diff(start, "years")) isnt 0
        duration = "#{years} years"
    else if (months = end.diff(start, "months")) isnt 0
        duration = "#{months} months"
    else if (days = end.diff(start, "days")) isnt 0
        duration = "#{days} days"
    else duration = "#{end.diff(start)} ms"
    return duration
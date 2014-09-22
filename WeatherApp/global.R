# per application stuff
library(dplyr)

load("data/ALL.dat")

bdate <- "2013-01-01"
edate <- "2014-09-30"

stnstable <- stns %.%
    select(
        ID = id,
        State = state,
        Name = name,
        Lat = lat,
        Long = lon,
        Elev = elev
    )

# per application stuff
library(shiny, quietly = T)
library(dplyr,quietly = T)
library(reshape2, quietly = T)

load("data/ALL.dat")

bdate <- "2000-01-01"
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

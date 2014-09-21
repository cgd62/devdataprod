# per application stuff
library(shiny)
library(dplyr)
library(reshape2)
library(data.table)

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

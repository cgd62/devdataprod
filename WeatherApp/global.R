# per application stuff
library(dplyr,warn.conflicts = F,quietly=T)
library(data.table)

load("data/ALL.dat")

setkey(meas,id,time,elem)

bdate <- "2013-01-01"
edate <- "2014-09-30"
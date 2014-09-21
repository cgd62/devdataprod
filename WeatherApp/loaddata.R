## Load Data

library(LaF)
library(reshape2)
library(data.table)
library(leafletR)

fd <- laf_open_fwf("ghcnd-stations.txt",
                   column_widths=c(12,9,10,7,3,30),
                   column_names=c("id","lat","lon","elev","state","name"),
                   column_types=c("string","double","double","double","categorical","string"),
                   trim=T)
stns <- fd[,]

states <- read.fwf("ghcnd-states.txt",
                   widths=c(2,-1,45),
                   col.names=c("code","name"),
                   colClasses=c("character","character"),)

fd <- laf_open_fwf(gzfile("core.dly"),
                   column_widths=c(11,4,2,4,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1,5,1,1,1),
                   column_types=c("string","integer","integer","factor","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string","double","string","string","string"),
                   trim=T)
m <- fd[,]

# normalize the screwy 31 columns for day format
meas <- melt(m, id=1:4, measure=c(seq(from = 5,to = 128,by = 4)))

# free mem
rm(m,fd)

setDT(meas)

setnames(meas,c("id","year","mon","elem","day","value"))

# get rid of NA measurements
allna <- (meas$value <= -2500) | (meas$value >= 9989)
meas <- meas[!allna,]
rm(allna)

# get rid of stations that don't have measurements
uids <- unique(meas$id)
stns <- stns[stns$id %in% uids,]
rm(uids)

# get rid of all but US
usstns <- stns[!is.na(stns$state),"id"]
meas <- meas[meas$id %in% usstns,]
rm(usstns)

# make timestamps and lose y/m/d columns
meas$time <- as.Date(paste(meas$year,meas$mon,as.integer(as.integer(substring(meas$day,2))/4)),"%Y %m %d")
meas <- as.data.table(subset(meas,select=c(id,time,elem,value)))
setkey(meas,id,time)

save.image("weather/data/ALL.dat",compress=T)
saveRDS(states,"weather/data/states.rds")
saveRDS(stns,"weather/data/stns.rds")
saveRDS(meas,"weather/data/meas.rds")

# shinyapps::configureApp("APPNAME", size="medium")
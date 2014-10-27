#!/usr/bin/env Rscript

library(argparse)
library(data.table)
library(RSQLite)

commandline_parser = ArgumentParser(
        description="subtract the phase values from the two files")

commandline_parser$add_argument('-f', '--second',
            type='character', nargs='?',
            help='sqlite file with the data')

commandline_parser$add_argument('-s', '--second',
            type='character', nargs='?',
            help='sqlite file with the data')

args <- commandline_parser$parse_args()

dataset.driver <- dbDriver("SQLite")
dataset.connection <- dbConnect(dataset.driver, dbname=args$first)
table1 <- data.table(dbReadTable(dataset.connection, "by_pixel"))
dbDisconnect(dataset.connection)

dataset.driver <- dbDriver("SQLite")
dataset.connection <- dbConnect(dataset.driver, dbname=args$second)
table2 <- data.table(dbReadTable(dataset.connection, "by_pixel"))
dbDisconnect(dataset.connection)

phase <- table2[, mean_P - table1[,mean_P]]

print(phase)

#dataset.driver <- dbDriver("SQLite")
#dataset.file <- sub(".db", "-by-pixel.db", args$file)
#dataset.connection <- dbConnect(dataset.driver, dbname=dataset.file)
#dbWriteTable(dataset.connection, "by_pixel", by_pixel, overwrite=TRUE)
#dbDisconnect(dataset.connection)

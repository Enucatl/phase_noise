#!/usr/bin/env Rscript

library(argparse)
library(data.table)
library(RSQLite)

commandline_parser = ArgumentParser(
        description="values pixel by pixel averaging over exposures")

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='?',
            help='sqlite file with the data')

args <- commandline_parser$parse_args()

dataset.driver <- dbDriver("SQLite")
dataset.connection <- dbConnect(dataset.driver, dbname=args$file)
table <- data.table(dbReadTable(dataset.connection, "by_pixel_and_exposure"))
dbDisconnect(dataset.connection)

weighted.sd <- function(sd) {
    return(sqrt(1 / sum(sd^(-2))))
}

by_pixel <- table[,
    list(
    mean_v0=weighted.mean(mean_v0, sd_v0^(-2)),
    sd_v0=weighted.sd(sd_v0),
    mean_A=weighted.mean(mean_A, sd_A^(-2)),
    sd_A=weighted.sd(sd_A),
    mean_B=weighted.mean(mean_B, sd_B^(-2)),
    sd_B=weighted.sd(sd_B),
    mean_R=weighted.mean(mean_R, sd_R^(-2)),
    sd_R=weighted.sd(sd_R),
    mean_P=weighted.mean(mean_P, sd_P^(-2)),
    sd_P=weighted.sd(sd_P)
    ),
    by="pixel"
    ]

dataset.driver <- dbDriver("SQLite")
dataset.file <- sub(".db", "-by-pixel.db", args$file)
print(dataset.file)
dataset.connection <- dbConnect(dataset.driver, dbname=dataset.file)
dbWriteTable(dataset.connection, "by_pixel", by_pixel, overwrite=TRUE)
dbDisconnect(dataset.connection)

#!/usr/bin/env Rscript

library(argparse)
library(data.table)
library(RSQLite)
library(rjson)

commandline_parser = ArgumentParser(
        description="output the visibility for each pixel")

commandline_parser$add_argument('-o', '--output',
            type='character', nargs='?',
            help='output csv file')

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='+',
            help='sqlite files with the data')

args <- commandline_parser$parse_args()

get_table = function(file.name) {
    dataset.driver <- dbDriver("SQLite")
    dataset.connection <- dbConnect(dataset.driver, dbname=file.name)
    table <- data.table(dbReadTable(dataset.connection, "by_pixel_and_exposure"))
    dbDisconnect(dataset.connection)
    return(table)
}

comp.table = rbindlist(lapply(args$file, get_table))[,
    list(pixel, exposure, mean_v0, mean_R, mean_A, relative_prediction_error)]
write.csv(comp.table, args$output)

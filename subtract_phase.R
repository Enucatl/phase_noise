#!/usr/bin/env Rscript

library(argparse)
library(data.table)
library(RSQLite)
library(rjson)

commandline_parser = ArgumentParser(
        description="subtract the phase values from the two files")

commandline_parser$add_argument('-b', '--batch',
            action="store_true",
            help='show plot')

commandline_parser$add_argument('-f', '--first',
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

table2[, diff_P:=(mean_P - table1[,mean_P])]
table2[, sd_diff_P:=min(c(0.001, abs(diff_P) * sqrt((sd_P / mean_P)^2 +
                                                   table1[,sd_P /
                                                          mean_P]^2)))]

#dataset.driver <- dbDriver("SQLite")
#dataset.file <- sub(".db", "-by-pixel.db", args$file)
#dataset.connection <- dbConnect(dataset.driver, dbname=dataset.file)
#dbWriteTable(dataset.connection, "by_pixel", by_pixel, overwrite=TRUE)
#dbDisconnect(dataset.connection)

min_visibility <- 0.04
print(table2)

mean_P <- mean(table2[mean_v0 > min_visibility, diff_P])
sd_P <- sd(table2[mean_v0 > min_visibility, diff_P])

output <- list(mean_P=mean_P, sd_P=sd_P)
output_file_name <- sub("-by-pixel.db", ".json", args$first)
sink(output_file_name)
cat(toJSON(output))
sink()

if(!args$batch) {
    library(ggplot2)
    X11()
    plot <- ggplot(
                   data=table2[mean_v0 > min_visibility],
                   aes(x=pixel, y=sd_diff_P)) + geom_point(size=1)
    print(plot)
    message("Press Return To Continue")
    invisible(readLines("stdin", n=1))
}

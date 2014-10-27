#!/usr/bin/env Rscript

library(argparse)
library(ggplot2)
library(data.table)
library(RSQLite)

commandline_parser = ArgumentParser(
        description="draw results for the phase noise analysis")

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='?',
            help='file with the data')

args <- commandline_parser$parse_args()

table <- fread(args$file)
setkey(table, pixel, exposure)
deviations <- table[,
    list(
    mean_n0=mean(n0),
    mean_v0=mean(v0),
    mean_A=mean(A),
    mean_B=mean(B),
    mean_R=mean(R),
    mean_P=mean(P),
    sd_v0=sd(v0),
    sd_A=sd(A),
    sd_B=sd(B),
    sd_R=sd(R),
    sd_P=sd(P)
    ), by=key(table)]

dataset.driver <- dbDriver("SQLite")
dataset.file <- sub(".csv", ".db", args$file)
dataset.connection <- dbConnect(dataset.driver, dbname=dataset.file)
dbWriteTable(dataset.connection, "by_pixel_and_exposure", deviations, overwrite=TRUE)
dbDisconnect(dataset.connection)

min_visibility <- 0.04
wm_R <- weighted.mean(
                      deviations[mean_v0 > min_visibility, mean_R],
                      deviations[mean_v0 > min_visibility, sd_R]^(-2))
wm_P <- weighted.mean(
                      deviations[mean_v0 > min_visibility, mean_P],
                      deviations[mean_v0 > min_visibility, sd_P]^(-2))
wm_P_sd <- sqrt(1 / sum(deviations[mean_v0 > min_visibility,
                          sd_P]^(-2)))
deviations <- deviations[,
    expected_sigma_P := 1 / (mean_v0 * sqrt(mean_n0) * mean_A ^
                               (wm_R + 0.5)),
    by=key(deviations)]
deviations <- deviations[,
    prediction_error := (expected_sigma_P - sd_P) / expected_sigma_P,
    by=key(deviations)]
print(table)
print(deviations)

print(c(wm_R, wm_P, wm_P_sd))

X11()
plot <- ggplot(
    data=deviations[mean_v0 > min_visibility],
    aes(x=pixel, y=mean_P)) + geom_point(size=1)
print(plot)
message("Press Return To Continue")
invisible(readLines("stdin", n=1))

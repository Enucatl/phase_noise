#!/usr/bin/env Rscript

library(argparse)
library(ggplot2)
library(data.table)

commandline_parser = ArgumentParser(
        description="draw results for the phase noise analysis")

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='?', default='S00074_S00633.csv',
            help='file with the data')

args <- commandline_parser$parse_args()

table <- fread(args$file)
setkey(table, pixel, exposure)
deviations <- table[,
    c(
    "mean_v0",
    "sigma_phi",
    "mean_n0",
    "mean_A",
    "mean_R",
    "sd_R"
    ):=list(
    mean(v0),
    sd(phi),
    mean(n0),
    mean(A),
    mean(R),
    sd(R)
    ), by=c("pixel", "exposure")]
min_visibility <- 0.04
wm_R <- weighted.mean(
                      deviations[mean_v0 > min_visibility, mean_R],
                      deviations[mean_v0 > min_visibility, sd_R]^(-2))
deviations <- deviations[,
    expected_sigma_phi := 1 / (mean_v0 * sqrt(mean_n0) * mean_A ^
                               (wm_R + 0.5)),
    by=key(deviations)]
deviations <- deviations[,
    prediction_error := expected_sigma_phi - sigma_phi,
    by=key(deviations)]
print(table)
print(deviations)

X11()
plot <- ggplot(
    data=deviations[mean_v0 > min_visibility],
    aes(x=pixel, y=prediction_error)) + geom_point(size=1)
print(plot)
message("Press Return To Continue")
invisible(readLines("stdin", n=1))

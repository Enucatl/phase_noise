#!/usr/bin/env Rscript

library(argparse)
library(ggplot2)
library(data.table)

commandline_parser = ArgumentParser(
        description="draw results for the phase noise analysis")

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='?', default='S00400_S02399.log',
            help='file with the data')

args = commandline_parser$parse_args()

table = fread(args$file)
print(table)

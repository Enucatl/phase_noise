#!/usr/bin/env Rscript

library(argparse)
library(ggplot2)
library(data.table)
library(scales)

commandline_parser = ArgumentParser(
        description="draw the plots for the progress report")

commandline_parser$add_argument('-f', '--file',
            type='character', nargs='+',
            help='file with the data')

args <- commandline_parser$parse_args()

table <- fread(args$file)
print(table)

width <- 10
height <- 0.618 * width
dpi <- 150
color <- "#0570b0"

# pixel visibility scatter plot
pixel_vis_scatter = ggplot(table, aes(x=pixel, y=mean_v0)) +
    geom_point(size=1, color=color) +
    scale_y_continuous("visibility", labels=percent)
ggsave(
       file="pixel_visibility.png",
       plot=pixel_vis_scatter,
       width=width, height=height, dpi=dpi)

# visibility distribution histogram
visibility_distribution <- ggplot(table[mean_v0 > 0.01,], aes(x=mean_v0)) +
    geom_histogram(binwidth=0.002, fill=color) + 
    scale_x_continuous("visibility", labels=percent) +
    scale_y_continuous("#pixels / 0.2%")
ggsave(
       file="visibility.png",
       plot=visibility_distribution,
       width=width, height=height, dpi=dpi)

# R distribution histogram
R_distribution <- ggplot(table[mean_v0 > 0.04,], aes(x=mean_R)) +
    geom_histogram(binwidth=0.004, fill=color) + 
    scale_x_continuous("R") +
    scale_y_continuous("#pixels / 0.004")
ggsave(
       file="R_distribution.png",
       plot=R_distribution,
       width=width, height=height, dpi=dpi)

# relative_prediction_error_flat_only vs mean_B
relative_prediction_error_flat_only <- ggplot(table[mean_v0 > 0.04,], aes(x=mean_B,
                                                     y=relative_prediction_error_flat_only)) +
    geom_point(size=1, color=color) +
    scale_x_continuous("dark field") +
    scale_y_continuous("relative prediction error", labels=percent)
ggsave(
       file="relative_prediction_error_flat_only_meanB.png",
       plot=relative_prediction_error_flat_only,
       width=width, height=height, dpi=dpi)

# relative_prediction_error_flat_only vs mean_A
relative_prediction_error_flat_only <- ggplot(table[mean_v0 > 0.04,], aes(x=mean_A,
                                                     y=relative_prediction_error_flat_only)) +
    geom_point(size=1, color=color) +
    scale_x_continuous("A") +
    scale_y_continuous("relative prediction error", labels=percent)
ggsave(
       file="relative_prediction_error_flat_only.png",
       plot=relative_prediction_error_flat_only,
       width=width, height=height, dpi=dpi)

# relative_prediction_error vs mean_A
relative_prediction_error <- ggplot(table[mean_v0 > 0.04,], aes(x=mean_A,
                                                     y=relative_prediction_error)) +
    geom_point(size=1, color=color) +
    scale_x_continuous("A") +
    scale_y_continuous("relative prediction error", labels=percent)
ggsave(
       file="relative_prediction_error.png",
       plot=relative_prediction_error,
       width=width, height=height, dpi=dpi)

# sd_P vs mean_A
sd_P <- ggplot(table[mean_v0 > 0.04,], aes(x=mean_A,
                                                     y=sd_P)) +
    geom_point(size=1, color=color) +
    scale_x_continuous("A") +
    scale_y_continuous("sd P")
ggsave(
       file="sd_P.png",
       plot=sd_P,
       width=width, height=height, dpi=dpi)

# sd_P vs mean_A
sd_P_exposure <- ggplot(table[mean_v0 > 0.04,], aes(x=exposure,
                                                     y=sd_P)) +
    geom_point(size=1, color=color) +
    scale_x_continuous("exposure") +
    scale_y_continuous("sd P")
ggsave(
       file="sd_P_exposure.png",
       plot=sd_P_exposure,
       width=width, height=height, dpi=dpi)

# sd_P vs mean_n0
sd_P_mean_n0 <- ggplot(table[mean_v0 > 0.04,], aes(x=mean_n0,
                                                     y=sd_P)) +
    geom_point(size=1, color=color) +
    scale_x_continuous("n0") +
    scale_y_continuous("sd P")
ggsave(
       file="sd_P_mean_n0.png",
       plot=sd_P_mean_n0,
       width=width, height=height, dpi=dpi)

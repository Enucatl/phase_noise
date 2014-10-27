import numpy as np
import argparse
import os
import nist_lookup.xraydb_plugin as xdb

import matplotlib.pyplot as plt

materials = [
    {
        "name": "PMMA",
        "formula": "C5O2H8",
        "density": 1.18,  # g / cm 3
    },
    {
        "name": "Polystyrene",
        "formula": "C8H8",
        "density": 1.05,  # g / cm 3
    },
    {
        "name": "High-density Polyethilene",
        "formula": "C2H4",
        "density": 0.97,  # g / cm 3
    },
]

energies = np.arange(10, 200)  # keV

parser = argparse.ArgumentParser(
    __doc__,
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument(
    "file",
    nargs="?",
    default="deltas_table.npy",
    help="destination file for the npy table")

parser.add_argument(
    "-b", "--batch",
    action="store_true",
    help="don't show the plot")

parser.add_argument(
    "-o", "--overwrite",
    action="store_true",
    help="overwrite output file")

if __name__ == '__main__':
    file_name = "deltas_table.npy"
    args = parser.parse_args()
    if os.path.exists(file_name) and not args.overwrite:
        deltas = np.load(file_name)
    else:
        deltas = np.array([[
            xdb.xray_delta_beta(
                mat["formula"],
                mat["density"],
                e * 1e3)[0]
            for mat in materials]
            for e in energies
        ])
        np.save(file_name, deltas)
    if not args.batch:
        plt.plot(energies, deltas[..., 1] / deltas[..., 0])
        plt.plot(energies, deltas[..., 2] / deltas[..., 0])
        plt.ion()
        plt.show()
        input()

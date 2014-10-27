import h5py
import sys
import csv
import argparse
import numpy as np

"""
Print pixel by pixel data to be imported into R

"""

parser = argparse.ArgumentParser(
    __doc__,
    formatter_class=argparse.ArgumentDefaultsHelpFormatter
)

parser.add_argument(
    "file",
    nargs=1,
    help="hdf5 file with the data",
)

if __name__ == '__main__':
    args = parser.parse_args()
    lines_per_time = 40
    file_name = args.file[0]
    input_file = h5py.File(file_name, "r")
    input_group = input_file["postprocessing"]
    v_0s = input_group["visibility"][0, ...]
    n_0s = np.sum(input_group["flat_phase_stepping_curves"][0, ...], axis=-1)
    As = input_group["dpc_reconstruction"][0, ..., 0]
    Ps = input_group["dpc_reconstruction"][0, ..., 1]
    Bs = input_group["dpc_reconstruction"][0, ..., 2]
    exposures = [1, 2, 3, 4, 5, 6, 7]
    writer = csv.writer(sys.stdout)
    writer.writerow(["pixel", "exposure", "v0", "n0", "A", "B", "R", "P"])
    writer.writerows([
        i,
        exposures[j // lines_per_time],
        v_0s[i, j],
        n_0s[i, j],
        As[i, j],
        Bs[i, j],
        np.log(Bs[i, j]) / np.log(As[i, j]),
        Ps[i, j],
    ]
        for i in range(Ps.shape[0])
        for j in range(Ps.shape[1])
    )

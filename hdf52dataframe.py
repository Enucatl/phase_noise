import h5py
import os
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
    file_name = args.file[0]
    input_file = h5py.File(file_name, "r")
    input_group = input_file["postprocessing"]
    v_0s = input_group["flat_parameters"][0, ..., 1]
    n_0s = np.sum(input_group["flat_phase_stepping_curves"][0, ...], axis=-1)
    As = input_group["dpc_reconstruction"][0, ..., 0]
    phis = input_group["dpc_reconstruction"][0, ..., 1]
    exposures = [1, 2, 3, 4, 5, 6, 7, 4, 5, 6]
    print(v_0s.shape)
    print(n_0s.shape)
    print(As.shape)
    print(phis.shape)
    for pixel in zip(v_0s, n_0s, As, phis):
        for i, experiment in enumerate(pixel):
            print(exposures[i // 100], *experiment)

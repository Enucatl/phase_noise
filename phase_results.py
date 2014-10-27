import argparse
import numpy as np
import json

from theoretical_delta import materials


def delta2p(delta, p=2.8e-4, D=18.9, tan_theta=0.75):
    """Calculate the GI P value from delta (1/cm)

    """
    return 2 * np.pi * D * delta * tan_theta / p


def p2delta(P, p=2.8e-4, D=18.9, tan_theta=0.75):
    """inverse of above

    """
    return p * P / (2 * np.pi * D * tan_theta)

if __name__ == '__main__':
    deltas = np.load("deltas_table.npy")
    for i, material in enumerate(materials):
        experimental_data = material["name"] + ".json"
        experimental_data = json.load(open(experimental_data))
        print()
        print(material["name"])
        print("theoretical P:", delta2p(deltas[40, i]))
        print("experimental P: {0} ± {1}".format(
            0.5 * experimental_data["mean_P"],
            0.5 * experimental_data["sd_P"]
        ))
        print()

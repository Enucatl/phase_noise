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
    experimental = []
    for i, material in enumerate(materials):
        experimental_data = material["name"] + ".json"
        experimental_data = json.load(open(experimental_data))
        print()
        print(material["name"])
        print("theoretical P: {0:.4f}".format(delta2p(deltas[41, i])))
        print("experimental P: {0:.4f} ± {1:.4f}".format(
            0.5 * experimental_data["mean_P"],
            0.5 * experimental_data["sd_P"]
        ))
        experimental.append({
            "value": 0.5 * experimental_data["mean_P"],
            "error": 0.5 * experimental_data["sd_P"]
        })
        print("theoretical delta: {0:.3g}".format(deltas[41, i]))
        print("experimental delta: {0:.3g} ± {1:.3g}".format(
            p2delta(0.5 * experimental_data["mean_P"]),
            p2delta(0.5 * experimental_data["sd_P"])
        ))
        print("theoretical ratio with pmma: {0:.2f}".format(
            deltas[41, i] / deltas[41, 0]))
        print()
    r1 = experimental[1]["value"] / experimental[0]["value"]
    r2 = experimental[2]["value"] / experimental[0]["value"]
    print("ratio 1 {0:.2f} ± {1:.2f}".format(
        r1,
        r1 * np.sqrt(
            (experimental[1]["error"]/experimental[1]["value"])**2 +
            (experimental[0]["error"]/experimental[0]["value"])**2
        )))
    print("ratio 2 {0:.2f} ± {1:.2f}".format(
        r2,
        r2 * np.sqrt(
            (experimental[2]["error"]/experimental[2]["value"])**2 +
            (experimental[0]["error"]/experimental[0]["value"])**2
        )))
    print()

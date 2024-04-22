import pathlib
import pickle
import matplotlib.pyplot as plt
import numpy as np
import tifffile


def patch_grid_shape(model_output, patch_length=224):
    return patch_grid_idx(model_output, patch_length).max(axis=0) + 1


def patch_grid_idx(model_output, patch_length=224):
    index = np.fliplr(
        np.array(model_output["coordinates"])[:, :2] / patch_length
    ).astype(int)
    return index


def plot_kather100k(
    model_output,
    plot=True,
    ax=None,
    plot_legend=False,
):
    PATCH_WIDTH = 224
    LABEL_DICT = {
        "BACK": 0,
        "NORM": 1,
        "DEB": 2,
        "TUM": 3,
        "ADI": 4,
        "MUC": 5,
        "MUS": 6,
        "STR": 7,
        "LYM": 8,
    }

    grid_shape = patch_grid_shape(model_output, PATCH_WIDTH)
    idx = patch_grid_idx(model_output, PATCH_WIDTH)
    cat_img = np.zeros(grid_shape)
    cat_img[tuple(idx.T)] = np.asarray(model_output["predictions"])
    # cat_img = np.asarray(model_output['predictions']).reshape(grid_shape)

    if plot:
        if ax is None:
            plt.figure()
            ax = plt.gca()
        ax.imshow(cat_img, cmap="tab10", vmin=0, vmax=9, interpolation="none")

    if plot_legend:
        plt.figure()
        plt.imshow(np.arange(9).reshape(-1, 1), cmap="tab10", vmin=0, vmax=9)
        plt.gca().set_yticks(list(LABEL_DICT.values()), list(LABEL_DICT.keys()))

    return cat_img


pp_orion = sorted(
    pathlib.Path(
        r"/Users/yuanchen/projects/orion-crc/HE_patch_prediction/gamma-only/orion"
    ).glob("*.pickle")
)

prediction_orion = [pickle.load(open(p, "rb")) for p in pp_orion]

out_dir = pathlib.Path(
    "/Users/yuanchen/projects/orion-crc/HE_patch_prediction/gamma-only/orion/class-images"
)

for pp, pred in zip(pp_orion, prediction_orion):
    img = plot_kather100k(pred, plot=False)
    plt.imsave(
        out_dir / f"{pp.name.split('.')[0]}.png", img, cmap="tab10", vmin=0, vmax=9
    )
    tifffile.imwrite(out_dir / f"{pp.name.split('.')[0]}.tiff", img.astype("uint8"))

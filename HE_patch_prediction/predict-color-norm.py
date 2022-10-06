# 
# Prediction block 
#
import palom
import tiatoolbox
import tifffile
import numpy as np
import skimage.transform

from tiatoolbox.models.engine.patch_predictor import PatchPredictor
from tiatoolbox.models.engine.patch_predictor import IOPatchPredictorConfig
from tiatoolbox.models.dataset.classification import WSIPatchDataset


predictor = PatchPredictor(
    pretrained_model='densenet161-kather100k', batch_size=32,
    num_loader_workers=0
)

import skimage.exposure
import torchvision.transforms

def preproc_func(img):
    return torchvision.transforms.ToTensor()(
        skimage.exposure.adjust_gamma(img, 2.2)
    ).permute(1, 2, 0)

predictor.model.preproc_func = preproc_func


ON_GPU = True

MPP_TEST = 0.325
MPP_TRAINING = 0.5
PATCH_WIDTH = int(224 * (0.5/MPP_TRAINING))

wsi_ioconfig = IOPatchPredictorConfig(
    # this is referring to the resolution of the training data
    # if the resolution here doesn't match the input wsi, the
    # input wsi will be resized
    input_resolutions=[{'units': 'mpp', 'resolution': MPP_TRAINING}],
    patch_input_shape=[PATCH_WIDTH, PATCH_WIDTH],
    stride_shape=[PATCH_WIDTH, PATCH_WIDTH]
)

def grid_shape(coors, patch_length=224):
    return grid_idx(coors, patch_length).max(axis=0) + 1

def grid_idx(coors, patch_length=224):
    index = np.fliplr(
        np.array(coors)[:, :2] /
        patch_length
    ).astype(int)
    return index

def run_predict(slide_path):

    slide = tiatoolbox.wsicore.wsireader.TIFFWSIReader(
        slide_path,
        mpp=[MPP_TEST]*2,
        power=20,
        axes='SYX'
    )

    dataset = WSIPatchDataset(
        slide,
        mode='wsi',
        patch_input_shape=wsi_ioconfig.patch_input_shape,
        stride_shape=wsi_ioconfig.stride_shape,
        resolution=wsi_ioconfig.input_resolutions[0]["resolution"],
        units=wsi_ioconfig.input_resolutions[0]["units"],
        auto_get_mask=False,
    )

    g_shape = grid_shape(dataset.inputs)
    c1r = palom.reader.OmePyramidReader(slide_path)
    level = -1 if len(c1r.pyramid) < 5 else 4
    mask = palom.img_util.entropy_mask(c1r.pyramid[level][1])
    mask = skimage.transform.resize(mask.astype(float), g_shape, order=3) > 0.1

    dataset.inputs = dataset.inputs[mask.flatten()]

    return predictor._predict_engine(
        dataset,
        return_labels=False,
        return_probabilities=True,
        return_coordinates=True,
        on_gpu=ON_GPU,
    )

def construct_dataset(slide_path, do_mask=False):

    slide = tiatoolbox.wsicore.wsireader.TIFFWSIReader(
        slide_path,
         mpp=[MPP_TEST]*2,
         power=20,
         axes='SYX'
    )

    dataset = WSIPatchDataset(
        slide,
        mode='wsi',
        patch_input_shape=wsi_ioconfig.patch_input_shape,
        stride_shape=wsi_ioconfig.stride_shape,
        resolution=wsi_ioconfig.input_resolutions[0]["resolution"],
        units=wsi_ioconfig.input_resolutions[0]["units"],
        auto_get_mask=False,
    )
    dataset.patch_idx = np.arange(np.multiply(*g_shape))

    if do_mask:
        g_shape = grid_shape(dataset.inputs)
        c1r = palom.reader.OmePyramidReader(slide_path)
        level = -1 if len(c1r.pyramid) < 5 else 4
        mask = palom.img_util.entropy_mask(c1r.pyramid[level][1])
        mask = skimage.transform.resize(mask.astype(float), g_shape, order=3) > 0.1

        dataset.inputs = dataset.inputs[mask.flatten()]
        dataset.patch_idx = dataset.patch_idx[mask.flatten()]
    return dataset

def slide_grid_shape(slide_path):
    dataset = construct_dataset(slide_path)
    return grid_shape(dataset.inputs)

import csv

with open(r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\img_list.csv') as csvfile:
    reader = csv.DictReader(csvfile)
    files = [r for r in reader]

slide_paths = [f['path'] for f in files][:]
slide_names = [f['name'] for f in files][:]

import pickle
import pathlib

out_dir = pathlib.Path(r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\he_crc_100k_gt450_orion_p37_batch1\densenet161-kather100k\gamma-only')

for p in slide_paths[:]:
    p = pathlib.Path(p)
    print()
    print('Processing', p.name)

    with open(out_dir / f"{p.name}-crc_100k_predict_result.pickle", 'wb') as f:
        p_results = run_predict(p)
        p_results['grid_shape'] = slide_grid_shape(p)
        pickle.dump(p_results, f)


# record grid shape for later usages
all_grid_shapes = [slide_grid_shape(p) for p in slide_paths]
grid_shape_file = r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\he_crc_100k_gt450_orion_p37_batch1\densenet161-kather100k\grid_shape.csv'
with open(grid_shape_file, 'w', newline='') as csvout:
    fieldnames = ['filename', 'num_rows', 'num_cols']
    writer = csv.DictWriter(csvout, fieldnames=fieldnames)
    writer.writeheader()

    for p, (r, c) in zip(slide_paths, all_grid_shapes):
        writer.writerow({'filename': p, 'num_rows': r, 'num_cols': c})




import pathlib
from joblib import Parallel, delayed

out_dir = pathlib.Path(r"Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round3\cell_class_table\patches\orion")

for p, n in zip(slide_paths[:], slide_names[:]):
    p = pathlib.Path(p)
    print()
    print('Processing', p.name)
    slide_name = f"{n}-{p.name.split('$')[1]}"
    (out_dir / slide_name).mkdir(exist_ok=True, parents=True)
    patch_idx = construct_dataset(p, do_mask=True).patch_idx[:]
    print('num of jobs:', len(patch_idx))
    Parallel(n_jobs=10, verbose=1)(
        delayed(
            lambda x: tifffile.imsave(
                out_dir/slide_name/f"{x}.tif",
                construct_dataset(p)[x]['image']
            )
        )(i) for i in patch_idx
    )


import pathlib
import pickle
from joblib import Parallel, delayed


def patch_grid_idx(model_output, patch_length=224):
    index = np.fliplr(
        np.array(model_output['coordinates'])[:, :2] /
        patch_length
    ).astype(int)
    return index

prediction_dir = pathlib.Path(r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\he_crc_100k_gt450_orion_p37_batch1\densenet161-kather100k\gamma-only\other-batches-orion')
patch_dir = pathlib.Path(r"Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round3\cell_class_table\patches\orion")

for p, n in zip(slide_paths[:], slide_names[:]):
    p = pathlib.Path(p)
    print()
    print('Processing', p.name)

    pickle_name = prediction_dir / f"{p.name}-crc_100k_predict_result.pickle"
    slide_name = f"{n}-{p.name.split('$')[1]}"

    processed_patch_idxs = construct_dataset(p, do_mask=True).patch_idx[:]
    
    g_shape = slide_grid_shape(p)
    prediction = pickle.load(open(pickle_name, 'rb'))
    prediction_patch_idxs = np.ravel_multi_index(
        patch_grid_idx(prediction).T, g_shape
    )
    bg_patch_idxs = prediction_patch_idxs[np.array(prediction['predictions']) == 0]
    intersection_patch_idxs = np.intersect1d(processed_patch_idxs, bg_patch_idxs)

    print(len(processed_patch_idxs), len(bg_patch_idxs), len(intersection_patch_idxs), len(intersection_patch_idxs)/len(processed_patch_idxs))
    def rm_file(filepath):
        try:
            filepath.unlink()
        except FileNotFoundError:
            pass
        return
    Parallel(n_jobs=10, verbose=1)(
        delayed(
            rm_file
        )(patch_dir / slide_name / f"{i}.tif") for i in intersection_patch_idxs
    )
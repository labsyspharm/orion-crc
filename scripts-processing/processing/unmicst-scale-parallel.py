# Using the nucleiDAPILAMIN model instead of the nucleiDAPI model


import UnMicst2 as UnMicst2
import pathlib
import skimage.io
import skimage.exposure
import rowit
import skimage.transform
from joblib import Parallel, delayed
import numpy as np
import warnings
import time
import datetime


def wrap_rescale(img, scale=1, kwargs={}):
    if scale == 1: return img
    return skimage.transform.rescale(img, scale, **kwargs)

def wrap_round_dtype(img, dtype=None):
    if dtype is None: return img
    assert np.issubdtype(dtype, np.integer), 'dtype must be subtype of np.integer'
    d_info = np.iinfo(dtype)
    return np.clip(np.round(img), d_info.min, d_info.max).astype(dtype)


def whole_image_bg(img, method, radius):
    ori_img = img

    func = getattr(skimage.filters.rank, method)

    def wrap_warn(rank_func, img, **kwargs):
        with warnings.catch_warnings():
            warnings.simplefilter('ignore')
            return func(img, **kwargs)

    wv_bg = Parallel(n_jobs=1, max_nbytes=None, verbose=1)(
        delayed(wrap_warn)(
            func, i, selem=skimage.morphology.disk(radius)
        ) for i in ori_img
    )

    return np.array(wv_bg)
    
def wrap_subtract_bg(img, selem=None):
    if selem is None: return img
    dtype = img.dtype
    assert np.issubdtype(dtype, np.integer), (
        'image pixel dtype needs to be integer to perform local'
        ' background subtraction'
    )
    d_info = np.iinfo(dtype)
    with warnings.catch_warnings():
        warnings.simplefilter('ignore')
        bg = skimage.filters.rank.mean_percentile(
            img, p0=0, p1=0.25, selem=selem
        )
    img = np.clip(img.astype(int) - bg.astype(int), d_info.min, d_info.max)
    return img.astype(dtype)

def wrap_rescale_intensity(img, rescale_min, rescale_max):
    img = skimage.exposure.rescale_intensity(
        img.astype(float), 
        in_range=(rescale_min, rescale_max), 
        out_range=(0, 0.983)
    )
    return img

def wrap_resize(img, size):
    if ~np.all(img.shape == size):
        img = skimage.transform.resize(img.astype(float), size, order=3)
    return skimage.img_as_ubyte(img)

def test(
    img_path, channel,
    out_dir, out_name,
    pixel_scale, subtract_bg=False,
    rescale_p0=5, rescale_p1=99.999,
    block_size=2000, block_overlap=200,
    adjust_gamma_value=None
):

    start_time = int(time.perf_counter())

    input_file_path = img_path
    nucleus_channel = channel
    output_dir = out_dir
    output_name = out_name
    scale = pixel_scale
    block_size = block_size
    local_bg_selem = skimage.morphology.disk(50)

    output_path = (
        pathlib.Path(output_dir) / output_name / 'unmicst2' / '{}_Probabilities_{}.tif'.format(
            output_name, nucleus_channel
        )
    )

    img = skimage.io.imread(input_file_path, key=nucleus_channel)
    dtype = img.dtype
    # img = np.log1p(img)

    # rescale_min = img.min()
    # rescale_max = np.percentile(img, 99.9999)

    wv_settings = rowit.WindowView(
        # img.shape, block_size=10000, overlap_size=1000,
        img.shape, block_size=block_size, overlap_size=block_overlap
    )
    img_wv = wv_settings.window_view_list(img)


    img_wv = Parallel(n_jobs=-1, verbose=1)(delayed(wrap_rescale)(
        i, scale, kwargs=dict(order=3, preserve_range=True)
    ) for i in img_wv)

    img_wv = wrap_round_dtype(img_wv, dtype)

    if adjust_gamma_value is not None:
        img_wv = skimage.exposure.adjust_gamma(
            img_wv, adjust_gamma_value
        )
    
    if subtract_bg == True:
        img_wv = Parallel(n_jobs=-1, verbose=1, max_nbytes=None)(delayed(wrap_subtract_bg)(
            i, local_bg_selem
        ) for i in img_wv)

    rescale_min = np.percentile(np.array(img_wv).flatten(), rescale_p0)
    rescale_max = np.percentile(np.array(img_wv).flatten(), rescale_p1)
    img_wv = Parallel(n_jobs=-1, verbose=1)(delayed(wrap_rescale_intensity)(
        i, rescale_min, rescale_max
    ) for i in img_wv)

    for idx, class_i in enumerate(range(3)[::-1]):
        prob_wv = [
            UnMicst2.UNet2D.singleImageInference(np.array([i, i]), 'accumulate', class_i)
            for i in img_wv
        ]
        prob_wv = Parallel(n_jobs=-1, verbose=1)(delayed(wrap_resize)(
            i, (block_size, block_size)
        ) for i in prob_wv)
        prob_wv = wv_settings.reconstruct(np.array(prob_wv))
        pathlib.Path(output_path).parent.mkdir(parents=True, exist_ok=True)
        append = False if idx == 0 else True
        save_kwargs = dict(
            bigtiff=True, 
            photometric='minisblack', 
            resolution=(0.325, 0.325),
            tile=(1024, 1024),
            metadata=None,
            check_contrast=False
        )
        skimage.io.imsave(str(output_path), prob_wv, append=append, **save_kwargs)
        if idx == 1:
            preview_name = output_path.name.replace(
                f'_Probabilities_{nucleus_channel}.tif',
                f'_Preview_{nucleus_channel}.tif'
            )
            preview_path = output_path.parent / preview_name
            skimage.io.imsave(str(preview_path), prob_wv, append=False, **save_kwargs)
        if class_i == 0:
            img_wv = Parallel(n_jobs=-1, verbose=1)(delayed(wrap_resize)(
                i, (block_size, block_size)
            ) for i in img_wv)
            img_wv = wv_settings.reconstruct(np.array(img_wv))
            skimage.io.imsave(str(preview_path), img_wv, append=True, **save_kwargs)

    end_time = int(time.perf_counter())
    print('elapsed', datetime.timedelta(seconds=end_time-start_time))


import pathlib

# ome_tiffs = pathlib.Path(r'Z:\RareCyte-S3\YC-analysis\IHC_Tonsil_1269\extracted')
# ome_tiffs = sorted(ome_tiffs.glob('*.ome.tif'))
# ome_tiffs = [pathlib.Path(r'Z:\RareCyte-S3\YC-analysis\Lung_066-082\test.tif')]

model_path = pathlib.Path('./models/nucleiDAPILAMIN/')
UnMicst2.UNet2D.singleImageInferenceSetup(model_path, 0, -1, -1)

import csv
with open(r'Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round1\scripts-processing\file_list.csv') as file_config_csv:
    csv_reader = csv.DictReader(file_config_csv)
    file_config = [dict(row) for row in csv_reader]

input_dir = pathlib.Path(r'Z:\RareCyte-S3\P37_CRCstudy_Round1')

for c in file_config[:]:
    print('Processing', c['name'])
    test(
        img_path=str(input_dir / c['path']),
        channel=0,
        out_dir=r'Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round1', 
        out_name=c['name'],
        pixel_scale=0.325/0.65,
        subtract_bg=False,
        rescale_p0=5, rescale_p1=100,
        block_size=5000, block_overlap=200,
        adjust_gamma_value=0.6
    )

UnMicst2.UNet2D.singleImageInferenceCleanup()
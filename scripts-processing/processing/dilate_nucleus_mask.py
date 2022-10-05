import skimage.io
import pathlib
import numpy as np
from skimage.morphology import binary_dilation, disk, label
import rowit
from skimage.segmentation import watershed, clear_border
from joblib import Parallel, delayed

def watershed_dilated(mask, radius):
    return watershed(
        -mask, mask, mask=binary_dilation(mask>0, selem=disk(radius)),
        watershed_line=True
    ) > 0

def main(input_dir, dilation_radius=5):

    in_dir = pathlib.Path(input_dir)
    nucleiMask = skimage.io.imread(str(in_dir / 'nucleiMask.tif'))

    win_view_setting = rowit.WindowView(nucleiMask.shape, 2000, 500)
    nucleiMask = win_view_setting.window_view_list(nucleiMask)

    print(f'Number of jobs: {nucleiMask.shape[0]}')
    cellMask = np.array(
        Parallel(n_jobs=6, verbose=1)(delayed(watershed_dilated)(
            m, dilation_radius
        ) for m in nucleiMask)
    )
    cellMask = win_view_setting.reconstruct(cellMask)
    nucleiMask = win_view_setting.reconstruct(np.array(nucleiMask)) > 0

    import scipy.ndimage as ndi

    cellMask_out = np.empty_like(cellMask, np.int32)
    ndi.label(cellMask, output=cellMask_out)

    nucleiMask_out = np.empty_like(cellMask, np.int32)
    np.multiply(cellMask_out, nucleiMask, out=nucleiMask_out)

    del cellMask
    del nucleiMask


    win_view_setting_2 = rowit.WindowView(cellMask_out.shape, 5000, 0)
    nucleiMask_out = win_view_setting_2.window_view_list(nucleiMask_out)
    cellMask_out = win_view_setting_2.window_view_list(cellMask_out)
    passed = (
        Parallel(n_jobs=6, verbose=1)(delayed(np.unique)(b) 
            for b in nucleiMask_out
        )  
    )
    passed = np.unique(
        [i for p in passed for i in p]
    )

    cellMask_keep = np.array(
        Parallel(n_jobs=6, verbose=1)(delayed(np.isin)(cm, passed) 
            for cm in cellMask_out
        )
    )


    cellMask_keep = win_view_setting_2.reconstruct(cellMask_keep)
    cellMask_out = win_view_setting_2.reconstruct(np.array(cellMask_out))

    cellMask_out *= cellMask_keep
    del cellMask_keep
    ndi.label(cellMask_out > 0, output=cellMask_out)

    nucleiMask_out = win_view_setting_2.reconstruct(nucleiMask_out)
    nucleiMask_out = np.multiply(nucleiMask_out > 0, cellMask_out)

    kwargs = dict(
        bigtiff=True, 
        photometric='minisblack', 
        resolution=(0.325, 0.325), 
        metadata=None,
        check_contrast=False,
        tile=(1024, 1024),
    )

    skimage.io.imsave(str(in_dir / 'nucleiRingMask.tif'), nucleiMask_out, **kwargs)
    skimage.io.imsave(str(in_dir / 'cellRingMask.tif'), cellMask_out, **kwargs)


import csv

with open(r'Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round1\scripts-processing\file_list.csv') as file_config_csv:
    csv_reader = csv.DictReader(file_config_csv)
    file_config = [dict(row) for row in csv_reader]

ome_tiffs = [pathlib.Path(c['path']) for c in file_config]
ome_names = [n.stem.replace('.ome', '') for n in ome_tiffs]
slide_names = [pathlib.Path(c['name']) for c in file_config]

group_dir = pathlib.Path(r'Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round1')

segmentation_dirs = [
    group_dir / s_n / 'segmentation' / o_n
    for s_n, o_n in zip(slide_names, ome_names)
]

for s in segmentation_dirs[:]:
    print('Processing', s.name)
    main(s, dilation_radius=5)
    print()
import pandas as pd
import numpy as np

# c40_table = pd.read_csv('Celltable_C40B1.csv')

def grid_cat_size(
    df,
    grid_size=112,
    y_column_name='Yt',
    x_column_name='Xt',
    cat_column_name='Cat1'
):
    cat = df[cat_column_name].astype('category')
    categories = cat.cat.categories

    y_bins = np.arange(0, df[y_column_name].max()+grid_size, grid_size)
    x_bins = np.arange(0, df[x_column_name].max()+grid_size, grid_size)
    grid_cat_size = []
    for c in categories:
        sub_df = df[df[cat_column_name] == c]
        cut_y = pd.cut(sub_df[y_column_name], y_bins)
        cut_x = pd.cut(sub_df[x_column_name], x_bins)
        grid_cat_size_c = (
            sub_df
                .groupby([cut_y, cut_x])
                .size().values
                .reshape(len(y_bins)-1, -1)
        )
        grid_cat_size.append(grid_cat_size_c)
    return np.array(grid_cat_size)


def grid_group(
    df,
    grid_size=112,
    y_column_name='Yt',
    x_column_name='Xt',
    return_shape=False
):
    y_bins = np.arange(
        0, df[y_column_name].max()+grid_size, grid_size
    )
    x_bins = np.arange(
        0, df[x_column_name].max()+grid_size, grid_size
    )
    cut_y = pd.cut(df[y_column_name], y_bins)
    cut_x = pd.cut(df[x_column_name], x_bins)
    if return_shape:
        return (
            df.groupby([cut_y, cut_x]),
            np.array([len(y_bins), len(x_bins)]) - 1 
        )
    return df.groupby([cut_y, cut_x])


def grid_columns(
    df,
    grid_size=112,
    y_column_name='Yt',
    x_column_name='Xt',
    return_type='interval',
    grid_shape=None
):
    assert return_type in ['interval', 'ij', 'sequence']

    if grid_shape is None:
        nr = np.ceil(df[y_column_name].max() / grid_size)
        nc = np.ceil(df[x_column_name].max() / grid_size)
        grid_shape = (int(nr), int(nc))
    nr, nc = grid_shape
    # reason to +1: try `pd.cut([0.5], np.arange(1))`
    y_bins = np.arange(nr + 1) * grid_size
    x_bins = np.arange(nc + 1) * grid_size

    if return_type == 'interval':
        labels_r, labels_c = None, None
        column_text = 'interval'
    if return_type == 'ij' or return_type == 'sequence':
        labels_r = np.arange(nr)
        labels_c = np.arange(nc)
        column_text = 'idx'
    
    cut_y = pd.cut(df[y_column_name], y_bins, labels=labels_r)
    cut_x = pd.cut(df[x_column_name], x_bins, labels=labels_c)

    if return_type in ['interval', 'ij']:
        return pd.concat([cut_y, cut_x], axis=1).rename(columns={
            y_column_name: f"grid_row_{column_text}",
            x_column_name: f"grid_col_{column_text}"
        })
    else:
        return np.ravel_multi_index(
            np.asarray([cut_y, cut_x]),
            grid_shape
        )

def assign_patch_id_and_prediction():
    # add grid id and prediction result to each cell
    import plot_he_crc_100k_gt450_orion_p37_batch1 as p371
    import pathlib
    import pickle
    import matplotlib.pyplot as plt

    file_table = pd.read_csv(r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\he_crc_100k_gt450_orion_p37_batch1\densenet161-kather100k\sc_prediction.csv')

    for i in range(39, 42):
        target = file_table.iloc[i]
        csv = pathlib.Path(target['sc'])
        print('\nprocessing', csv.name)
        df = pd.read_csv(target['sc'])
        df.loc[:, 'Xt'] = df['X_centroid'] * 0.325
        df.loc[:, 'Yt'] = df['Y_centroid'] * 0.325

        grid_shape = target[['num_rows', 'num_cols']].astype(int)
        grid_ids = grid_columns(df, return_type='sequence', grid_shape=grid_shape)

        # orion
        orion = pickle.load(open(target['p_orion'], 'rb'))
        patch_idxs = np.ravel_multi_index(p371.patch_grid_idx(orion).T, grid_shape)
        
        indexer = np.zeros(np.prod(grid_shape))
        indexer[patch_idxs] = orion['predictions']
        orion_predictions = indexer[grid_ids]

        indexer = np.vstack([[1] + [0]*8] * np.prod(grid_shape)).astype(np.float32)
        indexer[patch_idxs] = orion['probabilities']
        orion_probs = indexer[grid_ids]

        # adjacent
        adjacent = pickle.load(open(target['p_adjacent'], 'rb'))
        patch_idxs = np.ravel_multi_index(p371.patch_grid_idx(adjacent).T, grid_shape)
        
        indexer = np.zeros(np.prod(grid_shape))
        indexer[patch_idxs] = adjacent['predictions']
        adjacent_predictions = indexer[grid_ids]

        indexer = np.vstack([[1] + [0]*8] * np.prod(grid_shape)).astype(np.float32)
        indexer[patch_idxs] = adjacent['probabilities']
        adjacent_probs = indexer[grid_ids]

        # make table for output
        out = pd.DataFrame()
        out.loc[:, 'patch_id'] = grid_ids.astype(np.int32)
        out.loc[:, 'prediction_orion'] = orion_predictions.astype(np.int8)
        out.loc[:, 'prediction_adjacent'] = adjacent_predictions.astype(np.int8)

        out.loc[:, [f"orion_probs_{i}" for i in range(9)]] = orion_probs.astype(np.float32)
        out.loc[:, [f"adjacent_probs_{i}" for i in range(9)]] = adjacent_probs.astype(np.float32)

        print('number of nan:', np.isnan(out.values).sum())

        out.iloc[:, :3].to_csv(
            pathlib.Path(r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\he_crc_100k_gt450_orion_p37_batch1\densenet161-kather100k\gamma-only\cell_class_table') / f"cell_class_{csv.parent.parent.parent.name.split('-')[1]}.csv"
        )
        fig, axs = plt.subplots(1, 2, sharex=True, sharey=True)
        fig.suptitle(csv.parent.parent.parent.name.split('-')[1])
        for ax, p in zip(axs.flatten(), [out.prediction_adjacent, out.prediction_orion]):
            ax.imshow([[0]])
            ax.scatter(df.Xt, df.Yt, s=1, linewidths=0, c=p, cmap='tab10', vmin=0, vmax=9)
        
        out.iloc[:, [0, *list(range(3, 21))]].to_csv(
            pathlib.Path(r'Y:\sorger\data\computation\Yu-An\YC-20220207-tiatoolbox_explore\he_crc_100k_gt450_orion_p37_batch1\densenet161-kather100k\gamma-only\cell_class_table') / f"cell_class_probs_{csv.parent.parent.parent.name.split('-')[1]}.csv"
        )

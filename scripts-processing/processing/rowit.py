import numpy as np
from skimage.util import view_as_windows, montage


class WindowView(object):

    def __init__(
        self, img_shape, block_size, overlap_size
    ):
        self.img_shape = img_shape
        self.block_size = block_size
        self.overlap_size = overlap_size

        self.step_size = block_size - overlap_size

    def window_view_list(self, img, pad_mode='constant'):
        half = int(self.overlap_size / 2)
        img = np.pad(img, (
            (half, self.padded_shape[0] - self.img_shape[0] - half), 
            (half, self.padded_shape[1] - self.img_shape[1] - half),
        ), mode=pad_mode)
        
        return self._window_view_list(img)
    
    def padding_mask(self):
        half = int(self.overlap_size / 2)
        padding_mask = np.ones(self.img_shape, dtype=np.bool)
        padding_mask = np.pad(padding_mask, (
            (half, self.padded_shape[0] - self.img_shape[0] - half), 
            (half, self.padded_shape[1] - self.img_shape[1] - half),
        ), mode='constant', constant_values=0)
        return self._window_view_list(padding_mask)

    def reconstruct(self, img_window_view_list):
        grid_shape = self.window_view_shape[:2]

        start = int(self.overlap_size / 2)
        end = int(self.block_size - start)

        img_window_view_list = img_window_view_list[..., start:end, start:end]

        return montage(
            img_window_view_list, grid_shape=grid_shape
        )[:self.img_shape[0], :self.img_shape[1]]
        
    @property
    def padded_shape(self):
        padded_shape = np.array(self.img_shape) + self.overlap_size
        n = np.ceil((padded_shape - self.block_size) / self.step_size)
        padded_shape = (self.block_size + (n * self.step_size)).astype(np.int)
        return tuple(padded_shape)

    @property 
    def window_view_shape(self):
        return view_as_windows(
            np.empty(self.padded_shape), 
            self.block_size, self.step_size
        ).shape

    def _window_view_list(self, img):
        return (
            view_as_windows(img, self.block_size, self.step_size)
                .reshape(-1, self.block_size, self.block_size)
        )

def crop_with_padding_mask(img, padding_mask, return_mask=False):
    if np.all(padding_mask == 1):
        return (img, padding_mask) if return_mask else img
    (r_s, r_e), (c_s, c_e) = [
        (i.min(), i.max() + 1)
        for i in np.where(padding_mask == 1)
    ]
    padded = np.zeros_like(img)
    img = img[r_s:r_e, c_s:c_e]
    padded[r_s:r_e, c_s:c_e] = 1
    return (img, padded) if return_mask else img
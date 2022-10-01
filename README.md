[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

# Multi-modal digital pathology for colorectal cancer diagnosis by high-plex immunofluorescence imaging and traditional histology of the same tissue section

Jia-Ren Lin<sup>1,2,</sup>\*,
Yu-An Chen<sup>1,2,</sup>\*,
Daniel Campton<sup>3,</sup>\*,
Jeremy Cooper<sup>3</sup>,
Shannon Coy<sup>1,4</sup>,
Clarence Yapp<sup>1,2</sup>,
Juliann B. Tefft<sup>1,2</sup>,
Erin McCarty<sup>3</sup>,
Keith L. Ligon<sup>4</sup>,
Scott J. Rodig<sup>4</sup>,
Steven Reese<sup>3</sup>,
Tad George<sup>3</sup>,
Sandro Santagata<sup>1,2,4,±</sup>,
Peter K. Sorger<sup>1,2,±</sup>

\* These authors contributed equally<br>
± These authors contributed equally

**Human Tissue Atlas Center** <br>
<sup>1</sup> Laboratory of Systems Pharmacology, Harvard Medical School, Boston, MA, 02115, USA.<br>
<sup>2</sup> Ludwig Center at Harvard, Harvard Medical School, Boston, MA 02115, USA.<br>
<sup>3</sup> RareCyte, Inc., 2601 Fourth Ave., Seattle, WA, 98121, USA.<br>
<sup>4</sup> Department of Pathology, Brigham and Women’s Hospital, Harvard Medical School, Boston, MA 02115, USA.<br>

---


## Scientific summary

![Summary figure](./docs/Orion_fig1a.png)

Precision medicine is critically dependent on better methods for diagnosing and staging disease and predicting drug response. Histopathology using Hematoxylin and Eosin (H&E) stained tissue - not genomics – remains the primary diagnostic modality in cancer. Moreover, recently developed, highly multiplexed tissue imaging represents a means of enhancing histology workflows with single cell mechanisms. Here we describe an approach for collecting and analyzing H&E and high-plex immunofluorescence (IF) images from the same cells in a whole-slide format suitable for translational and clinical research and eventual deployment in diagnosis. Using data from 40 human colorectal cancer resections (60 million cells) we show that IF and H&E images provide human experts and machine learning algorithms with complementary information. We demonstrate the automated generation and ranking of computational models, based either on immune infiltration or tumor-intrinsic features, that are highly predictive of progression-free survival. When these models are combined, a hazard ratio of ~0.045 is achieved, demonstrating the ability of multi-modal digital pathology to generate high-performance and interpretable biomarkers.

---


## Data availability

Full-resolution images, derived imaging data, and single-cell spatial feature tables will be released by the National Cancer Institute sponsored [repository for Human Tumor Atlas Network](https://htan-portal-nextjs.vercel.app/). While the public resource is still undergoing extensive development, we provided exemplar data via [Synapse]() for demonstration purposes. Light-weight image viewing for all the bio-specimens used in this study is made available using Minerva.


### Download exemplar data

Please follow the instructions provided by Synapse


### Image viewing using web browsers

Light-weight image viewing for all the bio-specimens used in this study is made available using Minerva. Visit https://labsyspharm.github.io/orion-crc to access the images.

---


## Codes for imaging data processing

Highplex Orion whole-slide images were processed using [MCMICRO](https://mcmicro.org/) modules with customizations to cope with the large X-Y dimension in the dataset. Registration of Orion immunofluorescence images and post-Orion H&E images was done with [PALOM](https://github.com/yu-anchen/palom).


### Scripts in the `scripts-processing/` folder

- asfsdf

---


## Codes for analyzing single-cell spatial analysis

Single-cell spatial analysis was performed using [MATLAB 2019b]((https://www.mathworks.com/products/matlab.html)). To run the provided scripts on your data, please contact authors for more details.

### Running the analysis and plotting scripts

asdfasdf

---


## Funding

This work was supported by NCI grants U54-CA225088 and U2C-CA233262 (PKS, SS), an NCI SBIR small business grant to RareCyte and PKS (R41-CA224503), and commercial investment from RareCyte; data processing software was developed with support from a Team Science Grant from the Gray Foundation and Ludwig Cancer Research (PKS, SS). SS is supported by the BWH President’s Scholars Award. 

---


## Demo

```matlab
%% Optimize ImmuneScore

markers = {'CD3','CD8','CD45','CD45RO','CD68','CD163','CD4','CD20','SMA'};
regions = {'R1','R2'};
figure;

for i = 1:length(markers)
    for j = 1:length(regions)
        subplot(3,6,(i-1)*length(regions)+j);
        marker1 = strcat('norm_',markers{i},regions{j});
        list1 = sumAllsample{:,marker1};
        list2 = sumAllsample.PFSDays;
        scatter(list1,list2,30,'b','fill');
        lsline;
        title(num2str(corr(list1,list2),'%0.2f'),'FontSize',16);
        set(gca,'xtick',[]);
        xlabel(marker1,'Interpreter','none');
        set(gca,'ytick',[]);
        ylabel('PFS Days');
    end
end
```
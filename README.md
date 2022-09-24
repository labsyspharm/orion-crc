[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
# Codes and sample data for "Multi-modal digital pathology for colorectal cancer diagnosis by high-plex immunofluorescence imaging and traditional histology of the same tissue section" could be found here: https://github.com/labsyspharm/orion-crc/
<br>
Jia-Ren Lin1,2,*, Yu-An Chen1,2,*, Daniel Campton3,*, Jeremy Cooper3, Shannon Coy1,4, Clarence Yapp1,2, Juliann B. Tefft1,2, Erin McCarty3, Keith L. Ligon4, Scott J. Rodig, Steven Reese3, Tad George3, Sandro Santagata1,2,4,±, Peter K. Sorger1,2,± 
<br>
* These authors contributed equally
± These authors contributed equally

**Human Tissue Atlas Center** <br>
**1** Laboratory of Systems Pharmacology, Harvard Medical School, Boston, MA, 02115, USA. 
**2** Ludwig Center at Harvard, Harvard Medical School, Boston, MA 02115, USA.
**3** RareCyte, Inc., 2601 Fourth Ave., Seattle, WA, 98121, USA.
**4** Department of Pathology, Brigham and Women’s Hospital, Harvard Medical School, Boston, MA 02115, USA.
<br>
<br>
<img src="./docs/Orion_fig1a.png" style="max-width:700px;width:100%" >
<br>
<br>
Precision medicine is critically dependent on better methods for diagnosing and staging disease and predicting drug response. Histopathology using Hematoxylin and Eosin (H&E) stained tissue - not genomics – remains the primary diagnostic modality in cancer. Moreover, recently developed, highly multiplexed tissue imaging represents a means of enhancing histology workflows with single cell mechanisms. Here we describe an approach for collecting and analyzing H&E and high-plex immunofluorescence (IF) images from the same cells in a whole-slide format suitable for translational and clinical research and eventual deployment in diagnosis. Using data from 40 human colorectal cancer resections (60 million cells) we show that IF and H&E images provide human experts and machine learning algorithms with complementary information. We demonstrate the automated generation and ranking of computational models, based either on immune infiltration or tumor-intrinsic features, that are highly predictive of progression-free survival. When these models are combined, a hazard ratio of ~0.045 is achieved, demonstrating the ability of multi-modal digital pathology to generate high-performance and interpretable biomarkers.
<br>
<br>
## System requirements 
**For imaging processing, please visit [mcmicro.org](https//mcmicro.org/) for details**
**MATLAB 2019b or above [mathworks.com/products/matlab](https://www.mathworks.com/products/matlab.html)**
<br>
## Installation guide
**1** Loading provided demo data <br>
**2** Run MATLAB scripts to generate each plots <br>
**Typical install time on a typical desktop isn't determined**
<br>
## Demo
```
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
<br>
## Instructions for use
To learn more about how to run the provided scripts on your data, please contact authors for details
<br>
<br>
## Funding
This work was supported by NCI grants U54-CA225088 and U2C-CA233262 (PKS, SS), an NCI SBIR small business grant to RareCyte and PKS (R41-CA224503), and commercial investment from RareCyte; data processing software was developed with support from a Team Science Grant from the Gray Foundation and Ludwig Cancer Research (PKS, SS). SS is supported by the BWH President’s Scholars Award. 

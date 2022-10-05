from subprocess import call
import time
import datetime

command = '''
python  c:/Users/Public/Downloads/S3segmenter/S3segmenter.py 
    --imagePath "{}" 
    --contoursClassProbPath "{}" 
    --nucleiClassProbPath "{}" 
    --probMapChan 0
    --crop dearray 
    --nucleiFilter {}
    --logSigma 5 60
    --segmentCytoplasm ignoreCytoplasm
    --cytoMethod ring 
    --cytoDilation 5 
    --outputPath {}
'''

import pathlib
import csv

with open(r'Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round1\scripts-processing\file_list.csv') as file_config_csv:
    csv_reader = csv.DictReader(file_config_csv)
    file_config = [dict(row) for row in csv_reader]

group_dir = pathlib.Path(r'Z:\RareCyte-S3\YC-analysis\P37_CRCstudy_Round1')
ome_dir = pathlib.Path(r'Z:\RareCyte-S3\P37_CRCstudy_Round1')

for c in file_config[:]:
    o = ome_dir / c['path']
    n = c['name']

    print('Processing', n)
    prob_path = str(group_dir / n / 'unmicst2' / f'{n}_Probabilities_0.tif')
    out_path = str(group_dir / n / 'segmentation')
    command_final = command.format(
        str(o),
        prob_path,
        prob_path,
        'IntPM',
        out_path
    )
    start_time = int(time.perf_counter())
    # print(command_final)
    call(' '.join(command_final.split()))
    end_time = int(time.perf_counter())

    print('elapsed', datetime.timedelta(seconds=end_time-start_time))
    print('')
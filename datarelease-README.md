# Access the full Orion CRC dataset

All images at full resolution, derived image data (e.g., segmentation masks),
and single-cell tables are stored and can be accessed through Amazon Web
Services (AWS) S3 once the publication is live.

AWS S3 bucket location

```bash
s3://lin-2023-orion-crc/data
```

Email tissue-atlas(at)hms.harvard.edu with the subject line "Orion-CRC: Data
Access" if you experience issues accessing the above S3 buckets.

*Note About Accessing AWS Data:*

To browse and download the data use either a graphical file transfer application
that supports S3 such as [CyberDuck](https://cyberduck.io), or the [AWS CLI
tools](https://aws.amazon.com/cli/). A graphical tool may be more convenient but
the CLI tools will likely offer higher download speeds. For users who wish to
perform processing within AWS, note that the bucket is located in the
`us-east-1` region so any other resources must be instantiated in this same
region.

---

## File organization

Each folder corresponds to a patient sample. The following files are available for each patient and are located on AWS.

| File Type            | Description                                                                                            |
| -------------------- | ------------------------------------------------------------------------------------------------------ |
| P*_S*.ome.tiff       | 19-channel Orion whole-slide-images (WSIs), in pyramidal format                                        |
| *-registered.ome.tif | H&E WSIs of the same tissue section of the corresponding Orion WSI                                     |
| cellRingMask.tif     | Labeled masks, each object in the mask represents a cell                                               |
| *_cellRingMask.csv   | Single-cell by feature tables generated by quantifying objects in the labeled mask with the Orion WSIs |
| markers.csv          | List of all markers/channel names/antibody target names in Orion WSIs                                  |

---

## File Lists

### Orion WSIs (19 channels)

| Patient | Folder name | File name                                                  | File size (GB) |
| :------ | :---------- | :--------------------------------------------------------- | :------------- |
| C1      | CRC01       | P37_S29_A24_C59kX_E15@20220106_014304_946511.ome.tiff      | 236.25         |
| C2      | CRC02       | P37_S30_A24_C59kX_E15@20220106_014319_409148.ome.tiff      | 148.43         |
| C3      | CRC03       | P37_S31_A24_C59kX_E15@20220106_014409_014236.ome.tiff      | 174.65         |
| C4      | CRC04       | P37_S32_A24_C59kX_E15@20220106_014630_553652.ome.tiff      | 193.25         |
| C5      | CRC05       | P37_S33_A24_C59kX_E15@20220107_180446_881530.ome.tiff      | 269.40         |
| C6      | CRC06       | P37_S34_A24_C59kX_E15@20220107_202112_212579.ome.tiff      | 179.47         |
| C7      | CRC07       | P37_S35_A24_C59kX_E15@20220108_012037_490594.ome.tiff      | 187.48         |
| C8      | CRC08       | P37_S57_Full_A24_C59nX_E15@20220224_011032_774034.ome.tiff | 158.03         |
| C9      | CRC09       | P37_S37_A24_C59kX_E15@20220108_012113_953544.ome.tiff      | 212.66         |
| C10     | CRC10       | P37_S38_A24_C59kX_E15@20220108_012130_664519.ome.tiff      | 128.07         |
| C11     | CRC11       | P37_S43_Full_A24_C59mX_E15@20220128_171510_544056.ome.tiff | 190.50         |
| C12     | CRC12       | P37_S44_Full_A24_C59mX_E15@20220128_171448_903938.ome.tiff | 200.11         |
| C13     | CRC13       | P37_S45_Full_A24_C59mX_E15@20220128_171409_633341.ome.tiff | 213.58         |
| C14     | CRC14       | P37_S46_Full_A24_C59mX_E15@20220128_013821_398547.ome.tiff | 270.87         |
| C15     | CRC15       | P37_S47_Full_A24_C59mX_E15@20220128_020654_901143.ome.tiff | 227.44         |
| C16     | CRC16       | P37_S48_Full_A24_C59mX_E15@20220129_015105_865195.ome.tiff | 296.06         |
| C17     | CRC17       | P37_S49_Full_A24_C59mX_E15@20220129_015121_911264.ome.tiff | 309.17         |
| C18     | CRC18       | P37_S50_Full_A24_C59mX_E15@20220129_015242_755602.ome.tiff | 256.81         |
| C19     | CRC19       | P37_S51_Full_A24_C59mX_E15@20220129_015300_669681.ome.tiff | 255.37         |
| C20     | CRC20       | P37_S52_Full_A24_C59mX_E15@20220129_015324_574779.ome.tiff | 273.03         |
| C21     | CRC21       | P37_S58_Full_A24_C59nX_E15@20220224_011058_014787.ome.tiff | 235.17         |
| C22     | CRC22       | P37_S59_Full_A24_C59nX_E15@20220224_011113_455637.ome.tiff | 259.88         |
| C23     | CRC23       | P37_S60_Full_A24_C59nX_E15@20220224_011127_971497.ome.tiff | 288.73         |
| C24     | CRC24       | P37_S61_Full_A24_C59nX_E15@20220224_011149_079291.ome.tiff | 281.00         |
| C25     | CRC25       | P37_S62_Full_A24_C59nX_E15@20220224_011204_784145.ome.tiff | 258.60         |
| C26     | CRC26       | P37_S63_Full_A24_C59nX_E15@20220224_011246_458738.ome.tiff | 221.78         |
| C27     | CRC27       | P37_S64_Full_A24_C59nX_E15@20220224_011259_841605.ome.tiff | 233.06         |
| C28     | CRC28       | P37_S65_Full_A24_C59nX_E15@20220224_011333_386280.ome.tiff | 199.19         |
| C29     | CRC29       | P37_S66_Full_A24_C59nX_E15@20220224_011348_519133.ome.tiff | 162.45         |
| C30     | CRC30       | P37_S67_Full_A24_C59nX_E15@20220224_011408_506939.ome.tiff | 236.65         |
| C31     | CRC31       | P37_S74_Full_A24_C59qX_E15@20220302_234837_137590.ome.tiff | 257.96         |
| C32     | CRC32       | P37_S75_Full_A24_C59qX_E15@20220302_235001_586560.ome.tiff | 248.20         |
| C33     | CRC33_01    | P37_S76_01_A24_C59qX_E15@20220302_235136_561323.ome.tiff   | 99.97          |
| C33     | CRC33_02    | P37_S76_02_A24_C59qX_E15@20220302_235158_533766.ome.tiff   | 111.65         |
| C34     | CRC34       | P37_S77_Full_A24_C59qX_E15@20220302_235222_359806.ome.tiff | 265.22         |
| C35     | CRC35       | P37_S78_Full_A24_C59qX_E15@20220302_235239_498836.ome.tiff | 230.75         |
| C36     | CRC36       | P37_S79_Full_A24_C59qX_E15@20220302_235254_496641.ome.tiff | 217.64         |
| C37     | CRC37       | P37_S80_Full_A24_C59qX_E15@20220307_235159_333000.ome.tiff | 295.86         |
| C38     | CRC38       | P37_S81_Full_A24_C59qX_E15@20220302_235331_704703.ome.tiff | 252.19         |
| C39     | CRC39       | P37_S82_Full_A24_C59qX_E15@20220304_200614_832683.ome.tiff | 222.62         |
| C40     | CRC40       | P37_S83_Full_A24_C59qX_E15@20220304_200429_490805.ome.tiff | 184.53         |

### H&E images (registered to their corresponding Orion WSIs)

| Patient | Folder name | File name                                                   | File size (GB) |
| :------ | :---------- | :---------------------------------------------------------- | :------------- |
| C1      | CRC01       | 18459$LSP10353$US$SCAN$OR$001 _093059-registered.ome.tif    | 14.51          |
| C2      | CRC02       | 18459$LSP10364$US$SCAN$OR$001 _092347-registered.ome.tif    | 9.34           |
| C3      | CRC03       | 18459$LSP10375$US$SCAN$OR$001 _092147-registered.ome.tif    | 10.87          |
| C4      | CRC04       | 18459$LSP10388$US$SCAN$OR$001 _091155-registered.ome.tif    | 12.11          |
| C5      | CRC05       | 18459$LSP10397$US$SCAN$OR$001 _091631-registered.ome.tif    | 16.80          |
| C6      | CRC06       | 18459$LSP10408$US$SCAN$OR$001 _092559-registered.ome.tif    | 11.21          |
| C7      | CRC07       | 18459$LSP10419$US$SCAN$OR$001 _090907-registered.ome.tif    | 11.68          |
| C8      | CRC08       | 19510$C8$US$SCAN$OR$001 _150825-registered.ome.tif          | 9.66           |
| C9      | CRC09       | 18459$LSP10441$US$SCAN$OR$001 _091844-registered.ome.tif    | 13.37          |
| C10     | CRC10       | 18459$LSP10452$US$SCAN$OR$001 _091355-registered.ome.tif    | 7.98           |
| C11     | CRC11       | 19510$C11$US$SCAN$OR$001 _151039-registered.ome.tif         | 12.03          |
| C12     | CRC12       | 19510$C12$US$SCAN$OR$001 _151249-registered.ome.tif         | 12.55          |
| C13     | CRC13       | 19510$C13$US$SCAN$OR$001 _151503-registered.ome.tif         | 13.20          |
| C14     | CRC14       | 19510$C14$US$SCAN$OR$001 _151737-registered.ome.tif         | 16.78          |
| C15     | CRC15       | 19510$C15$US$SCAN$OR$001 _152234-registered.ome.tif         | 14.19          |
| C16     | CRC16       | 19510$C16$US$SCAN$OR$001 _152020-registered.ome.tif         | 18.60          |
| C17     | CRC17       | 19510$C17$US$SCAN$OR$001 _152525-registered.ome.tif         | 19.40          |
| C18     | CRC18       | 19510$C18$US$SCAN$OR$001 _152757-registered.ome.tif         | 15.79          |
| C19     | CRC19       | 19510$C19$US$SCAN$OR$001 _153041-registered.ome.tif         | 16.11          |
| C20     | CRC20       | 19510$C20$US$SCAN$OR$001 _153341-registered.ome.tif         | 17.03          |
| C21     | CRC21       | 19510$C21$US$SCAN$OR$001 _153607-registered.ome.tif         | 14.64          |
| C22     | CRC22       | 19510$C22$US$SCAN$OR$001 _092420-registered.ome.tif         | 16.34          |
| C23     | CRC23       | 19510$C23$US$SCAN$OR$001 _154147-registered.ome.tif         | 18.10          |
| C24     | CRC24       | 19510$C24$US$SCAN$OR$001 _091904-registered.ome.tif         | 17.61          |
| C25     | CRC25       | 19510$C25$US$SCAN$OR$001 _154712-registered.ome.tif         | 15.99          |
| C26     | CRC26       | 19510$C26$US$SCAN$OR$001 _092131-registered.ome.tif         | 13.86          |
| C27     | CRC27       | 19510$C27$US$SCAN$OR$001 _155205-registered.ome.tif         | 14.55          |
| C28     | CRC28       | 19510$C28$US$SCAN$OR$001 _155413-registered.ome.tif         | 12.45          |
| C29     | CRC29       | 19510$C29$US$SCAN$OR$001 _155859-registered.ome.tif         | 10.18          |
| C30     | CRC30       | 19510$C30$US$SCAN$OR$001 _155702-registered.ome.tif         | 14.87          |
| C31     | CRC31       | 19510$C31$US$SCAN$OR$001 _160203-registered.ome.tif         | 16.24          |
| C32     | CRC32       | 19510$C32$US$SCAN$OR$001 _160434-registered.ome.tif         | 15.48          |
| C33     | CRC33_01    | 19510$C33$US$SCAN$OR$001 _160715-2-registered.ome.tif       | 6.28           |
| C33     | CRC33_02    | 19510$C33$US$SCAN$OR$001 _160715-registered.ome.tif         | 6.96           |
| C34     | CRC34       | 19510$C34$US$SCAN$OR$001 _160949-registered.ome.tif         | 16.62          |
| C35     | CRC35       | 19510$C35$US$SCAN$OR$001 _161209-registered.ome.tif         | 14.49          |
| C36     | CRC36       | 19510$C36$US$SCAN$OR$001 _161442-registered.ome.tif         | 13.58          |
| C37     | CRC37       | 19510$C37$US$SCAN$OR$001 _161733-registered.ome.tif         | 18.60          |
| C38     | CRC38       | 19510$C38$US$SCAN$OR$001 _162018-registered.ome.tif         | 15.59          |
| C39     | CRC39       | 19510$C39$US$SCAN$OR$001 _162343-registered.ome.tif         | 13.95          |
| C40     | CRC40       | 19510$P37-S83 C40$US$SCAN$OR$001 _163912-registered.ome.tif | 11.50          |

### Segmentation masks

| Patient | Folder name | File name        | File size (GB) |
| :------ | :---------- | :--------------- | :------------- |
| C1      | CRC01       | cellRingMask.tif | 18.41          |
| C2      | CRC02       | cellRingMask.tif | 11.68          |
| C3      | CRC03       | cellRingMask.tif | 13.59          |
| C4      | CRC04       | cellRingMask.tif | 15.15          |
| C5      | CRC05       | cellRingMask.tif | 20.99          |
| C6      | CRC06       | cellRingMask.tif | 14.00          |
| C7      | CRC07       | cellRingMask.tif | 14.59          |
| C8      | CRC08       | cellRingMask.tif | 12.27          |
| C9      | CRC09       | cellRingMask.tif | 16.71          |
| C10     | CRC10       | cellRingMask.tif | 9.98           |
| C11     | CRC11       | cellRingMask.tif | 15.03          |
| C12     | CRC12       | cellRingMask.tif | 15.69          |
| C13     | CRC13       | cellRingMask.tif | 16.76          |
| C14     | CRC14       | cellRingMask.tif | 21.29          |
| C15     | CRC15       | cellRingMask.tif | 17.75          |
| C16     | CRC16       | cellRingMask.tif | 23.25          |
| C17     | CRC17       | cellRingMask.tif | 24.24          |
| C18     | CRC18       | cellRingMask.tif | 20.04          |
| C19     | CRC19       | cellRingMask.tif | 20.13          |
| C20     | CRC20       | cellRingMask.tif | 21.28          |
| C21     | CRC21       | cellRingMask.tif | 18.29          |
| C22     | CRC22       | cellRingMask.tif | 20.43          |
| C23     | CRC23       | cellRingMask.tif | 22.62          |
| C24     | CRC24       | cellRingMask.tif | 22.00          |
| C25     | CRC25       | cellRingMask.tif | 20.30          |
| C26     | CRC26       | cellRingMask.tif | 17.34          |
| C27     | CRC27       | cellRingMask.tif | 18.18          |
| C28     | CRC28       | cellRingMask.tif | 15.56          |
| C29     | CRC29       | cellRingMask.tif | 12.73          |
| C30     | CRC30       | cellRingMask.tif | 18.57          |
| C31     | CRC31       | cellRingMask.tif | 20.28          |
| C32     | CRC32       | cellRingMask.tif | 19.36          |
| C33     | CRC33_01    | cellRingMask.tif | 7.85           |
| C33     | CRC33_02    | cellRingMask.tif | 8.70           |
| C34     | CRC34       | cellRingMask.tif | 20.76          |
| C35     | CRC35       | cellRingMask.tif | 18.10          |
| C36     | CRC36       | cellRingMask.tif | 16.97          |
| C37     | CRC37       | cellRingMask.tif | 23.25          |
| C38     | CRC38       | cellRingMask.tif | 19.80          |
| C39     | CRC39       | cellRingMask.tif | 17.44          |
| C40     | CRC40       | cellRingMask.tif | 14.39          |

### Single-cell tables

| Patient | Folder name | File name                                                          | File size (GB) |
| :------ | :---------- | :----------------------------------------------------------------- | :------------- |
| C1      | CRC01       | P37_S29_A24_C59kX_E15@20220106_014304_946511_cellRingMask.csv      | 0.81           |
| C2      | CRC02       | P37_S30_A24_C59kX_E15@20220106_014319_409148_cellRingMask.csv      | 0.63           |
| C3      | CRC03       | P37_S31_A24_C59kX_E15@20220106_014409_014236_cellRingMask.csv      | 1.02           |
| C4      | CRC04       | P37_S32_A24_C59kX_E15@20220106_014630_553652_cellRingMask.csv      | 0.91           |
| C5      | CRC05       | P37_S33_A24_C59kX_E15@20220107_180446_881530_cellRingMask.csv      | 0.44           |
| C6      | CRC06       | P37_S34_A24_C59kX_E15@20220107_202112_212579_cellRingMask.csv      | 0.55           |
| C7      | CRC07       | P37_S35_A24_C59kX_E15@20220108_012037_490594_cellRingMask.csv      | 0.51           |
| C8      | CRC08       | P37_S57_Full_A24_C59nX_E15@20220224_011032_774034_cellRingMask.csv | 0.58           |
| C9      | CRC09       | P37_S37_A24_C59kX_E15@20220108_012113_953544_cellRingMask.csv      | 0.59           |
| C10     | CRC10       | P37_S38_A24_C59kX_E15@20220108_012130_664519_cellRingMask.csv      | 0.71           |
| C11     | CRC11       | P37_S43_Full_A24_C59mX_E15@20220128_171510_544056_cellRingMask.csv | 0.51           |
| C12     | CRC12       | P37_S44_Full_A24_C59mX_E15@20220128_171448_903938_cellRingMask.csv | 0.36           |
| C13     | CRC13       | P37_S45_Full_A24_C59mX_E15@20220128_171409_633341_cellRingMask.csv | 0.72           |
| C14     | CRC14       | P37_S46_Full_A24_C59mX_E15@20220128_013821_398547_cellRingMask.csv | 0.74           |
| C15     | CRC15       | P37_S47_Full_A24_C59mX_E15@20220128_020654_901143_cellRingMask.csv | 0.92           |
| C16     | CRC16       | P37_S48_Full_A24_C59mX_E15@20220129_015105_865195_cellRingMask.csv | 1.39           |
| C17     | CRC17       | P37_S49_Full_A24_C59mX_E15@20220129_015121_911264_cellRingMask.csv | 1.83           |
| C18     | CRC18       | P37_S50_Full_A24_C59mX_E15@20220129_015242_755602_cellRingMask.csv | 1.08           |
| C19     | CRC19       | P37_S51_Full_A24_C59mX_E15@20220129_015300_669681_cellRingMask.csv | 0.74           |
| C20     | CRC20       | P37_S52_Full_A24_C59mX_E15@20220129_015324_574779_cellRingMask.csv | 1.20           |
| C21     | CRC21       | P37_S58_Full_A24_C59nX_E15@20220224_011058_014787_cellRingMask.csv | 0.67           |
| C22     | CRC22       | P37_S59_Full_A24_C59nX_E15@20220224_011113_455637_cellRingMask.csv | 0.66           |
| C23     | CRC23       | P37_S60_Full_A24_C59nX_E15@20220224_011127_971497_cellRingMask.csv | 1.12           |
| C24     | CRC24       | P37_S61_Full_A24_C59nX_E15@20220224_011149_079291_cellRingMask.csv | 0.99           |
| C25     | CRC25       | P37_S62_Full_A24_C59nX_E15@20220224_011204_784145_cellRingMask.csv | 0.21           |
| C26     | CRC26       | P37_S63_Full_A24_C59nX_E15@20220224_011246_458738_cellRingMask.csv | 0.76           |
| C27     | CRC27       | P37_S64_Full_A24_C59nX_E15@20220224_011259_841605_cellRingMask.csv | 0.94           |
| C28     | CRC28       | P37_S65_Full_A24_C59nX_E15@20220224_011333_386280_cellRingMask.csv | 0.73           |
| C29     | CRC29       | P37_S66_Full_A24_C59nX_E15@20220224_011348_519133_cellRingMask.csv | 1.00           |
| C30     | CRC30       | P37_S67_Full_A24_C59nX_E15@20220224_011408_506939_cellRingMask.csv | 0.42           |
| C31     | CRC31       | P37_S74_Full_A24_C59qX_E15@20220302_234837_137590_cellRingMask.csv | 0.60           |
| C32     | CRC32       | P37_S75_Full_A24_C59qX_E15@20220302_235001_586560_cellRingMask.csv | 0.50           |
| C33     | CRC33_01    | P37_S76_01_A24_C59qX_E15@20220302_235136_561323_cellRingMask.csv   | 0.22           |
| C33     | CRC33_02    | P37_S76_02_A24_C59qX_E15@20220302_235158_533766_cellRingMask.csv   | 0.29           |
| C34     | CRC34       | P37_S77_Full_A24_C59qX_E15@20220302_235222_359806_cellRingMask.csv | 1.49           |
| C35     | CRC35       | P37_S78_Full_A24_C59qX_E15@20220302_235239_498836_cellRingMask.csv | 0.92           |
| C36     | CRC36       | P37_S79_Full_A24_C59qX_E15@20220302_235254_496641_cellRingMask.csv | 0.73           |
| C37     | CRC37       | P37_S80_Full_A24_C59qX_E15@20220307_235159_333000_cellRingMask.csv | 1.05           |
| C38     | CRC38       | P37_S81_Full_A24_C59qX_E15@20220302_235331_704703_cellRingMask.csv | 1.38           |
| C39     | CRC39       | P37_S82_Full_A24_C59qX_E15@20220304_200614_832683_cellRingMask.csv | 0.83           |
| C40     | CRC40       | P37_S83_Full_A24_C59qX_E15@20220304_200429_490805_cellRingMask.csv | 1.05           |
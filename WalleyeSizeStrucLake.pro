PRO WalleyeSizeStrucLake
; to determine lake-specfic age structure of walleye

tstart = SYSTIME(/seconds)


; Identify a direcotry for exporting daily output of state variables as .csv file
CD, 'C:\Users\Daisuke\Desktop\Walleye outputs'; Directory; F:\SNS_SEIBM

; File location
; All lakes
file = FILEPATH('Walleye_growth_data_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; All lakes w/ length data only
;  ; Lakes w/ 4 or more years of data
;file = FILEPATH('WAE_growth_data_Select_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
; Lakes w/ 4 or more years of exploitation data
;file = FILEPATH('WAE_Growth_Expl_Data_Select_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
; Escanaba only
; length
;file = FILEPATH('WAE_growth_L_data_Escanaba_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
; weight
;file = FILEPATH('WAE_growth_W_data_Escanaba_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

; Check if the file is not blank
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Read the file
; Input file order
; (1) WBIC_Year (2) WBIC (3) SurveyYear (4) Age (5) FracAge (6) LengthMM (7) Sex

; Define the data structure
N = 107866L; all lakes
;N = 108814L; all lakes with covariates
;N = 26667L; Lakes w/ >4 years of data
;N = 16290L; Lakes w/ >4 years of exploitation data
Data_Final = DOUBLE(FLTARR(8L, N))

OPENR, lun, file, /GET_LUN
READF, lun, Data_Final;, FORMAT='(A17, x, I0)';
WBIC_Year = Data_Final[0, *]
WBIC = Data_Final[1, *]
SurveyYear = Data_Final[2, *]
Age = Data_Final[3, *]
FracAge = Data_Final[4, *]
Length = Data_Final[5, *]
;LengthMM = Data_Final[5, *]
Sex = Data_Final[6, *]
FishID = Data_Final[7, *]
FREE_LUN, lun


; Find unique lake-years
uniqWBIC_Year = WBIC_Year[UNIQ(WBIC_Year, SORT(WBIC_Year))]
PRINT, 'Total N of WBIC_years', n_elements(uniqWBIC_Year)

; Find unique lakes
uniqWBIC = WBIC[UNIQ(WBIC, SORT(WBIC))]
PRINT, 'Total N of WBICs', n_elements(uniqWBIC)


; Allocate an array for paramter outputs
paramset = FLTARR(156L, N_ELEMENTS(uniqWBIC)); an array for growth model parameters
WAE_size_age = FLTARR(409L, N_ELEMENTS(uniqWBIC)+1L); an array for mean size-at-age

WAE_size_age_all = FLTARR(198, max(SurveyYear)-min(SurveyYear)+1L)
;WAE_size_age_all = FLTARR(198, 40)
year = indgen(max(SurveyYear)-min(SurveyYear)+1L)+min(SurveyYear); an index for year

NumLengthBin = 37L; numebr of length bins in a default array (NEED TO CORRECT)
Nageclass = 28;
WAE_length_bin=fltarr(37*3L, N_ELEMENTS(uniqWBIC)*NumLengthBin + 37)

; Pooling by YEAR
;  For i = 0L, max(SurveyYear2)-min(SurveyYear2) do begin
;    INDEX_growthdata_ALL = WHERE(SurveyYear2[*] EQ year[i], INDEX_growthdata_allcount)
;
;    ;INDEX_growthdata = WHERE(WBIC_Year2[*] EQ uniqWBIC_Year[i], INDEX_growthdatacount)
;
;    ; arrays based on N of samples: all records > unique WBIC_year > unique WBIC
;    IF INDEX_growthdata_allcount GT 0 THEN BEGIN
;      Nageclass = INTARR(3L, INDEX_growthdata_allcount); subarray w/ unique WBIC_year only
;
;      ;   FOR ii = 0L, INDEX_growthdata_allcount-1L DO BEGIN
;      Numageclass = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL]), SORT(FIX(AGE[INDEX_growthdata_ALL]), /L64)))
;      Maxageclass = Max(AGE[INDEX_growthdata_ALL])
;      Minageclass = Min(AGE[INDEX_growthdata_ALL])
;
;
;      Length_Gro = Length2[INDEX_growthdata_ALL]
;      Age_Gro = Age2[INDEX_growthdata_ALL]
;      Sex_Gro = Sex2[INDEX_growthdata_ALL]
;
;      Male = WHERE(Sex_Gro eq 0, malecount)
;      Female = WHERE(Sex_Gro eq 1, femalecount)
;      unknown = WHERE(Sex_Gro eq 2, unknowncount)
;
;      IF malecouNt gt 0 then begin
;        NumageclassM = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL[male]]), SORT(FIX(AGE[INDEX_growthdata_ALL[male]]), /L64)))
;        MaxageclassM = Max(AGE[INDEX_growthdata_ALL[male]])
;        MinageclassM = Min(AGE[INDEX_growthdata_ALL[male]])
;      endif
;      if femalecount gt 0 then begin
;        NumageclassF = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL[female]]), SORT(FIX(AGE[INDEX_growthdata_ALL[female]]), /L64)))
;        MaxageclassF = Max(AGE[INDEX_growthdata_ALL[female]])
;        MinageclassF = Min(AGE[INDEX_growthdata_ALL[female]])
;      endif
;
;      ;paramset[0, i] = uniqWBIC_Year[i]
;      paramset[1, i] = N_ELEMENTS(Length_Gro)
;      ;paramset[2, i] = WBIC2[INDEX_growthdata_ALL[0]]
;      paramset[3, i] = SurveyYear2[INDEX_growthdata_ALL[0]]
;  ;   ENDFOR
;
;
;      ; All
;      age1 = WHERE((AGE[INDEX_growthdata_all] EQ 1), Age1count)
;      age2 = WHERE((AGE[INDEX_growthdata_all] EQ 2), AGE2count)
;      age3 = WHERE((AGE[INDEX_growthdata_all] EQ 3), AGE3count)
;      age4 = WHERE((AGE[INDEX_growthdata_all] EQ 4), AGE4count)
;      age5 = WHERE((AGE[INDEX_growthdata_all] EQ 5) , AGE5count)
;      age6 = WHERE((AGE[INDEX_growthdata_all] EQ 6) , AGE6count)
;      age7 = WHERE((AGE[INDEX_growthdata_all] EQ 7) , AGE7count)
;      age8 = WHERE((AGE[INDEX_growthdata_all] EQ 8), AGE8count)
;      age9 = WHERE((AGE[INDEX_growthdata_all] EQ 9), AGE9count)
;      age10 = WHERE((AGE[INDEX_growthdata_all] EQ 10), AGE10count)
;      age11 = WHERE((AGE[INDEX_growthdata_all] EQ 11) , AGE11count)
;      age12 = WHERE((AGE[INDEX_growthdata_all] EQ 12) , AGE12count)
;      age13 = WHERE((AGE[INDEX_growthdata_all] EQ 13), AGE13count)
;      ; Male
;      age1M = WHERE((AGE[INDEX_growthdata_all] EQ 1) AND (SEX[INDEX_growthdata_all] EQ 0), Age1Mcount)
;      age2M = WHERE((AGE[INDEX_growthdata_all] EQ 2) AND (SEX[INDEX_growthdata_all] EQ 0), AGE2Mcount)
;      age3M = WHERE((AGE[INDEX_growthdata_all] EQ 3) AND (SEX[INDEX_growthdata_all] EQ 0), AGE3Mcount)
;      age4M = WHERE((AGE[INDEX_growthdata_all] EQ 4) AND (SEX[INDEX_growthdata_all] EQ 0), AGE4Mcount)
;      age5M = WHERE((AGE[INDEX_growthdata_all] EQ 5) AND (SEX[INDEX_growthdata_all] EQ 0), AGE5Mcount)
;      age6M = WHERE((AGE[INDEX_growthdata_all] EQ 6) AND (SEX[INDEX_growthdata_all] EQ 0), AGE6Mcount)
;      age7M = WHERE((AGE[INDEX_growthdata_all] EQ 7) AND (SEX[INDEX_growthdata_all] EQ 0), AGE7Mcount)
;      age8M = WHERE((AGE[INDEX_growthdata_all] EQ 8) AND (SEX[INDEX_growthdata_all] EQ 0), AGE8Mcount)
;      age9M = WHERE((AGE[INDEX_growthdata_all] EQ 9) AND (SEX[INDEX_growthdata_all] EQ 0), AGE9Mcount)
;      age10M = WHERE((AGE[INDEX_growthdata_all] EQ 10) AND (SEX[INDEX_growthdata_all] EQ 0), AGE10Mcount)
;      age11M = WHERE((AGE[INDEX_growthdata_all] EQ 11) AND (SEX[INDEX_growthdata_all] EQ 0), AGE11Mcount)
;      age12M = WHERE((AGE[INDEX_growthdata_all] EQ 12) AND (SEX[INDEX_growthdata_all] EQ 0), AGE12Mcount)
;      age13M = WHERE((AGE[INDEX_growthdata_all] EQ 13) AND (SEX[INDEX_growthdata_all] EQ 0), AGE13Mcount)
;      ; Female
;      age1F = WHERE((AGE[INDEX_growthdata_all] EQ 1) AND (SEX[INDEX_growthdata_all] EQ 1), Age1Fcount)
;      age2F = WHERE((AGE[INDEX_growthdata_all] EQ 2) AND (SEX[INDEX_growthdata_all] EQ 1), AGE2Fcount)
;      age3F = WHERE((AGE[INDEX_growthdata_all] EQ 3) AND (SEX[INDEX_growthdata_all] EQ 1), AGE3Fcount)
;      age4F = WHERE((AGE[INDEX_growthdata_all] EQ 4) AND (SEX[INDEX_growthdata_all] EQ 1), AGE4Fcount)
;      age5F = WHERE((AGE[INDEX_growthdata_all] EQ 5) AND (SEX[INDEX_growthdata_all] EQ 1), AGE5Fcount)
;      age6F = WHERE((AGE[INDEX_growthdata_all] EQ 6) AND (SEX[INDEX_growthdata_all] EQ 1), AGE6Fcount)
;      age7F = WHERE((AGE[INDEX_growthdata_all] EQ 7) AND (SEX[INDEX_growthdata_all] EQ 1), AGE7Fcount)
;      age8F = WHERE((AGE[INDEX_growthdata_all] EQ 8) AND (SEX[INDEX_growthdata_all] EQ 1), AGE8Fcount)
;      age9F = WHERE((AGE[INDEX_growthdata_all] EQ 9) AND (SEX[INDEX_growthdata_all] EQ 1), AGE9Fcount)
;      age10F = WHERE((AGE[INDEX_growthdata_all] EQ 10) AND (SEX[INDEX_growthdata_all] EQ 1), AGE10Fcount)
;      age11F = WHERE((AGE[INDEX_growthdata_all] EQ 11) AND (SEX[INDEX_growthdata_all] EQ 1), AGE11Fcount)
;      age12F = WHERE((AGE[INDEX_growthdata_all] EQ 12) AND (SEX[INDEX_growthdata_all] EQ 1), AGE12Fcount)
;      age13F = WHERE((AGE[INDEX_growthdata_all] EQ 13) AND (SEX[INDEX_growthdata_all] EQ 1), AGE13Fcount)
;
;     ;WAE_size_age_all[0, ii] = 'All_annual'
;      ;WAE_size_age_all[1, ii] = 'All'
;      WAE_size_age_all[2, i] = year[i]
;
;      IF Age1Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[3, i] = MEAN(Length[INDEX_growthdata_all[age1M]])
;        WAE_size_age_all[4, i] = STDDEV(Length[INDEX_growthdata_all[age1M]])
;        WAE_size_age_all[5, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age1M]])
;        WAE_size_age_all[6, i] = MAX(Length[INDEX_growthdata_all[age1M]])
;        WAE_size_age_all[7, i] = MIN(Length[INDEX_growthdata_all[age1M]])
;      ENDIF
;      IF Age2Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[8, i] = MEAN(Length[INDEX_growthdata_all[age2M]])
;        WAE_size_age_all[9, i] = STDDEV(Length[INDEX_growthdata_all[age2M]])
;        WAE_size_age_all[10, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age2M]])
;        WAE_size_age_all[11, i] = MAX(Length[INDEX_growthdata_all[age2M]])
;        WAE_size_age_all[12, i] = MIN(Length[INDEX_growthdata_all[age2M]])
;      ENDIF
;      IF Age3Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[13, i] = MEAN(Length[INDEX_growthdata_all[age3M]])
;        WAE_size_age_all[14, i] = STDDEV(Length[INDEX_growthdata_all[age3M]])
;        WAE_size_age_all[15, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age4M]])
;        WAE_size_age_all[16, i] = MAX(Length[INDEX_growthdata_all[age3M]])
;        WAE_size_age_all[17, i] = MIN(Length[INDEX_growthdata_all[age3M]])
;      ENDIF
;      IF Age4Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[18, i] = MEAN(Length[INDEX_growthdata_all[age4M]])
;        WAE_size_age_all[19, i] = STDDEV(Length[INDEX_growthdata_all[age4M]])
;        WAE_size_age_all[20, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age4M]])
;        WAE_size_age_all[21, i] = MAX(Length[INDEX_growthdata_all[age4M]])
;        WAE_size_age_all[22, i] = MIN(Length[INDEX_growthdata_all[age4M]])
;      ENDIF
;       IF Age5Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[23, i] = MEAN(Length[INDEX_growthdata_all[age5M]])
;        WAE_size_age_all[24, i] = STDDEV(Length[INDEX_growthdata_all[age5M]])
;        WAE_size_age_all[25, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age5M]])
;        WAE_size_age_all[26, i] = MAX(Length[INDEX_growthdata_all[age5M]])
;        WAE_size_age_all[27, i] = MIN(Length[INDEX_growthdata_all[age5M]])
;      ENDIF
;      IF Age6Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[28, i] = MEAN(Length[INDEX_growthdata_all[age6M]])
;        WAE_size_age_all[29, i] = STDDEV(Length[INDEX_growthdata_all[age6M]])
;        WAE_size_age_all[30, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age6M]])
;        WAE_size_age_all[31, i] = MAX(Length[INDEX_growthdata_all[age6M]])
;        WAE_size_age_all[32, i] = MIN(Length[INDEX_growthdata_all[age6M]])
;      ENDIF
;       IF Age7Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[33, i] = MEAN(Length[INDEX_growthdata_all[age7M]])
;        WAE_size_age_all[34, i] = STDDEV(Length[INDEX_growthdata_all[age7M]])
;        WAE_size_age_all[35, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age7M]])
;        WAE_size_age_all[36, i] = MAX(Length[INDEX_growthdata_all[age7M]])
;        WAE_size_age_all[37, i] = MIN(Length[INDEX_growthdata_all[age7M]])
;      ENDIF
;      IF Age8Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[38, i] = MEAN(Length[INDEX_growthdata_all[age8M]])
;        WAE_size_age_all[39, i] = STDDEV(Length[INDEX_growthdata_all[age8M]])
;        WAE_size_age_all[40, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age8M]])
;        WAE_size_age_all[41, i] = MAX(Length[INDEX_growthdata_all[age8M]])
;        WAE_size_age_all[42, i] = MIN(Length[INDEX_growthdata_all[age8M]])
;      ENDIF
;      IF Age9Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[43, i] = MEAN(Length[INDEX_growthdata_all[age9M]])
;        WAE_size_age_all[44, i] = STDDEV(Length[INDEX_growthdata_all[age9M]])
;        WAE_size_age_all[45, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age9M]])
;        WAE_size_age_all[46, i] = MAX(Length[INDEX_growthdata_all[age9M]])
;        WAE_size_age_all[47, i] = MIN(Length[INDEX_growthdata_all[age9M]])
;      ENDIF
;      IF Age10Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[48, i] = MEAN(Length[INDEX_growthdata_all[age10M]])
;        WAE_size_age_all[49, i] = STDDEV(Length[INDEX_growthdata_all[age10M]])
;        WAE_size_age_all[50, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age10M]])
;        WAE_size_age_all[51, i] = MAX(Length[INDEX_growthdata_all[age10M]])
;        WAE_size_age_all[52, i] = MIN(Length[INDEX_growthdata_all[age10M]])
;      ENDIF
;      IF Age11Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[53, i] = MEAN(Length[INDEX_growthdata_all[age11M]])
;        WAE_size_age_all[54, i] = STDDEV(Length[INDEX_growthdata_all[age11M]])
;        WAE_size_age_all[55, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age11M]])
;        WAE_size_age_all[56, i] = MAX(Length[INDEX_growthdata_all[age11M]])
;        WAE_size_age_all[57, i] = MIN(Length[INDEX_growthdata_all[age11M]])
;      ENDIF
;      IF Age12Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[58, i] = MEAN(Length[INDEX_growthdata_all[age12M]])
;        WAE_size_age_all[59, i] = STDDEV(Length[INDEX_growthdata_all[age12M]])
;        WAE_size_age_all[60, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age12M]])
;        WAE_size_age_all[61, i] = MAX(Length[INDEX_growthdata_all[age12M]])
;        WAE_size_age_all[62, i] = MIN(Length[INDEX_growthdata_all[age12M]])
;      ENDIF
;      IF Age13Mcount GT 0. THEN BEGIN
;        WAE_size_age_all[63, i] = MEAN(Length[INDEX_growthdata_all[age13M]])
;        WAE_size_age_all[64, i] = STDDEV(Length[INDEX_growthdata_all[age13M]])
;        WAE_size_age_all[65, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age13M]])
;        WAE_size_age_all[66, i] = MAX(Length[INDEX_growthdata_all[age13M]])
;        WAE_size_age_all[67, i] = MIN(Length[INDEX_growthdata_all[age13M]])
;      ENDIF
;
;      ; Female
;      IF Age1Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[68, i] = MEAN(Length[INDEX_growthdata_all[age1F]])
;        WAE_size_age_all[69, i] = STDDEV(Length[INDEX_growthdata_all[age1F]])
;        WAE_size_age_all[70, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age1F]])
;        WAE_size_age_all[71, i] = MAX(Length[INDEX_growthdata_all[age1F]])
;        WAE_size_age_all[72, i] = MIN(Length[INDEX_growthdata_all[age1F]])
;      ENDIF
;      IF Age2Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[73, i] = MEAN(Length[INDEX_growthdata_all[age2F]])
;        WAE_size_age_all[74, i] = STDDEV(Length[INDEX_growthdata_all[age2F]])
;        WAE_size_age_all[75, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age2F]])
;        WAE_size_age_all[76, i] = MAX(Length[INDEX_growthdata_all[age2F]])
;        WAE_size_age_all[77, i] = MIN(Length[INDEX_growthdata_all[age2F]])
;      ENDIF
;      IF Age3Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[78, i] = MEAN(Length[INDEX_growthdata_all[age3F]])
;        WAE_size_age_all[79, i] = STDDEV(Length[INDEX_growthdata_all[age3F]])
;        WAE_size_age_all[80, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age3F]])
;        WAE_size_age_all[81, i] = MAX(Length[INDEX_growthdata_all[age3F]])
;        WAE_size_age_all[82, i] = MIN(Length[INDEX_growthdata_all[age3F]])
;      ENDIF
;      IF Age4Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[83, i] = MEAN(Length[INDEX_growthdata_all[age4F]])
;        WAE_size_age_all[84, i] = STDDEV(Length[INDEX_growthdata_all[age4F]])
;        WAE_size_age_all[85, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age4F]])
;        WAE_size_age_all[86, i] = MAX(Length[INDEX_growthdata_all[age4F]])
;        WAE_size_age_all[87, i] = MIN(Length[INDEX_growthdata_all[age4F]])
;      ENDIF
;       IF Age5Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[88, i] = MEAN(Length[INDEX_growthdata_all[age5F]])
;        WAE_size_age_all[89, i] = STDDEV(Length[INDEX_growthdata_all[age5F]])
;        WAE_size_age_all[90, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age5F]])
;        WAE_size_age_all[91, i] = MAX(Length[INDEX_growthdata_all[age5F]])
;        WAE_size_age_all[92, i] = MIN(Length[INDEX_growthdata_all[age5F]])
;      ENDIF
;      IF Age6Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[93, i] = MEAN(Length[INDEX_growthdata_all[age6F]])
;        WAE_size_age_all[94, i] = STDDEV(Length[INDEX_growthdata_all[age6F]])
;        WAE_size_age_all[95, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age6F]])
;        WAE_size_age_all[96, i] = MAX(Length[INDEX_growthdata_all[age6F]])
;        WAE_size_age_all[97, i] = MIN(Length[INDEX_growthdata_all[age6F]])
;      ENDIF
;       IF Age7Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[98, i] = MEAN(Length[INDEX_growthdata_all[age7F]])
;        WAE_size_age_all[99, i] = STDDEV(Length[INDEX_growthdata_all[age7F]])
;        WAE_size_age_all[100, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age7F]])
;        WAE_size_age_all[101, i] = MAX(Length[INDEX_growthdata_all[age7F]])
;        WAE_size_age_all[102, i] = MIN(Length[INDEX_growthdata_all[age7F]])
;      ENDIF
;      IF Age8Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[103, i] = MEAN(Length[INDEX_growthdata_all[age8F]])
;        WAE_size_age_all[104, i] = STDDEV(Length[INDEX_growthdata_all[age8F]])
;        WAE_size_age_all[105, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age8F]])
;        WAE_size_age_all[106, i] = MAX(Length[INDEX_growthdata_all[age8F]])
;        WAE_size_age_all[107, i] = MIN(Length[INDEX_growthdata_all[age8F]])
;      ENDIF
;      IF Age9Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[108, i] = MEAN(Length[INDEX_growthdata_all[age9F]])
;        WAE_size_age_all[109, i] = STDDEV(Length[INDEX_growthdata_all[age9F]])
;        WAE_size_age_all[110, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age9F]])
;        WAE_size_age_all[111, i] = MAX(Length[INDEX_growthdata_all[age9F]])
;        WAE_size_age_all[112, i] = MIN(Length[INDEX_growthdata_all[age9F]])
;      ENDIF
;      IF Age10Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[113, i] = MEAN(Length[INDEX_growthdata_all[age10F]])
;        WAE_size_age_all[114, i] = STDDEV(Length[INDEX_growthdata_all[age10F]])
;        WAE_size_age_all[115, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age10F]])
;        WAE_size_age_all[116, i] = MAX(Length[INDEX_growthdata_all[age10F]])
;        WAE_size_age_all[117, i] = MIN(Length[INDEX_growthdata_all[age10F]])
;      ENDIF
;      IF Age11Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[118, i] = MEAN(Length[INDEX_growthdata_all[age11F]])
;        WAE_size_age_all[119, i] = STDDEV(Length[INDEX_growthdata_all[age11F]])
;        WAE_size_age_all[120, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age11F]])
;        WAE_size_age_all[121, i] = MAX(Length[INDEX_growthdata_all[age11F]])
;        WAE_size_age_all[122, i] = MIN(Length[INDEX_growthdata_all[age11F]])
;      ENDIF
;      IF Age12Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[123, i] = MEAN(Length[INDEX_growthdata_all[age12F]])
;        WAE_size_age_all[124, i] = STDDEV(Length[INDEX_growthdata_all[age12F]])
;        WAE_size_age_all[125, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age12F]])
;        WAE_size_age_all[126, i] = MAX(Length[INDEX_growthdata_all[age12F]])
;        WAE_size_age_all[127, i] = MIN(Length[INDEX_growthdata_all[age12F]])
;      ENDIF
;      IF Age13Fcount GT 0. THEN BEGIN
;        WAE_size_age_all[128, i] = MEAN(Length[INDEX_growthdata_all[age13F]])
;        WAE_size_age_all[129, i] = STDDEV(Length[INDEX_growthdata_all[age13F]])
;        WAE_size_age_all[130, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age13F]])
;        WAE_size_age_all[131, i] = MAX(Length[INDEX_growthdata_all[age13F]])
;        WAE_size_age_all[132, i] = MIN(Length[INDEX_growthdata_all[age13F]])
;      ENDIF
;
;      ;all
;      IF Age1count GT 0. THEN BEGIN
;        WAE_size_age_all[133, i] = MEAN(Length[INDEX_growthdata_all[age1]])
;        WAE_size_age_all[134, i] = STDDEV(Length[INDEX_growthdata_all[age1]])
;        WAE_size_age_all[135, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age1]])
;        WAE_size_age_all[136, i] = MAX(Length[INDEX_growthdata_all[age1]])
;        WAE_size_age_all[137, i] = MIN(Length[INDEX_growthdata_all[age1]])
;      ENDIF
;      IF Age2count GT 0. THEN BEGIN
;        WAE_size_age_all[138, i] = MEAN(Length[INDEX_growthdata_all[age2]])
;        WAE_size_age_all[139, i] = STDDEV(Length[INDEX_growthdata_all[age2]])
;        WAE_size_age_all[140, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age2]])
;        WAE_size_age_all[141, i] = MAX(Length[INDEX_growthdata_all[age2]])
;        WAE_size_age_all[142, i] = MIN(Length[INDEX_growthdata_all[age2]])
;      ENDIF
;      IF Age3count GT 0. THEN BEGIN
;        WAE_size_age_all[143, i] = MEAN(Length[INDEX_growthdata_all[age3]])
;        WAE_size_age_all[144, i] = STDDEV(Length[INDEX_growthdata_all[age3]])
;        WAE_size_age_all[145, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age4]])
;        WAE_size_age_all[146, i] = MAX(Length[INDEX_growthdata_all[age3]])
;        WAE_size_age_all[147, i] = MIN(Length[INDEX_growthdata_all[age3]])
;      ENDIF
;      IF Age4count GT 0. THEN BEGIN
;        WAE_size_age_all[148, i] = MEAN(Length[INDEX_growthdata_all[age4]])
;        WAE_size_age_all[149, i] = STDDEV(Length[INDEX_growthdata_all[age4]])
;        WAE_size_age_all[150, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age4]])
;        WAE_size_age_all[151, i] = MAX(Length[INDEX_growthdata_all[age4]])
;        WAE_size_age_all[152, i] = MIN(Length[INDEX_growthdata_all[age4]])
;      ENDIF
;       IF Age5count GT 0. THEN BEGIN
;        WAE_size_age_all[153, i] = MEAN(Length[INDEX_growthdata_all[age5]])
;        WAE_size_age_all[154, i] = STDDEV(Length[INDEX_growthdata_all[age5]])
;        WAE_size_age_all[155, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age5]])
;        WAE_size_age_all[156, i] = MAX(Length[INDEX_growthdata_all[age5]])
;        WAE_size_age_all[157, i] = MIN(Length[INDEX_growthdata_all[age5]])
;      ENDIF
;      IF Age6count GT 0. THEN BEGIN
;        WAE_size_age_all[158, i] = MEAN(Length[INDEX_growthdata_all[age6]])
;        WAE_size_age_all[159, i] = STDDEV(Length[INDEX_growthdata_all[age6]])
;        WAE_size_age_all[160, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age6]])
;        WAE_size_age_all[161, i] = MAX(Length[INDEX_growthdata_all[age6]])
;        WAE_size_age_all[162, i] = MIN(Length[INDEX_growthdata_all[age6]])
;      ENDIF
;       IF Age7count GT 0. THEN BEGIN
;        WAE_size_age_all[163, i] = MEAN(Length[INDEX_growthdata_all[age7]])
;        WAE_size_age_all[164, i] = STDDEV(Length[INDEX_growthdata_all[age7]])
;        WAE_size_age_all[165, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age7]])
;        WAE_size_age_all[166, i] = MAX(Length[INDEX_growthdata_all[age7]])
;        WAE_size_age_all[167, i] = MIN(Length[INDEX_growthdata_all[age7]])
;      ENDIF
;      IF Age8count GT 0. THEN BEGIN
;        WAE_size_age_all[168, i] = MEAN(Length[INDEX_growthdata_all[age8]])
;        WAE_size_age_all[169, i] = STDDEV(Length[INDEX_growthdata_all[age8]])
;        WAE_size_age_all[170, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age8]])
;        WAE_size_age_all[171, i] = MAX(Length[INDEX_growthdata_all[age8]])
;        WAE_size_age_all[172, i] = MIN(Length[INDEX_growthdata_all[age8]])
;      ENDIF
;      IF Age9count GT 0. THEN BEGIN
;        WAE_size_age_all[173, i] = MEAN(Length[INDEX_growthdata_all[age9]])
;        WAE_size_age_all[174, i] = STDDEV(Length[INDEX_growthdata_all[age9]])
;        WAE_size_age_all[175, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age9]])
;        WAE_size_age_all[176, i] = MAX(Length[INDEX_growthdata_all[age9]])
;        WAE_size_age_all[177, i] = MIN(Length[INDEX_growthdata_all[age9]])
;      ENDIF
;      IF Age10count GT 0. THEN BEGIN
;        WAE_size_age_all[178, i] = MEAN(Length[INDEX_growthdata_all[age10]])
;        WAE_size_age_all[179, i] = STDDEV(Length[INDEX_growthdata_all[age10]])
;        WAE_size_age_all[170, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age10]])
;        WAE_size_age_all[181, i] = MAX(Length[INDEX_growthdata_all[age10]])
;        WAE_size_age_all[182, i] = MIN(Length[INDEX_growthdata_all[age10]])
;      ENDIF
;      IF Age11count GT 0. THEN BEGIN
;        WAE_size_age_all[183, i] = MEAN(Length[INDEX_growthdata_all[age11]])
;        WAE_size_age_all[184, i] = STDDEV(Length[INDEX_growthdata_all[age11]])
;        WAE_size_age_all[185, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age11]])
;        WAE_size_age_all[186, i] = MAX(Length[INDEX_growthdata_all[age11]])
;        WAE_size_age_all[187, i] = MIN(Length[INDEX_growthdata_all[age11]])
;      ENDIF
;      IF Age12count GT 0. THEN BEGIN
;        WAE_size_age_all[188, i] = MEAN(Length[INDEX_growthdata_all[age12]])
;        WAE_size_age_all[189, i] = STDDEV(Length[INDEX_growthdata_all[age12]])
;        WAE_size_age_all[190, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age12]])
;        WAE_size_age_all[191, i] = MAX(Length[INDEX_growthdata_all[age12]])
;        WAE_size_age_all[192, i] = MIN(Length[INDEX_growthdata_all[age12]])
;      ENDIF
;      IF Age13count GT 0. THEN BEGIN
;        WAE_size_age_all[193, i] = MEAN(Length[INDEX_growthdata_all[age13]])
;        WAE_size_age_all[194, i] = STDDEV(Length[INDEX_growthdata_all[age13]])
;        WAE_size_age_all[195, i] = N_ELEMENTS(Length[INDEX_growthdata_all[age13]])
;        WAE_size_age_all[196, i] = MAX(Length[INDEX_growthdata_all[age13]])
;        WAE_size_age_all[197, i] = MIN(Length[INDEX_growthdata_all[age13]])
;      ENDIF


; Loop through lakes (sequential WBICs)
FOR i = 0L, N_ELEMENTS(uniqWBIC)-1L DO BEGIN
  ; Index for unique WBIC-year walleye populations
  INDEX_growthdata = WHERE(WBIC[*] EQ uniqWBIC[i], INDEX_growthdatacount)
  ; WBIC2 - WBIC from the input data
  ; uniqWBIC - hypothetical WBICs created for loops
  ;paramset[22L, i] = INDEX_growthdatacount
  print,'Number of fish in each WBIC',INDEX_growthdatacount

  Nageclass = INTARR(3L, INDEX_growthdatacount); subarray w/ unique WBIC only
  ; arrays based on N of samples: all records > unique WBIC > unique WBIC

  ;    FOR ii = 0L, INDEX_growthdatacount-1L DO BEGIN
  ;    ENDFOR

  IF INDEX_growthdatacount GT 0 THEN BEGIN
    Numageclass = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata]), SORT(FIX(AGE[INDEX_growthdata]), /L64)))
    Maxageclass = Max(AGE[INDEX_growthdata])
    Minageclass = Min(AGE[INDEX_growthdata])

    Length_Gro = Length[INDEX_growthdata]
    Age_Gro = Age[INDEX_growthdata]
    Sex_Gro = Sex[INDEX_growthdata]

    PRINT, 'age_gro', age[index_growthdata]
    PRINT, 'length_gro', length[index_growthdata]

    Male = WHERE(Sex_Gro eq 0, malecount)
    Female = WHERE(Sex_Gro eq 1, femalecount)
    unknown = WHERE(Sex_Gro eq 2, unknowncount)

    ; age infomation for males
    IF malecouNt gt 0 then begin
      NumageclassM = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata[male]]), SORT(FIX(AGE[INDEX_growthdata[male]]), /L64)))
      MaxageclassM = Max(AGE[INDEX_growthdata[male]])
      MinageclassM = Min(AGE[INDEX_growthdata[male]])
    endif
    ; age information for females
    if femalecount gt 0 then begin
      NumageclassF = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata[female]]), SORT(FIX(AGE[INDEX_growthdata[female]]), /L64)))
      MaxageclassF = Max(AGE[INDEX_growthdata[female]])
      MinageclassF = Min(AGE[INDEX_growthdata[female]])
    endif

    paramset[0, i] = uniqWBIC[i]; WBIC
    paramset[1, i] = N_ELEMENTS(Length_Gro); N of fish
    paramset[2, i] = WBIC[INDEX_growthdata[0]]; WBIC
    paramset[3, i] = SurveyYear[INDEX_growthdata[0]]; year
    ;PRINT, 'Observed length', Length_Gro
    ;PRINT, 'Observed age', Age_Gro
    print, 'N of fish', paramset[1, i]
    print, 'WBIC', paramset[2, i]
    print, 'Year', paramset[3, i]
    print, 'Max length (mm)', Max(length[INDEX_growthdata])
    print, 'Min length (mm)', Min(length[INDEX_growthdata])
    print, 'Female max length (mm)', Max(length[INDEX_growthdata[female]])
    print, 'Female min length (mm)', Min(length[INDEX_growthdata[female]])
    print, 'Male max length (mm)', Max(length[INDEX_growthdata[male]])
    print, 'Male min length (mm)', Min(length[INDEX_growthdata[male]])


    ; Length group distributions - all fish
    SizeLT100 = WHERE(Length_Gro LT 100., SizeLT100count)
    Size100to120 = WHERE((Length_Gro GE 100.) AND (Length_Gro LT 120.), Size100to120count)
    Size120to140 = WHERE((Length_Gro GE 120.) AND (Length_Gro LT 140.), Size120to140count)
    Size140to160 = WHERE((Length_Gro GE 140.) AND (Length_Gro LT 160.), Size140to160count)
    Size160to180 = WHERE((Length_Gro GE 160.) AND (Length_Gro LT 180.), Size160to180count)
    Size180to200 = WHERE((Length_Gro GE 180.) AND (Length_Gro LT 200.), Size180to200count)
    Size200to220 = WHERE((Length_Gro GE 200.) AND (Length_Gro LT 220.), Size200to220count)
    Size220to240 = WHERE((Length_Gro GE 220.) AND (Length_Gro LT 240.), Size220to240count)
    Size240to260 = WHERE((Length_Gro GE 240.) AND (Length_Gro LT 260.), Size240to260count)
    Size260to280 = WHERE((Length_Gro GE 260.) AND (Length_Gro LT 280.), Size260to280count)
    Size280to300 = WHERE((Length_Gro GE 280.) AND (Length_Gro LT 300.), Size280to300count)
    Size300to320 = WHERE((Length_Gro GE 300.) AND (Length_Gro LT 320.), Size300to320count)
    Size320to340 = WHERE((Length_Gro GE 320.) AND (Length_Gro LT 340.), Size320to340count)
    Size340to360 = WHERE((Length_Gro GE 340.) AND (Length_Gro LT 360.), Size340to360count)
    Size360to380 = WHERE((Length_Gro GE 360.) AND (Length_Gro LT 380.), Size360to380count)
    Size380to400 = WHERE((Length_Gro GE 380.) AND (Length_Gro LT 400.), Size380to400count)
    Size400to420 = WHERE((Length_Gro GE 400.) AND (Length_Gro LT 420.), Size400to420count)
    Size420to440 = WHERE((Length_Gro GE 420.) AND (Length_Gro LT 440.), Size420to440count)
    Size440to460 = WHERE((Length_Gro GE 440.) AND (Length_Gro LT 460.), Size440to460count)
    Size460to480 = WHERE((Length_Gro GE 460.) AND (Length_Gro LT 480.), Size460to480count)
    Size480to500 = WHERE((Length_Gro GE 480.) AND (Length_Gro LT 500.), Size480to500count)
    Size500to520 = WHERE((Length_Gro GE 500.) AND (Length_Gro LT 520.), Size500to520count)
    Size520to540 = WHERE((Length_Gro GE 520.) AND (Length_Gro LT 540.), Size520to540count)
    Size540to560 = WHERE((Length_Gro GE 540.) AND (Length_Gro LT 560.), Size540to560count)
    Size560to580 = WHERE((Length_Gro GE 560.) AND (Length_Gro LT 580.), Size560to580count)
    Size580to600 = WHERE((Length_Gro GE 580.) AND (Length_Gro LT 600.), Size580to600count)
    Size600to620 = WHERE((Length_Gro GE 600.) AND (Length_Gro LT 620.), Size600to620count)
    Size620to640 = WHERE((Length_Gro GE 620.) AND (Length_Gro LT 640.), Size620to640count)
    Size640to660 = WHERE((Length_Gro GE 640.) AND (Length_Gro LT 660.), Size640to660count)
    Size660to680 = WHERE((Length_Gro GE 660.) AND (Length_Gro LT 680.), Size660to680count)
    Size680to700 = WHERE((Length_Gro GE 680.) AND (Length_Gro LT 700.), Size680to700count)
    Size700to720 = WHERE((Length_Gro GE 700.) AND (Length_Gro LT 720.), Size700to720count)
    Size720to740 = WHERE((Length_Gro GE 720.) AND (Length_Gro LT 740.), Size720to740count)
    Size740to760 = WHERE((Length_Gro GE 740.) AND (Length_Gro LT 760.), Size740to760count)
    Size760to780 = WHERE((Length_Gro GE 760.) AND (Length_Gro LT 780.), Size760to780count)
    Size780to800 = WHERE((Length_Gro GE 780.) AND (Length_Gro LT 800.), Size780to800count)
    SizeGE800 = WHERE((Length_Gro GE 800.), SizeGE800count)

    PRINT, 'i', i
    IF i EQ 0L THEN adj = 0
    IF i GT 1L THEN adj = 1

    WAE_length_bin[0, i*NumLengthBin+adj] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj] = 99
    WAE_length_bin[9, i*NumLengthBin+adj] = SizeLT100count

    ; length bin 1
    IF SizeLT100count GT 0 THEN BEGIN
      age0SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 0), Age0SizeLT100count)
      age1SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 1), Age1SizeLT100count)
      age2SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 2), AGE2SizeLT100count)
      age3SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 3), AGE3SizeLT100count)
      age4SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 4), AGE4SizeLT100count)
      age5SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 5), AGE5SizeLT100count)
      age6SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 6), AGE6SizeLT100count)
      age7SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 7), AGE7SizeLT100count)
      age8SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 8), AGE8SizeLT100count)
      age9SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 9), AGE9SizeLT100count)
      age10SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 10), AGE10SizeLT100count)
      age11SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 11), AGE11SizeLT100count)
      AGE12SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 12), AGE12SizeLT100count)
      AGE13SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 13), AGE13SizeLT100count)
      AGE14SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 14), AGE14SizeLT100count)
      AGE15SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 15), AGE15SizeLT100count)
      age16SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 16), Age16SizeLT100count)
      age17SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 17), AGE17SizeLT100count)
      age18SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 18), AGE18SizeLT100count)
      age19SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 19), AGE19SizeLT100count)
      age20SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 20), AGE20SizeLT100count)
      age21SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 21), AGE21SizeLT100count)
      age22SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 22), AGE22SizeLT100count)
      age23SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 23), AGE23SizeLT100count)
      age24SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 24), AGE24SizeLT100count)
      age25SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 25), AGE25SizeLT100count)
      age26SizeLT100 = WHERE((Age_Gro[SizeLT100] EQ 26), AGE26SizeLT100count)

      WAE_length_bin[10, i*NumLengthBin+adj] = Age0SizeLT100count
      WAE_length_bin[11, i*NumLengthBin+adj] = Age1SizeLT100count
      WAE_length_bin[12, i*NumLengthBin+adj] = Age2SizeLT100count
      WAE_length_bin[13, i*NumLengthBin+adj] = Age3SizeLT100count
      WAE_length_bin[14, i*NumLengthBin+adj] = Age4SizeLT100count
      WAE_length_bin[15, i*NumLengthBin+adj] = Age5SizeLT100count
      WAE_length_bin[16, i*NumLengthBin+adj] = Age6SizeLT100count
      WAE_length_bin[17, i*NumLengthBin+adj] = Age7SizeLT100count
      WAE_length_bin[18, i*NumLengthBin+adj] = Age8SizeLT100count
      WAE_length_bin[19, i*NumLengthBin+adj] = Age9SizeLT100count
      WAE_length_bin[20, i*NumLengthBin+adj] = Age10SizeLT100count
      WAE_length_bin[21, i*NumLengthBin+adj] = Age11SizeLT100count
      WAE_length_bin[22, i*NumLengthBin+adj] = Age12SizeLT100count
      WAE_length_bin[23, i*NumLengthBin+adj] = Age13SizeLT100count
      WAE_length_bin[24, i*NumLengthBin+adj] = Age14SizeLT100count
      WAE_length_bin[25, i*NumLengthBin+adj] = Age15SizeLT100count
      WAE_length_bin[26, i*NumLengthBin+adj] = Age16SizeLT100count
      WAE_length_bin[27, i*NumLengthBin+adj] = Age17SizeLT100count
      WAE_length_bin[28, i*NumLengthBin+adj] = Age18SizeLT100count
      WAE_length_bin[29, i*NumLengthBin+adj] = Age19SizeLT100count
      WAE_length_bin[30, i*NumLengthBin+adj] = Age20SizeLT100count
      WAE_length_bin[31, i*NumLengthBin+adj] = Age21SizeLT100count
      WAE_length_bin[32, i*NumLengthBin+adj] = Age22SizeLT100count
      WAE_length_bin[33, i*NumLengthBin+adj] = Age23SizeLT100count
      WAE_length_bin[34, i*NumLengthBin+adj] = Age24SizeLT100count
      WAE_length_bin[35, i*NumLengthBin+adj] = Age25SizeLT100count
      WAE_length_bin[36, i*NumLengthBin+adj] = Age26SizeLT100count
    ENDIF
    PRINT, 'SizeLT100', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj])


    WAE_length_bin[0, i*NumLengthBin+adj+1L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj+1L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+1L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+1L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+1L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+1L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+1L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+1L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+1L] = 100
    WAE_length_bin[9, i*NumLengthBin+adj+1L] = Size100to120count

    ; length bin 2
    IF Size100to120count GT 0 THEN BEGIN
      age0Size100to120 = WHERE((Age_Gro[Size100to120] EQ 0), Age0Size100to120count)
      age1Size100to120 = WHERE((Age_Gro[Size100to120] EQ 1), Age1Size100to120count)
      age2Size100to120 = WHERE((Age_Gro[Size100to120] EQ 2), AGE2Size100to120count)
      age3Size100to120 = WHERE((Age_Gro[Size100to120] EQ 3), AGE3Size100to120count)
      age4Size100to120 = WHERE((Age_Gro[Size100to120] EQ 4), AGE4Size100to120count)
      age5Size100to120 = WHERE((Age_Gro[Size100to120] EQ 5), AGE5Size100to120count)
      age6Size100to120 = WHERE((Age_Gro[Size100to120] EQ 6), AGE6Size100to120count)
      age7Size100to120 = WHERE((Age_Gro[Size100to120] EQ 7), AGE7Size100to120count)
      age8Size100to120 = WHERE((Age_Gro[Size100to120] EQ 8), AGE8Size100to120count)
      age9Size100to120 = WHERE((Age_Gro[Size100to120] EQ 9), AGE9Size100to120count)
      age10Size100to120 = WHERE((Age_Gro[Size100to120] EQ 10), AGE10Size100to120count)
      age11Size100to120 = WHERE((Age_Gro[Size100to120] EQ 11), AGE11Size100to120count)
      AGE12Size100to120 = WHERE((Age_Gro[Size100to120] EQ 12), AGE12Size100to120count)
      AGE13Size100to120 = WHERE((Age_Gro[Size100to120] EQ 13), AGE13Size100to120count)
      AGE14Size100to120 = WHERE((Age_Gro[Size100to120] EQ 14), AGE14Size100to120count)
      AGE15Size100to120 = WHERE((Age_Gro[Size100to120] EQ 15), AGE15Size100to120count)
      age16Size100to120 = WHERE((Age_Gro[Size100to120] EQ 16), Age16Size100to120count)
      age17Size100to120 = WHERE((Age_Gro[Size100to120] EQ 17), AGE17Size100to120count)
      age18Size100to120 = WHERE((Age_Gro[Size100to120] EQ 18), AGE18Size100to120count)
      age19Size100to120 = WHERE((Age_Gro[Size100to120] EQ 19), AGE19Size100to120count)
      age20Size100to120 = WHERE((Age_Gro[Size100to120] EQ 20), AGE20Size100to120count)
      age21Size100to120 = WHERE((Age_Gro[Size100to120] EQ 21), AGE21Size100to120count)
      age22Size100to120 = WHERE((Age_Gro[Size100to120] EQ 22), AGE22Size100to120count)
      age23Size100to120 = WHERE((Age_Gro[Size100to120] EQ 23), AGE23Size100to120count)
      age24Size100to120 = WHERE((Age_Gro[Size100to120] EQ 24), AGE24Size100to120count)
      age25Size100to120 = WHERE((Age_Gro[Size100to120] EQ 25), AGE25Size100to120count)
      age26Size100to120 = WHERE((Age_Gro[Size100to120] EQ 26), AGE26Size100to120count)

      WAE_length_bin[10, i*NumLengthBin+adj+1L] = Age0Size100to120count
      WAE_length_bin[11, i*NumLengthBin+adj+1L] = Age1Size100to120count
      WAE_length_bin[12, i*NumLengthBin+adj+1L] = Age2Size100to120count
      WAE_length_bin[13, i*NumLengthBin+adj+1L] = Age3Size100to120count
      WAE_length_bin[14, i*NumLengthBin+adj+1L] = Age4Size100to120count
      WAE_length_bin[15, i*NumLengthBin+adj+1L] = Age5Size100to120count
      WAE_length_bin[16, i*NumLengthBin+adj+1L] = Age6Size100to120count
      WAE_length_bin[17, i*NumLengthBin+adj+1L] = Age7Size100to120count
      WAE_length_bin[18, i*NumLengthBin+adj+1L] = Age8Size100to120count
      WAE_length_bin[19, i*NumLengthBin+adj+1L] = Age9Size100to120count
      WAE_length_bin[20, i*NumLengthBin+adj+1L] = Age10Size100to120count
      WAE_length_bin[21, i*NumLengthBin+adj+1L] = Age11Size100to120count
      WAE_length_bin[22, i*NumLengthBin+adj+1L] = Age12Size100to120count
      WAE_length_bin[23, i*NumLengthBin+adj+1L] = Age13Size100to120count
      WAE_length_bin[24, i*NumLengthBin+adj+1L] = Age14Size100to120count
      WAE_length_bin[25, i*NumLengthBin+adj+1L] = Age15Size100to120count
      WAE_length_bin[26, i*NumLengthBin+adj+1L] = Age16Size100to120count
      WAE_length_bin[27, i*NumLengthBin+adj+1L] = Age17Size100to120count
      WAE_length_bin[28, i*NumLengthBin+adj+1L] = Age18Size100to120count
      WAE_length_bin[29, i*NumLengthBin+adj+1L] = Age19Size100to120count
      WAE_length_bin[30, i*NumLengthBin+adj+1L] = Age20Size100to120count
      WAE_length_bin[31, i*NumLengthBin+adj+1L] = Age21Size100to120count
      WAE_length_bin[32, i*NumLengthBin+adj+1L] = Age22Size100to120count
      WAE_length_bin[33, i*NumLengthBin+adj+1L] = Age23Size100to120count
      WAE_length_bin[34, i*NumLengthBin+adj+1L] = Age24Size100to120count
      WAE_length_bin[35, i*NumLengthBin+adj+1L] = Age25Size100to120count
      WAE_length_bin[36, i*NumLengthBin+adj+1L] = Age26Size100to120count
    ENDIF
    PRINT, 'Size100to120', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+1L])


    WAE_length_bin[0, i*NumLengthBin+adj+2L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj+2L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+2L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+2L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+2L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+2L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+2L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+2L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+2L] = 120
    WAE_length_bin[9, i*NumLengthBin+adj+2L] = Size120to140count

    ; length bin 3
    IF Size120to140count GT 0 THEN BEGIN
      age0Size120to140 = WHERE((Age_Gro[Size120to140] EQ 0), Age0Size120to140count)
      age1Size120to140 = WHERE((Age_Gro[Size120to140] EQ 1), Age1Size120to140count)
      age2Size120to140 = WHERE((Age_Gro[Size120to140] EQ 2), AGE2Size120to140count)
      age3Size120to140 = WHERE((Age_Gro[Size120to140] EQ 3), AGE3Size120to140count)
      age4Size120to140 = WHERE((Age_Gro[Size120to140] EQ 4), AGE4Size120to140count)
      age5Size120to140 = WHERE((Age_Gro[Size120to140] EQ 5), AGE5Size120to140count)
      age6Size120to140 = WHERE((Age_Gro[Size120to140] EQ 6), AGE6Size120to140count)
      age7Size120to140 = WHERE((Age_Gro[Size120to140] EQ 7), AGE7Size120to140count)
      age8Size120to140 = WHERE((Age_Gro[Size120to140] EQ 8), AGE8Size120to140count)
      age9Size120to140 = WHERE((Age_Gro[Size120to140] EQ 9), AGE9Size120to140count)
      age10Size120to140 = WHERE((Age_Gro[Size120to140] EQ 10), AGE10Size120to140count)
      age11Size120to140 = WHERE((Age_Gro[Size120to140] EQ 11), AGE11Size120to140count)
      AGE12Size120to140 = WHERE((Age_Gro[Size120to140] EQ 12), AGE12Size120to140count)
      AGE13Size120to140 = WHERE((Age_Gro[Size120to140] EQ 13), AGE13Size120to140count)
      AGE14Size120to140 = WHERE((Age_Gro[Size120to140] EQ 14), AGE14Size120to140count)
      AGE15Size120to140 = WHERE((Age_Gro[Size120to140] EQ 15), AGE15Size120to140count)
      age16Size120to140 = WHERE((Age_Gro[Size120to140] EQ 16), Age16Size120to140count)
      age17Size120to140 = WHERE((Age_Gro[Size120to140] EQ 17), AGE17Size120to140count)
      age18Size120to140 = WHERE((Age_Gro[Size120to140] EQ 18), AGE18Size120to140count)
      age19Size120to140 = WHERE((Age_Gro[Size120to140] EQ 19), AGE19Size120to140count)
      age20Size120to140 = WHERE((Age_Gro[Size120to140] EQ 20), AGE20Size120to140count)
      age21Size120to140 = WHERE((Age_Gro[Size120to140] EQ 21), AGE21Size120to140count)
      age22Size120to140 = WHERE((Age_Gro[Size120to140] EQ 22), AGE22Size120to140count)
      age23Size120to140 = WHERE((Age_Gro[Size120to140] EQ 23), AGE23Size120to140count)
      age24Size120to140 = WHERE((Age_Gro[Size120to140] EQ 24), AGE24Size120to140count)
      age25Size120to140 = WHERE((Age_Gro[Size120to140] EQ 25), AGE25Size120to140count)
      age26Size120to140 = WHERE((Age_Gro[Size120to140] EQ 26), AGE26Size120to140count)

      WAE_length_bin[10, i*NumLengthBin+adj+2L] = Age0Size120to140count
      WAE_length_bin[11, i*NumLengthBin+adj+2L] = Age1Size120to140count
      WAE_length_bin[12, i*NumLengthBin+adj+2L] = Age2Size120to140count
      WAE_length_bin[13, i*NumLengthBin+adj+2L] = Age3Size120to140count
      WAE_length_bin[14, i*NumLengthBin+adj+2L] = Age4Size120to140count
      WAE_length_bin[15, i*NumLengthBin+adj+2L] = Age5Size120to140count
      WAE_length_bin[16, i*NumLengthBin+adj+2L] = Age6Size120to140count
      WAE_length_bin[17, i*NumLengthBin+adj+2L] = Age7Size120to140count
      WAE_length_bin[18, i*NumLengthBin+adj+2L] = Age8Size120to140count
      WAE_length_bin[19, i*NumLengthBin+adj+2L] = Age9Size120to140count
      WAE_length_bin[20, i*NumLengthBin+adj+2L] = Age10Size120to140count
      WAE_length_bin[21, i*NumLengthBin+adj+2L] = Age11Size120to140count
      WAE_length_bin[22, i*NumLengthBin+adj+2L] = Age12Size120to140count
      WAE_length_bin[23, i*NumLengthBin+adj+2L] = Age13Size120to140count
      WAE_length_bin[24, i*NumLengthBin+adj+2L] = Age14Size120to140count
      WAE_length_bin[25, i*NumLengthBin+adj+2L] = Age15Size120to140count
      WAE_length_bin[26, i*NumLengthBin+adj+2L] = Age16Size120to140count
      WAE_length_bin[27, i*NumLengthBin+adj+2L] = Age17Size120to140count
      WAE_length_bin[28, i*NumLengthBin+adj+2L] = Age18Size120to140count
      WAE_length_bin[29, i*NumLengthBin+adj+2L] = Age19Size120to140count
      WAE_length_bin[30, i*NumLengthBin+adj+2L] = Age20Size120to140count
      WAE_length_bin[31, i*NumLengthBin+adj+2L] = Age21Size120to140count
      WAE_length_bin[32, i*NumLengthBin+adj+2L] = Age22Size120to140count
      WAE_length_bin[33, i*NumLengthBin+adj+2L] = Age23Size120to140count
      WAE_length_bin[34, i*NumLengthBin+adj+2L] = Age24Size120to140count
      WAE_length_bin[35, i*NumLengthBin+adj+2L] = Age25Size120to140count
      WAE_length_bin[36, i*NumLengthBin+adj+2L] = Age26Size120to140count
    ENDIF
    PRINT, 'Size120to140', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+2L])


    WAE_length_bin[0, i*NumLengthBin+adj+3L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj+3L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+3L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+3L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+3L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+3L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+3L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+3L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+3L] = 140
    WAE_length_bin[9, i*NumLengthBin+adj+3L] = Size140to160count

    ; length bin 4
    IF Size140to160count GT 0 THEN BEGIN
      age0Size140to160 = WHERE((Age_Gro[Size140to160] EQ 0), Age0Size140to160count)
      age1Size140to160 = WHERE((Age_Gro[Size140to160] EQ 1), Age1Size140to160count)
      age2Size140to160 = WHERE((Age_Gro[Size140to160] EQ 2), AGE2Size140to160count)
      age3Size140to160 = WHERE((Age_Gro[Size140to160] EQ 3), AGE3Size140to160count)
      age4Size140to160 = WHERE((Age_Gro[Size140to160] EQ 4), AGE4Size140to160count)
      age5Size140to160 = WHERE((Age_Gro[Size140to160] EQ 5), AGE5Size140to160count)
      age6Size140to160 = WHERE((Age_Gro[Size140to160] EQ 6), AGE6Size140to160count)
      age7Size140to160 = WHERE((Age_Gro[Size140to160] EQ 7), AGE7Size140to160count)
      age8Size140to160 = WHERE((Age_Gro[Size140to160] EQ 8), AGE8Size140to160count)
      age9Size140to160 = WHERE((Age_Gro[Size140to160] EQ 9), AGE9Size140to160count)
      age10Size140to160 = WHERE((Age_Gro[Size140to160] EQ 10), AGE10Size140to160count)
      age11Size140to160 = WHERE((Age_Gro[Size140to160] EQ 11), AGE11Size140to160count)
      AGE12Size140to160 = WHERE((Age_Gro[Size140to160] EQ 12), AGE12Size140to160count)
      AGE13Size140to160 = WHERE((Age_Gro[Size140to160] EQ 13), AGE13Size140to160count)
      AGE14Size140to160 = WHERE((Age_Gro[Size140to160] EQ 14), AGE14Size140to160count)
      AGE15Size140to160 = WHERE((Age_Gro[Size140to160] EQ 15), AGE15Size140to160count)
      age16Size140to160 = WHERE((Age_Gro[Size140to160] EQ 16), Age16Size140to160count)
      age17Size140to160 = WHERE((Age_Gro[Size140to160] EQ 17), AGE17Size140to160count)
      age18Size140to160 = WHERE((Age_Gro[Size140to160] EQ 18), AGE18Size140to160count)
      age19Size140to160 = WHERE((Age_Gro[Size140to160] EQ 19), AGE19Size140to160count)
      age20Size140to160 = WHERE((Age_Gro[Size140to160] EQ 20), AGE20Size140to160count)
      age21Size140to160 = WHERE((Age_Gro[Size140to160] EQ 21), AGE21Size140to160count)
      age22Size140to160 = WHERE((Age_Gro[Size140to160] EQ 22), AGE22Size140to160count)
      age23Size140to160 = WHERE((Age_Gro[Size140to160] EQ 23), AGE23Size140to160count)
      age24Size140to160 = WHERE((Age_Gro[Size140to160] EQ 24), AGE24Size140to160count)
      age25Size140to160 = WHERE((Age_Gro[Size140to160] EQ 25), AGE25Size140to160count)
      age26Size140to160 = WHERE((Age_Gro[Size140to160] EQ 26), AGE26Size140to160count)

      WAE_length_bin[10, i*NumLengthBin+adj+3L] = Age0Size140to160count
      WAE_length_bin[11, i*NumLengthBin+adj+3L] = Age1Size140to160count
      WAE_length_bin[12, i*NumLengthBin+adj+3L] = Age2Size140to160count
      WAE_length_bin[13, i*NumLengthBin+adj+3L] = Age3Size140to160count
      WAE_length_bin[14, i*NumLengthBin+adj+3L] = Age4Size140to160count
      WAE_length_bin[15, i*NumLengthBin+adj+3L] = Age5Size140to160count
      WAE_length_bin[16, i*NumLengthBin+adj+3L] = Age6Size140to160count
      WAE_length_bin[17, i*NumLengthBin+adj+3L] = Age7Size140to160count
      WAE_length_bin[18, i*NumLengthBin+adj+3L] = Age8Size140to160count
      WAE_length_bin[19, i*NumLengthBin+adj+3L] = Age9Size140to160count
      WAE_length_bin[20, i*NumLengthBin+adj+3L] = Age10Size140to160count
      WAE_length_bin[21, i*NumLengthBin+adj+3L] = Age11Size140to160count
      WAE_length_bin[22, i*NumLengthBin+adj+3L] = Age12Size140to160count
      WAE_length_bin[23, i*NumLengthBin+adj+3L] = Age13Size140to160count
      WAE_length_bin[24, i*NumLengthBin+adj+3L] = Age14Size140to160count
      WAE_length_bin[25, i*NumLengthBin+adj+3L] = Age15Size140to160count
      WAE_length_bin[26, i*NumLengthBin+adj+3L] = Age16Size140to160count
      WAE_length_bin[27, i*NumLengthBin+adj+3L] = Age17Size140to160count
      WAE_length_bin[28, i*NumLengthBin+adj+3L] = Age18Size140to160count
      WAE_length_bin[29, i*NumLengthBin+adj+3L] = Age19Size140to160count
      WAE_length_bin[30, i*NumLengthBin+adj+3L] = Age20Size140to160count
      WAE_length_bin[31, i*NumLengthBin+adj+3L] = Age21Size140to160count
      WAE_length_bin[32, i*NumLengthBin+adj+3L] = Age22Size140to160count
      WAE_length_bin[33, i*NumLengthBin+adj+3L] = Age23Size140to160count
      WAE_length_bin[34, i*NumLengthBin+adj+3L] = Age24Size140to160count
      WAE_length_bin[35, i*NumLengthBin+adj+3L] = Age25Size140to160count
      WAE_length_bin[36, i*NumLengthBin+adj+3L] = Age26Size140to160count
    ENDIF
    PRINT, 'Size140to160', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+3L])


    WAE_length_bin[0, i*NumLengthBin+adj+4L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj+4L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+4L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+4L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+4L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+4L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+4L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+4L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+4L] = 160
    WAE_length_bin[9, i*NumLengthBin+adj+4L] = Size160to180count

    ; length bin 5
    IF Size160to180count GT 0 THEN BEGIN
      age0Size160to180 = WHERE((Age_Gro[Size160to180] EQ 0), Age0Size160to180count)
      age1Size160to180 = WHERE((Age_Gro[Size160to180] EQ 1), Age1Size160to180count)
      age2Size160to180 = WHERE((Age_Gro[Size160to180] EQ 2), AGE2Size160to180count)
      age3Size160to180 = WHERE((Age_Gro[Size160to180] EQ 3), AGE3Size160to180count)
      age4Size160to180 = WHERE((Age_Gro[Size160to180] EQ 4), AGE4Size160to180count)
      age5Size160to180 = WHERE((Age_Gro[Size160to180] EQ 5), AGE5Size160to180count)
      age6Size160to180 = WHERE((Age_Gro[Size160to180] EQ 6), AGE6Size160to180count)
      age7Size160to180 = WHERE((Age_Gro[Size160to180] EQ 7), AGE7Size160to180count)
      age8Size160to180 = WHERE((Age_Gro[Size160to180] EQ 8), AGE8Size160to180count)
      age9Size160to180 = WHERE((Age_Gro[Size160to180] EQ 9), AGE9Size160to180count)
      age10Size160to180 = WHERE((Age_Gro[Size160to180] EQ 10), AGE10Size160to180count)
      age11Size160to180 = WHERE((Age_Gro[Size160to180] EQ 11), AGE11Size160to180count)
      AGE12Size160to180 = WHERE((Age_Gro[Size160to180] EQ 12), AGE12Size160to180count)
      AGE13Size160to180 = WHERE((Age_Gro[Size160to180] EQ 13), AGE13Size160to180count)
      AGE14Size160to180 = WHERE((Age_Gro[Size160to180] EQ 14), AGE14Size160to180count)
      AGE15Size160to180 = WHERE((Age_Gro[Size160to180] EQ 15), AGE15Size160to180count)
      age16Size160to180 = WHERE((Age_Gro[Size160to180] EQ 16), Age16Size160to180count)
      age17Size160to180 = WHERE((Age_Gro[Size160to180] EQ 17), AGE17Size160to180count)
      age18Size160to180 = WHERE((Age_Gro[Size160to180] EQ 18), AGE18Size160to180count)
      age19Size160to180 = WHERE((Age_Gro[Size160to180] EQ 19), AGE19Size160to180count)
      age20Size160to180 = WHERE((Age_Gro[Size160to180] EQ 20), AGE20Size160to180count)
      age21Size160to180 = WHERE((Age_Gro[Size160to180] EQ 21), AGE21Size160to180count)
      age22Size160to180 = WHERE((Age_Gro[Size160to180] EQ 22), AGE22Size160to180count)
      age23Size160to180 = WHERE((Age_Gro[Size160to180] EQ 23), AGE23Size160to180count)
      age24Size160to180 = WHERE((Age_Gro[Size160to180] EQ 24), AGE24Size160to180count)
      age25Size160to180 = WHERE((Age_Gro[Size160to180] EQ 25), AGE25Size160to180count)
      age26Size160to180 = WHERE((Age_Gro[Size160to180] EQ 26), AGE26Size160to180count)

      WAE_length_bin[10, i*NumLengthBin+adj+4L] = Age0Size160to180count
      WAE_length_bin[11, i*NumLengthBin+adj+4L] = Age1Size160to180count
      WAE_length_bin[12, i*NumLengthBin+adj+4L] = Age2Size160to180count
      WAE_length_bin[13, i*NumLengthBin+adj+4L] = Age3Size160to180count
      WAE_length_bin[14, i*NumLengthBin+adj+4L] = Age4Size160to180count
      WAE_length_bin[15, i*NumLengthBin+adj+4L] = Age5Size160to180count
      WAE_length_bin[16, i*NumLengthBin+adj+4L] = Age6Size160to180count
      WAE_length_bin[17, i*NumLengthBin+adj+4L] = Age7Size160to180count
      WAE_length_bin[18, i*NumLengthBin+adj+4L] = Age8Size160to180count
      WAE_length_bin[19, i*NumLengthBin+adj+4L] = Age9Size160to180count
      WAE_length_bin[20, i*NumLengthBin+adj+4L] = Age10Size160to180count
      WAE_length_bin[21, i*NumLengthBin+adj+4L] = Age11Size160to180count
      WAE_length_bin[22, i*NumLengthBin+adj+4L] = Age12Size160to180count
      WAE_length_bin[23, i*NumLengthBin+adj+4L] = Age13Size160to180count
      WAE_length_bin[24, i*NumLengthBin+adj+4L] = Age14Size160to180count
      WAE_length_bin[25, i*NumLengthBin+adj+4L] = Age15Size160to180count
      WAE_length_bin[26, i*NumLengthBin+adj+4L] = Age16Size160to180count
      WAE_length_bin[27, i*NumLengthBin+adj+4L] = Age17Size160to180count
      WAE_length_bin[28, i*NumLengthBin+adj+4L] = Age18Size160to180count
      WAE_length_bin[29, i*NumLengthBin+adj+4L] = Age19Size160to180count
      WAE_length_bin[30, i*NumLengthBin+adj+4L] = Age20Size160to180count
      WAE_length_bin[31, i*NumLengthBin+adj+4L] = Age21Size160to180count
      WAE_length_bin[32, i*NumLengthBin+adj+4L] = Age22Size160to180count
      WAE_length_bin[33, i*NumLengthBin+adj+4L] = Age23Size160to180count
      WAE_length_bin[34, i*NumLengthBin+adj+4L] = Age24Size160to180count
      WAE_length_bin[35, i*NumLengthBin+adj+4L] = Age25Size160to180count
      WAE_length_bin[36, i*NumLengthBin+adj+4L] = Age26Size160to180count
    ENDIF
    PRINT, 'Size160to180', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+4L])

    WAE_length_bin[0, i*NumLengthBin+adj+5L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj+5L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+5L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+5L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+5L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+5L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+5L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+5L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+5L] = 180
    WAE_length_bin[9, i*NumLengthBin+adj+5L] = Size180to200count

    ; length bin 6
    IF Size180to200count GT 0 THEN BEGIN
      age0Size180to200 = WHERE((Age_Gro[Size180to200] EQ 0), Age0Size180to200count)
      age1Size180to200 = WHERE((Age_Gro[Size180to200] EQ 1), Age1Size180to200count)
      age2Size180to200 = WHERE((Age_Gro[Size180to200] EQ 2), AGE2Size180to200count)
      age3Size180to200 = WHERE((Age_Gro[Size180to200] EQ 3), AGE3Size180to200count)
      age4Size180to200 = WHERE((Age_Gro[Size180to200] EQ 4), AGE4Size180to200count)
      age5Size180to200 = WHERE((Age_Gro[Size180to200] EQ 5), AGE5Size180to200count)
      age6Size180to200 = WHERE((Age_Gro[Size180to200] EQ 6), AGE6Size180to200count)
      age7Size180to200 = WHERE((Age_Gro[Size180to200] EQ 7), AGE7Size180to200count)
      age8Size180to200 = WHERE((Age_Gro[Size180to200] EQ 8), AGE8Size180to200count)
      age9Size180to200 = WHERE((Age_Gro[Size180to200] EQ 9), AGE9Size180to200count)
      age10Size180to200 = WHERE((Age_Gro[Size180to200] EQ 10), AGE10Size180to200count)
      age11Size180to200 = WHERE((Age_Gro[Size180to200] EQ 11), AGE11Size180to200count)
      AGE12Size180to200 = WHERE((Age_Gro[Size180to200] EQ 12), AGE12Size180to200count)
      AGE13Size180to200 = WHERE((Age_Gro[Size180to200] EQ 13), AGE13Size180to200count)
      AGE14Size180to200 = WHERE((Age_Gro[Size180to200] EQ 14), AGE14Size180to200count)
      AGE15Size180to200 = WHERE((Age_Gro[Size180to200] EQ 15), AGE15Size180to200count)
      age16Size180to200 = WHERE((Age_Gro[Size180to200] EQ 16), Age16Size180to200count)
      age17Size180to200 = WHERE((Age_Gro[Size180to200] EQ 17), AGE17Size180to200count)
      age18Size180to200 = WHERE((Age_Gro[Size180to200] EQ 18), AGE18Size180to200count)
      age19Size180to200 = WHERE((Age_Gro[Size180to200] EQ 19), AGE19Size180to200count)
      age20Size180to200 = WHERE((Age_Gro[Size180to200] EQ 20), AGE20Size180to200count)
      age21Size180to200 = WHERE((Age_Gro[Size180to200] EQ 21), AGE21Size180to200count)
      age22Size180to200 = WHERE((Age_Gro[Size180to200] EQ 22), AGE22Size180to200count)
      age23Size180to200 = WHERE((Age_Gro[Size180to200] EQ 23), AGE23Size180to200count)
      age24Size180to200 = WHERE((Age_Gro[Size180to200] EQ 24), AGE24Size180to200count)
      age25Size180to200 = WHERE((Age_Gro[Size180to200] EQ 25), AGE25Size180to200count)
      age26Size180to200 = WHERE((Age_Gro[Size180to200] EQ 26), AGE26Size180to200count)

      WAE_length_bin[10, i*NumLengthBin+adj+5L] = Age0Size180to200count
      WAE_length_bin[11, i*NumLengthBin+adj+5L] = Age1Size180to200count
      WAE_length_bin[12, i*NumLengthBin+adj+5L] = Age2Size180to200count
      WAE_length_bin[13, i*NumLengthBin+adj+5L] = Age3Size180to200count
      WAE_length_bin[14, i*NumLengthBin+adj+5L] = Age4Size180to200count
      WAE_length_bin[15, i*NumLengthBin+adj+5L] = Age5Size180to200count
      WAE_length_bin[16, i*NumLengthBin+adj+5L] = Age6Size180to200count
      WAE_length_bin[17, i*NumLengthBin+adj+5L] = Age7Size180to200count
      WAE_length_bin[18, i*NumLengthBin+adj+5L] = Age8Size180to200count
      WAE_length_bin[19, i*NumLengthBin+adj+5L] = Age9Size180to200count
      WAE_length_bin[20, i*NumLengthBin+adj+5L] = Age10Size180to200count
      WAE_length_bin[21, i*NumLengthBin+adj+5L] = Age11Size180to200count
      WAE_length_bin[22, i*NumLengthBin+adj+5L] = Age12Size180to200count
      WAE_length_bin[23, i*NumLengthBin+adj+5L] = Age13Size180to200count
      WAE_length_bin[24, i*NumLengthBin+adj+5L] = Age14Size180to200count
      WAE_length_bin[25, i*NumLengthBin+adj+5L] = Age15Size180to200count
      WAE_length_bin[26, i*NumLengthBin+adj+5L] = Age16Size180to200count
      WAE_length_bin[27, i*NumLengthBin+adj+5L] = Age17Size180to200count
      WAE_length_bin[28, i*NumLengthBin+adj+5L] = Age18Size180to200count
      WAE_length_bin[29, i*NumLengthBin+adj+5L] = Age19Size180to200count
      WAE_length_bin[30, i*NumLengthBin+adj+5L] = Age20Size180to200count
      WAE_length_bin[31, i*NumLengthBin+adj+5L] = Age21Size180to200count
      WAE_length_bin[32, i*NumLengthBin+adj+5L] = Age22Size180to200count
      WAE_length_bin[33, i*NumLengthBin+adj+5L] = Age23Size180to200count
      WAE_length_bin[34, i*NumLengthBin+adj+5L] = Age24Size180to200count
      WAE_length_bin[35, i*NumLengthBin+adj+5L] = Age25Size180to200count
      WAE_length_bin[36, i*NumLengthBin+adj+5L] = Age26Size180to200count
    ENDIF
    PRINT, 'Size180to200', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+5L])


    WAE_length_bin[0, i*NumLengthBin+adj+6L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[1, i*NumLengthBin+adj+6L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+6L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+6L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+6L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+6L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+6L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+6L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+6L] = 200
    WAE_length_bin[9, i*NumLengthBin+adj+6L] = Size200to220count

    ; length bin 7
    IF Size200to220count GT 0 THEN BEGIN
      age0Size200to220 = WHERE((Age_Gro[Size200to220] EQ 0), Age0Size200to220count)
      age1Size200to220 = WHERE((Age_Gro[Size200to220] EQ 1), Age1Size200to220count)
      age2Size200to220 = WHERE((Age_Gro[Size200to220] EQ 2), AGE2Size200to220count)
      age3Size200to220 = WHERE((Age_Gro[Size200to220] EQ 3), AGE3Size200to220count)
      age4Size200to220 = WHERE((Age_Gro[Size200to220] EQ 4), AGE4Size200to220count)
      age5Size200to220 = WHERE((Age_Gro[Size200to220] EQ 5), AGE5Size200to220count)
      age6Size200to220 = WHERE((Age_Gro[Size200to220] EQ 6), AGE6Size200to220count)
      age7Size200to220 = WHERE((Age_Gro[Size200to220] EQ 7), AGE7Size200to220count)
      age8Size200to220 = WHERE((Age_Gro[Size200to220] EQ 8), AGE8Size200to220count)
      age9Size200to220 = WHERE((Age_Gro[Size200to220] EQ 9), AGE9Size200to220count)
      age10Size200to220 = WHERE((Age_Gro[Size200to220] EQ 10), AGE10Size200to220count)
      age11Size200to220 = WHERE((Age_Gro[Size200to220] EQ 11), AGE11Size200to220count)
      AGE12Size200to220 = WHERE((Age_Gro[Size200to220] EQ 12), AGE12Size200to220count)
      AGE13Size200to220 = WHERE((Age_Gro[Size200to220] EQ 13), AGE13Size200to220count)
      AGE14Size200to220 = WHERE((Age_Gro[Size200to220] EQ 14), AGE14Size200to220count)
      AGE15Size200to220 = WHERE((Age_Gro[Size200to220] EQ 15), AGE15Size200to220count)
      age16Size200to220 = WHERE((Age_Gro[Size200to220] EQ 16), Age16Size200to220count)
      age17Size200to220 = WHERE((Age_Gro[Size200to220] EQ 17), AGE17Size200to220count)
      age18Size200to220 = WHERE((Age_Gro[Size200to220] EQ 18), AGE18Size200to220count)
      age19Size200to220 = WHERE((Age_Gro[Size200to220] EQ 19), AGE19Size200to220count)
      age20Size200to220 = WHERE((Age_Gro[Size200to220] EQ 20), AGE20Size200to220count)
      age21Size200to220 = WHERE((Age_Gro[Size200to220] EQ 21), AGE21Size200to220count)
      age22Size200to220 = WHERE((Age_Gro[Size200to220] EQ 22), AGE22Size200to220count)
      age23Size200to220 = WHERE((Age_Gro[Size200to220] EQ 23), AGE23Size200to220count)
      age24Size200to220 = WHERE((Age_Gro[Size200to220] EQ 24), AGE24Size200to220count)
      age25Size200to220 = WHERE((Age_Gro[Size200to220] EQ 25), AGE25Size200to220count)
      age26Size200to220 = WHERE((Age_Gro[Size200to220] EQ 26), AGE26Size200to220count)

      WAE_length_bin[10, i*NumLengthBin+adj+6L] = Age0Size200to220count
      WAE_length_bin[11, i*NumLengthBin+adj+6L] = Age1Size200to220count
      WAE_length_bin[12, i*NumLengthBin+adj+6L] = Age2Size200to220count
      WAE_length_bin[13, i*NumLengthBin+adj+6L] = Age3Size200to220count
      WAE_length_bin[14, i*NumLengthBin+adj+6L] = Age4Size200to220count
      WAE_length_bin[15, i*NumLengthBin+adj+6L] = Age5Size200to220count
      WAE_length_bin[16, i*NumLengthBin+adj+6L] = Age6Size200to220count
      WAE_length_bin[17, i*NumLengthBin+adj+6L] = Age7Size200to220count
      WAE_length_bin[18, i*NumLengthBin+adj+6L] = Age8Size200to220count
      WAE_length_bin[19, i*NumLengthBin+adj+6L] = Age9Size200to220count
      WAE_length_bin[20, i*NumLengthBin+adj+6L] = Age10Size200to220count
      WAE_length_bin[21, i*NumLengthBin+adj+6L] = Age11Size200to220count
      WAE_length_bin[22, i*NumLengthBin+adj+6L] = Age12Size200to220count
      WAE_length_bin[23, i*NumLengthBin+adj+6L] = Age13Size200to220count
      WAE_length_bin[24, i*NumLengthBin+adj+6L] = Age14Size200to220count
      WAE_length_bin[25, i*NumLengthBin+adj+6L] = Age15Size200to220count
      WAE_length_bin[26, i*NumLengthBin+adj+6L] = Age16Size200to220count
      WAE_length_bin[27, i*NumLengthBin+adj+6L] = Age17Size200to220count
      WAE_length_bin[28, i*NumLengthBin+adj+6L] = Age18Size200to220count
      WAE_length_bin[29, i*NumLengthBin+adj+6L] = Age19Size200to220count
      WAE_length_bin[30, i*NumLengthBin+adj+6L] = Age20Size200to220count
      WAE_length_bin[31, i*NumLengthBin+adj+6L] = Age21Size200to220count
      WAE_length_bin[32, i*NumLengthBin+adj+6L] = Age22Size200to220count
      WAE_length_bin[33, i*NumLengthBin+adj+6L] = Age23Size200to220count
      WAE_length_bin[34, i*NumLengthBin+adj+6L] = Age24Size200to220count
      WAE_length_bin[35, i*NumLengthBin+adj+6L] = Age25Size200to220count
      WAE_length_bin[36, i*NumLengthBin+adj+6L] = Age26Size200to220count
    ENDIF
    PRINT, 'Size200to220', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+6L])


    WAE_length_bin[0, i*NumLengthBin+adj+7L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+7L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+7L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+7L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+7L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+7L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+7L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+7L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+7L] = 220
    WAE_length_bin[9, i*NumLengthBin+adj+7L] = Size220to240count

    ; length bin 8
    IF Size220to240count GT 0 THEN BEGIN
      age0Size220to240 = WHERE((Age_Gro[Size220to240] EQ 0), Age0Size220to240count)
      age1Size220to240 = WHERE((Age_Gro[Size220to240] EQ 1), Age1Size220to240count)
      age2Size220to240 = WHERE((Age_Gro[Size220to240] EQ 2), AGE2Size220to240count)
      age3Size220to240 = WHERE((Age_Gro[Size220to240] EQ 3), AGE3Size220to240count)
      age4Size220to240 = WHERE((Age_Gro[Size220to240] EQ 4), AGE4Size220to240count)
      age5Size220to240 = WHERE((Age_Gro[Size220to240] EQ 5), AGE5Size220to240count)
      age6Size220to240 = WHERE((Age_Gro[Size220to240] EQ 6), AGE6Size220to240count)
      age7Size220to240 = WHERE((Age_Gro[Size220to240] EQ 7), AGE7Size220to240count)
      age8Size220to240 = WHERE((Age_Gro[Size220to240] EQ 8), AGE8Size220to240count)
      age9Size220to240 = WHERE((Age_Gro[Size220to240] EQ 9), AGE9Size220to240count)
      age10Size220to240 = WHERE((Age_Gro[Size220to240] EQ 10), AGE10Size220to240count)
      age11Size220to240 = WHERE((Age_Gro[Size220to240] EQ 11), AGE11Size220to240count)
      AGE12Size220to240 = WHERE((Age_Gro[Size220to240] EQ 12), AGE12Size220to240count)
      AGE13Size220to240 = WHERE((Age_Gro[Size220to240] EQ 13), AGE13Size220to240count)
      AGE14Size220to240 = WHERE((Age_Gro[Size220to240] EQ 14), AGE14Size220to240count)
      AGE15Size220to240 = WHERE((Age_Gro[Size220to240] EQ 15), AGE15Size220to240count)
      age16Size220to240 = WHERE((Age_Gro[Size220to240] EQ 16), Age16Size220to240count)
      age17Size220to240 = WHERE((Age_Gro[Size220to240] EQ 17), AGE17Size220to240count)
      age18Size220to240 = WHERE((Age_Gro[Size220to240] EQ 18), AGE18Size220to240count)
      age19Size220to240 = WHERE((Age_Gro[Size220to240] EQ 19), AGE19Size220to240count)
      age20Size220to240 = WHERE((Age_Gro[Size220to240] EQ 20), AGE20Size220to240count)
      age21Size220to240 = WHERE((Age_Gro[Size220to240] EQ 21), AGE21Size220to240count)
      age22Size220to240 = WHERE((Age_Gro[Size220to240] EQ 22), AGE22Size220to240count)
      age23Size220to240 = WHERE((Age_Gro[Size220to240] EQ 23), AGE23Size220to240count)
      age24Size220to240 = WHERE((Age_Gro[Size220to240] EQ 24), AGE24Size220to240count)
      age25Size220to240 = WHERE((Age_Gro[Size220to240] EQ 25), AGE25Size220to240count)
      age26Size220to240 = WHERE((Age_Gro[Size220to240] EQ 26), AGE26Size220to240count)

      WAE_length_bin[10, i*NumLengthBin+adj+7L] = Age0Size220to240count
      WAE_length_bin[11, i*NumLengthBin+adj+7L] = Age1Size220to240count
      WAE_length_bin[12, i*NumLengthBin+adj+7L] = Age2Size220to240count
      WAE_length_bin[13, i*NumLengthBin+adj+7L] = Age3Size220to240count
      WAE_length_bin[14, i*NumLengthBin+adj+7L] = Age4Size220to240count
      WAE_length_bin[15, i*NumLengthBin+adj+7L] = Age5Size220to240count
      WAE_length_bin[16, i*NumLengthBin+adj+7L] = Age6Size220to240count
      WAE_length_bin[17, i*NumLengthBin+adj+7L] = Age7Size220to240count
      WAE_length_bin[18, i*NumLengthBin+adj+7L] = Age8Size220to240count
      WAE_length_bin[19, i*NumLengthBin+adj+7L] = Age9Size220to240count
      WAE_length_bin[20, i*NumLengthBin+adj+7L] = Age10Size220to240count
      WAE_length_bin[21, i*NumLengthBin+adj+7L] = Age11Size220to240count
      WAE_length_bin[22, i*NumLengthBin+adj+7L] = Age12Size220to240count
      WAE_length_bin[23, i*NumLengthBin+adj+7L] = Age13Size220to240count
      WAE_length_bin[24, i*NumLengthBin+adj+7L] = Age14Size220to240count
      WAE_length_bin[25, i*NumLengthBin+adj+7L] = Age15Size220to240count
      WAE_length_bin[26, i*NumLengthBin+adj+7L] = Age16Size220to240count
      WAE_length_bin[27, i*NumLengthBin+adj+7L] = Age17Size220to240count
      WAE_length_bin[28, i*NumLengthBin+adj+7L] = Age18Size220to240count
      WAE_length_bin[29, i*NumLengthBin+adj+7L] = Age19Size220to240count
      WAE_length_bin[30, i*NumLengthBin+adj+7L] = Age20Size220to240count
      WAE_length_bin[31, i*NumLengthBin+adj+7L] = Age21Size220to240count
      WAE_length_bin[32, i*NumLengthBin+adj+7L] = Age22Size220to240count
      WAE_length_bin[33, i*NumLengthBin+adj+7L] = Age23Size220to240count
      WAE_length_bin[34, i*NumLengthBin+adj+7L] = Age24Size220to240count
      WAE_length_bin[35, i*NumLengthBin+adj+7L] = Age25Size220to240count
      WAE_length_bin[36, i*NumLengthBin+adj+7L] = Age26Size220to240count
    ENDIF
    PRINT, 'Size220to240', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+7L])


    WAE_length_bin[0, i*NumLengthBin+adj+8L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+8L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+8L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+8L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+8L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+8L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+8L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+8L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+8L] = 240
    WAE_length_bin[9, i*NumLengthBin+adj+8L] =  Size240to260count

    ; length bin 9
    IF Size240to260count GT 0 THEN BEGIN
      age0Size240to260 = WHERE((Age_Gro[Size240to260] EQ 0), Age0Size240to260count)
      age1Size240to260 = WHERE((Age_Gro[Size240to260] EQ 1), Age1Size240to260count)
      age2Size240to260 = WHERE((Age_Gro[Size240to260] EQ 2), AGE2Size240to260count)
      age3Size240to260 = WHERE((Age_Gro[Size240to260] EQ 3), AGE3Size240to260count)
      age4Size240to260 = WHERE((Age_Gro[Size240to260] EQ 4), AGE4Size240to260count)
      age5Size240to260 = WHERE((Age_Gro[Size240to260] EQ 5), AGE5Size240to260count)
      age6Size240to260 = WHERE((Age_Gro[Size240to260] EQ 6), AGE6Size240to260count)
      age7Size240to260 = WHERE((Age_Gro[Size240to260] EQ 7), AGE7Size240to260count)
      age8Size240to260 = WHERE((Age_Gro[Size240to260] EQ 8), AGE8Size240to260count)
      age9Size240to260 = WHERE((Age_Gro[Size240to260] EQ 9), AGE9Size240to260count)
      age10Size240to260 = WHERE((Age_Gro[Size240to260] EQ 10), AGE10Size240to260count)
      age11Size240to260 = WHERE((Age_Gro[Size240to260] EQ 11), AGE11Size240to260count)
      AGE12Size240to260 = WHERE((Age_Gro[Size240to260] EQ 12), AGE12Size240to260count)
      AGE13Size240to260 = WHERE((Age_Gro[Size240to260] EQ 13), AGE13Size240to260count)
      AGE14Size240to260 = WHERE((Age_Gro[Size240to260] EQ 14), AGE14Size240to260count)
      AGE15Size240to260 = WHERE((Age_Gro[Size240to260] EQ 15), AGE15Size240to260count)
      age16Size240to260 = WHERE((Age_Gro[Size240to260] EQ 16), Age16Size240to260count)
      age17Size240to260 = WHERE((Age_Gro[Size240to260] EQ 17), AGE17Size240to260count)
      age18Size240to260 = WHERE((Age_Gro[Size240to260] EQ 18), AGE18Size240to260count)
      age19Size240to260 = WHERE((Age_Gro[Size240to260] EQ 19), AGE19Size240to260count)
      age20Size240to260 = WHERE((Age_Gro[Size240to260] EQ 20), AGE20Size240to260count)
      age21Size240to260 = WHERE((Age_Gro[Size240to260] EQ 21), AGE21Size240to260count)
      age22Size240to260 = WHERE((Age_Gro[Size240to260] EQ 22), AGE22Size240to260count)
      age23Size240to260 = WHERE((Age_Gro[Size240to260] EQ 23), AGE23Size240to260count)
      age24Size240to260 = WHERE((Age_Gro[Size240to260] EQ 24), AGE24Size240to260count)
      age25Size240to260 = WHERE((Age_Gro[Size240to260] EQ 25), AGE25Size240to260count)
      age26Size240to260 = WHERE((Age_Gro[Size240to260] EQ 26), AGE26Size240to260count)


      WAE_length_bin[10, i*NumLengthBin+adj+8L] = Age0Size240to260count
      WAE_length_bin[11, i*NumLengthBin+adj+8L] = Age1Size240to260count
      WAE_length_bin[12, i*NumLengthBin+adj+8L] = Age2Size240to260count
      WAE_length_bin[13, i*NumLengthBin+adj+8L] = Age3Size240to260count
      WAE_length_bin[14, i*NumLengthBin+adj+8L] = Age4Size240to260count
      WAE_length_bin[15, i*NumLengthBin+adj+8L] = Age5Size240to260count
      WAE_length_bin[16, i*NumLengthBin+adj+8L] = Age6Size240to260count
      WAE_length_bin[17, i*NumLengthBin+adj+8L] = Age7Size240to260count
      WAE_length_bin[18, i*NumLengthBin+adj+8L] = Age8Size240to260count
      WAE_length_bin[19, i*NumLengthBin+adj+8L] = Age9Size240to260count
      WAE_length_bin[20, i*NumLengthBin+adj+8L] = Age10Size240to260count
      WAE_length_bin[21, i*NumLengthBin+adj+8L] = Age11Size240to260count
      WAE_length_bin[22, i*NumLengthBin+adj+8L] = Age12Size240to260count
      WAE_length_bin[23, i*NumLengthBin+adj+8L] = Age13Size240to260count
      WAE_length_bin[24, i*NumLengthBin+adj+8L] = Age14Size240to260count
      WAE_length_bin[25, i*NumLengthBin+adj+8L] = Age15Size240to260count
      WAE_length_bin[26, i*NumLengthBin+adj+8L] = Age16Size240to260count
      WAE_length_bin[27, i*NumLengthBin+adj+8L] = Age17Size240to260count
      WAE_length_bin[28, i*NumLengthBin+adj+8L] = Age18Size240to260count
      WAE_length_bin[29, i*NumLengthBin+adj+8L] = Age19Size240to260count
      WAE_length_bin[30, i*NumLengthBin+adj+8L] = Age20Size240to260count
      WAE_length_bin[31, i*NumLengthBin+adj+8L] = Age21Size240to260count
      WAE_length_bin[32, i*NumLengthBin+adj+8L] = Age22Size240to260count
      WAE_length_bin[33, i*NumLengthBin+adj+8L] = Age23Size240to260count
      WAE_length_bin[34, i*NumLengthBin+adj+8L] = Age24Size240to260count
      WAE_length_bin[35, i*NumLengthBin+adj+8L] = Age25Size240to260count
      WAE_length_bin[36, i*NumLengthBin+adj+8L] = Age26Size240to260count
    ENDIF
    PRINT, 'Size240to260', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+8L])


    WAE_length_bin[0, i*NumLengthBin+adj+9L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+9L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+9L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+9L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+9L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+9L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+9L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+9L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+9L] = 260
    WAE_length_bin[9, i*NumLengthBin+adj+9L] =  Size260to280count

    ; length bin 10
    IF Size260to280count GT 0 THEN BEGIN
      age0Size260to280 = WHERE((Age_Gro[Size260to280] EQ 0), Age0Size260to280count)
      age1Size260to280 = WHERE((Age_Gro[Size260to280] EQ 1), Age1Size260to280count)
      age2Size260to280 = WHERE((Age_Gro[Size260to280] EQ 2), AGE2Size260to280count)
      age3Size260to280 = WHERE((Age_Gro[Size260to280] EQ 3), AGE3Size260to280count)
      age4Size260to280 = WHERE((Age_Gro[Size260to280] EQ 4), AGE4Size260to280count)
      age5Size260to280 = WHERE((Age_Gro[Size260to280] EQ 5), AGE5Size260to280count)
      age6Size260to280 = WHERE((Age_Gro[Size260to280] EQ 6), AGE6Size260to280count)
      age7Size260to280 = WHERE((Age_Gro[Size260to280] EQ 7), AGE7Size260to280count)
      age8Size260to280 = WHERE((Age_Gro[Size260to280] EQ 8), AGE8Size260to280count)
      age9Size260to280 = WHERE((Age_Gro[Size260to280] EQ 9), AGE9Size260to280count)
      age10Size260to280 = WHERE((Age_Gro[Size260to280] EQ 10), AGE10Size260to280count)
      age11Size260to280 = WHERE((Age_Gro[Size260to280] EQ 11), AGE11Size260to280count)
      AGE12Size260to280 = WHERE((Age_Gro[Size260to280] EQ 12), AGE12Size260to280count)
      AGE13Size260to280 = WHERE((Age_Gro[Size260to280] EQ 13), AGE13Size260to280count)
      AGE14Size260to280 = WHERE((Age_Gro[Size260to280] EQ 14), AGE14Size260to280count)
      AGE15Size260to280 = WHERE((Age_Gro[Size260to280] EQ 15), AGE15Size260to280count)
      age16Size260to280 = WHERE((Age_Gro[Size260to280] EQ 16), Age16Size260to280count)
      age17Size260to280 = WHERE((Age_Gro[Size260to280] EQ 17), AGE17Size260to280count)
      age18Size260to280 = WHERE((Age_Gro[Size260to280] EQ 18), AGE18Size260to280count)
      age19Size260to280 = WHERE((Age_Gro[Size260to280] EQ 19), AGE19Size260to280count)
      age20Size260to280 = WHERE((Age_Gro[Size260to280] EQ 20), AGE20Size260to280count)
      age21Size260to280 = WHERE((Age_Gro[Size260to280] EQ 21), AGE21Size260to280count)
      age22Size260to280 = WHERE((Age_Gro[Size260to280] EQ 22), AGE22Size260to280count)
      age23Size260to280 = WHERE((Age_Gro[Size260to280] EQ 23), AGE23Size260to280count)
      age24Size260to280 = WHERE((Age_Gro[Size260to280] EQ 24), AGE24Size260to280count)
      age25Size260to280 = WHERE((Age_Gro[Size260to280] EQ 25), AGE25Size260to280count)
      age26Size260to280 = WHERE((Age_Gro[Size260to280] EQ 26), AGE26Size260to280count)

      WAE_length_bin[10, i*NumLengthBin+adj+9L] = Age0Size260to280count
      WAE_length_bin[11, i*NumLengthBin+adj+9L] = Age1Size260to280count
      WAE_length_bin[12, i*NumLengthBin+adj+9L] = Age2Size260to280count
      WAE_length_bin[13, i*NumLengthBin+adj+9L] = Age3Size260to280count
      WAE_length_bin[14, i*NumLengthBin+adj+9L] = Age4Size260to280count
      WAE_length_bin[15, i*NumLengthBin+adj+9L] = Age5Size260to280count
      WAE_length_bin[16, i*NumLengthBin+adj+9L] = Age6Size260to280count
      WAE_length_bin[17, i*NumLengthBin+adj+9L] = Age7Size260to280count
      WAE_length_bin[18, i*NumLengthBin+adj+9L] = Age8Size260to280count
      WAE_length_bin[19, i*NumLengthBin+adj+9L] = Age9Size260to280count
      WAE_length_bin[20, i*NumLengthBin+adj+9L] = Age10Size260to280count
      WAE_length_bin[21, i*NumLengthBin+adj+9L] = Age11Size260to280count
      WAE_length_bin[22, i*NumLengthBin+adj+9L] = Age12Size260to280count
      WAE_length_bin[23, i*NumLengthBin+adj+9L] = Age13Size260to280count
      WAE_length_bin[24, i*NumLengthBin+adj+9L] = Age14Size260to280count
      WAE_length_bin[25, i*NumLengthBin+adj+9L] = Age15Size260to280count
      WAE_length_bin[26, i*NumLengthBin+adj+9L] = Age16Size260to280count
      WAE_length_bin[27, i*NumLengthBin+adj+9L] = Age17Size260to280count
      WAE_length_bin[28, i*NumLengthBin+adj+9L] = Age18Size260to280count
      WAE_length_bin[29, i*NumLengthBin+adj+9L] = Age19Size260to280count
      WAE_length_bin[30, i*NumLengthBin+adj+9L] = Age20Size260to280count
      WAE_length_bin[31, i*NumLengthBin+adj+9L] = Age21Size260to280count
      WAE_length_bin[32, i*NumLengthBin+adj+9L] = Age22Size260to280count
      WAE_length_bin[33, i*NumLengthBin+adj+9L] = Age23Size260to280count
      WAE_length_bin[34, i*NumLengthBin+adj+9L] = Age24Size260to280count
      WAE_length_bin[35, i*NumLengthBin+adj+9L] = Age25Size260to280count
      WAE_length_bin[36, i*NumLengthBin+adj+9L] = Age26Size260to280count
    ENDIF
    PRINT, ' Size260to280', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+9L])


    WAE_length_bin[0, i*NumLengthBin+adj+10L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+10L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+10L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+10L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+10L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+10L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+10L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+10L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+10L] = 280
    WAE_length_bin[9, i*NumLengthBin+adj+10L] =  Size280to300count

    ; length bin 11
    IF Size280to300count GT 0 THEN BEGIN
      age0Size280to300 = WHERE((Age_Gro[Size280to300] EQ 0), Age0Size280to300count)
      age1Size280to300 = WHERE((Age_Gro[Size280to300] EQ 1), Age1Size280to300count)
      age2Size280to300 = WHERE((Age_Gro[Size280to300] EQ 2), AGE2Size280to300count)
      age3Size280to300 = WHERE((Age_Gro[Size280to300] EQ 3), AGE3Size280to300count)
      age4Size280to300 = WHERE((Age_Gro[Size280to300] EQ 4), AGE4Size280to300count)
      age5Size280to300 = WHERE((Age_Gro[Size280to300] EQ 5), AGE5Size280to300count)
      age6Size280to300 = WHERE((Age_Gro[Size280to300] EQ 6), AGE6Size280to300count)
      age7Size280to300 = WHERE((Age_Gro[Size280to300] EQ 7), AGE7Size280to300count)
      age8Size280to300 = WHERE((Age_Gro[Size280to300] EQ 8), AGE8Size280to300count)
      age9Size280to300 = WHERE((Age_Gro[Size280to300] EQ 9), AGE9Size280to300count)
      age10Size280to300 = WHERE((Age_Gro[Size280to300] EQ 10), AGE10Size280to300count)
      age11Size280to300 = WHERE((Age_Gro[Size280to300] EQ 11), AGE11Size280to300count)
      AGE12Size280to300 = WHERE((Age_Gro[Size280to300] EQ 12), AGE12Size280to300count)
      AGE13Size280to300 = WHERE((Age_Gro[Size280to300] EQ 13), AGE13Size280to300count)
      AGE14Size280to300 = WHERE((Age_Gro[Size280to300] EQ 14), AGE14Size280to300count)
      AGE15Size280to300 = WHERE((Age_Gro[Size280to300] EQ 15), AGE15Size280to300count)
      age16Size280to300 = WHERE((Age_Gro[Size280to300] EQ 16), Age16Size280to300count)
      age17Size280to300 = WHERE((Age_Gro[Size280to300] EQ 17), AGE17Size280to300count)
      age18Size280to300 = WHERE((Age_Gro[Size280to300] EQ 18), AGE18Size280to300count)
      age19Size280to300 = WHERE((Age_Gro[Size280to300] EQ 19), AGE19Size280to300count)
      age20Size280to300 = WHERE((Age_Gro[Size280to300] EQ 20), AGE20Size280to300count)
      age21Size280to300 = WHERE((Age_Gro[Size280to300] EQ 21), AGE21Size280to300count)
      age22Size280to300 = WHERE((Age_Gro[Size280to300] EQ 22), AGE22Size280to300count)
      age23Size280to300 = WHERE((Age_Gro[Size280to300] EQ 23), AGE23Size280to300count)
      age24Size280to300 = WHERE((Age_Gro[Size280to300] EQ 24), AGE24Size280to300count)
      age25Size280to300 = WHERE((Age_Gro[Size280to300] EQ 25), AGE25Size280to300count)
      age26Size280to300 = WHERE((Age_Gro[Size280to300] EQ 26), AGE26Size280to300count)

      WAE_length_bin[10, i*NumLengthBin+adj+10L] = Age0Size280to300count
      WAE_length_bin[11, i*NumLengthBin+adj+10L] = Age1Size280to300count
      WAE_length_bin[12, i*NumLengthBin+adj+10L] = Age2Size280to300count
      WAE_length_bin[13, i*NumLengthBin+adj+10L] = Age3Size280to300count
      WAE_length_bin[14, i*NumLengthBin+adj+10L] = Age4Size280to300count
      WAE_length_bin[15, i*NumLengthBin+adj+10L] = Age5Size280to300count
      WAE_length_bin[16, i*NumLengthBin+adj+10L] = Age6Size280to300count
      WAE_length_bin[17, i*NumLengthBin+adj+10L] = Age7Size280to300count
      WAE_length_bin[18, i*NumLengthBin+adj+10L] = Age8Size280to300count
      WAE_length_bin[19, i*NumLengthBin+adj+10L] = Age9Size280to300count
      WAE_length_bin[20, i*NumLengthBin+adj+10L] = Age10Size280to300count
      WAE_length_bin[21, i*NumLengthBin+adj+10L] = Age11Size280to300count
      WAE_length_bin[22, i*NumLengthBin+adj+10L] = Age12Size280to300count
      WAE_length_bin[23, i*NumLengthBin+adj+10L] = Age13Size280to300count
      WAE_length_bin[24, i*NumLengthBin+adj+10L] = Age14Size280to300count
      WAE_length_bin[25, i*NumLengthBin+adj+10L] = Age15Size280to300count
      WAE_length_bin[26, i*NumLengthBin+adj+10L] = Age16Size280to300count
      WAE_length_bin[27, i*NumLengthBin+adj+10L] = Age17Size280to300count
      WAE_length_bin[28, i*NumLengthBin+adj+10L] = Age18Size280to300count
      WAE_length_bin[29, i*NumLengthBin+adj+10L] = Age19Size280to300count
      WAE_length_bin[30, i*NumLengthBin+adj+10L] = Age20Size280to300count
      WAE_length_bin[31, i*NumLengthBin+adj+10L] = Age21Size280to300count
      WAE_length_bin[32, i*NumLengthBin+adj+10L] = Age22Size280to300count
      WAE_length_bin[33, i*NumLengthBin+adj+10L] = Age23Size280to300count
      WAE_length_bin[34, i*NumLengthBin+adj+10L] = Age24Size280to300count
      WAE_length_bin[35, i*NumLengthBin+adj+10L] = Age25Size280to300count
      WAE_length_bin[36, i*NumLengthBin+adj+10L] = Age26Size280to300count
    ENDIF
    PRINT, ' Size280to300', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+10L])



    WAE_length_bin[0, i*NumLengthBin+adj+11L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+11L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+11L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+11L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+11L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+11L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+11L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+11L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+11L] = 300
    WAE_length_bin[9, i*NumLengthBin+adj+11L] =  Size300to320count

    ; length bin 12
    IF Size300to320count GT 0 THEN BEGIN
      age0Size300to320 = WHERE((Age_Gro[Size300to320] EQ 0), Age0Size300to320count)
      age1Size300to320 = WHERE((Age_Gro[Size300to320] EQ 1), Age1Size300to320count)
      age2Size300to320 = WHERE((Age_Gro[Size300to320] EQ 2), AGE2Size300to320count)
      age3Size300to320 = WHERE((Age_Gro[Size300to320] EQ 3), AGE3Size300to320count)
      age4Size300to320 = WHERE((Age_Gro[Size300to320] EQ 4), AGE4Size300to320count)
      age5Size300to320 = WHERE((Age_Gro[Size300to320] EQ 5), AGE5Size300to320count)
      age6Size300to320 = WHERE((Age_Gro[Size300to320] EQ 6), AGE6Size300to320count)
      age7Size300to320 = WHERE((Age_Gro[Size300to320] EQ 7), AGE7Size300to320count)
      age8Size300to320 = WHERE((Age_Gro[Size300to320] EQ 8), AGE8Size300to320count)
      age9Size300to320 = WHERE((Age_Gro[Size300to320] EQ 9), AGE9Size300to320count)
      age10Size300to320 = WHERE((Age_Gro[Size300to320] EQ 10), AGE10Size300to320count)
      age11Size300to320 = WHERE((Age_Gro[Size300to320] EQ 11), AGE11Size300to320count)
      AGE12Size300to320 = WHERE((Age_Gro[Size300to320] EQ 12), AGE12Size300to320count)
      AGE13Size300to320 = WHERE((Age_Gro[Size300to320] EQ 13), AGE13Size300to320count)
      AGE14Size300to320 = WHERE((Age_Gro[Size300to320] EQ 14), AGE14Size300to320count)
      AGE15Size300to320 = WHERE((Age_Gro[Size300to320] EQ 15), AGE15Size300to320count)
      age16Size300to320 = WHERE((Age_Gro[Size300to320] EQ 16), Age16Size300to320count)
      age17Size300to320 = WHERE((Age_Gro[Size300to320] EQ 17), AGE17Size300to320count)
      age18Size300to320 = WHERE((Age_Gro[Size300to320] EQ 18), AGE18Size300to320count)
      age19Size300to320 = WHERE((Age_Gro[Size300to320] EQ 19), AGE19Size300to320count)
      age20Size300to320 = WHERE((Age_Gro[Size300to320] EQ 20), AGE20Size300to320count)
      age21Size300to320 = WHERE((Age_Gro[Size300to320] EQ 21), AGE21Size300to320count)
      age22Size300to320 = WHERE((Age_Gro[Size300to320] EQ 22), AGE22Size300to320count)
      age23Size300to320 = WHERE((Age_Gro[Size300to320] EQ 23), AGE23Size300to320count)
      age24Size300to320 = WHERE((Age_Gro[Size300to320] EQ 24), AGE24Size300to320count)
      age25Size300to320 = WHERE((Age_Gro[Size300to320] EQ 25), AGE25Size300to320count)
      age26Size300to320 = WHERE((Age_Gro[Size300to320] EQ 26), AGE26Size300to320count)

      WAE_length_bin[10, i*NumLengthBin+adj+11L] = Age0Size300to320count
      WAE_length_bin[11, i*NumLengthBin+adj+11L] = Age1Size300to320count
      WAE_length_bin[12, i*NumLengthBin+adj+11L] = Age2Size300to320count
      WAE_length_bin[13, i*NumLengthBin+adj+11L] = Age3Size300to320count
      WAE_length_bin[14, i*NumLengthBin+adj+11L] = Age4Size300to320count
      WAE_length_bin[15, i*NumLengthBin+adj+11L] = Age5Size300to320count
      WAE_length_bin[16, i*NumLengthBin+adj+11L] = Age6Size300to320count
      WAE_length_bin[17, i*NumLengthBin+adj+11L] = Age7Size300to320count
      WAE_length_bin[18, i*NumLengthBin+adj+11L] = Age8Size300to320count
      WAE_length_bin[19, i*NumLengthBin+adj+11L] = Age9Size300to320count
      WAE_length_bin[20, i*NumLengthBin+adj+11L] = Age10Size300to320count
      WAE_length_bin[21, i*NumLengthBin+adj+11L] = Age11Size300to320count
      WAE_length_bin[22, i*NumLengthBin+adj+11L] = Age12Size300to320count
      WAE_length_bin[23, i*NumLengthBin+adj+11L] = Age13Size300to320count
      WAE_length_bin[24, i*NumLengthBin+adj+11L] = Age14Size300to320count
      WAE_length_bin[25, i*NumLengthBin+adj+11L] = Age15Size300to320count
      WAE_length_bin[26, i*NumLengthBin+adj+11L] = Age16Size300to320count
      WAE_length_bin[27, i*NumLengthBin+adj+11L] = Age17Size300to320count
      WAE_length_bin[28, i*NumLengthBin+adj+11L] = Age18Size300to320count
      WAE_length_bin[29, i*NumLengthBin+adj+11L] = Age19Size300to320count
      WAE_length_bin[30, i*NumLengthBin+adj+11L] = Age20Size300to320count
      WAE_length_bin[31, i*NumLengthBin+adj+11L] = Age21Size300to320count
      WAE_length_bin[32, i*NumLengthBin+adj+11L] = Age22Size300to320count
      WAE_length_bin[33, i*NumLengthBin+adj+11L] = Age23Size300to320count
      WAE_length_bin[34, i*NumLengthBin+adj+11L] = Age24Size300to320count
      WAE_length_bin[35, i*NumLengthBin+adj+11L] = Age25Size300to320count
      WAE_length_bin[36, i*NumLengthBin+adj+11L] = Age26Size300to320count
    ENDIF
    PRINT, ' Size300to320', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+11L])


    WAE_length_bin[0, i*NumLengthBin+adj+12L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+12L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+12L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+12L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+12L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+12L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+12L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+12L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+12L] = 320
    WAE_length_bin[9, i*NumLengthBin+adj+12L] =  Size320to340count

    ; length bin 13
    IF Size320to340count GT 0 THEN BEGIN
      age0Size320to340 = WHERE((Age_Gro[Size320to340] EQ 0), Age0Size320to340count)
      age1Size320to340 = WHERE((Age_Gro[Size320to340] EQ 1), Age1Size320to340count)
      age2Size320to340 = WHERE((Age_Gro[Size320to340] EQ 2), AGE2Size320to340count)
      age3Size320to340 = WHERE((Age_Gro[Size320to340] EQ 3), AGE3Size320to340count)
      age4Size320to340 = WHERE((Age_Gro[Size320to340] EQ 4), AGE4Size320to340count)
      age5Size320to340 = WHERE((Age_Gro[Size320to340] EQ 5), AGE5Size320to340count)
      age6Size320to340 = WHERE((Age_Gro[Size320to340] EQ 6), AGE6Size320to340count)
      age7Size320to340 = WHERE((Age_Gro[Size320to340] EQ 7), AGE7Size320to340count)
      age8Size320to340 = WHERE((Age_Gro[Size320to340] EQ 8), AGE8Size320to340count)
      age9Size320to340 = WHERE((Age_Gro[Size320to340] EQ 9), AGE9Size320to340count)
      age10Size320to340 = WHERE((Age_Gro[Size320to340] EQ 10), AGE10Size320to340count)
      age11Size320to340 = WHERE((Age_Gro[Size320to340] EQ 11), AGE11Size320to340count)
      AGE12Size320to340 = WHERE((Age_Gro[Size320to340] EQ 12), AGE12Size320to340count)
      AGE13Size320to340 = WHERE((Age_Gro[Size320to340] EQ 13), AGE13Size320to340count)
      AGE14Size320to340 = WHERE((Age_Gro[Size320to340] EQ 14), AGE14Size320to340count)
      AGE15Size320to340 = WHERE((Age_Gro[Size320to340] EQ 15), AGE15Size320to340count)
      age16Size320to340 = WHERE((Age_Gro[Size320to340] EQ 16), Age16Size320to340count)
      age17Size320to340 = WHERE((Age_Gro[Size320to340] EQ 17), AGE17Size320to340count)
      age18Size320to340 = WHERE((Age_Gro[Size320to340] EQ 18), AGE18Size320to340count)
      age19Size320to340 = WHERE((Age_Gro[Size320to340] EQ 19), AGE19Size320to340count)
      age20Size320to340 = WHERE((Age_Gro[Size320to340] EQ 20), AGE20Size320to340count)
      age21Size320to340 = WHERE((Age_Gro[Size320to340] EQ 21), AGE21Size320to340count)
      age22Size320to340 = WHERE((Age_Gro[Size320to340] EQ 22), AGE22Size320to340count)
      age23Size320to340 = WHERE((Age_Gro[Size320to340] EQ 23), AGE23Size320to340count)
      age24Size320to340 = WHERE((Age_Gro[Size320to340] EQ 24), AGE24Size320to340count)
      age25Size320to340 = WHERE((Age_Gro[Size320to340] EQ 25), AGE25Size320to340count)
      age26Size320to340 = WHERE((Age_Gro[Size320to340] EQ 26), AGE26Size320to340count)

      WAE_length_bin[10, i*NumLengthBin+adj+12L] = Age0Size320to340count
      WAE_length_bin[11, i*NumLengthBin+adj+12L] = Age1Size320to340count
      WAE_length_bin[12, i*NumLengthBin+adj+12L] = Age2Size320to340count
      WAE_length_bin[13, i*NumLengthBin+adj+12L] = Age3Size320to340count
      WAE_length_bin[14, i*NumLengthBin+adj+12L] = Age4Size320to340count
      WAE_length_bin[15, i*NumLengthBin+adj+12L] = Age5Size320to340count
      WAE_length_bin[16, i*NumLengthBin+adj+12L] = Age6Size320to340count
      WAE_length_bin[17, i*NumLengthBin+adj+12L] = Age7Size320to340count
      WAE_length_bin[18, i*NumLengthBin+adj+12L] = Age8Size320to340count
      WAE_length_bin[19, i*NumLengthBin+adj+12L] = Age9Size320to340count
      WAE_length_bin[20, i*NumLengthBin+adj+12L] = Age10Size320to340count
      WAE_length_bin[21, i*NumLengthBin+adj+12L] = Age11Size320to340count
      WAE_length_bin[22, i*NumLengthBin+adj+12L] = Age12Size320to340count
      WAE_length_bin[23, i*NumLengthBin+adj+12L] = Age13Size320to340count
      WAE_length_bin[24, i*NumLengthBin+adj+12L] = Age14Size320to340count
      WAE_length_bin[25, i*NumLengthBin+adj+12L] = Age15Size320to340count
      WAE_length_bin[26, i*NumLengthBin+adj+12L] = Age16Size320to340count
      WAE_length_bin[27, i*NumLengthBin+adj+12L] = Age17Size320to340count
      WAE_length_bin[28, i*NumLengthBin+adj+12L] = Age18Size320to340count
      WAE_length_bin[29, i*NumLengthBin+adj+12L] = Age19Size320to340count
      WAE_length_bin[30, i*NumLengthBin+adj+12L] = Age20Size320to340count
      WAE_length_bin[31, i*NumLengthBin+adj+12L] = Age21Size320to340count
      WAE_length_bin[32, i*NumLengthBin+adj+12L] = Age22Size320to340count
      WAE_length_bin[33, i*NumLengthBin+adj+12L] = Age23Size320to340count
      WAE_length_bin[34, i*NumLengthBin+adj+12L] = Age24Size320to340count
      WAE_length_bin[35, i*NumLengthBin+adj+12L] = Age25Size320to340count
      WAE_length_bin[36, i*NumLengthBin+adj+12L] = Age26Size320to340count
    ENDIF
    PRINT, 'Size320to340', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+12L])


    WAE_length_bin[0, i*NumLengthBin+adj+13L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+13L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+13L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+13L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+13L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+13L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+13L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+13L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+13L] = 340
    WAE_length_bin[9, i*NumLengthBin+adj+13L] =  Size340to360count

    ; length bin 14
    IF Size340to360count GT 0 THEN BEGIN
      age0Size340to360 = WHERE((Age_Gro[Size340to360] EQ 0), Age0Size340to360count)
      age1Size340to360 = WHERE((Age_Gro[Size340to360] EQ 1), Age1Size340to360count)
      age2Size340to360 = WHERE((Age_Gro[Size340to360] EQ 2), AGE2Size340to360count)
      age3Size340to360 = WHERE((Age_Gro[Size340to360] EQ 3), AGE3Size340to360count)
      age4Size340to360 = WHERE((Age_Gro[Size340to360] EQ 4), AGE4Size340to360count)
      age5Size340to360 = WHERE((Age_Gro[Size340to360] EQ 5), AGE5Size340to360count)
      age6Size340to360 = WHERE((Age_Gro[Size340to360] EQ 6), AGE6Size340to360count)
      age7Size340to360 = WHERE((Age_Gro[Size340to360] EQ 7), AGE7Size340to360count)
      age8Size340to360 = WHERE((Age_Gro[Size340to360] EQ 8), AGE8Size340to360count)
      age9Size340to360 = WHERE((Age_Gro[Size340to360] EQ 9), AGE9Size340to360count)
      age10Size340to360 = WHERE((Age_Gro[Size340to360] EQ 10), AGE10Size340to360count)
      age11Size340to360 = WHERE((Age_Gro[Size340to360] EQ 11), AGE11Size340to360count)
      AGE12Size340to360 = WHERE((Age_Gro[Size340to360] EQ 12), AGE12Size340to360count)
      AGE13Size340to360 = WHERE((Age_Gro[Size340to360] EQ 13), AGE13Size340to360count)
      AGE14Size340to360 = WHERE((Age_Gro[Size340to360] EQ 14), AGE14Size340to360count)
      AGE15Size340to360 = WHERE((Age_Gro[Size340to360] EQ 15), AGE15Size340to360count)
      age16Size340to360 = WHERE((Age_Gro[Size340to360] EQ 16), Age16Size340to360count)
      age17Size340to360 = WHERE((Age_Gro[Size340to360] EQ 17), AGE17Size340to360count)
      age18Size340to360 = WHERE((Age_Gro[Size340to360] EQ 18), AGE18Size340to360count)
      age19Size340to360 = WHERE((Age_Gro[Size340to360] EQ 19), AGE19Size340to360count)
      age20Size340to360 = WHERE((Age_Gro[Size340to360] EQ 20), AGE20Size340to360count)
      age21Size340to360 = WHERE((Age_Gro[Size340to360] EQ 21), AGE21Size340to360count)
      age22Size340to360 = WHERE((Age_Gro[Size340to360] EQ 22), AGE22Size340to360count)
      age23Size340to360 = WHERE((Age_Gro[Size340to360] EQ 23), AGE23Size340to360count)
      age24Size340to360 = WHERE((Age_Gro[Size340to360] EQ 24), AGE24Size340to360count)
      age25Size340to360 = WHERE((Age_Gro[Size340to360] EQ 25), AGE25Size340to360count)
      age26Size340to360 = WHERE((Age_Gro[Size340to360] EQ 26), AGE26Size340to360count)

      WAE_length_bin[10, i*NumLengthBin+adj+13L] = Age0Size340to360count
      WAE_length_bin[11, i*NumLengthBin+adj+13L] = Age1Size340to360count
      WAE_length_bin[12, i*NumLengthBin+adj+13L] = Age2Size340to360count
      WAE_length_bin[13, i*NumLengthBin+adj+13L] = Age3Size340to360count
      WAE_length_bin[14, i*NumLengthBin+adj+13L] = Age4Size340to360count
      WAE_length_bin[15, i*NumLengthBin+adj+13L] = Age5Size340to360count
      WAE_length_bin[16, i*NumLengthBin+adj+13L] = Age6Size340to360count
      WAE_length_bin[17, i*NumLengthBin+adj+13L] = Age7Size340to360count
      WAE_length_bin[18, i*NumLengthBin+adj+13L] = Age8Size340to360count
      WAE_length_bin[19, i*NumLengthBin+adj+13L] = Age9Size340to360count
      WAE_length_bin[20, i*NumLengthBin+adj+13L] = Age10Size340to360count
      WAE_length_bin[21, i*NumLengthBin+adj+13L] = Age11Size340to360count
      WAE_length_bin[22, i*NumLengthBin+adj+13L] = Age12Size340to360count
      WAE_length_bin[23, i*NumLengthBin+adj+13L] = Age13Size340to360count
      WAE_length_bin[24, i*NumLengthBin+adj+13L] = Age14Size340to360count
      WAE_length_bin[25, i*NumLengthBin+adj+13L] = Age15Size340to360count
      WAE_length_bin[26, i*NumLengthBin+adj+13L] = Age16Size340to360count
      WAE_length_bin[27, i*NumLengthBin+adj+13L] = Age17Size340to360count
      WAE_length_bin[28, i*NumLengthBin+adj+13L] = Age18Size340to360count
      WAE_length_bin[29, i*NumLengthBin+adj+13L] = Age19Size340to360count
      WAE_length_bin[30, i*NumLengthBin+adj+13L] = Age20Size340to360count
      WAE_length_bin[31, i*NumLengthBin+adj+13L] = Age21Size340to360count
      WAE_length_bin[32, i*NumLengthBin+adj+13L] = Age22Size340to360count
      WAE_length_bin[33, i*NumLengthBin+adj+13L] = Age23Size340to360count
      WAE_length_bin[34, i*NumLengthBin+adj+13L] = Age24Size340to360count
      WAE_length_bin[35, i*NumLengthBin+adj+13L] = Age25Size340to360count
      WAE_length_bin[36, i*NumLengthBin+adj+13L] = Age26Size340to360count
    ENDIF
    PRINT, ' Size340to360', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+13L])

    WAE_length_bin[0, i*NumLengthBin+adj+14L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+14L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+14L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+14L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+14L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+14L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+14L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+14L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+14L] = 360
    WAE_length_bin[9, i*NumLengthBin+adj+14L] =  Size360to380count

    ; length bin 15
    IF Size360to380count GT 0 THEN BEGIN
      age0Size360to380 = WHERE((Age_Gro[Size360to380] EQ 0), Age0Size360to380count)
      age1Size360to380 = WHERE((Age_Gro[Size360to380] EQ 1), Age1Size360to380count)
      age2Size360to380 = WHERE((Age_Gro[Size360to380] EQ 2), AGE2Size360to380count)
      age3Size360to380 = WHERE((Age_Gro[Size360to380] EQ 3), AGE3Size360to380count)
      age4Size360to380 = WHERE((Age_Gro[Size360to380] EQ 4), AGE4Size360to380count)
      age5Size360to380 = WHERE((Age_Gro[Size360to380] EQ 5), AGE5Size360to380count)
      age6Size360to380 = WHERE((Age_Gro[Size360to380] EQ 6), AGE6Size360to380count)
      age7Size360to380 = WHERE((Age_Gro[Size360to380] EQ 7), AGE7Size360to380count)
      age8Size360to380 = WHERE((Age_Gro[Size360to380] EQ 8), AGE8Size360to380count)
      age9Size360to380 = WHERE((Age_Gro[Size360to380] EQ 9), AGE9Size360to380count)
      age10Size360to380 = WHERE((Age_Gro[Size360to380] EQ 10), AGE10Size360to380count)
      age11Size360to380 = WHERE((Age_Gro[Size360to380] EQ 11), AGE11Size360to380count)
      AGE12Size360to380 = WHERE((Age_Gro[Size360to380] EQ 12), AGE12Size360to380count)
      AGE13Size360to380 = WHERE((Age_Gro[Size360to380] EQ 13), AGE13Size360to380count)
      AGE14Size360to380 = WHERE((Age_Gro[Size360to380] EQ 14), AGE14Size360to380count)
      AGE15Size360to380 = WHERE((Age_Gro[Size360to380] EQ 15), AGE15Size360to380count)
      age16Size360to380 = WHERE((Age_Gro[Size360to380] EQ 16), Age16Size360to380count)
      age17Size360to380 = WHERE((Age_Gro[Size360to380] EQ 17), AGE17Size360to380count)
      age18Size360to380 = WHERE((Age_Gro[Size360to380] EQ 18), AGE18Size360to380count)
      age19Size360to380 = WHERE((Age_Gro[Size360to380] EQ 19), AGE19Size360to380count)
      age20Size360to380 = WHERE((Age_Gro[Size360to380] EQ 20), AGE20Size360to380count)
      age21Size360to380 = WHERE((Age_Gro[Size360to380] EQ 21), AGE21Size360to380count)
      age22Size360to380 = WHERE((Age_Gro[Size360to380] EQ 22), AGE22Size360to380count)
      age23Size360to380 = WHERE((Age_Gro[Size360to380] EQ 23), AGE23Size360to380count)
      age24Size360to380 = WHERE((Age_Gro[Size360to380] EQ 24), AGE24Size360to380count)
      age25Size360to380 = WHERE((Age_Gro[Size360to380] EQ 25), AGE25Size360to380count)
      age26Size360to380 = WHERE((Age_Gro[Size360to380] EQ 26), AGE26Size360to380count)

      WAE_length_bin[10, i*NumLengthBin+adj+14L] = Age0Size360to380count
      WAE_length_bin[11, i*NumLengthBin+adj+14L] = Age1Size360to380count
      WAE_length_bin[12, i*NumLengthBin+adj+14L] = Age2Size360to380count
      WAE_length_bin[13, i*NumLengthBin+adj+14L] = Age3Size360to380count
      WAE_length_bin[14, i*NumLengthBin+adj+14L] = Age4Size360to380count
      WAE_length_bin[15, i*NumLengthBin+adj+14L] = Age5Size360to380count
      WAE_length_bin[16, i*NumLengthBin+adj+14L] = Age6Size360to380count
      WAE_length_bin[17, i*NumLengthBin+adj+14L] = Age7Size360to380count
      WAE_length_bin[18, i*NumLengthBin+adj+14L] = Age8Size360to380count
      WAE_length_bin[19, i*NumLengthBin+adj+14L] = Age9Size360to380count
      WAE_length_bin[20, i*NumLengthBin+adj+14L] = Age10Size360to380count
      WAE_length_bin[21, i*NumLengthBin+adj+14L] = Age11Size360to380count
      WAE_length_bin[22, i*NumLengthBin+adj+14L] = Age12Size360to380count
      WAE_length_bin[23, i*NumLengthBin+adj+14L] = Age13Size360to380count
      WAE_length_bin[24, i*NumLengthBin+adj+14L] = Age14Size360to380count
      WAE_length_bin[25, i*NumLengthBin+adj+14L] = Age15Size360to380count
      WAE_length_bin[26, i*NumLengthBin+adj+14L] = Age16Size360to380count
      WAE_length_bin[27, i*NumLengthBin+adj+14L] = Age17Size360to380count
      WAE_length_bin[28, i*NumLengthBin+adj+14L] = Age18Size360to380count
      WAE_length_bin[29, i*NumLengthBin+adj+14L] = Age19Size360to380count
      WAE_length_bin[30, i*NumLengthBin+adj+14L] = Age20Size360to380count
      WAE_length_bin[31, i*NumLengthBin+adj+14L] = Age21Size360to380count
      WAE_length_bin[32, i*NumLengthBin+adj+14L] = Age22Size360to380count
      WAE_length_bin[33, i*NumLengthBin+adj+14L] = Age23Size360to380count
      WAE_length_bin[34, i*NumLengthBin+adj+14L] = Age24Size360to380count
      WAE_length_bin[35, i*NumLengthBin+adj+14L] = Age25Size360to380count
      WAE_length_bin[36, i*NumLengthBin+adj+14L] = Age26Size360to380count
    ENDIF
    PRINT, ' Size360to380', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+14L])


    WAE_length_bin[0, i*NumLengthBin+adj+15L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+15L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+15L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+15L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+15L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+15L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+15L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+15L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+15L] = 380
    WAE_length_bin[9, i*NumLengthBin+adj+15L] =  Size380to400count

    ; length bin 16
    IF Size380to400count GT 0 THEN BEGIN
      age0Size380to400 = WHERE((Age_Gro[Size380to400] EQ 0), Age0Size380to400count)
      age1Size380to400 = WHERE((Age_Gro[Size380to400] EQ 1), Age1Size380to400count)
      age2Size380to400 = WHERE((Age_Gro[Size380to400] EQ 2), AGE2Size380to400count)
      age3Size380to400 = WHERE((Age_Gro[Size380to400] EQ 3), AGE3Size380to400count)
      age4Size380to400 = WHERE((Age_Gro[Size380to400] EQ 4), AGE4Size380to400count)
      age5Size380to400 = WHERE((Age_Gro[Size380to400] EQ 5), AGE5Size380to400count)
      age6Size380to400 = WHERE((Age_Gro[Size380to400] EQ 6), AGE6Size380to400count)
      age7Size380to400 = WHERE((Age_Gro[Size380to400] EQ 7), AGE7Size380to400count)
      age8Size380to400 = WHERE((Age_Gro[Size380to400] EQ 8), AGE8Size380to400count)
      age9Size380to400 = WHERE((Age_Gro[Size380to400] EQ 9), AGE9Size380to400count)
      age10Size380to400 = WHERE((Age_Gro[Size380to400] EQ 10), AGE10Size380to400count)
      age11Size380to400 = WHERE((Age_Gro[Size380to400] EQ 11), AGE11Size380to400count)
      AGE12Size380to400 = WHERE((Age_Gro[Size380to400] EQ 12), AGE12Size380to400count)
      AGE13Size380to400 = WHERE((Age_Gro[Size380to400] EQ 13), AGE13Size380to400count)
      AGE14Size380to400 = WHERE((Age_Gro[Size380to400] EQ 14), AGE14Size380to400count)
      AGE15Size380to400 = WHERE((Age_Gro[Size380to400] EQ 15), AGE15Size380to400count)
      age16Size380to400 = WHERE((Age_Gro[Size380to400] EQ 16), Age16Size380to400count)
      age17Size380to400 = WHERE((Age_Gro[Size380to400] EQ 17), AGE17Size380to400count)
      age18Size380to400 = WHERE((Age_Gro[Size380to400] EQ 18), AGE18Size380to400count)
      age19Size380to400 = WHERE((Age_Gro[Size380to400] EQ 19), AGE19Size380to400count)
      age20Size380to400 = WHERE((Age_Gro[Size380to400] EQ 20), AGE20Size380to400count)
      age21Size380to400 = WHERE((Age_Gro[Size380to400] EQ 21), AGE21Size380to400count)
      age22Size380to400 = WHERE((Age_Gro[Size380to400] EQ 22), AGE22Size380to400count)
      age23Size380to400 = WHERE((Age_Gro[Size380to400] EQ 23), AGE23Size380to400count)
      age24Size380to400 = WHERE((Age_Gro[Size380to400] EQ 24), AGE24Size380to400count)
      age25Size380to400 = WHERE((Age_Gro[Size380to400] EQ 25), AGE25Size380to400count)
      age26Size380to400 = WHERE((Age_Gro[Size380to400] EQ 26), AGE26Size380to400count)

      WAE_length_bin[10, i*NumLengthBin+adj+15L] = Age0Size380to400count
      WAE_length_bin[11, i*NumLengthBin+adj+15L] = Age1Size380to400count
      WAE_length_bin[12, i*NumLengthBin+adj+15L] = Age2Size380to400count
      WAE_length_bin[13, i*NumLengthBin+adj+15L] = Age3Size380to400count
      WAE_length_bin[14, i*NumLengthBin+adj+15L] = Age4Size380to400count
      WAE_length_bin[15, i*NumLengthBin+adj+15L] = Age5Size380to400count
      WAE_length_bin[16, i*NumLengthBin+adj+15L] = Age6Size380to400count
      WAE_length_bin[17, i*NumLengthBin+adj+15L] = Age7Size380to400count
      WAE_length_bin[18, i*NumLengthBin+adj+15L] = Age8Size380to400count
      WAE_length_bin[19, i*NumLengthBin+adj+15L] = Age9Size380to400count
      WAE_length_bin[20, i*NumLengthBin+adj+15L] = Age10Size380to400count
      WAE_length_bin[21, i*NumLengthBin+adj+15L] = Age11Size380to400count
      WAE_length_bin[22, i*NumLengthBin+adj+15L] = Age12Size380to400count
      WAE_length_bin[23, i*NumLengthBin+adj+15L] = Age13Size380to400count
      WAE_length_bin[24, i*NumLengthBin+adj+15L] = Age14Size380to400count
      WAE_length_bin[25, i*NumLengthBin+adj+15L] = Age15Size380to400count
      WAE_length_bin[26, i*NumLengthBin+adj+15L] = Age16Size380to400count
      WAE_length_bin[27, i*NumLengthBin+adj+15L] = Age17Size380to400count
      WAE_length_bin[28, i*NumLengthBin+adj+15L] = Age18Size380to400count
      WAE_length_bin[29, i*NumLengthBin+adj+15L] = Age19Size380to400count
      WAE_length_bin[30, i*NumLengthBin+adj+15L] = Age20Size380to400count
      WAE_length_bin[31, i*NumLengthBin+adj+15L] = Age21Size380to400count
      WAE_length_bin[32, i*NumLengthBin+adj+15L] = Age22Size380to400count
      WAE_length_bin[33, i*NumLengthBin+adj+15L] = Age23Size380to400count
      WAE_length_bin[34, i*NumLengthBin+adj+15L] = Age24Size380to400count
      WAE_length_bin[35, i*NumLengthBin+adj+15L] = Age25Size380to400count
      WAE_length_bin[36, i*NumLengthBin+adj+15L] = Age26Size380to400count
    ENDIF
    PRINT, 'Size380to400', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+15L])


    WAE_length_bin[0, i*NumLengthBin+adj+16L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+16L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+16L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+16L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+16L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+16L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+16L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+16L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+16L] = 400
    WAE_length_bin[9, i*NumLengthBin+adj+16L] =  Size400to420count

    ; length bin 17
    IF Size400to420count GT 0 THEN BEGIN
      age0Size400to420 = WHERE((Age_Gro[Size400to420] EQ 0), Age0Size400to420count)
      age1Size400to420 = WHERE((Age_Gro[Size400to420] EQ 1), Age1Size400to420count)
      age2Size400to420 = WHERE((Age_Gro[Size400to420] EQ 2), AGE2Size400to420count)
      age3Size400to420 = WHERE((Age_Gro[Size400to420] EQ 3), AGE3Size400to420count)
      age4Size400to420 = WHERE((Age_Gro[Size400to420] EQ 4), AGE4Size400to420count)
      age5Size400to420 = WHERE((Age_Gro[Size400to420] EQ 5), AGE5Size400to420count)
      age6Size400to420 = WHERE((Age_Gro[Size400to420] EQ 6), AGE6Size400to420count)
      age7Size400to420 = WHERE((Age_Gro[Size400to420] EQ 7), AGE7Size400to420count)
      age8Size400to420 = WHERE((Age_Gro[Size400to420] EQ 8), AGE8Size400to420count)
      age9Size400to420 = WHERE((Age_Gro[Size400to420] EQ 9), AGE9Size400to420count)
      age10Size400to420 = WHERE((Age_Gro[Size400to420] EQ 10), AGE10Size400to420count)
      age11Size400to420 = WHERE((Age_Gro[Size400to420] EQ 11), AGE11Size400to420count)
      AGE12Size400to420 = WHERE((Age_Gro[Size400to420] EQ 12), AGE12Size400to420count)
      AGE13Size400to420 = WHERE((Age_Gro[Size400to420] EQ 13), AGE13Size400to420count)
      AGE14Size400to420 = WHERE((Age_Gro[Size400to420] EQ 14), AGE14Size400to420count)
      AGE15Size400to420 = WHERE((Age_Gro[Size400to420] EQ 15), AGE15Size400to420count)
      age16Size400to420 = WHERE((Age_Gro[Size400to420] EQ 16), Age16Size400to420count)
      age17Size400to420 = WHERE((Age_Gro[Size400to420] EQ 17), AGE17Size400to420count)
      age18Size400to420 = WHERE((Age_Gro[Size400to420] EQ 18), AGE18Size400to420count)
      age19Size400to420 = WHERE((Age_Gro[Size400to420] EQ 19), AGE19Size400to420count)
      age20Size400to420 = WHERE((Age_Gro[Size400to420] EQ 20), AGE20Size400to420count)
      age21Size400to420 = WHERE((Age_Gro[Size400to420] EQ 21), AGE21Size400to420count)
      age22Size400to420 = WHERE((Age_Gro[Size400to420] EQ 22), AGE22Size400to420count)
      age23Size400to420 = WHERE((Age_Gro[Size400to420] EQ 23), AGE23Size400to420count)
      age24Size400to420 = WHERE((Age_Gro[Size400to420] EQ 24), AGE24Size400to420count)
      age25Size400to420 = WHERE((Age_Gro[Size400to420] EQ 25), AGE25Size400to420count)
      age26Size400to420 = WHERE((Age_Gro[Size400to420] EQ 26), AGE26Size400to420count)

      WAE_length_bin[10, i*NumLengthBin+adj+16L] = Age0Size400to420count
      WAE_length_bin[11, i*NumLengthBin+adj+16L] = Age1Size400to420count
      WAE_length_bin[12, i*NumLengthBin+adj+16L] = Age2Size400to420count
      WAE_length_bin[13, i*NumLengthBin+adj+16L] = Age3Size400to420count
      WAE_length_bin[14, i*NumLengthBin+adj+16L] = Age4Size400to420count
      WAE_length_bin[15, i*NumLengthBin+adj+16L] = Age5Size400to420count
      WAE_length_bin[16, i*NumLengthBin+adj+16L] = Age6Size400to420count
      WAE_length_bin[17, i*NumLengthBin+adj+16L] = Age7Size400to420count
      WAE_length_bin[18, i*NumLengthBin+adj+16L] = Age8Size400to420count
      WAE_length_bin[19, i*NumLengthBin+adj+16L] = Age9Size400to420count
      WAE_length_bin[20, i*NumLengthBin+adj+16L] = Age10Size400to420count
      WAE_length_bin[21, i*NumLengthBin+adj+16L] = Age11Size400to420count
      WAE_length_bin[22, i*NumLengthBin+adj+16L] = Age12Size400to420count
      WAE_length_bin[23, i*NumLengthBin+adj+16L] = Age13Size400to420count
      WAE_length_bin[24, i*NumLengthBin+adj+16L] = Age14Size400to420count
      WAE_length_bin[25, i*NumLengthBin+adj+16L] = Age15Size400to420count
      WAE_length_bin[26, i*NumLengthBin+adj+16L] = Age16Size400to420count
      WAE_length_bin[27, i*NumLengthBin+adj+16L] = Age17Size400to420count
      WAE_length_bin[28, i*NumLengthBin+adj+16L] = Age18Size400to420count
      WAE_length_bin[29, i*NumLengthBin+adj+16L] = Age19Size400to420count
      WAE_length_bin[30, i*NumLengthBin+adj+16L] = Age20Size400to420count
      WAE_length_bin[31, i*NumLengthBin+adj+16L] = Age21Size400to420count
      WAE_length_bin[32, i*NumLengthBin+adj+16L] = Age22Size400to420count
      WAE_length_bin[33, i*NumLengthBin+adj+16L] = Age23Size400to420count
      WAE_length_bin[34, i*NumLengthBin+adj+16L] = Age24Size400to420count
      WAE_length_bin[35, i*NumLengthBin+adj+16L] = Age25Size400to420count
      WAE_length_bin[36, i*NumLengthBin+adj+16L] = Age26Size400to420count
    ENDIF
    PRINT, 'Size400to420', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+16L])


    WAE_length_bin[0, i*NumLengthBin+adj+17L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+17L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+17L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+17L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+17L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+17L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+17L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+17L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+17L] = 420
    WAE_length_bin[9, i*NumLengthBin+adj+17L] =  Size420to440count

    ; length bin 18
    IF Size420to440count GT 0 THEN BEGIN
      age0Size420to440 = WHERE((Age_Gro[Size420to440] EQ 0), Age0Size420to440count)
      age1Size420to440 = WHERE((Age_Gro[Size420to440] EQ 1), Age1Size420to440count)
      age2Size420to440 = WHERE((Age_Gro[Size420to440] EQ 2), AGE2Size420to440count)
      age3Size420to440 = WHERE((Age_Gro[Size420to440] EQ 3), AGE3Size420to440count)
      age4Size420to440 = WHERE((Age_Gro[Size420to440] EQ 4), AGE4Size420to440count)
      age5Size420to440 = WHERE((Age_Gro[Size420to440] EQ 5), AGE5Size420to440count)
      age6Size420to440 = WHERE((Age_Gro[Size420to440] EQ 6), AGE6Size420to440count)
      age7Size420to440 = WHERE((Age_Gro[Size420to440] EQ 7), AGE7Size420to440count)
      age8Size420to440 = WHERE((Age_Gro[Size420to440] EQ 8), AGE8Size420to440count)
      age9Size420to440 = WHERE((Age_Gro[Size420to440] EQ 9), AGE9Size420to440count)
      age10Size420to440 = WHERE((Age_Gro[Size420to440] EQ 10), AGE10Size420to440count)
      age11Size420to440 = WHERE((Age_Gro[Size420to440] EQ 11), AGE11Size420to440count)
      AGE12Size420to440 = WHERE((Age_Gro[Size420to440] EQ 12), AGE12Size420to440count)
      AGE13Size420to440 = WHERE((Age_Gro[Size420to440] EQ 13), AGE13Size420to440count)
      AGE14Size420to440 = WHERE((Age_Gro[Size420to440] EQ 14), AGE14Size420to440count)
      AGE15Size420to440 = WHERE((Age_Gro[Size420to440] EQ 15), AGE15Size420to440count)
      age16Size420to440 = WHERE((Age_Gro[Size420to440] EQ 16), Age16Size420to440count)
      age17Size420to440 = WHERE((Age_Gro[Size420to440] EQ 17), AGE17Size420to440count)
      age18Size420to440 = WHERE((Age_Gro[Size420to440] EQ 18), AGE18Size420to440count)
      age19Size420to440 = WHERE((Age_Gro[Size420to440] EQ 19), AGE19Size420to440count)
      age20Size420to440 = WHERE((Age_Gro[Size420to440] EQ 20), AGE20Size420to440count)
      age21Size420to440 = WHERE((Age_Gro[Size420to440] EQ 21), AGE21Size420to440count)
      age22Size420to440 = WHERE((Age_Gro[Size420to440] EQ 22), AGE22Size420to440count)
      age23Size420to440 = WHERE((Age_Gro[Size420to440] EQ 23), AGE23Size420to440count)
      age24Size420to440 = WHERE((Age_Gro[Size420to440] EQ 24), AGE24Size420to440count)
      age25Size420to440 = WHERE((Age_Gro[Size420to440] EQ 25), AGE25Size420to440count)
      age26Size420to440 = WHERE((Age_Gro[Size420to440] EQ 26), AGE26Size420to440count)

      WAE_length_bin[10, i*NumLengthBin+adj+17L] = Age0Size420to440count
      WAE_length_bin[11, i*NumLengthBin+adj+17L] = Age1Size420to440count
      WAE_length_bin[12, i*NumLengthBin+adj+17L] = Age2Size420to440count
      WAE_length_bin[13, i*NumLengthBin+adj+17L] = Age3Size420to440count
      WAE_length_bin[14, i*NumLengthBin+adj+17L] = Age4Size420to440count
      WAE_length_bin[15, i*NumLengthBin+adj+17L] = Age5Size420to440count
      WAE_length_bin[16, i*NumLengthBin+adj+17L] = Age6Size420to440count
      WAE_length_bin[17, i*NumLengthBin+adj+17L] = Age7Size420to440count
      WAE_length_bin[18, i*NumLengthBin+adj+17L] = Age8Size420to440count
      WAE_length_bin[19, i*NumLengthBin+adj+17L] = Age9Size420to440count
      WAE_length_bin[20, i*NumLengthBin+adj+17L] = Age10Size420to440count
      WAE_length_bin[21, i*NumLengthBin+adj+17L] = Age11Size420to440count
      WAE_length_bin[22, i*NumLengthBin+adj+17L] = Age12Size420to440count
      WAE_length_bin[23, i*NumLengthBin+adj+17L] = Age13Size420to440count
      WAE_length_bin[24, i*NumLengthBin+adj+17L] = Age14Size420to440count
      WAE_length_bin[25, i*NumLengthBin+adj+17L] = Age15Size420to440count
      WAE_length_bin[26, i*NumLengthBin+adj+17L] = Age16Size420to440count
      WAE_length_bin[27, i*NumLengthBin+adj+17L] = Age17Size420to440count
      WAE_length_bin[28, i*NumLengthBin+adj+17L] = Age18Size420to440count
      WAE_length_bin[29, i*NumLengthBin+adj+17L] = Age19Size420to440count
      WAE_length_bin[30, i*NumLengthBin+adj+17L] = Age20Size420to440count
      WAE_length_bin[31, i*NumLengthBin+adj+17L] = Age21Size420to440count
      WAE_length_bin[32, i*NumLengthBin+adj+17L] = Age22Size420to440count
      WAE_length_bin[33, i*NumLengthBin+adj+17L] = Age23Size420to440count
      WAE_length_bin[34, i*NumLengthBin+adj+17L] = Age24Size420to440count
      WAE_length_bin[35, i*NumLengthBin+adj+17L] = Age25Size420to440count
      WAE_length_bin[36, i*NumLengthBin+adj+17L] = Age26Size420to440count
    ENDIF
    PRINT, ' Size420to440', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+17L])


    WAE_length_bin[0, i*NumLengthBin+adj+18L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+18L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+18L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+18L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+18L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+18L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+18L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+18L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+18L] = 440
    WAE_length_bin[9, i*NumLengthBin+adj+18L] =  Size440to460count

    ; length bin 19
    IF Size440to460count GT 0 THEN BEGIN
      age0Size440to460 = WHERE((Age_Gro[Size440to460] EQ 0), Age0Size440to460count)
      age1Size440to460 = WHERE((Age_Gro[Size440to460] EQ 1), Age1Size440to460count)
      age2Size440to460 = WHERE((Age_Gro[Size440to460] EQ 2), AGE2Size440to460count)
      age3Size440to460 = WHERE((Age_Gro[Size440to460] EQ 3), AGE3Size440to460count)
      age4Size440to460 = WHERE((Age_Gro[Size440to460] EQ 4), AGE4Size440to460count)
      age5Size440to460 = WHERE((Age_Gro[Size440to460] EQ 5), AGE5Size440to460count)
      age6Size440to460 = WHERE((Age_Gro[Size440to460] EQ 6), AGE6Size440to460count)
      age7Size440to460 = WHERE((Age_Gro[Size440to460] EQ 7), AGE7Size440to460count)
      age8Size440to460 = WHERE((Age_Gro[Size440to460] EQ 8), AGE8Size440to460count)
      age9Size440to460 = WHERE((Age_Gro[Size440to460] EQ 9), AGE9Size440to460count)
      age10Size440to460 = WHERE((Age_Gro[Size440to460] EQ 10), AGE10Size440to460count)
      age11Size440to460 = WHERE((Age_Gro[Size440to460] EQ 11), AGE11Size440to460count)
      AGE12Size440to460 = WHERE((Age_Gro[Size440to460] EQ 12), AGE12Size440to460count)
      AGE13Size440to460 = WHERE((Age_Gro[Size440to460] EQ 13), AGE13Size440to460count)
      AGE14Size440to460 = WHERE((Age_Gro[Size440to460] EQ 14), AGE14Size440to460count)
      AGE15Size440to460 = WHERE((Age_Gro[Size440to460] EQ 15), AGE15Size440to460count)
      age16Size440to460 = WHERE((Age_Gro[Size440to460] EQ 16), Age16Size440to460count)
      age17Size440to460 = WHERE((Age_Gro[Size440to460] EQ 17), AGE17Size440to460count)
      age18Size440to460 = WHERE((Age_Gro[Size440to460] EQ 18), AGE18Size440to460count)
      age19Size440to460 = WHERE((Age_Gro[Size440to460] EQ 19), AGE19Size440to460count)
      age20Size440to460 = WHERE((Age_Gro[Size440to460] EQ 20), AGE20Size440to460count)
      age21Size440to460 = WHERE((Age_Gro[Size440to460] EQ 21), AGE21Size440to460count)
      age22Size440to460 = WHERE((Age_Gro[Size440to460] EQ 22), AGE22Size440to460count)
      age23Size440to460 = WHERE((Age_Gro[Size440to460] EQ 23), AGE23Size440to460count)
      age24Size440to460 = WHERE((Age_Gro[Size440to460] EQ 24), AGE24Size440to460count)
      age25Size440to460 = WHERE((Age_Gro[Size440to460] EQ 25), AGE25Size440to460count)
      age26Size440to460 = WHERE((Age_Gro[Size440to460] EQ 26), AGE26Size440to460count)

      WAE_length_bin[10, i*NumLengthBin+adj+18L] = Age0Size440to460count
      WAE_length_bin[11, i*NumLengthBin+adj+18L] = Age1Size440to460count
      WAE_length_bin[12, i*NumLengthBin+adj+18L] = Age2Size440to460count
      WAE_length_bin[13, i*NumLengthBin+adj+18L] = Age3Size440to460count
      WAE_length_bin[14, i*NumLengthBin+adj+18L] = Age4Size440to460count
      WAE_length_bin[15, i*NumLengthBin+adj+18L] = Age5Size440to460count
      WAE_length_bin[16, i*NumLengthBin+adj+18L] = Age6Size440to460count
      WAE_length_bin[17, i*NumLengthBin+adj+18L] = Age7Size440to460count
      WAE_length_bin[18, i*NumLengthBin+adj+18L] = Age8Size440to460count
      WAE_length_bin[19, i*NumLengthBin+adj+18L] = Age9Size440to460count
      WAE_length_bin[20, i*NumLengthBin+adj+18L] = Age10Size440to460count
      WAE_length_bin[21, i*NumLengthBin+adj+18L] = Age11Size440to460count
      WAE_length_bin[22, i*NumLengthBin+adj+18L] = Age12Size440to460count
      WAE_length_bin[23, i*NumLengthBin+adj+18L] = Age13Size440to460count
      WAE_length_bin[24, i*NumLengthBin+adj+18L] = Age14Size440to460count
      WAE_length_bin[25, i*NumLengthBin+adj+18L] = Age15Size440to460count
      WAE_length_bin[26, i*NumLengthBin+adj+18L] = Age16Size440to460count
      WAE_length_bin[27, i*NumLengthBin+adj+18L] = Age17Size440to460count
      WAE_length_bin[28, i*NumLengthBin+adj+18L] = Age18Size440to460count
      WAE_length_bin[29, i*NumLengthBin+adj+18L] = Age19Size440to460count
      WAE_length_bin[30, i*NumLengthBin+adj+18L] = Age20Size440to460count
      WAE_length_bin[31, i*NumLengthBin+adj+18L] = Age21Size440to460count
      WAE_length_bin[32, i*NumLengthBin+adj+18L] = Age22Size440to460count
      WAE_length_bin[33, i*NumLengthBin+adj+18L] = Age23Size440to460count
      WAE_length_bin[34, i*NumLengthBin+adj+18L] = Age24Size440to460count
      WAE_length_bin[35, i*NumLengthBin+adj+18L] = Age25Size440to460count
      WAE_length_bin[36, i*NumLengthBin+adj+18L] = Age26Size440to460count
    ENDIF
    PRINT, 'Size440to460', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+18L])

    WAE_length_bin[0, i*NumLengthBin+adj+19L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+19L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+19L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+19L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+19L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+19L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+19L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+19L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+19L] = 460
    WAE_length_bin[9, i*NumLengthBin+adj+19L] =  Size460to480count

    ; length bin 20
    IF Size460to480count GT 0 THEN BEGIN
      age0Size460to480 = WHERE((Age_Gro[Size460to480] EQ 0), Age0Size460to480count)
      age1Size460to480 = WHERE((Age_Gro[Size460to480] EQ 1), Age1Size460to480count)
      age2Size460to480 = WHERE((Age_Gro[Size460to480] EQ 2), AGE2Size460to480count)
      age3Size460to480 = WHERE((Age_Gro[Size460to480] EQ 3), AGE3Size460to480count)
      age4Size460to480 = WHERE((Age_Gro[Size460to480] EQ 4), AGE4Size460to480count)
      age5Size460to480 = WHERE((Age_Gro[Size460to480] EQ 5), AGE5Size460to480count)
      age6Size460to480 = WHERE((Age_Gro[Size460to480] EQ 6), AGE6Size460to480count)
      age7Size460to480 = WHERE((Age_Gro[Size460to480] EQ 7), AGE7Size460to480count)
      age8Size460to480 = WHERE((Age_Gro[Size460to480] EQ 8), AGE8Size460to480count)
      age9Size460to480 = WHERE((Age_Gro[Size460to480] EQ 9), AGE9Size460to480count)
      age10Size460to480 = WHERE((Age_Gro[Size460to480] EQ 10), AGE10Size460to480count)
      age11Size460to480 = WHERE((Age_Gro[Size460to480] EQ 11), AGE11Size460to480count)
      AGE12Size460to480 = WHERE((Age_Gro[Size460to480] EQ 12), AGE12Size460to480count)
      AGE13Size460to480 = WHERE((Age_Gro[Size460to480] EQ 13), AGE13Size460to480count)
      AGE14Size460to480 = WHERE((Age_Gro[Size460to480] EQ 14), AGE14Size460to480count)
      AGE15Size460to480 = WHERE((Age_Gro[Size460to480] EQ 15), AGE15Size460to480count)
      age16Size460to480 = WHERE((Age_Gro[Size460to480] EQ 16), Age16Size460to480count)
      age17Size460to480 = WHERE((Age_Gro[Size460to480] EQ 17), AGE17Size460to480count)
      age18Size460to480 = WHERE((Age_Gro[Size460to480] EQ 18), AGE18Size460to480count)
      age19Size460to480 = WHERE((Age_Gro[Size460to480] EQ 19), AGE19Size460to480count)
      age20Size460to480 = WHERE((Age_Gro[Size460to480] EQ 20), AGE20Size460to480count)
      age21Size460to480 = WHERE((Age_Gro[Size460to480] EQ 21), AGE21Size460to480count)
      age22Size460to480 = WHERE((Age_Gro[Size460to480] EQ 22), AGE22Size460to480count)
      age23Size460to480 = WHERE((Age_Gro[Size460to480] EQ 23), AGE23Size460to480count)
      age24Size460to480 = WHERE((Age_Gro[Size460to480] EQ 24), AGE24Size460to480count)
      age25Size460to480 = WHERE((Age_Gro[Size460to480] EQ 25), AGE25Size460to480count)
      age26Size460to480 = WHERE((Age_Gro[Size460to480] EQ 26), AGE26Size460to480count)

      WAE_length_bin[10, i*NumLengthBin+adj+19L] = Age0Size460to480count
      WAE_length_bin[11, i*NumLengthBin+adj+19L] = Age1Size460to480count
      WAE_length_bin[12, i*NumLengthBin+adj+19L] = Age2Size460to480count
      WAE_length_bin[13, i*NumLengthBin+adj+19L] = Age3Size460to480count
      WAE_length_bin[14, i*NumLengthBin+adj+19L] = Age4Size460to480count
      WAE_length_bin[15, i*NumLengthBin+adj+19L] = Age5Size460to480count
      WAE_length_bin[16, i*NumLengthBin+adj+19L] = Age6Size460to480count
      WAE_length_bin[17, i*NumLengthBin+adj+19L] = Age7Size460to480count
      WAE_length_bin[18, i*NumLengthBin+adj+19L] = Age8Size460to480count
      WAE_length_bin[19, i*NumLengthBin+adj+19L] = Age9Size460to480count
      WAE_length_bin[20, i*NumLengthBin+adj+19L] = Age10Size460to480count
      WAE_length_bin[21, i*NumLengthBin+adj+19L] = Age11Size460to480count
      WAE_length_bin[22, i*NumLengthBin+adj+19L] = Age12Size460to480count
      WAE_length_bin[23, i*NumLengthBin+adj+19L] = Age13Size460to480count
      WAE_length_bin[24, i*NumLengthBin+adj+19L] = Age14Size460to480count
      WAE_length_bin[25, i*NumLengthBin+adj+19L] = Age15Size460to480count
      WAE_length_bin[26, i*NumLengthBin+adj+19L] = Age16Size460to480count
      WAE_length_bin[27, i*NumLengthBin+adj+19L] = Age17Size460to480count
      WAE_length_bin[28, i*NumLengthBin+adj+19L] = Age18Size460to480count
      WAE_length_bin[29, i*NumLengthBin+adj+19L] = Age19Size460to480count
      WAE_length_bin[30, i*NumLengthBin+adj+19L] = Age20Size460to480count
      WAE_length_bin[31, i*NumLengthBin+adj+19L] = Age21Size460to480count
      WAE_length_bin[32, i*NumLengthBin+adj+19L] = Age22Size460to480count
      WAE_length_bin[33, i*NumLengthBin+adj+19L] = Age23Size460to480count
      WAE_length_bin[34, i*NumLengthBin+adj+19L] = Age24Size460to480count
      WAE_length_bin[35, i*NumLengthBin+adj+19L] = Age25Size460to480count
      WAE_length_bin[36, i*NumLengthBin+adj+19L] = Age26Size460to480count
    ENDIF
    PRINT, ' Size460to480', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+19L])


    WAE_length_bin[0, i*NumLengthBin+adj+20L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+20L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+20L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+20L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+20L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+20L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+20L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+20L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+20L] = 480
    WAE_length_bin[9, i*NumLengthBin+adj+20L] =  Size480to500count

    ; length bin 21
    IF Size480to500count GT 0 THEN BEGIN
      age0Size480to500 = WHERE((Age_Gro[Size480to500] EQ 0), Age0Size480to500count)
      age1Size480to500 = WHERE((Age_Gro[Size480to500] EQ 1), Age1Size480to500count)
      age2Size480to500 = WHERE((Age_Gro[Size480to500] EQ 2), AGE2Size480to500count)
      age3Size480to500 = WHERE((Age_Gro[Size480to500] EQ 3), AGE3Size480to500count)
      age4Size480to500 = WHERE((Age_Gro[Size480to500] EQ 4), AGE4Size480to500count)
      age5Size480to500 = WHERE((Age_Gro[Size480to500] EQ 5), AGE5Size480to500count)
      age6Size480to500 = WHERE((Age_Gro[Size480to500] EQ 6), AGE6Size480to500count)
      age7Size480to500 = WHERE((Age_Gro[Size480to500] EQ 7), AGE7Size480to500count)
      age8Size480to500 = WHERE((Age_Gro[Size480to500] EQ 8), AGE8Size480to500count)
      age9Size480to500 = WHERE((Age_Gro[Size480to500] EQ 9), AGE9Size480to500count)
      age10Size480to500 = WHERE((Age_Gro[Size480to500] EQ 10), AGE10Size480to500count)
      age11Size480to500 = WHERE((Age_Gro[Size480to500] EQ 11), AGE11Size480to500count)
      AGE12Size480to500 = WHERE((Age_Gro[Size480to500] EQ 12), AGE12Size480to500count)
      AGE13Size480to500 = WHERE((Age_Gro[Size480to500] EQ 13), AGE13Size480to500count)
      AGE14Size480to500 = WHERE((Age_Gro[Size480to500] EQ 14), AGE14Size480to500count)
      AGE15Size480to500 = WHERE((Age_Gro[Size480to500] EQ 15), AGE15Size480to500count)
      age16Size480to500 = WHERE((Age_Gro[Size480to500] EQ 16), Age16Size480to500count)
      age17Size480to500 = WHERE((Age_Gro[Size480to500] EQ 17), AGE17Size480to500count)
      age18Size480to500 = WHERE((Age_Gro[Size480to500] EQ 18), AGE18Size480to500count)
      age19Size480to500 = WHERE((Age_Gro[Size480to500] EQ 19), AGE19Size480to500count)
      age20Size480to500 = WHERE((Age_Gro[Size480to500] EQ 20), AGE20Size480to500count)
      age21Size480to500 = WHERE((Age_Gro[Size480to500] EQ 21), AGE21Size480to500count)
      age22Size480to500 = WHERE((Age_Gro[Size480to500] EQ 22), AGE22Size480to500count)
      age23Size480to500 = WHERE((Age_Gro[Size480to500] EQ 23), AGE23Size480to500count)
      age24Size480to500 = WHERE((Age_Gro[Size480to500] EQ 24), AGE24Size480to500count)
      age25Size480to500 = WHERE((Age_Gro[Size480to500] EQ 25), AGE25Size480to500count)
      age26Size480to500 = WHERE((Age_Gro[Size480to500] EQ 26), AGE26Size480to500count)

      WAE_length_bin[10, i*NumLengthBin+adj+20L] = Age0Size480to500count
      WAE_length_bin[11, i*NumLengthBin+adj+20L] = Age1Size480to500count
      WAE_length_bin[12, i*NumLengthBin+adj+20L] = Age2Size480to500count
      WAE_length_bin[13, i*NumLengthBin+adj+20L] = Age3Size480to500count
      WAE_length_bin[14, i*NumLengthBin+adj+20L] = Age4Size480to500count
      WAE_length_bin[15, i*NumLengthBin+adj+20L] = Age5Size480to500count
      WAE_length_bin[16, i*NumLengthBin+adj+20L] = Age6Size480to500count
      WAE_length_bin[17, i*NumLengthBin+adj+20L] = Age7Size480to500count
      WAE_length_bin[18, i*NumLengthBin+adj+20L] = Age8Size480to500count
      WAE_length_bin[19, i*NumLengthBin+adj+20L] = Age9Size480to500count
      WAE_length_bin[20, i*NumLengthBin+adj+20L] = Age10Size480to500count
      WAE_length_bin[21, i*NumLengthBin+adj+20L] = Age11Size480to500count
      WAE_length_bin[22, i*NumLengthBin+adj+20L] = Age12Size480to500count
      WAE_length_bin[23, i*NumLengthBin+adj+20L] = Age13Size480to500count
      WAE_length_bin[24, i*NumLengthBin+adj+20L] = Age14Size480to500count
      WAE_length_bin[25, i*NumLengthBin+adj+20L] = Age15Size480to500count
      WAE_length_bin[26, i*NumLengthBin+adj+20L] = Age16Size480to500count
      WAE_length_bin[27, i*NumLengthBin+adj+20L] = Age17Size480to500count
      WAE_length_bin[28, i*NumLengthBin+adj+20L] = Age18Size480to500count
      WAE_length_bin[29, i*NumLengthBin+adj+20L] = Age19Size480to500count
      WAE_length_bin[30, i*NumLengthBin+adj+20L] = Age20Size480to500count
      WAE_length_bin[31, i*NumLengthBin+adj+20L] = Age21Size480to500count
      WAE_length_bin[32, i*NumLengthBin+adj+20L] = Age22Size480to500count
      WAE_length_bin[33, i*NumLengthBin+adj+20L] = Age23Size480to500count
      WAE_length_bin[34, i*NumLengthBin+adj+20L] = Age24Size480to500count
      WAE_length_bin[35, i*NumLengthBin+adj+20L] = Age25Size480to500count
      WAE_length_bin[36, i*NumLengthBin+adj+20L] = Age26Size480to500count
    ENDIF
    PRINT, ' Size480to500', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+20L])

    WAE_length_bin[0, i*NumLengthBin+adj+21L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+21L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+21L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+21L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+21L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+21L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+21L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+21L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+21L] = 500
    WAE_length_bin[9, i*NumLengthBin+adj+21L] =  Size500to520count

    ; length bin 22
    IF Size500to520count GT 0 THEN BEGIN
      age0Size500to520 = WHERE((Age_Gro[Size500to520] EQ 0), Age0Size500to520count)
      age1Size500to520 = WHERE((Age_Gro[Size500to520] EQ 1), Age1Size500to520count)
      age2Size500to520 = WHERE((Age_Gro[Size500to520] EQ 2), AGE2Size500to520count)
      age3Size500to520 = WHERE((Age_Gro[Size500to520] EQ 3), AGE3Size500to520count)
      age4Size500to520 = WHERE((Age_Gro[Size500to520] EQ 4), AGE4Size500to520count)
      age5Size500to520 = WHERE((Age_Gro[Size500to520] EQ 5), AGE5Size500to520count)
      age6Size500to520 = WHERE((Age_Gro[Size500to520] EQ 6), AGE6Size500to520count)
      age7Size500to520 = WHERE((Age_Gro[Size500to520] EQ 7), AGE7Size500to520count)
      age8Size500to520 = WHERE((Age_Gro[Size500to520] EQ 8), AGE8Size500to520count)
      age9Size500to520 = WHERE((Age_Gro[Size500to520] EQ 9), AGE9Size500to520count)
      age10Size500to520 = WHERE((Age_Gro[Size500to520] EQ 10), AGE10Size500to520count)
      age11Size500to520 = WHERE((Age_Gro[Size500to520] EQ 11), AGE11Size500to520count)
      AGE12Size500to520 = WHERE((Age_Gro[Size500to520] EQ 12), AGE12Size500to520count)
      AGE13Size500to520 = WHERE((Age_Gro[Size500to520] EQ 13), AGE13Size500to520count)
      AGE14Size500to520 = WHERE((Age_Gro[Size500to520] EQ 14), AGE14Size500to520count)
      AGE15Size500to520 = WHERE((Age_Gro[Size500to520] EQ 15), AGE15Size500to520count)
      age16Size500to520 = WHERE((Age_Gro[Size500to520] EQ 16), Age16Size500to520count)
      age17Size500to520 = WHERE((Age_Gro[Size500to520] EQ 17), AGE17Size500to520count)
      age18Size500to520 = WHERE((Age_Gro[Size500to520] EQ 18), AGE18Size500to520count)
      age19Size500to520 = WHERE((Age_Gro[Size500to520] EQ 19), AGE19Size500to520count)
      age20Size500to520 = WHERE((Age_Gro[Size500to520] EQ 20), AGE20Size500to520count)
      age21Size500to520 = WHERE((Age_Gro[Size500to520] EQ 21), AGE21Size500to520count)
      age22Size500to520 = WHERE((Age_Gro[Size500to520] EQ 22), AGE22Size500to520count)
      age23Size500to520 = WHERE((Age_Gro[Size500to520] EQ 23), AGE23Size500to520count)
      age24Size500to520 = WHERE((Age_Gro[Size500to520] EQ 24), AGE24Size500to520count)
      age25Size500to520 = WHERE((Age_Gro[Size500to520] EQ 25), AGE25Size500to520count)
      age26Size500to520 = WHERE((Age_Gro[Size500to520] EQ 26), AGE26Size500to520count)

      WAE_length_bin[10, i*NumLengthBin+adj+21L] = Age0Size500to520count
      WAE_length_bin[11, i*NumLengthBin+adj+21L] = Age1Size500to520count
      WAE_length_bin[12, i*NumLengthBin+adj+21L] = Age2Size500to520count
      WAE_length_bin[13, i*NumLengthBin+adj+21L] = Age3Size500to520count
      WAE_length_bin[14, i*NumLengthBin+adj+21L] = Age4Size500to520count
      WAE_length_bin[15, i*NumLengthBin+adj+21L] = Age5Size500to520count
      WAE_length_bin[16, i*NumLengthBin+adj+21L] = Age6Size500to520count
      WAE_length_bin[17, i*NumLengthBin+adj+21L] = Age7Size500to520count
      WAE_length_bin[18, i*NumLengthBin+adj+21L] = Age8Size500to520count
      WAE_length_bin[19, i*NumLengthBin+adj+21L] = Age9Size500to520count
      WAE_length_bin[20, i*NumLengthBin+adj+21L] = Age10Size500to520count
      WAE_length_bin[21, i*NumLengthBin+adj+21L] = Age11Size500to520count
      WAE_length_bin[22, i*NumLengthBin+adj+21L] = Age12Size500to520count
      WAE_length_bin[23, i*NumLengthBin+adj+21L] = Age13Size500to520count
      WAE_length_bin[24, i*NumLengthBin+adj+21L] = Age14Size500to520count
      WAE_length_bin[25, i*NumLengthBin+adj+21L] = Age15Size500to520count
      WAE_length_bin[26, i*NumLengthBin+adj+21L] = Age16Size500to520count
      WAE_length_bin[27, i*NumLengthBin+adj+21L] = Age17Size500to520count
      WAE_length_bin[28, i*NumLengthBin+adj+21L] = Age18Size500to520count
      WAE_length_bin[29, i*NumLengthBin+adj+21L] = Age19Size500to520count
      WAE_length_bin[30, i*NumLengthBin+adj+21L] = Age20Size500to520count
      WAE_length_bin[31, i*NumLengthBin+adj+21L] = Age21Size500to520count
      WAE_length_bin[32, i*NumLengthBin+adj+21L] = Age22Size500to520count
      WAE_length_bin[33, i*NumLengthBin+adj+21L] = Age23Size500to520count
      WAE_length_bin[34, i*NumLengthBin+adj+21L] = Age24Size500to520count
      WAE_length_bin[35, i*NumLengthBin+adj+21L] = Age25Size500to520count
      WAE_length_bin[36, i*NumLengthBin+adj+21L] = Age26Size500to520count
    ENDIF
    PRINT, ' Size500to520', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+21L])


    WAE_length_bin[0, i*NumLengthBin+adj+22L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+22L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+22L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+22L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+22L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+22L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+22L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+22L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+22L] = 520
    WAE_length_bin[9, i*NumLengthBin+adj+22L] =  Size520to540count

    ; length bin 23
    IF Size520to540count GT 0 THEN BEGIN
      age0Size520to540 = WHERE((Age_Gro[Size520to540] EQ 0), Age0Size520to540count)
      age1Size520to540 = WHERE((Age_Gro[Size520to540] EQ 1), Age1Size520to540count)
      age2Size520to540 = WHERE((Age_Gro[Size520to540] EQ 2), AGE2Size520to540count)
      age3Size520to540 = WHERE((Age_Gro[Size520to540] EQ 3), AGE3Size520to540count)
      age4Size520to540 = WHERE((Age_Gro[Size520to540] EQ 4), AGE4Size520to540count)
      age5Size520to540 = WHERE((Age_Gro[Size520to540] EQ 5), AGE5Size520to540count)
      age6Size520to540 = WHERE((Age_Gro[Size520to540] EQ 6), AGE6Size520to540count)
      age7Size520to540 = WHERE((Age_Gro[Size520to540] EQ 7), AGE7Size520to540count)
      age8Size520to540 = WHERE((Age_Gro[Size520to540] EQ 8), AGE8Size520to540count)
      age9Size520to540 = WHERE((Age_Gro[Size520to540] EQ 9), AGE9Size520to540count)
      age10Size520to540 = WHERE((Age_Gro[Size520to540] EQ 10), AGE10Size520to540count)
      age11Size520to540 = WHERE((Age_Gro[Size520to540] EQ 11), AGE11Size520to540count)
      AGE12Size520to540 = WHERE((Age_Gro[Size520to540] EQ 12), AGE12Size520to540count)
      AGE13Size520to540 = WHERE((Age_Gro[Size520to540] EQ 13), AGE13Size520to540count)
      AGE14Size520to540 = WHERE((Age_Gro[Size520to540] EQ 14), AGE14Size520to540count)
      AGE15Size520to540 = WHERE((Age_Gro[Size520to540] EQ 15), AGE15Size520to540count)
      age16Size520to540 = WHERE((Age_Gro[Size520to540] EQ 16), Age16Size520to540count)
      age17Size520to540 = WHERE((Age_Gro[Size520to540] EQ 17), AGE17Size520to540count)
      age18Size520to540 = WHERE((Age_Gro[Size520to540] EQ 18), AGE18Size520to540count)
      age19Size520to540 = WHERE((Age_Gro[Size520to540] EQ 19), AGE19Size520to540count)
      age20Size520to540 = WHERE((Age_Gro[Size520to540] EQ 20), AGE20Size520to540count)
      age21Size520to540 = WHERE((Age_Gro[Size520to540] EQ 21), AGE21Size520to540count)
      age22Size520to540 = WHERE((Age_Gro[Size520to540] EQ 22), AGE22Size520to540count)
      age23Size520to540 = WHERE((Age_Gro[Size520to540] EQ 23), AGE23Size520to540count)
      age24Size520to540 = WHERE((Age_Gro[Size520to540] EQ 24), AGE24Size520to540count)
      age25Size520to540 = WHERE((Age_Gro[Size520to540] EQ 25), AGE25Size520to540count)
      age26Size520to540 = WHERE((Age_Gro[Size520to540] EQ 26), AGE26Size520to540count)

      WAE_length_bin[10, i*NumLengthBin+adj+22L] = Age0Size520to540count
      WAE_length_bin[11, i*NumLengthBin+adj+22L] = Age1Size520to540count
      WAE_length_bin[12, i*NumLengthBin+adj+22L] = Age2Size520to540count
      WAE_length_bin[13, i*NumLengthBin+adj+22L] = Age3Size520to540count
      WAE_length_bin[14, i*NumLengthBin+adj+22L] = Age4Size520to540count
      WAE_length_bin[15, i*NumLengthBin+adj+22L] = Age5Size520to540count
      WAE_length_bin[16, i*NumLengthBin+adj+22L] = Age6Size520to540count
      WAE_length_bin[17, i*NumLengthBin+adj+22L] = Age7Size520to540count
      WAE_length_bin[18, i*NumLengthBin+adj+22L] = Age8Size520to540count
      WAE_length_bin[19, i*NumLengthBin+adj+22L] = Age9Size520to540count
      WAE_length_bin[20, i*NumLengthBin+adj+22L] = Age10Size520to540count
      WAE_length_bin[21, i*NumLengthBin+adj+22L] = Age11Size520to540count
      WAE_length_bin[22, i*NumLengthBin+adj+22L] = Age12Size520to540count
      WAE_length_bin[23, i*NumLengthBin+adj+22L] = Age13Size520to540count
      WAE_length_bin[24, i*NumLengthBin+adj+22L] = Age14Size520to540count
      WAE_length_bin[25, i*NumLengthBin+adj+22L] = Age15Size520to540count
      WAE_length_bin[26, i*NumLengthBin+adj+22L] = Age16Size520to540count
      WAE_length_bin[27, i*NumLengthBin+adj+22L] = Age17Size520to540count
      WAE_length_bin[28, i*NumLengthBin+adj+22L] = Age18Size520to540count
      WAE_length_bin[29, i*NumLengthBin+adj+22L] = Age19Size520to540count
      WAE_length_bin[30, i*NumLengthBin+adj+22L] = Age20Size520to540count
      WAE_length_bin[31, i*NumLengthBin+adj+22L] = Age21Size520to540count
      WAE_length_bin[32, i*NumLengthBin+adj+22L] = Age22Size520to540count
      WAE_length_bin[33, i*NumLengthBin+adj+22L] = Age23Size520to540count
      WAE_length_bin[34, i*NumLengthBin+adj+22L] = Age24Size520to540count
      WAE_length_bin[35, i*NumLengthBin+adj+22L] = Age25Size520to540count
      WAE_length_bin[36, i*NumLengthBin+adj+22L] = Age26Size520to540count
    ENDIF
    PRINT, ' Size520to540', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+22L])


    WAE_length_bin[0, i*NumLengthBin+adj+23L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+23L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+23L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+23L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+23L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+23L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+23L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+23L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+23L] = 540
    WAE_length_bin[9, i*NumLengthBin+adj+23L] =  Size540to560count

    ; length bin 24
    IF Size540to560count GT 0 THEN BEGIN
      age0Size540to560 = WHERE((Age_Gro[Size540to560] EQ 0), Age0Size540to560count)
      age1Size540to560 = WHERE((Age_Gro[Size540to560] EQ 1), Age1Size540to560count)
      age2Size540to560 = WHERE((Age_Gro[Size540to560] EQ 2), AGE2Size540to560count)
      age3Size540to560 = WHERE((Age_Gro[Size540to560] EQ 3), AGE3Size540to560count)
      age4Size540to560 = WHERE((Age_Gro[Size540to560] EQ 4), AGE4Size540to560count)
      age5Size540to560 = WHERE((Age_Gro[Size540to560] EQ 5), AGE5Size540to560count)
      age6Size540to560 = WHERE((Age_Gro[Size540to560] EQ 6), AGE6Size540to560count)
      age7Size540to560 = WHERE((Age_Gro[Size540to560] EQ 7), AGE7Size540to560count)
      age8Size540to560 = WHERE((Age_Gro[Size540to560] EQ 8), AGE8Size540to560count)
      age9Size540to560 = WHERE((Age_Gro[Size540to560] EQ 9), AGE9Size540to560count)
      age10Size540to560 = WHERE((Age_Gro[Size540to560] EQ 10), AGE10Size540to560count)
      age11Size540to560 = WHERE((Age_Gro[Size540to560] EQ 11), AGE11Size540to560count)
      AGE12Size540to560 = WHERE((Age_Gro[Size540to560] EQ 12), AGE12Size540to560count)
      AGE13Size540to560 = WHERE((Age_Gro[Size540to560] EQ 13), AGE13Size540to560count)
      AGE14Size540to560 = WHERE((Age_Gro[Size540to560] EQ 14), AGE14Size540to560count)
      AGE15Size540to560 = WHERE((Age_Gro[Size540to560] EQ 15), AGE15Size540to560count)
      age16Size540to560 = WHERE((Age_Gro[Size540to560] EQ 16), Age16Size540to560count)
      age17Size540to560 = WHERE((Age_Gro[Size540to560] EQ 17), AGE17Size540to560count)
      age18Size540to560 = WHERE((Age_Gro[Size540to560] EQ 18), AGE18Size540to560count)
      age19Size540to560 = WHERE((Age_Gro[Size540to560] EQ 19), AGE19Size540to560count)
      age20Size540to560 = WHERE((Age_Gro[Size540to560] EQ 20), AGE20Size540to560count)
      age21Size540to560 = WHERE((Age_Gro[Size540to560] EQ 21), AGE21Size540to560count)
      age22Size540to560 = WHERE((Age_Gro[Size540to560] EQ 22), AGE22Size540to560count)
      age23Size540to560 = WHERE((Age_Gro[Size540to560] EQ 23), AGE23Size540to560count)
      age24Size540to560 = WHERE((Age_Gro[Size540to560] EQ 24), AGE24Size540to560count)
      age25Size540to560 = WHERE((Age_Gro[Size540to560] EQ 25), AGE25Size540to560count)
      age26Size540to560 = WHERE((Age_Gro[Size540to560] EQ 26), AGE26Size540to560count)

      WAE_length_bin[10, i*NumLengthBin+adj+23L] = Age0Size540to560count
      WAE_length_bin[11, i*NumLengthBin+adj+23L] = Age1Size540to560count
      WAE_length_bin[12, i*NumLengthBin+adj+23L] = Age2Size540to560count
      WAE_length_bin[13, i*NumLengthBin+adj+23L] = Age3Size540to560count
      WAE_length_bin[14, i*NumLengthBin+adj+23L] = Age4Size540to560count
      WAE_length_bin[15, i*NumLengthBin+adj+23L] = Age5Size540to560count
      WAE_length_bin[16, i*NumLengthBin+adj+23L] = Age6Size540to560count
      WAE_length_bin[17, i*NumLengthBin+adj+23L] = Age7Size540to560count
      WAE_length_bin[18, i*NumLengthBin+adj+23L] = Age8Size540to560count
      WAE_length_bin[19, i*NumLengthBin+adj+23L] = Age9Size540to560count
      WAE_length_bin[20, i*NumLengthBin+adj+23L] = Age10Size540to560count
      WAE_length_bin[21, i*NumLengthBin+adj+23L] = Age11Size540to560count
      WAE_length_bin[22, i*NumLengthBin+adj+23L] = Age12Size540to560count
      WAE_length_bin[23, i*NumLengthBin+adj+23L] = Age13Size540to560count
      WAE_length_bin[24, i*NumLengthBin+adj+23L] = Age14Size540to560count
      WAE_length_bin[25, i*NumLengthBin+adj+23L] = Age15Size540to560count
      WAE_length_bin[26, i*NumLengthBin+adj+23L] = Age16Size540to560count
      WAE_length_bin[27, i*NumLengthBin+adj+23L] = Age17Size540to560count
      WAE_length_bin[28, i*NumLengthBin+adj+23L] = Age18Size540to560count
      WAE_length_bin[29, i*NumLengthBin+adj+23L] = Age19Size540to560count
      WAE_length_bin[30, i*NumLengthBin+adj+23L] = Age20Size540to560count
      WAE_length_bin[31, i*NumLengthBin+adj+23L] = Age21Size540to560count
      WAE_length_bin[32, i*NumLengthBin+adj+23L] = Age22Size540to560count
      WAE_length_bin[33, i*NumLengthBin+adj+23L] = Age23Size540to560count
      WAE_length_bin[34, i*NumLengthBin+adj+23L] = Age24Size540to560count
      WAE_length_bin[35, i*NumLengthBin+adj+23L] = Age25Size540to560count
      WAE_length_bin[36, i*NumLengthBin+adj+23L] = Age26Size540to560count
    ENDIF
    PRINT, ' Size540to560', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+23L])

    WAE_length_bin[0, i*NumLengthBin+adj+24L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+24L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+24L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+24L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+24L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+24L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+24L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+24L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+24L] = 560
    WAE_length_bin[9, i*NumLengthBin+adj+24L] =  Size560to580count

    ; length bin 25
    IF Size560to580count GT 0 THEN BEGIN
      age0Size560to580 = WHERE((Age_Gro[Size560to580] EQ 0), Age0Size560to580count)
      age1Size560to580 = WHERE((Age_Gro[Size560to580] EQ 1), Age1Size560to580count)
      age2Size560to580 = WHERE((Age_Gro[Size560to580] EQ 2), AGE2Size560to580count)
      age3Size560to580 = WHERE((Age_Gro[Size560to580] EQ 3), AGE3Size560to580count)
      age4Size560to580 = WHERE((Age_Gro[Size560to580] EQ 4), AGE4Size560to580count)
      age5Size560to580 = WHERE((Age_Gro[Size560to580] EQ 5), AGE5Size560to580count)
      age6Size560to580 = WHERE((Age_Gro[Size560to580] EQ 6), AGE6Size560to580count)
      age7Size560to580 = WHERE((Age_Gro[Size560to580] EQ 7), AGE7Size560to580count)
      age8Size560to580 = WHERE((Age_Gro[Size560to580] EQ 8), AGE8Size560to580count)
      age9Size560to580 = WHERE((Age_Gro[Size560to580] EQ 9), AGE9Size560to580count)
      age10Size560to580 = WHERE((Age_Gro[Size560to580] EQ 10), AGE10Size560to580count)
      age11Size560to580 = WHERE((Age_Gro[Size560to580] EQ 11), AGE11Size560to580count)
      AGE12Size560to580 = WHERE((Age_Gro[Size560to580] EQ 12), AGE12Size560to580count)
      AGE13Size560to580 = WHERE((Age_Gro[Size560to580] EQ 13), AGE13Size560to580count)
      AGE14Size560to580 = WHERE((Age_Gro[Size560to580] EQ 14), AGE14Size560to580count)
      AGE15Size560to580 = WHERE((Age_Gro[Size560to580] EQ 15), AGE15Size560to580count)
      age16Size560to580 = WHERE((Age_Gro[Size560to580] EQ 16), Age16Size560to580count)
      age17Size560to580 = WHERE((Age_Gro[Size560to580] EQ 17), AGE17Size560to580count)
      age18Size560to580 = WHERE((Age_Gro[Size560to580] EQ 18), AGE18Size560to580count)
      age19Size560to580 = WHERE((Age_Gro[Size560to580] EQ 19), AGE19Size560to580count)
      age20Size560to580 = WHERE((Age_Gro[Size560to580] EQ 20), AGE20Size560to580count)
      age21Size560to580 = WHERE((Age_Gro[Size560to580] EQ 21), AGE21Size560to580count)
      age22Size560to580 = WHERE((Age_Gro[Size560to580] EQ 22), AGE22Size560to580count)
      age23Size560to580 = WHERE((Age_Gro[Size560to580] EQ 23), AGE23Size560to580count)
      age24Size560to580 = WHERE((Age_Gro[Size560to580] EQ 24), AGE24Size560to580count)
      age25Size560to580 = WHERE((Age_Gro[Size560to580] EQ 25), AGE25Size560to580count)
      age26Size560to580 = WHERE((Age_Gro[Size560to580] EQ 26), AGE26Size560to580count)

      WAE_length_bin[10, i*NumLengthBin+adj+24L] = Age0Size560to580count
      WAE_length_bin[11, i*NumLengthBin+adj+24L] = Age1Size560to580count
      WAE_length_bin[12, i*NumLengthBin+adj+24L] = Age2Size560to580count
      WAE_length_bin[13, i*NumLengthBin+adj+24L] = Age3Size560to580count
      WAE_length_bin[14, i*NumLengthBin+adj+24L] = Age4Size560to580count
      WAE_length_bin[15, i*NumLengthBin+adj+24L] = Age5Size560to580count
      WAE_length_bin[16, i*NumLengthBin+adj+24L] = Age6Size560to580count
      WAE_length_bin[17, i*NumLengthBin+adj+24L] = Age7Size560to580count
      WAE_length_bin[18, i*NumLengthBin+adj+24L] = Age8Size560to580count
      WAE_length_bin[19, i*NumLengthBin+adj+24L] = Age9Size560to580count
      WAE_length_bin[20, i*NumLengthBin+adj+24L] = Age10Size560to580count
      WAE_length_bin[21, i*NumLengthBin+adj+24L] = Age11Size560to580count
      WAE_length_bin[22, i*NumLengthBin+adj+24L] = Age12Size560to580count
      WAE_length_bin[23, i*NumLengthBin+adj+24L] = Age13Size560to580count
      WAE_length_bin[24, i*NumLengthBin+adj+24L] = Age14Size560to580count
      WAE_length_bin[25, i*NumLengthBin+adj+24L] = Age15Size560to580count
      WAE_length_bin[26, i*NumLengthBin+adj+24L] = Age16Size560to580count
      WAE_length_bin[27, i*NumLengthBin+adj+24L] = Age17Size560to580count
      WAE_length_bin[28, i*NumLengthBin+adj+24L] = Age18Size560to580count
      WAE_length_bin[29, i*NumLengthBin+adj+24L] = Age19Size560to580count
      WAE_length_bin[30, i*NumLengthBin+adj+24L] = Age20Size560to580count
      WAE_length_bin[31, i*NumLengthBin+adj+24L] = Age21Size560to580count
      WAE_length_bin[32, i*NumLengthBin+adj+24L] = Age22Size560to580count
      WAE_length_bin[33, i*NumLengthBin+adj+24L] = Age23Size560to580count
      WAE_length_bin[34, i*NumLengthBin+adj+24L] = Age24Size560to580count
      WAE_length_bin[35, i*NumLengthBin+adj+24L] = Age25Size560to580count
      WAE_length_bin[36, i*NumLengthBin+adj+24L] = Age26Size560to580count
    ENDIF
    PRINT, ' Size560to580', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+24L])


    WAE_length_bin[0, i*NumLengthBin+adj+25L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+25L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+25L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+25L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+25L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+25L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+25L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+25L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+25L] = 580
    WAE_length_bin[9, i*NumLengthBin+adj+25L] =  Size580to600count

    ; length bin 26
    IF Size580to600count GT 0 THEN BEGIN
      age0Size580to600 = WHERE((Age_Gro[Size580to600] EQ 0), Age0Size580to600count)
      age1Size580to600 = WHERE((Age_Gro[Size580to600] EQ 1), Age1Size580to600count)
      age2Size580to600 = WHERE((Age_Gro[Size580to600] EQ 2), AGE2Size580to600count)
      age3Size580to600 = WHERE((Age_Gro[Size580to600] EQ 3), AGE3Size580to600count)
      age4Size580to600 = WHERE((Age_Gro[Size580to600] EQ 4), AGE4Size580to600count)
      age5Size580to600 = WHERE((Age_Gro[Size580to600] EQ 5), AGE5Size580to600count)
      age6Size580to600 = WHERE((Age_Gro[Size580to600] EQ 6), AGE6Size580to600count)
      age7Size580to600 = WHERE((Age_Gro[Size580to600] EQ 7), AGE7Size580to600count)
      age8Size580to600 = WHERE((Age_Gro[Size580to600] EQ 8), AGE8Size580to600count)
      age9Size580to600 = WHERE((Age_Gro[Size580to600] EQ 9), AGE9Size580to600count)
      age10Size580to600 = WHERE((Age_Gro[Size580to600] EQ 10), AGE10Size580to600count)
      age11Size580to600 = WHERE((Age_Gro[Size580to600] EQ 11), AGE11Size580to600count)
      AGE12Size580to600 = WHERE((Age_Gro[Size580to600] EQ 12), AGE12Size580to600count)
      AGE13Size580to600 = WHERE((Age_Gro[Size580to600] EQ 13), AGE13Size580to600count)
      AGE14Size580to600 = WHERE((Age_Gro[Size580to600] EQ 14), AGE14Size580to600count)
      AGE15Size580to600 = WHERE((Age_Gro[Size580to600] EQ 15), AGE15Size580to600count)
      age16Size580to600 = WHERE((Age_Gro[Size580to600] EQ 16), Age16Size580to600count)
      age17Size580to600 = WHERE((Age_Gro[Size580to600] EQ 17), AGE17Size580to600count)
      age18Size580to600 = WHERE((Age_Gro[Size580to600] EQ 18), AGE18Size580to600count)
      age19Size580to600 = WHERE((Age_Gro[Size580to600] EQ 19), AGE19Size580to600count)
      age20Size580to600 = WHERE((Age_Gro[Size580to600] EQ 20), AGE20Size580to600count)
      age21Size580to600 = WHERE((Age_Gro[Size580to600] EQ 21), AGE21Size580to600count)
      age22Size580to600 = WHERE((Age_Gro[Size580to600] EQ 22), AGE22Size580to600count)
      age23Size580to600 = WHERE((Age_Gro[Size580to600] EQ 23), AGE23Size580to600count)
      age24Size580to600 = WHERE((Age_Gro[Size580to600] EQ 24), AGE24Size580to600count)
      age25Size580to600 = WHERE((Age_Gro[Size580to600] EQ 25), AGE25Size580to600count)
      age26Size580to600 = WHERE((Age_Gro[Size580to600] EQ 26), AGE26Size580to600count)

      WAE_length_bin[10, i*NumLengthBin+adj+25L] = Age0Size580to600count
      WAE_length_bin[11, i*NumLengthBin+adj+25L] = Age1Size580to600count
      WAE_length_bin[12, i*NumLengthBin+adj+25L] = Age2Size580to600count
      WAE_length_bin[13, i*NumLengthBin+adj+25L] = Age3Size580to600count
      WAE_length_bin[14, i*NumLengthBin+adj+25L] = Age4Size580to600count
      WAE_length_bin[15, i*NumLengthBin+adj+25L] = Age5Size580to600count
      WAE_length_bin[16, i*NumLengthBin+adj+25L] = Age6Size580to600count
      WAE_length_bin[17, i*NumLengthBin+adj+25L] = Age7Size580to600count
      WAE_length_bin[18, i*NumLengthBin+adj+25L] = Age8Size580to600count
      WAE_length_bin[19, i*NumLengthBin+adj+25L] = Age9Size580to600count
      WAE_length_bin[20, i*NumLengthBin+adj+25L] = Age10Size580to600count
      WAE_length_bin[21, i*NumLengthBin+adj+25L] = Age11Size580to600count
      WAE_length_bin[22, i*NumLengthBin+adj+25L] = Age12Size580to600count
      WAE_length_bin[23, i*NumLengthBin+adj+25L] = Age13Size580to600count
      WAE_length_bin[24, i*NumLengthBin+adj+25L] = Age14Size580to600count
      WAE_length_bin[25, i*NumLengthBin+adj+25L] = Age15Size580to600count
      WAE_length_bin[26, i*NumLengthBin+adj+25L] = Age16Size580to600count
      WAE_length_bin[27, i*NumLengthBin+adj+25L] = Age17Size580to600count
      WAE_length_bin[28, i*NumLengthBin+adj+25L] = Age18Size580to600count
      WAE_length_bin[29, i*NumLengthBin+adj+25L] = Age19Size580to600count
      WAE_length_bin[30, i*NumLengthBin+adj+25L] = Age20Size580to600count
      WAE_length_bin[31, i*NumLengthBin+adj+25L] = Age21Size580to600count
      WAE_length_bin[32, i*NumLengthBin+adj+25L] = Age22Size580to600count
      WAE_length_bin[33, i*NumLengthBin+adj+25L] = Age23Size580to600count
      WAE_length_bin[34, i*NumLengthBin+adj+25L] = Age24Size580to600count
      WAE_length_bin[35, i*NumLengthBin+adj+25L] = Age25Size580to600count
      WAE_length_bin[36, i*NumLengthBin+adj+25L] = Age26Size580to600count
    ENDIF
    PRINT, ' Size580to600', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+25L])


    WAE_length_bin[0, i*NumLengthBin+adj+26L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+26L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+26L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+26L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+26L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+26L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+26L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+26L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+26L] = 600
    WAE_length_bin[9, i*NumLengthBin+adj+26L] =  Size600to620count

    ; length bin 27
    IF Size600to620count GT 0 THEN BEGIN
      age0Size600to620 = WHERE((Age_Gro[Size600to620] EQ 0), Age0Size600to620count)
      age1Size600to620 = WHERE((Age_Gro[Size600to620] EQ 1), Age1Size600to620count)
      age2Size600to620 = WHERE((Age_Gro[Size600to620] EQ 2), AGE2Size600to620count)
      age3Size600to620 = WHERE((Age_Gro[Size600to620] EQ 3), AGE3Size600to620count)
      age4Size600to620 = WHERE((Age_Gro[Size600to620] EQ 4), AGE4Size600to620count)
      age5Size600to620 = WHERE((Age_Gro[Size600to620] EQ 5), AGE5Size600to620count)
      age6Size600to620 = WHERE((Age_Gro[Size600to620] EQ 6), AGE6Size600to620count)
      age7Size600to620 = WHERE((Age_Gro[Size600to620] EQ 7), AGE7Size600to620count)
      age8Size600to620 = WHERE((Age_Gro[Size600to620] EQ 8), AGE8Size600to620count)
      age9Size600to620 = WHERE((Age_Gro[Size600to620] EQ 9), AGE9Size600to620count)
      age10Size600to620 = WHERE((Age_Gro[Size600to620] EQ 10), AGE10Size600to620count)
      age11Size600to620 = WHERE((Age_Gro[Size600to620] EQ 11), AGE11Size600to620count)
      AGE12Size600to620 = WHERE((Age_Gro[Size600to620] EQ 12), AGE12Size600to620count)
      AGE13Size600to620 = WHERE((Age_Gro[Size600to620] EQ 13), AGE13Size600to620count)
      AGE14Size600to620 = WHERE((Age_Gro[Size600to620] EQ 14), AGE14Size600to620count)
      AGE15Size600to620 = WHERE((Age_Gro[Size600to620] EQ 15), AGE15Size600to620count)
      age16Size600to620 = WHERE((Age_Gro[Size600to620] EQ 16), Age16Size600to620count)
      age17Size600to620 = WHERE((Age_Gro[Size600to620] EQ 17), AGE17Size600to620count)
      age18Size600to620 = WHERE((Age_Gro[Size600to620] EQ 18), AGE18Size600to620count)
      age19Size600to620 = WHERE((Age_Gro[Size600to620] EQ 19), AGE19Size600to620count)
      age20Size600to620 = WHERE((Age_Gro[Size600to620] EQ 20), AGE20Size600to620count)
      age21Size600to620 = WHERE((Age_Gro[Size600to620] EQ 21), AGE21Size600to620count)
      age22Size600to620 = WHERE((Age_Gro[Size600to620] EQ 22), AGE22Size600to620count)
      age23Size600to620 = WHERE((Age_Gro[Size600to620] EQ 23), AGE23Size600to620count)
      age24Size600to620 = WHERE((Age_Gro[Size600to620] EQ 24), AGE24Size600to620count)
      age25Size600to620 = WHERE((Age_Gro[Size600to620] EQ 25), AGE25Size600to620count)
      age26Size600to620 = WHERE((Age_Gro[Size600to620] EQ 26), AGE26Size600to620count)

      WAE_length_bin[10, i*NumLengthBin+adj+26L] = Age0Size600to620count
      WAE_length_bin[11, i*NumLengthBin+adj+26L] = Age1Size600to620count
      WAE_length_bin[12, i*NumLengthBin+adj+26L] = Age2Size600to620count
      WAE_length_bin[13, i*NumLengthBin+adj+26L] = Age3Size600to620count
      WAE_length_bin[14, i*NumLengthBin+adj+26L] = Age4Size600to620count
      WAE_length_bin[15, i*NumLengthBin+adj+26L] = Age5Size600to620count
      WAE_length_bin[16, i*NumLengthBin+adj+26L] = Age6Size600to620count
      WAE_length_bin[17, i*NumLengthBin+adj+26L] = Age7Size600to620count
      WAE_length_bin[18, i*NumLengthBin+adj+26L] = Age8Size600to620count
      WAE_length_bin[19, i*NumLengthBin+adj+26L] = Age9Size600to620count
      WAE_length_bin[20, i*NumLengthBin+adj+26L] = Age10Size600to620count
      WAE_length_bin[21, i*NumLengthBin+adj+26L] = Age11Size600to620count
      WAE_length_bin[22, i*NumLengthBin+adj+26L] = Age12Size600to620count
      WAE_length_bin[23, i*NumLengthBin+adj+26L] = Age13Size600to620count
      WAE_length_bin[24, i*NumLengthBin+adj+26L] = Age14Size600to620count
      WAE_length_bin[25, i*NumLengthBin+adj+26L] = Age15Size600to620count
      WAE_length_bin[26, i*NumLengthBin+adj+26L] = Age16Size600to620count
      WAE_length_bin[27, i*NumLengthBin+adj+26L] = Age17Size600to620count
      WAE_length_bin[28, i*NumLengthBin+adj+26L] = Age18Size600to620count
      WAE_length_bin[29, i*NumLengthBin+adj+26L] = Age19Size600to620count
      WAE_length_bin[30, i*NumLengthBin+adj+26L] = Age20Size600to620count
      WAE_length_bin[31, i*NumLengthBin+adj+26L] = Age21Size600to620count
      WAE_length_bin[32, i*NumLengthBin+adj+26L] = Age22Size600to620count
      WAE_length_bin[33, i*NumLengthBin+adj+26L] = Age23Size600to620count
      WAE_length_bin[34, i*NumLengthBin+adj+26L] = Age24Size600to620count
      WAE_length_bin[35, i*NumLengthBin+adj+26L] = Age25Size600to620count
      WAE_length_bin[36, i*NumLengthBin+adj+26L] = Age26Size600to620count
    ENDIF
    PRINT, ' Size600to620', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+26L])


    WAE_length_bin[0, i*NumLengthBin+adj+27L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+27L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+27L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+27L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+27L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+27L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+27L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+27L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+27L] = 620
    WAE_length_bin[9, i*NumLengthBin+adj+27L] =  Size620to640count

    ; length bin 28
    IF Size620to640count GT 0 THEN BEGIN
      age0Size620to640 = WHERE((Age_Gro[Size620to640] EQ 0), Age0Size620to640count)
      age1Size620to640 = WHERE((Age_Gro[Size620to640] EQ 1), Age1Size620to640count)
      age2Size620to640 = WHERE((Age_Gro[Size620to640] EQ 2), AGE2Size620to640count)
      age3Size620to640 = WHERE((Age_Gro[Size620to640] EQ 3), AGE3Size620to640count)
      age4Size620to640 = WHERE((Age_Gro[Size620to640] EQ 4), AGE4Size620to640count)
      age5Size620to640 = WHERE((Age_Gro[Size620to640] EQ 5), AGE5Size620to640count)
      age6Size620to640 = WHERE((Age_Gro[Size620to640] EQ 6), AGE6Size620to640count)
      age7Size620to640 = WHERE((Age_Gro[Size620to640] EQ 7), AGE7Size620to640count)
      age8Size620to640 = WHERE((Age_Gro[Size620to640] EQ 8), AGE8Size620to640count)
      age9Size620to640 = WHERE((Age_Gro[Size620to640] EQ 9), AGE9Size620to640count)
      age10Size620to640 = WHERE((Age_Gro[Size620to640] EQ 10), AGE10Size620to640count)
      age11Size620to640 = WHERE((Age_Gro[Size620to640] EQ 11), AGE11Size620to640count)
      AGE12Size620to640 = WHERE((Age_Gro[Size620to640] EQ 12), AGE12Size620to640count)
      AGE13Size620to640 = WHERE((Age_Gro[Size620to640] EQ 13), AGE13Size620to640count)
      AGE14Size620to640 = WHERE((Age_Gro[Size620to640] EQ 14), AGE14Size620to640count)
      AGE15Size620to640 = WHERE((Age_Gro[Size620to640] EQ 15), AGE15Size620to640count)
      age16Size620to640 = WHERE((Age_Gro[Size620to640] EQ 16), Age16Size620to640count)
      age17Size620to640 = WHERE((Age_Gro[Size620to640] EQ 17), AGE17Size620to640count)
      age18Size620to640 = WHERE((Age_Gro[Size620to640] EQ 18), AGE18Size620to640count)
      age19Size620to640 = WHERE((Age_Gro[Size620to640] EQ 19), AGE19Size620to640count)
      age20Size620to640 = WHERE((Age_Gro[Size620to640] EQ 20), AGE20Size620to640count)
      age21Size620to640 = WHERE((Age_Gro[Size620to640] EQ 21), AGE21Size620to640count)
      age22Size620to640 = WHERE((Age_Gro[Size620to640] EQ 22), AGE22Size620to640count)
      age23Size620to640 = WHERE((Age_Gro[Size620to640] EQ 23), AGE23Size620to640count)
      age24Size620to640 = WHERE((Age_Gro[Size620to640] EQ 24), AGE24Size620to640count)
      age25Size620to640 = WHERE((Age_Gro[Size620to640] EQ 25), AGE25Size620to640count)
      age26Size620to640 = WHERE((Age_Gro[Size620to640] EQ 26), AGE26Size620to640count)

      WAE_length_bin[10, i*NumLengthBin+adj+27L] = Age0Size620to640count
      WAE_length_bin[11, i*NumLengthBin+adj+27L] = Age1Size620to640count
      WAE_length_bin[12, i*NumLengthBin+adj+27L] = Age2Size620to640count
      WAE_length_bin[13, i*NumLengthBin+adj+27L] = Age3Size620to640count
      WAE_length_bin[14, i*NumLengthBin+adj+27L] = Age4Size620to640count
      WAE_length_bin[15, i*NumLengthBin+adj+27L] = Age5Size620to640count
      WAE_length_bin[16, i*NumLengthBin+adj+27L] = Age6Size620to640count
      WAE_length_bin[17, i*NumLengthBin+adj+27L] = Age7Size620to640count
      WAE_length_bin[18, i*NumLengthBin+adj+27L] = Age8Size620to640count
      WAE_length_bin[19, i*NumLengthBin+adj+27L] = Age9Size620to640count
      WAE_length_bin[20, i*NumLengthBin+adj+27L] = Age10Size620to640count
      WAE_length_bin[21, i*NumLengthBin+adj+27L] = Age11Size620to640count
      WAE_length_bin[22, i*NumLengthBin+adj+27L] = Age12Size620to640count
      WAE_length_bin[23, i*NumLengthBin+adj+27L] = Age13Size620to640count
      WAE_length_bin[24, i*NumLengthBin+adj+27L] = Age14Size620to640count
      WAE_length_bin[25, i*NumLengthBin+adj+27L] = Age15Size620to640count
      WAE_length_bin[26, i*NumLengthBin+adj+27L] = Age16Size620to640count
      WAE_length_bin[27, i*NumLengthBin+adj+27L] = Age17Size620to640count
      WAE_length_bin[28, i*NumLengthBin+adj+27L] = Age18Size620to640count
      WAE_length_bin[29, i*NumLengthBin+adj+27L] = Age19Size620to640count
      WAE_length_bin[30, i*NumLengthBin+adj+27L] = Age20Size620to640count
      WAE_length_bin[31, i*NumLengthBin+adj+27L] = Age21Size620to640count
      WAE_length_bin[32, i*NumLengthBin+adj+27L] = Age22Size620to640count
      WAE_length_bin[33, i*NumLengthBin+adj+27L] = Age23Size620to640count
      WAE_length_bin[34, i*NumLengthBin+adj+27L] = Age24Size620to640count
      WAE_length_bin[35, i*NumLengthBin+adj+27L] = Age25Size620to640count
      WAE_length_bin[36, i*NumLengthBin+adj+27L] = Age26Size620to640count
    ENDIF
    PRINT, ' Size620to640', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+27L])


    WAE_length_bin[0, i*NumLengthBin+adj+28L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+28L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+28L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+28L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+28L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+28L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+28L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+28L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+28L] = 640
    WAE_length_bin[9, i*NumLengthBin+adj+28L] = Size640to660count

    ; length bin 29
    IF Size640to660count GT 0 THEN BEGIN
      age0Size640to660 = WHERE((Age_Gro[Size640to660] EQ 0), Age0Size640to660count)
      age1Size640to660 = WHERE((Age_Gro[Size640to660] EQ 1), Age1Size640to660count)
      age2Size640to660 = WHERE((Age_Gro[Size640to660] EQ 2), AGE2Size640to660count)
      age3Size640to660 = WHERE((Age_Gro[Size640to660] EQ 3), AGE3Size640to660count)
      age4Size640to660 = WHERE((Age_Gro[Size640to660] EQ 4), AGE4Size640to660count)
      age5Size640to660 = WHERE((Age_Gro[Size640to660] EQ 5), AGE5Size640to660count)
      age6Size640to660 = WHERE((Age_Gro[Size640to660] EQ 6), AGE6Size640to660count)
      age7Size640to660 = WHERE((Age_Gro[Size640to660] EQ 7), AGE7Size640to660count)
      age8Size640to660 = WHERE((Age_Gro[Size640to660] EQ 8), AGE8Size640to660count)
      age9Size640to660 = WHERE((Age_Gro[Size640to660] EQ 9), AGE9Size640to660count)
      age10Size640to660 = WHERE((Age_Gro[Size640to660] EQ 10), AGE10Size640to660count)
      age11Size640to660 = WHERE((Age_Gro[Size640to660] EQ 11), AGE11Size640to660count)
      AGE12Size640to660 = WHERE((Age_Gro[Size640to660] EQ 12), AGE12Size640to660count)
      AGE13Size640to660 = WHERE((Age_Gro[Size640to660] EQ 13), AGE13Size640to660count)
      AGE14Size640to660 = WHERE((Age_Gro[Size640to660] EQ 14), AGE14Size640to660count)
      AGE15Size640to660 = WHERE((Age_Gro[Size640to660] EQ 15), AGE15Size640to660count)
      age16Size640to660 = WHERE((Age_Gro[Size640to660] EQ 16), Age16Size640to660count)
      age17Size640to660 = WHERE((Age_Gro[Size640to660] EQ 17), AGE17Size640to660count)
      age18Size640to660 = WHERE((Age_Gro[Size640to660] EQ 18), AGE18Size640to660count)
      age19Size640to660 = WHERE((Age_Gro[Size640to660] EQ 19), AGE19Size640to660count)
      age20Size640to660 = WHERE((Age_Gro[Size640to660] EQ 20), AGE20Size640to660count)
      age21Size640to660 = WHERE((Age_Gro[Size640to660] EQ 21), AGE21Size640to660count)
      age22Size640to660 = WHERE((Age_Gro[Size640to660] EQ 22), AGE22Size640to660count)
      age23Size640to660 = WHERE((Age_Gro[Size640to660] EQ 23), AGE23Size640to660count)
      age24Size640to660 = WHERE((Age_Gro[Size640to660] EQ 24), AGE24Size640to660count)
      age25Size640to660 = WHERE((Age_Gro[Size640to660] EQ 25), AGE25Size640to660count)
      age26Size640to660 = WHERE((Age_Gro[Size640to660] EQ 26), AGE26Size640to660count)

      WAE_length_bin[10, i*NumLengthBin+adj+28L] = Age0Size640to660count
      WAE_length_bin[11, i*NumLengthBin+adj+28L] = Age1Size640to660count
      WAE_length_bin[12, i*NumLengthBin+adj+28L] = Age2Size640to660count
      WAE_length_bin[13, i*NumLengthBin+adj+28L] = Age3Size640to660count
      WAE_length_bin[14, i*NumLengthBin+adj+28L] = Age4Size640to660count
      WAE_length_bin[15, i*NumLengthBin+adj+28L] = Age5Size640to660count
      WAE_length_bin[16, i*NumLengthBin+adj+28L] = Age6Size640to660count
      WAE_length_bin[17, i*NumLengthBin+adj+28L] = Age7Size640to660count
      WAE_length_bin[18, i*NumLengthBin+adj+28L] = Age8Size640to660count
      WAE_length_bin[19, i*NumLengthBin+adj+28L] = Age9Size640to660count
      WAE_length_bin[20, i*NumLengthBin+adj+28L] = Age10Size640to660count
      WAE_length_bin[21, i*NumLengthBin+adj+28L] = Age11Size640to660count
      WAE_length_bin[22, i*NumLengthBin+adj+28L] = Age12Size640to660count
      WAE_length_bin[23, i*NumLengthBin+adj+28L] = Age13Size640to660count
      WAE_length_bin[24, i*NumLengthBin+adj+28L] = Age14Size640to660count
      WAE_length_bin[25, i*NumLengthBin+adj+28L] = Age15Size640to660count
      WAE_length_bin[26, i*NumLengthBin+adj+28L] = Age16Size640to660count
      WAE_length_bin[27, i*NumLengthBin+adj+28L] = Age17Size640to660count
      WAE_length_bin[28, i*NumLengthBin+adj+28L] = Age18Size640to660count
      WAE_length_bin[29, i*NumLengthBin+adj+28L] = Age19Size640to660count
      WAE_length_bin[30, i*NumLengthBin+adj+28L] = Age20Size640to660count
      WAE_length_bin[31, i*NumLengthBin+adj+28L] = Age21Size640to660count
      WAE_length_bin[32, i*NumLengthBin+adj+28L] = Age22Size640to660count
      WAE_length_bin[33, i*NumLengthBin+adj+28L] = Age23Size640to660count
      WAE_length_bin[34, i*NumLengthBin+adj+28L] = Age24Size640to660count
      WAE_length_bin[35, i*NumLengthBin+adj+28L] = Age25Size640to660count
      WAE_length_bin[36, i*NumLengthBin+adj+28L] = Age26Size640to660count
    ENDIF
    PRINT, ' Size640to660', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+28L])

    WAE_length_bin[0, i*NumLengthBin+adj+29L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+29L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+29L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+29L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+29L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+29L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+29L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+29L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+29L] = 660
    WAE_length_bin[9, i*NumLengthBin+adj+29L] =  Size660to680count

    ; length bin 30
    IF Size660to680count GT 0 THEN BEGIN
      age0Size660to680 = WHERE((Age_Gro[Size660to680] EQ 0), Age0Size660to680count)
      age1Size660to680 = WHERE((Age_Gro[Size660to680] EQ 1), Age1Size660to680count)
      age2Size660to680 = WHERE((Age_Gro[Size660to680] EQ 2), AGE2Size660to680count)
      age3Size660to680 = WHERE((Age_Gro[Size660to680] EQ 3), AGE3Size660to680count)
      age4Size660to680 = WHERE((Age_Gro[Size660to680] EQ 4), AGE4Size660to680count)
      age5Size660to680 = WHERE((Age_Gro[Size660to680] EQ 5), AGE5Size660to680count)
      age6Size660to680 = WHERE((Age_Gro[Size660to680] EQ 6), AGE6Size660to680count)
      age7Size660to680 = WHERE((Age_Gro[Size660to680] EQ 7), AGE7Size660to680count)
      age8Size660to680 = WHERE((Age_Gro[Size660to680] EQ 8), AGE8Size660to680count)
      age9Size660to680 = WHERE((Age_Gro[Size660to680] EQ 9), AGE9Size660to680count)
      age10Size660to680 = WHERE((Age_Gro[Size660to680] EQ 10), AGE10Size660to680count)
      age11Size660to680 = WHERE((Age_Gro[Size660to680] EQ 11), AGE11Size660to680count)
      AGE12Size660to680 = WHERE((Age_Gro[Size660to680] EQ 12), AGE12Size660to680count)
      AGE13Size660to680 = WHERE((Age_Gro[Size660to680] EQ 13), AGE13Size660to680count)
      AGE14Size660to680 = WHERE((Age_Gro[Size660to680] EQ 14), AGE14Size660to680count)
      AGE15Size660to680 = WHERE((Age_Gro[Size660to680] EQ 15), AGE15Size660to680count)
      age16Size660to680 = WHERE((Age_Gro[Size660to680] EQ 16), Age16Size660to680count)
      age17Size660to680 = WHERE((Age_Gro[Size660to680] EQ 17), AGE17Size660to680count)
      age18Size660to680 = WHERE((Age_Gro[Size660to680] EQ 18), AGE18Size660to680count)
      age19Size660to680 = WHERE((Age_Gro[Size660to680] EQ 19), AGE19Size660to680count)
      age20Size660to680 = WHERE((Age_Gro[Size660to680] EQ 20), AGE20Size660to680count)
      age21Size660to680 = WHERE((Age_Gro[Size660to680] EQ 21), AGE21Size660to680count)
      age22Size660to680 = WHERE((Age_Gro[Size660to680] EQ 22), AGE22Size660to680count)
      age23Size660to680 = WHERE((Age_Gro[Size660to680] EQ 23), AGE23Size660to680count)
      age24Size660to680 = WHERE((Age_Gro[Size660to680] EQ 24), AGE24Size660to680count)
      age25Size660to680 = WHERE((Age_Gro[Size660to680] EQ 25), AGE25Size660to680count)
      age26Size660to680 = WHERE((Age_Gro[Size660to680] EQ 26), AGE26Size660to680count)

      WAE_length_bin[10, i*NumLengthBin+adj+29L] = Age0Size660to680count
      WAE_length_bin[11, i*NumLengthBin+adj+29L] = Age1Size660to680count
      WAE_length_bin[12, i*NumLengthBin+adj+29L] = Age2Size660to680count
      WAE_length_bin[13, i*NumLengthBin+adj+29L] = Age3Size660to680count
      WAE_length_bin[14, i*NumLengthBin+adj+29L] = Age4Size660to680count
      WAE_length_bin[15, i*NumLengthBin+adj+29L] = Age5Size660to680count
      WAE_length_bin[16, i*NumLengthBin+adj+29L] = Age6Size660to680count
      WAE_length_bin[17, i*NumLengthBin+adj+29L] = Age7Size660to680count
      WAE_length_bin[18, i*NumLengthBin+adj+29L] = Age8Size660to680count
      WAE_length_bin[19, i*NumLengthBin+adj+29L] = Age9Size660to680count
      WAE_length_bin[20, i*NumLengthBin+adj+29L] = Age10Size660to680count
      WAE_length_bin[21, i*NumLengthBin+adj+29L] = Age11Size660to680count
      WAE_length_bin[22, i*NumLengthBin+adj+29L] = Age12Size660to680count
      WAE_length_bin[23, i*NumLengthBin+adj+29L] = Age13Size660to680count
      WAE_length_bin[24, i*NumLengthBin+adj+29L] = Age14Size660to680count
      WAE_length_bin[25, i*NumLengthBin+adj+29L] = Age15Size660to680count
      WAE_length_bin[26, i*NumLengthBin+adj+29L] = Age16Size660to680count
      WAE_length_bin[27, i*NumLengthBin+adj+29L] = Age17Size660to680count
      WAE_length_bin[28, i*NumLengthBin+adj+29L] = Age18Size660to680count
      WAE_length_bin[29, i*NumLengthBin+adj+29L] = Age19Size660to680count
      WAE_length_bin[30, i*NumLengthBin+adj+29L] = Age20Size660to680count
      WAE_length_bin[31, i*NumLengthBin+adj+29L] = Age21Size660to680count
      WAE_length_bin[32, i*NumLengthBin+adj+29L] = Age22Size660to680count
      WAE_length_bin[33, i*NumLengthBin+adj+29L] = Age23Size660to680count
      WAE_length_bin[34, i*NumLengthBin+adj+29L] = Age24Size660to680count
      WAE_length_bin[35, i*NumLengthBin+adj+29L] = Age25Size660to680count
      WAE_length_bin[36, i*NumLengthBin+adj+29L] = Age26Size660to680count
    ENDIF
    PRINT, ' Size660to680', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+29L])

    WAE_length_bin[0, i*NumLengthBin+adj+30L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+30L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+30L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+30L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+30L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+30L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+30L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+30L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+30L] = 680
    WAE_length_bin[9, i*NumLengthBin+adj+30L] =  Size680to700count

    ; length bin 31
    IF Size680to700count GT 0 THEN BEGIN
      age0Size680to700 = WHERE((Age_Gro[Size680to700] EQ 0), Age0Size680to700count)
      age1Size680to700 = WHERE((Age_Gro[Size680to700] EQ 1), Age1Size680to700count)
      age2Size680to700 = WHERE((Age_Gro[Size680to700] EQ 2), AGE2Size680to700count)
      age3Size680to700 = WHERE((Age_Gro[Size680to700] EQ 3), AGE3Size680to700count)
      age4Size680to700 = WHERE((Age_Gro[Size680to700] EQ 4), AGE4Size680to700count)
      age5Size680to700 = WHERE((Age_Gro[Size680to700] EQ 5), AGE5Size680to700count)
      age6Size680to700 = WHERE((Age_Gro[Size680to700] EQ 6), AGE6Size680to700count)
      age7Size680to700 = WHERE((Age_Gro[Size680to700] EQ 7), AGE7Size680to700count)
      age8Size680to700 = WHERE((Age_Gro[Size680to700] EQ 8), AGE8Size680to700count)
      age9Size680to700 = WHERE((Age_Gro[Size680to700] EQ 9), AGE9Size680to700count)
      age10Size680to700 = WHERE((Age_Gro[Size680to700] EQ 10), AGE10Size680to700count)
      age11Size680to700 = WHERE((Age_Gro[Size680to700] EQ 11), AGE11Size680to700count)
      AGE12Size680to700 = WHERE((Age_Gro[Size680to700] EQ 12), AGE12Size680to700count)
      AGE13Size680to700 = WHERE((Age_Gro[Size680to700] EQ 13), AGE13Size680to700count)
      AGE14Size680to700 = WHERE((Age_Gro[Size680to700] EQ 14), AGE14Size680to700count)
      AGE15Size680to700 = WHERE((Age_Gro[Size680to700] EQ 15), AGE15Size680to700count)
      age16Size680to700 = WHERE((Age_Gro[Size680to700] EQ 16), Age16Size680to700count)
      age17Size680to700 = WHERE((Age_Gro[Size680to700] EQ 17), AGE17Size680to700count)
      age18Size680to700 = WHERE((Age_Gro[Size680to700] EQ 18), AGE18Size680to700count)
      age19Size680to700 = WHERE((Age_Gro[Size680to700] EQ 19), AGE19Size680to700count)
      age20Size680to700 = WHERE((Age_Gro[Size680to700] EQ 20), AGE20Size680to700count)
      age21Size680to700 = WHERE((Age_Gro[Size680to700] EQ 21), AGE21Size680to700count)
      age22Size680to700 = WHERE((Age_Gro[Size680to700] EQ 22), AGE22Size680to700count)
      age23Size680to700 = WHERE((Age_Gro[Size680to700] EQ 23), AGE23Size680to700count)
      age24Size680to700 = WHERE((Age_Gro[Size680to700] EQ 24), AGE24Size680to700count)
      age25Size680to700 = WHERE((Age_Gro[Size680to700] EQ 25), AGE25Size680to700count)
      age26Size680to700 = WHERE((Age_Gro[Size680to700] EQ 26), AGE26Size680to700count)

      WAE_length_bin[10, i*NumLengthBin+adj+30L] = Age0Size680to700count
      WAE_length_bin[11, i*NumLengthBin+adj+30L] = Age1Size680to700count
      WAE_length_bin[12, i*NumLengthBin+adj+30L] = Age2Size680to700count
      WAE_length_bin[13, i*NumLengthBin+adj+30L] = Age3Size680to700count
      WAE_length_bin[14, i*NumLengthBin+adj+30L] = Age4Size680to700count
      WAE_length_bin[15, i*NumLengthBin+adj+30L] = Age5Size680to700count
      WAE_length_bin[16, i*NumLengthBin+adj+30L] = Age6Size680to700count
      WAE_length_bin[17, i*NumLengthBin+adj+30L] = Age7Size680to700count
      WAE_length_bin[18, i*NumLengthBin+adj+30L] = Age8Size680to700count
      WAE_length_bin[19, i*NumLengthBin+adj+30L] = Age9Size680to700count
      WAE_length_bin[20, i*NumLengthBin+adj+30L] = Age10Size680to700count
      WAE_length_bin[21, i*NumLengthBin+adj+30L] = Age11Size680to700count
      WAE_length_bin[22, i*NumLengthBin+adj+30L] = Age12Size680to700count
      WAE_length_bin[23, i*NumLengthBin+adj+30L] = Age13Size680to700count
      WAE_length_bin[24, i*NumLengthBin+adj+30L] = Age14Size680to700count
      WAE_length_bin[25, i*NumLengthBin+adj+30L] = Age15Size680to700count
      WAE_length_bin[26, i*NumLengthBin+adj+30L] = Age16Size680to700count
      WAE_length_bin[27, i*NumLengthBin+adj+30L] = Age17Size680to700count
      WAE_length_bin[28, i*NumLengthBin+adj+30L] = Age18Size680to700count
      WAE_length_bin[29, i*NumLengthBin+adj+30L] = Age19Size680to700count
      WAE_length_bin[30, i*NumLengthBin+adj+30L] = Age20Size680to700count
      WAE_length_bin[31, i*NumLengthBin+adj+30L] = Age21Size680to700count
      WAE_length_bin[32, i*NumLengthBin+adj+30L] = Age22Size680to700count
      WAE_length_bin[33, i*NumLengthBin+adj+30L] = Age23Size680to700count
      WAE_length_bin[34, i*NumLengthBin+adj+30L] = Age24Size680to700count
      WAE_length_bin[35, i*NumLengthBin+adj+30L] = Age25Size680to700count
      WAE_length_bin[36, i*NumLengthBin+adj+30L] = Age26Size680to700count
    ENDIF
    PRINT, 'Size680to700', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+30L])

    WAE_length_bin[0, i*NumLengthBin+adj+31L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+31L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+31L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+31L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+31L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+31L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+31L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+31L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+31L] = 700
    WAE_length_bin[9, i*NumLengthBin+adj+31L] =  Size700to720count

    ; length bin 32
    IF Size700to720count GT 0 THEN BEGIN
      age0Size700to720c = WHERE((Age_Gro[Size700to720] EQ 0), Age0Size700to720count)
      age1Size700to720c = WHERE((Age_Gro[Size700to720] EQ 1), Age1Size700to720count)
      age2Size700to720c = WHERE((Age_Gro[Size700to720] EQ 2), AGE2Size700to720count)
      age3Size700to720c = WHERE((Age_Gro[Size700to720] EQ 3), AGE3Size700to720count)
      age4Size700to720c = WHERE((Age_Gro[Size700to720] EQ 4), AGE4Size700to720count)
      age5Size700to720c = WHERE((Age_Gro[Size700to720] EQ 5), AGE5Size700to720count)
      age6Size700to720c = WHERE((Age_Gro[Size700to720] EQ 6), AGE6Size700to720count)
      age7Size700to720c = WHERE((Age_Gro[Size700to720] EQ 7), AGE7Size700to720count)
      age8Size700to720c = WHERE((Age_Gro[Size700to720] EQ 8), AGE8Size700to720count)
      age9Size700to720c = WHERE((Age_Gro[Size700to720] EQ 9), AGE9Size700to720count)
      age10Size700to720c = WHERE((Age_Gro[Size700to720] EQ 10), AGE10Size700to720count)
      age11Size700to720c = WHERE((Age_Gro[Size700to720] EQ 11), AGE11Size700to720count)
      AGE12Size700to720c = WHERE((Age_Gro[Size700to720] EQ 12), AGE12Size700to720count)
      AGE13Size700to720c = WHERE((Age_Gro[Size700to720] EQ 13), AGE13Size700to720count)
      AGE14Size700to720c = WHERE((Age_Gro[Size700to720] EQ 14), AGE14Size700to720count)
      AGE15Size700to720c = WHERE((Age_Gro[Size700to720] EQ 15), AGE15Size700to720count)
      age16Size700to720c = WHERE((Age_Gro[Size700to720] EQ 16), Age16Size700to720count)
      age17Size700to720c = WHERE((Age_Gro[Size700to720] EQ 17), AGE17Size700to720count)
      age18Size700to720c = WHERE((Age_Gro[Size700to720] EQ 18), AGE18Size700to720count)
      age19Size700to720c = WHERE((Age_Gro[Size700to720] EQ 19), AGE19Size700to720count)
      age20Size700to720c = WHERE((Age_Gro[Size700to720] EQ 20), AGE20Size700to720count)
      age21Size700to720c = WHERE((Age_Gro[Size700to720] EQ 21), AGE21Size700to720count)
      age22Size700to720c = WHERE((Age_Gro[Size700to720] EQ 22), AGE22Size700to720count)
      age23Size700to720c = WHERE((Age_Gro[Size700to720] EQ 23), AGE23Size700to720count)
      age24Size700to720c = WHERE((Age_Gro[Size700to720] EQ 24), AGE24Size700to720count)
      age25Size700to720c = WHERE((Age_Gro[Size700to720] EQ 25), AGE25Size700to720count)
      age26Size700to720c = WHERE((Age_Gro[Size700to720] EQ 26), AGE26Size700to720count)

      WAE_length_bin[10, i*NumLengthBin+adj+31L] = Age0Size700to720count
      WAE_length_bin[11, i*NumLengthBin+adj+31L] = Age1Size700to720count
      WAE_length_bin[12, i*NumLengthBin+adj+31L] = Age2Size700to720count
      WAE_length_bin[13, i*NumLengthBin+adj+31L] = Age3Size700to720count
      WAE_length_bin[14, i*NumLengthBin+adj+31L] = Age4Size700to720count
      WAE_length_bin[15, i*NumLengthBin+adj+31L] = Age5Size700to720count
      WAE_length_bin[16, i*NumLengthBin+adj+31L] = Age6Size700to720count
      WAE_length_bin[17, i*NumLengthBin+adj+31L] = Age7Size700to720count
      WAE_length_bin[18, i*NumLengthBin+adj+31L] = Age8Size700to720count
      WAE_length_bin[19, i*NumLengthBin+adj+31L] = Age9Size700to720count
      WAE_length_bin[20, i*NumLengthBin+adj+31L] = Age10Size700to720count
      WAE_length_bin[21, i*NumLengthBin+adj+31L] = Age11Size700to720count
      WAE_length_bin[22, i*NumLengthBin+adj+31L] = Age12Size700to720count
      WAE_length_bin[23, i*NumLengthBin+adj+31L] = Age13Size700to720count
      WAE_length_bin[24, i*NumLengthBin+adj+31L] = Age14Size700to720count
      WAE_length_bin[25, i*NumLengthBin+adj+31L] = Age15Size700to720count
      WAE_length_bin[26, i*NumLengthBin+adj+31L] = Age16Size700to720count
      WAE_length_bin[27, i*NumLengthBin+adj+31L] = Age17Size700to720count
      WAE_length_bin[28, i*NumLengthBin+adj+31L] = Age18Size700to720count
      WAE_length_bin[29, i*NumLengthBin+adj+31L] = Age19Size700to720count
      WAE_length_bin[30, i*NumLengthBin+adj+31L] = Age20Size700to720count
      WAE_length_bin[31, i*NumLengthBin+adj+31L] = Age21Size700to720count
      WAE_length_bin[32, i*NumLengthBin+adj+31L] = Age22Size700to720count
      WAE_length_bin[33, i*NumLengthBin+adj+31L] = Age23Size700to720count
      WAE_length_bin[34, i*NumLengthBin+adj+31L] = Age24Size700to720count
      WAE_length_bin[35, i*NumLengthBin+adj+31L] = Age25Size700to720count
      WAE_length_bin[36, i*NumLengthBin+adj+31L] = Age26Size700to720count
    ENDIF
    PRINT, ' Size700to720', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+31L])

    WAE_length_bin[0, i*NumLengthBin+adj+32L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+32L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+32L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+32L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+32L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+32L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+32L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+32L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+32L] = 720
    WAE_length_bin[9, i*NumLengthBin+adj+32L] =  Size720to740count

    ; length bin 33
    IF Size720to740count GT 0 THEN BEGIN
      age0Size720to740 = WHERE((Age_Gro[Size720to740] EQ 0), Age0Size720to740count)
      age1Size720to740 = WHERE((Age_Gro[Size720to740] EQ 1), Age1Size720to740count)
      age2Size720to740 = WHERE((Age_Gro[Size720to740] EQ 2), AGE2Size720to740count)
      age3Size720to740 = WHERE((Age_Gro[Size720to740] EQ 3), AGE3Size720to740count)
      age4Size720to740 = WHERE((Age_Gro[Size720to740] EQ 4), AGE4Size720to740count)
      age5Size720to740 = WHERE((Age_Gro[Size720to740] EQ 5), AGE5Size720to740count)
      age6Size720to740 = WHERE((Age_Gro[Size720to740] EQ 6), AGE6Size720to740count)
      age7Size720to740 = WHERE((Age_Gro[Size720to740] EQ 7), AGE7Size720to740count)
      age8Size720to740 = WHERE((Age_Gro[Size720to740] EQ 8), AGE8Size720to740count)
      age9Size720to740 = WHERE((Age_Gro[Size720to740] EQ 9), AGE9Size720to740count)
      age10Size720to740 = WHERE((Age_Gro[Size720to740] EQ 10), AGE10Size720to740count)
      age11Size720to740 = WHERE((Age_Gro[Size720to740] EQ 11), AGE11Size720to740count)
      AGE12Size720to740 = WHERE((Age_Gro[Size720to740] EQ 12), AGE12Size720to740count)
      AGE13Size720to740 = WHERE((Age_Gro[Size720to740] EQ 13), AGE13Size720to740count)
      AGE14Size720to740 = WHERE((Age_Gro[Size720to740] EQ 14), AGE14Size720to740count)
      AGE15Size720to740 = WHERE((Age_Gro[Size720to740] EQ 15), AGE15Size720to740count)
      age16Size720to740 = WHERE((Age_Gro[Size720to740] EQ 16), Age16Size720to740count)
      age17Size720to740 = WHERE((Age_Gro[Size720to740] EQ 17), AGE17Size720to740count)
      age18Size720to740 = WHERE((Age_Gro[Size720to740] EQ 18), AGE18Size720to740count)
      age19Size720to740 = WHERE((Age_Gro[Size720to740] EQ 19), AGE19Size720to740count)
      age20Size720to740 = WHERE((Age_Gro[Size720to740] EQ 20), AGE20Size720to740count)
      age21Size720to740 = WHERE((Age_Gro[Size720to740] EQ 21), AGE21Size720to740count)
      age22Size720to740 = WHERE((Age_Gro[Size720to740] EQ 22), AGE22Size720to740count)
      age23Size720to740 = WHERE((Age_Gro[Size720to740] EQ 23), AGE23Size720to740count)
      age24Size720to740 = WHERE((Age_Gro[Size720to740] EQ 24), AGE24Size720to740count)
      age25Size720to740 = WHERE((Age_Gro[Size720to740] EQ 25), AGE25Size720to740count)
      age26Size720to740 = WHERE((Age_Gro[Size720to740] EQ 26), AGE26Size720to740count)

      WAE_length_bin[10, i*NumLengthBin+adj+32L] = Age0Size720to740count
      WAE_length_bin[11, i*NumLengthBin+adj+32L] = Age1Size720to740count
      WAE_length_bin[12, i*NumLengthBin+adj+32L] = Age2Size720to740count
      WAE_length_bin[13, i*NumLengthBin+adj+32L] = Age3Size720to740count
      WAE_length_bin[14, i*NumLengthBin+adj+32L] = Age4Size720to740count
      WAE_length_bin[15, i*NumLengthBin+adj+32L] = Age5Size720to740count
      WAE_length_bin[16, i*NumLengthBin+adj+32L] = Age6Size720to740count
      WAE_length_bin[17, i*NumLengthBin+adj+32L] = Age7Size720to740count
      WAE_length_bin[18, i*NumLengthBin+adj+32L] = Age8Size720to740count
      WAE_length_bin[19, i*NumLengthBin+adj+32L] = Age9Size720to740count
      WAE_length_bin[20, i*NumLengthBin+adj+32L] = Age10Size720to740count
      WAE_length_bin[21, i*NumLengthBin+adj+32L] = Age11Size720to740count
      WAE_length_bin[22, i*NumLengthBin+adj+32L] = Age12Size720to740count
      WAE_length_bin[23, i*NumLengthBin+adj+32L] = Age13Size720to740count
      WAE_length_bin[24, i*NumLengthBin+adj+32L] = Age14Size720to740count
      WAE_length_bin[25, i*NumLengthBin+adj+32L] = Age15Size720to740count
      WAE_length_bin[26, i*NumLengthBin+adj+32L] = Age16Size720to740count
      WAE_length_bin[27, i*NumLengthBin+adj+32L] = Age17Size720to740count
      WAE_length_bin[28, i*NumLengthBin+adj+32L] = Age18Size720to740count
      WAE_length_bin[29, i*NumLengthBin+adj+32L] = Age19Size720to740count
      WAE_length_bin[30, i*NumLengthBin+adj+32L] = Age20Size720to740count
      WAE_length_bin[31, i*NumLengthBin+adj+32L] = Age21Size720to740count
      WAE_length_bin[32, i*NumLengthBin+adj+32L] = Age22Size720to740count
      WAE_length_bin[33, i*NumLengthBin+adj+32L] = Age23Size720to740count
      WAE_length_bin[34, i*NumLengthBin+adj+32L] = Age24Size720to740count
      WAE_length_bin[35, i*NumLengthBin+adj+32L] = Age25Size720to740count
      WAE_length_bin[36, i*NumLengthBin+adj+32L] = Age26Size720to740count
    ENDIF
    PRINT, 'Size720to740', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+32L])


    WAE_length_bin[0, i*NumLengthBin+adj+33L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+33L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+33L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+33L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+33L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+33L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+33L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+33L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+33L] = 740
    WAE_length_bin[9, i*NumLengthBin+adj+33L] =  Size740to760count

    ; length bin 34
    IF Size740to760count GT 0 THEN BEGIN
      age0Size740to760 = WHERE((Age_Gro[Size740to760] EQ 0), Age0Size740to760count)
      age1Size740to760 = WHERE((Age_Gro[Size740to760] EQ 1), Age1Size740to760count)
      age2Size740to760 = WHERE((Age_Gro[Size740to760] EQ 2), AGE2Size740to760count)
      age3Size740to760 = WHERE((Age_Gro[Size740to760] EQ 3), AGE3Size740to760count)
      age4Size740to760 = WHERE((Age_Gro[Size740to760] EQ 4), AGE4Size740to760count)
      age5Size740to760 = WHERE((Age_Gro[Size740to760] EQ 5), AGE5Size740to760count)
      age6Size740to760 = WHERE((Age_Gro[Size740to760] EQ 6), AGE6Size740to760count)
      age7Size740to760 = WHERE((Age_Gro[Size740to760] EQ 7), AGE7Size740to760count)
      age8Size740to760 = WHERE((Age_Gro[Size740to760] EQ 8), AGE8Size740to760count)
      age9Size740to760 = WHERE((Age_Gro[Size740to760] EQ 9), AGE9Size740to760count)
      age10Size740to760 = WHERE((Age_Gro[Size740to760] EQ 10), AGE10Size740to760count)
      age11Size740to760 = WHERE((Age_Gro[Size740to760] EQ 11), AGE11Size740to760count)
      AGE12Size740to760 = WHERE((Age_Gro[Size740to760] EQ 12), AGE12Size740to760count)
      AGE13Size740to760 = WHERE((Age_Gro[Size740to760] EQ 13), AGE13Size740to760count)
      AGE14Size740to760 = WHERE((Age_Gro[Size740to760] EQ 14), AGE14Size740to760count)
      AGE15Size740to760 = WHERE((Age_Gro[Size740to760] EQ 15), AGE15Size740to760count)
      age16Size740to760 = WHERE((Age_Gro[Size740to760] EQ 16), Age16Size740to760count)
      age17Size740to760 = WHERE((Age_Gro[Size740to760] EQ 17), AGE17Size740to760count)
      age18Size740to760 = WHERE((Age_Gro[Size740to760] EQ 18), AGE18Size740to760count)
      age19Size740to760 = WHERE((Age_Gro[Size740to760] EQ 19), AGE19Size740to760count)
      age20Size740to760 = WHERE((Age_Gro[Size740to760] EQ 20), AGE20Size740to760count)
      age21Size740to760 = WHERE((Age_Gro[Size740to760] EQ 21), AGE21Size740to760count)
      age22Size740to760 = WHERE((Age_Gro[Size740to760] EQ 22), AGE22Size740to760count)
      age23Size740to760 = WHERE((Age_Gro[Size740to760] EQ 23), AGE23Size740to760count)
      age24Size740to760 = WHERE((Age_Gro[Size740to760] EQ 24), AGE24Size740to760count)
      age25Size740to760 = WHERE((Age_Gro[Size740to760] EQ 25), AGE25Size740to760count)
      age26Size740to760 = WHERE((Age_Gro[Size740to760] EQ 26), AGE26Size740to760count)

      WAE_length_bin[10, i*NumLengthBin+adj+33L] = Age0Size740to760count
      WAE_length_bin[11, i*NumLengthBin+adj+33L] = Age1Size740to760count
      WAE_length_bin[12, i*NumLengthBin+adj+33L] = Age2Size740to760count
      WAE_length_bin[13, i*NumLengthBin+adj+33L] = Age3Size740to760count
      WAE_length_bin[14, i*NumLengthBin+adj+33L] = Age4Size740to760count
      WAE_length_bin[15, i*NumLengthBin+adj+33L] = Age5Size740to760count
      WAE_length_bin[16, i*NumLengthBin+adj+33L] = Age6Size740to760count
      WAE_length_bin[17, i*NumLengthBin+adj+33L] = Age7Size740to760count
      WAE_length_bin[18, i*NumLengthBin+adj+33L] = Age8Size740to760count
      WAE_length_bin[19, i*NumLengthBin+adj+33L] = Age9Size740to760count
      WAE_length_bin[20, i*NumLengthBin+adj+33L] = Age10Size740to760count
      WAE_length_bin[21, i*NumLengthBin+adj+33L] = Age11Size740to760count
      WAE_length_bin[22, i*NumLengthBin+adj+33L] = Age12Size740to760count
      WAE_length_bin[23, i*NumLengthBin+adj+33L] = Age13Size740to760count
      WAE_length_bin[24, i*NumLengthBin+adj+33L] = Age14Size740to760count
      WAE_length_bin[25, i*NumLengthBin+adj+33L] = Age15Size740to760count
      WAE_length_bin[26, i*NumLengthBin+adj+33L] = Age16Size740to760count
      WAE_length_bin[27, i*NumLengthBin+adj+33L] = Age17Size740to760count
      WAE_length_bin[28, i*NumLengthBin+adj+33L] = Age18Size740to760count
      WAE_length_bin[29, i*NumLengthBin+adj+33L] = Age19Size740to760count
      WAE_length_bin[30, i*NumLengthBin+adj+33L] = Age20Size740to760count
      WAE_length_bin[31, i*NumLengthBin+adj+33L] = Age21Size740to760count
      WAE_length_bin[32, i*NumLengthBin+adj+33L] = Age22Size740to760count
      WAE_length_bin[33, i*NumLengthBin+adj+33L] = Age23Size740to760count
      WAE_length_bin[34, i*NumLengthBin+adj+33L] = Age24Size740to760count
      WAE_length_bin[35, i*NumLengthBin+adj+33L] = Age25Size740to760count
      WAE_length_bin[36, i*NumLengthBin+adj+33L] = Age26Size740to760count
    ENDIF
    PRINT, 'Size740to760', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+33L])


    WAE_length_bin[0, i*NumLengthBin+adj+34L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+34L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+34L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+34L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+34L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+34L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+34L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+34L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+34L] = 760
    WAE_length_bin[9, i*NumLengthBin+adj+34L] =  Size760to780count

    ; legnth bin 35
    IF Size760to780count GT 0 THEN BEGIN
      age0Size760to780 = WHERE((Age_Gro[Size760to780] EQ 0), Age0Size760to780count)
      age1Size760to780 = WHERE((Age_Gro[Size760to780] EQ 1), Age1Size760to780count)
      age2Size760to780 = WHERE((Age_Gro[Size760to780] EQ 2), AGE2Size760to780count)
      age3Size760to780 = WHERE((Age_Gro[Size760to780] EQ 3), AGE3Size760to780count)
      age4Size760to780 = WHERE((Age_Gro[Size760to780] EQ 4), AGE4Size760to780count)
      age5Size760to780 = WHERE((Age_Gro[Size760to780] EQ 5), AGE5Size760to780count)
      age6Size760to780 = WHERE((Age_Gro[Size760to780] EQ 6), AGE6Size760to780count)
      age7Size760to780 = WHERE((Age_Gro[Size760to780] EQ 7), AGE7Size760to780count)
      age8Size760to780 = WHERE((Age_Gro[Size760to780] EQ 8), AGE8Size760to780count)
      age9Size760to780 = WHERE((Age_Gro[Size760to780] EQ 9), AGE9Size760to780count)
      age10Size760to780 = WHERE((Age_Gro[Size760to780] EQ 10), AGE10Size760to780count)
      age11Size760to780 = WHERE((Age_Gro[Size760to780] EQ 11), AGE11Size760to780count)
      AGE12Size760to780 = WHERE((Age_Gro[Size760to780] EQ 12), AGE12Size760to780count)
      AGE13Size760to780 = WHERE((Age_Gro[Size760to780] EQ 13), AGE13Size760to780count)
      AGE14Size760to780 = WHERE((Age_Gro[Size760to780] EQ 14), AGE14Size760to780count)
      AGE15Size760to780 = WHERE((Age_Gro[Size760to780] EQ 15), AGE15Size760to780count)
      age16Size760to780 = WHERE((Age_Gro[Size760to780] EQ 16), Age16Size760to780count)
      age17Size760to780 = WHERE((Age_Gro[Size760to780] EQ 17), AGE17Size760to780count)
      age18Size760to780 = WHERE((Age_Gro[Size760to780] EQ 18), AGE18Size760to780count)
      age19Size760to780 = WHERE((Age_Gro[Size760to780] EQ 19), AGE19Size760to780count)
      age20Size760to780 = WHERE((Age_Gro[Size760to780] EQ 20), AGE20Size760to780count)
      age21Size760to780 = WHERE((Age_Gro[Size760to780] EQ 21), AGE21Size760to780count)
      age22Size760to780 = WHERE((Age_Gro[Size760to780] EQ 22), AGE22Size760to780count)
      age23Size760to780 = WHERE((Age_Gro[Size760to780] EQ 23), AGE23Size760to780count)
      age24Size760to780 = WHERE((Age_Gro[Size760to780] EQ 24), AGE24Size760to780count)
      age25Size760to780 = WHERE((Age_Gro[Size760to780] EQ 25), AGE25Size760to780count)
      age26Size760to780 = WHERE((Age_Gro[Size760to780] EQ 26), AGE26Size760to780count)

      WAE_length_bin[10, i*NumLengthBin+adj+34L] = Age0Size760to780count
      WAE_length_bin[11, i*NumLengthBin+adj+34L] = Age1Size760to780count
      WAE_length_bin[12, i*NumLengthBin+adj+34L] = Age2Size760to780count
      WAE_length_bin[13, i*NumLengthBin+adj+34L] = Age3Size760to780count
      WAE_length_bin[14, i*NumLengthBin+adj+34L] = Age4Size760to780count
      WAE_length_bin[15, i*NumLengthBin+adj+34L] = Age5Size760to780count
      WAE_length_bin[16, i*NumLengthBin+adj+34L] = Age6Size760to780count
      WAE_length_bin[17, i*NumLengthBin+adj+34L] = Age7Size760to780count
      WAE_length_bin[18, i*NumLengthBin+adj+34L] = Age8Size760to780count
      WAE_length_bin[19, i*NumLengthBin+adj+34L] = Age9Size760to780count
      WAE_length_bin[20, i*NumLengthBin+adj+34L] = Age10Size760to780count
      WAE_length_bin[21, i*NumLengthBin+adj+34L] = Age11Size760to780count
      WAE_length_bin[22, i*NumLengthBin+adj+34L] = Age12Size760to780count
      WAE_length_bin[23, i*NumLengthBin+adj+34L] = Age13Size760to780count
      WAE_length_bin[24, i*NumLengthBin+adj+34L] = Age14Size760to780count
      WAE_length_bin[25, i*NumLengthBin+adj+34L] = Age15Size760to780count
      WAE_length_bin[26, i*NumLengthBin+adj+34L] = Age16Size760to780count
      WAE_length_bin[27, i*NumLengthBin+adj+34L] = Age17Size760to780count
      WAE_length_bin[28, i*NumLengthBin+adj+34L] = Age18Size760to780count
      WAE_length_bin[29, i*NumLengthBin+adj+34L] = Age19Size760to780count
      WAE_length_bin[30, i*NumLengthBin+adj+34L] = Age20Size760to780count
      WAE_length_bin[31, i*NumLengthBin+adj+34L] = Age21Size760to780count
      WAE_length_bin[32, i*NumLengthBin+adj+34L] = Age22Size760to780count
      WAE_length_bin[33, i*NumLengthBin+adj+34L] = Age23Size760to780count
      WAE_length_bin[34, i*NumLengthBin+adj+34L] = Age24Size760to780count
      WAE_length_bin[35, i*NumLengthBin+adj+34L] = Age25Size760to780count
      WAE_length_bin[36, i*NumLengthBin+adj+34L] = Age26Size760to780count
    ENDIF
    PRINT, 'Size760to780', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+34L])

    WAE_length_bin[0, i*NumLengthBin+adj+35L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+35L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+35L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+35L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+35L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+35L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+35L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+35L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+35L] = 780
    WAE_length_bin[9, i*NumLengthBin+adj+35L] =  Size780to800count

    ; length bin 36
    IF Size780to800count GT 0 THEN BEGIN
      age0Size780to800 = WHERE((Age_Gro[Size780to800] EQ 0), Age0Size780to800count)
      age1Size780to800 = WHERE((Age_Gro[Size780to800] EQ 1), Age1Size780to800count)
      age2Size780to800 = WHERE((Age_Gro[Size780to800] EQ 2), AGE2Size780to800count)
      age3Size780to800 = WHERE((Age_Gro[Size780to800] EQ 3), AGE3Size780to800count)
      age4Size780to800 = WHERE((Age_Gro[Size780to800] EQ 4), AGE4Size780to800count)
      age5Size780to800 = WHERE((Age_Gro[Size780to800] EQ 5), AGE5Size780to800count)
      age6Size780to800 = WHERE((Age_Gro[Size780to800] EQ 6), AGE6Size780to800count)
      age7Size780to800 = WHERE((Age_Gro[Size780to800] EQ 7), AGE7Size780to800count)
      age8Size780to800 = WHERE((Age_Gro[Size780to800] EQ 8), AGE8Size780to800count)
      age9Size780to800 = WHERE((Age_Gro[Size780to800] EQ 9), AGE9Size780to800count)
      age10Size780to800 = WHERE((Age_Gro[Size780to800] EQ 10), AGE10Size780to800count)
      age11Size780to800 = WHERE((Age_Gro[Size780to800] EQ 11), AGE11Size780to800count)
      AGE12Size780to800 = WHERE((Age_Gro[Size780to800] EQ 12), AGE12Size780to800count)
      AGE13Size780to800 = WHERE((Age_Gro[Size780to800] EQ 13), AGE13Size780to800count)
      AGE14Size780to800 = WHERE((Age_Gro[Size780to800] EQ 14), AGE14Size780to800count)
      AGE15Size780to800 = WHERE((Age_Gro[Size780to800] EQ 15), AGE15Size780to800count)
      age16Size780to800 = WHERE((Age_Gro[Size780to800] EQ 16), Age16Size780to800count)
      age17Size780to800 = WHERE((Age_Gro[Size780to800] EQ 17), AGE17Size780to800count)
      age18Size780to800 = WHERE((Age_Gro[Size780to800] EQ 18), AGE18Size780to800count)
      age19Size780to800 = WHERE((Age_Gro[Size780to800] EQ 19), AGE19Size780to800count)
      age20Size780to800 = WHERE((Age_Gro[Size780to800] EQ 20), AGE20Size780to800count)
      age21Size780to800 = WHERE((Age_Gro[Size780to800] EQ 21), AGE21Size780to800count)
      age22Size780to800 = WHERE((Age_Gro[Size780to800] EQ 22), AGE22Size780to800count)
      age23Size780to800 = WHERE((Age_Gro[Size780to800] EQ 23), AGE23Size780to800count)
      age24Size780to800 = WHERE((Age_Gro[Size780to800] EQ 24), AGE24Size780to800count)
      age25Size780to800 = WHERE((Age_Gro[Size780to800] EQ 25), AGE25Size780to800count)
      age26Size780to800 = WHERE((Age_Gro[Size780to800] EQ 26), AGE26Size780to800count)

      WAE_length_bin[10, i*NumLengthBin+adj+35L] = Age0Size780to800count
      WAE_length_bin[11, i*NumLengthBin+adj+35L] = Age1Size780to800count
      WAE_length_bin[12, i*NumLengthBin+adj+35L] = Age2Size780to800count
      WAE_length_bin[13, i*NumLengthBin+adj+35L] = Age3Size780to800count
      WAE_length_bin[14, i*NumLengthBin+adj+35L] = Age4Size780to800count
      WAE_length_bin[15, i*NumLengthBin+adj+35L] = Age5Size780to800count
      WAE_length_bin[16, i*NumLengthBin+adj+35L] = Age6Size780to800count
      WAE_length_bin[17, i*NumLengthBin+adj+35L] = Age7Size780to800count
      WAE_length_bin[18, i*NumLengthBin+adj+35L] = Age8Size780to800count
      WAE_length_bin[19, i*NumLengthBin+adj+35L] = Age9Size780to800count
      WAE_length_bin[20, i*NumLengthBin+adj+35L] = Age10Size780to800count
      WAE_length_bin[21, i*NumLengthBin+adj+35L] = Age11Size780to800count
      WAE_length_bin[22, i*NumLengthBin+adj+35L] = Age12Size780to800count
      WAE_length_bin[23, i*NumLengthBin+adj+35L] = Age13Size780to800count
      WAE_length_bin[24, i*NumLengthBin+adj+35L] = Age14Size780to800count
      WAE_length_bin[25, i*NumLengthBin+adj+35L] = Age15Size780to800count
      WAE_length_bin[26, i*NumLengthBin+adj+35L] = Age16Size780to800count
      WAE_length_bin[27, i*NumLengthBin+adj+35L] = Age17Size780to800count
      WAE_length_bin[28, i*NumLengthBin+adj+35L] = Age18Size780to800count
      WAE_length_bin[29, i*NumLengthBin+adj+35L] = Age19Size780to800count
      WAE_length_bin[30, i*NumLengthBin+adj+35L] = Age20Size780to800count
      WAE_length_bin[31, i*NumLengthBin+adj+35L] = Age21Size780to800count
      WAE_length_bin[32, i*NumLengthBin+adj+35L] = Age22Size780to800count
      WAE_length_bin[33, i*NumLengthBin+adj+35L] = Age23Size780to800count
      WAE_length_bin[34, i*NumLengthBin+adj+35L] = Age24Size780to800count
      WAE_length_bin[35, i*NumLengthBin+adj+35L] = Age25Size780to800count
      WAE_length_bin[36, i*NumLengthBin+adj+35L] = Age26Size780to800count
    ENDIF
    PRINT, 'Size780to800', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+35L])

    WAE_length_bin[0, i*NumLengthBin+adj+36L] = WBIC[INDEX_growthdata[0]]; WBIC (abbrev)
    WAE_length_bin[1, i*NumLengthBin+adj+36L] = N_ELEMENTS(Length_Gro); N of fish
    WAE_length_bin[2, i*NumLengthBin+adj+36L] = WBIC[INDEX_growthdata[0]]; WBIC
    WAE_length_bin[3, i*NumLengthBin+adj+36L] = SurveyYear[INDEX_growthdata[0]]; year
    WAE_length_bin[4, i*NumLengthBin+adj+36L] = Max(length[INDEX_growthdata])
    WAE_length_bin[5, i*NumLengthBin+adj+36L] = Min(length[INDEX_growthdata])
    WAE_length_bin[6, i*NumLengthBin+adj+36L] = Max(age[INDEX_growthdata])
    WAE_length_bin[7, i*NumLengthBin+adj+36L] = Min(age[INDEX_growthdata])
    WAE_length_bin[8, i*NumLengthBin+adj+36L] = 800
    WAE_length_bin[9, i*NumLengthBin+adj+36L] =  SizeGE800count
    ; length bin 37
    IF SizeGE800count GT 0 THEN BEGIN
      age0SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 0), Age0SizeGE800count)
      age1SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 1), Age1SizeGE800count)
      age2SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 2), AGE2SizeGE800count)
      age3SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 3), AGE3SizeGE800count)
      age4SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 4), AGE4SizeGE800count)
      age5SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 5), AGE5SizeGE800count)
      age6SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 6), AGE6SizeGE800count)
      age7SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 7), AGE7SizeGE800count)
      age8SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 8), AGE8SizeGE800count)
      age9SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 9), AGE9SizeGE800count)
      age10SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 10), AGE10SizeGE800count)
      age11SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 11), AGE11SizeGE800count)
      AGE12SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 12), AGE12SizeGE800count)
      AGE13SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 13), AGE13SizeGE800count)
      AGE14SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 14), AGE14SizeGE800count)
      AGE15SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 15), AGE15SizeGE800count)
      age16SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 16), Age16SizeGE800count)
      age17SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 17), AGE17SizeGE800count)
      age18SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 18), AGE18SizeGE800count)
      age19SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 19), AGE19SizeGE800count)
      age20SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 20), AGE20SizeGE800count)
      age21SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 21), AGE21SizeGE800count)
      age22SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 22), AGE22SizeGE800count)
      age23SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 23), AGE23SizeGE800count)
      age24SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 24), AGE24SizeGE800count)
      age25SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 25), AGE25SizeGE800count)
      age26SizeGE800 = WHERE((Age_Gro[SizeGE800] EQ 26), AGE26SizeGE800count)

      WAE_length_bin[10, i*NumLengthBin+adj+36L] = Age0SizeGE800count
      WAE_length_bin[11, i*NumLengthBin+adj+36L] = Age1SizeGE800count
      WAE_length_bin[12, i*NumLengthBin+adj+36L] = Age2SizeGE800count
      WAE_length_bin[13, i*NumLengthBin+adj+36L] = Age3SizeGE800count
      WAE_length_bin[14, i*NumLengthBin+adj+36L] = Age4SizeGE800count
      WAE_length_bin[15, i*NumLengthBin+adj+36L] = Age5SizeGE800count
      WAE_length_bin[16, i*NumLengthBin+adj+36L] = Age6SizeGE800count
      WAE_length_bin[17, i*NumLengthBin+adj+36L] = Age7SizeGE800count
      WAE_length_bin[18, i*NumLengthBin+adj+36L] = Age8SizeGE800count
      WAE_length_bin[19, i*NumLengthBin+adj+36L] = Age9SizeGE800count
      WAE_length_bin[20, i*NumLengthBin+adj+36L] = Age10SizeGE800count
      WAE_length_bin[21, i*NumLengthBin+adj+36L] = Age11SizeGE800count
      WAE_length_bin[22, i*NumLengthBin+adj+36L] = Age12SizeGE800count
      WAE_length_bin[23, i*NumLengthBin+adj+36L] = Age13SizeGE800count
      WAE_length_bin[24, i*NumLengthBin+adj+36L] = Age14SizeGE800count
      WAE_length_bin[25, i*NumLengthBin+adj+36L] = Age15SizeGE800count
      WAE_length_bin[26, i*NumLengthBin+adj+36L] = Age16SizeGE800count
      WAE_length_bin[27, i*NumLengthBin+adj+36L] = Age17SizeGE800count
      WAE_length_bin[28, i*NumLengthBin+adj+36L] = Age18SizeGE800count
      WAE_length_bin[29, i*NumLengthBin+adj+36L] = Age19SizeGE800count
      WAE_length_bin[30, i*NumLengthBin+adj+36L] = Age20SizeGE800count
      WAE_length_bin[31, i*NumLengthBin+adj+36L] = Age21SizeGE800count
      WAE_length_bin[32, i*NumLengthBin+adj+36L] = Age22SizeGE800count
      WAE_length_bin[33, i*NumLengthBin+adj+36L] = Age23SizeGE800count
      WAE_length_bin[34, i*NumLengthBin+adj+36L] = Age24SizeGE800count
      WAE_length_bin[35, i*NumLengthBin+adj+36L] = Age25SizeGE800count
      WAE_length_bin[36, i*NumLengthBin+adj+36L] = Age26SizeGE800count
    ENDIF
    PRINT, 'SizeGE800', TOTAL(WAE_length_bin[10L:36, i*NumLengthBin+adj+36L])
    PRINT, 'Total N of fish', TOTAL(WAE_length_bin[1L:27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])

      
      ;***MALES***
      ; Length group distributions - all fish - male
      SizeLT100M = WHERE((Sex_Gro EQ 0L) AND Length_Gro LT 100, SizeLT100countM)
      Size100to120M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 100) AND (Length_Gro LT 120), Size100to120countM)
      Size120to140M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 120) AND (Length_Gro LT 140), Size120to140countM)
      Size140to160M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 140) AND (Length_Gro LT 160), Size140to160countM)
      Size160to180M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 160) AND (Length_Gro LT 180), Size160to180countM)
      Size180to200M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 180) AND (Length_Gro LT 200), Size180to200countM)
      Size200to220M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 200) AND (Length_Gro LT 220), Size200to220countM)
      Size220to240M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 220) AND (Length_Gro LT 240), Size220to240countM)
      Size240to260M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 240) AND (Length_Gro LT 260), Size240to260countM)
      Size260to280M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 260) AND (Length_Gro LT 280), Size260to280countM)
      Size280to300M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 280) AND (Length_Gro LT 300), Size280to300countM)
      Size300to320M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 300) AND (Length_Gro LT 320), Size300to320countM)
      Size320to340M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 320) AND (Length_Gro LT 340), Size320to340countM)
      Size340to360M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 340) AND (Length_Gro LT 360), Size340to360countM)
      Size360to380M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 360) AND (Length_Gro LT 380), Size360to380countM)
      Size380to400M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 380) AND (Length_Gro LT 400), Size380to400countM)
      Size400to420M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 400) AND (Length_Gro LT 420), Size400to420countM)
      Size420to440M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 420) AND (Length_Gro LT 440), Size420to440countM)
      Size440to460M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 440) AND (Length_Gro LT 460), Size440to460countM)
      Size460to480M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 460) AND (Length_Gro LT 480), Size460to480countM)
      Size480to500M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 480) AND (Length_Gro LT 500), Size480to500countM)
      Size500to520M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 500) AND (Length_Gro LT 520), Size500to520countM)
      Size520to540M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 520) AND (Length_Gro LT 540), Size520to540countM)
      Size540to560M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 540) AND (Length_Gro LT 560), Size540to560countM)
      Size560to580M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 560) AND (Length_Gro LT 580), Size560to580countM)
      Size580to600M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 580) AND (Length_Gro LT 600), Size580to600countM)
      Size600to620M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 600) AND (Length_Gro LT 620), Size600to620countM)
      Size620to640M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 620) AND (Length_Gro LT 640), Size620to640countM)
      Size640to660M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 640) AND (Length_Gro LT 660), Size640to660countM)
      Size660to680M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 660) AND (Length_Gro LT 680), Size660to680countM)
      Size680to700M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 680) AND (Length_Gro LT 700), Size680to700countM)
      Size700to720M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 700) AND (Length_Gro LT 720), Size700to720countM)
      Size720to740M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 720) AND (Length_Gro LT 740), Size720to740countM)
      Size740to760M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 740) AND (Length_Gro LT 760), Size740to760countM)
      Size760to780M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 760) AND (Length_Gro LT 780), Size760to780countM)
      Size780to800M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 780) AND (Length_Gro LT 800), Size780to800countM)
      SizeGE800M = WHERE((Sex_Gro EQ 0L) AND (Length_Gro GE 800), SizeGE800countM)
      
      IF SizeLT100countM GT 0 THEN paramset[3, i] = SizeLT100countM
      IF Size100to120countM GT 0 THEN paramset[4, i] = Size100to120countM
      IF Size120to140countM GT 0 THEN paramset[5, i] = Size120to140countM
      IF Size140to160countM GT 0 THEN paramset[6, i] = Size140to160countM
      IF Size160to180countM GT 0 THEN paramset[7, i] = Size160to180countM
      IF Size180to200countM GT 0 THEN paramset[8, i] = Size180to200countM
      IF Size200to220countM GT 0 THEN paramset[9, i] = Size200to220countM
      IF Size220to240countM GT 0 THEN paramset[10, i] = Size220to240countM
      IF Size240to260countM GT 0 THEN paramset[11, i] = Size240to260countM
      IF Size260to280countM GT 0 THEN paramset[12, i] = Size260to280countM
      IF Size280to300countM GT 0 THEN paramset[13, i] = Size280to300countM
      IF Size300to320countM GT 0 THEN paramset[14, i] = Size300to320countM
      IF Size320to340countM GT 0 THEN paramset[15, i] = Size320to340countM
      IF Size340to360countM GT 0 THEN paramset[16, i] = Size340to360countM
      IF Size360to380countM GT 0 THEN paramset[17, i] = Size360to380countM
      IF Size380to400countM GT 0 THEN paramset[18, i] = Size380to400countM
      IF Size400to420countM GT 0 THEN paramset[19, i] = Size400to420countM
      IF Size420to440countM GT 0 THEN paramset[20, i] = Size420to440countM
      IF Size440to460countM GT 0 THEN paramset[21, i] = Size440to460countM
      IF Size460to480countM GT 0 THEN paramset[22, i] = Size460to480countM
      IF Size480to500countM GT 0 THEN paramset[23, i] = Size480to500countM
      IF Size500to520countM GT 0 THEN paramset[24, i] = Size500to520countM
      IF Size520to540countM GT 0 THEN paramset[25, i] = Size520to540countM
      IF Size540to560countM GT 0 THEN paramset[26, i] = Size540to560countM
      IF Size560to580countM GT 0 THEN paramset[27, i] = Size560to580countM
      IF Size580to600countM GT 0 THEN paramset[28, i] = Size580to600countM
      IF Size600to620countM GT 0 THEN paramset[29, i] = Size600to620countM
      IF Size620to640countM GT 0 THEN paramset[30, i] = Size620to640countM
      IF Size640to660countM GT 0 THEN paramset[31, i] = Size640to660countM
      IF Size660to680countM GT 0 THEN paramset[32, i] = Size660to680countM
      IF Size680to700countM GT 0 THEN paramset[33, i] = Size680to700countM
      IF Size700to720countM GT 0 THEN paramset[34, i] = Size700to720countM
      IF Size720to740countM GT 0 THEN paramset[35, i] = Size720to740countM
      IF Size740to760countM GT 0 THEN paramset[36, i] = Size740to760countM
      IF Size760to780countM GT 0 THEN paramset[37, i] = Size760to780countM
      IF Size780to800countM GT 0 THEN paramset[38, i] = Size780to800countM
      IF SizeGE800countM GT 0 THEN paramset[39, i] = SizeGE800countM
      
      
      ; length bin 1
      IF SizeLT100count GT 0 THEN BEGIN
        age0SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 0) AND (Sex_Gro[SizeLT100] EQ 0), Age0SizeLT100countM)
        age1SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 1) AND (Sex_Gro[SizeLT100] EQ 0), Age1SizeLT100countM)
        age2SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 2) AND (Sex_Gro[SizeLT100] EQ 0), Age2SizeLT100countM)
        age3SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 3) AND (Sex_Gro[SizeLT100] EQ 0), Age3SizeLT100countM)
        age4SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 4) AND (Sex_Gro[SizeLT100] EQ 0), Age4SizeLT100countM)
        age5SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 5) AND (Sex_Gro[SizeLT100] EQ 0), Age5SizeLT100countM)
        age6SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 6) AND (Sex_Gro[SizeLT100] EQ 0), Age6SizeLT100countM)
        age7SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 7) AND (Sex_Gro[SizeLT100] EQ 0), Age7SizeLT100countM)
        age8SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 8) AND (Sex_Gro[SizeLT100] EQ 0), Age8SizeLT100countM)
        age9SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 9) AND (Sex_Gro[SizeLT100] EQ 0), Age9SizeLT100countM)
        age10SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 10) AND (Sex_Gro[SizeLT100] EQ 0), Age10SizeLT100countM)
        age11SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 11) AND (Sex_Gro[SizeLT100] EQ 0), Age11SizeLT100countM)
        AGE12SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 12) AND (Sex_Gro[SizeLT100] EQ 0), Age12SizeLT100countM)
        AGE13SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 13) AND (Sex_Gro[SizeLT100] EQ 0), Age13SizeLT100countM)
        AGE14SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 14) AND (Sex_Gro[SizeLT100] EQ 0), Age14SizeLT100countM)
        AGE15SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 15) AND (Sex_Gro[SizeLT100] EQ 0), Age15SizeLT100countM)
        age16SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 16) AND (Sex_Gro[SizeLT100] EQ 0), Age16SizeLT100countM)
        age17SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 17) AND (Sex_Gro[SizeLT100] EQ 0), Age17SizeLT100countM)
        age18SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 18) AND (Sex_Gro[SizeLT100] EQ 0), Age18SizeLT100countM)
        age19SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 19) AND (Sex_Gro[SizeLT100] EQ 0), Age19SizeLT100countM)
        age20SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 20) AND (Sex_Gro[SizeLT100] EQ 0), Age20SizeLT100countM)
        age21SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 21) AND (Sex_Gro[SizeLT100] EQ 0), Age21SizeLT100countM)
        age22SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 22) AND (Sex_Gro[SizeLT100] EQ 0), Age22SizeLT100countM)
        age23SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 23) AND (Sex_Gro[SizeLT100] EQ 0), Age23SizeLT100countM)
        age24SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 24) AND (Sex_Gro[SizeLT100] EQ 0), Age24SizeLT100countM)
        age25SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 25) AND (Sex_Gro[SizeLT100] EQ 0), Age25SizeLT100countM)
        age26SizeLT100M = WHERE((Age_Gro[SizeLT100] EQ 26) AND (Sex_Gro[SizeLT100] EQ 0), Age26SizeLT100countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj] = 99
        WAE_length_bin[42, i*NumLengthBin+adj] = SizeLT100countM
      
        WAE_length_bin[43, i*NumLengthBin+adj] = Age0SizeLT100countM
        WAE_length_bin[44, i*NumLengthBin+adj] = Age1SizeLT100countM
        WAE_length_bin[45, i*NumLengthBin+adj] = Age2SizeLT100countM
        WAE_length_bin[46, i*NumLengthBin+adj] = Age3SizeLT100countM
        WAE_length_bin[47, i*NumLengthBin+adj] = Age4SizeLT100countM
        WAE_length_bin[48, i*NumLengthBin+adj] = Age5SizeLT100countM
        WAE_length_bin[49, i*NumLengthBin+adj] = Age6SizeLT100countM
        WAE_length_bin[50, i*NumLengthBin+adj] = Age7SizeLT100countM
        WAE_length_bin[51, i*NumLengthBin+adj] = Age8SizeLT100countM
        WAE_length_bin[52, i*NumLengthBin+adj] = Age9SizeLT100countM
        WAE_length_bin[53, i*NumLengthBin+adj] = Age10SizeLT100countM
        WAE_length_bin[54, i*NumLengthBin+adj] = Age11SizeLT100countM
        WAE_length_bin[55, i*NumLengthBin+adj] = Age12SizeLT100countM
        WAE_length_bin[56, i*NumLengthBin+adj] = Age13SizeLT100countM
        WAE_length_bin[57, i*NumLengthBin+adj] = Age14SizeLT100countM
        WAE_length_bin[58, i*NumLengthBin+adj] = Age15SizeLT100countM
        WAE_length_bin[59, i*NumLengthBin+adj] = Age16SizeLT100countM
        WAE_length_bin[60, i*NumLengthBin+adj] = Age17SizeLT100countM
        WAE_length_bin[61, i*NumLengthBin+adj] = Age18SizeLT100countM
        WAE_length_bin[62, i*NumLengthBin+adj] = Age19SizeLT100countM
        WAE_length_bin[63, i*NumLengthBin+adj] = Age20SizeLT100countM
        WAE_length_bin[64, i*NumLengthBin+adj] = Age21SizeLT100countM
        WAE_length_bin[65, i*NumLengthBin+adj] = Age22SizeLT100countM
        WAE_length_bin[66, i*NumLengthBin+adj] = Age23SizeLT100countM
        WAE_length_bin[67, i*NumLengthBin+adj] = Age24SizeLT100countM
        WAE_length_bin[68, i*NumLengthBin+adj] = Age25SizeLT100countM
        WAE_length_bin[69, i*NumLengthBin+adj] = Age26SizeLT100countM
      ENDIF
      PRINT, 'SizeLT100M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj])
      
      
      ; length bin 2
      IF Size100to120count GT 0 THEN BEGIN
        age0Size100to120M = WHERE((Age_Gro[Size100to120] EQ 0) AND (Sex_Gro[Size100to120] EQ 0), Age0Size100to120countM)
        age1Size100to120M = WHERE((Age_Gro[Size100to120] EQ 1) AND (Sex_Gro[Size100to120] EQ 0), Age1Size100to120countM)
        age2Size100to120M = WHERE((Age_Gro[Size100to120] EQ 2) AND (Sex_Gro[Size100to120] EQ 0), Age2Size100to120countM)
        age3Size100to120M = WHERE((Age_Gro[Size100to120] EQ 3) AND (Sex_Gro[Size100to120] EQ 0), Age3Size100to120countM)
        age4Size100to120M = WHERE((Age_Gro[Size100to120] EQ 4) AND (Sex_Gro[Size100to120] EQ 0), Age4Size100to120countM)
        age5Size100to120M = WHERE((Age_Gro[Size100to120] EQ 5) AND (Sex_Gro[Size100to120] EQ 0), Age5Size100to120countM)
        age6Size100to120M = WHERE((Age_Gro[Size100to120] EQ 6) AND (Sex_Gro[Size100to120] EQ 0), Age6Size100to120countM)
        age7Size100to120M = WHERE((Age_Gro[Size100to120] EQ 7) AND (Sex_Gro[Size100to120] EQ 0), Age7Size100to120countM)
        age8Size100to120M = WHERE((Age_Gro[Size100to120] EQ 8) AND (Sex_Gro[Size100to120] EQ 0), Age8Size100to120countM)
        age9Size100to120M = WHERE((Age_Gro[Size100to120] EQ 9) AND (Sex_Gro[Size100to120] EQ 0), Age9Size100to120countM)
        age10Size100to120M = WHERE((Age_Gro[Size100to120] EQ 10) AND (Sex_Gro[Size100to120] EQ 0), Age10Size100to120countM)
        age11Size100to120M = WHERE((Age_Gro[Size100to120] EQ 11) AND (Sex_Gro[Size100to120] EQ 0), Age11Size100to120countM)
        AGE12Size100to120M = WHERE((Age_Gro[Size100to120] EQ 12) AND (Sex_Gro[Size100to120] EQ 0), Age12Size100to120countM)
        AGE13Size100to120M = WHERE((Age_Gro[Size100to120] EQ 13) AND (Sex_Gro[Size100to120] EQ 0), Age13Size100to120countM)
        AGE14Size100to120M = WHERE((Age_Gro[Size100to120] EQ 14) AND (Sex_Gro[Size100to120] EQ 0), Age14Size100to120countM)
        AGE15Size100to120M = WHERE((Age_Gro[Size100to120] EQ 15) AND (Sex_Gro[Size100to120] EQ 0), Age15Size100to120countM)
        age16Size100to120M = WHERE((Age_Gro[Size100to120] EQ 16) AND (Sex_Gro[Size100to120] EQ 0), Age16Size100to120countM)
        age17Size100to120M = WHERE((Age_Gro[Size100to120] EQ 17) AND (Sex_Gro[Size100to120] EQ 0), Age17Size100to120countM)
        age18Size100to120M = WHERE((Age_Gro[Size100to120] EQ 18) AND (Sex_Gro[Size100to120] EQ 0), Age18Size100to120countM)
        age19Size100to120M = WHERE((Age_Gro[Size100to120] EQ 19) AND (Sex_Gro[Size100to120] EQ 0), Age19Size100to120countM)
        age20Size100to120M = WHERE((Age_Gro[Size100to120] EQ 20) AND (Sex_Gro[Size100to120] EQ 0), Age20Size100to120countM)
        age21Size100to120M = WHERE((Age_Gro[Size100to120] EQ 21) AND (Sex_Gro[Size100to120] EQ 0), Age21Size100to120countM)
        age22Size100to120M = WHERE((Age_Gro[Size100to120] EQ 22) AND (Sex_Gro[Size100to120] EQ 0), Age22Size100to120countM)
        age23Size100to120M = WHERE((Age_Gro[Size100to120] EQ 23) AND (Sex_Gro[Size100to120] EQ 0), Age23Size100to120countM)
        age24Size100to120M = WHERE((Age_Gro[Size100to120] EQ 24) AND (Sex_Gro[Size100to120] EQ 0), Age24Size100to120countM)
        age25Size100to120M = WHERE((Age_Gro[Size100to120] EQ 25) AND (Sex_Gro[Size100to120] EQ 0), Age25Size100to120countM)
        age26Size100to120M = WHERE((Age_Gro[Size100to120] EQ 26) AND (Sex_Gro[Size100to120] EQ 0), Age26Size100to120countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+1L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+1L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+1L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+1L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+1L] = 100
        WAE_length_bin[42, i*NumLengthBin+adj+1L] = Size100to120countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+1L] = Age0Size100to120countM
        WAE_length_bin[44, i*NumLengthBin+adj+1L] = Age1Size100to120countM
        WAE_length_bin[45, i*NumLengthBin+adj+1L] = Age2Size100to120countM
        WAE_length_bin[46, i*NumLengthBin+adj+1L] = Age3Size100to120countM
        WAE_length_bin[47, i*NumLengthBin+adj+1L] = Age4Size100to120countM
        WAE_length_bin[48, i*NumLengthBin+adj+1L] = Age5Size100to120countM
        WAE_length_bin[49, i*NumLengthBin+adj+1L] = Age6Size100to120countM
        WAE_length_bin[50, i*NumLengthBin+adj+1L] = Age7Size100to120countM
        WAE_length_bin[51, i*NumLengthBin+adj+1L] = Age8Size100to120countM
        WAE_length_bin[52, i*NumLengthBin+adj+1L] = Age9Size100to120countM
        WAE_length_bin[53, i*NumLengthBin+adj+1L] = Age10Size100to120countM
        WAE_length_bin[54, i*NumLengthBin+adj+1L] = Age11Size100to120countM
        WAE_length_bin[55, i*NumLengthBin+adj+1L] = Age12Size100to120countM
        WAE_length_bin[56, i*NumLengthBin+adj+1L] = Age13Size100to120countM
        WAE_length_bin[57, i*NumLengthBin+adj+1L] = Age14Size100to120countM
        WAE_length_bin[58, i*NumLengthBin+adj+1L] = Age15Size100to120countM
        WAE_length_bin[59, i*NumLengthBin+adj+1L] = Age16Size100to120countM
        WAE_length_bin[60, i*NumLengthBin+adj+1L] = Age17Size100to120countM
        WAE_length_bin[61, i*NumLengthBin+adj+1L] = Age18Size100to120countM
        WAE_length_bin[62, i*NumLengthBin+adj+1L] = Age19Size100to120countM
        WAE_length_bin[63, i*NumLengthBin+adj+1L] = Age20Size100to120countM
        WAE_length_bin[64, i*NumLengthBin+adj+1L] = Age21Size100to120countM
        WAE_length_bin[65, i*NumLengthBin+adj+1L] = Age22Size100to120countM
        WAE_length_bin[66, i*NumLengthBin+adj+1L] = Age23Size100to120countM
        WAE_length_bin[67, i*NumLengthBin+adj+1L] = Age24Size100to120countM
        WAE_length_bin[68, i*NumLengthBin+adj+1L] = Age25Size100to120countM
        WAE_length_bin[69, i*NumLengthBin+adj+1L] = Age26Size100to120countM
      ENDIF
      PRINT, 'Size100to120M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+1L])
      
      
      ; length bin 3
      IF Size120to140count GT 0 THEN BEGIN
        age0Size120to140M = WHERE((Age_Gro[Size120to140] EQ 0) AND (Sex_Gro[Size120to140] EQ 0), Age0Size120to140countM)
        age1Size120to140M = WHERE((Age_Gro[Size120to140] EQ 1) AND (Sex_Gro[Size120to140] EQ 0), Age1Size120to140countM)
        age2Size120to140M = WHERE((Age_Gro[Size120to140] EQ 2) AND (Sex_Gro[Size120to140] EQ 0), Age2Size120to140countM)
        age3Size120to140M = WHERE((Age_Gro[Size120to140] EQ 3) AND (Sex_Gro[Size120to140] EQ 0), Age3Size120to140countM)
        age4Size120to140M = WHERE((Age_Gro[Size120to140] EQ 4) AND (Sex_Gro[Size120to140] EQ 0), Age4Size120to140countM)
        age5Size120to140M = WHERE((Age_Gro[Size120to140] EQ 5) AND (Sex_Gro[Size120to140] EQ 0), Age5Size120to140countM)
        age6Size120to140M = WHERE((Age_Gro[Size120to140] EQ 6) AND (Sex_Gro[Size120to140] EQ 0), Age6Size120to140countM)
        age7Size120to140M = WHERE((Age_Gro[Size120to140] EQ 7) AND (Sex_Gro[Size120to140] EQ 0), Age7Size120to140countM)
        age8Size120to140M = WHERE((Age_Gro[Size120to140] EQ 8) AND (Sex_Gro[Size120to140] EQ 0), Age8Size120to140countM)
        age9Size120to140M = WHERE((Age_Gro[Size120to140] EQ 9) AND (Sex_Gro[Size120to140] EQ 0), Age9Size120to140countM)
        age10Size120to140M = WHERE((Age_Gro[Size120to140] EQ 10) AND (Sex_Gro[Size120to140] EQ 0), Age10Size120to140countM)
        age11Size120to140M = WHERE((Age_Gro[Size120to140] EQ 11) AND (Sex_Gro[Size120to140] EQ 0), Age11Size120to140countM)
        AGE12Size120to140M = WHERE((Age_Gro[Size120to140] EQ 12) AND (Sex_Gro[Size120to140] EQ 0), Age12Size120to140countM)
        AGE13Size120to140M = WHERE((Age_Gro[Size120to140] EQ 13) AND (Sex_Gro[Size120to140] EQ 0), Age13Size120to140countM)
        AGE14Size120to140M = WHERE((Age_Gro[Size120to140] EQ 14) AND (Sex_Gro[Size120to140] EQ 0), Age14Size120to140countM)
        AGE15Size120to140M = WHERE((Age_Gro[Size120to140] EQ 15) AND (Sex_Gro[Size120to140] EQ 0), Age15Size120to140countM)
        age16Size120to140M = WHERE((Age_Gro[Size120to140] EQ 16) AND (Sex_Gro[Size120to140] EQ 0), Age16Size120to140countM)
        age17Size120to140M = WHERE((Age_Gro[Size120to140] EQ 17) AND (Sex_Gro[Size120to140] EQ 0), Age17Size120to140countM)
        age18Size120to140M = WHERE((Age_Gro[Size120to140] EQ 18) AND (Sex_Gro[Size120to140] EQ 0), Age18Size120to140countM)
        age19Size120to140M = WHERE((Age_Gro[Size120to140] EQ 19) AND (Sex_Gro[Size120to140] EQ 0), Age19Size120to140countM)
        age20Size120to140M = WHERE((Age_Gro[Size120to140] EQ 20) AND (Sex_Gro[Size120to140] EQ 0), Age20Size120to140countM)
        age21Size120to140M = WHERE((Age_Gro[Size120to140] EQ 21) AND (Sex_Gro[Size120to140] EQ 0), Age21Size120to140countM)
        age22Size120to140M = WHERE((Age_Gro[Size120to140] EQ 22) AND (Sex_Gro[Size120to140] EQ 0), Age22Size120to140countM)
        age23Size120to140M = WHERE((Age_Gro[Size120to140] EQ 23) AND (Sex_Gro[Size120to140] EQ 0), Age23Size120to140countM)
        age24Size120to140M = WHERE((Age_Gro[Size120to140] EQ 24) AND (Sex_Gro[Size120to140] EQ 0), Age24Size120to140countM)
        age25Size120to140M = WHERE((Age_Gro[Size120to140] EQ 25) AND (Sex_Gro[Size120to140] EQ 0), Age25Size120to140countM)
        age26Size120to140M = WHERE((Age_Gro[Size120to140] EQ 26) AND (Sex_Gro[Size120to140] EQ 0), Age26Size120to140countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+2L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+2L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+2L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+2L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+2L] = 120
        WAE_length_bin[42, i*NumLengthBin+adj+2L] = Size120to140countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+2L] = Age0Size120to140countM
        WAE_length_bin[44, i*NumLengthBin+adj+2L] = Age1Size120to140countM
        WAE_length_bin[45, i*NumLengthBin+adj+2L] = Age2Size120to140countM
        WAE_length_bin[46, i*NumLengthBin+adj+2L] = Age3Size120to140countM
        WAE_length_bin[47, i*NumLengthBin+adj+2L] = Age4Size120to140countM
        WAE_length_bin[48, i*NumLengthBin+adj+2L] = Age5Size120to140countM
        WAE_length_bin[49, i*NumLengthBin+adj+2L] = Age6Size120to140countM
        WAE_length_bin[50, i*NumLengthBin+adj+2L] = Age7Size120to140countM
        WAE_length_bin[51, i*NumLengthBin+adj+2L] = Age8Size120to140countM
        WAE_length_bin[52, i*NumLengthBin+adj+2L] = Age9Size120to140countM
        WAE_length_bin[53, i*NumLengthBin+adj+2L] = Age10Size120to140countM
        WAE_length_bin[54, i*NumLengthBin+adj+2L] = Age11Size120to140countM
        WAE_length_bin[55, i*NumLengthBin+adj+2L] = Age12Size120to140countM
        WAE_length_bin[56, i*NumLengthBin+adj+2L] = Age13Size120to140countM
        WAE_length_bin[57, i*NumLengthBin+adj+2L] = Age14Size120to140countM
        WAE_length_bin[58, i*NumLengthBin+adj+2L] = Age15Size120to140countM
        WAE_length_bin[59, i*NumLengthBin+adj+2L] = Age16Size120to140countM
        WAE_length_bin[60, i*NumLengthBin+adj+2L] = Age17Size120to140countM
        WAE_length_bin[61, i*NumLengthBin+adj+2L] = Age18Size120to140countM
        WAE_length_bin[62, i*NumLengthBin+adj+2L] = Age19Size120to140countM
        WAE_length_bin[63, i*NumLengthBin+adj+2L] = Age20Size120to140countM
        WAE_length_bin[64, i*NumLengthBin+adj+2L] = Age21Size120to140countM
        WAE_length_bin[65, i*NumLengthBin+adj+2L] = Age22Size120to140countM
        WAE_length_bin[66, i*NumLengthBin+adj+2L] = Age23Size120to140countM
        WAE_length_bin[67, i*NumLengthBin+adj+2L] = Age24Size120to140countM
        WAE_length_bin[68, i*NumLengthBin+adj+2L] = Age25Size120to140countM
        WAE_length_bin[69, i*NumLengthBin+adj+2L] = Age26Size120to140countM
      ENDIF
      PRINT, 'Size120to140M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+2L])
      
      ; length bin 4
      IF Size140to160count GT 0 THEN BEGIN
        age0Size140to160M = WHERE((Age_Gro[Size140to160] EQ 0) AND (Sex_Gro[Size140to160] EQ 0), Age0Size140to160countM)
        age1Size140to160M = WHERE((Age_Gro[Size140to160] EQ 1) AND (Sex_Gro[Size140to160] EQ 0), Age1Size140to160countM)
        age2Size140to160M = WHERE((Age_Gro[Size140to160] EQ 2) AND (Sex_Gro[Size140to160] EQ 0), Age2Size140to160countM)
        age3Size140to160M = WHERE((Age_Gro[Size140to160] EQ 3) AND (Sex_Gro[Size140to160] EQ 0), Age3Size140to160countM)
        age4Size140to160M = WHERE((Age_Gro[Size140to160] EQ 4) AND (Sex_Gro[Size140to160] EQ 0), Age4Size140to160countM)
        age5Size140to160M = WHERE((Age_Gro[Size140to160] EQ 5) AND (Sex_Gro[Size140to160] EQ 0), Age5Size140to160countM)
        age6Size140to160M = WHERE((Age_Gro[Size140to160] EQ 6) AND (Sex_Gro[Size140to160] EQ 0), Age6Size140to160countM)
        age7Size140to160M = WHERE((Age_Gro[Size140to160] EQ 7) AND (Sex_Gro[Size140to160] EQ 0), Age7Size140to160countM)
        age8Size140to160M = WHERE((Age_Gro[Size140to160] EQ 8) AND (Sex_Gro[Size140to160] EQ 0), Age8Size140to160countM)
        age9Size140to160M = WHERE((Age_Gro[Size140to160] EQ 9) AND (Sex_Gro[Size140to160] EQ 0), Age9Size140to160countM)
        age10Size140to160M = WHERE((Age_Gro[Size140to160] EQ 10) AND (Sex_Gro[Size140to160] EQ 0), Age10Size140to160countM)
        age11Size140to160M = WHERE((Age_Gro[Size140to160] EQ 11) AND (Sex_Gro[Size140to160] EQ 0), Age11Size140to160countM)
        AGE12Size140to160M = WHERE((Age_Gro[Size140to160] EQ 12) AND (Sex_Gro[Size140to160] EQ 0), Age12Size140to160countM)
        AGE13Size140to160M = WHERE((Age_Gro[Size140to160] EQ 13) AND (Sex_Gro[Size140to160] EQ 0), Age13Size140to160countM)
        AGE14Size140to160M = WHERE((Age_Gro[Size140to160] EQ 14) AND (Sex_Gro[Size140to160] EQ 0), Age14Size140to160countM)
        AGE15Size140to160M = WHERE((Age_Gro[Size140to160] EQ 15) AND (Sex_Gro[Size140to160] EQ 0), Age15Size140to160countM)
        age16Size140to160M = WHERE((Age_Gro[Size140to160] EQ 16) AND (Sex_Gro[Size140to160] EQ 0), Age16Size140to160countM)
        age17Size140to160M = WHERE((Age_Gro[Size140to160] EQ 17) AND (Sex_Gro[Size140to160] EQ 0), Age17Size140to160countM)
        age18Size140to160M = WHERE((Age_Gro[Size140to160] EQ 18) AND (Sex_Gro[Size140to160] EQ 0), Age18Size140to160countM)
        age19Size140to160M = WHERE((Age_Gro[Size140to160] EQ 19) AND (Sex_Gro[Size140to160] EQ 0), Age19Size140to160countM)
        age20Size140to160M = WHERE((Age_Gro[Size140to160] EQ 20) AND (Sex_Gro[Size140to160] EQ 0), Age20Size140to160countM)
        age21Size140to160M = WHERE((Age_Gro[Size140to160] EQ 21) AND (Sex_Gro[Size140to160] EQ 0), Age21Size140to160countM)
        age22Size140to160M = WHERE((Age_Gro[Size140to160] EQ 22) AND (Sex_Gro[Size140to160] EQ 0), Age22Size140to160countM)
        age23Size140to160M = WHERE((Age_Gro[Size140to160] EQ 23) AND (Sex_Gro[Size140to160] EQ 0), Age23Size140to160countM)
        age24Size140to160M = WHERE((Age_Gro[Size140to160] EQ 24) AND (Sex_Gro[Size140to160] EQ 0), Age24Size140to160countM)
        age25Size140to160M = WHERE((Age_Gro[Size140to160] EQ 25) AND (Sex_Gro[Size140to160] EQ 0), Age25Size140to160countM)
        age26Size140to160M = WHERE((Age_Gro[Size140to160] EQ 26) AND (Sex_Gro[Size140to160] EQ 0), Age26Size140to160countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+3L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+3L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+3L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+3L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+3L] = 140
        WAE_length_bin[42, i*NumLengthBin+adj+3L] = Size140to160countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+3L] = Age0Size140to160countM
        WAE_length_bin[44, i*NumLengthBin+adj+3L] = Age1Size140to160countM
        WAE_length_bin[45, i*NumLengthBin+adj+3L] = Age2Size140to160countM
        WAE_length_bin[46, i*NumLengthBin+adj+3L] = Age3Size140to160countM
        WAE_length_bin[47, i*NumLengthBin+adj+3L] = Age4Size140to160countM
        WAE_length_bin[48, i*NumLengthBin+adj+3L] = Age5Size140to160countM
        WAE_length_bin[49, i*NumLengthBin+adj+3L] = Age6Size140to160countM
        WAE_length_bin[50, i*NumLengthBin+adj+3L] = Age7Size140to160countM
        WAE_length_bin[51, i*NumLengthBin+adj+3L] = Age8Size140to160countM
        WAE_length_bin[52, i*NumLengthBin+adj+3L] = Age9Size140to160countM
        WAE_length_bin[53, i*NumLengthBin+adj+3L] = Age10Size140to160countM
        WAE_length_bin[54, i*NumLengthBin+adj+3L] = Age11Size140to160countM
        WAE_length_bin[55, i*NumLengthBin+adj+3L] = Age12Size140to160countM
        WAE_length_bin[56, i*NumLengthBin+adj+3L] = Age13Size140to160countM
        WAE_length_bin[57, i*NumLengthBin+adj+3L] = Age14Size140to160countM
        WAE_length_bin[58, i*NumLengthBin+adj+3L] = Age15Size140to160countM
        WAE_length_bin[59, i*NumLengthBin+adj+3L] = Age16Size140to160countM
        WAE_length_bin[60, i*NumLengthBin+adj+3L] = Age17Size140to160countM
        WAE_length_bin[61, i*NumLengthBin+adj+3L] = Age18Size140to160countM
        WAE_length_bin[62, i*NumLengthBin+adj+3L] = Age19Size140to160countM
        WAE_length_bin[63, i*NumLengthBin+adj+3L] = Age20Size140to160countM
        WAE_length_bin[64, i*NumLengthBin+adj+3L] = Age21Size140to160countM
        WAE_length_bin[65, i*NumLengthBin+adj+3L] = Age22Size140to160countM
        WAE_length_bin[66, i*NumLengthBin+adj+3L] = Age23Size140to160countM
        WAE_length_bin[67, i*NumLengthBin+adj+3L] = Age24Size140to160countM
        WAE_length_bin[68, i*NumLengthBin+adj+3L] = Age25Size140to160countM
        WAE_length_bin[69, i*NumLengthBin+adj+3L] = Age26Size140to160countM
      ENDIF
      PRINT, 'Size140to160M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+3L])
      
      
      ; length bin 5
      IF Size160to180count GT 0 THEN BEGIN
        age0Size160to180M = WHERE((Age_Gro[Size160to180] EQ 0) AND (Sex_Gro[Size160to180] EQ 0), Age0Size160to180countM)
        age1Size160to180M = WHERE((Age_Gro[Size160to180] EQ 1) AND (Sex_Gro[Size160to180] EQ 0), Age1Size160to180countM)
        age2Size160to180M = WHERE((Age_Gro[Size160to180] EQ 2) AND (Sex_Gro[Size160to180] EQ 0), Age2Size160to180countM)
        age3Size160to180M = WHERE((Age_Gro[Size160to180] EQ 3) AND (Sex_Gro[Size160to180] EQ 0), Age3Size160to180countM)
        age4Size160to180M = WHERE((Age_Gro[Size160to180] EQ 4) AND (Sex_Gro[Size160to180] EQ 0), Age4Size160to180countM)
        age5Size160to180M = WHERE((Age_Gro[Size160to180] EQ 5) AND (Sex_Gro[Size160to180] EQ 0), Age5Size160to180countM)
        age6Size160to180M = WHERE((Age_Gro[Size160to180] EQ 6) AND (Sex_Gro[Size160to180] EQ 0), Age6Size160to180countM)
        age7Size160to180M = WHERE((Age_Gro[Size160to180] EQ 7) AND (Sex_Gro[Size160to180] EQ 0), Age7Size160to180countM)
        age8Size160to180M = WHERE((Age_Gro[Size160to180] EQ 8) AND (Sex_Gro[Size160to180] EQ 0), Age8Size160to180countM)
        age9Size160to180M = WHERE((Age_Gro[Size160to180] EQ 9) AND (Sex_Gro[Size160to180] EQ 0), Age9Size160to180countM)
        age10Size160to180M = WHERE((Age_Gro[Size160to180] EQ 10) AND (Sex_Gro[Size160to180] EQ 0), Age10Size160to180countM)
        age11Size160to180M = WHERE((Age_Gro[Size160to180] EQ 11) AND (Sex_Gro[Size160to180] EQ 0), Age11Size160to180countM)
        AGE12Size160to180M = WHERE((Age_Gro[Size160to180] EQ 12) AND (Sex_Gro[Size160to180] EQ 0), Age12Size160to180countM)
        AGE13Size160to180M = WHERE((Age_Gro[Size160to180] EQ 13) AND (Sex_Gro[Size160to180] EQ 0), Age13Size160to180countM)
        AGE14Size160to180M = WHERE((Age_Gro[Size160to180] EQ 14) AND (Sex_Gro[Size160to180] EQ 0), Age14Size160to180countM)
        AGE15Size160to180M = WHERE((Age_Gro[Size160to180] EQ 15) AND (Sex_Gro[Size160to180] EQ 0), Age15Size160to180countM)
        age16Size160to180M = WHERE((Age_Gro[Size160to180] EQ 16) AND (Sex_Gro[Size160to180] EQ 0), Age16Size160to180countM)
        age17Size160to180M = WHERE((Age_Gro[Size160to180] EQ 17) AND (Sex_Gro[Size160to180] EQ 0), Age17Size160to180countM)
        age18Size160to180M = WHERE((Age_Gro[Size160to180] EQ 18) AND (Sex_Gro[Size160to180] EQ 0), Age18Size160to180countM)
        age19Size160to180M = WHERE((Age_Gro[Size160to180] EQ 19) AND (Sex_Gro[Size160to180] EQ 0), Age19Size160to180countM)
        age20Size160to180M = WHERE((Age_Gro[Size160to180] EQ 20) AND (Sex_Gro[Size160to180] EQ 0), Age20Size160to180countM)
        age21Size160to180M = WHERE((Age_Gro[Size160to180] EQ 21) AND (Sex_Gro[Size160to180] EQ 0), Age21Size160to180countM)
        age22Size160to180M = WHERE((Age_Gro[Size160to180] EQ 22) AND (Sex_Gro[Size160to180] EQ 0), Age22Size160to180countM)
        age23Size160to180M = WHERE((Age_Gro[Size160to180] EQ 23) AND (Sex_Gro[Size160to180] EQ 0), Age23Size160to180countM)
        age24Size160to180M = WHERE((Age_Gro[Size160to180] EQ 24) AND (Sex_Gro[Size160to180] EQ 0), Age24Size160to180countM)
        age25Size160to180M = WHERE((Age_Gro[Size160to180] EQ 25) AND (Sex_Gro[Size160to180] EQ 0), Age25Size160to180countM)
        age26Size160to180M = WHERE((Age_Gro[Size160to180] EQ 26) AND (Sex_Gro[Size160to180] EQ 0), Age26Size160to180countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+4L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+4L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+4L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+4L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+4L] = 160
        WAE_length_bin[42, i*NumLengthBin+adj+4L] = Size160to180countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+4L] = Age0Size160to180countM
        WAE_length_bin[44, i*NumLengthBin+adj+4L] = Age1Size160to180countM
        WAE_length_bin[45, i*NumLengthBin+adj+4L] = Age2Size160to180countM
        WAE_length_bin[46, i*NumLengthBin+adj+4L] = Age3Size160to180countM
        WAE_length_bin[47, i*NumLengthBin+adj+4L] = Age4Size160to180countM
        WAE_length_bin[48, i*NumLengthBin+adj+4L] = Age5Size160to180countM
        WAE_length_bin[49, i*NumLengthBin+adj+4L] = Age6Size160to180countM
        WAE_length_bin[50, i*NumLengthBin+adj+4L] = Age7Size160to180countM
        WAE_length_bin[51, i*NumLengthBin+adj+4L] = Age8Size160to180countM
        WAE_length_bin[52, i*NumLengthBin+adj+4L] = Age9Size160to180countM
        WAE_length_bin[53, i*NumLengthBin+adj+4L] = Age10Size160to180countM
        WAE_length_bin[54, i*NumLengthBin+adj+4L] = Age11Size160to180countM
        WAE_length_bin[55, i*NumLengthBin+adj+4L] = Age12Size160to180countM
        WAE_length_bin[56, i*NumLengthBin+adj+4L] = Age13Size160to180countM
        WAE_length_bin[57, i*NumLengthBin+adj+4L] = Age14Size160to180countM
        WAE_length_bin[58, i*NumLengthBin+adj+4L] = Age15Size160to180countM
        WAE_length_bin[59, i*NumLengthBin+adj+4L] = Age16Size160to180countM
        WAE_length_bin[60, i*NumLengthBin+adj+4L] = Age17Size160to180countM
        WAE_length_bin[61, i*NumLengthBin+adj+4L] = Age18Size160to180countM
        WAE_length_bin[62, i*NumLengthBin+adj+4L] = Age19Size160to180countM
        WAE_length_bin[63, i*NumLengthBin+adj+4L] = Age20Size160to180countM
        WAE_length_bin[64, i*NumLengthBin+adj+4L] = Age21Size160to180countM
        WAE_length_bin[65, i*NumLengthBin+adj+4L] = Age22Size160to180countM
        WAE_length_bin[66, i*NumLengthBin+adj+4L] = Age23Size160to180countM
        WAE_length_bin[67, i*NumLengthBin+adj+4L] = Age24Size160to180countM
        WAE_length_bin[68, i*NumLengthBin+adj+4L] = Age25Size160to180countM
        WAE_length_bin[69, i*NumLengthBin+adj+4L] = Age26Size160to180countM
      ENDIF
      PRINT, 'Size160to180M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+4L])
      
      ; length bin 6
      IF Size180to200count GT 0 THEN BEGIN
        age0Size180to200M = WHERE((Age_Gro[Size180to200] EQ 0) AND (Sex_Gro[Size180to200] EQ 0), Age0Size180to200countM)
        age1Size180to200M = WHERE((Age_Gro[Size180to200] EQ 1) AND (Sex_Gro[Size180to200] EQ 0), Age1Size180to200countM)
        age2Size180to200M = WHERE((Age_Gro[Size180to200] EQ 2) AND (Sex_Gro[Size180to200] EQ 0), Age2Size180to200countM)
        age3Size180to200M = WHERE((Age_Gro[Size180to200] EQ 3) AND (Sex_Gro[Size180to200] EQ 0), Age3Size180to200countM)
        age4Size180to200M = WHERE((Age_Gro[Size180to200] EQ 4) AND (Sex_Gro[Size180to200] EQ 0), Age4Size180to200countM)
        age5Size180to200M = WHERE((Age_Gro[Size180to200] EQ 5) AND (Sex_Gro[Size180to200] EQ 0), Age5Size180to200countM)
        age6Size180to200M = WHERE((Age_Gro[Size180to200] EQ 6) AND (Sex_Gro[Size180to200] EQ 0), Age6Size180to200countM)
        age7Size180to200M = WHERE((Age_Gro[Size180to200] EQ 7) AND (Sex_Gro[Size180to200] EQ 0), Age7Size180to200countM)
        age8Size180to200M = WHERE((Age_Gro[Size180to200] EQ 8) AND (Sex_Gro[Size180to200] EQ 0), Age8Size180to200countM)
        age9Size180to200M = WHERE((Age_Gro[Size180to200] EQ 9) AND (Sex_Gro[Size180to200] EQ 0), Age9Size180to200countM)
        age10Size180to200M = WHERE((Age_Gro[Size180to200] EQ 10) AND (Sex_Gro[Size180to200] EQ 0), Age10Size180to200countM)
        age11Size180to200M = WHERE((Age_Gro[Size180to200] EQ 11) AND (Sex_Gro[Size180to200] EQ 0), Age11Size180to200countM)
        AGE12Size180to200M = WHERE((Age_Gro[Size180to200] EQ 12) AND (Sex_Gro[Size180to200] EQ 0), Age12Size180to200countM)
        AGE13Size180to200M = WHERE((Age_Gro[Size180to200] EQ 13) AND (Sex_Gro[Size180to200] EQ 0), Age13Size180to200countM)
        AGE14Size180to200M = WHERE((Age_Gro[Size180to200] EQ 14) AND (Sex_Gro[Size180to200] EQ 0), Age14Size180to200countM)
        AGE15Size180to200M = WHERE((Age_Gro[Size180to200] EQ 15) AND (Sex_Gro[Size180to200] EQ 0), Age15Size180to200countM)
        age16Size180to200M = WHERE((Age_Gro[Size180to200] EQ 16) AND (Sex_Gro[Size180to200] EQ 0), Age16Size180to200countM)
        age17Size180to200M = WHERE((Age_Gro[Size180to200] EQ 17) AND (Sex_Gro[Size180to200] EQ 0), Age17Size180to200countM)
        age18Size180to200M = WHERE((Age_Gro[Size180to200] EQ 18) AND (Sex_Gro[Size180to200] EQ 0), Age18Size180to200countM)
        age19Size180to200M = WHERE((Age_Gro[Size180to200] EQ 19) AND (Sex_Gro[Size180to200] EQ 0), Age19Size180to200countM)
        age20Size180to200M = WHERE((Age_Gro[Size180to200] EQ 20) AND (Sex_Gro[Size180to200] EQ 0), Age20Size180to200countM)
        age21Size180to200M = WHERE((Age_Gro[Size180to200] EQ 21) AND (Sex_Gro[Size180to200] EQ 0), Age21Size180to200countM)
        age22Size180to200M = WHERE((Age_Gro[Size180to200] EQ 22) AND (Sex_Gro[Size180to200] EQ 0), Age22Size180to200countM)
        age23Size180to200M = WHERE((Age_Gro[Size180to200] EQ 23) AND (Sex_Gro[Size180to200] EQ 0), Age23Size180to200countM)
        age24Size180to200M = WHERE((Age_Gro[Size180to200] EQ 24) AND (Sex_Gro[Size180to200] EQ 0), Age24Size180to200countM)
        age25Size180to200M = WHERE((Age_Gro[Size180to200] EQ 25) AND (Sex_Gro[Size180to200] EQ 0), Age25Size180to200countM)
        age26Size180to200M = WHERE((Age_Gro[Size180to200] EQ 26) AND (Sex_Gro[Size180to200] EQ 0), Age26Size180to200countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+5L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+5L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+5L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+5L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+5L] = 180
        WAE_length_bin[42, i*NumLengthBin+adj+5L] = Size180to200countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+5L] = Age0Size180to200countM
        WAE_length_bin[44, i*NumLengthBin+adj+5L] = Age1Size180to200countM
        WAE_length_bin[45, i*NumLengthBin+adj+5L] = Age2Size180to200countM
        WAE_length_bin[46, i*NumLengthBin+adj+5L] = Age3Size180to200countM
        WAE_length_bin[47, i*NumLengthBin+adj+5L] = Age4Size180to200countM
        WAE_length_bin[48, i*NumLengthBin+adj+5L] = Age5Size180to200countM
        WAE_length_bin[49, i*NumLengthBin+adj+5L] = Age6Size180to200countM
        WAE_length_bin[50, i*NumLengthBin+adj+5L] = Age7Size180to200countM
        WAE_length_bin[51, i*NumLengthBin+adj+5L] = Age8Size180to200countM
        WAE_length_bin[52, i*NumLengthBin+adj+5L] = Age9Size180to200countM
        WAE_length_bin[53, i*NumLengthBin+adj+5L] = Age10Size180to200countM
        WAE_length_bin[54, i*NumLengthBin+adj+5L] = Age11Size180to200countM
        WAE_length_bin[55, i*NumLengthBin+adj+5L] = Age12Size180to200countM
        WAE_length_bin[56, i*NumLengthBin+adj+5L] = Age13Size180to200countM
        WAE_length_bin[57, i*NumLengthBin+adj+5L] = Age14Size180to200countM
        WAE_length_bin[58, i*NumLengthBin+adj+5L] = Age15Size180to200countM
        WAE_length_bin[59, i*NumLengthBin+adj+5L] = Age16Size180to200countM
        WAE_length_bin[60, i*NumLengthBin+adj+5L] = Age17Size180to200countM
        WAE_length_bin[61, i*NumLengthBin+adj+5L] = Age18Size180to200countM
        WAE_length_bin[62, i*NumLengthBin+adj+5L] = Age19Size180to200countM
        WAE_length_bin[63, i*NumLengthBin+adj+5L] = Age20Size180to200countM
        WAE_length_bin[64, i*NumLengthBin+adj+5L] = Age21Size180to200countM
        WAE_length_bin[65, i*NumLengthBin+adj+5L] = Age22Size180to200countM
        WAE_length_bin[66, i*NumLengthBin+adj+5L] = Age23Size180to200countM
        WAE_length_bin[67, i*NumLengthBin+adj+5L] = Age24Size180to200countM
        WAE_length_bin[68, i*NumLengthBin+adj+5L] = Age25Size180to200countM
        WAE_length_bin[69, i*NumLengthBin+adj+5L] = Age26Size180to200countM
      ENDIF
      PRINT, 'Size180to200M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+5L])
      
      ; length bin 7
      IF Size200to220count GT 0 THEN BEGIN
        age0Size200to220M = WHERE((Age_Gro[Size200to220] EQ 0) AND (Sex_Gro[Size200to220] EQ 0), Age0Size200to220countM)
        age1Size200to220M = WHERE((Age_Gro[Size200to220] EQ 1) AND (Sex_Gro[Size200to220] EQ 0), Age1Size200to220countM)
        age2Size200to220M = WHERE((Age_Gro[Size200to220] EQ 2) AND (Sex_Gro[Size200to220] EQ 0), Age2Size200to220countM)
        age3Size200to220M = WHERE((Age_Gro[Size200to220] EQ 3) AND (Sex_Gro[Size200to220] EQ 0), Age3Size200to220countM)
        age4Size200to220M = WHERE((Age_Gro[Size200to220] EQ 4) AND (Sex_Gro[Size200to220] EQ 0), Age4Size200to220countM)
        age5Size200to220M = WHERE((Age_Gro[Size200to220] EQ 5) AND (Sex_Gro[Size200to220] EQ 0), Age5Size200to220countM)
        age6Size200to220M = WHERE((Age_Gro[Size200to220] EQ 6) AND (Sex_Gro[Size200to220] EQ 0), Age6Size200to220countM)
        age7Size200to220M = WHERE((Age_Gro[Size200to220] EQ 7) AND (Sex_Gro[Size200to220] EQ 0), Age7Size200to220countM)
        age8Size200to220M = WHERE((Age_Gro[Size200to220] EQ 8) AND (Sex_Gro[Size200to220] EQ 0), Age8Size200to220countM)
        age9Size200to220M = WHERE((Age_Gro[Size200to220] EQ 9) AND (Sex_Gro[Size200to220] EQ 0), Age9Size200to220countM)
        age10Size200to220M = WHERE((Age_Gro[Size200to220] EQ 10) AND (Sex_Gro[Size200to220] EQ 0), Age10Size200to220countM)
        age11Size200to220M = WHERE((Age_Gro[Size200to220] EQ 11) AND (Sex_Gro[Size200to220] EQ 0), Age11Size200to220countM)
        AGE12Size200to220M = WHERE((Age_Gro[Size200to220] EQ 12) AND (Sex_Gro[Size200to220] EQ 0), Age12Size200to220countM)
        AGE13Size200to220M = WHERE((Age_Gro[Size200to220] EQ 13) AND (Sex_Gro[Size200to220] EQ 0), Age13Size200to220countM)
        AGE14Size200to220M = WHERE((Age_Gro[Size200to220] EQ 14) AND (Sex_Gro[Size200to220] EQ 0), Age14Size200to220countM)
        AGE15Size200to220M = WHERE((Age_Gro[Size200to220] EQ 15) AND (Sex_Gro[Size200to220] EQ 0), Age15Size200to220countM)
        age16Size200to220M = WHERE((Age_Gro[Size200to220] EQ 16) AND (Sex_Gro[Size200to220] EQ 0), Age16Size200to220countM)
        age17Size200to220M = WHERE((Age_Gro[Size200to220] EQ 17) AND (Sex_Gro[Size200to220] EQ 0), Age17Size200to220countM)
        age18Size200to220M = WHERE((Age_Gro[Size200to220] EQ 18) AND (Sex_Gro[Size200to220] EQ 0), Age18Size200to220countM)
        age19Size200to220M = WHERE((Age_Gro[Size200to220] EQ 19) AND (Sex_Gro[Size200to220] EQ 0), Age19Size200to220countM)
        age20Size200to220M = WHERE((Age_Gro[Size200to220] EQ 20) AND (Sex_Gro[Size200to220] EQ 0), Age20Size200to220countM)
        age21Size200to220M = WHERE((Age_Gro[Size200to220] EQ 21) AND (Sex_Gro[Size200to220] EQ 0), Age21Size200to220countM)
        age22Size200to220M = WHERE((Age_Gro[Size200to220] EQ 22) AND (Sex_Gro[Size200to220] EQ 0), Age22Size200to220countM)
        age23Size200to220M = WHERE((Age_Gro[Size200to220] EQ 23) AND (Sex_Gro[Size200to220] EQ 0), Age23Size200to220countM)
        age24Size200to220M = WHERE((Age_Gro[Size200to220] EQ 24) AND (Sex_Gro[Size200to220] EQ 0), Age24Size200to220countM)
        age25Size200to220M = WHERE((Age_Gro[Size200to220] EQ 25) AND (Sex_Gro[Size200to220] EQ 0), Age25Size200to220countM)
        age26Size200to220M = WHERE((Age_Gro[Size200to220] EQ 26) AND (Sex_Gro[Size200to220] EQ 0), Age26Size200to220countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+6L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+6L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+6L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+6L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+6L] = 200
        WAE_length_bin[42, i*NumLengthBin+adj+6L] = Size200to220countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+6L] = Age0Size200to220countM
        WAE_length_bin[44, i*NumLengthBin+adj+6L] = Age1Size200to220countM
        WAE_length_bin[45, i*NumLengthBin+adj+6L] = Age2Size200to220countM
        WAE_length_bin[46, i*NumLengthBin+adj+6L] = Age3Size200to220countM
        WAE_length_bin[47, i*NumLengthBin+adj+6L] = Age4Size200to220countM
        WAE_length_bin[48, i*NumLengthBin+adj+6L] = Age5Size200to220countM
        WAE_length_bin[49, i*NumLengthBin+adj+6L] = Age6Size200to220countM
        WAE_length_bin[50, i*NumLengthBin+adj+6L] = Age7Size200to220countM
        WAE_length_bin[51, i*NumLengthBin+adj+6L] = Age8Size200to220countM
        WAE_length_bin[52, i*NumLengthBin+adj+6L] = Age9Size200to220countM
        WAE_length_bin[53, i*NumLengthBin+adj+6L] = Age10Size200to220countM
        WAE_length_bin[54, i*NumLengthBin+adj+6L] = Age11Size200to220countM
        WAE_length_bin[55, i*NumLengthBin+adj+6L] = Age12Size200to220countM
        WAE_length_bin[56, i*NumLengthBin+adj+6L] = Age13Size200to220countM
        WAE_length_bin[57, i*NumLengthBin+adj+6L] = Age14Size200to220countM
        WAE_length_bin[58, i*NumLengthBin+adj+6L] = Age15Size200to220countM
        WAE_length_bin[59, i*NumLengthBin+adj+6L] = Age16Size200to220countM
        WAE_length_bin[60, i*NumLengthBin+adj+6L] = Age17Size200to220countM
        WAE_length_bin[61, i*NumLengthBin+adj+6L] = Age18Size200to220countM
        WAE_length_bin[62, i*NumLengthBin+adj+6L] = Age19Size200to220countM
        WAE_length_bin[63, i*NumLengthBin+adj+6L] = Age20Size200to220countM
        WAE_length_bin[64, i*NumLengthBin+adj+6L] = Age21Size200to220countM
        WAE_length_bin[65, i*NumLengthBin+adj+6L] = Age22Size200to220countM
        WAE_length_bin[66, i*NumLengthBin+adj+6L] = Age23Size200to220countM
        WAE_length_bin[67, i*NumLengthBin+adj+6L] = Age24Size200to220countM
        WAE_length_bin[68, i*NumLengthBin+adj+6L] = Age25Size200to220countM
        WAE_length_bin[69, i*NumLengthBin+adj+6L] = Age26Size200to220countM
      ENDIF
      PRINT, 'Size200to220M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+6L])
      
      ; length bin 8
      IF Size220to240count GT 0 THEN BEGIN
        age0Size220to240M = WHERE((Age_Gro[Size220to240] EQ 0) AND (Sex_Gro[Size220to240] EQ 0), Age0Size220to240countM)
        age1Size220to240M = WHERE((Age_Gro[Size220to240] EQ 1) AND (Sex_Gro[Size220to240] EQ 0), Age1Size220to240countM)
        age2Size220to240M = WHERE((Age_Gro[Size220to240] EQ 2) AND (Sex_Gro[Size220to240] EQ 0), Age2Size220to240countM)
        age3Size220to240M = WHERE((Age_Gro[Size220to240] EQ 3) AND (Sex_Gro[Size220to240] EQ 0), Age3Size220to240countM)
        age4Size220to240M = WHERE((Age_Gro[Size220to240] EQ 4) AND (Sex_Gro[Size220to240] EQ 0), Age4Size220to240countM)
        age5Size220to240M = WHERE((Age_Gro[Size220to240] EQ 5) AND (Sex_Gro[Size220to240] EQ 0), Age5Size220to240countM)
        age6Size220to240M = WHERE((Age_Gro[Size220to240] EQ 6) AND (Sex_Gro[Size220to240] EQ 0), Age6Size220to240countM)
        age7Size220to240M = WHERE((Age_Gro[Size220to240] EQ 7) AND (Sex_Gro[Size220to240] EQ 0), Age7Size220to240countM)
        age8Size220to240M = WHERE((Age_Gro[Size220to240] EQ 8) AND (Sex_Gro[Size220to240] EQ 0), Age8Size220to240countM)
        age9Size220to240M = WHERE((Age_Gro[Size220to240] EQ 9) AND (Sex_Gro[Size220to240] EQ 0), Age9Size220to240countM)
        age10Size220to240M = WHERE((Age_Gro[Size220to240] EQ 10) AND (Sex_Gro[Size220to240] EQ 0), Age10Size220to240countM)
        age11Size220to240M = WHERE((Age_Gro[Size220to240] EQ 11) AND (Sex_Gro[Size220to240] EQ 0), Age11Size220to240countM)
        AGE12Size220to240M = WHERE((Age_Gro[Size220to240] EQ 12) AND (Sex_Gro[Size220to240] EQ 0), Age12Size220to240countM)
        AGE13Size220to240M = WHERE((Age_Gro[Size220to240] EQ 13) AND (Sex_Gro[Size220to240] EQ 0), Age13Size220to240countM)
        AGE14Size220to240M = WHERE((Age_Gro[Size220to240] EQ 14) AND (Sex_Gro[Size220to240] EQ 0), Age14Size220to240countM)
        AGE15Size220to240M = WHERE((Age_Gro[Size220to240] EQ 15) AND (Sex_Gro[Size220to240] EQ 0), Age15Size220to240countM)
        age16Size220to240M = WHERE((Age_Gro[Size220to240] EQ 16) AND (Sex_Gro[Size220to240] EQ 0), Age16Size220to240countM)
        age17Size220to240M = WHERE((Age_Gro[Size220to240] EQ 17) AND (Sex_Gro[Size220to240] EQ 0), Age17Size220to240countM)
        age18Size220to240M = WHERE((Age_Gro[Size220to240] EQ 18) AND (Sex_Gro[Size220to240] EQ 0), Age18Size220to240countM)
        age19Size220to240M = WHERE((Age_Gro[Size220to240] EQ 19) AND (Sex_Gro[Size220to240] EQ 0), Age19Size220to240countM)
        age20Size220to240M = WHERE((Age_Gro[Size220to240] EQ 20) AND (Sex_Gro[Size220to240] EQ 0), Age20Size220to240countM)
        age21Size220to240M = WHERE((Age_Gro[Size220to240] EQ 21) AND (Sex_Gro[Size220to240] EQ 0), Age21Size220to240countM)
        age22Size220to240M = WHERE((Age_Gro[Size220to240] EQ 22) AND (Sex_Gro[Size220to240] EQ 0), Age22Size220to240countM)
        age23Size220to240M = WHERE((Age_Gro[Size220to240] EQ 23) AND (Sex_Gro[Size220to240] EQ 0), Age23Size220to240countM)
        age24Size220to240M = WHERE((Age_Gro[Size220to240] EQ 24) AND (Sex_Gro[Size220to240] EQ 0), Age24Size220to240countM)
        age25Size220to240M = WHERE((Age_Gro[Size220to240] EQ 25) AND (Sex_Gro[Size220to240] EQ 0), Age25Size220to240countM)
        age26Size220to240M = WHERE((Age_Gro[Size220to240] EQ 26) AND (Sex_Gro[Size220to240] EQ 0), Age26Size220to240countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+7L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+7L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+7L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+7L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+7L] = 220
        WAE_length_bin[42, i*NumLengthBin+adj+7L] = Size220to240countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+7L] = Age0Size220to240countM
        WAE_length_bin[44, i*NumLengthBin+adj+7L] = Age1Size220to240countM
        WAE_length_bin[45, i*NumLengthBin+adj+7L] = Age2Size220to240countM
        WAE_length_bin[46, i*NumLengthBin+adj+7L] = Age3Size220to240countM
        WAE_length_bin[47, i*NumLengthBin+adj+7L] = Age4Size220to240countM
        WAE_length_bin[48, i*NumLengthBin+adj+7L] = Age5Size220to240countM
        WAE_length_bin[49, i*NumLengthBin+adj+7L] = Age6Size220to240countM
        WAE_length_bin[50, i*NumLengthBin+adj+7L] = Age7Size220to240countM
        WAE_length_bin[51, i*NumLengthBin+adj+7L] = Age8Size220to240countM
        WAE_length_bin[52, i*NumLengthBin+adj+7L] = Age9Size220to240countM
        WAE_length_bin[53, i*NumLengthBin+adj+7L] = Age10Size220to240countM
        WAE_length_bin[54, i*NumLengthBin+adj+7L] = Age11Size220to240countM
        WAE_length_bin[55, i*NumLengthBin+adj+7L] = Age12Size220to240countM
        WAE_length_bin[56, i*NumLengthBin+adj+7L] = Age13Size220to240countM
        WAE_length_bin[57, i*NumLengthBin+adj+7L] = Age14Size220to240countM
        WAE_length_bin[58, i*NumLengthBin+adj+7L] = Age15Size220to240countM
        WAE_length_bin[59, i*NumLengthBin+adj+7L] = Age16Size220to240countM
        WAE_length_bin[60, i*NumLengthBin+adj+7L] = Age17Size220to240countM
        WAE_length_bin[61, i*NumLengthBin+adj+7L] = Age18Size220to240countM
        WAE_length_bin[62, i*NumLengthBin+adj+7L] = Age19Size220to240countM
        WAE_length_bin[63, i*NumLengthBin+adj+7L] = Age20Size220to240countM
        WAE_length_bin[64, i*NumLengthBin+adj+7L] = Age21Size220to240countM
        WAE_length_bin[65, i*NumLengthBin+adj+7L] = Age22Size220to240countM
        WAE_length_bin[66, i*NumLengthBin+adj+7L] = Age23Size220to240countM
        WAE_length_bin[67, i*NumLengthBin+adj+7L] = Age24Size220to240countM
        WAE_length_bin[68, i*NumLengthBin+adj+7L] = Age25Size220to240countM
        WAE_length_bin[69, i*NumLengthBin+adj+7L] = Age26Size220to240countM
      ENDIF
      PRINT, 'Size220to240M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+7L])
      
      ; length bin 9
      IF Size240to260count GT 0 THEN BEGIN
        age0Size240to260M = WHERE((Age_Gro[Size240to260] EQ 0) AND (Sex_Gro[Size240to260] EQ 0), Age0Size240to260countM)
        age1Size240to260M = WHERE((Age_Gro[Size240to260] EQ 1) AND (Sex_Gro[Size240to260] EQ 0), Age1Size240to260countM)
        age2Size240to260M = WHERE((Age_Gro[Size240to260] EQ 2) AND (Sex_Gro[Size240to260] EQ 0), Age2Size240to260countM)
        age3Size240to260M = WHERE((Age_Gro[Size240to260] EQ 3) AND (Sex_Gro[Size240to260] EQ 0), Age3Size240to260countM)
        age4Size240to260M = WHERE((Age_Gro[Size240to260] EQ 4) AND (Sex_Gro[Size240to260] EQ 0), Age4Size240to260countM)
        age5Size240to260M = WHERE((Age_Gro[Size240to260] EQ 5) AND (Sex_Gro[Size240to260] EQ 0), Age5Size240to260countM)
        age6Size240to260M = WHERE((Age_Gro[Size240to260] EQ 6) AND (Sex_Gro[Size240to260] EQ 0), Age6Size240to260countM)
        age7Size240to260M = WHERE((Age_Gro[Size240to260] EQ 7) AND (Sex_Gro[Size240to260] EQ 0), Age7Size240to260countM)
        age8Size240to260M = WHERE((Age_Gro[Size240to260] EQ 8) AND (Sex_Gro[Size240to260] EQ 0), Age8Size240to260countM)
        age9Size240to260M = WHERE((Age_Gro[Size240to260] EQ 9) AND (Sex_Gro[Size240to260] EQ 0), Age9Size240to260countM)
        age10Size240to260M = WHERE((Age_Gro[Size240to260] EQ 10) AND (Sex_Gro[Size240to260] EQ 0), Age10Size240to260countM)
        age11Size240to260M = WHERE((Age_Gro[Size240to260] EQ 11) AND (Sex_Gro[Size240to260] EQ 0), Age11Size240to260countM)
        AGE12Size240to260M = WHERE((Age_Gro[Size240to260] EQ 12) AND (Sex_Gro[Size240to260] EQ 0), Age12Size240to260countM)
        AGE13Size240to260M = WHERE((Age_Gro[Size240to260] EQ 13) AND (Sex_Gro[Size240to260] EQ 0), Age13Size240to260countM)
        AGE14Size240to260M = WHERE((Age_Gro[Size240to260] EQ 14) AND (Sex_Gro[Size240to260] EQ 0), Age14Size240to260countM)
        AGE15Size240to260M = WHERE((Age_Gro[Size240to260] EQ 15) AND (Sex_Gro[Size240to260] EQ 0), Age15Size240to260countM)
        age16Size240to260M = WHERE((Age_Gro[Size240to260] EQ 16) AND (Sex_Gro[Size240to260] EQ 0), Age16Size240to260countM)
        age17Size240to260M = WHERE((Age_Gro[Size240to260] EQ 17) AND (Sex_Gro[Size240to260] EQ 0), Age17Size240to260countM)
        age18Size240to260M = WHERE((Age_Gro[Size240to260] EQ 18) AND (Sex_Gro[Size240to260] EQ 0), Age18Size240to260countM)
        age19Size240to260M = WHERE((Age_Gro[Size240to260] EQ 19) AND (Sex_Gro[Size240to260] EQ 0), Age19Size240to260countM)
        age20Size240to260M = WHERE((Age_Gro[Size240to260] EQ 20) AND (Sex_Gro[Size240to260] EQ 0), Age20Size240to260countM)
        age21Size240to260M = WHERE((Age_Gro[Size240to260] EQ 21) AND (Sex_Gro[Size240to260] EQ 0), Age21Size240to260countM)
        age22Size240to260M = WHERE((Age_Gro[Size240to260] EQ 22) AND (Sex_Gro[Size240to260] EQ 0), Age22Size240to260countM)
        age23Size240to260M = WHERE((Age_Gro[Size240to260] EQ 23) AND (Sex_Gro[Size240to260] EQ 0), Age23Size240to260countM)
        age24Size240to260M = WHERE((Age_Gro[Size240to260] EQ 24) AND (Sex_Gro[Size240to260] EQ 0), Age24Size240to260countM)
        age25Size240to260M = WHERE((Age_Gro[Size240to260] EQ 25) AND (Sex_Gro[Size240to260] EQ 0), Age25Size240to260countM)
        age26Size240to260M = WHERE((Age_Gro[Size240to260] EQ 26) AND (Sex_Gro[Size240to260] EQ 0), Age26Size240to260countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+8L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+8L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+8L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+8L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+8L] = 240
        WAE_length_bin[42, i*NumLengthBin+adj+8L] = Size240to260countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+8L] = Age0Size240to260countM
        WAE_length_bin[44, i*NumLengthBin+adj+8L] = Age1Size240to260countM
        WAE_length_bin[45, i*NumLengthBin+adj+8L] = Age2Size240to260countM
        WAE_length_bin[46, i*NumLengthBin+adj+8L] = Age3Size240to260countM
        WAE_length_bin[47, i*NumLengthBin+adj+8L] = Age4Size240to260countM
        WAE_length_bin[48, i*NumLengthBin+adj+8L] = Age5Size240to260countM
        WAE_length_bin[49, i*NumLengthBin+adj+8L] = Age6Size240to260countM
        WAE_length_bin[50, i*NumLengthBin+adj+8L] = Age7Size240to260countM
        WAE_length_bin[51, i*NumLengthBin+adj+8L] = Age8Size240to260countM
        WAE_length_bin[52, i*NumLengthBin+adj+8L] = Age9Size240to260countM
        WAE_length_bin[53, i*NumLengthBin+adj+8L] = Age10Size240to260countM
        WAE_length_bin[54, i*NumLengthBin+adj+8L] = Age11Size240to260countM
        WAE_length_bin[55, i*NumLengthBin+adj+8L] = Age12Size240to260countM
        WAE_length_bin[56, i*NumLengthBin+adj+8L] = Age13Size240to260countM
        WAE_length_bin[57, i*NumLengthBin+adj+8L] = Age14Size240to260countM
        WAE_length_bin[58, i*NumLengthBin+adj+8L] = Age15Size240to260countM
        WAE_length_bin[59, i*NumLengthBin+adj+8L] = Age16Size240to260countM
        WAE_length_bin[60, i*NumLengthBin+adj+8L] = Age17Size240to260countM
        WAE_length_bin[61, i*NumLengthBin+adj+8L] = Age18Size240to260countM
        WAE_length_bin[62, i*NumLengthBin+adj+8L] = Age19Size240to260countM
        WAE_length_bin[63, i*NumLengthBin+adj+8L] = Age20Size240to260countM
        WAE_length_bin[64, i*NumLengthBin+adj+8L] = Age21Size240to260countM
        WAE_length_bin[65, i*NumLengthBin+adj+8L] = Age22Size240to260countM
        WAE_length_bin[66, i*NumLengthBin+adj+8L] = Age23Size240to260countM
        WAE_length_bin[67, i*NumLengthBin+adj+8L] = Age24Size240to260countM
        WAE_length_bin[68, i*NumLengthBin+adj+8L] = Age25Size240to260countM
        WAE_length_bin[69, i*NumLengthBin+adj+8L] = Age26Size240to260countM
      ENDIF
      PRINT, 'Size240to260M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+8L])
      
      ; length bin 10
      IF Size260to280count GT 0 THEN BEGIN
        age0Size260to280M = WHERE((Age_Gro[Size260to280] EQ 0) AND (Sex_Gro[Size260to280] EQ 0), Age0Size260to280countM)
        age1Size260to280M = WHERE((Age_Gro[Size260to280] EQ 1) AND (Sex_Gro[Size260to280] EQ 0), Age1Size260to280countM)
        age2Size260to280M = WHERE((Age_Gro[Size260to280] EQ 2) AND (Sex_Gro[Size260to280] EQ 0), Age2Size260to280countM)
        age3Size260to280M = WHERE((Age_Gro[Size260to280] EQ 3) AND (Sex_Gro[Size260to280] EQ 0), Age3Size260to280countM)
        age4Size260to280M = WHERE((Age_Gro[Size260to280] EQ 4) AND (Sex_Gro[Size260to280] EQ 0), Age4Size260to280countM)
        age5Size260to280M = WHERE((Age_Gro[Size260to280] EQ 5) AND (Sex_Gro[Size260to280] EQ 0), Age5Size260to280countM)
        age6Size260to280M = WHERE((Age_Gro[Size260to280] EQ 6) AND (Sex_Gro[Size260to280] EQ 0), Age6Size260to280countM)
        age7Size260to280M = WHERE((Age_Gro[Size260to280] EQ 7) AND (Sex_Gro[Size260to280] EQ 0), Age7Size260to280countM)
        age8Size260to280M = WHERE((Age_Gro[Size260to280] EQ 8) AND (Sex_Gro[Size260to280] EQ 0), Age8Size260to280countM)
        age9Size260to280M = WHERE((Age_Gro[Size260to280] EQ 9) AND (Sex_Gro[Size260to280] EQ 0), Age9Size260to280countM)
        age10Size260to280M = WHERE((Age_Gro[Size260to280] EQ 10) AND (Sex_Gro[Size260to280] EQ 0), Age10Size260to280countM)
        age11Size260to280M = WHERE((Age_Gro[Size260to280] EQ 11) AND (Sex_Gro[Size260to280] EQ 0), Age11Size260to280countM)
        AGE12Size260to280M = WHERE((Age_Gro[Size260to280] EQ 12) AND (Sex_Gro[Size260to280] EQ 0), Age12Size260to280countM)
        AGE13Size260to280M = WHERE((Age_Gro[Size260to280] EQ 13) AND (Sex_Gro[Size260to280] EQ 0), Age13Size260to280countM)
        AGE14Size260to280M = WHERE((Age_Gro[Size260to280] EQ 14) AND (Sex_Gro[Size260to280] EQ 0), Age14Size260to280countM)
        AGE15Size260to280M = WHERE((Age_Gro[Size260to280] EQ 15) AND (Sex_Gro[Size260to280] EQ 0), Age15Size260to280countM)
        age16Size260to280M = WHERE((Age_Gro[Size260to280] EQ 16) AND (Sex_Gro[Size260to280] EQ 0), Age16Size260to280countM)
        age17Size260to280M = WHERE((Age_Gro[Size260to280] EQ 17) AND (Sex_Gro[Size260to280] EQ 0), Age17Size260to280countM)
        age18Size260to280M = WHERE((Age_Gro[Size260to280] EQ 18) AND (Sex_Gro[Size260to280] EQ 0), Age18Size260to280countM)
        age19Size260to280M = WHERE((Age_Gro[Size260to280] EQ 19) AND (Sex_Gro[Size260to280] EQ 0), Age19Size260to280countM)
        age20Size260to280M = WHERE((Age_Gro[Size260to280] EQ 20) AND (Sex_Gro[Size260to280] EQ 0), Age20Size260to280countM)
        age21Size260to280M = WHERE((Age_Gro[Size260to280] EQ 21) AND (Sex_Gro[Size260to280] EQ 0), Age21Size260to280countM)
        age22Size260to280M = WHERE((Age_Gro[Size260to280] EQ 22) AND (Sex_Gro[Size260to280] EQ 0), Age22Size260to280countM)
        age23Size260to280M = WHERE((Age_Gro[Size260to280] EQ 23) AND (Sex_Gro[Size260to280] EQ 0), Age23Size260to280countM)
        age24Size260to280M = WHERE((Age_Gro[Size260to280] EQ 24) AND (Sex_Gro[Size260to280] EQ 0), Age24Size260to280countM)
        age25Size260to280M = WHERE((Age_Gro[Size260to280] EQ 25) AND (Sex_Gro[Size260to280] EQ 0), Age25Size260to280countM)
        age26Size260to280M = WHERE((Age_Gro[Size260to280] EQ 26) AND (Sex_Gro[Size260to280] EQ 0), Age26Size260to280countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+9L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+9L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+9L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+9L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+9L] = 260
        WAE_length_bin[42, i*NumLengthBin+adj+9L] = Size260to280countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+9L] = Age0Size260to280countM
        WAE_length_bin[44, i*NumLengthBin+adj+9L] = Age1Size260to280countM
        WAE_length_bin[45, i*NumLengthBin+adj+9L] = Age2Size260to280countM
        WAE_length_bin[46, i*NumLengthBin+adj+9L] = Age3Size260to280countM
        WAE_length_bin[47, i*NumLengthBin+adj+9L] = Age4Size260to280countM
        WAE_length_bin[48, i*NumLengthBin+adj+9L] = Age5Size260to280countM
        WAE_length_bin[49, i*NumLengthBin+adj+9L] = Age6Size260to280countM
        WAE_length_bin[50, i*NumLengthBin+adj+9L] = Age7Size260to280countM
        WAE_length_bin[51, i*NumLengthBin+adj+9L] = Age8Size260to280countM
        WAE_length_bin[52, i*NumLengthBin+adj+9L] = Age9Size260to280countM
        WAE_length_bin[53, i*NumLengthBin+adj+9L] = Age10Size260to280countM
        WAE_length_bin[54, i*NumLengthBin+adj+9L] = Age11Size260to280countM
        WAE_length_bin[55, i*NumLengthBin+adj+9L] = Age12Size260to280countM
        WAE_length_bin[56, i*NumLengthBin+adj+9L] = Age13Size260to280countM
        WAE_length_bin[57, i*NumLengthBin+adj+9L] = Age14Size260to280countM
        WAE_length_bin[58, i*NumLengthBin+adj+9L] = Age15Size260to280countM
        WAE_length_bin[59, i*NumLengthBin+adj+9L] = Age16Size260to280countM
        WAE_length_bin[60, i*NumLengthBin+adj+9L] = Age17Size260to280countM
        WAE_length_bin[61, i*NumLengthBin+adj+9L] = Age18Size260to280countM
        WAE_length_bin[62, i*NumLengthBin+adj+9L] = Age19Size260to280countM
        WAE_length_bin[63, i*NumLengthBin+adj+9L] = Age20Size260to280countM
        WAE_length_bin[64, i*NumLengthBin+adj+9L] = Age21Size260to280countM
        WAE_length_bin[65, i*NumLengthBin+adj+9L] = Age22Size260to280countM
        WAE_length_bin[66, i*NumLengthBin+adj+9L] = Age23Size260to280countM
        WAE_length_bin[67, i*NumLengthBin+adj+9L] = Age24Size260to280countM
        WAE_length_bin[68, i*NumLengthBin+adj+9L] = Age25Size260to280countM
        WAE_length_bin[69, i*NumLengthBin+adj+9L] = Age26Size260to280countM
      ENDIF
      PRINT, 'Size260to280M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+9L])
      
      ; length bin 11
      IF Size280to300count GT 0 THEN BEGIN
        age0Size280to300M = WHERE((Age_Gro[Size280to300] EQ 0) AND (Sex_Gro[Size280to300] EQ 0), Age0Size280to300countM)
        age1Size280to300M = WHERE((Age_Gro[Size280to300] EQ 1) AND (Sex_Gro[Size280to300] EQ 0), Age1Size280to300countM)
        age2Size280to300M = WHERE((Age_Gro[Size280to300] EQ 2) AND (Sex_Gro[Size280to300] EQ 0), Age2Size280to300countM)
        age3Size280to300M = WHERE((Age_Gro[Size280to300] EQ 3) AND (Sex_Gro[Size280to300] EQ 0), Age3Size280to300countM)
        age4Size280to300M = WHERE((Age_Gro[Size280to300] EQ 4) AND (Sex_Gro[Size280to300] EQ 0), Age4Size280to300countM)
        age5Size280to300M = WHERE((Age_Gro[Size280to300] EQ 5) AND (Sex_Gro[Size280to300] EQ 0), Age5Size280to300countM)
        age6Size280to300M = WHERE((Age_Gro[Size280to300] EQ 6) AND (Sex_Gro[Size280to300] EQ 0), Age6Size280to300countM)
        age7Size280to300M = WHERE((Age_Gro[Size280to300] EQ 7) AND (Sex_Gro[Size280to300] EQ 0), Age7Size280to300countM)
        age8Size280to300M = WHERE((Age_Gro[Size280to300] EQ 8) AND (Sex_Gro[Size280to300] EQ 0), Age8Size280to300countM)
        age9Size280to300M = WHERE((Age_Gro[Size280to300] EQ 9) AND (Sex_Gro[Size280to300] EQ 0), Age9Size280to300countM)
        age10Size280to300M = WHERE((Age_Gro[Size280to300] EQ 10) AND (Sex_Gro[Size280to300] EQ 0), Age10Size280to300countM)
        age11Size280to300M = WHERE((Age_Gro[Size280to300] EQ 11) AND (Sex_Gro[Size280to300] EQ 0), Age11Size280to300countM)
        AGE12Size280to300M = WHERE((Age_Gro[Size280to300] EQ 12) AND (Sex_Gro[Size280to300] EQ 0), Age12Size280to300countM)
        AGE13Size280to300M = WHERE((Age_Gro[Size280to300] EQ 13) AND (Sex_Gro[Size280to300] EQ 0), Age13Size280to300countM)
        AGE14Size280to300M = WHERE((Age_Gro[Size280to300] EQ 14) AND (Sex_Gro[Size280to300] EQ 0), Age14Size280to300countM)
        AGE15Size280to300M = WHERE((Age_Gro[Size280to300] EQ 15) AND (Sex_Gro[Size280to300] EQ 0), Age15Size280to300countM)
        age16Size280to300M = WHERE((Age_Gro[Size280to300] EQ 16) AND (Sex_Gro[Size280to300] EQ 0), Age16Size280to300countM)
        age17Size280to300M = WHERE((Age_Gro[Size280to300] EQ 17) AND (Sex_Gro[Size280to300] EQ 0), Age17Size280to300countM)
        age18Size280to300M = WHERE((Age_Gro[Size280to300] EQ 18) AND (Sex_Gro[Size280to300] EQ 0), Age18Size280to300countM)
        age19Size280to300M = WHERE((Age_Gro[Size280to300] EQ 19) AND (Sex_Gro[Size280to300] EQ 0), Age19Size280to300countM)
        age20Size280to300M = WHERE((Age_Gro[Size280to300] EQ 20) AND (Sex_Gro[Size280to300] EQ 0), Age20Size280to300countM)
        age21Size280to300M = WHERE((Age_Gro[Size280to300] EQ 21) AND (Sex_Gro[Size280to300] EQ 0), Age21Size280to300countM)
        age22Size280to300M = WHERE((Age_Gro[Size280to300] EQ 22) AND (Sex_Gro[Size280to300] EQ 0), Age22Size280to300countM)
        age23Size280to300M = WHERE((Age_Gro[Size280to300] EQ 23) AND (Sex_Gro[Size280to300] EQ 0), Age23Size280to300countM)
        age24Size280to300M = WHERE((Age_Gro[Size280to300] EQ 24) AND (Sex_Gro[Size280to300] EQ 0), Age24Size280to300countM)
        age25Size280to300M = WHERE((Age_Gro[Size280to300] EQ 25) AND (Sex_Gro[Size280to300] EQ 0), Age25Size280to300countM)
        age26Size280to300M = WHERE((Age_Gro[Size280to300] EQ 26) AND (Sex_Gro[Size280to300] EQ 0), Age26Size280to300countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+10L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+10L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+10L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+10L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+10L] = 280
        WAE_length_bin[42, i*NumLengthBin+adj+10L] = Size280to300countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+10L] = Age0Size280to300countM
        WAE_length_bin[44, i*NumLengthBin+adj+10L] = Age1Size280to300countM
        WAE_length_bin[45, i*NumLengthBin+adj+10L] = Age2Size280to300countM
        WAE_length_bin[46, i*NumLengthBin+adj+10L] = Age3Size280to300countM
        WAE_length_bin[47, i*NumLengthBin+adj+10L] = Age4Size280to300countM
        WAE_length_bin[48, i*NumLengthBin+adj+10L] = Age5Size280to300countM
        WAE_length_bin[49, i*NumLengthBin+adj+10L] = Age6Size280to300countM
        WAE_length_bin[50, i*NumLengthBin+adj+10L] = Age7Size280to300countM
        WAE_length_bin[51, i*NumLengthBin+adj+10L] = Age8Size280to300countM
        WAE_length_bin[52, i*NumLengthBin+adj+10L] = Age9Size280to300countM
        WAE_length_bin[53, i*NumLengthBin+adj+10L] = Age10Size280to300countM
        WAE_length_bin[54, i*NumLengthBin+adj+10L] = Age11Size280to300countM
        WAE_length_bin[55, i*NumLengthBin+adj+10L] = Age12Size280to300countM
        WAE_length_bin[56, i*NumLengthBin+adj+10L] = Age13Size280to300countM
        WAE_length_bin[57, i*NumLengthBin+adj+10L] = Age14Size280to300countM
        WAE_length_bin[58, i*NumLengthBin+adj+10L] = Age15Size280to300countM
        WAE_length_bin[59, i*NumLengthBin+adj+10L] = Age16Size280to300countM
        WAE_length_bin[60, i*NumLengthBin+adj+10L] = Age17Size280to300countM
        WAE_length_bin[61, i*NumLengthBin+adj+10L] = Age18Size280to300countM
        WAE_length_bin[62, i*NumLengthBin+adj+10L] = Age19Size280to300countM
        WAE_length_bin[63, i*NumLengthBin+adj+10L] = Age20Size280to300countM
        WAE_length_bin[64, i*NumLengthBin+adj+10L] = Age21Size280to300countM
        WAE_length_bin[65, i*NumLengthBin+adj+10L] = Age22Size280to300countM
        WAE_length_bin[66, i*NumLengthBin+adj+10L] = Age23Size280to300countM
        WAE_length_bin[67, i*NumLengthBin+adj+10L] = Age24Size280to300countM
        WAE_length_bin[68, i*NumLengthBin+adj+10L] = Age25Size280to300countM
        WAE_length_bin[69, i*NumLengthBin+adj+10L] = Age26Size280to300countM
      ENDIF
      PRINT, 'Size280to300M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+10L])
      
      ; length bin 12
      IF Size300to320count GT 0 THEN BEGIN
        age0Size300to320M = WHERE((Age_Gro[Size300to320] EQ 0) AND (Sex_Gro[Size300to320] EQ 0), Age0Size300to320countM)
        age1Size300to320M = WHERE((Age_Gro[Size300to320] EQ 1) AND (Sex_Gro[Size300to320] EQ 0), Age1Size300to320countM)
        age2Size300to320M = WHERE((Age_Gro[Size300to320] EQ 2) AND (Sex_Gro[Size300to320] EQ 0), Age2Size300to320countM)
        age3Size300to320M = WHERE((Age_Gro[Size300to320] EQ 3) AND (Sex_Gro[Size300to320] EQ 0), Age3Size300to320countM)
        age4Size300to320M = WHERE((Age_Gro[Size300to320] EQ 4) AND (Sex_Gro[Size300to320] EQ 0), Age4Size300to320countM)
        age5Size300to320M = WHERE((Age_Gro[Size300to320] EQ 5) AND (Sex_Gro[Size300to320] EQ 0), Age5Size300to320countM)
        age6Size300to320M = WHERE((Age_Gro[Size300to320] EQ 6) AND (Sex_Gro[Size300to320] EQ 0), Age6Size300to320countM)
        age7Size300to320M = WHERE((Age_Gro[Size300to320] EQ 7) AND (Sex_Gro[Size300to320] EQ 0), Age7Size300to320countM)
        age8Size300to320M = WHERE((Age_Gro[Size300to320] EQ 8) AND (Sex_Gro[Size300to320] EQ 0), Age8Size300to320countM)
        age9Size300to320M = WHERE((Age_Gro[Size300to320] EQ 9) AND (Sex_Gro[Size300to320] EQ 0), Age9Size300to320countM)
        age10Size300to320M = WHERE((Age_Gro[Size300to320] EQ 10) AND (Sex_Gro[Size300to320] EQ 0), Age10Size300to320countM)
        age11Size300to320M = WHERE((Age_Gro[Size300to320] EQ 11) AND (Sex_Gro[Size300to320] EQ 0), Age11Size300to320countM)
        AGE12Size300to320M = WHERE((Age_Gro[Size300to320] EQ 12) AND (Sex_Gro[Size300to320] EQ 0), Age12Size300to320countM)
        AGE13Size300to320M = WHERE((Age_Gro[Size300to320] EQ 13) AND (Sex_Gro[Size300to320] EQ 0), Age13Size300to320countM)
        AGE14Size300to320M = WHERE((Age_Gro[Size300to320] EQ 14) AND (Sex_Gro[Size300to320] EQ 0), Age14Size300to320countM)
        AGE15Size300to320M = WHERE((Age_Gro[Size300to320] EQ 15) AND (Sex_Gro[Size300to320] EQ 0), Age15Size300to320countM)
        age16Size300to320M = WHERE((Age_Gro[Size300to320] EQ 16) AND (Sex_Gro[Size300to320] EQ 0), Age16Size300to320countM)
        age17Size300to320M = WHERE((Age_Gro[Size300to320] EQ 17) AND (Sex_Gro[Size300to320] EQ 0), Age17Size300to320countM)
        age18Size300to320M = WHERE((Age_Gro[Size300to320] EQ 18) AND (Sex_Gro[Size300to320] EQ 0), Age18Size300to320countM)
        age19Size300to320M = WHERE((Age_Gro[Size300to320] EQ 19) AND (Sex_Gro[Size300to320] EQ 0), Age19Size300to320countM)
        age20Size300to320M = WHERE((Age_Gro[Size300to320] EQ 20) AND (Sex_Gro[Size300to320] EQ 0), Age20Size300to320countM)
        age21Size300to320M = WHERE((Age_Gro[Size300to320] EQ 21) AND (Sex_Gro[Size300to320] EQ 0), Age21Size300to320countM)
        age22Size300to320M = WHERE((Age_Gro[Size300to320] EQ 22) AND (Sex_Gro[Size300to320] EQ 0), Age22Size300to320countM)
        age23Size300to320M = WHERE((Age_Gro[Size300to320] EQ 23) AND (Sex_Gro[Size300to320] EQ 0), Age23Size300to320countM)
        age24Size300to320M = WHERE((Age_Gro[Size300to320] EQ 24) AND (Sex_Gro[Size300to320] EQ 0), Age24Size300to320countM)
        age25Size300to320M = WHERE((Age_Gro[Size300to320] EQ 25) AND (Sex_Gro[Size300to320] EQ 0), Age25Size300to320countM)
        age26Size300to320M = WHERE((Age_Gro[Size300to320] EQ 26) AND (Sex_Gro[Size300to320] EQ 0), Age26Size300to320countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+11L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+11L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+11L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+11L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+11L] = 300
        WAE_length_bin[42, i*NumLengthBin+adj+11L] = Size300to320countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+11L] = Age0Size300to320countM
        WAE_length_bin[44, i*NumLengthBin+adj+11L] = Age1Size300to320countM
        WAE_length_bin[45, i*NumLengthBin+adj+11L] = Age2Size300to320countM
        WAE_length_bin[46, i*NumLengthBin+adj+11L] = Age3Size300to320countM
        WAE_length_bin[47, i*NumLengthBin+adj+11L] = Age4Size300to320countM
        WAE_length_bin[48, i*NumLengthBin+adj+11L] = Age5Size300to320countM
        WAE_length_bin[49, i*NumLengthBin+adj+11L] = Age6Size300to320countM
        WAE_length_bin[50, i*NumLengthBin+adj+11L] = Age7Size300to320countM
        WAE_length_bin[51, i*NumLengthBin+adj+11L] = Age8Size300to320countM
        WAE_length_bin[52, i*NumLengthBin+adj+11L] = Age9Size300to320countM
        WAE_length_bin[53, i*NumLengthBin+adj+11L] = Age10Size300to320countM
        WAE_length_bin[54, i*NumLengthBin+adj+11L] = Age11Size300to320countM
        WAE_length_bin[55, i*NumLengthBin+adj+11L] = Age12Size300to320countM
        WAE_length_bin[56, i*NumLengthBin+adj+11L] = Age13Size300to320countM
        WAE_length_bin[57, i*NumLengthBin+adj+11L] = Age14Size300to320countM
        WAE_length_bin[58, i*NumLengthBin+adj+11L] = Age15Size300to320countM
        WAE_length_bin[59, i*NumLengthBin+adj+11L] = Age16Size300to320countM
        WAE_length_bin[60, i*NumLengthBin+adj+11L] = Age17Size300to320countM
        WAE_length_bin[61, i*NumLengthBin+adj+11L] = Age18Size300to320countM
        WAE_length_bin[62, i*NumLengthBin+adj+11L] = Age19Size300to320countM
        WAE_length_bin[63, i*NumLengthBin+adj+11L] = Age20Size300to320countM
        WAE_length_bin[64, i*NumLengthBin+adj+11L] = Age21Size300to320countM
        WAE_length_bin[65, i*NumLengthBin+adj+11L] = Age22Size300to320countM
        WAE_length_bin[66, i*NumLengthBin+adj+11L] = Age23Size300to320countM
        WAE_length_bin[67, i*NumLengthBin+adj+11L] = Age24Size300to320countM
        WAE_length_bin[68, i*NumLengthBin+adj+11L] = Age25Size300to320countM
        WAE_length_bin[69, i*NumLengthBin+adj+11L] = Age26Size300to320countM
      ENDIF
      PRINT, 'Size300to320M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+11L])
      
      ; length bin 13
      IF Size320to340count GT 0 THEN BEGIN
        age0Size320to340M = WHERE((Age_Gro[Size320to340] EQ 0) AND (Sex_Gro[Size320to340] EQ 0), Age0Size320to340countM)
        age1Size320to340M = WHERE((Age_Gro[Size320to340] EQ 1) AND (Sex_Gro[Size320to340] EQ 0), Age1Size320to340countM)
        age2Size320to340M = WHERE((Age_Gro[Size320to340] EQ 2) AND (Sex_Gro[Size320to340] EQ 0), Age2Size320to340countM)
        age3Size320to340M = WHERE((Age_Gro[Size320to340] EQ 3) AND (Sex_Gro[Size320to340] EQ 0), Age3Size320to340countM)
        age4Size320to340M = WHERE((Age_Gro[Size320to340] EQ 4) AND (Sex_Gro[Size320to340] EQ 0), Age4Size320to340countM)
        age5Size320to340M = WHERE((Age_Gro[Size320to340] EQ 5) AND (Sex_Gro[Size320to340] EQ 0), Age5Size320to340countM)
        age6Size320to340M = WHERE((Age_Gro[Size320to340] EQ 6) AND (Sex_Gro[Size320to340] EQ 0), Age6Size320to340countM)
        age7Size320to340M = WHERE((Age_Gro[Size320to340] EQ 7) AND (Sex_Gro[Size320to340] EQ 0), Age7Size320to340countM)
        age8Size320to340M = WHERE((Age_Gro[Size320to340] EQ 8) AND (Sex_Gro[Size320to340] EQ 0), Age8Size320to340countM)
        age9Size320to340M = WHERE((Age_Gro[Size320to340] EQ 9) AND (Sex_Gro[Size320to340] EQ 0), Age9Size320to340countM)
        age10Size320to340M = WHERE((Age_Gro[Size320to340] EQ 10) AND (Sex_Gro[Size320to340] EQ 0), Age10Size320to340countM)
        age11Size320to340M = WHERE((Age_Gro[Size320to340] EQ 11) AND (Sex_Gro[Size320to340] EQ 0), Age11Size320to340countM)
        AGE12Size320to340M = WHERE((Age_Gro[Size320to340] EQ 12) AND (Sex_Gro[Size320to340] EQ 0), Age12Size320to340countM)
        AGE13Size320to340M = WHERE((Age_Gro[Size320to340] EQ 13) AND (Sex_Gro[Size320to340] EQ 0), Age13Size320to340countM)
        AGE14Size320to340M = WHERE((Age_Gro[Size320to340] EQ 14) AND (Sex_Gro[Size320to340] EQ 0), Age14Size320to340countM)
        AGE15Size320to340M = WHERE((Age_Gro[Size320to340] EQ 15) AND (Sex_Gro[Size320to340] EQ 0), Age15Size320to340countM)
        age16Size320to340M = WHERE((Age_Gro[Size320to340] EQ 16) AND (Sex_Gro[Size320to340] EQ 0), Age16Size320to340countM)
        age17Size320to340M = WHERE((Age_Gro[Size320to340] EQ 17) AND (Sex_Gro[Size320to340] EQ 0), Age17Size320to340countM)
        age18Size320to340M = WHERE((Age_Gro[Size320to340] EQ 18) AND (Sex_Gro[Size320to340] EQ 0), Age18Size320to340countM)
        age19Size320to340M = WHERE((Age_Gro[Size320to340] EQ 19) AND (Sex_Gro[Size320to340] EQ 0), Age19Size320to340countM)
        age20Size320to340M = WHERE((Age_Gro[Size320to340] EQ 20) AND (Sex_Gro[Size320to340] EQ 0), Age20Size320to340countM)
        age21Size320to340M = WHERE((Age_Gro[Size320to340] EQ 21) AND (Sex_Gro[Size320to340] EQ 0), Age21Size320to340countM)
        age22Size320to340M = WHERE((Age_Gro[Size320to340] EQ 22) AND (Sex_Gro[Size320to340] EQ 0), Age22Size320to340countM)
        age23Size320to340M = WHERE((Age_Gro[Size320to340] EQ 23) AND (Sex_Gro[Size320to340] EQ 0), Age23Size320to340countM)
        age24Size320to340M = WHERE((Age_Gro[Size320to340] EQ 24) AND (Sex_Gro[Size320to340] EQ 0), Age24Size320to340countM)
        age25Size320to340M = WHERE((Age_Gro[Size320to340] EQ 25) AND (Sex_Gro[Size320to340] EQ 0), Age25Size320to340countM)
        age26Size320to340M = WHERE((Age_Gro[Size320to340] EQ 26) AND (Sex_Gro[Size320to340] EQ 0), Age26Size320to340countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+12L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+12L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+12L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+12L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+12L] = 320
        WAE_length_bin[42, i*NumLengthBin+adj+12L] = Size320to340countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+12L] = Age0Size320to340countM
        WAE_length_bin[44, i*NumLengthBin+adj+12L] = Age1Size320to340countM
        WAE_length_bin[45, i*NumLengthBin+adj+12L] = Age2Size320to340countM
        WAE_length_bin[46, i*NumLengthBin+adj+12L] = Age3Size320to340countM
        WAE_length_bin[47, i*NumLengthBin+adj+12L] = Age4Size320to340countM
        WAE_length_bin[48, i*NumLengthBin+adj+12L] = Age5Size320to340countM
        WAE_length_bin[49, i*NumLengthBin+adj+12L] = Age6Size320to340countM
        WAE_length_bin[50, i*NumLengthBin+adj+12L] = Age7Size320to340countM
        WAE_length_bin[51, i*NumLengthBin+adj+12L] = Age8Size320to340countM
        WAE_length_bin[52, i*NumLengthBin+adj+12L] = Age9Size320to340countM
        WAE_length_bin[53, i*NumLengthBin+adj+12L] = Age10Size320to340countM
        WAE_length_bin[54, i*NumLengthBin+adj+12L] = Age11Size320to340countM
        WAE_length_bin[55, i*NumLengthBin+adj+12L] = Age12Size320to340countM
        WAE_length_bin[56, i*NumLengthBin+adj+12L] = Age13Size320to340countM
        WAE_length_bin[57, i*NumLengthBin+adj+12L] = Age14Size320to340countM
        WAE_length_bin[58, i*NumLengthBin+adj+12L] = Age15Size320to340countM
        WAE_length_bin[59, i*NumLengthBin+adj+12L] = Age16Size320to340countM
        WAE_length_bin[60, i*NumLengthBin+adj+12L] = Age17Size320to340countM
        WAE_length_bin[61, i*NumLengthBin+adj+12L] = Age18Size320to340countM
        WAE_length_bin[62, i*NumLengthBin+adj+12L] = Age19Size320to340countM
        WAE_length_bin[63, i*NumLengthBin+adj+12L] = Age20Size320to340countM
        WAE_length_bin[64, i*NumLengthBin+adj+12L] = Age21Size320to340countM
        WAE_length_bin[65, i*NumLengthBin+adj+12L] = Age22Size320to340countM
        WAE_length_bin[66, i*NumLengthBin+adj+12L] = Age23Size320to340countM
        WAE_length_bin[67, i*NumLengthBin+adj+12L] = Age24Size320to340countM
        WAE_length_bin[68, i*NumLengthBin+adj+12L] = Age25Size320to340countM
        WAE_length_bin[69, i*NumLengthBin+adj+12L] = Age26Size320to340countM
      ENDIF
      PRINT, 'Size320to340M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+12L])
      
      ; length bin 14
      IF Size340to360count GT 0 THEN BEGIN
        age0Size340to360M = WHERE((Age_Gro[Size340to360] EQ 0) AND (Sex_Gro[Size340to360] EQ 0), Age0Size340to360countM)
        age1Size340to360M = WHERE((Age_Gro[Size340to360] EQ 1) AND (Sex_Gro[Size340to360] EQ 0), Age1Size340to360countM)
        age2Size340to360M = WHERE((Age_Gro[Size340to360] EQ 2) AND (Sex_Gro[Size340to360] EQ 0), Age2Size340to360countM)
        age3Size340to360M = WHERE((Age_Gro[Size340to360] EQ 3) AND (Sex_Gro[Size340to360] EQ 0), Age3Size340to360countM)
        age4Size340to360M = WHERE((Age_Gro[Size340to360] EQ 4) AND (Sex_Gro[Size340to360] EQ 0), Age4Size340to360countM)
        age5Size340to360M = WHERE((Age_Gro[Size340to360] EQ 5) AND (Sex_Gro[Size340to360] EQ 0), Age5Size340to360countM)
        age6Size340to360M = WHERE((Age_Gro[Size340to360] EQ 6) AND (Sex_Gro[Size340to360] EQ 0), Age6Size340to360countM)
        age7Size340to360M = WHERE((Age_Gro[Size340to360] EQ 7) AND (Sex_Gro[Size340to360] EQ 0), Age7Size340to360countM)
        age8Size340to360M = WHERE((Age_Gro[Size340to360] EQ 8) AND (Sex_Gro[Size340to360] EQ 0), Age8Size340to360countM)
        age9Size340to360M = WHERE((Age_Gro[Size340to360] EQ 9) AND (Sex_Gro[Size340to360] EQ 0), Age9Size340to360countM)
        age10Size340to360M = WHERE((Age_Gro[Size340to360] EQ 10) AND (Sex_Gro[Size340to360] EQ 0), Age10Size340to360countM)
        age11Size340to360M = WHERE((Age_Gro[Size340to360] EQ 11) AND (Sex_Gro[Size340to360] EQ 0), Age11Size340to360countM)
        AGE12Size340to360M = WHERE((Age_Gro[Size340to360] EQ 12) AND (Sex_Gro[Size340to360] EQ 0), Age12Size340to360countM)
        AGE13Size340to360M = WHERE((Age_Gro[Size340to360] EQ 13) AND (Sex_Gro[Size340to360] EQ 0), Age13Size340to360countM)
        AGE14Size340to360M = WHERE((Age_Gro[Size340to360] EQ 14) AND (Sex_Gro[Size340to360] EQ 0), Age14Size340to360countM)
        AGE15Size340to360M = WHERE((Age_Gro[Size340to360] EQ 15) AND (Sex_Gro[Size340to360] EQ 0), Age15Size340to360countM)
        age16Size340to360M = WHERE((Age_Gro[Size340to360] EQ 16) AND (Sex_Gro[Size340to360] EQ 0), Age16Size340to360countM)
        age17Size340to360M = WHERE((Age_Gro[Size340to360] EQ 17) AND (Sex_Gro[Size340to360] EQ 0), Age17Size340to360countM)
        age18Size340to360M = WHERE((Age_Gro[Size340to360] EQ 18) AND (Sex_Gro[Size340to360] EQ 0), Age18Size340to360countM)
        age19Size340to360M = WHERE((Age_Gro[Size340to360] EQ 19) AND (Sex_Gro[Size340to360] EQ 0), Age19Size340to360countM)
        age20Size340to360M = WHERE((Age_Gro[Size340to360] EQ 20) AND (Sex_Gro[Size340to360] EQ 0), Age20Size340to360countM)
        age21Size340to360M = WHERE((Age_Gro[Size340to360] EQ 21) AND (Sex_Gro[Size340to360] EQ 0), Age21Size340to360countM)
        age22Size340to360M = WHERE((Age_Gro[Size340to360] EQ 22) AND (Sex_Gro[Size340to360] EQ 0), Age22Size340to360countM)
        age23Size340to360M = WHERE((Age_Gro[Size340to360] EQ 23) AND (Sex_Gro[Size340to360] EQ 0), Age23Size340to360countM)
        age24Size340to360M = WHERE((Age_Gro[Size340to360] EQ 24) AND (Sex_Gro[Size340to360] EQ 0), Age24Size340to360countM)
        age25Size340to360M = WHERE((Age_Gro[Size340to360] EQ 25) AND (Sex_Gro[Size340to360] EQ 0), Age25Size340to360countM)
        age26Size340to360M = WHERE((Age_Gro[Size340to360] EQ 26) AND (Sex_Gro[Size340to360] EQ 0), Age26Size340to360countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+13L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+13L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+13L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+13L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+13L] = 340
        WAE_length_bin[42, i*NumLengthBin+adj+13L] = Size340to360countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+13L] = Age0Size340to360countM
        WAE_length_bin[44, i*NumLengthBin+adj+13L] = Age1Size340to360countM
        WAE_length_bin[45, i*NumLengthBin+adj+13L] = Age2Size340to360countM
        WAE_length_bin[46, i*NumLengthBin+adj+13L] = Age3Size340to360countM
        WAE_length_bin[47, i*NumLengthBin+adj+13L] = Age4Size340to360countM
        WAE_length_bin[48, i*NumLengthBin+adj+13L] = Age5Size340to360countM
        WAE_length_bin[49, i*NumLengthBin+adj+13L] = Age6Size340to360countM
        WAE_length_bin[50, i*NumLengthBin+adj+13L] = Age7Size340to360countM
        WAE_length_bin[51, i*NumLengthBin+adj+13L] = Age8Size340to360countM
        WAE_length_bin[52, i*NumLengthBin+adj+13L] = Age9Size340to360countM
        WAE_length_bin[53, i*NumLengthBin+adj+13L] = Age10Size340to360countM
        WAE_length_bin[54, i*NumLengthBin+adj+13L] = Age11Size340to360countM
        WAE_length_bin[55, i*NumLengthBin+adj+13L] = Age12Size340to360countM
        WAE_length_bin[56, i*NumLengthBin+adj+13L] = Age13Size340to360countM
        WAE_length_bin[57, i*NumLengthBin+adj+13L] = Age14Size340to360countM
        WAE_length_bin[58, i*NumLengthBin+adj+13L] = Age15Size340to360countM
        WAE_length_bin[59, i*NumLengthBin+adj+13L] = Age16Size340to360countM
        WAE_length_bin[60, i*NumLengthBin+adj+13L] = Age17Size340to360countM
        WAE_length_bin[61, i*NumLengthBin+adj+13L] = Age18Size340to360countM
        WAE_length_bin[62, i*NumLengthBin+adj+13L] = Age19Size340to360countM
        WAE_length_bin[63, i*NumLengthBin+adj+13L] = Age20Size340to360countM
        WAE_length_bin[64, i*NumLengthBin+adj+13L] = Age21Size340to360countM
        WAE_length_bin[65, i*NumLengthBin+adj+13L] = Age22Size340to360countM
        WAE_length_bin[66, i*NumLengthBin+adj+13L] = Age23Size340to360countM
        WAE_length_bin[67, i*NumLengthBin+adj+13L] = Age24Size340to360countM
        WAE_length_bin[68, i*NumLengthBin+adj+13L] = Age25Size340to360countM
        WAE_length_bin[69, i*NumLengthBin+adj+13L] = Age26Size340to360countM
      ENDIF
      PRINT, 'Size340to360M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+13L])
      
      ; length bin 15
      IF Size360to380count GT 0 THEN BEGIN
        age0Size360to380M = WHERE((Age_Gro[Size360to380] EQ 0) AND (Sex_Gro[Size360to380] EQ 0), Age0Size360to380countM)
        age1Size360to380M = WHERE((Age_Gro[Size360to380] EQ 1) AND (Sex_Gro[Size360to380] EQ 0), Age1Size360to380countM)
        age2Size360to380M = WHERE((Age_Gro[Size360to380] EQ 2) AND (Sex_Gro[Size360to380] EQ 0), Age2Size360to380countM)
        age3Size360to380M = WHERE((Age_Gro[Size360to380] EQ 3) AND (Sex_Gro[Size360to380] EQ 0), Age3Size360to380countM)
        age4Size360to380M = WHERE((Age_Gro[Size360to380] EQ 4) AND (Sex_Gro[Size360to380] EQ 0), Age4Size360to380countM)
        age5Size360to380M = WHERE((Age_Gro[Size360to380] EQ 5) AND (Sex_Gro[Size360to380] EQ 0), Age5Size360to380countM)
        age6Size360to380M = WHERE((Age_Gro[Size360to380] EQ 6) AND (Sex_Gro[Size360to380] EQ 0), Age6Size360to380countM)
        age7Size360to380M = WHERE((Age_Gro[Size360to380] EQ 7) AND (Sex_Gro[Size360to380] EQ 0), Age7Size360to380countM)
        age8Size360to380M = WHERE((Age_Gro[Size360to380] EQ 8) AND (Sex_Gro[Size360to380] EQ 0), Age8Size360to380countM)
        age9Size360to380M = WHERE((Age_Gro[Size360to380] EQ 9) AND (Sex_Gro[Size360to380] EQ 0), Age9Size360to380countM)
        age10Size360to380M = WHERE((Age_Gro[Size360to380] EQ 10) AND (Sex_Gro[Size360to380] EQ 0), Age10Size360to380countM)
        age11Size360to380M = WHERE((Age_Gro[Size360to380] EQ 11) AND (Sex_Gro[Size360to380] EQ 0), Age11Size360to380countM)
        AGE12Size360to380M = WHERE((Age_Gro[Size360to380] EQ 12) AND (Sex_Gro[Size360to380] EQ 0), Age12Size360to380countM)
        AGE13Size360to380M = WHERE((Age_Gro[Size360to380] EQ 13) AND (Sex_Gro[Size360to380] EQ 0), Age13Size360to380countM)
        AGE14Size360to380M = WHERE((Age_Gro[Size360to380] EQ 14) AND (Sex_Gro[Size360to380] EQ 0), Age14Size360to380countM)
        AGE15Size360to380M = WHERE((Age_Gro[Size360to380] EQ 15) AND (Sex_Gro[Size360to380] EQ 0), Age15Size360to380countM)
        age16Size360to380M = WHERE((Age_Gro[Size360to380] EQ 16) AND (Sex_Gro[Size360to380] EQ 0), Age16Size360to380countM)
        age17Size360to380M = WHERE((Age_Gro[Size360to380] EQ 17) AND (Sex_Gro[Size360to380] EQ 0), Age17Size360to380countM)
        age18Size360to380M = WHERE((Age_Gro[Size360to380] EQ 18) AND (Sex_Gro[Size360to380] EQ 0), Age18Size360to380countM)
        age19Size360to380M = WHERE((Age_Gro[Size360to380] EQ 19) AND (Sex_Gro[Size360to380] EQ 0), Age19Size360to380countM)
        age20Size360to380M = WHERE((Age_Gro[Size360to380] EQ 20) AND (Sex_Gro[Size360to380] EQ 0), Age20Size360to380countM)
        age21Size360to380M = WHERE((Age_Gro[Size360to380] EQ 21) AND (Sex_Gro[Size360to380] EQ 0), Age21Size360to380countM)
        age22Size360to380M = WHERE((Age_Gro[Size360to380] EQ 22) AND (Sex_Gro[Size360to380] EQ 0), Age22Size360to380countM)
        age23Size360to380M = WHERE((Age_Gro[Size360to380] EQ 23) AND (Sex_Gro[Size360to380] EQ 0), Age23Size360to380countM)
        age24Size360to380M = WHERE((Age_Gro[Size360to380] EQ 24) AND (Sex_Gro[Size360to380] EQ 0), Age24Size360to380countM)
        age25Size360to380M = WHERE((Age_Gro[Size360to380] EQ 25) AND (Sex_Gro[Size360to380] EQ 0), Age25Size360to380countM)
        age26Size360to380M = WHERE((Age_Gro[Size360to380] EQ 26) AND (Sex_Gro[Size360to380] EQ 0), Age26Size360to380countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+14L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+14L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+14L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+14L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+14L] = 360
        WAE_length_bin[42, i*NumLengthBin+adj+14L] = Size360to380countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+14L] = Age0Size360to380countM
        WAE_length_bin[44, i*NumLengthBin+adj+14L] = Age1Size360to380countM
        WAE_length_bin[45, i*NumLengthBin+adj+14L] = Age2Size360to380countM
        WAE_length_bin[46, i*NumLengthBin+adj+14L] = Age3Size360to380countM
        WAE_length_bin[47, i*NumLengthBin+adj+14L] = Age4Size360to380countM
        WAE_length_bin[48, i*NumLengthBin+adj+14L] = Age5Size360to380countM
        WAE_length_bin[49, i*NumLengthBin+adj+14L] = Age6Size360to380countM
        WAE_length_bin[50, i*NumLengthBin+adj+14L] = Age7Size360to380countM
        WAE_length_bin[51, i*NumLengthBin+adj+14L] = Age8Size360to380countM
        WAE_length_bin[52, i*NumLengthBin+adj+14L] = Age9Size360to380countM
        WAE_length_bin[53, i*NumLengthBin+adj+14L] = Age10Size360to380countM
        WAE_length_bin[54, i*NumLengthBin+adj+14L] = Age11Size360to380countM
        WAE_length_bin[55, i*NumLengthBin+adj+14L] = Age12Size360to380countM
        WAE_length_bin[56, i*NumLengthBin+adj+14L] = Age13Size360to380countM
        WAE_length_bin[57, i*NumLengthBin+adj+14L] = Age14Size360to380countM
        WAE_length_bin[58, i*NumLengthBin+adj+14L] = Age15Size360to380countM
        WAE_length_bin[59, i*NumLengthBin+adj+14L] = Age16Size360to380countM
        WAE_length_bin[60, i*NumLengthBin+adj+14L] = Age17Size360to380countM
        WAE_length_bin[61, i*NumLengthBin+adj+14L] = Age18Size360to380countM
        WAE_length_bin[62, i*NumLengthBin+adj+14L] = Age19Size360to380countM
        WAE_length_bin[63, i*NumLengthBin+adj+14L] = Age20Size360to380countM
        WAE_length_bin[64, i*NumLengthBin+adj+14L] = Age21Size360to380countM
        WAE_length_bin[65, i*NumLengthBin+adj+14L] = Age22Size360to380countM
        WAE_length_bin[66, i*NumLengthBin+adj+14L] = Age23Size360to380countM
        WAE_length_bin[67, i*NumLengthBin+adj+14L] = Age24Size360to380countM
        WAE_length_bin[68, i*NumLengthBin+adj+14L] = Age25Size360to380countM
        WAE_length_bin[69, i*NumLengthBin+adj+14L] = Age26Size360to380countM
      ENDIF
      PRINT, 'Size360to380M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+14L])
      
      ; length bin 16
      IF Size380to400count GT 0 THEN BEGIN
        age0Size380to400M = WHERE((Age_Gro[Size380to400] EQ 0) AND (Sex_Gro[Size380to400] EQ 0), Age0Size380to400countM)
        age1Size380to400M = WHERE((Age_Gro[Size380to400] EQ 1) AND (Sex_Gro[Size380to400] EQ 0), Age1Size380to400countM)
        age2Size380to400M = WHERE((Age_Gro[Size380to400] EQ 2) AND (Sex_Gro[Size380to400] EQ 0), Age2Size380to400countM)
        age3Size380to400M = WHERE((Age_Gro[Size380to400] EQ 3) AND (Sex_Gro[Size380to400] EQ 0), Age3Size380to400countM)
        age4Size380to400M = WHERE((Age_Gro[Size380to400] EQ 4) AND (Sex_Gro[Size380to400] EQ 0), Age4Size380to400countM)
        age5Size380to400M = WHERE((Age_Gro[Size380to400] EQ 5) AND (Sex_Gro[Size380to400] EQ 0), Age5Size380to400countM)
        age6Size380to400M = WHERE((Age_Gro[Size380to400] EQ 6) AND (Sex_Gro[Size380to400] EQ 0), Age6Size380to400countM)
        age7Size380to400M = WHERE((Age_Gro[Size380to400] EQ 7) AND (Sex_Gro[Size380to400] EQ 0), Age7Size380to400countM)
        age8Size380to400M = WHERE((Age_Gro[Size380to400] EQ 8) AND (Sex_Gro[Size380to400] EQ 0), Age8Size380to400countM)
        age9Size380to400M = WHERE((Age_Gro[Size380to400] EQ 9) AND (Sex_Gro[Size380to400] EQ 0), Age9Size380to400countM)
        age10Size380to400M = WHERE((Age_Gro[Size380to400] EQ 10) AND (Sex_Gro[Size380to400] EQ 0), Age10Size380to400countM)
        age11Size380to400M = WHERE((Age_Gro[Size380to400] EQ 11) AND (Sex_Gro[Size380to400] EQ 0), Age11Size380to400countM)
        AGE12Size380to400M = WHERE((Age_Gro[Size380to400] EQ 12) AND (Sex_Gro[Size380to400] EQ 0), Age12Size380to400countM)
        AGE13Size380to400M = WHERE((Age_Gro[Size380to400] EQ 13) AND (Sex_Gro[Size380to400] EQ 0), Age13Size380to400countM)
        AGE14Size380to400M = WHERE((Age_Gro[Size380to400] EQ 14) AND (Sex_Gro[Size380to400] EQ 0), Age14Size380to400countM)
        AGE15Size380to400M = WHERE((Age_Gro[Size380to400] EQ 15) AND (Sex_Gro[Size380to400] EQ 0), Age15Size380to400countM)
        age16Size380to400M = WHERE((Age_Gro[Size380to400] EQ 16) AND (Sex_Gro[Size380to400] EQ 0), Age16Size380to400countM)
        age17Size380to400M = WHERE((Age_Gro[Size380to400] EQ 17) AND (Sex_Gro[Size380to400] EQ 0), Age17Size380to400countM)
        age18Size380to400M = WHERE((Age_Gro[Size380to400] EQ 18) AND (Sex_Gro[Size380to400] EQ 0), Age18Size380to400countM)
        age19Size380to400M = WHERE((Age_Gro[Size380to400] EQ 19) AND (Sex_Gro[Size380to400] EQ 0), Age19Size380to400countM)
        age20Size380to400M = WHERE((Age_Gro[Size380to400] EQ 20) AND (Sex_Gro[Size380to400] EQ 0), Age20Size380to400countM)
        age21Size380to400M = WHERE((Age_Gro[Size380to400] EQ 21) AND (Sex_Gro[Size380to400] EQ 0), Age21Size380to400countM)
        age22Size380to400M = WHERE((Age_Gro[Size380to400] EQ 22) AND (Sex_Gro[Size380to400] EQ 0), Age22Size380to400countM)
        age23Size380to400M = WHERE((Age_Gro[Size380to400] EQ 23) AND (Sex_Gro[Size380to400] EQ 0), Age23Size380to400countM)
        age24Size380to400M = WHERE((Age_Gro[Size380to400] EQ 24) AND (Sex_Gro[Size380to400] EQ 0), Age24Size380to400countM)
        age25Size380to400M = WHERE((Age_Gro[Size380to400] EQ 25) AND (Sex_Gro[Size380to400] EQ 0), Age25Size380to400countM)
        age26Size380to400M = WHERE((Age_Gro[Size380to400] EQ 26) AND (Sex_Gro[Size380to400] EQ 0), Age26Size380to400countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+15L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+15L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+15L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+15L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+15L] = 380
        WAE_length_bin[42, i*NumLengthBin+adj+15L] = Size380to400countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+15L] = Age0Size380to400countM
        WAE_length_bin[44, i*NumLengthBin+adj+15L] = Age1Size380to400countM
        WAE_length_bin[45, i*NumLengthBin+adj+15L] = Age2Size380to400countM
        WAE_length_bin[46, i*NumLengthBin+adj+15L] = Age3Size380to400countM
        WAE_length_bin[47, i*NumLengthBin+adj+15L] = Age4Size380to400countM
        WAE_length_bin[48, i*NumLengthBin+adj+15L] = Age5Size380to400countM
        WAE_length_bin[49, i*NumLengthBin+adj+15L] = Age6Size380to400countM
        WAE_length_bin[50, i*NumLengthBin+adj+15L] = Age7Size380to400countM
        WAE_length_bin[51, i*NumLengthBin+adj+15L] = Age8Size380to400countM
        WAE_length_bin[52, i*NumLengthBin+adj+15L] = Age9Size380to400countM
        WAE_length_bin[53, i*NumLengthBin+adj+15L] = Age10Size380to400countM
        WAE_length_bin[54, i*NumLengthBin+adj+15L] = Age11Size380to400countM
        WAE_length_bin[55, i*NumLengthBin+adj+15L] = Age12Size380to400countM
        WAE_length_bin[56, i*NumLengthBin+adj+15L] = Age13Size380to400countM
        WAE_length_bin[57, i*NumLengthBin+adj+15L] = Age14Size380to400countM
        WAE_length_bin[58, i*NumLengthBin+adj+15L] = Age15Size380to400countM
        WAE_length_bin[59, i*NumLengthBin+adj+15L] = Age16Size380to400countM
        WAE_length_bin[60, i*NumLengthBin+adj+15L] = Age17Size380to400countM
        WAE_length_bin[61, i*NumLengthBin+adj+15L] = Age18Size380to400countM
        WAE_length_bin[62, i*NumLengthBin+adj+15L] = Age19Size380to400countM
        WAE_length_bin[63, i*NumLengthBin+adj+15L] = Age20Size380to400countM
        WAE_length_bin[64, i*NumLengthBin+adj+15L] = Age21Size380to400countM
        WAE_length_bin[65, i*NumLengthBin+adj+15L] = Age22Size380to400countM
        WAE_length_bin[66, i*NumLengthBin+adj+15L] = Age23Size380to400countM
        WAE_length_bin[67, i*NumLengthBin+adj+15L] = Age24Size380to400countM
        WAE_length_bin[68, i*NumLengthBin+adj+15L] = Age25Size380to400countM
        WAE_length_bin[69, i*NumLengthBin+adj+15L] = Age26Size380to400countM
      ENDIF
      PRINT, 'Size380to400M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+15L])
      
      ; length bin 17
      IF Size400to420count GT 0 THEN BEGIN
        age0Size400to420M = WHERE((Age_Gro[Size400to420] EQ 0) AND (Sex_Gro[Size400to420] EQ 0), Age0Size400to420countM)
        age1Size400to420M = WHERE((Age_Gro[Size400to420] EQ 1) AND (Sex_Gro[Size400to420] EQ 0), Age1Size400to420countM)
        age2Size400to420M = WHERE((Age_Gro[Size400to420] EQ 2) AND (Sex_Gro[Size400to420] EQ 0), Age2Size400to420countM)
        age3Size400to420M = WHERE((Age_Gro[Size400to420] EQ 3) AND (Sex_Gro[Size400to420] EQ 0), Age3Size400to420countM)
        age4Size400to420M = WHERE((Age_Gro[Size400to420] EQ 4) AND (Sex_Gro[Size400to420] EQ 0), Age4Size400to420countM)
        age5Size400to420M = WHERE((Age_Gro[Size400to420] EQ 5) AND (Sex_Gro[Size400to420] EQ 0), Age5Size400to420countM)
        age6Size400to420M = WHERE((Age_Gro[Size400to420] EQ 6) AND (Sex_Gro[Size400to420] EQ 0), Age6Size400to420countM)
        age7Size400to420M = WHERE((Age_Gro[Size400to420] EQ 7) AND (Sex_Gro[Size400to420] EQ 0), Age7Size400to420countM)
        age8Size400to420M = WHERE((Age_Gro[Size400to420] EQ 8) AND (Sex_Gro[Size400to420] EQ 0), Age8Size400to420countM)
        age9Size400to420M = WHERE((Age_Gro[Size400to420] EQ 9) AND (Sex_Gro[Size400to420] EQ 0), Age9Size400to420countM)
        age10Size400to420M = WHERE((Age_Gro[Size400to420] EQ 10) AND (Sex_Gro[Size400to420] EQ 0), Age10Size400to420countM)
        age11Size400to420M = WHERE((Age_Gro[Size400to420] EQ 11) AND (Sex_Gro[Size400to420] EQ 0), Age11Size400to420countM)
        AGE12Size400to420M = WHERE((Age_Gro[Size400to420] EQ 12) AND (Sex_Gro[Size400to420] EQ 0), Age12Size400to420countM)
        AGE13Size400to420M = WHERE((Age_Gro[Size400to420] EQ 13) AND (Sex_Gro[Size400to420] EQ 0), Age13Size400to420countM)
        AGE14Size400to420M = WHERE((Age_Gro[Size400to420] EQ 14) AND (Sex_Gro[Size400to420] EQ 0), Age14Size400to420countM)
        AGE15Size400to420M = WHERE((Age_Gro[Size400to420] EQ 15) AND (Sex_Gro[Size400to420] EQ 0), Age15Size400to420countM)
        age16Size400to420M = WHERE((Age_Gro[Size400to420] EQ 16) AND (Sex_Gro[Size400to420] EQ 0), Age16Size400to420countM)
        age17Size400to420M = WHERE((Age_Gro[Size400to420] EQ 17) AND (Sex_Gro[Size400to420] EQ 0), Age17Size400to420countM)
        age18Size400to420M = WHERE((Age_Gro[Size400to420] EQ 18) AND (Sex_Gro[Size400to420] EQ 0), Age18Size400to420countM)
        age19Size400to420M = WHERE((Age_Gro[Size400to420] EQ 19) AND (Sex_Gro[Size400to420] EQ 0), Age19Size400to420countM)
        age20Size400to420M = WHERE((Age_Gro[Size400to420] EQ 20) AND (Sex_Gro[Size400to420] EQ 0), Age20Size400to420countM)
        age21Size400to420M = WHERE((Age_Gro[Size400to420] EQ 21) AND (Sex_Gro[Size400to420] EQ 0), Age21Size400to420countM)
        age22Size400to420M = WHERE((Age_Gro[Size400to420] EQ 22) AND (Sex_Gro[Size400to420] EQ 0), Age22Size400to420countM)
        age23Size400to420M = WHERE((Age_Gro[Size400to420] EQ 23) AND (Sex_Gro[Size400to420] EQ 0), Age23Size400to420countM)
        age24Size400to420M = WHERE((Age_Gro[Size400to420] EQ 24) AND (Sex_Gro[Size400to420] EQ 0), Age24Size400to420countM)
        age25Size400to420M = WHERE((Age_Gro[Size400to420] EQ 25) AND (Sex_Gro[Size400to420] EQ 0), Age25Size400to420countM)
        age26Size400to420M = WHERE((Age_Gro[Size400to420] EQ 26) AND (Sex_Gro[Size400to420] EQ 0), Age26Size400to420countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+16L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+16L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+16L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+16L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+16L] = 400
        WAE_length_bin[42, i*NumLengthBin+adj+16L] = Size400to420countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+16L] = Age0Size400to420countM
        WAE_length_bin[44, i*NumLengthBin+adj+16L] = Age1Size400to420countM
        WAE_length_bin[45, i*NumLengthBin+adj+16L] = Age2Size400to420countM
        WAE_length_bin[46, i*NumLengthBin+adj+16L] = Age3Size400to420countM
        WAE_length_bin[47, i*NumLengthBin+adj+16L] = Age4Size400to420countM
        WAE_length_bin[48, i*NumLengthBin+adj+16L] = Age5Size400to420countM
        WAE_length_bin[49, i*NumLengthBin+adj+16L] = Age6Size400to420countM
        WAE_length_bin[50, i*NumLengthBin+adj+16L] = Age7Size400to420countM
        WAE_length_bin[51, i*NumLengthBin+adj+16L] = Age8Size400to420countM
        WAE_length_bin[52, i*NumLengthBin+adj+16L] = Age9Size400to420countM
        WAE_length_bin[53, i*NumLengthBin+adj+16L] = Age10Size400to420countM
        WAE_length_bin[54, i*NumLengthBin+adj+16L] = Age11Size400to420countM
        WAE_length_bin[55, i*NumLengthBin+adj+16L] = Age12Size400to420countM
        WAE_length_bin[56, i*NumLengthBin+adj+16L] = Age13Size400to420countM
        WAE_length_bin[57, i*NumLengthBin+adj+16L] = Age14Size400to420countM
        WAE_length_bin[58, i*NumLengthBin+adj+16L] = Age15Size400to420countM
        WAE_length_bin[59, i*NumLengthBin+adj+16L] = Age16Size400to420countM
        WAE_length_bin[60, i*NumLengthBin+adj+16L] = Age17Size400to420countM
        WAE_length_bin[61, i*NumLengthBin+adj+16L] = Age18Size400to420countM
        WAE_length_bin[62, i*NumLengthBin+adj+16L] = Age19Size400to420countM
        WAE_length_bin[63, i*NumLengthBin+adj+16L] = Age20Size400to420countM
        WAE_length_bin[64, i*NumLengthBin+adj+16L] = Age21Size400to420countM
        WAE_length_bin[65, i*NumLengthBin+adj+16L] = Age22Size400to420countM
        WAE_length_bin[66, i*NumLengthBin+adj+16L] = Age23Size400to420countM
        WAE_length_bin[67, i*NumLengthBin+adj+16L] = Age24Size400to420countM
        WAE_length_bin[68, i*NumLengthBin+adj+16L] = Age25Size400to420countM
        WAE_length_bin[69, i*NumLengthBin+adj+16L] = Age26Size400to420countM
      ENDIF
      PRINT, 'Size400to420M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+16L])
      
      ; length bin 18
      IF Size420to440count GT 0 THEN BEGIN
        age0Size420to440M = WHERE((Age_Gro[Size420to440] EQ 0) AND (Sex_Gro[Size420to440] EQ 0), Age0Size420to440countM)
        age1Size420to440M = WHERE((Age_Gro[Size420to440] EQ 1) AND (Sex_Gro[Size420to440] EQ 0), Age1Size420to440countM)
        age2Size420to440M = WHERE((Age_Gro[Size420to440] EQ 2) AND (Sex_Gro[Size420to440] EQ 0), Age2Size420to440countM)
        age3Size420to440M = WHERE((Age_Gro[Size420to440] EQ 3) AND (Sex_Gro[Size420to440] EQ 0), Age3Size420to440countM)
        age4Size420to440M = WHERE((Age_Gro[Size420to440] EQ 4) AND (Sex_Gro[Size420to440] EQ 0), Age4Size420to440countM)
        age5Size420to440M = WHERE((Age_Gro[Size420to440] EQ 5) AND (Sex_Gro[Size420to440] EQ 0), Age5Size420to440countM)
        age6Size420to440M = WHERE((Age_Gro[Size420to440] EQ 6) AND (Sex_Gro[Size420to440] EQ 0), Age6Size420to440countM)
        age7Size420to440M = WHERE((Age_Gro[Size420to440] EQ 7) AND (Sex_Gro[Size420to440] EQ 0), Age7Size420to440countM)
        age8Size420to440M = WHERE((Age_Gro[Size420to440] EQ 8) AND (Sex_Gro[Size420to440] EQ 0), Age8Size420to440countM)
        age9Size420to440M = WHERE((Age_Gro[Size420to440] EQ 9) AND (Sex_Gro[Size420to440] EQ 0), Age9Size420to440countM)
        age10Size420to440M = WHERE((Age_Gro[Size420to440] EQ 10) AND (Sex_Gro[Size420to440] EQ 0), Age10Size420to440countM)
        age11Size420to440M = WHERE((Age_Gro[Size420to440] EQ 11) AND (Sex_Gro[Size420to440] EQ 0), Age11Size420to440countM)
        AGE12Size420to440M = WHERE((Age_Gro[Size420to440] EQ 12) AND (Sex_Gro[Size420to440] EQ 0), Age12Size420to440countM)
        AGE13Size420to440M = WHERE((Age_Gro[Size420to440] EQ 13) AND (Sex_Gro[Size420to440] EQ 0), Age13Size420to440countM)
        AGE14Size420to440M = WHERE((Age_Gro[Size420to440] EQ 14) AND (Sex_Gro[Size420to440] EQ 0), Age14Size420to440countM)
        AGE15Size420to440M = WHERE((Age_Gro[Size420to440] EQ 15) AND (Sex_Gro[Size420to440] EQ 0), Age15Size420to440countM)
        age16Size420to440M = WHERE((Age_Gro[Size420to440] EQ 16) AND (Sex_Gro[Size420to440] EQ 0), Age16Size420to440countM)
        age17Size420to440M = WHERE((Age_Gro[Size420to440] EQ 17) AND (Sex_Gro[Size420to440] EQ 0), Age17Size420to440countM)
        age18Size420to440M = WHERE((Age_Gro[Size420to440] EQ 18) AND (Sex_Gro[Size420to440] EQ 0), Age18Size420to440countM)
        age19Size420to440M = WHERE((Age_Gro[Size420to440] EQ 19) AND (Sex_Gro[Size420to440] EQ 0), Age19Size420to440countM)
        age20Size420to440M = WHERE((Age_Gro[Size420to440] EQ 20) AND (Sex_Gro[Size420to440] EQ 0), Age20Size420to440countM)
        age21Size420to440M = WHERE((Age_Gro[Size420to440] EQ 21) AND (Sex_Gro[Size420to440] EQ 0), Age21Size420to440countM)
        age22Size420to440M = WHERE((Age_Gro[Size420to440] EQ 22) AND (Sex_Gro[Size420to440] EQ 0), Age22Size420to440countM)
        age23Size420to440M = WHERE((Age_Gro[Size420to440] EQ 23) AND (Sex_Gro[Size420to440] EQ 0), Age23Size420to440countM)
        age24Size420to440M = WHERE((Age_Gro[Size420to440] EQ 24) AND (Sex_Gro[Size420to440] EQ 0), Age24Size420to440countM)
        age25Size420to440M = WHERE((Age_Gro[Size420to440] EQ 25) AND (Sex_Gro[Size420to440] EQ 0), Age25Size420to440countM)
        age26Size420to440M = WHERE((Age_Gro[Size420to440] EQ 26) AND (Sex_Gro[Size420to440] EQ 0), Age26Size420to440countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+17L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+17L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+17L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+17L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+17L] = 420
        WAE_length_bin[42, i*NumLengthBin+adj+17L] = Size420to440countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+17L] = Age0Size420to440countM
        WAE_length_bin[44, i*NumLengthBin+adj+17L] = Age1Size420to440countM
        WAE_length_bin[45, i*NumLengthBin+adj+17L] = Age2Size420to440countM
        WAE_length_bin[46, i*NumLengthBin+adj+17L] = Age3Size420to440countM
        WAE_length_bin[47, i*NumLengthBin+adj+17L] = Age4Size420to440countM
        WAE_length_bin[48, i*NumLengthBin+adj+17L] = Age5Size420to440countM
        WAE_length_bin[49, i*NumLengthBin+adj+17L] = Age6Size420to440countM
        WAE_length_bin[50, i*NumLengthBin+adj+17L] = Age7Size420to440countM
        WAE_length_bin[51, i*NumLengthBin+adj+17L] = Age8Size420to440countM
        WAE_length_bin[52, i*NumLengthBin+adj+17L] = Age9Size420to440countM
        WAE_length_bin[53, i*NumLengthBin+adj+17L] = Age10Size420to440countM
        WAE_length_bin[54, i*NumLengthBin+adj+17L] = Age11Size420to440countM
        WAE_length_bin[55, i*NumLengthBin+adj+17L] = Age12Size420to440countM
        WAE_length_bin[56, i*NumLengthBin+adj+17L] = Age13Size420to440countM
        WAE_length_bin[57, i*NumLengthBin+adj+17L] = Age14Size420to440countM
        WAE_length_bin[58, i*NumLengthBin+adj+17L] = Age15Size420to440countM
        WAE_length_bin[59, i*NumLengthBin+adj+17L] = Age16Size420to440countM
        WAE_length_bin[60, i*NumLengthBin+adj+17L] = Age17Size420to440countM
        WAE_length_bin[61, i*NumLengthBin+adj+17L] = Age18Size420to440countM
        WAE_length_bin[62, i*NumLengthBin+adj+17L] = Age19Size420to440countM
        WAE_length_bin[63, i*NumLengthBin+adj+17L] = Age20Size420to440countM
        WAE_length_bin[64, i*NumLengthBin+adj+17L] = Age21Size420to440countM
        WAE_length_bin[65, i*NumLengthBin+adj+17L] = Age22Size420to440countM
        WAE_length_bin[66, i*NumLengthBin+adj+17L] = Age23Size420to440countM
        WAE_length_bin[67, i*NumLengthBin+adj+17L] = Age24Size420to440countM
        WAE_length_bin[68, i*NumLengthBin+adj+17L] = Age25Size420to440countM
        WAE_length_bin[69, i*NumLengthBin+adj+17L] = Age26Size420to440countM
      ENDIF
      PRINT, 'Size420to440M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+17L])
      
      ; length bin 19
      IF Size440to460count GT 0 THEN BEGIN
        age0Size440to460M = WHERE((Age_Gro[Size440to460] EQ 0) AND (Sex_Gro[Size440to460] EQ 0), Age0Size440to460countM)
        age1Size440to460M = WHERE((Age_Gro[Size440to460] EQ 1) AND (Sex_Gro[Size440to460] EQ 0), Age1Size440to460countM)
        age2Size440to460M = WHERE((Age_Gro[Size440to460] EQ 2) AND (Sex_Gro[Size440to460] EQ 0), Age2Size440to460countM)
        age3Size440to460M = WHERE((Age_Gro[Size440to460] EQ 3) AND (Sex_Gro[Size440to460] EQ 0), Age3Size440to460countM)
        age4Size440to460M = WHERE((Age_Gro[Size440to460] EQ 4) AND (Sex_Gro[Size440to460] EQ 0), Age4Size440to460countM)
        age5Size440to460M = WHERE((Age_Gro[Size440to460] EQ 5) AND (Sex_Gro[Size440to460] EQ 0), Age5Size440to460countM)
        age6Size440to460M = WHERE((Age_Gro[Size440to460] EQ 6) AND (Sex_Gro[Size440to460] EQ 0), Age6Size440to460countM)
        age7Size440to460M = WHERE((Age_Gro[Size440to460] EQ 7) AND (Sex_Gro[Size440to460] EQ 0), Age7Size440to460countM)
        age8Size440to460M = WHERE((Age_Gro[Size440to460] EQ 8) AND (Sex_Gro[Size440to460] EQ 0), Age8Size440to460countM)
        age9Size440to460M = WHERE((Age_Gro[Size440to460] EQ 9) AND (Sex_Gro[Size440to460] EQ 0), Age9Size440to460countM)
        age10Size440to460M = WHERE((Age_Gro[Size440to460] EQ 10) AND (Sex_Gro[Size440to460] EQ 0), Age10Size440to460countM)
        age11Size440to460M = WHERE((Age_Gro[Size440to460] EQ 11) AND (Sex_Gro[Size440to460] EQ 0), Age11Size440to460countM)
        AGE12Size440to460M = WHERE((Age_Gro[Size440to460] EQ 12) AND (Sex_Gro[Size440to460] EQ 0), Age12Size440to460countM)
        AGE13Size440to460M = WHERE((Age_Gro[Size440to460] EQ 13) AND (Sex_Gro[Size440to460] EQ 0), Age13Size440to460countM)
        AGE14Size440to460M = WHERE((Age_Gro[Size440to460] EQ 14) AND (Sex_Gro[Size440to460] EQ 0), Age14Size440to460countM)
        AGE15Size440to460M = WHERE((Age_Gro[Size440to460] EQ 15) AND (Sex_Gro[Size440to460] EQ 0), Age15Size440to460countM)
        age16Size440to460M = WHERE((Age_Gro[Size440to460] EQ 16) AND (Sex_Gro[Size440to460] EQ 0), Age16Size440to460countM)
        age17Size440to460M = WHERE((Age_Gro[Size440to460] EQ 17) AND (Sex_Gro[Size440to460] EQ 0), Age17Size440to460countM)
        age18Size440to460M = WHERE((Age_Gro[Size440to460] EQ 18) AND (Sex_Gro[Size440to460] EQ 0), Age18Size440to460countM)
        age19Size440to460M = WHERE((Age_Gro[Size440to460] EQ 19) AND (Sex_Gro[Size440to460] EQ 0), Age19Size440to460countM)
        age20Size440to460M = WHERE((Age_Gro[Size440to460] EQ 20) AND (Sex_Gro[Size440to460] EQ 0), Age20Size440to460countM)
        age21Size440to460M = WHERE((Age_Gro[Size440to460] EQ 21) AND (Sex_Gro[Size440to460] EQ 0), Age21Size440to460countM)
        age22Size440to460M = WHERE((Age_Gro[Size440to460] EQ 22) AND (Sex_Gro[Size440to460] EQ 0), Age22Size440to460countM)
        age23Size440to460M = WHERE((Age_Gro[Size440to460] EQ 23) AND (Sex_Gro[Size440to460] EQ 0), Age23Size440to460countM)
        age24Size440to460M = WHERE((Age_Gro[Size440to460] EQ 24) AND (Sex_Gro[Size440to460] EQ 0), Age24Size440to460countM)
        age25Size440to460M = WHERE((Age_Gro[Size440to460] EQ 25) AND (Sex_Gro[Size440to460] EQ 0), Age25Size440to460countM)
        age26Size440to460M = WHERE((Age_Gro[Size440to460] EQ 26) AND (Sex_Gro[Size440to460] EQ 0), Age26Size440to460countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+18L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+18L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+18L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+18L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+18L] = 440
        WAE_length_bin[42, i*NumLengthBin+adj+18L] = Size440to460countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+18L] = Age0Size440to460countM
        WAE_length_bin[44, i*NumLengthBin+adj+18L] = Age1Size440to460countM
        WAE_length_bin[45, i*NumLengthBin+adj+18L] = Age2Size440to460countM
        WAE_length_bin[46, i*NumLengthBin+adj+18L] = Age3Size440to460countM
        WAE_length_bin[47, i*NumLengthBin+adj+18L] = Age4Size440to460countM
        WAE_length_bin[48, i*NumLengthBin+adj+18L] = Age5Size440to460countM
        WAE_length_bin[49, i*NumLengthBin+adj+18L] = Age6Size440to460countM
        WAE_length_bin[50, i*NumLengthBin+adj+18L] = Age7Size440to460countM
        WAE_length_bin[51, i*NumLengthBin+adj+18L] = Age8Size440to460countM
        WAE_length_bin[52, i*NumLengthBin+adj+18L] = Age9Size440to460countM
        WAE_length_bin[53, i*NumLengthBin+adj+18L] = Age10Size440to460countM
        WAE_length_bin[54, i*NumLengthBin+adj+18L] = Age11Size440to460countM
        WAE_length_bin[55, i*NumLengthBin+adj+18L] = Age12Size440to460countM
        WAE_length_bin[56, i*NumLengthBin+adj+18L] = Age13Size440to460countM
        WAE_length_bin[57, i*NumLengthBin+adj+18L] = Age14Size440to460countM
        WAE_length_bin[58, i*NumLengthBin+adj+18L] = Age15Size440to460countM
        WAE_length_bin[59, i*NumLengthBin+adj+18L] = Age16Size440to460countM
        WAE_length_bin[60, i*NumLengthBin+adj+18L] = Age17Size440to460countM
        WAE_length_bin[61, i*NumLengthBin+adj+18L] = Age18Size440to460countM
        WAE_length_bin[62, i*NumLengthBin+adj+18L] = Age19Size440to460countM
        WAE_length_bin[63, i*NumLengthBin+adj+18L] = Age20Size440to460countM
        WAE_length_bin[64, i*NumLengthBin+adj+18L] = Age21Size440to460countM
        WAE_length_bin[65, i*NumLengthBin+adj+18L] = Age22Size440to460countM
        WAE_length_bin[66, i*NumLengthBin+adj+18L] = Age23Size440to460countM
        WAE_length_bin[67, i*NumLengthBin+adj+18L] = Age24Size440to460countM
        WAE_length_bin[68, i*NumLengthBin+adj+18L] = Age25Size440to460countM
        WAE_length_bin[69, i*NumLengthBin+adj+18L] = Age26Size440to460countM
      ENDIF
      PRINT, 'Size440to460M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+18L])
      
      ; length bin 20
      IF Size460to480count GT 0 THEN BEGIN
        age0Size460to480M = WHERE((Age_Gro[Size460to480] EQ 0) AND (Sex_Gro[Size460to480] EQ 0), Age0Size460to480countM)
        age1Size460to480M = WHERE((Age_Gro[Size460to480] EQ 1) AND (Sex_Gro[Size460to480] EQ 0), Age1Size460to480countM)
        age2Size460to480M = WHERE((Age_Gro[Size460to480] EQ 2) AND (Sex_Gro[Size460to480] EQ 0), Age2Size460to480countM)
        age3Size460to480M = WHERE((Age_Gro[Size460to480] EQ 3) AND (Sex_Gro[Size460to480] EQ 0), Age3Size460to480countM)
        age4Size460to480M = WHERE((Age_Gro[Size460to480] EQ 4) AND (Sex_Gro[Size460to480] EQ 0), Age4Size460to480countM)
        age5Size460to480M = WHERE((Age_Gro[Size460to480] EQ 5) AND (Sex_Gro[Size460to480] EQ 0), Age5Size460to480countM)
        age6Size460to480M = WHERE((Age_Gro[Size460to480] EQ 6) AND (Sex_Gro[Size460to480] EQ 0), Age6Size460to480countM)
        age7Size460to480M = WHERE((Age_Gro[Size460to480] EQ 7) AND (Sex_Gro[Size460to480] EQ 0), Age7Size460to480countM)
        age8Size460to480M = WHERE((Age_Gro[Size460to480] EQ 8) AND (Sex_Gro[Size460to480] EQ 0), Age8Size460to480countM)
        age9Size460to480M = WHERE((Age_Gro[Size460to480] EQ 9) AND (Sex_Gro[Size460to480] EQ 0), Age9Size460to480countM)
        age10Size460to480M = WHERE((Age_Gro[Size460to480] EQ 10) AND (Sex_Gro[Size460to480] EQ 0), Age10Size460to480countM)
        age11Size460to480M = WHERE((Age_Gro[Size460to480] EQ 11) AND (Sex_Gro[Size460to480] EQ 0), Age11Size460to480countM)
        AGE12Size460to480M = WHERE((Age_Gro[Size460to480] EQ 12) AND (Sex_Gro[Size460to480] EQ 0), Age12Size460to480countM)
        AGE13Size460to480M = WHERE((Age_Gro[Size460to480] EQ 13) AND (Sex_Gro[Size460to480] EQ 0), Age13Size460to480countM)
        AGE14Size460to480M = WHERE((Age_Gro[Size460to480] EQ 14) AND (Sex_Gro[Size460to480] EQ 0), Age14Size460to480countM)
        AGE15Size460to480M = WHERE((Age_Gro[Size460to480] EQ 15) AND (Sex_Gro[Size460to480] EQ 0), Age15Size460to480countM)
        age16Size460to480M = WHERE((Age_Gro[Size460to480] EQ 16) AND (Sex_Gro[Size460to480] EQ 0), Age16Size460to480countM)
        age17Size460to480M = WHERE((Age_Gro[Size460to480] EQ 17) AND (Sex_Gro[Size460to480] EQ 0), Age17Size460to480countM)
        age18Size460to480M = WHERE((Age_Gro[Size460to480] EQ 18) AND (Sex_Gro[Size460to480] EQ 0), Age18Size460to480countM)
        age19Size460to480M = WHERE((Age_Gro[Size460to480] EQ 19) AND (Sex_Gro[Size460to480] EQ 0), Age19Size460to480countM)
        age20Size460to480M = WHERE((Age_Gro[Size460to480] EQ 20) AND (Sex_Gro[Size460to480] EQ 0), Age20Size460to480countM)
        age21Size460to480M = WHERE((Age_Gro[Size460to480] EQ 21) AND (Sex_Gro[Size460to480] EQ 0), Age21Size460to480countM)
        age22Size460to480M = WHERE((Age_Gro[Size460to480] EQ 22) AND (Sex_Gro[Size460to480] EQ 0), Age22Size460to480countM)
        age23Size460to480M = WHERE((Age_Gro[Size460to480] EQ 23) AND (Sex_Gro[Size460to480] EQ 0), Age23Size460to480countM)
        age24Size460to480M = WHERE((Age_Gro[Size460to480] EQ 24) AND (Sex_Gro[Size460to480] EQ 0), Age24Size460to480countM)
        age25Size460to480M = WHERE((Age_Gro[Size460to480] EQ 25) AND (Sex_Gro[Size460to480] EQ 0), Age25Size460to480countM)
        age26Size460to480M = WHERE((Age_Gro[Size460to480] EQ 26) AND (Sex_Gro[Size460to480] EQ 0), Age26Size460to480countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+19L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+19L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+19L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+19L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+19L] = 460
        WAE_length_bin[42, i*NumLengthBin+adj+19L] = Size460to480countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+19L] = Age0Size460to480countM
        WAE_length_bin[44, i*NumLengthBin+adj+19L] = Age1Size460to480countM
        WAE_length_bin[45, i*NumLengthBin+adj+19L] = Age2Size460to480countM
        WAE_length_bin[46, i*NumLengthBin+adj+19L] = Age3Size460to480countM
        WAE_length_bin[47, i*NumLengthBin+adj+19L] = Age4Size460to480countM
        WAE_length_bin[48, i*NumLengthBin+adj+19L] = Age5Size460to480countM
        WAE_length_bin[49, i*NumLengthBin+adj+19L] = Age6Size460to480countM
        WAE_length_bin[50, i*NumLengthBin+adj+19L] = Age7Size460to480countM
        WAE_length_bin[51, i*NumLengthBin+adj+19L] = Age8Size460to480countM
        WAE_length_bin[52, i*NumLengthBin+adj+19L] = Age9Size460to480countM
        WAE_length_bin[53, i*NumLengthBin+adj+19L] = Age10Size460to480countM
        WAE_length_bin[54, i*NumLengthBin+adj+19L] = Age11Size460to480countM
        WAE_length_bin[55, i*NumLengthBin+adj+19L] = Age12Size460to480countM
        WAE_length_bin[56, i*NumLengthBin+adj+19L] = Age13Size460to480countM
        WAE_length_bin[57, i*NumLengthBin+adj+19L] = Age14Size460to480countM
        WAE_length_bin[58, i*NumLengthBin+adj+19L] = Age15Size460to480countM
        WAE_length_bin[59, i*NumLengthBin+adj+19L] = Age16Size460to480countM
        WAE_length_bin[60, i*NumLengthBin+adj+19L] = Age17Size460to480countM
        WAE_length_bin[61, i*NumLengthBin+adj+19L] = Age18Size460to480countM
        WAE_length_bin[62, i*NumLengthBin+adj+19L] = Age19Size460to480countM
        WAE_length_bin[63, i*NumLengthBin+adj+19L] = Age20Size460to480countM
        WAE_length_bin[64, i*NumLengthBin+adj+19L] = Age21Size460to480countM
        WAE_length_bin[65, i*NumLengthBin+adj+19L] = Age22Size460to480countM
        WAE_length_bin[66, i*NumLengthBin+adj+19L] = Age23Size460to480countM
        WAE_length_bin[67, i*NumLengthBin+adj+19L] = Age24Size460to480countM
        WAE_length_bin[68, i*NumLengthBin+adj+19L] = Age25Size460to480countM
        WAE_length_bin[69, i*NumLengthBin+adj+19L] = Age26Size460to480countM
      ENDIF
      PRINT, 'Size460to480M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+19L])
      
      ; length bin 21
      IF Size480to500count GT 0 THEN BEGIN
        age0Size480to500M = WHERE((Age_Gro[Size480to500] EQ 0) AND (Sex_Gro[Size480to500] EQ 0), Age0Size480to500countM)
        age1Size480to500M = WHERE((Age_Gro[Size480to500] EQ 1) AND (Sex_Gro[Size480to500] EQ 0), Age1Size480to500countM)
        age2Size480to500M = WHERE((Age_Gro[Size480to500] EQ 2) AND (Sex_Gro[Size480to500] EQ 0), Age2Size480to500countM)
        age3Size480to500M = WHERE((Age_Gro[Size480to500] EQ 3) AND (Sex_Gro[Size480to500] EQ 0), Age3Size480to500countM)
        age4Size480to500M = WHERE((Age_Gro[Size480to500] EQ 4) AND (Sex_Gro[Size480to500] EQ 0), Age4Size480to500countM)
        age5Size480to500M = WHERE((Age_Gro[Size480to500] EQ 5) AND (Sex_Gro[Size480to500] EQ 0), Age5Size480to500countM)
        age6Size480to500M = WHERE((Age_Gro[Size480to500] EQ 6) AND (Sex_Gro[Size480to500] EQ 0), Age6Size480to500countM)
        age7Size480to500M = WHERE((Age_Gro[Size480to500] EQ 7) AND (Sex_Gro[Size480to500] EQ 0), Age7Size480to500countM)
        age8Size480to500M = WHERE((Age_Gro[Size480to500] EQ 8) AND (Sex_Gro[Size480to500] EQ 0), Age8Size480to500countM)
        age9Size480to500M = WHERE((Age_Gro[Size480to500] EQ 9) AND (Sex_Gro[Size480to500] EQ 0), Age9Size480to500countM)
        age10Size480to500M = WHERE((Age_Gro[Size480to500] EQ 10) AND (Sex_Gro[Size480to500] EQ 0), Age10Size480to500countM)
        age11Size480to500M = WHERE((Age_Gro[Size480to500] EQ 11) AND (Sex_Gro[Size480to500] EQ 0), Age11Size480to500countM)
        AGE12Size480to500M = WHERE((Age_Gro[Size480to500] EQ 12) AND (Sex_Gro[Size480to500] EQ 0), Age12Size480to500countM)
        AGE13Size480to500M = WHERE((Age_Gro[Size480to500] EQ 13) AND (Sex_Gro[Size480to500] EQ 0), Age13Size480to500countM)
        AGE14Size480to500M = WHERE((Age_Gro[Size480to500] EQ 14) AND (Sex_Gro[Size480to500] EQ 0), Age14Size480to500countM)
        AGE15Size480to500M = WHERE((Age_Gro[Size480to500] EQ 15) AND (Sex_Gro[Size480to500] EQ 0), Age15Size480to500countM)
        age16Size480to500M = WHERE((Age_Gro[Size480to500] EQ 16) AND (Sex_Gro[Size480to500] EQ 0), Age16Size480to500countM)
        age17Size480to500M = WHERE((Age_Gro[Size480to500] EQ 17) AND (Sex_Gro[Size480to500] EQ 0), Age17Size480to500countM)
        age18Size480to500M = WHERE((Age_Gro[Size480to500] EQ 18) AND (Sex_Gro[Size480to500] EQ 0), Age18Size480to500countM)
        age19Size480to500M = WHERE((Age_Gro[Size480to500] EQ 19) AND (Sex_Gro[Size480to500] EQ 0), Age19Size480to500countM)
        age20Size480to500M = WHERE((Age_Gro[Size480to500] EQ 20) AND (Sex_Gro[Size480to500] EQ 0), Age20Size480to500countM)
        age21Size480to500M = WHERE((Age_Gro[Size480to500] EQ 21) AND (Sex_Gro[Size480to500] EQ 0), Age21Size480to500countM)
        age22Size480to500M = WHERE((Age_Gro[Size480to500] EQ 22) AND (Sex_Gro[Size480to500] EQ 0), Age22Size480to500countM)
        age23Size480to500M = WHERE((Age_Gro[Size480to500] EQ 23) AND (Sex_Gro[Size480to500] EQ 0), Age23Size480to500countM)
        age24Size480to500M = WHERE((Age_Gro[Size480to500] EQ 24) AND (Sex_Gro[Size480to500] EQ 0), Age24Size480to500countM)
        age25Size480to500M = WHERE((Age_Gro[Size480to500] EQ 25) AND (Sex_Gro[Size480to500] EQ 0), Age25Size480to500countM)
        age26Size480to500M = WHERE((Age_Gro[Size480to500] EQ 26) AND (Sex_Gro[Size480to500] EQ 0), Age26Size480to500countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+20L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+20L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+20L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+20L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+20L] = 480
        WAE_length_bin[42, i*NumLengthBin+adj+20L] = Size480to500countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+20L] = Age0Size480to500countM
        WAE_length_bin[44, i*NumLengthBin+adj+20L] = Age1Size480to500countM
        WAE_length_bin[45, i*NumLengthBin+adj+20L] = Age2Size480to500countM
        WAE_length_bin[46, i*NumLengthBin+adj+20L] = Age3Size480to500countM
        WAE_length_bin[47, i*NumLengthBin+adj+20L] = Age4Size480to500countM
        WAE_length_bin[48, i*NumLengthBin+adj+20L] = Age5Size480to500countM
        WAE_length_bin[49, i*NumLengthBin+adj+20L] = Age6Size480to500countM
        WAE_length_bin[50, i*NumLengthBin+adj+20L] = Age7Size480to500countM
        WAE_length_bin[51, i*NumLengthBin+adj+20L] = Age8Size480to500countM
        WAE_length_bin[52, i*NumLengthBin+adj+20L] = Age9Size480to500countM
        WAE_length_bin[53, i*NumLengthBin+adj+20L] = Age10Size480to500countM
        WAE_length_bin[54, i*NumLengthBin+adj+20L] = Age11Size480to500countM
        WAE_length_bin[55, i*NumLengthBin+adj+20L] = Age12Size480to500countM
        WAE_length_bin[56, i*NumLengthBin+adj+20L] = Age13Size480to500countM
        WAE_length_bin[57, i*NumLengthBin+adj+20L] = Age14Size480to500countM
        WAE_length_bin[58, i*NumLengthBin+adj+20L] = Age15Size480to500countM
        WAE_length_bin[59, i*NumLengthBin+adj+20L] = Age16Size480to500countM
        WAE_length_bin[60, i*NumLengthBin+adj+20L] = Age17Size480to500countM
        WAE_length_bin[61, i*NumLengthBin+adj+20L] = Age18Size480to500countM
        WAE_length_bin[62, i*NumLengthBin+adj+20L] = Age19Size480to500countM
        WAE_length_bin[63, i*NumLengthBin+adj+20L] = Age20Size480to500countM
        WAE_length_bin[64, i*NumLengthBin+adj+20L] = Age21Size480to500countM
        WAE_length_bin[65, i*NumLengthBin+adj+20L] = Age22Size480to500countM
        WAE_length_bin[66, i*NumLengthBin+adj+20L] = Age23Size480to500countM
        WAE_length_bin[67, i*NumLengthBin+adj+20L] = Age24Size480to500countM
        WAE_length_bin[68, i*NumLengthBin+adj+20L] = Age25Size480to500countM
        WAE_length_bin[69, i*NumLengthBin+adj+20L] = Age26Size480to500countM
      ENDIF
      PRINT, 'Size480to500M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+20L])
      ; length bin 22
      IF Size500to520count GT 0 THEN BEGIN
        age0Size500to520M = WHERE((Age_Gro[Size500to520] EQ 0) AND (Sex_Gro[Size500to520] EQ 0), Age0Size500to520countM)
        age1Size500to520M = WHERE((Age_Gro[Size500to520] EQ 1) AND (Sex_Gro[Size500to520] EQ 0), Age1Size500to520countM)
        age2Size500to520M = WHERE((Age_Gro[Size500to520] EQ 2) AND (Sex_Gro[Size500to520] EQ 0), Age2Size500to520countM)
        age3Size500to520M = WHERE((Age_Gro[Size500to520] EQ 3) AND (Sex_Gro[Size500to520] EQ 0), Age3Size500to520countM)
        age4Size500to520M = WHERE((Age_Gro[Size500to520] EQ 4) AND (Sex_Gro[Size500to520] EQ 0), Age4Size500to520countM)
        age5Size500to520M = WHERE((Age_Gro[Size500to520] EQ 5) AND (Sex_Gro[Size500to520] EQ 0), Age5Size500to520countM)
        age6Size500to520M = WHERE((Age_Gro[Size500to520] EQ 6) AND (Sex_Gro[Size500to520] EQ 0), Age6Size500to520countM)
        age7Size500to520M = WHERE((Age_Gro[Size500to520] EQ 7) AND (Sex_Gro[Size500to520] EQ 0), Age7Size500to520countM)
        age8Size500to520M = WHERE((Age_Gro[Size500to520] EQ 8) AND (Sex_Gro[Size500to520] EQ 0), Age8Size500to520countM)
        age9Size500to520M = WHERE((Age_Gro[Size500to520] EQ 9) AND (Sex_Gro[Size500to520] EQ 0), Age9Size500to520countM)
        age10Size500to520M = WHERE((Age_Gro[Size500to520] EQ 10) AND (Sex_Gro[Size500to520] EQ 0), Age10Size500to520countM)
        age11Size500to520M = WHERE((Age_Gro[Size500to520] EQ 11) AND (Sex_Gro[Size500to520] EQ 0), Age11Size500to520countM)
        AGE12Size500to520M = WHERE((Age_Gro[Size500to520] EQ 12) AND (Sex_Gro[Size500to520] EQ 0), Age12Size500to520countM)
        AGE13Size500to520M = WHERE((Age_Gro[Size500to520] EQ 13) AND (Sex_Gro[Size500to520] EQ 0), Age13Size500to520countM)
        AGE14Size500to520M = WHERE((Age_Gro[Size500to520] EQ 14) AND (Sex_Gro[Size500to520] EQ 0), Age14Size500to520countM)
        AGE15Size500to520M = WHERE((Age_Gro[Size500to520] EQ 15) AND (Sex_Gro[Size500to520] EQ 0), Age15Size500to520countM)
        age16Size500to520M = WHERE((Age_Gro[Size500to520] EQ 16) AND (Sex_Gro[Size500to520] EQ 0), Age16Size500to520countM)
        age17Size500to520M = WHERE((Age_Gro[Size500to520] EQ 17) AND (Sex_Gro[Size500to520] EQ 0), Age17Size500to520countM)
        age18Size500to520M = WHERE((Age_Gro[Size500to520] EQ 18) AND (Sex_Gro[Size500to520] EQ 0), Age18Size500to520countM)
        age19Size500to520M = WHERE((Age_Gro[Size500to520] EQ 19) AND (Sex_Gro[Size500to520] EQ 0), Age19Size500to520countM)
        age20Size500to520M = WHERE((Age_Gro[Size500to520] EQ 20) AND (Sex_Gro[Size500to520] EQ 0), Age20Size500to520countM)
        age21Size500to520M = WHERE((Age_Gro[Size500to520] EQ 21) AND (Sex_Gro[Size500to520] EQ 0), Age21Size500to520countM)
        age22Size500to520M = WHERE((Age_Gro[Size500to520] EQ 22) AND (Sex_Gro[Size500to520] EQ 0), Age22Size500to520countM)
        age23Size500to520M = WHERE((Age_Gro[Size500to520] EQ 23) AND (Sex_Gro[Size500to520] EQ 0), Age23Size500to520countM)
        age24Size500to520M = WHERE((Age_Gro[Size500to520] EQ 24) AND (Sex_Gro[Size500to520] EQ 0), Age24Size500to520countM)
        age25Size500to520M = WHERE((Age_Gro[Size500to520] EQ 25) AND (Sex_Gro[Size500to520] EQ 0), Age25Size500to520countM)
        age26Size500to520M = WHERE((Age_Gro[Size500to520] EQ 26) AND (Sex_Gro[Size500to520] EQ 0), Age26Size500to520countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+21L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+21L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+21L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+21L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+21L] = 500
        WAE_length_bin[42, i*NumLengthBin+adj+21L] = Size500to520countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+21L] = Age0Size500to520countM
        WAE_length_bin[44, i*NumLengthBin+adj+21L] = Age1Size500to520countM
        WAE_length_bin[45, i*NumLengthBin+adj+21L] = Age2Size500to520countM
        WAE_length_bin[46, i*NumLengthBin+adj+21L] = Age3Size500to520countM
        WAE_length_bin[47, i*NumLengthBin+adj+21L] = Age4Size500to520countM
        WAE_length_bin[48, i*NumLengthBin+adj+21L] = Age5Size500to520countM
        WAE_length_bin[49, i*NumLengthBin+adj+21L] = Age6Size500to520countM
        WAE_length_bin[50, i*NumLengthBin+adj+21L] = Age7Size500to520countM
        WAE_length_bin[51, i*NumLengthBin+adj+21L] = Age8Size500to520countM
        WAE_length_bin[52, i*NumLengthBin+adj+21L] = Age9Size500to520countM
        WAE_length_bin[53, i*NumLengthBin+adj+21L] = Age10Size500to520countM
        WAE_length_bin[54, i*NumLengthBin+adj+21L] = Age11Size500to520countM
        WAE_length_bin[55, i*NumLengthBin+adj+21L] = Age12Size500to520countM
        WAE_length_bin[56, i*NumLengthBin+adj+21L] = Age13Size500to520countM
        WAE_length_bin[57, i*NumLengthBin+adj+21L] = Age14Size500to520countM
        WAE_length_bin[58, i*NumLengthBin+adj+21L] = Age15Size500to520countM
        WAE_length_bin[59, i*NumLengthBin+adj+21L] = Age16Size500to520countM
        WAE_length_bin[60, i*NumLengthBin+adj+21L] = Age17Size500to520countM
        WAE_length_bin[61, i*NumLengthBin+adj+21L] = Age18Size500to520countM
        WAE_length_bin[62, i*NumLengthBin+adj+21L] = Age19Size500to520countM
        WAE_length_bin[63, i*NumLengthBin+adj+21L] = Age20Size500to520countM
        WAE_length_bin[64, i*NumLengthBin+adj+21L] = Age21Size500to520countM
        WAE_length_bin[65, i*NumLengthBin+adj+21L] = Age22Size500to520countM
        WAE_length_bin[66, i*NumLengthBin+adj+21L] = Age23Size500to520countM
        WAE_length_bin[67, i*NumLengthBin+adj+21L] = Age24Size500to520countM
        WAE_length_bin[68, i*NumLengthBin+adj+21L] = Age25Size500to520countM
        WAE_length_bin[69, i*NumLengthBin+adj+21L] = Age26Size500to520countM
      ENDIF
      PRINT, 'Size500to520M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+21L])
      
      ; length bin 23
      IF Size520to540count GT 0 THEN BEGIN
        age0Size520to540M = WHERE((Age_Gro[Size520to540] EQ 0) AND (Sex_Gro[Size520to540] EQ 0), Age0Size520to540countM)
        age1Size520to540M = WHERE((Age_Gro[Size520to540] EQ 1) AND (Sex_Gro[Size520to540] EQ 0), Age1Size520to540countM)
        age2Size520to540M = WHERE((Age_Gro[Size520to540] EQ 2) AND (Sex_Gro[Size520to540] EQ 0), Age2Size520to540countM)
        age3Size520to540M = WHERE((Age_Gro[Size520to540] EQ 3) AND (Sex_Gro[Size520to540] EQ 0), Age3Size520to540countM)
        age4Size520to540M = WHERE((Age_Gro[Size520to540] EQ 4) AND (Sex_Gro[Size520to540] EQ 0), Age4Size520to540countM)
        age5Size520to540M = WHERE((Age_Gro[Size520to540] EQ 5) AND (Sex_Gro[Size520to540] EQ 0), Age5Size520to540countM)
        age6Size520to540M = WHERE((Age_Gro[Size520to540] EQ 6) AND (Sex_Gro[Size520to540] EQ 0), Age6Size520to540countM)
        age7Size520to540M = WHERE((Age_Gro[Size520to540] EQ 7) AND (Sex_Gro[Size520to540] EQ 0), Age7Size520to540countM)
        age8Size520to540M = WHERE((Age_Gro[Size520to540] EQ 8) AND (Sex_Gro[Size520to540] EQ 0), Age8Size520to540countM)
        age9Size520to540M = WHERE((Age_Gro[Size520to540] EQ 9) AND (Sex_Gro[Size520to540] EQ 0), Age9Size520to540countM)
        age10Size520to540M = WHERE((Age_Gro[Size520to540] EQ 10) AND (Sex_Gro[Size520to540] EQ 0), Age10Size520to540countM)
        age11Size520to540M = WHERE((Age_Gro[Size520to540] EQ 11) AND (Sex_Gro[Size520to540] EQ 0), Age11Size520to540countM)
        AGE12Size520to540M = WHERE((Age_Gro[Size520to540] EQ 12) AND (Sex_Gro[Size520to540] EQ 0), Age12Size520to540countM)
        AGE13Size520to540M = WHERE((Age_Gro[Size520to540] EQ 13) AND (Sex_Gro[Size520to540] EQ 0), Age13Size520to540countM)
        AGE14Size520to540M = WHERE((Age_Gro[Size520to540] EQ 14) AND (Sex_Gro[Size520to540] EQ 0), Age14Size520to540countM)
        AGE15Size520to540M = WHERE((Age_Gro[Size520to540] EQ 15) AND (Sex_Gro[Size520to540] EQ 0), Age15Size520to540countM)
        age16Size520to540M = WHERE((Age_Gro[Size520to540] EQ 16) AND (Sex_Gro[Size520to540] EQ 0), Age16Size520to540countM)
        age17Size520to540M = WHERE((Age_Gro[Size520to540] EQ 17) AND (Sex_Gro[Size520to540] EQ 0), Age17Size520to540countM)
        age18Size520to540M = WHERE((Age_Gro[Size520to540] EQ 18) AND (Sex_Gro[Size520to540] EQ 0), Age18Size520to540countM)
        age19Size520to540M = WHERE((Age_Gro[Size520to540] EQ 19) AND (Sex_Gro[Size520to540] EQ 0), Age19Size520to540countM)
        age20Size520to540M = WHERE((Age_Gro[Size520to540] EQ 20) AND (Sex_Gro[Size520to540] EQ 0), Age20Size520to540countM)
        age21Size520to540M = WHERE((Age_Gro[Size520to540] EQ 21) AND (Sex_Gro[Size520to540] EQ 0), Age21Size520to540countM)
        age22Size520to540M = WHERE((Age_Gro[Size520to540] EQ 22) AND (Sex_Gro[Size520to540] EQ 0), Age22Size520to540countM)
        age23Size520to540M = WHERE((Age_Gro[Size520to540] EQ 23) AND (Sex_Gro[Size520to540] EQ 0), Age23Size520to540countM)
        age24Size520to540M = WHERE((Age_Gro[Size520to540] EQ 24) AND (Sex_Gro[Size520to540] EQ 0), Age24Size520to540countM)
        age25Size520to540M = WHERE((Age_Gro[Size520to540] EQ 25) AND (Sex_Gro[Size520to540] EQ 0), Age25Size520to540countM)
        age26Size520to540M = WHERE((Age_Gro[Size520to540] EQ 26) AND (Sex_Gro[Size520to540] EQ 0), Age26Size520to540countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+22L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+22L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+22L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+22L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+22L] = 520
        WAE_length_bin[42, i*NumLengthBin+adj+22L] = Size520to540countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+22L] = Age0Size520to540countM
        WAE_length_bin[44, i*NumLengthBin+adj+22L] = Age1Size520to540countM
        WAE_length_bin[45, i*NumLengthBin+adj+22L] = Age2Size520to540countM
        WAE_length_bin[46, i*NumLengthBin+adj+22L] = Age3Size520to540countM
        WAE_length_bin[47, i*NumLengthBin+adj+22L] = Age4Size520to540countM
        WAE_length_bin[48, i*NumLengthBin+adj+22L] = Age5Size520to540countM
        WAE_length_bin[49, i*NumLengthBin+adj+22L] = Age6Size520to540countM
        WAE_length_bin[50, i*NumLengthBin+adj+22L] = Age7Size520to540countM
        WAE_length_bin[51, i*NumLengthBin+adj+22L] = Age8Size520to540countM
        WAE_length_bin[52, i*NumLengthBin+adj+22L] = Age9Size520to540countM
        WAE_length_bin[53, i*NumLengthBin+adj+22L] = Age10Size520to540countM
        WAE_length_bin[54, i*NumLengthBin+adj+22L] = Age11Size520to540countM
        WAE_length_bin[55, i*NumLengthBin+adj+22L] = Age12Size520to540countM
        WAE_length_bin[56, i*NumLengthBin+adj+22L] = Age13Size520to540countM
        WAE_length_bin[57, i*NumLengthBin+adj+22L] = Age14Size520to540countM
        WAE_length_bin[58, i*NumLengthBin+adj+22L] = Age15Size520to540countM
        WAE_length_bin[59, i*NumLengthBin+adj+22L] = Age16Size520to540countM
        WAE_length_bin[60, i*NumLengthBin+adj+22L] = Age17Size520to540countM
        WAE_length_bin[61, i*NumLengthBin+adj+22L] = Age18Size520to540countM
        WAE_length_bin[62, i*NumLengthBin+adj+22L] = Age19Size520to540countM
        WAE_length_bin[63, i*NumLengthBin+adj+22L] = Age20Size520to540countM
        WAE_length_bin[64, i*NumLengthBin+adj+22L] = Age21Size520to540countM
        WAE_length_bin[65, i*NumLengthBin+adj+22L] = Age22Size520to540countM
        WAE_length_bin[66, i*NumLengthBin+adj+22L] = Age23Size520to540countM
        WAE_length_bin[67, i*NumLengthBin+adj+22L] = Age24Size520to540countM
        WAE_length_bin[68, i*NumLengthBin+adj+22L] = Age25Size520to540countM
        WAE_length_bin[69, i*NumLengthBin+adj+22L] = Age26Size520to540countM
      ENDIF
      PRINT, 'Size520to540M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+22L])
      
      ; length bin 24
      IF Size540to560count GT 0 THEN BEGIN
        age0Size540to560M = WHERE((Age_Gro[Size540to560] EQ 0) AND (Sex_Gro[Size540to560] EQ 0), Age0Size540to560countM)
        age1Size540to560M = WHERE((Age_Gro[Size540to560] EQ 1) AND (Sex_Gro[Size540to560] EQ 0), Age1Size540to560countM)
        age2Size540to560M = WHERE((Age_Gro[Size540to560] EQ 2) AND (Sex_Gro[Size540to560] EQ 0), Age2Size540to560countM)
        age3Size540to560M = WHERE((Age_Gro[Size540to560] EQ 3) AND (Sex_Gro[Size540to560] EQ 0), Age3Size540to560countM)
        age4Size540to560M = WHERE((Age_Gro[Size540to560] EQ 4) AND (Sex_Gro[Size540to560] EQ 0), Age4Size540to560countM)
        age5Size540to560M = WHERE((Age_Gro[Size540to560] EQ 5) AND (Sex_Gro[Size540to560] EQ 0), Age5Size540to560countM)
        age6Size540to560M = WHERE((Age_Gro[Size540to560] EQ 6) AND (Sex_Gro[Size540to560] EQ 0), Age6Size540to560countM)
        age7Size540to560M = WHERE((Age_Gro[Size540to560] EQ 7) AND (Sex_Gro[Size540to560] EQ 0), Age7Size540to560countM)
        age8Size540to560M = WHERE((Age_Gro[Size540to560] EQ 8) AND (Sex_Gro[Size540to560] EQ 0), Age8Size540to560countM)
        age9Size540to560M = WHERE((Age_Gro[Size540to560] EQ 9) AND (Sex_Gro[Size540to560] EQ 0), Age9Size540to560countM)
        age10Size540to560M = WHERE((Age_Gro[Size540to560] EQ 10) AND (Sex_Gro[Size540to560] EQ 0), Age10Size540to560countM)
        age11Size540to560M = WHERE((Age_Gro[Size540to560] EQ 11) AND (Sex_Gro[Size540to560] EQ 0), Age11Size540to560countM)
        AGE12Size540to560M = WHERE((Age_Gro[Size540to560] EQ 12) AND (Sex_Gro[Size540to560] EQ 0), Age12Size540to560countM)
        AGE13Size540to560M = WHERE((Age_Gro[Size540to560] EQ 13) AND (Sex_Gro[Size540to560] EQ 0), Age13Size540to560countM)
        AGE14Size540to560M = WHERE((Age_Gro[Size540to560] EQ 14) AND (Sex_Gro[Size540to560] EQ 0), Age14Size540to560countM)
        AGE15Size540to560M = WHERE((Age_Gro[Size540to560] EQ 15) AND (Sex_Gro[Size540to560] EQ 0), Age15Size540to560countM)
        age16Size540to560M = WHERE((Age_Gro[Size540to560] EQ 16) AND (Sex_Gro[Size540to560] EQ 0), Age16Size540to560countM)
        age17Size540to560M = WHERE((Age_Gro[Size540to560] EQ 17) AND (Sex_Gro[Size540to560] EQ 0), Age17Size540to560countM)
        age18Size540to560M = WHERE((Age_Gro[Size540to560] EQ 18) AND (Sex_Gro[Size540to560] EQ 0), Age18Size540to560countM)
        age19Size540to560M = WHERE((Age_Gro[Size540to560] EQ 19) AND (Sex_Gro[Size540to560] EQ 0), Age19Size540to560countM)
        age20Size540to560M = WHERE((Age_Gro[Size540to560] EQ 20) AND (Sex_Gro[Size540to560] EQ 0), Age20Size540to560countM)
        age21Size540to560M = WHERE((Age_Gro[Size540to560] EQ 21) AND (Sex_Gro[Size540to560] EQ 0), Age21Size540to560countM)
        age22Size540to560M = WHERE((Age_Gro[Size540to560] EQ 22) AND (Sex_Gro[Size540to560] EQ 0), Age22Size540to560countM)
        age23Size540to560M = WHERE((Age_Gro[Size540to560] EQ 23) AND (Sex_Gro[Size540to560] EQ 0), Age23Size540to560countM)
        age24Size540to560M = WHERE((Age_Gro[Size540to560] EQ 24) AND (Sex_Gro[Size540to560] EQ 0), Age24Size540to560countM)
        age25Size540to560M = WHERE((Age_Gro[Size540to560] EQ 25) AND (Sex_Gro[Size540to560] EQ 0), Age25Size540to560countM)
        age26Size540to560M = WHERE((Age_Gro[Size540to560] EQ 26) AND (Sex_Gro[Size540to560] EQ 0), Age26Size540to560countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+23L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+23L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+23L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+23L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+23L] = 540
        WAE_length_bin[42, i*NumLengthBin+adj+23L] = Size540to560countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+23L] = Age0Size540to560countM
        WAE_length_bin[44, i*NumLengthBin+adj+23L] = Age1Size540to560countM
        WAE_length_bin[45, i*NumLengthBin+adj+23L] = Age2Size540to560countM
        WAE_length_bin[46, i*NumLengthBin+adj+23L] = Age3Size540to560countM
        WAE_length_bin[47, i*NumLengthBin+adj+23L] = Age4Size540to560countM
        WAE_length_bin[48, i*NumLengthBin+adj+23L] = Age5Size540to560countM
        WAE_length_bin[49, i*NumLengthBin+adj+23L] = Age6Size540to560countM
        WAE_length_bin[50, i*NumLengthBin+adj+23L] = Age7Size540to560countM
        WAE_length_bin[51, i*NumLengthBin+adj+23L] = Age8Size540to560countM
        WAE_length_bin[52, i*NumLengthBin+adj+23L] = Age9Size540to560countM
        WAE_length_bin[53, i*NumLengthBin+adj+23L] = Age10Size540to560countM
        WAE_length_bin[54, i*NumLengthBin+adj+23L] = Age11Size540to560countM
        WAE_length_bin[55, i*NumLengthBin+adj+23L] = Age12Size540to560countM
        WAE_length_bin[56, i*NumLengthBin+adj+23L] = Age13Size540to560countM
        WAE_length_bin[57, i*NumLengthBin+adj+23L] = Age14Size540to560countM
        WAE_length_bin[58, i*NumLengthBin+adj+23L] = Age15Size540to560countM
        WAE_length_bin[59, i*NumLengthBin+adj+23L] = Age16Size540to560countM
        WAE_length_bin[60, i*NumLengthBin+adj+23L] = Age17Size540to560countM
        WAE_length_bin[61, i*NumLengthBin+adj+23L] = Age18Size540to560countM
        WAE_length_bin[62, i*NumLengthBin+adj+23L] = Age19Size540to560countM
        WAE_length_bin[63, i*NumLengthBin+adj+23L] = Age20Size540to560countM
        WAE_length_bin[64, i*NumLengthBin+adj+23L] = Age21Size540to560countM
        WAE_length_bin[65, i*NumLengthBin+adj+23L] = Age22Size540to560countM
        WAE_length_bin[66, i*NumLengthBin+adj+23L] = Age23Size540to560countM
        WAE_length_bin[67, i*NumLengthBin+adj+23L] = Age24Size540to560countM
        WAE_length_bin[68, i*NumLengthBin+adj+23L] = Age25Size540to560countM
        WAE_length_bin[69, i*NumLengthBin+adj+23L] = Age26Size540to560countM
      ENDIF
      PRINT, 'Size540to560M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+23L])
      
      ; length bin 25
      IF Size560to580count GT 0 THEN BEGIN
        age0Size560to580M = WHERE((Age_Gro[Size560to580] EQ 0) AND (Sex_Gro[Size560to580] EQ 0), Age0Size560to580countM)
        age1Size560to580M = WHERE((Age_Gro[Size560to580] EQ 1) AND (Sex_Gro[Size560to580] EQ 0), Age1Size560to580countM)
        age2Size560to580M = WHERE((Age_Gro[Size560to580] EQ 2) AND (Sex_Gro[Size560to580] EQ 0), Age2Size560to580countM)
        age3Size560to580M = WHERE((Age_Gro[Size560to580] EQ 3) AND (Sex_Gro[Size560to580] EQ 0), Age3Size560to580countM)
        age4Size560to580M = WHERE((Age_Gro[Size560to580] EQ 4) AND (Sex_Gro[Size560to580] EQ 0), Age4Size560to580countM)
        age5Size560to580M = WHERE((Age_Gro[Size560to580] EQ 5) AND (Sex_Gro[Size560to580] EQ 0), Age5Size560to580countM)
        age6Size560to580M = WHERE((Age_Gro[Size560to580] EQ 6) AND (Sex_Gro[Size560to580] EQ 0), Age6Size560to580countM)
        age7Size560to580M = WHERE((Age_Gro[Size560to580] EQ 7) AND (Sex_Gro[Size560to580] EQ 0), Age7Size560to580countM)
        age8Size560to580M = WHERE((Age_Gro[Size560to580] EQ 8) AND (Sex_Gro[Size560to580] EQ 0), Age8Size560to580countM)
        age9Size560to580M = WHERE((Age_Gro[Size560to580] EQ 9) AND (Sex_Gro[Size560to580] EQ 0), Age9Size560to580countM)
        age10Size560to580M = WHERE((Age_Gro[Size560to580] EQ 10) AND (Sex_Gro[Size560to580] EQ 0), Age10Size560to580countM)
        age11Size560to580M = WHERE((Age_Gro[Size560to580] EQ 11) AND (Sex_Gro[Size560to580] EQ 0), Age11Size560to580countM)
        AGE12Size560to580M = WHERE((Age_Gro[Size560to580] EQ 12) AND (Sex_Gro[Size560to580] EQ 0), Age12Size560to580countM)
        AGE13Size560to580M = WHERE((Age_Gro[Size560to580] EQ 13) AND (Sex_Gro[Size560to580] EQ 0), Age13Size560to580countM)
        AGE14Size560to580M = WHERE((Age_Gro[Size560to580] EQ 14) AND (Sex_Gro[Size560to580] EQ 0), Age14Size560to580countM)
        AGE15Size560to580M = WHERE((Age_Gro[Size560to580] EQ 15) AND (Sex_Gro[Size560to580] EQ 0), Age15Size560to580countM)
        age16Size560to580M = WHERE((Age_Gro[Size560to580] EQ 16) AND (Sex_Gro[Size560to580] EQ 0), Age16Size560to580countM)
        age17Size560to580M = WHERE((Age_Gro[Size560to580] EQ 17) AND (Sex_Gro[Size560to580] EQ 0), Age17Size560to580countM)
        age18Size560to580M = WHERE((Age_Gro[Size560to580] EQ 18) AND (Sex_Gro[Size560to580] EQ 0), Age18Size560to580countM)
        age19Size560to580M = WHERE((Age_Gro[Size560to580] EQ 19) AND (Sex_Gro[Size560to580] EQ 0), Age19Size560to580countM)
        age20Size560to580M = WHERE((Age_Gro[Size560to580] EQ 20) AND (Sex_Gro[Size560to580] EQ 0), Age20Size560to580countM)
        age21Size560to580M = WHERE((Age_Gro[Size560to580] EQ 21) AND (Sex_Gro[Size560to580] EQ 0), Age21Size560to580countM)
        age22Size560to580M = WHERE((Age_Gro[Size560to580] EQ 22) AND (Sex_Gro[Size560to580] EQ 0), Age22Size560to580countM)
        age23Size560to580M = WHERE((Age_Gro[Size560to580] EQ 23) AND (Sex_Gro[Size560to580] EQ 0), Age23Size560to580countM)
        age24Size560to580M = WHERE((Age_Gro[Size560to580] EQ 24) AND (Sex_Gro[Size560to580] EQ 0), Age24Size560to580countM)
        age25Size560to580M = WHERE((Age_Gro[Size560to580] EQ 25) AND (Sex_Gro[Size560to580] EQ 0), Age25Size560to580countM)
        age26Size560to580M = WHERE((Age_Gro[Size560to580] EQ 26) AND (Sex_Gro[Size560to580] EQ 0), Age26Size560to580countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+24L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+24L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+24L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+24L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+24L] = 560
        WAE_length_bin[42, i*NumLengthBin+adj+24L] = Size560to580countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+24L] = Age0Size560to580countM
        WAE_length_bin[44, i*NumLengthBin+adj+24L] = Age1Size560to580countM
        WAE_length_bin[45, i*NumLengthBin+adj+24L] = Age2Size560to580countM
        WAE_length_bin[46, i*NumLengthBin+adj+24L] = Age3Size560to580countM
        WAE_length_bin[47, i*NumLengthBin+adj+24L] = Age4Size560to580countM
        WAE_length_bin[48, i*NumLengthBin+adj+24L] = Age5Size560to580countM
        WAE_length_bin[49, i*NumLengthBin+adj+24L] = Age6Size560to580countM
        WAE_length_bin[50, i*NumLengthBin+adj+24L] = Age7Size560to580countM
        WAE_length_bin[51, i*NumLengthBin+adj+24L] = Age8Size560to580countM
        WAE_length_bin[52, i*NumLengthBin+adj+24L] = Age9Size560to580countM
        WAE_length_bin[53, i*NumLengthBin+adj+24L] = Age10Size560to580countM
        WAE_length_bin[54, i*NumLengthBin+adj+24L] = Age11Size560to580countM
        WAE_length_bin[55, i*NumLengthBin+adj+24L] = Age12Size560to580countM
        WAE_length_bin[56, i*NumLengthBin+adj+24L] = Age13Size560to580countM
        WAE_length_bin[57, i*NumLengthBin+adj+24L] = Age14Size560to580countM
        WAE_length_bin[58, i*NumLengthBin+adj+24L] = Age15Size560to580countM
        WAE_length_bin[59, i*NumLengthBin+adj+24L] = Age16Size560to580countM
        WAE_length_bin[60, i*NumLengthBin+adj+24L] = Age17Size560to580countM
        WAE_length_bin[61, i*NumLengthBin+adj+24L] = Age18Size560to580countM
        WAE_length_bin[62, i*NumLengthBin+adj+24L] = Age19Size560to580countM
        WAE_length_bin[63, i*NumLengthBin+adj+24L] = Age20Size560to580countM
        WAE_length_bin[64, i*NumLengthBin+adj+24L] = Age21Size560to580countM
        WAE_length_bin[65, i*NumLengthBin+adj+24L] = Age22Size560to580countM
        WAE_length_bin[66, i*NumLengthBin+adj+24L] = Age23Size560to580countM
        WAE_length_bin[67, i*NumLengthBin+adj+24L] = Age24Size560to580countM
        WAE_length_bin[68, i*NumLengthBin+adj+24L] = Age25Size560to580countM
        WAE_length_bin[69, i*NumLengthBin+adj+24L] = Age26Size560to580countM
      ENDIF
      PRINT, 'Size560to580M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+24L])
      
      ; length bin 26
      IF Size580to600count GT 0 THEN BEGIN
        age0Size580to600M = WHERE((Age_Gro[Size580to600] EQ 0) AND (Sex_Gro[Size580to600] EQ 0), Age0Size580to600countM)
        age1Size580to600M = WHERE((Age_Gro[Size580to600] EQ 1) AND (Sex_Gro[Size580to600] EQ 0), Age1Size580to600countM)
        age2Size580to600M = WHERE((Age_Gro[Size580to600] EQ 2) AND (Sex_Gro[Size580to600] EQ 0), Age2Size580to600countM)
        age3Size580to600M = WHERE((Age_Gro[Size580to600] EQ 3) AND (Sex_Gro[Size580to600] EQ 0), Age3Size580to600countM)
        age4Size580to600M = WHERE((Age_Gro[Size580to600] EQ 4) AND (Sex_Gro[Size580to600] EQ 0), Age4Size580to600countM)
        age5Size580to600M = WHERE((Age_Gro[Size580to600] EQ 5) AND (Sex_Gro[Size580to600] EQ 0), Age5Size580to600countM)
        age6Size580to600M = WHERE((Age_Gro[Size580to600] EQ 6) AND (Sex_Gro[Size580to600] EQ 0), Age6Size580to600countM)
        age7Size580to600M = WHERE((Age_Gro[Size580to600] EQ 7) AND (Sex_Gro[Size580to600] EQ 0), Age7Size580to600countM)
        age8Size580to600M = WHERE((Age_Gro[Size580to600] EQ 8) AND (Sex_Gro[Size580to600] EQ 0), Age8Size580to600countM)
        age9Size580to600M = WHERE((Age_Gro[Size580to600] EQ 9) AND (Sex_Gro[Size580to600] EQ 0), Age9Size580to600countM)
        age10Size580to600M = WHERE((Age_Gro[Size580to600] EQ 10) AND (Sex_Gro[Size580to600] EQ 0), Age10Size580to600countM)
        age11Size580to600M = WHERE((Age_Gro[Size580to600] EQ 11) AND (Sex_Gro[Size580to600] EQ 0), Age11Size580to600countM)
        AGE12Size580to600M = WHERE((Age_Gro[Size580to600] EQ 12) AND (Sex_Gro[Size580to600] EQ 0), Age12Size580to600countM)
        AGE13Size580to600M = WHERE((Age_Gro[Size580to600] EQ 13) AND (Sex_Gro[Size580to600] EQ 0), Age13Size580to600countM)
        AGE14Size580to600M = WHERE((Age_Gro[Size580to600] EQ 14) AND (Sex_Gro[Size580to600] EQ 0), Age14Size580to600countM)
        AGE15Size580to600M = WHERE((Age_Gro[Size580to600] EQ 15) AND (Sex_Gro[Size580to600] EQ 0), Age15Size580to600countM)
        age16Size580to600M = WHERE((Age_Gro[Size580to600] EQ 16) AND (Sex_Gro[Size580to600] EQ 0), Age16Size580to600countM)
        age17Size580to600M = WHERE((Age_Gro[Size580to600] EQ 17) AND (Sex_Gro[Size580to600] EQ 0), Age17Size580to600countM)
        age18Size580to600M = WHERE((Age_Gro[Size580to600] EQ 18) AND (Sex_Gro[Size580to600] EQ 0), Age18Size580to600countM)
        age19Size580to600M = WHERE((Age_Gro[Size580to600] EQ 19) AND (Sex_Gro[Size580to600] EQ 0), Age19Size580to600countM)
        age20Size580to600M = WHERE((Age_Gro[Size580to600] EQ 20) AND (Sex_Gro[Size580to600] EQ 0), Age20Size580to600countM)
        age21Size580to600M = WHERE((Age_Gro[Size580to600] EQ 21) AND (Sex_Gro[Size580to600] EQ 0), Age21Size580to600countM)
        age22Size580to600M = WHERE((Age_Gro[Size580to600] EQ 22) AND (Sex_Gro[Size580to600] EQ 0), Age22Size580to600countM)
        age23Size580to600M = WHERE((Age_Gro[Size580to600] EQ 23) AND (Sex_Gro[Size580to600] EQ 0), Age23Size580to600countM)
        age24Size580to600M = WHERE((Age_Gro[Size580to600] EQ 24) AND (Sex_Gro[Size580to600] EQ 0), Age24Size580to600countM)
        age25Size580to600M = WHERE((Age_Gro[Size580to600] EQ 25) AND (Sex_Gro[Size580to600] EQ 0), Age25Size580to600countM)
        age26Size580to600M = WHERE((Age_Gro[Size580to600] EQ 26) AND (Sex_Gro[Size580to600] EQ 0), Age26Size580to600countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+25L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+25L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+25L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+25L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+25L] = 580
        WAE_length_bin[42, i*NumLengthBin+adj+25L] = Size580to600countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+25L] = Age0Size580to600countM
        WAE_length_bin[44, i*NumLengthBin+adj+25L] = Age1Size580to600countM
        WAE_length_bin[45, i*NumLengthBin+adj+25L] = Age2Size580to600countM
        WAE_length_bin[46, i*NumLengthBin+adj+25L] = Age3Size580to600countM
        WAE_length_bin[47, i*NumLengthBin+adj+25L] = Age4Size580to600countM
        WAE_length_bin[48, i*NumLengthBin+adj+25L] = Age5Size580to600countM
        WAE_length_bin[49, i*NumLengthBin+adj+25L] = Age6Size580to600countM
        WAE_length_bin[50, i*NumLengthBin+adj+25L] = Age7Size580to600countM
        WAE_length_bin[51, i*NumLengthBin+adj+25L] = Age8Size580to600countM
        WAE_length_bin[52, i*NumLengthBin+adj+25L] = Age9Size580to600countM
        WAE_length_bin[53, i*NumLengthBin+adj+25L] = Age10Size580to600countM
        WAE_length_bin[54, i*NumLengthBin+adj+25L] = Age11Size580to600countM
        WAE_length_bin[55, i*NumLengthBin+adj+25L] = Age12Size580to600countM
        WAE_length_bin[56, i*NumLengthBin+adj+25L] = Age13Size580to600countM
        WAE_length_bin[57, i*NumLengthBin+adj+25L] = Age14Size580to600countM
        WAE_length_bin[58, i*NumLengthBin+adj+25L] = Age15Size580to600countM
        WAE_length_bin[59, i*NumLengthBin+adj+25L] = Age16Size580to600countM
        WAE_length_bin[60, i*NumLengthBin+adj+25L] = Age17Size580to600countM
        WAE_length_bin[61, i*NumLengthBin+adj+25L] = Age18Size580to600countM
        WAE_length_bin[62, i*NumLengthBin+adj+25L] = Age19Size580to600countM
        WAE_length_bin[63, i*NumLengthBin+adj+25L] = Age20Size580to600countM
        WAE_length_bin[64, i*NumLengthBin+adj+25L] = Age21Size580to600countM
        WAE_length_bin[65, i*NumLengthBin+adj+25L] = Age22Size580to600countM
        WAE_length_bin[66, i*NumLengthBin+adj+25L] = Age23Size580to600countM
        WAE_length_bin[67, i*NumLengthBin+adj+25L] = Age24Size580to600countM
        WAE_length_bin[68, i*NumLengthBin+adj+25L] = Age25Size580to600countM
        WAE_length_bin[69, i*NumLengthBin+adj+25L] = Age26Size580to600countM
      ENDIF
      PRINT, 'Size580to600M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+25L])
      
      ; length bin 27
      IF Size600to620count GT 0 THEN BEGIN
        age0Size600to620M = WHERE((Age_Gro[Size600to620] EQ 0) AND (Sex_Gro[Size600to620] EQ 0), Age0Size600to620countM)
        age1Size600to620M = WHERE((Age_Gro[Size600to620] EQ 1) AND (Sex_Gro[Size600to620] EQ 0), Age1Size600to620countM)
        age2Size600to620M = WHERE((Age_Gro[Size600to620] EQ 2) AND (Sex_Gro[Size600to620] EQ 0), Age2Size600to620countM)
        age3Size600to620M = WHERE((Age_Gro[Size600to620] EQ 3) AND (Sex_Gro[Size600to620] EQ 0), Age3Size600to620countM)
        age4Size600to620M = WHERE((Age_Gro[Size600to620] EQ 4) AND (Sex_Gro[Size600to620] EQ 0), Age4Size600to620countM)
        age5Size600to620M = WHERE((Age_Gro[Size600to620] EQ 5) AND (Sex_Gro[Size600to620] EQ 0), Age5Size600to620countM)
        age6Size600to620M = WHERE((Age_Gro[Size600to620] EQ 6) AND (Sex_Gro[Size600to620] EQ 0), Age6Size600to620countM)
        age7Size600to620M = WHERE((Age_Gro[Size600to620] EQ 7) AND (Sex_Gro[Size600to620] EQ 0), Age7Size600to620countM)
        age8Size600to620M = WHERE((Age_Gro[Size600to620] EQ 8) AND (Sex_Gro[Size600to620] EQ 0), Age8Size600to620countM)
        age9Size600to620M = WHERE((Age_Gro[Size600to620] EQ 9) AND (Sex_Gro[Size600to620] EQ 0), Age9Size600to620countM)
        age10Size600to620M = WHERE((Age_Gro[Size600to620] EQ 10) AND (Sex_Gro[Size600to620] EQ 0), Age10Size600to620countM)
        age11Size600to620M = WHERE((Age_Gro[Size600to620] EQ 11) AND (Sex_Gro[Size600to620] EQ 0), Age11Size600to620countM)
        AGE12Size600to620M = WHERE((Age_Gro[Size600to620] EQ 12) AND (Sex_Gro[Size600to620] EQ 0), Age12Size600to620countM)
        AGE13Size600to620M = WHERE((Age_Gro[Size600to620] EQ 13) AND (Sex_Gro[Size600to620] EQ 0), Age13Size600to620countM)
        AGE14Size600to620M = WHERE((Age_Gro[Size600to620] EQ 14) AND (Sex_Gro[Size600to620] EQ 0), Age14Size600to620countM)
        AGE15Size600to620M = WHERE((Age_Gro[Size600to620] EQ 15) AND (Sex_Gro[Size600to620] EQ 0), Age15Size600to620countM)
        age16Size600to620M = WHERE((Age_Gro[Size600to620] EQ 16) AND (Sex_Gro[Size600to620] EQ 0), Age16Size600to620countM)
        age17Size600to620M = WHERE((Age_Gro[Size600to620] EQ 17) AND (Sex_Gro[Size600to620] EQ 0), Age17Size600to620countM)
        age18Size600to620M = WHERE((Age_Gro[Size600to620] EQ 18) AND (Sex_Gro[Size600to620] EQ 0), Age18Size600to620countM)
        age19Size600to620M = WHERE((Age_Gro[Size600to620] EQ 19) AND (Sex_Gro[Size600to620] EQ 0), Age19Size600to620countM)
        age20Size600to620M = WHERE((Age_Gro[Size600to620] EQ 20) AND (Sex_Gro[Size600to620] EQ 0), Age20Size600to620countM)
        age21Size600to620M = WHERE((Age_Gro[Size600to620] EQ 21) AND (Sex_Gro[Size600to620] EQ 0), Age21Size600to620countM)
        age22Size600to620M = WHERE((Age_Gro[Size600to620] EQ 22) AND (Sex_Gro[Size600to620] EQ 0), Age22Size600to620countM)
        age23Size600to620M = WHERE((Age_Gro[Size600to620] EQ 23) AND (Sex_Gro[Size600to620] EQ 0), Age23Size600to620countM)
        age24Size600to620M = WHERE((Age_Gro[Size600to620] EQ 24) AND (Sex_Gro[Size600to620] EQ 0), Age24Size600to620countM)
        age25Size600to620M = WHERE((Age_Gro[Size600to620] EQ 25) AND (Sex_Gro[Size600to620] EQ 0), Age25Size600to620countM)
        age26Size600to620M = WHERE((Age_Gro[Size600to620] EQ 26) AND (Sex_Gro[Size600to620] EQ 0), Age26Size600to620countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+26L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+26L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+26L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+26L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+26L] = 600
        WAE_length_bin[42, i*NumLengthBin+adj+26L] = Size600to620countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+26L] = Age0Size600to620countM
        WAE_length_bin[44, i*NumLengthBin+adj+26L] = Age1Size600to620countM
        WAE_length_bin[45, i*NumLengthBin+adj+26L] = Age2Size600to620countM
        WAE_length_bin[46, i*NumLengthBin+adj+26L] = Age3Size600to620countM
        WAE_length_bin[47, i*NumLengthBin+adj+26L] = Age4Size600to620countM
        WAE_length_bin[48, i*NumLengthBin+adj+26L] = Age5Size600to620countM
        WAE_length_bin[49, i*NumLengthBin+adj+26L] = Age6Size600to620countM
        WAE_length_bin[50, i*NumLengthBin+adj+26L] = Age7Size600to620countM
        WAE_length_bin[51, i*NumLengthBin+adj+26L] = Age8Size600to620countM
        WAE_length_bin[52, i*NumLengthBin+adj+26L] = Age9Size600to620countM
        WAE_length_bin[53, i*NumLengthBin+adj+26L] = Age10Size600to620countM
        WAE_length_bin[54, i*NumLengthBin+adj+26L] = Age11Size600to620countM
        WAE_length_bin[55, i*NumLengthBin+adj+26L] = Age12Size600to620countM
        WAE_length_bin[56, i*NumLengthBin+adj+26L] = Age13Size600to620countM
        WAE_length_bin[57, i*NumLengthBin+adj+26L] = Age14Size600to620countM
        WAE_length_bin[58, i*NumLengthBin+adj+26L] = Age15Size600to620countM
        WAE_length_bin[59, i*NumLengthBin+adj+26L] = Age16Size600to620countM
        WAE_length_bin[60, i*NumLengthBin+adj+26L] = Age17Size600to620countM
        WAE_length_bin[61, i*NumLengthBin+adj+26L] = Age18Size600to620countM
        WAE_length_bin[62, i*NumLengthBin+adj+26L] = Age19Size600to620countM
        WAE_length_bin[63, i*NumLengthBin+adj+26L] = Age20Size600to620countM
        WAE_length_bin[64, i*NumLengthBin+adj+26L] = Age21Size600to620countM
        WAE_length_bin[65, i*NumLengthBin+adj+26L] = Age22Size600to620countM
        WAE_length_bin[66, i*NumLengthBin+adj+26L] = Age23Size600to620countM
        WAE_length_bin[67, i*NumLengthBin+adj+26L] = Age24Size600to620countM
        WAE_length_bin[68, i*NumLengthBin+adj+26L] = Age25Size600to620countM
        WAE_length_bin[69, i*NumLengthBin+adj+26L] = Age26Size600to620countM
      ENDIF
      PRINT, 'Size600to620M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+26L])
      
      
      ; length bin 28
      IF Size620to640count GT 0 THEN BEGIN
        age0Size620to640M = WHERE((Age_Gro[Size620to640] EQ 0) AND (Sex_Gro[Size620to640] EQ 0), Age0Size620to640countM)
        age1Size620to640M = WHERE((Age_Gro[Size620to640] EQ 1) AND (Sex_Gro[Size620to640] EQ 0), Age1Size620to640countM)
        age2Size620to640M = WHERE((Age_Gro[Size620to640] EQ 2) AND (Sex_Gro[Size620to640] EQ 0), Age2Size620to640countM)
        age3Size620to640M = WHERE((Age_Gro[Size620to640] EQ 3) AND (Sex_Gro[Size620to640] EQ 0), Age3Size620to640countM)
        age4Size620to640M = WHERE((Age_Gro[Size620to640] EQ 4) AND (Sex_Gro[Size620to640] EQ 0), Age4Size620to640countM)
        age5Size620to640M = WHERE((Age_Gro[Size620to640] EQ 5) AND (Sex_Gro[Size620to640] EQ 0), Age5Size620to640countM)
        age6Size620to640M = WHERE((Age_Gro[Size620to640] EQ 6) AND (Sex_Gro[Size620to640] EQ 0), Age6Size620to640countM)
        age7Size620to640M = WHERE((Age_Gro[Size620to640] EQ 7) AND (Sex_Gro[Size620to640] EQ 0), Age7Size620to640countM)
        age8Size620to640M = WHERE((Age_Gro[Size620to640] EQ 8) AND (Sex_Gro[Size620to640] EQ 0), Age8Size620to640countM)
        age9Size620to640M = WHERE((Age_Gro[Size620to640] EQ 9) AND (Sex_Gro[Size620to640] EQ 0), Age9Size620to640countM)
        age10Size620to640M = WHERE((Age_Gro[Size620to640] EQ 10) AND (Sex_Gro[Size620to640] EQ 0), Age10Size620to640countM)
        age11Size620to640M = WHERE((Age_Gro[Size620to640] EQ 11) AND (Sex_Gro[Size620to640] EQ 0), Age11Size620to640countM)
        AGE12Size620to640M = WHERE((Age_Gro[Size620to640] EQ 12) AND (Sex_Gro[Size620to640] EQ 0), Age12Size620to640countM)
        AGE13Size620to640M = WHERE((Age_Gro[Size620to640] EQ 13) AND (Sex_Gro[Size620to640] EQ 0), Age13Size620to640countM)
        AGE14Size620to640M = WHERE((Age_Gro[Size620to640] EQ 14) AND (Sex_Gro[Size620to640] EQ 0), Age14Size620to640countM)
        AGE15Size620to640M = WHERE((Age_Gro[Size620to640] EQ 15) AND (Sex_Gro[Size620to640] EQ 0), Age15Size620to640countM)
        age16Size620to640M = WHERE((Age_Gro[Size620to640] EQ 16) AND (Sex_Gro[Size620to640] EQ 0), Age16Size620to640countM)
        age17Size620to640M = WHERE((Age_Gro[Size620to640] EQ 17) AND (Sex_Gro[Size620to640] EQ 0), Age17Size620to640countM)
        age18Size620to640M = WHERE((Age_Gro[Size620to640] EQ 18) AND (Sex_Gro[Size620to640] EQ 0), Age18Size620to640countM)
        age19Size620to640M = WHERE((Age_Gro[Size620to640] EQ 19) AND (Sex_Gro[Size620to640] EQ 0), Age19Size620to640countM)
        age20Size620to640M = WHERE((Age_Gro[Size620to640] EQ 20) AND (Sex_Gro[Size620to640] EQ 0), Age20Size620to640countM)
        age21Size620to640M = WHERE((Age_Gro[Size620to640] EQ 21) AND (Sex_Gro[Size620to640] EQ 0), Age21Size620to640countM)
        age22Size620to640M = WHERE((Age_Gro[Size620to640] EQ 22) AND (Sex_Gro[Size620to640] EQ 0), Age22Size620to640countM)
        age23Size620to640M = WHERE((Age_Gro[Size620to640] EQ 23) AND (Sex_Gro[Size620to640] EQ 0), Age23Size620to640countM)
        age24Size620to640M = WHERE((Age_Gro[Size620to640] EQ 24) AND (Sex_Gro[Size620to640] EQ 0), Age24Size620to640countM)
        age25Size620to640M = WHERE((Age_Gro[Size620to640] EQ 25) AND (Sex_Gro[Size620to640] EQ 0), Age25Size620to640countM)
        age26Size620to640M = WHERE((Age_Gro[Size620to640] EQ 26) AND (Sex_Gro[Size620to640] EQ 0), Age26Size620to640countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+27L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+27L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+27L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+27L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+27L] = 620
        WAE_length_bin[42, i*NumLengthBin+adj+27L] = Size620to640countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+27L] = Age0Size620to640countM
        WAE_length_bin[44, i*NumLengthBin+adj+27L] = Age1Size620to640countM
        WAE_length_bin[45, i*NumLengthBin+adj+27L] = Age2Size620to640countM
        WAE_length_bin[46, i*NumLengthBin+adj+27L] = Age3Size620to640countM
        WAE_length_bin[47, i*NumLengthBin+adj+27L] = Age4Size620to640countM
        WAE_length_bin[48, i*NumLengthBin+adj+27L] = Age5Size620to640countM
        WAE_length_bin[49, i*NumLengthBin+adj+27L] = Age6Size620to640countM
        WAE_length_bin[50, i*NumLengthBin+adj+27L] = Age7Size620to640countM
        WAE_length_bin[51, i*NumLengthBin+adj+27L] = Age8Size620to640countM
        WAE_length_bin[52, i*NumLengthBin+adj+27L] = Age9Size620to640countM
        WAE_length_bin[53, i*NumLengthBin+adj+27L] = Age10Size620to640countM
        WAE_length_bin[54, i*NumLengthBin+adj+27L] = Age11Size620to640countM
        WAE_length_bin[55, i*NumLengthBin+adj+27L] = Age12Size620to640countM
        WAE_length_bin[56, i*NumLengthBin+adj+27L] = Age13Size620to640countM
        WAE_length_bin[57, i*NumLengthBin+adj+27L] = Age14Size620to640countM
        WAE_length_bin[58, i*NumLengthBin+adj+27L] = Age15Size620to640countM
        WAE_length_bin[59, i*NumLengthBin+adj+27L] = Age16Size620to640countM
        WAE_length_bin[60, i*NumLengthBin+adj+27L] = Age17Size620to640countM
        WAE_length_bin[61, i*NumLengthBin+adj+27L] = Age18Size620to640countM
        WAE_length_bin[62, i*NumLengthBin+adj+27L] = Age19Size620to640countM
        WAE_length_bin[63, i*NumLengthBin+adj+27L] = Age20Size620to640countM
        WAE_length_bin[64, i*NumLengthBin+adj+27L] = Age21Size620to640countM
        WAE_length_bin[65, i*NumLengthBin+adj+27L] = Age22Size620to640countM
        WAE_length_bin[66, i*NumLengthBin+adj+27L] = Age23Size620to640countM
        WAE_length_bin[67, i*NumLengthBin+adj+27L] = Age24Size620to640countM
        WAE_length_bin[68, i*NumLengthBin+adj+27L] = Age25Size620to640countM
        WAE_length_bin[69, i*NumLengthBin+adj+27L] = Age26Size620to640countM
      ENDIF
      PRINT, 'Size620to640M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+27L])
      
      ; length bin 29
      IF Size640to660count GT 0 THEN BEGIN
        age0Size640to660M = WHERE((Age_Gro[Size640to660] EQ 0) AND (Sex_Gro[Size640to660] EQ 0), Age0Size640to660countM)
        age1Size640to660M = WHERE((Age_Gro[Size640to660] EQ 1) AND (Sex_Gro[Size640to660] EQ 0), Age1Size640to660countM)
        age2Size640to660M = WHERE((Age_Gro[Size640to660] EQ 2) AND (Sex_Gro[Size640to660] EQ 0), Age2Size640to660countM)
        age3Size640to660M = WHERE((Age_Gro[Size640to660] EQ 3) AND (Sex_Gro[Size640to660] EQ 0), Age3Size640to660countM)
        age4Size640to660M = WHERE((Age_Gro[Size640to660] EQ 4) AND (Sex_Gro[Size640to660] EQ 0), Age4Size640to660countM)
        age5Size640to660M = WHERE((Age_Gro[Size640to660] EQ 5) AND (Sex_Gro[Size640to660] EQ 0), Age5Size640to660countM)
        age6Size640to660M = WHERE((Age_Gro[Size640to660] EQ 6) AND (Sex_Gro[Size640to660] EQ 0), Age6Size640to660countM)
        age7Size640to660M = WHERE((Age_Gro[Size640to660] EQ 7) AND (Sex_Gro[Size640to660] EQ 0), Age7Size640to660countM)
        age8Size640to660M = WHERE((Age_Gro[Size640to660] EQ 8) AND (Sex_Gro[Size640to660] EQ 0), Age8Size640to660countM)
        age9Size640to660M = WHERE((Age_Gro[Size640to660] EQ 9) AND (Sex_Gro[Size640to660] EQ 0), Age9Size640to660countM)
        age10Size640to660M = WHERE((Age_Gro[Size640to660] EQ 10) AND (Sex_Gro[Size640to660] EQ 0), Age10Size640to660countM)
        age11Size640to660M = WHERE((Age_Gro[Size640to660] EQ 11) AND (Sex_Gro[Size640to660] EQ 0), Age11Size640to660countM)
        AGE12Size640to660M = WHERE((Age_Gro[Size640to660] EQ 12) AND (Sex_Gro[Size640to660] EQ 0), Age12Size640to660countM)
        AGE13Size640to660M = WHERE((Age_Gro[Size640to660] EQ 13) AND (Sex_Gro[Size640to660] EQ 0), Age13Size640to660countM)
        AGE14Size640to660M = WHERE((Age_Gro[Size640to660] EQ 14) AND (Sex_Gro[Size640to660] EQ 0), Age14Size640to660countM)
        AGE15Size640to660M = WHERE((Age_Gro[Size640to660] EQ 15) AND (Sex_Gro[Size640to660] EQ 0), Age15Size640to660countM)
        age16Size640to660M = WHERE((Age_Gro[Size640to660] EQ 16) AND (Sex_Gro[Size640to660] EQ 0), Age16Size640to660countM)
        age17Size640to660M = WHERE((Age_Gro[Size640to660] EQ 17) AND (Sex_Gro[Size640to660] EQ 0), Age17Size640to660countM)
        age18Size640to660M = WHERE((Age_Gro[Size640to660] EQ 18) AND (Sex_Gro[Size640to660] EQ 0), Age18Size640to660countM)
        age19Size640to660M = WHERE((Age_Gro[Size640to660] EQ 19) AND (Sex_Gro[Size640to660] EQ 0), Age19Size640to660countM)
        age20Size640to660M = WHERE((Age_Gro[Size640to660] EQ 20) AND (Sex_Gro[Size640to660] EQ 0), Age20Size640to660countM)
        age21Size640to660M = WHERE((Age_Gro[Size640to660] EQ 21) AND (Sex_Gro[Size640to660] EQ 0), Age21Size640to660countM)
        age22Size640to660M = WHERE((Age_Gro[Size640to660] EQ 22) AND (Sex_Gro[Size640to660] EQ 0), Age22Size640to660countM)
        age23Size640to660M = WHERE((Age_Gro[Size640to660] EQ 23) AND (Sex_Gro[Size640to660] EQ 0), Age23Size640to660countM)
        age24Size640to660M = WHERE((Age_Gro[Size640to660] EQ 24) AND (Sex_Gro[Size640to660] EQ 0), Age24Size640to660countM)
        age25Size640to660M = WHERE((Age_Gro[Size640to660] EQ 25) AND (Sex_Gro[Size640to660] EQ 0), Age25Size640to660countM)
        age26Size640to660M = WHERE((Age_Gro[Size640to660] EQ 26) AND (Sex_Gro[Size640to660] EQ 0), Age26Size640to660countM)
      
        ;WAE_length_bin[0, i*NumLengthBin+adj+28L] = uniqWBIC_Year[i]; WBIC_year (abbrev)
;        WAE_length_bin[1, i*NumLengthBin+adj+28L] = N_ELEMENTS(Length_Gro); N of fish
;        WAE_length_bin[2, i*NumLengthBin+adj+28L] = WBIC[INDEX_growthdata[0]]; WBIC
;        WAE_length_bin[3, i*NumLengthBin+adj+28L] = SurveyYear[INDEX_growthdata[0]]; year
;        WAE_length_bin[4, i*NumLengthBin+adj+28L] = Max(length[INDEX_growthdata])
;        WAE_length_bin[5, i*NumLengthBin+adj+28L] = Min(length[INDEX_growthdata])
;        WAE_length_bin[6, i*NumLengthBin+adj+28L] = Max(age[INDEX_growthdata])
;        WAE_length_bin[7, i*NumLengthBin+adj+28L] = Min(age[INDEX_growthdata])
;        WAE_length_bin[8, i*NumLengthBin+adj+28L] = 640
;        WAE_length_bin[9, i*NumLengthBin+adj+28L] =  Size640to660countM
      
        WAE_length_bin[37, i*NumLengthBin+adj+28L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+28L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+28L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+28L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+28L] = 640
        WAE_length_bin[42, i*NumLengthBin+adj+28L] = Size640to660countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+28L] = Age0Size640to660countM
        WAE_length_bin[44, i*NumLengthBin+adj+28L] = Age1Size640to660countM
        WAE_length_bin[45, i*NumLengthBin+adj+28L] = Age2Size640to660countM
        WAE_length_bin[46, i*NumLengthBin+adj+28L] = Age3Size640to660countM
        WAE_length_bin[47, i*NumLengthBin+adj+28L] = Age4Size640to660countM
        WAE_length_bin[48, i*NumLengthBin+adj+28L] = Age5Size640to660countM
        WAE_length_bin[49, i*NumLengthBin+adj+28L] = Age6Size640to660countM
        WAE_length_bin[50, i*NumLengthBin+adj+28L] = Age7Size640to660countM
        WAE_length_bin[51, i*NumLengthBin+adj+28L] = Age8Size640to660countM
        WAE_length_bin[52, i*NumLengthBin+adj+28L] = Age9Size640to660countM
        WAE_length_bin[53, i*NumLengthBin+adj+28L] = Age10Size640to660countM
        WAE_length_bin[54, i*NumLengthBin+adj+28L] = Age11Size640to660countM
        WAE_length_bin[55, i*NumLengthBin+adj+28L] = Age12Size640to660countM
        WAE_length_bin[56, i*NumLengthBin+adj+28L] = Age13Size640to660countM
        WAE_length_bin[57, i*NumLengthBin+adj+28L] = Age14Size640to660countM
        WAE_length_bin[58, i*NumLengthBin+adj+28L] = Age15Size640to660countM
        WAE_length_bin[59, i*NumLengthBin+adj+28L] = Age16Size640to660countM
        WAE_length_bin[60, i*NumLengthBin+adj+28L] = Age17Size640to660countM
        WAE_length_bin[61, i*NumLengthBin+adj+28L] = Age18Size640to660countM
        WAE_length_bin[62, i*NumLengthBin+adj+28L] = Age19Size640to660countM
        WAE_length_bin[63, i*NumLengthBin+adj+28L] = Age20Size640to660countM
        WAE_length_bin[64, i*NumLengthBin+adj+28L] = Age21Size640to660countM
        WAE_length_bin[65, i*NumLengthBin+adj+28L] = Age22Size640to660countM
        WAE_length_bin[66, i*NumLengthBin+adj+28L] = Age23Size640to660countM
        WAE_length_bin[67, i*NumLengthBin+adj+28L] = Age24Size640to660countM
        WAE_length_bin[68, i*NumLengthBin+adj+28L] = Age25Size640to660countM
        WAE_length_bin[69, i*NumLengthBin+adj+28L] = Age26Size640to660countM
      ENDIF
      PRINT, 'Size640to660M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+28L])
      
      ; length bin 30
      IF Size660to680count GT 0 THEN BEGIN
        age0Size660to680M = WHERE((Age_Gro[Size660to680] EQ 0) AND (Sex_Gro[Size660to680] EQ 0), Age0Size660to680countM)
        age1Size660to680M = WHERE((Age_Gro[Size660to680] EQ 1) AND (Sex_Gro[Size660to680] EQ 0), Age1Size660to680countM)
        age2Size660to680M = WHERE((Age_Gro[Size660to680] EQ 2) AND (Sex_Gro[Size660to680] EQ 0), Age2Size660to680countM)
        age3Size660to680M = WHERE((Age_Gro[Size660to680] EQ 3) AND (Sex_Gro[Size660to680] EQ 0), Age3Size660to680countM)
        age4Size660to680M = WHERE((Age_Gro[Size660to680] EQ 4) AND (Sex_Gro[Size660to680] EQ 0), Age4Size660to680countM)
        age5Size660to680M = WHERE((Age_Gro[Size660to680] EQ 5) AND (Sex_Gro[Size660to680] EQ 0), Age5Size660to680countM)
        age6Size660to680M = WHERE((Age_Gro[Size660to680] EQ 6) AND (Sex_Gro[Size660to680] EQ 0), Age6Size660to680countM)
        age7Size660to680M = WHERE((Age_Gro[Size660to680] EQ 7) AND (Sex_Gro[Size660to680] EQ 0), Age7Size660to680countM)
        age8Size660to680M = WHERE((Age_Gro[Size660to680] EQ 8) AND (Sex_Gro[Size660to680] EQ 0), Age8Size660to680countM)
        age9Size660to680M = WHERE((Age_Gro[Size660to680] EQ 9) AND (Sex_Gro[Size660to680] EQ 0), Age9Size660to680countM)
        age10Size660to680M = WHERE((Age_Gro[Size660to680] EQ 10) AND (Sex_Gro[Size660to680] EQ 0), Age10Size660to680countM)
        age11Size660to680M = WHERE((Age_Gro[Size660to680] EQ 11) AND (Sex_Gro[Size660to680] EQ 0), Age11Size660to680countM)
        AGE12Size660to680M = WHERE((Age_Gro[Size660to680] EQ 12) AND (Sex_Gro[Size660to680] EQ 0), Age12Size660to680countM)
        AGE13Size660to680M = WHERE((Age_Gro[Size660to680] EQ 13) AND (Sex_Gro[Size660to680] EQ 0), Age13Size660to680countM)
        AGE14Size660to680M = WHERE((Age_Gro[Size660to680] EQ 14) AND (Sex_Gro[Size660to680] EQ 0), Age14Size660to680countM)
        AGE15Size660to680M = WHERE((Age_Gro[Size660to680] EQ 15) AND (Sex_Gro[Size660to680] EQ 0), Age15Size660to680countM)
        age16Size660to680M = WHERE((Age_Gro[Size660to680] EQ 16) AND (Sex_Gro[Size660to680] EQ 0), Age16Size660to680countM)
        age17Size660to680M = WHERE((Age_Gro[Size660to680] EQ 17) AND (Sex_Gro[Size660to680] EQ 0), Age17Size660to680countM)
        age18Size660to680M = WHERE((Age_Gro[Size660to680] EQ 18) AND (Sex_Gro[Size660to680] EQ 0), Age18Size660to680countM)
        age19Size660to680M = WHERE((Age_Gro[Size660to680] EQ 19) AND (Sex_Gro[Size660to680] EQ 0), Age19Size660to680countM)
        age20Size660to680M = WHERE((Age_Gro[Size660to680] EQ 20) AND (Sex_Gro[Size660to680] EQ 0), Age20Size660to680countM)
        age21Size660to680M = WHERE((Age_Gro[Size660to680] EQ 21) AND (Sex_Gro[Size660to680] EQ 0), Age21Size660to680countM)
        age22Size660to680M = WHERE((Age_Gro[Size660to680] EQ 22) AND (Sex_Gro[Size660to680] EQ 0), Age22Size660to680countM)
        age23Size660to680M = WHERE((Age_Gro[Size660to680] EQ 23) AND (Sex_Gro[Size660to680] EQ 0), Age23Size660to680countM)
        age24Size660to680M = WHERE((Age_Gro[Size660to680] EQ 24) AND (Sex_Gro[Size660to680] EQ 0), Age24Size660to680countM)
        age25Size660to680M = WHERE((Age_Gro[Size660to680] EQ 25) AND (Sex_Gro[Size660to680] EQ 0), Age25Size660to680countM)
        age26Size660to680M = WHERE((Age_Gro[Size660to680] EQ 26) AND (Sex_Gro[Size660to680] EQ 0), Age26Size660to680countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+29L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+29L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+29L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+29L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+29L] = 660
        WAE_length_bin[42, i*NumLengthBin+adj+29L] = Size660to680countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+29L] = Age0Size660to680countM
        WAE_length_bin[44, i*NumLengthBin+adj+29L] = Age1Size660to680countM
        WAE_length_bin[45, i*NumLengthBin+adj+29L] = Age2Size660to680countM
        WAE_length_bin[46, i*NumLengthBin+adj+29L] = Age3Size660to680countM
        WAE_length_bin[47, i*NumLengthBin+adj+29L] = Age4Size660to680countM
        WAE_length_bin[48, i*NumLengthBin+adj+29L] = Age5Size660to680countM
        WAE_length_bin[49, i*NumLengthBin+adj+29L] = Age6Size660to680countM
        WAE_length_bin[50, i*NumLengthBin+adj+29L] = Age7Size660to680countM
        WAE_length_bin[51, i*NumLengthBin+adj+29L] = Age8Size660to680countM
        WAE_length_bin[52, i*NumLengthBin+adj+29L] = Age9Size660to680countM
        WAE_length_bin[53, i*NumLengthBin+adj+29L] = Age10Size660to680countM
        WAE_length_bin[54, i*NumLengthBin+adj+29L] = Age11Size660to680countM
        WAE_length_bin[55, i*NumLengthBin+adj+29L] = Age12Size660to680countM
        WAE_length_bin[56, i*NumLengthBin+adj+29L] = Age13Size660to680countM
        WAE_length_bin[57, i*NumLengthBin+adj+29L] = Age14Size660to680countM
        WAE_length_bin[58, i*NumLengthBin+adj+29L] = Age15Size660to680countM
        WAE_length_bin[59, i*NumLengthBin+adj+29L] = Age16Size660to680countM
        WAE_length_bin[60, i*NumLengthBin+adj+29L] = Age17Size660to680countM
        WAE_length_bin[61, i*NumLengthBin+adj+29L] = Age18Size660to680countM
        WAE_length_bin[62, i*NumLengthBin+adj+29L] = Age19Size660to680countM
        WAE_length_bin[63, i*NumLengthBin+adj+29L] = Age20Size660to680countM
        WAE_length_bin[64, i*NumLengthBin+adj+29L] = Age21Size660to680countM
        WAE_length_bin[65, i*NumLengthBin+adj+29L] = Age22Size660to680countM
        WAE_length_bin[66, i*NumLengthBin+adj+29L] = Age23Size660to680countM
        WAE_length_bin[67, i*NumLengthBin+adj+29L] = Age24Size660to680countM
        WAE_length_bin[68, i*NumLengthBin+adj+29L] = Age25Size660to680countM
        WAE_length_bin[69, i*NumLengthBin+adj+29L] = Age26Size660to680countM
      ENDIF
      PRINT, 'Size660to680M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+29L])
      
      ; length bin 31
      IF Size680to700count GT 0 THEN BEGIN
        age0Size680to700M = WHERE((Age_Gro[Size680to700] EQ 0) AND (Sex_Gro[Size680to700] EQ 0), Age0Size680to700countM)
        age1Size680to700M = WHERE((Age_Gro[Size680to700] EQ 1) AND (Sex_Gro[Size680to700] EQ 0), Age1Size680to700countM)
        age2Size680to700M = WHERE((Age_Gro[Size680to700] EQ 2) AND (Sex_Gro[Size680to700] EQ 0), Age2Size680to700countM)
        age3Size680to700M = WHERE((Age_Gro[Size680to700] EQ 3) AND (Sex_Gro[Size680to700] EQ 0), Age3Size680to700countM)
        age4Size680to700M = WHERE((Age_Gro[Size680to700] EQ 4) AND (Sex_Gro[Size680to700] EQ 0), Age4Size680to700countM)
        age5Size680to700M = WHERE((Age_Gro[Size680to700] EQ 5) AND (Sex_Gro[Size680to700] EQ 0), Age5Size680to700countM)
        age6Size680to700M = WHERE((Age_Gro[Size680to700] EQ 6) AND (Sex_Gro[Size680to700] EQ 0), Age6Size680to700countM)
        age7Size680to700M = WHERE((Age_Gro[Size680to700] EQ 7) AND (Sex_Gro[Size680to700] EQ 0), Age7Size680to700countM)
        age8Size680to700M = WHERE((Age_Gro[Size680to700] EQ 8) AND (Sex_Gro[Size680to700] EQ 0), Age8Size680to700countM)
        age9Size680to700M = WHERE((Age_Gro[Size680to700] EQ 9) AND (Sex_Gro[Size680to700] EQ 0), Age9Size680to700countM)
        age10Size680to700M = WHERE((Age_Gro[Size680to700] EQ 10) AND (Sex_Gro[Size680to700] EQ 0), Age10Size680to700countM)
        age11Size680to700M = WHERE((Age_Gro[Size680to700] EQ 11) AND (Sex_Gro[Size680to700] EQ 0), Age11Size680to700countM)
        AGE12Size680to700M = WHERE((Age_Gro[Size680to700] EQ 12) AND (Sex_Gro[Size680to700] EQ 0), Age12Size680to700countM)
        AGE13Size680to700M = WHERE((Age_Gro[Size680to700] EQ 13) AND (Sex_Gro[Size680to700] EQ 0), Age13Size680to700countM)
        AGE14Size680to700M = WHERE((Age_Gro[Size680to700] EQ 14) AND (Sex_Gro[Size680to700] EQ 0), Age14Size680to700countM)
        AGE15Size680to700M = WHERE((Age_Gro[Size680to700] EQ 15) AND (Sex_Gro[Size680to700] EQ 0), Age15Size680to700countM)
        age16Size680to700M = WHERE((Age_Gro[Size680to700] EQ 16) AND (Sex_Gro[Size680to700] EQ 0), Age16Size680to700countM)
        age17Size680to700M = WHERE((Age_Gro[Size680to700] EQ 17) AND (Sex_Gro[Size680to700] EQ 0), Age17Size680to700countM)
        age18Size680to700M = WHERE((Age_Gro[Size680to700] EQ 18) AND (Sex_Gro[Size680to700] EQ 0), Age18Size680to700countM)
        age19Size680to700M = WHERE((Age_Gro[Size680to700] EQ 19) AND (Sex_Gro[Size680to700] EQ 0), Age19Size680to700countM)
        age20Size680to700M = WHERE((Age_Gro[Size680to700] EQ 20) AND (Sex_Gro[Size680to700] EQ 0), Age20Size680to700countM)
        age21Size680to700M = WHERE((Age_Gro[Size680to700] EQ 21) AND (Sex_Gro[Size680to700] EQ 0), Age21Size680to700countM)
        age22Size680to700M = WHERE((Age_Gro[Size680to700] EQ 22) AND (Sex_Gro[Size680to700] EQ 0), Age22Size680to700countM)
        age23Size680to700M = WHERE((Age_Gro[Size680to700] EQ 23) AND (Sex_Gro[Size680to700] EQ 0), Age23Size680to700countM)
        age24Size680to700M = WHERE((Age_Gro[Size680to700] EQ 24) AND (Sex_Gro[Size680to700] EQ 0), Age24Size680to700countM)
        age25Size680to700M = WHERE((Age_Gro[Size680to700] EQ 25) AND (Sex_Gro[Size680to700] EQ 0), Age25Size680to700countM)
        age26Size680to700M = WHERE((Age_Gro[Size680to700] EQ 26) AND (Sex_Gro[Size680to700] EQ 0), Age26Size680to700countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+30L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+30L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+30L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+30L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+30L] = 680
        WAE_length_bin[42, i*NumLengthBin+adj+30L] = Size680to700countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+30L] = Age0Size680to700countM
        WAE_length_bin[44, i*NumLengthBin+adj+30L] = Age1Size680to700countM
        WAE_length_bin[45, i*NumLengthBin+adj+30L] = Age2Size680to700countM
        WAE_length_bin[46, i*NumLengthBin+adj+30L] = Age3Size680to700countM
        WAE_length_bin[47, i*NumLengthBin+adj+30L] = Age4Size680to700countM
        WAE_length_bin[48, i*NumLengthBin+adj+30L] = Age5Size680to700countM
        WAE_length_bin[49, i*NumLengthBin+adj+30L] = Age6Size680to700countM
        WAE_length_bin[50, i*NumLengthBin+adj+30L] = Age7Size680to700countM
        WAE_length_bin[51, i*NumLengthBin+adj+30L] = Age8Size680to700countM
        WAE_length_bin[52, i*NumLengthBin+adj+30L] = Age9Size680to700countM
        WAE_length_bin[53, i*NumLengthBin+adj+30L] = Age10Size680to700countM
        WAE_length_bin[54, i*NumLengthBin+adj+30L] = Age11Size680to700countM
        WAE_length_bin[55, i*NumLengthBin+adj+30L] = Age12Size680to700countM
        WAE_length_bin[56, i*NumLengthBin+adj+30L] = Age13Size680to700countM
        WAE_length_bin[57, i*NumLengthBin+adj+30L] = Age14Size680to700countM
        WAE_length_bin[58, i*NumLengthBin+adj+30L] = Age15Size680to700countM
        WAE_length_bin[59, i*NumLengthBin+adj+30L] = Age16Size680to700countM
        WAE_length_bin[60, i*NumLengthBin+adj+30L] = Age17Size680to700countM
        WAE_length_bin[61, i*NumLengthBin+adj+30L] = Age18Size680to700countM
        WAE_length_bin[62, i*NumLengthBin+adj+30L] = Age19Size680to700countM
        WAE_length_bin[63, i*NumLengthBin+adj+30L] = Age20Size680to700countM
        WAE_length_bin[64, i*NumLengthBin+adj+30L] = Age21Size680to700countM
        WAE_length_bin[65, i*NumLengthBin+adj+30L] = Age22Size680to700countM
        WAE_length_bin[66, i*NumLengthBin+adj+30L] = Age23Size680to700countM
        WAE_length_bin[67, i*NumLengthBin+adj+30L] = Age24Size680to700countM
        WAE_length_bin[68, i*NumLengthBin+adj+30L] = Age25Size680to700countM
        WAE_length_bin[69, i*NumLengthBin+adj+30L] = Age26Size680to700countM
      ENDIF
      PRINT, 'Size680to700M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+30L])
      
      ; length bin 32
      IF Size700to720count GT 0 THEN BEGIN
        age0Size700to720M = WHERE((Age_Gro[Size700to720] EQ 0) AND (Sex_Gro[Size700to720] EQ 0), Age0Size700to720countM)
        age1Size700to720M = WHERE((Age_Gro[Size700to720] EQ 1) AND (Sex_Gro[Size700to720] EQ 0), Age1Size700to720countM)
        age2Size700to720M = WHERE((Age_Gro[Size700to720] EQ 2) AND (Sex_Gro[Size700to720] EQ 0), Age2Size700to720countM)
        age3Size700to720M = WHERE((Age_Gro[Size700to720] EQ 3) AND (Sex_Gro[Size700to720] EQ 0), Age3Size700to720countM)
        age4Size700to720M = WHERE((Age_Gro[Size700to720] EQ 4) AND (Sex_Gro[Size700to720] EQ 0), Age4Size700to720countM)
        age5Size700to720M = WHERE((Age_Gro[Size700to720] EQ 5) AND (Sex_Gro[Size700to720] EQ 0), Age5Size700to720countM)
        age6Size700to720M = WHERE((Age_Gro[Size700to720] EQ 6) AND (Sex_Gro[Size700to720] EQ 0), Age6Size700to720countM)
        age7Size700to720M = WHERE((Age_Gro[Size700to720] EQ 7) AND (Sex_Gro[Size700to720] EQ 0), Age7Size700to720countM)
        age8Size700to720M = WHERE((Age_Gro[Size700to720] EQ 8) AND (Sex_Gro[Size700to720] EQ 0), Age8Size700to720countM)
        age9Size700to720M = WHERE((Age_Gro[Size700to720] EQ 9) AND (Sex_Gro[Size700to720] EQ 0), Age9Size700to720countM)
        age10Size700to720M = WHERE((Age_Gro[Size700to720] EQ 10) AND (Sex_Gro[Size700to720] EQ 0), Age10Size700to720countM)
        age11Size700to720M = WHERE((Age_Gro[Size700to720] EQ 11) AND (Sex_Gro[Size700to720] EQ 0), Age11Size700to720countM)
        AGE12Size700to720M = WHERE((Age_Gro[Size700to720] EQ 12) AND (Sex_Gro[Size700to720] EQ 0), Age12Size700to720countM)
        AGE13Size700to720M = WHERE((Age_Gro[Size700to720] EQ 13) AND (Sex_Gro[Size700to720] EQ 0), Age13Size700to720countM)
        AGE14Size700to720M = WHERE((Age_Gro[Size700to720] EQ 14) AND (Sex_Gro[Size700to720] EQ 0), Age14Size700to720countM)
        AGE15Size700to720M = WHERE((Age_Gro[Size700to720] EQ 15) AND (Sex_Gro[Size700to720] EQ 0), Age15Size700to720countM)
        age16Size700to720M = WHERE((Age_Gro[Size700to720] EQ 16) AND (Sex_Gro[Size700to720] EQ 0), Age16Size700to720countM)
        age17Size700to720M = WHERE((Age_Gro[Size700to720] EQ 17) AND (Sex_Gro[Size700to720] EQ 0), Age17Size700to720countM)
        age18Size700to720M = WHERE((Age_Gro[Size700to720] EQ 18) AND (Sex_Gro[Size700to720] EQ 0), Age18Size700to720countM)
        age19Size700to720M = WHERE((Age_Gro[Size700to720] EQ 19) AND (Sex_Gro[Size700to720] EQ 0), Age19Size700to720countM)
        age20Size700to720M = WHERE((Age_Gro[Size700to720] EQ 20) AND (Sex_Gro[Size700to720] EQ 0), Age20Size700to720countM)
        age21Size700to720M = WHERE((Age_Gro[Size700to720] EQ 21) AND (Sex_Gro[Size700to720] EQ 0), Age21Size700to720countM)
        age22Size700to720M = WHERE((Age_Gro[Size700to720] EQ 22) AND (Sex_Gro[Size700to720] EQ 0), Age22Size700to720countM)
        age23Size700to720M = WHERE((Age_Gro[Size700to720] EQ 23) AND (Sex_Gro[Size700to720] EQ 0), Age23Size700to720countM)
        age24Size700to720M = WHERE((Age_Gro[Size700to720] EQ 24) AND (Sex_Gro[Size700to720] EQ 0), Age24Size700to720countM)
        age25Size700to720M = WHERE((Age_Gro[Size700to720] EQ 25) AND (Sex_Gro[Size700to720] EQ 0), Age25Size700to720countM)
        age26Size700to720M = WHERE((Age_Gro[Size700to720] EQ 26) AND (Sex_Gro[Size700to720] EQ 0), Age26Size700to720countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+31L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+31L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+31L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+31L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+31L] = 700
        WAE_length_bin[42, i*NumLengthBin+adj+31L] = Size700to720countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+31L] = Age0Size700to720countM
        WAE_length_bin[44, i*NumLengthBin+adj+31L] = Age1Size700to720countM
        WAE_length_bin[45, i*NumLengthBin+adj+31L] = Age2Size700to720countM
        WAE_length_bin[46, i*NumLengthBin+adj+31L] = Age3Size700to720countM
        WAE_length_bin[47, i*NumLengthBin+adj+31L] = Age4Size700to720countM
        WAE_length_bin[48, i*NumLengthBin+adj+31L] = Age5Size700to720countM
        WAE_length_bin[49, i*NumLengthBin+adj+31L] = Age6Size700to720countM
        WAE_length_bin[50, i*NumLengthBin+adj+31L] = Age7Size700to720countM
        WAE_length_bin[51, i*NumLengthBin+adj+31L] = Age8Size700to720countM
        WAE_length_bin[52, i*NumLengthBin+adj+31L] = Age9Size700to720countM
        WAE_length_bin[53, i*NumLengthBin+adj+31L] = Age10Size700to720countM
        WAE_length_bin[54, i*NumLengthBin+adj+31L] = Age11Size700to720countM
        WAE_length_bin[55, i*NumLengthBin+adj+31L] = Age12Size700to720countM
        WAE_length_bin[56, i*NumLengthBin+adj+31L] = Age13Size700to720countM
        WAE_length_bin[57, i*NumLengthBin+adj+31L] = Age14Size700to720countM
        WAE_length_bin[58, i*NumLengthBin+adj+31L] = Age15Size700to720countM
        WAE_length_bin[59, i*NumLengthBin+adj+31L] = Age16Size700to720countM
        WAE_length_bin[60, i*NumLengthBin+adj+31L] = Age17Size700to720countM
        WAE_length_bin[61, i*NumLengthBin+adj+31L] = Age18Size700to720countM
        WAE_length_bin[62, i*NumLengthBin+adj+31L] = Age19Size700to720countM
        WAE_length_bin[63, i*NumLengthBin+adj+31L] = Age20Size700to720countM
        WAE_length_bin[64, i*NumLengthBin+adj+31L] = Age21Size700to720countM
        WAE_length_bin[65, i*NumLengthBin+adj+31L] = Age22Size700to720countM
        WAE_length_bin[66, i*NumLengthBin+adj+31L] = Age23Size700to720countM
        WAE_length_bin[67, i*NumLengthBin+adj+31L] = Age24Size700to720countM
        WAE_length_bin[68, i*NumLengthBin+adj+31L] = Age25Size700to720countM
        WAE_length_bin[69, i*NumLengthBin+adj+31L] = Age26Size700to720countM
      ENDIF
      PRINT, 'Size700to720M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+31L])
      
      ; length bin 33
      IF Size720to740count GT 0 THEN BEGIN
        age0Size720to740M = WHERE((Age_Gro[Size720to740] EQ 0) AND (Sex_Gro[Size720to740] EQ 0), Age0Size720to740countM)
        age1Size720to740M = WHERE((Age_Gro[Size720to740] EQ 1) AND (Sex_Gro[Size720to740] EQ 0), Age1Size720to740countM)
        age2Size720to740M = WHERE((Age_Gro[Size720to740] EQ 2) AND (Sex_Gro[Size720to740] EQ 0), Age2Size720to740countM)
        age3Size720to740M = WHERE((Age_Gro[Size720to740] EQ 3) AND (Sex_Gro[Size720to740] EQ 0), Age3Size720to740countM)
        age4Size720to740M = WHERE((Age_Gro[Size720to740] EQ 4) AND (Sex_Gro[Size720to740] EQ 0), Age4Size720to740countM)
        age5Size720to740M = WHERE((Age_Gro[Size720to740] EQ 5) AND (Sex_Gro[Size720to740] EQ 0), Age5Size720to740countM)
        age6Size720to740M = WHERE((Age_Gro[Size720to740] EQ 6) AND (Sex_Gro[Size720to740] EQ 0), Age6Size720to740countM)
        age7Size720to740M = WHERE((Age_Gro[Size720to740] EQ 7) AND (Sex_Gro[Size720to740] EQ 0), Age7Size720to740countM)
        age8Size720to740M = WHERE((Age_Gro[Size720to740] EQ 8) AND (Sex_Gro[Size720to740] EQ 0), Age8Size720to740countM)
        age9Size720to740M = WHERE((Age_Gro[Size720to740] EQ 9) AND (Sex_Gro[Size720to740] EQ 0), Age9Size720to740countM)
        age10Size720to740M = WHERE((Age_Gro[Size720to740] EQ 10) AND (Sex_Gro[Size720to740] EQ 0), Age10Size720to740countM)
        age11Size720to740M = WHERE((Age_Gro[Size720to740] EQ 11) AND (Sex_Gro[Size720to740] EQ 0), Age11Size720to740countM)
        AGE12Size720to740M = WHERE((Age_Gro[Size720to740] EQ 12) AND (Sex_Gro[Size720to740] EQ 0), Age12Size720to740countM)
        AGE13Size720to740M = WHERE((Age_Gro[Size720to740] EQ 13) AND (Sex_Gro[Size720to740] EQ 0), Age13Size720to740countM)
        AGE14Size720to740M = WHERE((Age_Gro[Size720to740] EQ 14) AND (Sex_Gro[Size720to740] EQ 0), Age14Size720to740countM)
        AGE15Size720to740M = WHERE((Age_Gro[Size720to740] EQ 15) AND (Sex_Gro[Size720to740] EQ 0), Age15Size720to740countM)
        age16Size720to740M = WHERE((Age_Gro[Size720to740] EQ 16) AND (Sex_Gro[Size720to740] EQ 0), Age16Size720to740countM)
        age17Size720to740M = WHERE((Age_Gro[Size720to740] EQ 17) AND (Sex_Gro[Size720to740] EQ 0), Age17Size720to740countM)
        age18Size720to740M = WHERE((Age_Gro[Size720to740] EQ 18) AND (Sex_Gro[Size720to740] EQ 0), Age18Size720to740countM)
        age19Size720to740M = WHERE((Age_Gro[Size720to740] EQ 19) AND (Sex_Gro[Size720to740] EQ 0), Age19Size720to740countM)
        age20Size720to740M = WHERE((Age_Gro[Size720to740] EQ 20) AND (Sex_Gro[Size720to740] EQ 0), Age20Size720to740countM)
        age21Size720to740M = WHERE((Age_Gro[Size720to740] EQ 21) AND (Sex_Gro[Size720to740] EQ 0), Age21Size720to740countM)
        age22Size720to740M = WHERE((Age_Gro[Size720to740] EQ 22) AND (Sex_Gro[Size720to740] EQ 0), Age22Size720to740countM)
        age23Size720to740M = WHERE((Age_Gro[Size720to740] EQ 23) AND (Sex_Gro[Size720to740] EQ 0), Age23Size720to740countM)
        age24Size720to740M = WHERE((Age_Gro[Size720to740] EQ 24) AND (Sex_Gro[Size720to740] EQ 0), Age24Size720to740countM)
        age25Size720to740M = WHERE((Age_Gro[Size720to740] EQ 25) AND (Sex_Gro[Size720to740] EQ 0), Age25Size720to740countM)
        age26Size720to740M = WHERE((Age_Gro[Size720to740] EQ 26) AND (Sex_Gro[Size720to740] EQ 0), Age26Size720to740countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+32L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+32L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+32L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+32L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+32L] = 720
        WAE_length_bin[42, i*NumLengthBin+adj+32L] = Size720to740countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+32L] = Age0Size720to740countM
        WAE_length_bin[44, i*NumLengthBin+adj+32L] = Age1Size720to740countM
        WAE_length_bin[45, i*NumLengthBin+adj+32L] = Age2Size720to740countM
        WAE_length_bin[46, i*NumLengthBin+adj+32L] = Age3Size720to740countM
        WAE_length_bin[47, i*NumLengthBin+adj+32L] = Age4Size720to740countM
        WAE_length_bin[48, i*NumLengthBin+adj+32L] = Age5Size720to740countM
        WAE_length_bin[49, i*NumLengthBin+adj+32L] = Age6Size720to740countM
        WAE_length_bin[50, i*NumLengthBin+adj+32L] = Age7Size720to740countM
        WAE_length_bin[51, i*NumLengthBin+adj+32L] = Age8Size720to740countM
        WAE_length_bin[52, i*NumLengthBin+adj+32L] = Age9Size720to740countM
        WAE_length_bin[53, i*NumLengthBin+adj+32L] = Age10Size720to740countM
        WAE_length_bin[54, i*NumLengthBin+adj+32L] = Age11Size720to740countM
        WAE_length_bin[55, i*NumLengthBin+adj+32L] = Age12Size720to740countM
        WAE_length_bin[56, i*NumLengthBin+adj+32L] = Age13Size720to740countM
        WAE_length_bin[57, i*NumLengthBin+adj+32L] = Age14Size720to740countM
        WAE_length_bin[58, i*NumLengthBin+adj+32L] = Age15Size720to740countM
        WAE_length_bin[59, i*NumLengthBin+adj+32L] = Age16Size720to740countM
        WAE_length_bin[60, i*NumLengthBin+adj+32L] = Age17Size720to740countM
        WAE_length_bin[61, i*NumLengthBin+adj+32L] = Age18Size720to740countM
        WAE_length_bin[62, i*NumLengthBin+adj+32L] = Age19Size720to740countM
        WAE_length_bin[63, i*NumLengthBin+adj+32L] = Age20Size720to740countM
        WAE_length_bin[64, i*NumLengthBin+adj+32L] = Age21Size720to740countM
        WAE_length_bin[65, i*NumLengthBin+adj+32L] = Age22Size720to740countM
        WAE_length_bin[66, i*NumLengthBin+adj+32L] = Age23Size720to740countM
        WAE_length_bin[67, i*NumLengthBin+adj+32L] = Age24Size720to740countM
        WAE_length_bin[68, i*NumLengthBin+adj+32L] = Age25Size720to740countM
        WAE_length_bin[69, i*NumLengthBin+adj+32L] = Age26Size720to740countM
      ENDIF
      PRINT, 'Size720to740M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+32L])
      
      ; length bin 34
      IF Size740to760count GT 0 THEN BEGIN
        age0Size740to760M = WHERE((Age_Gro[Size740to760] EQ 0) AND (Sex_Gro[Size740to760] EQ 0), Age0Size740to760countM)
        age1Size740to760M = WHERE((Age_Gro[Size740to760] EQ 1) AND (Sex_Gro[Size740to760] EQ 0), Age1Size740to760countM)
        age2Size740to760M = WHERE((Age_Gro[Size740to760] EQ 2) AND (Sex_Gro[Size740to760] EQ 0), Age2Size740to760countM)
        age3Size740to760M = WHERE((Age_Gro[Size740to760] EQ 3) AND (Sex_Gro[Size740to760] EQ 0), Age3Size740to760countM)
        age4Size740to760M = WHERE((Age_Gro[Size740to760] EQ 4) AND (Sex_Gro[Size740to760] EQ 0), Age4Size740to760countM)
        age5Size740to760M = WHERE((Age_Gro[Size740to760] EQ 5) AND (Sex_Gro[Size740to760] EQ 0), Age5Size740to760countM)
        age6Size740to760M = WHERE((Age_Gro[Size740to760] EQ 6) AND (Sex_Gro[Size740to760] EQ 0), Age6Size740to760countM)
        age7Size740to760M = WHERE((Age_Gro[Size740to760] EQ 7) AND (Sex_Gro[Size740to760] EQ 0), Age7Size740to760countM)
        age8Size740to760M = WHERE((Age_Gro[Size740to760] EQ 8) AND (Sex_Gro[Size740to760] EQ 0), Age8Size740to760countM)
        age9Size740to760M = WHERE((Age_Gro[Size740to760] EQ 9) AND (Sex_Gro[Size740to760] EQ 0), Age9Size740to760countM)
        age10Size740to760M = WHERE((Age_Gro[Size740to760] EQ 10) AND (Sex_Gro[Size740to760] EQ 0), Age10Size740to760countM)
        age11Size740to760M = WHERE((Age_Gro[Size740to760] EQ 11) AND (Sex_Gro[Size740to760] EQ 0), Age11Size740to760countM)
        AGE12Size740to760M = WHERE((Age_Gro[Size740to760] EQ 12) AND (Sex_Gro[Size740to760] EQ 0), Age12Size740to760countM)
        AGE13Size740to760M = WHERE((Age_Gro[Size740to760] EQ 13) AND (Sex_Gro[Size740to760] EQ 0), Age13Size740to760countM)
        AGE14Size740to760M = WHERE((Age_Gro[Size740to760] EQ 14) AND (Sex_Gro[Size740to760] EQ 0), Age14Size740to760countM)
        AGE15Size740to760M = WHERE((Age_Gro[Size740to760] EQ 15) AND (Sex_Gro[Size740to760] EQ 0), Age15Size740to760countM)
        age16Size740to760M = WHERE((Age_Gro[Size740to760] EQ 16) AND (Sex_Gro[Size740to760] EQ 0), Age16Size740to760countM)
        age17Size740to760M = WHERE((Age_Gro[Size740to760] EQ 17) AND (Sex_Gro[Size740to760] EQ 0), Age17Size740to760countM)
        age18Size740to760M = WHERE((Age_Gro[Size740to760] EQ 18) AND (Sex_Gro[Size740to760] EQ 0), Age18Size740to760countM)
        age19Size740to760M = WHERE((Age_Gro[Size740to760] EQ 19) AND (Sex_Gro[Size740to760] EQ 0), Age19Size740to760countM)
        age20Size740to760M = WHERE((Age_Gro[Size740to760] EQ 20) AND (Sex_Gro[Size740to760] EQ 0), Age20Size740to760countM)
        age21Size740to760M = WHERE((Age_Gro[Size740to760] EQ 21) AND (Sex_Gro[Size740to760] EQ 0), Age21Size740to760countM)
        age22Size740to760M = WHERE((Age_Gro[Size740to760] EQ 22) AND (Sex_Gro[Size740to760] EQ 0), Age22Size740to760countM)
        age23Size740to760M = WHERE((Age_Gro[Size740to760] EQ 23) AND (Sex_Gro[Size740to760] EQ 0), Age23Size740to760countM)
        age24Size740to760M = WHERE((Age_Gro[Size740to760] EQ 24) AND (Sex_Gro[Size740to760] EQ 0), Age24Size740to760countM)
        age25Size740to760M = WHERE((Age_Gro[Size740to760] EQ 25) AND (Sex_Gro[Size740to760] EQ 0), Age25Size740to760countM)
        age26Size740to760M = WHERE((Age_Gro[Size740to760] EQ 26) AND (Sex_Gro[Size740to760] EQ 0), Age26Size740to760countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+33L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+33L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+33L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+33L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+33L] = 740
        WAE_length_bin[42, i*NumLengthBin+adj+33L] = Size740to760countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+33L] = Age0Size740to760countM
        WAE_length_bin[44, i*NumLengthBin+adj+33L] = Age1Size740to760countM
        WAE_length_bin[45, i*NumLengthBin+adj+33L] = Age2Size740to760countM
        WAE_length_bin[46, i*NumLengthBin+adj+33L] = Age3Size740to760countM
        WAE_length_bin[47, i*NumLengthBin+adj+33L] = Age4Size740to760countM
        WAE_length_bin[48, i*NumLengthBin+adj+33L] = Age5Size740to760countM
        WAE_length_bin[49, i*NumLengthBin+adj+33L] = Age6Size740to760countM
        WAE_length_bin[50, i*NumLengthBin+adj+33L] = Age7Size740to760countM
        WAE_length_bin[51, i*NumLengthBin+adj+33L] = Age8Size740to760countM
        WAE_length_bin[52, i*NumLengthBin+adj+33L] = Age9Size740to760countM
        WAE_length_bin[53, i*NumLengthBin+adj+33L] = Age10Size740to760countM
        WAE_length_bin[54, i*NumLengthBin+adj+33L] = Age11Size740to760countM
        WAE_length_bin[55, i*NumLengthBin+adj+33L] = Age12Size740to760countM
        WAE_length_bin[56, i*NumLengthBin+adj+33L] = Age13Size740to760countM
        WAE_length_bin[57, i*NumLengthBin+adj+33L] = Age14Size740to760countM
        WAE_length_bin[58, i*NumLengthBin+adj+33L] = Age15Size740to760countM
        WAE_length_bin[59, i*NumLengthBin+adj+33L] = Age16Size740to760countM
        WAE_length_bin[60, i*NumLengthBin+adj+33L] = Age17Size740to760countM
        WAE_length_bin[61, i*NumLengthBin+adj+33L] = Age18Size740to760countM
        WAE_length_bin[62, i*NumLengthBin+adj+33L] = Age19Size740to760countM
        WAE_length_bin[63, i*NumLengthBin+adj+33L] = Age20Size740to760countM
        WAE_length_bin[64, i*NumLengthBin+adj+33L] = Age21Size740to760countM
        WAE_length_bin[65, i*NumLengthBin+adj+33L] = Age22Size740to760countM
        WAE_length_bin[66, i*NumLengthBin+adj+33L] = Age23Size740to760countM
        WAE_length_bin[67, i*NumLengthBin+adj+33L] = Age24Size740to760countM
        WAE_length_bin[68, i*NumLengthBin+adj+33L] = Age25Size740to760countM
        WAE_length_bin[69, i*NumLengthBin+adj+33L] = Age26Size740to760countM
      ENDIF
      PRINT, 'Size740to760M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+33L])
      
      ; legnth bin 35
      IF Size760to780count GT 0 THEN BEGIN
        age0Size760to780M = WHERE((Age_Gro[Size760to780] EQ 0) AND (Sex_Gro[Size760to780] EQ 0), Age0Size760to780countM)
        age1Size760to780M = WHERE((Age_Gro[Size760to780] EQ 1) AND (Sex_Gro[Size760to780] EQ 0), Age1Size760to780countM)
        age2Size760to780M = WHERE((Age_Gro[Size760to780] EQ 2) AND (Sex_Gro[Size760to780] EQ 0), Age2Size760to780countM)
        age3Size760to780M = WHERE((Age_Gro[Size760to780] EQ 3) AND (Sex_Gro[Size760to780] EQ 0), Age3Size760to780countM)
        age4Size760to780M = WHERE((Age_Gro[Size760to780] EQ 4) AND (Sex_Gro[Size760to780] EQ 0), Age4Size760to780countM)
        age5Size760to780M = WHERE((Age_Gro[Size760to780] EQ 5) AND (Sex_Gro[Size760to780] EQ 0), Age5Size760to780countM)
        age6Size760to780M = WHERE((Age_Gro[Size760to780] EQ 6) AND (Sex_Gro[Size760to780] EQ 0), Age6Size760to780countM)
        age7Size760to780M = WHERE((Age_Gro[Size760to780] EQ 7) AND (Sex_Gro[Size760to780] EQ 0), Age7Size760to780countM)
        age8Size760to780M = WHERE((Age_Gro[Size760to780] EQ 8) AND (Sex_Gro[Size760to780] EQ 0), Age8Size760to780countM)
        age9Size760to780M = WHERE((Age_Gro[Size760to780] EQ 9) AND (Sex_Gro[Size760to780] EQ 0), Age9Size760to780countM)
        age10Size760to780M = WHERE((Age_Gro[Size760to780] EQ 10) AND (Sex_Gro[Size760to780] EQ 0), Age10Size760to780countM)
        age11Size760to780M = WHERE((Age_Gro[Size760to780] EQ 11) AND (Sex_Gro[Size760to780] EQ 0), Age11Size760to780countM)
        AGE12Size760to780M = WHERE((Age_Gro[Size760to780] EQ 12) AND (Sex_Gro[Size760to780] EQ 0), Age12Size760to780countM)
        AGE13Size760to780M = WHERE((Age_Gro[Size760to780] EQ 13) AND (Sex_Gro[Size760to780] EQ 0), Age13Size760to780countM)
        AGE14Size760to780M = WHERE((Age_Gro[Size760to780] EQ 14) AND (Sex_Gro[Size760to780] EQ 0), Age14Size760to780countM)
        AGE15Size760to780M = WHERE((Age_Gro[Size760to780] EQ 15) AND (Sex_Gro[Size760to780] EQ 0), Age15Size760to780countM)
        age16Size760to780M = WHERE((Age_Gro[Size760to780] EQ 16) AND (Sex_Gro[Size760to780] EQ 0), Age16Size760to780countM)
        age17Size760to780M = WHERE((Age_Gro[Size760to780] EQ 17) AND (Sex_Gro[Size760to780] EQ 0), Age17Size760to780countM)
        age18Size760to780M = WHERE((Age_Gro[Size760to780] EQ 18) AND (Sex_Gro[Size760to780] EQ 0), Age18Size760to780countM)
        age19Size760to780M = WHERE((Age_Gro[Size760to780] EQ 19) AND (Sex_Gro[Size760to780] EQ 0), Age19Size760to780countM)
        age20Size760to780M = WHERE((Age_Gro[Size760to780] EQ 20) AND (Sex_Gro[Size760to780] EQ 0), Age20Size760to780countM)
        age21Size760to780M = WHERE((Age_Gro[Size760to780] EQ 21) AND (Sex_Gro[Size760to780] EQ 0), Age21Size760to780countM)
        age22Size760to780M = WHERE((Age_Gro[Size760to780] EQ 22) AND (Sex_Gro[Size760to780] EQ 0), Age22Size760to780countM)
        age23Size760to780M = WHERE((Age_Gro[Size760to780] EQ 23) AND (Sex_Gro[Size760to780] EQ 0), Age23Size760to780countM)
        age24Size760to780M = WHERE((Age_Gro[Size760to780] EQ 24) AND (Sex_Gro[Size760to780] EQ 0), Age24Size760to780countM)
        age25Size760to780M = WHERE((Age_Gro[Size760to780] EQ 25) AND (Sex_Gro[Size760to780] EQ 0), Age25Size760to780countM)
        age26Size760to780M = WHERE((Age_Gro[Size760to780] EQ 26) AND (Sex_Gro[Size760to780] EQ 0), Age26Size760to780countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+34L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+34L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+34L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+34L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+34L] = 760
        WAE_length_bin[42, i*NumLengthBin+adj+34L] = Size760to780countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+34L] = Age0Size760to780countM
        WAE_length_bin[44, i*NumLengthBin+adj+34L] = Age1Size760to780countM
        WAE_length_bin[45, i*NumLengthBin+adj+34L] = Age2Size760to780countM
        WAE_length_bin[46, i*NumLengthBin+adj+34L] = Age3Size760to780countM
        WAE_length_bin[47, i*NumLengthBin+adj+34L] = Age4Size760to780countM
        WAE_length_bin[48, i*NumLengthBin+adj+34L] = Age5Size760to780countM
        WAE_length_bin[49, i*NumLengthBin+adj+34L] = Age6Size760to780countM
        WAE_length_bin[50, i*NumLengthBin+adj+34L] = Age7Size760to780countM
        WAE_length_bin[51, i*NumLengthBin+adj+34L] = Age8Size760to780countM
        WAE_length_bin[52, i*NumLengthBin+adj+34L] = Age9Size760to780countM
        WAE_length_bin[53, i*NumLengthBin+adj+34L] = Age10Size760to780countM
        WAE_length_bin[54, i*NumLengthBin+adj+34L] = Age11Size760to780countM
        WAE_length_bin[55, i*NumLengthBin+adj+34L] = Age12Size760to780countM
        WAE_length_bin[56, i*NumLengthBin+adj+34L] = Age13Size760to780countM
        WAE_length_bin[57, i*NumLengthBin+adj+34L] = Age14Size760to780countM
        WAE_length_bin[58, i*NumLengthBin+adj+34L] = Age15Size760to780countM
        WAE_length_bin[59, i*NumLengthBin+adj+34L] = Age16Size760to780countM
        WAE_length_bin[60, i*NumLengthBin+adj+34L] = Age17Size760to780countM
        WAE_length_bin[61, i*NumLengthBin+adj+34L] = Age18Size760to780countM
        WAE_length_bin[62, i*NumLengthBin+adj+34L] = Age19Size760to780countM
        WAE_length_bin[63, i*NumLengthBin+adj+34L] = Age20Size760to780countM
        WAE_length_bin[64, i*NumLengthBin+adj+34L] = Age21Size760to780countM
        WAE_length_bin[65, i*NumLengthBin+adj+34L] = Age22Size760to780countM
        WAE_length_bin[66, i*NumLengthBin+adj+34L] = Age23Size760to780countM
        WAE_length_bin[67, i*NumLengthBin+adj+34L] = Age24Size760to780countM
        WAE_length_bin[68, i*NumLengthBin+adj+34L] = Age25Size760to780countM
        WAE_length_bin[69, i*NumLengthBin+adj+34L] = Age26Size760to780countM
      ENDIF
      PRINT, 'Size760to780M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+34L])
      
      ; length bin 36
      IF Size780to800count GT 0 THEN BEGIN
        age0Size780to800M = WHERE((Age_Gro[Size780to800] EQ 0) AND (Sex_Gro[Size780to800] EQ 0), Age0Size780to800countM)
        age1Size780to800M = WHERE((Age_Gro[Size780to800] EQ 1) AND (Sex_Gro[Size780to800] EQ 0), Age1Size780to800countM)
        age2Size780to800M = WHERE((Age_Gro[Size780to800] EQ 2) AND (Sex_Gro[Size780to800] EQ 0), Age2Size780to800countM)
        age3Size780to800M = WHERE((Age_Gro[Size780to800] EQ 3) AND (Sex_Gro[Size780to800] EQ 0), Age3Size780to800countM)
        age4Size780to800M = WHERE((Age_Gro[Size780to800] EQ 4) AND (Sex_Gro[Size780to800] EQ 0), Age4Size780to800countM)
        age5Size780to800M = WHERE((Age_Gro[Size780to800] EQ 5) AND (Sex_Gro[Size780to800] EQ 0), Age5Size780to800countM)
        age6Size780to800M = WHERE((Age_Gro[Size780to800] EQ 6) AND (Sex_Gro[Size780to800] EQ 0), Age6Size780to800countM)
        age7Size780to800M = WHERE((Age_Gro[Size780to800] EQ 7) AND (Sex_Gro[Size780to800] EQ 0), Age7Size780to800countM)
        age8Size780to800M = WHERE((Age_Gro[Size780to800] EQ 8) AND (Sex_Gro[Size780to800] EQ 0), Age8Size780to800countM)
        age9Size780to800M = WHERE((Age_Gro[Size780to800] EQ 9) AND (Sex_Gro[Size780to800] EQ 0), Age9Size780to800countM)
        age10Size780to800M = WHERE((Age_Gro[Size780to800] EQ 10) AND (Sex_Gro[Size780to800] EQ 0), Age10Size780to800countM)
        age11Size780to800M = WHERE((Age_Gro[Size780to800] EQ 11) AND (Sex_Gro[Size780to800] EQ 0), Age11Size780to800countM)
        AGE12Size780to800M = WHERE((Age_Gro[Size780to800] EQ 12) AND (Sex_Gro[Size780to800] EQ 0), Age12Size780to800countM)
        AGE13Size780to800M = WHERE((Age_Gro[Size780to800] EQ 13) AND (Sex_Gro[Size780to800] EQ 0), Age13Size780to800countM)
        AGE14Size780to800M = WHERE((Age_Gro[Size780to800] EQ 14) AND (Sex_Gro[Size780to800] EQ 0), Age14Size780to800countM)
        AGE15Size780to800M = WHERE((Age_Gro[Size780to800] EQ 15) AND (Sex_Gro[Size780to800] EQ 0), Age15Size780to800countM)
        age16Size780to800M = WHERE((Age_Gro[Size780to800] EQ 16) AND (Sex_Gro[Size780to800] EQ 0), Age16Size780to800countM)
        age17Size780to800M = WHERE((Age_Gro[Size780to800] EQ 17) AND (Sex_Gro[Size780to800] EQ 0), Age17Size780to800countM)
        age18Size780to800M = WHERE((Age_Gro[Size780to800] EQ 18) AND (Sex_Gro[Size780to800] EQ 0), Age18Size780to800countM)
        age19Size780to800M = WHERE((Age_Gro[Size780to800] EQ 19) AND (Sex_Gro[Size780to800] EQ 0), Age19Size780to800countM)
        age20Size780to800M = WHERE((Age_Gro[Size780to800] EQ 20) AND (Sex_Gro[Size780to800] EQ 0), Age20Size780to800countM)
        age21Size780to800M = WHERE((Age_Gro[Size780to800] EQ 21) AND (Sex_Gro[Size780to800] EQ 0), Age21Size780to800countM)
        age22Size780to800M = WHERE((Age_Gro[Size780to800] EQ 22) AND (Sex_Gro[Size780to800] EQ 0), Age22Size780to800countM)
        age23Size780to800M = WHERE((Age_Gro[Size780to800] EQ 23) AND (Sex_Gro[Size780to800] EQ 0), Age23Size780to800countM)
        age24Size780to800M = WHERE((Age_Gro[Size780to800] EQ 24) AND (Sex_Gro[Size780to800] EQ 0), Age24Size780to800countM)
        age25Size780to800M = WHERE((Age_Gro[Size780to800] EQ 25) AND (Sex_Gro[Size780to800] EQ 0), Age25Size780to800countM)
        age26Size780to800M = WHERE((Age_Gro[Size780to800] EQ 26) AND (Sex_Gro[Size780to800] EQ 0), Age26Size780to800countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+35L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+35L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+35L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+35L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+35L] = 780
        WAE_length_bin[42, i*NumLengthBin+adj+35L] = Size780to800countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+35L] = Age0Size780to800countM
        WAE_length_bin[44, i*NumLengthBin+adj+35L] = Age1Size780to800countM
        WAE_length_bin[45, i*NumLengthBin+adj+35L] = Age2Size780to800countM
        WAE_length_bin[46, i*NumLengthBin+adj+35L] = Age3Size780to800countM
        WAE_length_bin[47, i*NumLengthBin+adj+35L] = Age4Size780to800countM
        WAE_length_bin[48, i*NumLengthBin+adj+35L] = Age5Size780to800countM
        WAE_length_bin[49, i*NumLengthBin+adj+35L] = Age6Size780to800countM
        WAE_length_bin[50, i*NumLengthBin+adj+35L] = Age7Size780to800countM
        WAE_length_bin[51, i*NumLengthBin+adj+35L] = Age8Size780to800countM
        WAE_length_bin[52, i*NumLengthBin+adj+35L] = Age9Size780to800countM
        WAE_length_bin[53, i*NumLengthBin+adj+35L] = Age10Size780to800countM
        WAE_length_bin[54, i*NumLengthBin+adj+35L] = Age11Size780to800countM
        WAE_length_bin[55, i*NumLengthBin+adj+35L] = Age12Size780to800countM
        WAE_length_bin[56, i*NumLengthBin+adj+35L] = Age13Size780to800countM
        WAE_length_bin[57, i*NumLengthBin+adj+35L] = Age14Size780to800countM
        WAE_length_bin[58, i*NumLengthBin+adj+35L] = Age15Size780to800countM
        WAE_length_bin[59, i*NumLengthBin+adj+35L] = Age16Size780to800countM
        WAE_length_bin[60, i*NumLengthBin+adj+35L] = Age17Size780to800countM
        WAE_length_bin[61, i*NumLengthBin+adj+35L] = Age18Size780to800countM
        WAE_length_bin[62, i*NumLengthBin+adj+35L] = Age19Size780to800countM
        WAE_length_bin[63, i*NumLengthBin+adj+35L] = Age20Size780to800countM
        WAE_length_bin[64, i*NumLengthBin+adj+35L] = Age21Size780to800countM
        WAE_length_bin[65, i*NumLengthBin+adj+35L] = Age22Size780to800countM
        WAE_length_bin[66, i*NumLengthBin+adj+35L] = Age23Size780to800countM
        WAE_length_bin[67, i*NumLengthBin+adj+35L] = Age24Size780to800countM
        WAE_length_bin[68, i*NumLengthBin+adj+35L] = Age25Size780to800countM
        WAE_length_bin[69, i*NumLengthBin+adj+35L] = Age26Size780to800countM
      ENDIF
      PRINT, 'Size780to800M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+35L])
      
      
      ; length bin 37
      IF SizeGE800count GT 0 THEN BEGIN
        age0SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 0) AND (Sex_Gro[SizeGE800] EQ 0), Age0SizeGE800countM)
        age1SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 1) AND (Sex_Gro[SizeGE800] EQ 0), Age1SizeGE800countM)
        age2SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 2) AND (Sex_Gro[SizeGE800] EQ 0), Age2SizeGE800countM)
        age3SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 3) AND (Sex_Gro[SizeGE800] EQ 0), Age3SizeGE800countM)
        age4SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 4) AND (Sex_Gro[SizeGE800] EQ 0), Age4SizeGE800countM)
        age5SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 5) AND (Sex_Gro[SizeGE800] EQ 0), Age5SizeGE800countM)
        age6SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 6) AND (Sex_Gro[SizeGE800] EQ 0), Age6SizeGE800countM)
        age7SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 7) AND (Sex_Gro[SizeGE800] EQ 0), Age7SizeGE800countM)
        age8SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 8) AND (Sex_Gro[SizeGE800] EQ 0), Age8SizeGE800countM)
        age9SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 9) AND (Sex_Gro[SizeGE800] EQ 0), Age9SizeGE800countM)
        age10SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 10) AND (Sex_Gro[SizeGE800] EQ 0), Age10SizeGE800countM)
        age11SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 11) AND (Sex_Gro[SizeGE800] EQ 0), Age11SizeGE800countM)
        AGE12SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 12) AND (Sex_Gro[SizeGE800] EQ 0), Age12SizeGE800countM)
        AGE13SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 13) AND (Sex_Gro[SizeGE800] EQ 0), Age13SizeGE800countM)
        AGE14SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 14) AND (Sex_Gro[SizeGE800] EQ 0), Age14SizeGE800countM)
        AGE15SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 15) AND (Sex_Gro[SizeGE800] EQ 0), Age15SizeGE800countM)
        age16SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 16) AND (Sex_Gro[SizeGE800] EQ 0), Age16SizeGE800countM)
        age17SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 17) AND (Sex_Gro[SizeGE800] EQ 0), Age17SizeGE800countM)
        age18SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 18) AND (Sex_Gro[SizeGE800] EQ 0), Age18SizeGE800countM)
        age19SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 19) AND (Sex_Gro[SizeGE800] EQ 0), Age19SizeGE800countM)
        age20SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 20) AND (Sex_Gro[SizeGE800] EQ 0), Age20SizeGE800countM)
        age21SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 21) AND (Sex_Gro[SizeGE800] EQ 0), Age21SizeGE800countM)
        age22SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 22) AND (Sex_Gro[SizeGE800] EQ 0), Age22SizeGE800countM)
        age23SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 23) AND (Sex_Gro[SizeGE800] EQ 0), Age23SizeGE800countM)
        age24SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 24) AND (Sex_Gro[SizeGE800] EQ 0), Age24SizeGE800countM)
        age25SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 25) AND (Sex_Gro[SizeGE800] EQ 0), Age25SizeGE800countM)
        age26SizeGE800M = WHERE((Age_Gro[SizeGE800] EQ 26) AND (Sex_Gro[SizeGE800] EQ 0), Age26SizeGE800countM)
      
        WAE_length_bin[37, i*NumLengthBin+adj+36L] = Max(length[INDEX_growthdata[male]])
        WAE_length_bin[38, i*NumLengthBin+adj+36L] = Min(length[INDEX_growthdata[male]])
        WAE_length_bin[39, i*NumLengthBin+adj+36L] = Max(age[INDEX_growthdata[male]])
        WAE_length_bin[40, i*NumLengthBin+adj+36L] = Min(age[INDEX_growthdata[male]])
        WAE_length_bin[41, i*NumLengthBin+adj+36L] = 800
        WAE_length_bin[42, i*NumLengthBin+adj+36L] = SizeGE800countM
      
        WAE_length_bin[43, i*NumLengthBin+adj+36L] = Age0SizeGE800countM
        WAE_length_bin[44, i*NumLengthBin+adj+36L] = Age1SizeGE800countM
        WAE_length_bin[45, i*NumLengthBin+adj+36L] = Age2SizeGE800countM
        WAE_length_bin[46, i*NumLengthBin+adj+36L] = Age3SizeGE800countM
        WAE_length_bin[47, i*NumLengthBin+adj+36L] = Age4SizeGE800countM
        WAE_length_bin[48, i*NumLengthBin+adj+36L] = Age5SizeGE800countM
        WAE_length_bin[49, i*NumLengthBin+adj+36L] = Age6SizeGE800countM
        WAE_length_bin[50, i*NumLengthBin+adj+36L] = Age7SizeGE800countM
        WAE_length_bin[51, i*NumLengthBin+adj+36L] = Age8SizeGE800countM
        WAE_length_bin[52, i*NumLengthBin+adj+36L] = Age9SizeGE800countM
        WAE_length_bin[53, i*NumLengthBin+adj+36L] = Age10SizeGE800countM
        WAE_length_bin[54, i*NumLengthBin+adj+36L] = Age11SizeGE800countM
        WAE_length_bin[55, i*NumLengthBin+adj+36L] = Age12SizeGE800countM
        WAE_length_bin[56, i*NumLengthBin+adj+36L] = Age13SizeGE800countM
        WAE_length_bin[57, i*NumLengthBin+adj+36L] = Age14SizeGE800countM
        WAE_length_bin[58, i*NumLengthBin+adj+36L] = Age15SizeGE800countM
        WAE_length_bin[59, i*NumLengthBin+adj+36L] = Age16SizeGE800countM
        WAE_length_bin[60, i*NumLengthBin+adj+36L] = Age17SizeGE800countM
        WAE_length_bin[61, i*NumLengthBin+adj+36L] = Age18SizeGE800countM
        WAE_length_bin[62, i*NumLengthBin+adj+36L] = Age19SizeGE800countM
        WAE_length_bin[63, i*NumLengthBin+adj+36L] = Age20SizeGE800countM
        WAE_length_bin[64, i*NumLengthBin+adj+36L] = Age21SizeGE800countM
        WAE_length_bin[65, i*NumLengthBin+adj+36L] = Age22SizeGE800countM
        WAE_length_bin[66, i*NumLengthBin+adj+36L] = Age23SizeGE800countM
        WAE_length_bin[67, i*NumLengthBin+adj+36L] = Age24SizeGE800countM
        WAE_length_bin[68, i*NumLengthBin+adj+36L] = Age25SizeGE800countM
        WAE_length_bin[69, i*NumLengthBin+adj+36L] = Age26SizeGE800countM
      ENDIF
      PRINT, 'SizeGE800M', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj+36L])
      PRINT, 'Total N of fish', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
      
      
      
      
      ;***FEMALES***
      ; Length group distributions - all fish - female
      SizeLT100F = WHERE((Sex_Gro EQ 1L) AND Length_Gro LT 100, SizeLT100countF)
      Size100to120F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 100) AND (Length_Gro LT 120), Size100to120countF)
      Size120to140F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 120) AND (Length_Gro LT 140), Size120to140countF)
      Size140to160F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 140) AND (Length_Gro LT 160), Size140to160countF)
      Size160to180F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 160) AND (Length_Gro LT 180), Size160to180countF)
      Size180to200F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 180) AND (Length_Gro LT 200), Size180to200countF)
      Size200to220F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 200) AND (Length_Gro LT 220), Size200to220countF)
      Size220to240F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 220) AND (Length_Gro LT 240), Size220to240countF)
      Size240to260F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 240) AND (Length_Gro LT 260), Size240to260countF)
      Size260to280F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 260) AND (Length_Gro LT 280), Size260to280countF)
      Size280to300F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 280) AND (Length_Gro LT 300), Size280to300countF)
      Size300to320F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 300) AND (Length_Gro LT 320), Size300to320countF)
      Size320to340F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 320) AND (Length_Gro LT 340), Size320to340countF)
      Size340to360F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 340) AND (Length_Gro LT 360), Size340to360countF)
      Size360to380F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 360) AND (Length_Gro LT 380), Size360to380countF)
      Size380to400F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 380) AND (Length_Gro LT 400), Size380to400countF)
      Size400to420F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 400) AND (Length_Gro LT 420), Size400to420countF)
      Size420to440F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 420) AND (Length_Gro LT 440), Size420to440countF)
      Size440to460F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 440) AND (Length_Gro LT 460), Size440to460countF)
      Size460to480F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 460) AND (Length_Gro LT 480), Size460to480countF)
      Size480to500F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 480) AND (Length_Gro LT 500), Size480to500countF)
      Size500to520F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 500) AND (Length_Gro LT 520), Size500to520countF)
      Size520to540F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 520) AND (Length_Gro LT 540), Size520to540countF)
      Size540to560F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 540) AND (Length_Gro LT 560), Size540to560countF)
      Size560to580F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 560) AND (Length_Gro LT 580), Size560to580countF)
      Size580to600F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 580) AND (Length_Gro LT 600), Size580to600countF)
      Size600to620F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 600) AND (Length_Gro LT 620), Size600to620countF)
      Size620to640F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 620) AND (Length_Gro LT 640), Size620to640countF)
      Size640to660F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 640) AND (Length_Gro LT 660), Size640to660countF)
      Size660to680F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 660) AND (Length_Gro LT 680), Size660to680countF)
      Size680to700F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 680) AND (Length_Gro LT 700), Size680to700countF)
      Size700to720F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 700) AND (Length_Gro LT 720), Size700to720countF)
      Size720to740F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 720) AND (Length_Gro LT 740), Size720to740countF)
      Size740to760F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 740) AND (Length_Gro LT 760), Size740to760countF)
      Size760to780F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 760) AND (Length_Gro LT 780), Size760to780countF)
      Size780to800F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 780) AND (Length_Gro LT 800), Size780to800countF)
      SizeGE800F = WHERE((Sex_Gro EQ 1L) AND (Length_Gro GE 800), SizeGE800countF)
      
      
      ;IF Size100to120count GT 0 THEN BEGIN
      IF SizeLT100countF GT 0 THEN paramset[3, i] = SizeLT100countF
      IF Size100to120countF GT 0 THEN paramset[4, i] = Size100to120countF
      IF Size120to140countF GT 0 THEN paramset[5, i] = Size120to140countF
      IF Size140to160countF GT 0 THEN paramset[6, i] = Size140to160countF
      IF Size160to180countF GT 0 THEN paramset[7, i] = Size160to180countF
      IF Size180to200countF GT 0 THEN paramset[8, i] = Size180to200countF
      IF Size200to220countF GT 0 THEN paramset[9, i] = Size200to220countF
      IF Size220to240countF GT 0 THEN paramset[10, i] = Size220to240countF
      IF Size240to260countF GT 0 THEN paramset[11, i] = Size240to260countF
      IF Size260to280countF GT 0 THEN paramset[12, i] = Size260to280countF
      IF Size280to300countF GT 0 THEN paramset[13, i] = Size280to300countF
      IF Size300to320countF GT 0 THEN paramset[14, i] = Size300to320countF
      IF Size320to340countF GT 0 THEN paramset[15, i] = Size320to340countF
      IF Size340to360countF GT 0 THEN paramset[16, i] = Size340to360countF
      IF Size360to380countF GT 0 THEN paramset[17, i] = Size360to380countF
      IF Size380to400countF GT 0 THEN paramset[18, i] = Size380to400countF
      IF Size400to420countF GT 0 THEN paramset[19, i] = Size400to420countF
      IF Size420to440countF GT 0 THEN paramset[20, i] = Size420to440countF
      IF Size440to460countF GT 0 THEN paramset[21, i] = Size440to460countF
      IF Size460to480countF GT 0 THEN paramset[22, i] = Size460to480countF
      IF Size480to500countF GT 0 THEN paramset[23, i] = Size480to500countF
      IF Size500to520countF GT 0 THEN paramset[24, i] = Size500to520countF
      IF Size520to540countF GT 0 THEN paramset[25, i] = Size520to540countF
      IF Size540to560countF GT 0 THEN paramset[26, i] = Size540to560countF
      IF Size560to580countF GT 0 THEN paramset[27, i] = Size560to580countF
      IF Size580to600countF GT 0 THEN paramset[28, i] = Size580to600countF
      IF Size600to620countF GT 0 THEN paramset[29, i] = Size600to620countF
      IF Size620to640countF GT 0 THEN paramset[30, i] = Size620to640countF
      IF Size640to660countF GT 0 THEN paramset[31, i] = Size640to660countF
      IF Size660to680countF GT 0 THEN paramset[32, i] = Size660to680countF
      IF Size680to700countF GT 0 THEN paramset[33, i] = Size680to700countF
      IF Size700to720countF GT 0 THEN paramset[34, i] = Size700to720countF
      IF Size720to740countF GT 0 THEN paramset[35, i] = Size720to740countF
      IF Size740to760countF GT 0 THEN paramset[36, i] = Size740to760countF
      IF Size760to780countF GT 0 THEN paramset[37, i] = Size760to780countF
      IF Size780to800countF GT 0 THEN paramset[38, i] = Size780to800countF
      IF SizeGE800countF GT 0 THEN paramset[39, i] = SizeGE800countF
      
      ; length bin 1
      IF SizeLT100count GT 0 THEN BEGIN
        age0SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 0) AND (Sex_Gro[SizeLT100] EQ 1), Age0SizeLT100countF)
        age1SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 1) AND (Sex_Gro[SizeLT100] EQ 1), Age1SizeLT100countF)
        age2SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 2) AND (Sex_Gro[SizeLT100] EQ 1), Age2SizeLT100countF)
        age3SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 3) AND (Sex_Gro[SizeLT100] EQ 1), Age3SizeLT100countF)
        age4SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 4) AND (Sex_Gro[SizeLT100] EQ 1), Age4SizeLT100countF)
        age5SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 5) AND (Sex_Gro[SizeLT100] EQ 1), Age5SizeLT100countF)
        age6SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 6) AND (Sex_Gro[SizeLT100] EQ 1), Age6SizeLT100countF)
        age7SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 7) AND (Sex_Gro[SizeLT100] EQ 1), Age7SizeLT100countF)
        age8SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 8) AND (Sex_Gro[SizeLT100] EQ 1), Age8SizeLT100countF)
        age9SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 9) AND (Sex_Gro[SizeLT100] EQ 1), Age9SizeLT100countF)
        age10SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 10) AND (Sex_Gro[SizeLT100] EQ 1), Age10SizeLT100countF)
        age11SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 11) AND (Sex_Gro[SizeLT100] EQ 1), Age11SizeLT100countF)
        AGE12SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 12) AND (Sex_Gro[SizeLT100] EQ 1), Age12SizeLT100countF)
        AGE13SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 13) AND (Sex_Gro[SizeLT100] EQ 1), Age13SizeLT100countF)
        AGE14SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 14) AND (Sex_Gro[SizeLT100] EQ 1), Age14SizeLT100countF)
        AGE15SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 15) AND (Sex_Gro[SizeLT100] EQ 1), Age15SizeLT100countF)
        age16SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 16) AND (Sex_Gro[SizeLT100] EQ 1), Age16SizeLT100countF)
        age17SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 17) AND (Sex_Gro[SizeLT100] EQ 1), Age17SizeLT100countF)
        age18SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 18) AND (Sex_Gro[SizeLT100] EQ 1), Age18SizeLT100countF)
        age19SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 19) AND (Sex_Gro[SizeLT100] EQ 1), Age19SizeLT100countF)
        age20SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 20) AND (Sex_Gro[SizeLT100] EQ 1), Age20SizeLT100countF)
        age21SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 21) AND (Sex_Gro[SizeLT100] EQ 1), Age21SizeLT100countF)
        age22SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 22) AND (Sex_Gro[SizeLT100] EQ 1), Age22SizeLT100countF)
        age23SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 23) AND (Sex_Gro[SizeLT100] EQ 1), Age23SizeLT100countF)
        age24SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 24) AND (Sex_Gro[SizeLT100] EQ 1), Age24SizeLT100countF)
        age25SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 25) AND (Sex_Gro[SizeLT100] EQ 1), Age25SizeLT100countF)
        age26SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 26) AND (Sex_Gro[SizeLT100] EQ 1), Age26SizeLT100countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj] = 99
        WAE_length_bin[75, i*NumLengthBin+adj] = SizeLT100countF
      
        WAE_length_bin[76, i*NumLengthBin+adj] = Age0SizeLT100countF
        WAE_length_bin[77, i*NumLengthBin+adj] = Age1SizeLT100countF
        WAE_length_bin[78, i*NumLengthBin+adj] = Age2SizeLT100countF
        WAE_length_bin[79, i*NumLengthBin+adj] = Age3SizeLT100countF
        WAE_length_bin[80, i*NumLengthBin+adj] = Age4SizeLT100countF
        WAE_length_bin[81, i*NumLengthBin+adj] = Age5SizeLT100countF
        WAE_length_bin[82, i*NumLengthBin+adj] = Age6SizeLT100countF
        WAE_length_bin[83, i*NumLengthBin+adj] = Age7SizeLT100countF
        WAE_length_bin[84, i*NumLengthBin+adj] = Age8SizeLT100countF
        WAE_length_bin[85, i*NumLengthBin+adj] = Age9SizeLT100countF
        WAE_length_bin[86, i*NumLengthBin+adj] = Age10SizeLT100countF
        WAE_length_bin[87, i*NumLengthBin+adj] = Age11SizeLT100countF
        WAE_length_bin[88, i*NumLengthBin+adj] = Age12SizeLT100countF
        WAE_length_bin[89, i*NumLengthBin+adj] = Age13SizeLT100countF
        WAE_length_bin[90, i*NumLengthBin+adj] = Age14SizeLT100countF
        WAE_length_bin[91, i*NumLengthBin+adj] = Age15SizeLT100countF
        WAE_length_bin[92, i*NumLengthBin+adj] = Age16SizeLT100countF
        WAE_length_bin[93, i*NumLengthBin+adj] = Age17SizeLT100countF
        WAE_length_bin[94, i*NumLengthBin+adj] = Age18SizeLT100countF
        WAE_length_bin[95, i*NumLengthBin+adj] = Age19SizeLT100countF
        WAE_length_bin[96, i*NumLengthBin+adj] = Age20SizeLT100countF
        WAE_length_bin[97, i*NumLengthBin+adj] = Age21SizeLT100countF
        WAE_length_bin[98, i*NumLengthBin+adj] = Age22SizeLT100countF
        WAE_length_bin[99, i*NumLengthBin+adj] = Age23SizeLT100countF
        WAE_length_bin[100, i*NumLengthBin+adj] = Age24SizeLT100countF
        WAE_length_bin[101, i*NumLengthBin+adj] = Age25SizeLT100countF
        WAE_length_bin[102, i*NumLengthBin+adj] = Age26SizeLT100countF
      ENDIF
      PRINT, 'SizeLT100F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj])
      
      
      ; length bin 2
      IF Size100to120count GT 0 THEN BEGIN
        age0Size100to120F = WHERE((Age_Gro[Size100to120] EQ 0) AND (Sex_Gro[Size100to120] EQ 1), Age0Size100to120countF)
        age1Size100to120F = WHERE((Age_Gro[Size100to120] EQ 1) AND (Sex_Gro[Size100to120] EQ 1), Age1Size100to120countF)
        age2Size100to120F = WHERE((Age_Gro[Size100to120] EQ 2) AND (Sex_Gro[Size100to120] EQ 1), Age2Size100to120countF)
        age3Size100to120F = WHERE((Age_Gro[Size100to120] EQ 3) AND (Sex_Gro[Size100to120] EQ 1), Age3Size100to120countF)
        age4Size100to120F = WHERE((Age_Gro[Size100to120] EQ 4) AND (Sex_Gro[Size100to120] EQ 1), Age4Size100to120countF)
        age5Size100to120F = WHERE((Age_Gro[Size100to120] EQ 5) AND (Sex_Gro[Size100to120] EQ 1), Age5Size100to120countF)
        age6Size100to120F = WHERE((Age_Gro[Size100to120] EQ 6) AND (Sex_Gro[Size100to120] EQ 1), Age6Size100to120countF)
        age7Size100to120F = WHERE((Age_Gro[Size100to120] EQ 7) AND (Sex_Gro[Size100to120] EQ 1), Age7Size100to120countF)
        age8Size100to120F = WHERE((Age_Gro[Size100to120] EQ 8) AND (Sex_Gro[Size100to120] EQ 1), Age8Size100to120countF)
        age9Size100to120F = WHERE((Age_Gro[Size100to120] EQ 9) AND (Sex_Gro[Size100to120] EQ 1), Age9Size100to120countF)
        age10Size100to120F = WHERE((Age_Gro[Size100to120] EQ 10) AND (Sex_Gro[Size100to120] EQ 1), Age10Size100to120countF)
        age11Size100to120F = WHERE((Age_Gro[Size100to120] EQ 11) AND (Sex_Gro[Size100to120] EQ 1), Age11Size100to120countF)
        AGE12Size100to120F = WHERE((Age_Gro[Size100to120] EQ 12) AND (Sex_Gro[Size100to120] EQ 1), Age12Size100to120countF)
        AGE13Size100to120F = WHERE((Age_Gro[Size100to120] EQ 13) AND (Sex_Gro[Size100to120] EQ 1), Age13Size100to120countF)
        AGE14Size100to120F = WHERE((Age_Gro[Size100to120] EQ 14) AND (Sex_Gro[Size100to120] EQ 1), Age14Size100to120countF)
        AGE15Size100to120F = WHERE((Age_Gro[Size100to120] EQ 15) AND (Sex_Gro[Size100to120] EQ 1), Age15Size100to120countF)
        age16Size100to120F = WHERE((Age_Gro[Size100to120] EQ 16) AND (Sex_Gro[Size100to120] EQ 1), Age16Size100to120countF)
        age17Size100to120F = WHERE((Age_Gro[Size100to120] EQ 17) AND (Sex_Gro[Size100to120] EQ 1), Age17Size100to120countF)
        age18Size100to120F = WHERE((Age_Gro[Size100to120] EQ 18) AND (Sex_Gro[Size100to120] EQ 1), Age18Size100to120countF)
        age19Size100to120F = WHERE((Age_Gro[Size100to120] EQ 19) AND (Sex_Gro[Size100to120] EQ 1), Age19Size100to120countF)
        age20Size100to120F = WHERE((Age_Gro[Size100to120] EQ 20) AND (Sex_Gro[Size100to120] EQ 1), Age20Size100to120countF)
        age21Size100to120F = WHERE((Age_Gro[Size100to120] EQ 21) AND (Sex_Gro[Size100to120] EQ 1), Age21Size100to120countF)
        age22Size100to120F = WHERE((Age_Gro[Size100to120] EQ 22) AND (Sex_Gro[Size100to120] EQ 1), Age22Size100to120countF)
        age23Size100to120F = WHERE((Age_Gro[Size100to120] EQ 23) AND (Sex_Gro[Size100to120] EQ 1), Age23Size100to120countF)
        age24Size100to120F = WHERE((Age_Gro[Size100to120] EQ 24) AND (Sex_Gro[Size100to120] EQ 1), Age24Size100to120countF)
        age25Size100to120F = WHERE((Age_Gro[Size100to120] EQ 25) AND (Sex_Gro[Size100to120] EQ 1), Age25Size100to120countF)
        age26Size100to120F = WHERE((Age_Gro[Size100to120] EQ 26) AND (Sex_Gro[Size100to120] EQ 1), Age26Size100to120countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+1L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+1L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+1L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+1L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+1L] = 100
        WAE_length_bin[75, i*NumLengthBin+adj+1L] = Size100to120countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+1L] = Age0Size100to120countF
        WAE_length_bin[77, i*NumLengthBin+adj+1L] = Age1Size100to120countF
        WAE_length_bin[78, i*NumLengthBin+adj+1L] = Age2Size100to120countF
        WAE_length_bin[79, i*NumLengthBin+adj+1L] = Age3Size100to120countF
        WAE_length_bin[80, i*NumLengthBin+adj+1L] = Age4Size100to120countF
        WAE_length_bin[81, i*NumLengthBin+adj+1L] = Age5Size100to120countF
        WAE_length_bin[82, i*NumLengthBin+adj+1L] = Age6Size100to120countF
        WAE_length_bin[83, i*NumLengthBin+adj+1L] = Age7Size100to120countF
        WAE_length_bin[84, i*NumLengthBin+adj+1L] = Age8Size100to120countF
        WAE_length_bin[85, i*NumLengthBin+adj+1L] = Age9Size100to120countF
        WAE_length_bin[86, i*NumLengthBin+adj+1L] = Age10Size100to120countF
        WAE_length_bin[87, i*NumLengthBin+adj+1L] = Age11Size100to120countF
        WAE_length_bin[88, i*NumLengthBin+adj+1L] = Age12Size100to120countF
        WAE_length_bin[89, i*NumLengthBin+adj+1L] = Age13Size100to120countF
        WAE_length_bin[90, i*NumLengthBin+adj+1L] = Age14Size100to120countF
        WAE_length_bin[91, i*NumLengthBin+adj+1L] = Age15Size100to120countF
        WAE_length_bin[92, i*NumLengthBin+adj+1L] = Age16Size100to120countF
        WAE_length_bin[93, i*NumLengthBin+adj+1L] = Age17Size100to120countF
        WAE_length_bin[94, i*NumLengthBin+adj+1L] = Age18Size100to120countF
        WAE_length_bin[95, i*NumLengthBin+adj+1L] = Age19Size100to120countF
        WAE_length_bin[96, i*NumLengthBin+adj+1L] = Age20Size100to120countF
        WAE_length_bin[97, i*NumLengthBin+adj+1L] = Age21Size100to120countF
        WAE_length_bin[98, i*NumLengthBin+adj+1L] = Age22Size100to120countF
        WAE_length_bin[99, i*NumLengthBin+adj+1L] = Age23Size100to120countF
        WAE_length_bin[100, i*NumLengthBin+adj+1L] = Age24Size100to120countF
        WAE_length_bin[101, i*NumLengthBin+adj+1L] = Age25Size100to120countF
        WAE_length_bin[102, i*NumLengthBin+adj+1L] = Age26Size100to120countF
      ENDIF
      PRINT, 'Size100to120F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+1L])
      
      
      ; length bin 3
      IF Size120to140count GT 0 THEN BEGIN
        age0Size120to140F = WHERE((Age_Gro[Size120to140] EQ 0) AND (Sex_Gro[Size120to140] EQ 1), Age0Size120to140countF)
        age1Size120to140F = WHERE((Age_Gro[Size120to140] EQ 1) AND (Sex_Gro[Size120to140] EQ 1), Age1Size120to140countF)
        age2Size120to140F = WHERE((Age_Gro[Size120to140] EQ 2) AND (Sex_Gro[Size120to140] EQ 1), Age2Size120to140countF)
        age3Size120to140F = WHERE((Age_Gro[Size120to140] EQ 3) AND (Sex_Gro[Size120to140] EQ 1), Age3Size120to140countF)
        age4Size120to140F = WHERE((Age_Gro[Size120to140] EQ 4) AND (Sex_Gro[Size120to140] EQ 1), Age4Size120to140countF)
        age5Size120to140F = WHERE((Age_Gro[Size120to140] EQ 5) AND (Sex_Gro[Size120to140] EQ 1), Age5Size120to140countF)
        age6Size120to140F = WHERE((Age_Gro[Size120to140] EQ 6) AND (Sex_Gro[Size120to140] EQ 1), Age6Size120to140countF)
        age7Size120to140F = WHERE((Age_Gro[Size120to140] EQ 7) AND (Sex_Gro[Size120to140] EQ 1), Age7Size120to140countF)
        age8Size120to140F = WHERE((Age_Gro[Size120to140] EQ 8) AND (Sex_Gro[Size120to140] EQ 1), Age8Size120to140countF)
        age9Size120to140F = WHERE((Age_Gro[Size120to140] EQ 9) AND (Sex_Gro[Size120to140] EQ 1), Age9Size120to140countF)
        age10Size120to140F = WHERE((Age_Gro[Size120to140] EQ 10) AND (Sex_Gro[Size120to140] EQ 1), Age10Size120to140countF)
        age11Size120to140F = WHERE((Age_Gro[Size120to140] EQ 11) AND (Sex_Gro[Size120to140] EQ 1), Age11Size120to140countF)
        AGE12Size120to140F = WHERE((Age_Gro[Size120to140] EQ 12) AND (Sex_Gro[Size120to140] EQ 1), Age12Size120to140countF)
        AGE13Size120to140F = WHERE((Age_Gro[Size120to140] EQ 13) AND (Sex_Gro[Size120to140] EQ 1), Age13Size120to140countF)
        AGE14Size120to140F = WHERE((Age_Gro[Size120to140] EQ 14) AND (Sex_Gro[Size120to140] EQ 1), Age14Size120to140countF)
        AGE15Size120to140F = WHERE((Age_Gro[Size120to140] EQ 15) AND (Sex_Gro[Size120to140] EQ 1), Age15Size120to140countF)
        age16Size120to140F = WHERE((Age_Gro[Size120to140] EQ 16) AND (Sex_Gro[Size120to140] EQ 1), Age16Size120to140countF)
        age17Size120to140F = WHERE((Age_Gro[Size120to140] EQ 17) AND (Sex_Gro[Size120to140] EQ 1), Age17Size120to140countF)
        age18Size120to140F = WHERE((Age_Gro[Size120to140] EQ 18) AND (Sex_Gro[Size120to140] EQ 1), Age18Size120to140countF)
        age19Size120to140F = WHERE((Age_Gro[Size120to140] EQ 19) AND (Sex_Gro[Size120to140] EQ 1), Age19Size120to140countF)
        age20Size120to140F = WHERE((Age_Gro[Size120to140] EQ 20) AND (Sex_Gro[Size120to140] EQ 1), Age20Size120to140countF)
        age21Size120to140F = WHERE((Age_Gro[Size120to140] EQ 21) AND (Sex_Gro[Size120to140] EQ 1), Age21Size120to140countF)
        age22Size120to140F = WHERE((Age_Gro[Size120to140] EQ 22) AND (Sex_Gro[Size120to140] EQ 1), Age22Size120to140countF)
        age23Size120to140F = WHERE((Age_Gro[Size120to140] EQ 23) AND (Sex_Gro[Size120to140] EQ 1), Age23Size120to140countF)
        age24Size120to140F = WHERE((Age_Gro[Size120to140] EQ 24) AND (Sex_Gro[Size120to140] EQ 1), Age24Size120to140countF)
        age25Size120to140F = WHERE((Age_Gro[Size120to140] EQ 25) AND (Sex_Gro[Size120to140] EQ 1), Age25Size120to140countF)
        age26Size120to140F = WHERE((Age_Gro[Size120to140] EQ 26) AND (Sex_Gro[Size120to140] EQ 1), Age26Size120to140countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+2L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+2L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+2L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+2L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+2L] = 120
        WAE_length_bin[75, i*NumLengthBin+adj+2L] = Size120to140countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+2L] = Age0Size120to140countF
        WAE_length_bin[77, i*NumLengthBin+adj+2L] = Age1Size120to140countF
        WAE_length_bin[78, i*NumLengthBin+adj+2L] = Age2Size120to140countF
        WAE_length_bin[79, i*NumLengthBin+adj+2L] = Age3Size120to140countF
        WAE_length_bin[80, i*NumLengthBin+adj+2L] = Age4Size120to140countF
        WAE_length_bin[81, i*NumLengthBin+adj+2L] = Age5Size120to140countF
        WAE_length_bin[82, i*NumLengthBin+adj+2L] = Age6Size120to140countF
        WAE_length_bin[83, i*NumLengthBin+adj+2L] = Age7Size120to140countF
        WAE_length_bin[84, i*NumLengthBin+adj+2L] = Age8Size120to140countF
        WAE_length_bin[85, i*NumLengthBin+adj+2L] = Age9Size120to140countF
        WAE_length_bin[86, i*NumLengthBin+adj+2L] = Age10Size120to140countF
        WAE_length_bin[87, i*NumLengthBin+adj+2L] = Age11Size120to140countF
        WAE_length_bin[88, i*NumLengthBin+adj+2L] = Age12Size120to140countF
        WAE_length_bin[89, i*NumLengthBin+adj+2L] = Age13Size120to140countF
        WAE_length_bin[90, i*NumLengthBin+adj+2L] = Age14Size120to140countF
        WAE_length_bin[91, i*NumLengthBin+adj+2L] = Age15Size120to140countF
        WAE_length_bin[92, i*NumLengthBin+adj+2L] = Age16Size120to140countF
        WAE_length_bin[93, i*NumLengthBin+adj+2L] = Age17Size120to140countF
        WAE_length_bin[94, i*NumLengthBin+adj+2L] = Age18Size120to140countF
        WAE_length_bin[95, i*NumLengthBin+adj+2L] = Age19Size120to140countF
        WAE_length_bin[96, i*NumLengthBin+adj+2L] = Age20Size120to140countF
        WAE_length_bin[97, i*NumLengthBin+adj+2L] = Age21Size120to140countF
        WAE_length_bin[98, i*NumLengthBin+adj+2L] = Age22Size120to140countF
        WAE_length_bin[99, i*NumLengthBin+adj+2L] = Age23Size120to140countF
        WAE_length_bin[100, i*NumLengthBin+adj+2L] = Age24Size120to140countF
        WAE_length_bin[101, i*NumLengthBin+adj+2L] = Age25Size120to140countF
        WAE_length_bin[102, i*NumLengthBin+adj+2L] = Age26Size120to140countF
      ENDIF
      PRINT, 'Size120to140F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+2L])
      
      ; length bin 4
      IF Size140to160count GT 0 THEN BEGIN
        age0Size140to160F = WHERE((Age_Gro[Size140to160] EQ 0) AND (Sex_Gro[Size140to160] EQ 1), Age0Size140to160countF)
        age1Size140to160F = WHERE((Age_Gro[Size140to160] EQ 1) AND (Sex_Gro[Size140to160] EQ 1), Age1Size140to160countF)
        age2Size140to160F = WHERE((Age_Gro[Size140to160] EQ 2) AND (Sex_Gro[Size140to160] EQ 1), Age2Size140to160countF)
        age3Size140to160F = WHERE((Age_Gro[Size140to160] EQ 3) AND (Sex_Gro[Size140to160] EQ 1), Age3Size140to160countF)
        age4Size140to160F = WHERE((Age_Gro[Size140to160] EQ 4) AND (Sex_Gro[Size140to160] EQ 1), Age4Size140to160countF)
        age5Size140to160F = WHERE((Age_Gro[Size140to160] EQ 5) AND (Sex_Gro[Size140to160] EQ 1), Age5Size140to160countF)
        age6Size140to160F = WHERE((Age_Gro[Size140to160] EQ 6) AND (Sex_Gro[Size140to160] EQ 1), Age6Size140to160countF)
        age7Size140to160F = WHERE((Age_Gro[Size140to160] EQ 7) AND (Sex_Gro[Size140to160] EQ 1), Age7Size140to160countF)
        age8Size140to160F = WHERE((Age_Gro[Size140to160] EQ 8) AND (Sex_Gro[Size140to160] EQ 1), Age8Size140to160countF)
        age9Size140to160F = WHERE((Age_Gro[Size140to160] EQ 9) AND (Sex_Gro[Size140to160] EQ 1), Age9Size140to160countF)
        age10Size140to160F = WHERE((Age_Gro[Size140to160] EQ 10) AND (Sex_Gro[Size140to160] EQ 1), Age10Size140to160countF)
        age11Size140to160F = WHERE((Age_Gro[Size140to160] EQ 11) AND (Sex_Gro[Size140to160] EQ 1), Age11Size140to160countF)
        AGE12Size140to160F = WHERE((Age_Gro[Size140to160] EQ 12) AND (Sex_Gro[Size140to160] EQ 1), Age12Size140to160countF)
        AGE13Size140to160F = WHERE((Age_Gro[Size140to160] EQ 13) AND (Sex_Gro[Size140to160] EQ 1), Age13Size140to160countF)
        AGE14Size140to160F = WHERE((Age_Gro[Size140to160] EQ 14) AND (Sex_Gro[Size140to160] EQ 1), Age14Size140to160countF)
        AGE15Size140to160F = WHERE((Age_Gro[Size140to160] EQ 15) AND (Sex_Gro[Size140to160] EQ 1), Age15Size140to160countF)
        age16Size140to160F = WHERE((Age_Gro[Size140to160] EQ 16) AND (Sex_Gro[Size140to160] EQ 1), Age16Size140to160countF)
        age17Size140to160F = WHERE((Age_Gro[Size140to160] EQ 17) AND (Sex_Gro[Size140to160] EQ 1), Age17Size140to160countF)
        age18Size140to160F = WHERE((Age_Gro[Size140to160] EQ 18) AND (Sex_Gro[Size140to160] EQ 1), Age18Size140to160countF)
        age19Size140to160F = WHERE((Age_Gro[Size140to160] EQ 19) AND (Sex_Gro[Size140to160] EQ 1), Age19Size140to160countF)
        age20Size140to160F = WHERE((Age_Gro[Size140to160] EQ 20) AND (Sex_Gro[Size140to160] EQ 1), Age20Size140to160countF)
        age21Size140to160F = WHERE((Age_Gro[Size140to160] EQ 21) AND (Sex_Gro[Size140to160] EQ 1), Age21Size140to160countF)
        age22Size140to160F = WHERE((Age_Gro[Size140to160] EQ 22) AND (Sex_Gro[Size140to160] EQ 1), Age22Size140to160countF)
        age23Size140to160F = WHERE((Age_Gro[Size140to160] EQ 23) AND (Sex_Gro[Size140to160] EQ 1), Age23Size140to160countF)
        age24Size140to160F = WHERE((Age_Gro[Size140to160] EQ 24) AND (Sex_Gro[Size140to160] EQ 1), Age24Size140to160countF)
        age25Size140to160F = WHERE((Age_Gro[Size140to160] EQ 25) AND (Sex_Gro[Size140to160] EQ 1), Age25Size140to160countF)
        age26Size140to160F = WHERE((Age_Gro[Size140to160] EQ 26) AND (Sex_Gro[Size140to160] EQ 1), Age26Size140to160countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+3L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+3L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+3L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+3L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+3L] = 140
        WAE_length_bin[75, i*NumLengthBin+adj+3L] = Size140to160countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+3L] = Age0Size140to160countF
        WAE_length_bin[77, i*NumLengthBin+adj+3L] = Age1Size140to160countF
        WAE_length_bin[78, i*NumLengthBin+adj+3L] = Age2Size140to160countF
        WAE_length_bin[79, i*NumLengthBin+adj+3L] = Age3Size140to160countF
        WAE_length_bin[80, i*NumLengthBin+adj+3L] = Age4Size140to160countF
        WAE_length_bin[81, i*NumLengthBin+adj+3L] = Age5Size140to160countF
        WAE_length_bin[82, i*NumLengthBin+adj+3L] = Age6Size140to160countF
        WAE_length_bin[83, i*NumLengthBin+adj+3L] = Age7Size140to160countF
        WAE_length_bin[84, i*NumLengthBin+adj+3L] = Age8Size140to160countF
        WAE_length_bin[85, i*NumLengthBin+adj+3L] = Age9Size140to160countF
        WAE_length_bin[86, i*NumLengthBin+adj+3L] = Age10Size140to160countF
        WAE_length_bin[87, i*NumLengthBin+adj+3L] = Age11Size140to160countF
        WAE_length_bin[88, i*NumLengthBin+adj+3L] = Age12Size140to160countF
        WAE_length_bin[89, i*NumLengthBin+adj+3L] = Age13Size140to160countF
        WAE_length_bin[90, i*NumLengthBin+adj+3L] = Age14Size140to160countF
        WAE_length_bin[91, i*NumLengthBin+adj+3L] = Age15Size140to160countF
        WAE_length_bin[92, i*NumLengthBin+adj+3L] = Age16Size140to160countF
        WAE_length_bin[93, i*NumLengthBin+adj+3L] = Age17Size140to160countF
        WAE_length_bin[94, i*NumLengthBin+adj+3L] = Age18Size140to160countF
        WAE_length_bin[95, i*NumLengthBin+adj+3L] = Age19Size140to160countF
        WAE_length_bin[96, i*NumLengthBin+adj+3L] = Age20Size140to160countF
        WAE_length_bin[97, i*NumLengthBin+adj+3L] = Age21Size140to160countF
        WAE_length_bin[98, i*NumLengthBin+adj+3L] = Age22Size140to160countF
        WAE_length_bin[99, i*NumLengthBin+adj+3L] = Age23Size140to160countF
        WAE_length_bin[100, i*NumLengthBin+adj+3L] = Age24Size140to160countF
        WAE_length_bin[101, i*NumLengthBin+adj+3L] = Age25Size140to160countF
        WAE_length_bin[102, i*NumLengthBin+adj+3L] = Age26Size140to160countF
      ENDIF
      PRINT, 'Size140to160F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+3L])
      
      ; length bin 5
      IF Size160to180count GT 0 THEN BEGIN
        age0Size160to180F = WHERE((Age_Gro[Size160to180] EQ 0) AND (Sex_Gro[Size160to180] EQ 1), Age0Size160to180countF)
        age1Size160to180F = WHERE((Age_Gro[Size160to180] EQ 1) AND (Sex_Gro[Size160to180] EQ 1), Age1Size160to180countF)
        age2Size160to180F = WHERE((Age_Gro[Size160to180] EQ 2) AND (Sex_Gro[Size160to180] EQ 1), Age2Size160to180countF)
        age3Size160to180F = WHERE((Age_Gro[Size160to180] EQ 3) AND (Sex_Gro[Size160to180] EQ 1), Age3Size160to180countF)
        age4Size160to180F = WHERE((Age_Gro[Size160to180] EQ 4) AND (Sex_Gro[Size160to180] EQ 1), Age4Size160to180countF)
        age5Size160to180F = WHERE((Age_Gro[Size160to180] EQ 5) AND (Sex_Gro[Size160to180] EQ 1), Age5Size160to180countF)
        age6Size160to180F = WHERE((Age_Gro[Size160to180] EQ 6) AND (Sex_Gro[Size160to180] EQ 1), Age6Size160to180countF)
        age7Size160to180F = WHERE((Age_Gro[Size160to180] EQ 7) AND (Sex_Gro[Size160to180] EQ 1), Age7Size160to180countF)
        age8Size160to180F = WHERE((Age_Gro[Size160to180] EQ 8) AND (Sex_Gro[Size160to180] EQ 1), Age8Size160to180countF)
        age9Size160to180F = WHERE((Age_Gro[Size160to180] EQ 9) AND (Sex_Gro[Size160to180] EQ 1), Age9Size160to180countF)
        age10Size160to180F = WHERE((Age_Gro[Size160to180] EQ 10) AND (Sex_Gro[Size160to180] EQ 1), Age10Size160to180countF)
        age11Size160to180F = WHERE((Age_Gro[Size160to180] EQ 11) AND (Sex_Gro[Size160to180] EQ 1), Age11Size160to180countF)
        AGE12Size160to180F = WHERE((Age_Gro[Size160to180] EQ 12) AND (Sex_Gro[Size160to180] EQ 1), Age12Size160to180countF)
        AGE13Size160to180F = WHERE((Age_Gro[Size160to180] EQ 13) AND (Sex_Gro[Size160to180] EQ 1), Age13Size160to180countF)
        AGE14Size160to180F = WHERE((Age_Gro[Size160to180] EQ 14) AND (Sex_Gro[Size160to180] EQ 1), Age14Size160to180countF)
        AGE15Size160to180F = WHERE((Age_Gro[Size160to180] EQ 15) AND (Sex_Gro[Size160to180] EQ 1), Age15Size160to180countF)
        age16Size160to180F = WHERE((Age_Gro[Size160to180] EQ 16) AND (Sex_Gro[Size160to180] EQ 1), Age16Size160to180countF)
        age17Size160to180F = WHERE((Age_Gro[Size160to180] EQ 17) AND (Sex_Gro[Size160to180] EQ 1), Age17Size160to180countF)
        age18Size160to180F = WHERE((Age_Gro[Size160to180] EQ 18) AND (Sex_Gro[Size160to180] EQ 1), Age18Size160to180countF)
        age19Size160to180F = WHERE((Age_Gro[Size160to180] EQ 19) AND (Sex_Gro[Size160to180] EQ 1), Age19Size160to180countF)
        age20Size160to180F = WHERE((Age_Gro[Size160to180] EQ 20) AND (Sex_Gro[Size160to180] EQ 1), Age20Size160to180countF)
        age21Size160to180F = WHERE((Age_Gro[Size160to180] EQ 21) AND (Sex_Gro[Size160to180] EQ 1), Age21Size160to180countF)
        age22Size160to180F = WHERE((Age_Gro[Size160to180] EQ 22) AND (Sex_Gro[Size160to180] EQ 1), Age22Size160to180countF)
        age23Size160to180F = WHERE((Age_Gro[Size160to180] EQ 23) AND (Sex_Gro[Size160to180] EQ 1), Age23Size160to180countF)
        age24Size160to180F = WHERE((Age_Gro[Size160to180] EQ 24) AND (Sex_Gro[Size160to180] EQ 1), Age24Size160to180countF)
        age25Size160to180F = WHERE((Age_Gro[Size160to180] EQ 25) AND (Sex_Gro[Size160to180] EQ 1), Age25Size160to180countF)
        age26Size160to180F = WHERE((Age_Gro[Size160to180] EQ 26) AND (Sex_Gro[Size160to180] EQ 1), Age26Size160to180countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+4L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+4L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+4L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+4L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+4L] = 160
        WAE_length_bin[75, i*NumLengthBin+adj+4L] = Size160to180countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+4L] = Age0Size160to180countF
        WAE_length_bin[77, i*NumLengthBin+adj+4L] = Age1Size160to180countF
        WAE_length_bin[78, i*NumLengthBin+adj+4L] = Age2Size160to180countF
        WAE_length_bin[79, i*NumLengthBin+adj+4L] = Age3Size160to180countF
        WAE_length_bin[80, i*NumLengthBin+adj+4L] = Age4Size160to180countF
        WAE_length_bin[81, i*NumLengthBin+adj+4L] = Age5Size160to180countF
        WAE_length_bin[82, i*NumLengthBin+adj+4L] = Age6Size160to180countF
        WAE_length_bin[83, i*NumLengthBin+adj+4L] = Age7Size160to180countF
        WAE_length_bin[84, i*NumLengthBin+adj+4L] = Age8Size160to180countF
        WAE_length_bin[85, i*NumLengthBin+adj+4L] = Age9Size160to180countF
        WAE_length_bin[86, i*NumLengthBin+adj+4L] = Age10Size160to180countF
        WAE_length_bin[87, i*NumLengthBin+adj+4L] = Age11Size160to180countF
        WAE_length_bin[88, i*NumLengthBin+adj+4L] = Age12Size160to180countF
        WAE_length_bin[89, i*NumLengthBin+adj+4L] = Age13Size160to180countF
        WAE_length_bin[90, i*NumLengthBin+adj+4L] = Age14Size160to180countF
        WAE_length_bin[91, i*NumLengthBin+adj+4L] = Age15Size160to180countF
        WAE_length_bin[92, i*NumLengthBin+adj+4L] = Age16Size160to180countF
        WAE_length_bin[93, i*NumLengthBin+adj+4L] = Age17Size160to180countF
        WAE_length_bin[94, i*NumLengthBin+adj+4L] = Age18Size160to180countF
        WAE_length_bin[95, i*NumLengthBin+adj+4L] = Age19Size160to180countF
        WAE_length_bin[96, i*NumLengthBin+adj+4L] = Age20Size160to180countF
        WAE_length_bin[97, i*NumLengthBin+adj+4L] = Age21Size160to180countF
        WAE_length_bin[98, i*NumLengthBin+adj+4L] = Age22Size160to180countF
        WAE_length_bin[99, i*NumLengthBin+adj+4L] = Age23Size160to180countF
        WAE_length_bin[100, i*NumLengthBin+adj+4L] = Age24Size160to180countF
        WAE_length_bin[101, i*NumLengthBin+adj+4L] = Age25Size160to180countF
        WAE_length_bin[102, i*NumLengthBin+adj+4L] = Age26Size160to180countF
      ENDIF
      PRINT, 'Size160to180F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+4L])
      
      ; length bin 6
      IF Size180to200count GT 0 THEN BEGIN
        age0Size180to200F = WHERE((Age_Gro[Size180to200] EQ 0) AND (Sex_Gro[Size180to200] EQ 1), Age0Size180to200countF)
        age1Size180to200F = WHERE((Age_Gro[Size180to200] EQ 1) AND (Sex_Gro[Size180to200] EQ 1), Age1Size180to200countF)
        age2Size180to200F = WHERE((Age_Gro[Size180to200] EQ 2) AND (Sex_Gro[Size180to200] EQ 1), Age2Size180to200countF)
        age3Size180to200F = WHERE((Age_Gro[Size180to200] EQ 3) AND (Sex_Gro[Size180to200] EQ 1), Age3Size180to200countF)
        age4Size180to200F = WHERE((Age_Gro[Size180to200] EQ 4) AND (Sex_Gro[Size180to200] EQ 1), Age4Size180to200countF)
        age5Size180to200F = WHERE((Age_Gro[Size180to200] EQ 5) AND (Sex_Gro[Size180to200] EQ 1), Age5Size180to200countF)
        age6Size180to200F = WHERE((Age_Gro[Size180to200] EQ 6) AND (Sex_Gro[Size180to200] EQ 1), Age6Size180to200countF)
        age7Size180to200F = WHERE((Age_Gro[Size180to200] EQ 7) AND (Sex_Gro[Size180to200] EQ 1), Age7Size180to200countF)
        age8Size180to200F = WHERE((Age_Gro[Size180to200] EQ 8) AND (Sex_Gro[Size180to200] EQ 1), Age8Size180to200countF)
        age9Size180to200F = WHERE((Age_Gro[Size180to200] EQ 9) AND (Sex_Gro[Size180to200] EQ 1), Age9Size180to200countF)
        age10Size180to200F = WHERE((Age_Gro[Size180to200] EQ 10) AND (Sex_Gro[Size180to200] EQ 1), Age10Size180to200countF)
        age11Size180to200F = WHERE((Age_Gro[Size180to200] EQ 11) AND (Sex_Gro[Size180to200] EQ 1), Age11Size180to200countF)
        AGE12Size180to200F = WHERE((Age_Gro[Size180to200] EQ 12) AND (Sex_Gro[Size180to200] EQ 1), Age12Size180to200countF)
        AGE13Size180to200F = WHERE((Age_Gro[Size180to200] EQ 13) AND (Sex_Gro[Size180to200] EQ 1), Age13Size180to200countF)
        AGE14Size180to200F = WHERE((Age_Gro[Size180to200] EQ 14) AND (Sex_Gro[Size180to200] EQ 1), Age14Size180to200countF)
        AGE15Size180to200F = WHERE((Age_Gro[Size180to200] EQ 15) AND (Sex_Gro[Size180to200] EQ 1), Age15Size180to200countF)
        age16Size180to200F = WHERE((Age_Gro[Size180to200] EQ 16) AND (Sex_Gro[Size180to200] EQ 1), Age16Size180to200countF)
        age17Size180to200F = WHERE((Age_Gro[Size180to200] EQ 17) AND (Sex_Gro[Size180to200] EQ 1), Age17Size180to200countF)
        age18Size180to200F = WHERE((Age_Gro[Size180to200] EQ 18) AND (Sex_Gro[Size180to200] EQ 1), Age18Size180to200countF)
        age19Size180to200F = WHERE((Age_Gro[Size180to200] EQ 19) AND (Sex_Gro[Size180to200] EQ 1), Age19Size180to200countF)
        age20Size180to200F = WHERE((Age_Gro[Size180to200] EQ 20) AND (Sex_Gro[Size180to200] EQ 1), Age20Size180to200countF)
        age21Size180to200F = WHERE((Age_Gro[Size180to200] EQ 21) AND (Sex_Gro[Size180to200] EQ 1), Age21Size180to200countF)
        age22Size180to200F = WHERE((Age_Gro[Size180to200] EQ 22) AND (Sex_Gro[Size180to200] EQ 1), Age22Size180to200countF)
        age23Size180to200F = WHERE((Age_Gro[Size180to200] EQ 23) AND (Sex_Gro[Size180to200] EQ 1), Age23Size180to200countF)
        age24Size180to200F = WHERE((Age_Gro[Size180to200] EQ 24) AND (Sex_Gro[Size180to200] EQ 1), Age24Size180to200countF)
        age25Size180to200F = WHERE((Age_Gro[Size180to200] EQ 25) AND (Sex_Gro[Size180to200] EQ 1), Age25Size180to200countF)
        age26Size180to200F = WHERE((Age_Gro[Size180to200] EQ 26) AND (Sex_Gro[Size180to200] EQ 1), Age26Size180to200countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+5L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+5L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+5L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+5L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+5L] = 180
        WAE_length_bin[75, i*NumLengthBin+adj+5L] = Size180to200countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+5L] = Age0Size180to200countF
        WAE_length_bin[77, i*NumLengthBin+adj+5L] = Age1Size180to200countF
        WAE_length_bin[78, i*NumLengthBin+adj+5L] = Age2Size180to200countF
        WAE_length_bin[79, i*NumLengthBin+adj+5L] = Age3Size180to200countF
        WAE_length_bin[80, i*NumLengthBin+adj+5L] = Age4Size180to200countF
        WAE_length_bin[81, i*NumLengthBin+adj+5L] = Age5Size180to200countF
        WAE_length_bin[82, i*NumLengthBin+adj+5L] = Age6Size180to200countF
        WAE_length_bin[83, i*NumLengthBin+adj+5L] = Age7Size180to200countF
        WAE_length_bin[84, i*NumLengthBin+adj+5L] = Age8Size180to200countF
        WAE_length_bin[85, i*NumLengthBin+adj+5L] = Age9Size180to200countF
        WAE_length_bin[86, i*NumLengthBin+adj+5L] = Age10Size180to200countF
        WAE_length_bin[87, i*NumLengthBin+adj+5L] = Age11Size180to200countF
        WAE_length_bin[88, i*NumLengthBin+adj+5L] = Age12Size180to200countF
        WAE_length_bin[89, i*NumLengthBin+adj+5L] = Age13Size180to200countF
        WAE_length_bin[90, i*NumLengthBin+adj+5L] = Age14Size180to200countF
        WAE_length_bin[91, i*NumLengthBin+adj+5L] = Age15Size180to200countF
        WAE_length_bin[92, i*NumLengthBin+adj+5L] = Age16Size180to200countF
        WAE_length_bin[93, i*NumLengthBin+adj+5L] = Age17Size180to200countF
        WAE_length_bin[94, i*NumLengthBin+adj+5L] = Age18Size180to200countF
        WAE_length_bin[95, i*NumLengthBin+adj+5L] = Age19Size180to200countF
        WAE_length_bin[96, i*NumLengthBin+adj+5L] = Age20Size180to200countF
        WAE_length_bin[97, i*NumLengthBin+adj+5L] = Age21Size180to200countF
        WAE_length_bin[98, i*NumLengthBin+adj+5L] = Age22Size180to200countF
        WAE_length_bin[99, i*NumLengthBin+adj+5L] = Age23Size180to200countF
        WAE_length_bin[100, i*NumLengthBin+adj+5L] = Age24Size180to200countF
        WAE_length_bin[101, i*NumLengthBin+adj+5L] = Age25Size180to200countF
        WAE_length_bin[102, i*NumLengthBin+adj+5L] = Age26Size180to200countF
      ENDIF
      PRINT, 'Size180to200F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+5L])
      
      ; length bin 7
      IF Size200to220count GT 0 THEN BEGIN
        age0Size200to220F = WHERE((Age_Gro[Size200to220] EQ 0) AND (Sex_Gro[Size200to220] EQ 1), Age0Size200to220countF)
        age1Size200to220F = WHERE((Age_Gro[Size200to220] EQ 1) AND (Sex_Gro[Size200to220] EQ 1), Age1Size200to220countF)
        age2Size200to220F = WHERE((Age_Gro[Size200to220] EQ 2) AND (Sex_Gro[Size200to220] EQ 1), Age2Size200to220countF)
        age3Size200to220F = WHERE((Age_Gro[Size200to220] EQ 3) AND (Sex_Gro[Size200to220] EQ 1), Age3Size200to220countF)
        age4Size200to220F = WHERE((Age_Gro[Size200to220] EQ 4) AND (Sex_Gro[Size200to220] EQ 1), Age4Size200to220countF)
        age5Size200to220F = WHERE((Age_Gro[Size200to220] EQ 5) AND (Sex_Gro[Size200to220] EQ 1), Age5Size200to220countF)
        age6Size200to220F = WHERE((Age_Gro[Size200to220] EQ 6) AND (Sex_Gro[Size200to220] EQ 1), Age6Size200to220countF)
        age7Size200to220F = WHERE((Age_Gro[Size200to220] EQ 7) AND (Sex_Gro[Size200to220] EQ 1), Age7Size200to220countF)
        age8Size200to220F = WHERE((Age_Gro[Size200to220] EQ 8) AND (Sex_Gro[Size200to220] EQ 1), Age8Size200to220countF)
        age9Size200to220F = WHERE((Age_Gro[Size200to220] EQ 9) AND (Sex_Gro[Size200to220] EQ 1), Age9Size200to220countF)
        age10Size200to220F = WHERE((Age_Gro[Size200to220] EQ 10) AND (Sex_Gro[Size200to220] EQ 1), Age10Size200to220countF)
        age11Size200to220F = WHERE((Age_Gro[Size200to220] EQ 11) AND (Sex_Gro[Size200to220] EQ 1), Age11Size200to220countF)
        AGE12Size200to220F = WHERE((Age_Gro[Size200to220] EQ 12) AND (Sex_Gro[Size200to220] EQ 1), Age12Size200to220countF)
        AGE13Size200to220F = WHERE((Age_Gro[Size200to220] EQ 13) AND (Sex_Gro[Size200to220] EQ 1), Age13Size200to220countF)
        AGE14Size200to220F = WHERE((Age_Gro[Size200to220] EQ 14) AND (Sex_Gro[Size200to220] EQ 1), Age14Size200to220countF)
        AGE15Size200to220F = WHERE((Age_Gro[Size200to220] EQ 15) AND (Sex_Gro[Size200to220] EQ 1), Age15Size200to220countF)
        age16Size200to220F = WHERE((Age_Gro[Size200to220] EQ 16) AND (Sex_Gro[Size200to220] EQ 1), Age16Size200to220countF)
        age17Size200to220F = WHERE((Age_Gro[Size200to220] EQ 17) AND (Sex_Gro[Size200to220] EQ 1), Age17Size200to220countF)
        age18Size200to220F = WHERE((Age_Gro[Size200to220] EQ 18) AND (Sex_Gro[Size200to220] EQ 1), Age18Size200to220countF)
        age19Size200to220F = WHERE((Age_Gro[Size200to220] EQ 19) AND (Sex_Gro[Size200to220] EQ 1), Age19Size200to220countF)
        age20Size200to220F = WHERE((Age_Gro[Size200to220] EQ 20) AND (Sex_Gro[Size200to220] EQ 1), Age20Size200to220countF)
        age21Size200to220F = WHERE((Age_Gro[Size200to220] EQ 21) AND (Sex_Gro[Size200to220] EQ 1), Age21Size200to220countF)
        age22Size200to220F = WHERE((Age_Gro[Size200to220] EQ 22) AND (Sex_Gro[Size200to220] EQ 1), Age22Size200to220countF)
        age23Size200to220F = WHERE((Age_Gro[Size200to220] EQ 23) AND (Sex_Gro[Size200to220] EQ 1), Age23Size200to220countF)
        age24Size200to220F = WHERE((Age_Gro[Size200to220] EQ 24) AND (Sex_Gro[Size200to220] EQ 1), Age24Size200to220countF)
        age25Size200to220F = WHERE((Age_Gro[Size200to220] EQ 25) AND (Sex_Gro[Size200to220] EQ 1), Age25Size200to220countF)
        age26Size200to220F = WHERE((Age_Gro[Size200to220] EQ 26) AND (Sex_Gro[Size200to220] EQ 1), Age26Size200to220countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+6L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+6L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+6L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+6L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+6L] = 200
        WAE_length_bin[75, i*NumLengthBin+adj+6L] = Size200to220countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+6L] = Age0Size200to220countF
        WAE_length_bin[77, i*NumLengthBin+adj+6L] = Age1Size200to220countF
        WAE_length_bin[78, i*NumLengthBin+adj+6L] = Age2Size200to220countF
        WAE_length_bin[79, i*NumLengthBin+adj+6L] = Age3Size200to220countF
        WAE_length_bin[80, i*NumLengthBin+adj+6L] = Age4Size200to220countF
        WAE_length_bin[81, i*NumLengthBin+adj+6L] = Age5Size200to220countF
        WAE_length_bin[82, i*NumLengthBin+adj+6L] = Age6Size200to220countF
        WAE_length_bin[83, i*NumLengthBin+adj+6L] = Age7Size200to220countF
        WAE_length_bin[84, i*NumLengthBin+adj+6L] = Age8Size200to220countF
        WAE_length_bin[85, i*NumLengthBin+adj+6L] = Age9Size200to220countF
        WAE_length_bin[86, i*NumLengthBin+adj+6L] = Age10Size200to220countF
        WAE_length_bin[87, i*NumLengthBin+adj+6L] = Age11Size200to220countF
        WAE_length_bin[88, i*NumLengthBin+adj+6L] = Age12Size200to220countF
        WAE_length_bin[89, i*NumLengthBin+adj+6L] = Age13Size200to220countF
        WAE_length_bin[90, i*NumLengthBin+adj+6L] = Age14Size200to220countF
        WAE_length_bin[91, i*NumLengthBin+adj+6L] = Age15Size200to220countF
        WAE_length_bin[92, i*NumLengthBin+adj+6L] = Age16Size200to220countF
        WAE_length_bin[93, i*NumLengthBin+adj+6L] = Age17Size200to220countF
        WAE_length_bin[94, i*NumLengthBin+adj+6L] = Age18Size200to220countF
        WAE_length_bin[95, i*NumLengthBin+adj+6L] = Age19Size200to220countF
        WAE_length_bin[96, i*NumLengthBin+adj+6L] = Age20Size200to220countF
        WAE_length_bin[97, i*NumLengthBin+adj+6L] = Age21Size200to220countF
        WAE_length_bin[98, i*NumLengthBin+adj+6L] = Age22Size200to220countF
        WAE_length_bin[99, i*NumLengthBin+adj+6L] = Age23Size200to220countF
        WAE_length_bin[100, i*NumLengthBin+adj+6L] = Age24Size200to220countF
        WAE_length_bin[101, i*NumLengthBin+adj+6L] = Age25Size200to220countF
        WAE_length_bin[102, i*NumLengthBin+adj+6L] = Age26Size200to220countF
      ENDIF
      PRINT, 'Size200to220F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+6L])
      
      ; length bin 8
      IF Size220to240count GT 0 THEN BEGIN
        age0Size220to240F = WHERE((Age_Gro[Size220to240] EQ 0) AND (Sex_Gro[Size220to240] EQ 1), Age0Size220to240countF)
        age1Size220to240F = WHERE((Age_Gro[Size220to240] EQ 1) AND (Sex_Gro[Size220to240] EQ 1), Age1Size220to240countF)
        age2Size220to240F = WHERE((Age_Gro[Size220to240] EQ 2) AND (Sex_Gro[Size220to240] EQ 1), Age2Size220to240countF)
        age3Size220to240F = WHERE((Age_Gro[Size220to240] EQ 3) AND (Sex_Gro[Size220to240] EQ 1), Age3Size220to240countF)
        age4Size220to240F = WHERE((Age_Gro[Size220to240] EQ 4) AND (Sex_Gro[Size220to240] EQ 1), Age4Size220to240countF)
        age5Size220to240F = WHERE((Age_Gro[Size220to240] EQ 5) AND (Sex_Gro[Size220to240] EQ 1), Age5Size220to240countF)
        age6Size220to240F = WHERE((Age_Gro[Size220to240] EQ 6) AND (Sex_Gro[Size220to240] EQ 1), Age6Size220to240countF)
        age7Size220to240F = WHERE((Age_Gro[Size220to240] EQ 7) AND (Sex_Gro[Size220to240] EQ 1), Age7Size220to240countF)
        age8Size220to240F = WHERE((Age_Gro[Size220to240] EQ 8) AND (Sex_Gro[Size220to240] EQ 1), Age8Size220to240countF)
        age9Size220to240F = WHERE((Age_Gro[Size220to240] EQ 9) AND (Sex_Gro[Size220to240] EQ 1), Age9Size220to240countF)
        age10Size220to240F = WHERE((Age_Gro[Size220to240] EQ 10) AND (Sex_Gro[Size220to240] EQ 1), Age10Size220to240countF)
        age11Size220to240F = WHERE((Age_Gro[Size220to240] EQ 11) AND (Sex_Gro[Size220to240] EQ 1), Age11Size220to240countF)
        AGE12Size220to240F = WHERE((Age_Gro[Size220to240] EQ 12) AND (Sex_Gro[Size220to240] EQ 1), Age12Size220to240countF)
        AGE13Size220to240F = WHERE((Age_Gro[Size220to240] EQ 13) AND (Sex_Gro[Size220to240] EQ 1), Age13Size220to240countF)
        AGE14Size220to240F = WHERE((Age_Gro[Size220to240] EQ 14) AND (Sex_Gro[Size220to240] EQ 1), Age14Size220to240countF)
        AGE15Size220to240F = WHERE((Age_Gro[Size220to240] EQ 15) AND (Sex_Gro[Size220to240] EQ 1), Age15Size220to240countF)
        age16Size220to240F = WHERE((Age_Gro[Size220to240] EQ 16) AND (Sex_Gro[Size220to240] EQ 1), Age16Size220to240countF)
        age17Size220to240F = WHERE((Age_Gro[Size220to240] EQ 17) AND (Sex_Gro[Size220to240] EQ 1), Age17Size220to240countF)
        age18Size220to240F = WHERE((Age_Gro[Size220to240] EQ 18) AND (Sex_Gro[Size220to240] EQ 1), Age18Size220to240countF)
        age19Size220to240F = WHERE((Age_Gro[Size220to240] EQ 19) AND (Sex_Gro[Size220to240] EQ 1), Age19Size220to240countF)
        age20Size220to240F = WHERE((Age_Gro[Size220to240] EQ 20) AND (Sex_Gro[Size220to240] EQ 1), Age20Size220to240countF)
        age21Size220to240F = WHERE((Age_Gro[Size220to240] EQ 21) AND (Sex_Gro[Size220to240] EQ 1), Age21Size220to240countF)
        age22Size220to240F = WHERE((Age_Gro[Size220to240] EQ 22) AND (Sex_Gro[Size220to240] EQ 1), Age22Size220to240countF)
        age23Size220to240F = WHERE((Age_Gro[Size220to240] EQ 23) AND (Sex_Gro[Size220to240] EQ 1), Age23Size220to240countF)
        age24Size220to240F = WHERE((Age_Gro[Size220to240] EQ 24) AND (Sex_Gro[Size220to240] EQ 1), Age24Size220to240countF)
        age25Size220to240F = WHERE((Age_Gro[Size220to240] EQ 25) AND (Sex_Gro[Size220to240] EQ 1), Age25Size220to240countF)
        age26Size220to240F = WHERE((Age_Gro[Size220to240] EQ 26) AND (Sex_Gro[Size220to240] EQ 1), Age26Size220to240countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+7L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+7L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+7L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+7L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+7L] = 220
        WAE_length_bin[75, i*NumLengthBin+adj+7L] =Size220to240countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+7L] = Age0Size220to240countF
        WAE_length_bin[77, i*NumLengthBin+adj+7L] = Age1Size220to240countF
        WAE_length_bin[78, i*NumLengthBin+adj+7L] = Age2Size220to240countF
        WAE_length_bin[79, i*NumLengthBin+adj+7L] = Age3Size220to240countF
        WAE_length_bin[80, i*NumLengthBin+adj+7L] = Age4Size220to240countF
        WAE_length_bin[81, i*NumLengthBin+adj+7L] = Age5Size220to240countF
        WAE_length_bin[82, i*NumLengthBin+adj+7L] = Age6Size220to240countF
        WAE_length_bin[83, i*NumLengthBin+adj+7L] = Age7Size220to240countF
        WAE_length_bin[84, i*NumLengthBin+adj+7L] = Age8Size220to240countF
        WAE_length_bin[85, i*NumLengthBin+adj+7L] = Age9Size220to240countF
        WAE_length_bin[86, i*NumLengthBin+adj+7L] = Age10Size220to240countF
        WAE_length_bin[87, i*NumLengthBin+adj+7L] = Age11Size220to240countF
        WAE_length_bin[88, i*NumLengthBin+adj+7L] = Age12Size220to240countF
        WAE_length_bin[89, i*NumLengthBin+adj+7L] = Age13Size220to240countF
        WAE_length_bin[90, i*NumLengthBin+adj+7L] = Age14Size220to240countF
        WAE_length_bin[91, i*NumLengthBin+adj+7L] = Age15Size220to240countF
        WAE_length_bin[92, i*NumLengthBin+adj+7L] = Age16Size220to240countF
        WAE_length_bin[93, i*NumLengthBin+adj+7L] = Age17Size220to240countF
        WAE_length_bin[94, i*NumLengthBin+adj+7L] = Age18Size220to240countF
        WAE_length_bin[95, i*NumLengthBin+adj+7L] = Age19Size220to240countF
        WAE_length_bin[96, i*NumLengthBin+adj+7L] = Age20Size220to240countF
        WAE_length_bin[97, i*NumLengthBin+adj+7L] = Age21Size220to240countF
        WAE_length_bin[98, i*NumLengthBin+adj+7L] = Age22Size220to240countF
        WAE_length_bin[99, i*NumLengthBin+adj+7L] = Age23Size220to240countF
        WAE_length_bin[100, i*NumLengthBin+adj+7L] = Age24Size220to240countF
        WAE_length_bin[101, i*NumLengthBin+adj+7L] = Age25Size220to240countF
        WAE_length_bin[102, i*NumLengthBin+adj+7L] = Age26Size220to240countF
      ENDIF
      PRINT, 'Size220to240F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+7L])
      
      ; length bin 9
      IF Size240to260count GT 0 THEN BEGIN
        age0Size240to260F = WHERE((Age_Gro[Size240to260] EQ 0) AND (Sex_Gro[Size240to260] EQ 1), Age0Size240to260countF)
        age1Size240to260F = WHERE((Age_Gro[Size240to260] EQ 1) AND (Sex_Gro[Size240to260] EQ 1), Age1Size240to260countF)
        age2Size240to260F = WHERE((Age_Gro[Size240to260] EQ 2) AND (Sex_Gro[Size240to260] EQ 1), Age2Size240to260countF)
        age3Size240to260F = WHERE((Age_Gro[Size240to260] EQ 3) AND (Sex_Gro[Size240to260] EQ 1), Age3Size240to260countF)
        age4Size240to260F = WHERE((Age_Gro[Size240to260] EQ 4) AND (Sex_Gro[Size240to260] EQ 1), Age4Size240to260countF)
        age5Size240to260F = WHERE((Age_Gro[Size240to260] EQ 5) AND (Sex_Gro[Size240to260] EQ 1), Age5Size240to260countF)
        age6Size240to260F = WHERE((Age_Gro[Size240to260] EQ 6) AND (Sex_Gro[Size240to260] EQ 1), Age6Size240to260countF)
        age7Size240to260F = WHERE((Age_Gro[Size240to260] EQ 7) AND (Sex_Gro[Size240to260] EQ 1), Age7Size240to260countF)
        age8Size240to260F = WHERE((Age_Gro[Size240to260] EQ 8) AND (Sex_Gro[Size240to260] EQ 1), Age8Size240to260countF)
        age9Size240to260F = WHERE((Age_Gro[Size240to260] EQ 9) AND (Sex_Gro[Size240to260] EQ 1), Age9Size240to260countF)
        age10Size240to260F = WHERE((Age_Gro[Size240to260] EQ 10) AND (Sex_Gro[Size240to260] EQ 1), Age10Size240to260countF)
        age11Size240to260F = WHERE((Age_Gro[Size240to260] EQ 11) AND (Sex_Gro[Size240to260] EQ 1), Age11Size240to260countF)
        AGE12Size240to260F = WHERE((Age_Gro[Size240to260] EQ 12) AND (Sex_Gro[Size240to260] EQ 1), Age12Size240to260countF)
        AGE13Size240to260F = WHERE((Age_Gro[Size240to260] EQ 13) AND (Sex_Gro[Size240to260] EQ 1), Age13Size240to260countF)
        AGE14Size240to260F = WHERE((Age_Gro[Size240to260] EQ 14) AND (Sex_Gro[Size240to260] EQ 1), Age14Size240to260countF)
        AGE15Size240to260F = WHERE((Age_Gro[Size240to260] EQ 15) AND (Sex_Gro[Size240to260] EQ 1), Age15Size240to260countF)
        age16Size240to260F = WHERE((Age_Gro[Size240to260] EQ 16) AND (Sex_Gro[Size240to260] EQ 1), Age16Size240to260countF)
        age17Size240to260F = WHERE((Age_Gro[Size240to260] EQ 17) AND (Sex_Gro[Size240to260] EQ 1), Age17Size240to260countF)
        age18Size240to260F = WHERE((Age_Gro[Size240to260] EQ 18) AND (Sex_Gro[Size240to260] EQ 1), Age18Size240to260countF)
        age19Size240to260F = WHERE((Age_Gro[Size240to260] EQ 19) AND (Sex_Gro[Size240to260] EQ 1), Age19Size240to260countF)
        age20Size240to260F = WHERE((Age_Gro[Size240to260] EQ 20) AND (Sex_Gro[Size240to260] EQ 1), Age20Size240to260countF)
        age21Size240to260F = WHERE((Age_Gro[Size240to260] EQ 21) AND (Sex_Gro[Size240to260] EQ 1), Age21Size240to260countF)
        age22Size240to260F = WHERE((Age_Gro[Size240to260] EQ 22) AND (Sex_Gro[Size240to260] EQ 1), Age22Size240to260countF)
        age23Size240to260F = WHERE((Age_Gro[Size240to260] EQ 23) AND (Sex_Gro[Size240to260] EQ 1), Age23Size240to260countF)
        age24Size240to260F = WHERE((Age_Gro[Size240to260] EQ 24) AND (Sex_Gro[Size240to260] EQ 1), Age24Size240to260countF)
        age25Size240to260F = WHERE((Age_Gro[Size240to260] EQ 25) AND (Sex_Gro[Size240to260] EQ 1), Age25Size240to260countF)
        age26Size240to260F = WHERE((Age_Gro[Size240to260] EQ 26) AND (Sex_Gro[Size240to260] EQ 1), Age26Size240to260countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+8L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+8L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+8L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+8L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+8L] = 180
        WAE_length_bin[75, i*NumLengthBin+adj+8L] =Size240to260countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+8L] = Age0Size240to260countF
        WAE_length_bin[77, i*NumLengthBin+adj+8L] = Age1Size240to260countF
        WAE_length_bin[78, i*NumLengthBin+adj+8L] = Age2Size240to260countF
        WAE_length_bin[79, i*NumLengthBin+adj+8L] = Age3Size240to260countF
        WAE_length_bin[80, i*NumLengthBin+adj+8L] = Age4Size240to260countF
        WAE_length_bin[81, i*NumLengthBin+adj+8L] = Age5Size240to260countF
        WAE_length_bin[82, i*NumLengthBin+adj+8L] = Age6Size240to260countF
        WAE_length_bin[83, i*NumLengthBin+adj+8L] = Age7Size240to260countF
        WAE_length_bin[84, i*NumLengthBin+adj+8L] = Age8Size240to260countF
        WAE_length_bin[85, i*NumLengthBin+adj+8L] = Age9Size240to260countF
        WAE_length_bin[86, i*NumLengthBin+adj+8L] = Age10Size240to260countF
        WAE_length_bin[87, i*NumLengthBin+adj+8L] = Age11Size240to260countF
        WAE_length_bin[88, i*NumLengthBin+adj+8L] = Age12Size240to260countF
        WAE_length_bin[89, i*NumLengthBin+adj+8L] = Age13Size240to260countF
        WAE_length_bin[90, i*NumLengthBin+adj+8L] = Age14Size240to260countF
        WAE_length_bin[91, i*NumLengthBin+adj+8L] = Age15Size240to260countF
        WAE_length_bin[92, i*NumLengthBin+adj+8L] = Age16Size240to260countF
        WAE_length_bin[93, i*NumLengthBin+adj+8L] = Age17Size240to260countF
        WAE_length_bin[94, i*NumLengthBin+adj+8L] = Age18Size240to260countF
        WAE_length_bin[95, i*NumLengthBin+adj+8L] = Age19Size240to260countF
        WAE_length_bin[96, i*NumLengthBin+adj+8L] = Age20Size240to260countF
        WAE_length_bin[97, i*NumLengthBin+adj+8L] = Age21Size240to260countF
        WAE_length_bin[98, i*NumLengthBin+adj+8L] = Age22Size240to260countF
        WAE_length_bin[99, i*NumLengthBin+adj+8L] = Age23Size240to260countF
        WAE_length_bin[100, i*NumLengthBin+adj+8L] = Age24Size240to260countF
        WAE_length_bin[101, i*NumLengthBin+adj+8L] = Age25Size240to260countF
        WAE_length_bin[102, i*NumLengthBin+adj+8L] = Age26Size240to260countF
      ENDIF
      PRINT, 'Size240to260F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+8L])
      
      ; length bin 10
      IF Size260to280count GT 0 THEN BEGIN
        age0Size260to280F = WHERE((Age_Gro[Size260to280] EQ 0) AND (Sex_Gro[Size260to280] EQ 1), Age0Size260to280countF)
        age1Size260to280F = WHERE((Age_Gro[Size260to280] EQ 1) AND (Sex_Gro[Size260to280] EQ 1), Age1Size260to280countF)
        age2Size260to280F = WHERE((Age_Gro[Size260to280] EQ 2) AND (Sex_Gro[Size260to280] EQ 1), Age2Size260to280countF)
        age3Size260to280F = WHERE((Age_Gro[Size260to280] EQ 3) AND (Sex_Gro[Size260to280] EQ 1), Age3Size260to280countF)
        age4Size260to280F = WHERE((Age_Gro[Size260to280] EQ 4) AND (Sex_Gro[Size260to280] EQ 1), Age4Size260to280countF)
        age5Size260to280F = WHERE((Age_Gro[Size260to280] EQ 5) AND (Sex_Gro[Size260to280] EQ 1), Age5Size260to280countF)
        age6Size260to280F = WHERE((Age_Gro[Size260to280] EQ 6) AND (Sex_Gro[Size260to280] EQ 1), Age6Size260to280countF)
        age7Size260to280F = WHERE((Age_Gro[Size260to280] EQ 7) AND (Sex_Gro[Size260to280] EQ 1), Age7Size260to280countF)
        age8Size260to280F = WHERE((Age_Gro[Size260to280] EQ 8) AND (Sex_Gro[Size260to280] EQ 1), Age8Size260to280countF)
        age9Size260to280F = WHERE((Age_Gro[Size260to280] EQ 9) AND (Sex_Gro[Size260to280] EQ 1), Age9Size260to280countF)
        age10Size260to280F = WHERE((Age_Gro[Size260to280] EQ 10) AND (Sex_Gro[Size260to280] EQ 1), Age10Size260to280countF)
        age11Size260to280F = WHERE((Age_Gro[Size260to280] EQ 11) AND (Sex_Gro[Size260to280] EQ 1), Age11Size260to280countF)
        AGE12Size260to280F = WHERE((Age_Gro[Size260to280] EQ 12) AND (Sex_Gro[Size260to280] EQ 1), Age12Size260to280countF)
        AGE13Size260to280F = WHERE((Age_Gro[Size260to280] EQ 13) AND (Sex_Gro[Size260to280] EQ 1), Age13Size260to280countF)
        AGE14Size260to280F = WHERE((Age_Gro[Size260to280] EQ 14) AND (Sex_Gro[Size260to280] EQ 1), Age14Size260to280countF)
        AGE15Size260to280F = WHERE((Age_Gro[Size260to280] EQ 15) AND (Sex_Gro[Size260to280] EQ 1), Age15Size260to280countF)
        age16Size260to280F = WHERE((Age_Gro[Size260to280] EQ 16) AND (Sex_Gro[Size260to280] EQ 1), Age16Size260to280countF)
        age17Size260to280F = WHERE((Age_Gro[Size260to280] EQ 17) AND (Sex_Gro[Size260to280] EQ 1), Age17Size260to280countF)
        age18Size260to280F = WHERE((Age_Gro[Size260to280] EQ 18) AND (Sex_Gro[Size260to280] EQ 1), Age18Size260to280countF)
        age19Size260to280F = WHERE((Age_Gro[Size260to280] EQ 19) AND (Sex_Gro[Size260to280] EQ 1), Age19Size260to280countF)
        age20Size260to280F = WHERE((Age_Gro[Size260to280] EQ 20) AND (Sex_Gro[Size260to280] EQ 1), Age20Size260to280countF)
        age21Size260to280F = WHERE((Age_Gro[Size260to280] EQ 21) AND (Sex_Gro[Size260to280] EQ 1), Age21Size260to280countF)
        age22Size260to280F = WHERE((Age_Gro[Size260to280] EQ 22) AND (Sex_Gro[Size260to280] EQ 1), Age22Size260to280countF)
        age23Size260to280F = WHERE((Age_Gro[Size260to280] EQ 23) AND (Sex_Gro[Size260to280] EQ 1), Age23Size260to280countF)
        age24Size260to280F = WHERE((Age_Gro[Size260to280] EQ 24) AND (Sex_Gro[Size260to280] EQ 1), Age24Size260to280countF)
        age25Size260to280F = WHERE((Age_Gro[Size260to280] EQ 25) AND (Sex_Gro[Size260to280] EQ 1), Age25Size260to280countF)
        age26Size260to280F = WHERE((Age_Gro[Size260to280] EQ 26) AND (Sex_Gro[Size260to280] EQ 1), Age26Size260to280countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+9L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+9L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+9L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+9L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+9L] = 260
        WAE_length_bin[75, i*NumLengthBin+adj+9L] =Size260to280countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+9L] = Age0Size260to280countF
        WAE_length_bin[77, i*NumLengthBin+adj+9L] = Age1Size260to280countF
        WAE_length_bin[78, i*NumLengthBin+adj+9L] = Age2Size260to280countF
        WAE_length_bin[79, i*NumLengthBin+adj+9L] = Age3Size260to280countF
        WAE_length_bin[80, i*NumLengthBin+adj+9L] = Age4Size260to280countF
        WAE_length_bin[81, i*NumLengthBin+adj+9L] = Age5Size260to280countF
        WAE_length_bin[82, i*NumLengthBin+adj+9L] = Age6Size260to280countF
        WAE_length_bin[83, i*NumLengthBin+adj+9L] = Age7Size260to280countF
        WAE_length_bin[84, i*NumLengthBin+adj+9L] = Age8Size260to280countF
        WAE_length_bin[85, i*NumLengthBin+adj+9L] = Age9Size260to280countF
        WAE_length_bin[86, i*NumLengthBin+adj+9L] = Age10Size260to280countF
        WAE_length_bin[87, i*NumLengthBin+adj+9L] = Age11Size260to280countF
        WAE_length_bin[88, i*NumLengthBin+adj+9L] = Age12Size260to280countF
        WAE_length_bin[89, i*NumLengthBin+adj+9L] = Age13Size260to280countF
        WAE_length_bin[90, i*NumLengthBin+adj+9L] = Age14Size260to280countF
        WAE_length_bin[91, i*NumLengthBin+adj+9L] = Age15Size260to280countF
        WAE_length_bin[92, i*NumLengthBin+adj+9L] = Age16Size260to280countF
        WAE_length_bin[93, i*NumLengthBin+adj+9L] = Age17Size260to280countF
        WAE_length_bin[94, i*NumLengthBin+adj+9L] = Age18Size260to280countF
        WAE_length_bin[95, i*NumLengthBin+adj+9L] = Age19Size260to280countF
        WAE_length_bin[96, i*NumLengthBin+adj+9L] = Age20Size260to280countF
        WAE_length_bin[97, i*NumLengthBin+adj+9L] = Age21Size260to280countF
        WAE_length_bin[98, i*NumLengthBin+adj+9L] = Age22Size260to280countF
        WAE_length_bin[99, i*NumLengthBin+adj+9L] = Age23Size260to280countF
        WAE_length_bin[100, i*NumLengthBin+adj+9L] = Age24Size260to280countF
        WAE_length_bin[101, i*NumLengthBin+adj+9L] = Age25Size260to280countF
        WAE_length_bin[102, i*NumLengthBin+adj+9L] = Age26Size260to280countF
      ENDIF
      PRINT, 'Size260to280F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+9L])
      
      ; length bin 11
      IF Size280to300count GT 0 THEN BEGIN
        age0Size280to300F = WHERE((Age_Gro[Size280to300] EQ 0) AND (Sex_Gro[Size280to300] EQ 1), Age0Size280to300countF)
        age1Size280to300F = WHERE((Age_Gro[Size280to300] EQ 1) AND (Sex_Gro[Size280to300] EQ 1), Age1Size280to300countF)
        age2Size280to300F = WHERE((Age_Gro[Size280to300] EQ 2) AND (Sex_Gro[Size280to300] EQ 1), Age2Size280to300countF)
        age3Size280to300F = WHERE((Age_Gro[Size280to300] EQ 3) AND (Sex_Gro[Size280to300] EQ 1), Age3Size280to300countF)
        age4Size280to300F = WHERE((Age_Gro[Size280to300] EQ 4) AND (Sex_Gro[Size280to300] EQ 1), Age4Size280to300countF)
        age5Size280to300F = WHERE((Age_Gro[Size280to300] EQ 5) AND (Sex_Gro[Size280to300] EQ 1), Age5Size280to300countF)
        age6Size280to300F = WHERE((Age_Gro[Size280to300] EQ 6) AND (Sex_Gro[Size280to300] EQ 1), Age6Size280to300countF)
        age7Size280to300F = WHERE((Age_Gro[Size280to300] EQ 7) AND (Sex_Gro[Size280to300] EQ 1), Age7Size280to300countF)
        age8Size280to300F = WHERE((Age_Gro[Size280to300] EQ 8) AND (Sex_Gro[Size280to300] EQ 1), Age8Size280to300countF)
        age9Size280to300F = WHERE((Age_Gro[Size280to300] EQ 9) AND (Sex_Gro[Size280to300] EQ 1), Age9Size280to300countF)
        age10Size280to300F = WHERE((Age_Gro[Size280to300] EQ 10) AND (Sex_Gro[Size280to300] EQ 1), Age10Size280to300countF)
        age11Size280to300F = WHERE((Age_Gro[Size280to300] EQ 11) AND (Sex_Gro[Size280to300] EQ 1), Age11Size280to300countF)
        AGE12Size280to300F = WHERE((Age_Gro[Size280to300] EQ 12) AND (Sex_Gro[Size280to300] EQ 1), Age12Size280to300countF)
        AGE13Size280to300F = WHERE((Age_Gro[Size280to300] EQ 13) AND (Sex_Gro[Size280to300] EQ 1), Age13Size280to300countF)
        AGE14Size280to300F = WHERE((Age_Gro[Size280to300] EQ 14) AND (Sex_Gro[Size280to300] EQ 1), Age14Size280to300countF)
        AGE15Size280to300F = WHERE((Age_Gro[Size280to300] EQ 15) AND (Sex_Gro[Size280to300] EQ 1), Age15Size280to300countF)
        age16Size280to300F = WHERE((Age_Gro[Size280to300] EQ 16) AND (Sex_Gro[Size280to300] EQ 1), Age16Size280to300countF)
        age17Size280to300F = WHERE((Age_Gro[Size280to300] EQ 17) AND (Sex_Gro[Size280to300] EQ 1), Age17Size280to300countF)
        age18Size280to300F = WHERE((Age_Gro[Size280to300] EQ 18) AND (Sex_Gro[Size280to300] EQ 1), Age18Size280to300countF)
        age19Size280to300F = WHERE((Age_Gro[Size280to300] EQ 19) AND (Sex_Gro[Size280to300] EQ 1), Age19Size280to300countF)
        age20Size280to300F = WHERE((Age_Gro[Size280to300] EQ 20) AND (Sex_Gro[Size280to300] EQ 1), Age20Size280to300countF)
        age21Size280to300F = WHERE((Age_Gro[Size280to300] EQ 21) AND (Sex_Gro[Size280to300] EQ 1), Age21Size280to300countF)
        age22Size280to300F = WHERE((Age_Gro[Size280to300] EQ 22) AND (Sex_Gro[Size280to300] EQ 1), Age22Size280to300countF)
        age23Size280to300F = WHERE((Age_Gro[Size280to300] EQ 23) AND (Sex_Gro[Size280to300] EQ 1), Age23Size280to300countF)
        age24Size280to300F = WHERE((Age_Gro[Size280to300] EQ 24) AND (Sex_Gro[Size280to300] EQ 1), Age24Size280to300countF)
        age25Size280to300F = WHERE((Age_Gro[Size280to300] EQ 25) AND (Sex_Gro[Size280to300] EQ 1), Age25Size280to300countF)
        age26Size280to300F = WHERE((Age_Gro[Size280to300] EQ 26) AND (Sex_Gro[Size280to300] EQ 1), Age26Size280to300countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+10L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+10L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+10L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+10L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+10L] = 280
        WAE_length_bin[75, i*NumLengthBin+adj+10L] = Size280to300countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+10L] = Age0Size280to300countF
        WAE_length_bin[77, i*NumLengthBin+adj+10L] = Age1Size280to300countF
        WAE_length_bin[78, i*NumLengthBin+adj+10L] = Age2Size280to300countF
        WAE_length_bin[79, i*NumLengthBin+adj+10L] = Age3Size280to300countF
        WAE_length_bin[80, i*NumLengthBin+adj+10L] = Age4Size280to300countF
        WAE_length_bin[81, i*NumLengthBin+adj+10L] = Age5Size280to300countF
        WAE_length_bin[82, i*NumLengthBin+adj+10L] = Age6Size280to300countF
        WAE_length_bin[83, i*NumLengthBin+adj+10L] = Age7Size280to300countF
        WAE_length_bin[84, i*NumLengthBin+adj+10L] = Age8Size280to300countF
        WAE_length_bin[85, i*NumLengthBin+adj+10L] = Age9Size280to300countF
        WAE_length_bin[86, i*NumLengthBin+adj+10L] = Age10Size280to300countF
        WAE_length_bin[87, i*NumLengthBin+adj+10L] = Age11Size280to300countF
        WAE_length_bin[88, i*NumLengthBin+adj+10L] = Age12Size280to300countF
        WAE_length_bin[89, i*NumLengthBin+adj+10L] = Age13Size280to300countF
        WAE_length_bin[90, i*NumLengthBin+adj+10L] = Age14Size280to300countF
        WAE_length_bin[91, i*NumLengthBin+adj+10L] = Age15Size280to300countF
        WAE_length_bin[92, i*NumLengthBin+adj+10L] = Age16Size280to300countF
        WAE_length_bin[93, i*NumLengthBin+adj+10L] = Age17Size280to300countF
        WAE_length_bin[94, i*NumLengthBin+adj+10L] = Age18Size280to300countF
        WAE_length_bin[95, i*NumLengthBin+adj+10L] = Age19Size280to300countF
        WAE_length_bin[96, i*NumLengthBin+adj+10L] = Age20Size280to300countF
        WAE_length_bin[97, i*NumLengthBin+adj+10L] = Age21Size280to300countF
        WAE_length_bin[98, i*NumLengthBin+adj+10L] = Age22Size280to300countF
        WAE_length_bin[99, i*NumLengthBin+adj+10L] = Age23Size280to300countF
        WAE_length_bin[100, i*NumLengthBin+adj+10L] = Age24Size280to300countF
        WAE_length_bin[101, i*NumLengthBin+adj+10L] = Age25Size280to300countF
        WAE_length_bin[102, i*NumLengthBin+adj+10L] = Age26Size280to300countF
      ENDIF
      PRINT, 'Size280to300F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+10L])
      
      ; length bin 12
      IF Size300to320count GT 0 THEN BEGIN
        age0Size300to320F = WHERE((Age_Gro[Size300to320] EQ 0) AND (Sex_Gro[Size300to320] EQ 1), Age0Size300to320countF)
        age1Size300to320F = WHERE((Age_Gro[Size300to320] EQ 1) AND (Sex_Gro[Size300to320] EQ 1), Age1Size300to320countF)
        age2Size300to320F = WHERE((Age_Gro[Size300to320] EQ 2) AND (Sex_Gro[Size300to320] EQ 1), Age2Size300to320countF)
        age3Size300to320F = WHERE((Age_Gro[Size300to320] EQ 3) AND (Sex_Gro[Size300to320] EQ 1), Age3Size300to320countF)
        age4Size300to320F = WHERE((Age_Gro[Size300to320] EQ 4) AND (Sex_Gro[Size300to320] EQ 1), Age4Size300to320countF)
        age5Size300to320F = WHERE((Age_Gro[Size300to320] EQ 5) AND (Sex_Gro[Size300to320] EQ 1), Age5Size300to320countF)
        age6Size300to320F = WHERE((Age_Gro[Size300to320] EQ 6) AND (Sex_Gro[Size300to320] EQ 1), Age6Size300to320countF)
        age7Size300to320F = WHERE((Age_Gro[Size300to320] EQ 7) AND (Sex_Gro[Size300to320] EQ 1), Age7Size300to320countF)
        age8Size300to320F = WHERE((Age_Gro[Size300to320] EQ 8) AND (Sex_Gro[Size300to320] EQ 1), Age8Size300to320countF)
        age9Size300to320F = WHERE((Age_Gro[Size300to320] EQ 9) AND (Sex_Gro[Size300to320] EQ 1), Age9Size300to320countF)
        age10Size300to320F = WHERE((Age_Gro[Size300to320] EQ 10) AND (Sex_Gro[Size300to320] EQ 1), Age10Size300to320countF)
        age11Size300to320F = WHERE((Age_Gro[Size300to320] EQ 11) AND (Sex_Gro[Size300to320] EQ 1), Age11Size300to320countF)
        AGE12Size300to320F = WHERE((Age_Gro[Size300to320] EQ 12) AND (Sex_Gro[Size300to320] EQ 1), Age12Size300to320countF)
        AGE13Size300to320F = WHERE((Age_Gro[Size300to320] EQ 13) AND (Sex_Gro[Size300to320] EQ 1), Age13Size300to320countF)
        AGE14Size300to320F = WHERE((Age_Gro[Size300to320] EQ 14) AND (Sex_Gro[Size300to320] EQ 1), Age14Size300to320countF)
        AGE15Size300to320F = WHERE((Age_Gro[Size300to320] EQ 15) AND (Sex_Gro[Size300to320] EQ 1), Age15Size300to320countF)
        age16Size300to320F = WHERE((Age_Gro[Size300to320] EQ 16) AND (Sex_Gro[Size300to320] EQ 1), Age16Size300to320countF)
        age17Size300to320F = WHERE((Age_Gro[Size300to320] EQ 17) AND (Sex_Gro[Size300to320] EQ 1), Age17Size300to320countF)
        age18Size300to320F = WHERE((Age_Gro[Size300to320] EQ 18) AND (Sex_Gro[Size300to320] EQ 1), Age18Size300to320countF)
        age19Size300to320F = WHERE((Age_Gro[Size300to320] EQ 19) AND (Sex_Gro[Size300to320] EQ 1), Age19Size300to320countF)
        age20Size300to320F = WHERE((Age_Gro[Size300to320] EQ 20) AND (Sex_Gro[Size300to320] EQ 1), Age20Size300to320countF)
        age21Size300to320F = WHERE((Age_Gro[Size300to320] EQ 21) AND (Sex_Gro[Size300to320] EQ 1), Age21Size300to320countF)
        age22Size300to320F = WHERE((Age_Gro[Size300to320] EQ 22) AND (Sex_Gro[Size300to320] EQ 1), Age22Size300to320countF)
        age23Size300to320F = WHERE((Age_Gro[Size300to320] EQ 23) AND (Sex_Gro[Size300to320] EQ 1), Age23Size300to320countF)
        age24Size300to320F = WHERE((Age_Gro[Size300to320] EQ 24) AND (Sex_Gro[Size300to320] EQ 1), Age24Size300to320countF)
        age25Size300to320F = WHERE((Age_Gro[Size300to320] EQ 25) AND (Sex_Gro[Size300to320] EQ 1), Age25Size300to320countF)
        age26Size300to320F = WHERE((Age_Gro[Size300to320] EQ 26) AND (Sex_Gro[Size300to320] EQ 1), Age26Size300to320countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+11L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+11L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+11L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+11L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+11L] = 300
        WAE_length_bin[75, i*NumLengthBin+adj+11L] = Size300to320countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+11L] = Age0Size300to320countF
        WAE_length_bin[77, i*NumLengthBin+adj+11L] = Age1Size300to320countF
        WAE_length_bin[78, i*NumLengthBin+adj+11L] = Age2Size300to320countF
        WAE_length_bin[79, i*NumLengthBin+adj+11L] = Age3Size300to320countF
        WAE_length_bin[80, i*NumLengthBin+adj+11L] = Age4Size300to320countF
        WAE_length_bin[81, i*NumLengthBin+adj+11L] = Age5Size300to320countF
        WAE_length_bin[82, i*NumLengthBin+adj+11L] = Age6Size300to320countF
        WAE_length_bin[83, i*NumLengthBin+adj+11L] = Age7Size300to320countF
        WAE_length_bin[84, i*NumLengthBin+adj+11L] = Age8Size300to320countF
        WAE_length_bin[85, i*NumLengthBin+adj+11L] = Age9Size300to320countF
        WAE_length_bin[86, i*NumLengthBin+adj+11L] = Age10Size300to320countF
        WAE_length_bin[87, i*NumLengthBin+adj+11L] = Age11Size300to320countF
        WAE_length_bin[88, i*NumLengthBin+adj+11L] = Age12Size300to320countF
        WAE_length_bin[89, i*NumLengthBin+adj+11L] = Age13Size300to320countF
        WAE_length_bin[90, i*NumLengthBin+adj+11L] = Age14Size300to320countF
        WAE_length_bin[91, i*NumLengthBin+adj+11L] = Age15Size300to320countF
        WAE_length_bin[92, i*NumLengthBin+adj+11L] = Age16Size300to320countF
        WAE_length_bin[93, i*NumLengthBin+adj+11L] = Age17Size300to320countF
        WAE_length_bin[94, i*NumLengthBin+adj+11L] = Age18Size300to320countF
        WAE_length_bin[95, i*NumLengthBin+adj+11L] = Age19Size300to320countF
        WAE_length_bin[96, i*NumLengthBin+adj+11L] = Age20Size300to320countF
        WAE_length_bin[97, i*NumLengthBin+adj+11L] = Age21Size300to320countF
        WAE_length_bin[98, i*NumLengthBin+adj+11L] = Age22Size300to320countF
        WAE_length_bin[99, i*NumLengthBin+adj+11L] = Age23Size300to320countF
        WAE_length_bin[100, i*NumLengthBin+adj+11L] = Age24Size300to320countF
        WAE_length_bin[101, i*NumLengthBin+adj+11L] = Age25Size300to320countF
        WAE_length_bin[102, i*NumLengthBin+adj+11L] = Age26Size300to320countF
      ENDIF
      PRINT, 'Size300to320F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+11L])
      
      ; length bin 13
      IF Size320to340count GT 0 THEN BEGIN
        age0Size320to340F = WHERE((Age_Gro[Size320to340] EQ 0) AND (Sex_Gro[Size320to340] EQ 1), Age0Size320to340countF)
        age1Size320to340F = WHERE((Age_Gro[Size320to340] EQ 1) AND (Sex_Gro[Size320to340] EQ 1), Age1Size320to340countF)
        age2Size320to340F = WHERE((Age_Gro[Size320to340] EQ 2) AND (Sex_Gro[Size320to340] EQ 1), Age2Size320to340countF)
        age3Size320to340F = WHERE((Age_Gro[Size320to340] EQ 3) AND (Sex_Gro[Size320to340] EQ 1), Age3Size320to340countF)
        age4Size320to340F = WHERE((Age_Gro[Size320to340] EQ 4) AND (Sex_Gro[Size320to340] EQ 1), Age4Size320to340countF)
        age5Size320to340F = WHERE((Age_Gro[Size320to340] EQ 5) AND (Sex_Gro[Size320to340] EQ 1), Age5Size320to340countF)
        age6Size320to340F = WHERE((Age_Gro[Size320to340] EQ 6) AND (Sex_Gro[Size320to340] EQ 1), Age6Size320to340countF)
        age7Size320to340F = WHERE((Age_Gro[Size320to340] EQ 7) AND (Sex_Gro[Size320to340] EQ 1), Age7Size320to340countF)
        age8Size320to340F = WHERE((Age_Gro[Size320to340] EQ 8) AND (Sex_Gro[Size320to340] EQ 1), Age8Size320to340countF)
        age9Size320to340F = WHERE((Age_Gro[Size320to340] EQ 9) AND (Sex_Gro[Size320to340] EQ 1), Age9Size320to340countF)
        age10Size320to340F = WHERE((Age_Gro[Size320to340] EQ 10) AND (Sex_Gro[Size320to340] EQ 1), Age10Size320to340countF)
        age11Size320to340F = WHERE((Age_Gro[Size320to340] EQ 11) AND (Sex_Gro[Size320to340] EQ 1), Age11Size320to340countF)
        AGE12Size320to340F = WHERE((Age_Gro[Size320to340] EQ 12) AND (Sex_Gro[Size320to340] EQ 1), Age12Size320to340countF)
        AGE13Size320to340F = WHERE((Age_Gro[Size320to340] EQ 13) AND (Sex_Gro[Size320to340] EQ 1), Age13Size320to340countF)
        AGE14Size320to340F = WHERE((Age_Gro[Size320to340] EQ 14) AND (Sex_Gro[Size320to340] EQ 1), Age14Size320to340countF)
        AGE15Size320to340F = WHERE((Age_Gro[Size320to340] EQ 15) AND (Sex_Gro[Size320to340] EQ 1), Age15Size320to340countF)
        age16Size320to340F = WHERE((Age_Gro[Size320to340] EQ 16) AND (Sex_Gro[Size320to340] EQ 1), Age16Size320to340countF)
        age17Size320to340F = WHERE((Age_Gro[Size320to340] EQ 17) AND (Sex_Gro[Size320to340] EQ 1), Age17Size320to340countF)
        age18Size320to340F = WHERE((Age_Gro[Size320to340] EQ 18) AND (Sex_Gro[Size320to340] EQ 1), Age18Size320to340countF)
        age19Size320to340F = WHERE((Age_Gro[Size320to340] EQ 19) AND (Sex_Gro[Size320to340] EQ 1), Age19Size320to340countF)
        age20Size320to340F = WHERE((Age_Gro[Size320to340] EQ 20) AND (Sex_Gro[Size320to340] EQ 1), Age20Size320to340countF)
        age21Size320to340F = WHERE((Age_Gro[Size320to340] EQ 21) AND (Sex_Gro[Size320to340] EQ 1), Age21Size320to340countF)
        age22Size320to340F = WHERE((Age_Gro[Size320to340] EQ 22) AND (Sex_Gro[Size320to340] EQ 1), Age22Size320to340countF)
        age23Size320to340F = WHERE((Age_Gro[Size320to340] EQ 23) AND (Sex_Gro[Size320to340] EQ 1), Age23Size320to340countF)
        age24Size320to340F = WHERE((Age_Gro[Size320to340] EQ 24) AND (Sex_Gro[Size320to340] EQ 1), Age24Size320to340countF)
        age25Size320to340F = WHERE((Age_Gro[Size320to340] EQ 25) AND (Sex_Gro[Size320to340] EQ 1), Age25Size320to340countF)
        age26Size320to340F = WHERE((Age_Gro[Size320to340] EQ 26) AND (Sex_Gro[Size320to340] EQ 1), Age26Size320to340countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+12L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+12L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+12L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+12L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+12L] = 320
        WAE_length_bin[75, i*NumLengthBin+adj+12L] = Size320to340countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+12L] = Age0Size320to340countF
        WAE_length_bin[77, i*NumLengthBin+adj+12L] = Age1Size320to340countF
        WAE_length_bin[78, i*NumLengthBin+adj+12L] = Age2Size320to340countF
        WAE_length_bin[79, i*NumLengthBin+adj+12L] = Age3Size320to340countF
        WAE_length_bin[80, i*NumLengthBin+adj+12L] = Age4Size320to340countF
        WAE_length_bin[81, i*NumLengthBin+adj+12L] = Age5Size320to340countF
        WAE_length_bin[82, i*NumLengthBin+adj+12L] = Age6Size320to340countF
        WAE_length_bin[83, i*NumLengthBin+adj+12L] = Age7Size320to340countF
        WAE_length_bin[84, i*NumLengthBin+adj+12L] = Age8Size320to340countF
        WAE_length_bin[85, i*NumLengthBin+adj+12L] = Age9Size320to340countF
        WAE_length_bin[86, i*NumLengthBin+adj+12L] = Age10Size320to340countF
        WAE_length_bin[87, i*NumLengthBin+adj+12L] = Age11Size320to340countF
        WAE_length_bin[88, i*NumLengthBin+adj+12L] = Age12Size320to340countF
        WAE_length_bin[89, i*NumLengthBin+adj+12L] = Age13Size320to340countF
        WAE_length_bin[90, i*NumLengthBin+adj+12L] = Age14Size320to340countF
        WAE_length_bin[91, i*NumLengthBin+adj+12L] = Age15Size320to340countF
        WAE_length_bin[92, i*NumLengthBin+adj+12L] = Age16Size320to340countF
        WAE_length_bin[93, i*NumLengthBin+adj+12L] = Age17Size320to340countF
        WAE_length_bin[94, i*NumLengthBin+adj+12L] = Age18Size320to340countF
        WAE_length_bin[95, i*NumLengthBin+adj+12L] = Age19Size320to340countF
        WAE_length_bin[96, i*NumLengthBin+adj+12L] = Age20Size320to340countF
        WAE_length_bin[97, i*NumLengthBin+adj+12L] = Age21Size320to340countF
        WAE_length_bin[98, i*NumLengthBin+adj+12L] = Age22Size320to340countF
        WAE_length_bin[99, i*NumLengthBin+adj+12L] = Age23Size320to340countF
        WAE_length_bin[100, i*NumLengthBin+adj+12L] = Age24Size320to340countF
        WAE_length_bin[101, i*NumLengthBin+adj+12L] = Age25Size320to340countF
        WAE_length_bin[102, i*NumLengthBin+adj+12L] = Age26Size320to340countF
      ENDIF
      PRINT, 'Size320to340F', TOTAL(WAE_length_bin[70L:102, i*NumLengthBin+adj+13L])
      
      ; length bin 14
      IF Size340to360count GT 0 THEN BEGIN
        age0Size340to360F = WHERE((Age_Gro[Size340to360] EQ 0) AND (Sex_Gro[Size340to360] EQ 1), Age0Size340to360countF)
        age1Size340to360F = WHERE((Age_Gro[Size340to360] EQ 1) AND (Sex_Gro[Size340to360] EQ 1), Age1Size340to360countF)
        age2Size340to360F = WHERE((Age_Gro[Size340to360] EQ 2) AND (Sex_Gro[Size340to360] EQ 1), Age2Size340to360countF)
        age3Size340to360F = WHERE((Age_Gro[Size340to360] EQ 3) AND (Sex_Gro[Size340to360] EQ 1), Age3Size340to360countF)
        age4Size340to360F = WHERE((Age_Gro[Size340to360] EQ 4) AND (Sex_Gro[Size340to360] EQ 1), Age4Size340to360countF)
        age5Size340to360F = WHERE((Age_Gro[Size340to360] EQ 5) AND (Sex_Gro[Size340to360] EQ 1), Age5Size340to360countF)
        age6Size340to360F = WHERE((Age_Gro[Size340to360] EQ 6) AND (Sex_Gro[Size340to360] EQ 1), Age6Size340to360countF)
        age7Size340to360F = WHERE((Age_Gro[Size340to360] EQ 7) AND (Sex_Gro[Size340to360] EQ 1), Age7Size340to360countF)
        age8Size340to360F = WHERE((Age_Gro[Size340to360] EQ 8) AND (Sex_Gro[Size340to360] EQ 1), Age8Size340to360countF)
        age9Size340to360F = WHERE((Age_Gro[Size340to360] EQ 9) AND (Sex_Gro[Size340to360] EQ 1), Age9Size340to360countF)
        age10Size340to360F = WHERE((Age_Gro[Size340to360] EQ 10) AND (Sex_Gro[Size340to360] EQ 1), Age10Size340to360countF)
        age11Size340to360F = WHERE((Age_Gro[Size340to360] EQ 11) AND (Sex_Gro[Size340to360] EQ 1), Age11Size340to360countF)
        AGE12Size340to360F = WHERE((Age_Gro[Size340to360] EQ 12) AND (Sex_Gro[Size340to360] EQ 1), Age12Size340to360countF)
        AGE13Size340to360F = WHERE((Age_Gro[Size340to360] EQ 13) AND (Sex_Gro[Size340to360] EQ 1), Age13Size340to360countF)
        AGE14Size340to360F = WHERE((Age_Gro[Size340to360] EQ 14) AND (Sex_Gro[Size340to360] EQ 1), Age14Size340to360countF)
        AGE15Size340to360F = WHERE((Age_Gro[Size340to360] EQ 15) AND (Sex_Gro[Size340to360] EQ 1), Age15Size340to360countF)
        age16Size340to360F = WHERE((Age_Gro[Size340to360] EQ 16) AND (Sex_Gro[Size340to360] EQ 1), Age16Size340to360countF)
        age17Size340to360F = WHERE((Age_Gro[Size340to360] EQ 17) AND (Sex_Gro[Size340to360] EQ 1), Age17Size340to360countF)
        age18Size340to360F = WHERE((Age_Gro[Size340to360] EQ 18) AND (Sex_Gro[Size340to360] EQ 1), Age18Size340to360countF)
        age19Size340to360F = WHERE((Age_Gro[Size340to360] EQ 19) AND (Sex_Gro[Size340to360] EQ 1), Age19Size340to360countF)
        age20Size340to360F = WHERE((Age_Gro[Size340to360] EQ 20) AND (Sex_Gro[Size340to360] EQ 1), Age20Size340to360countF)
        age21Size340to360F = WHERE((Age_Gro[Size340to360] EQ 21) AND (Sex_Gro[Size340to360] EQ 1), Age21Size340to360countF)
        age22Size340to360F = WHERE((Age_Gro[Size340to360] EQ 22) AND (Sex_Gro[Size340to360] EQ 1), Age22Size340to360countF)
        age23Size340to360F = WHERE((Age_Gro[Size340to360] EQ 23) AND (Sex_Gro[Size340to360] EQ 1), Age23Size340to360countF)
        age24Size340to360F = WHERE((Age_Gro[Size340to360] EQ 24) AND (Sex_Gro[Size340to360] EQ 1), Age24Size340to360countF)
        age25Size340to360F = WHERE((Age_Gro[Size340to360] EQ 25) AND (Sex_Gro[Size340to360] EQ 1), Age25Size340to360countF)
        age26Size340to360F = WHERE((Age_Gro[Size340to360] EQ 26) AND (Sex_Gro[Size340to360] EQ 1), Age26Size340to360countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+13L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+13L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+13L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+13L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+13L] = 340
        WAE_length_bin[75, i*NumLengthBin+adj+14L] = Size340to360countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+13L] = Age0Size340to360countF
        WAE_length_bin[77, i*NumLengthBin+adj+13L] = Age1Size340to360countF
        WAE_length_bin[78, i*NumLengthBin+adj+13L] = Age2Size340to360countF
        WAE_length_bin[79, i*NumLengthBin+adj+13L] = Age3Size340to360countF
        WAE_length_bin[80, i*NumLengthBin+adj+13L] = Age4Size340to360countF
        WAE_length_bin[81, i*NumLengthBin+adj+13L] = Age5Size340to360countF
        WAE_length_bin[82, i*NumLengthBin+adj+13L] = Age6Size340to360countF
        WAE_length_bin[83, i*NumLengthBin+adj+13L] = Age7Size340to360countF
        WAE_length_bin[84, i*NumLengthBin+adj+13L] = Age8Size340to360countF
        WAE_length_bin[85, i*NumLengthBin+adj+13L] = Age9Size340to360countF
        WAE_length_bin[86, i*NumLengthBin+adj+13L] = Age10Size340to360countF
        WAE_length_bin[87, i*NumLengthBin+adj+13L] = Age11Size340to360countF
        WAE_length_bin[88, i*NumLengthBin+adj+13L] = Age12Size340to360countF
        WAE_length_bin[89, i*NumLengthBin+adj+13L] = Age13Size340to360countF
        WAE_length_bin[90, i*NumLengthBin+adj+13L] = Age14Size340to360countF
        WAE_length_bin[91, i*NumLengthBin+adj+13L] = Age15Size340to360countF
        WAE_length_bin[92, i*NumLengthBin+adj+13L] = Age16Size340to360countF
        WAE_length_bin[93, i*NumLengthBin+adj+13L] = Age17Size340to360countF
        WAE_length_bin[94, i*NumLengthBin+adj+13L] = Age18Size340to360countF
        WAE_length_bin[95, i*NumLengthBin+adj+13L] = Age19Size340to360countF
        WAE_length_bin[96, i*NumLengthBin+adj+13L] = Age20Size340to360countF
        WAE_length_bin[97, i*NumLengthBin+adj+13L] = Age21Size340to360countF
        WAE_length_bin[98, i*NumLengthBin+adj+13L] = Age22Size340to360countF
        WAE_length_bin[99, i*NumLengthBin+adj+13L] = Age23Size340to360countF
        WAE_length_bin[100, i*NumLengthBin+adj+13L] = Age24Size340to360countF
        WAE_length_bin[101, i*NumLengthBin+adj+13L] = Age25Size340to360countF
        WAE_length_bin[102, i*NumLengthBin+adj+13L] = Age26Size340to360countF
      ENDIF
      PRINT, 'Size340to360F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+14L])
      
      ; length bin 15
      IF Size360to380count GT 0 THEN BEGIN
        age0Size360to380F = WHERE((Age_Gro[Size360to380] EQ 0) AND (Sex_Gro[Size360to380] EQ 1), Age0Size360to380countF)
        age1Size360to380F = WHERE((Age_Gro[Size360to380] EQ 1) AND (Sex_Gro[Size360to380] EQ 1), Age1Size360to380countF)
        age2Size360to380F = WHERE((Age_Gro[Size360to380] EQ 2) AND (Sex_Gro[Size360to380] EQ 1), Age2Size360to380countF)
        age3Size360to380F = WHERE((Age_Gro[Size360to380] EQ 3) AND (Sex_Gro[Size360to380] EQ 1), Age3Size360to380countF)
        age4Size360to380F = WHERE((Age_Gro[Size360to380] EQ 4) AND (Sex_Gro[Size360to380] EQ 1), Age4Size360to380countF)
        age5Size360to380F = WHERE((Age_Gro[Size360to380] EQ 5) AND (Sex_Gro[Size360to380] EQ 1), Age5Size360to380countF)
        age6Size360to380F = WHERE((Age_Gro[Size360to380] EQ 6) AND (Sex_Gro[Size360to380] EQ 1), Age6Size360to380countF)
        age7Size360to380F = WHERE((Age_Gro[Size360to380] EQ 7) AND (Sex_Gro[Size360to380] EQ 1), Age7Size360to380countF)
        age8Size360to380F = WHERE((Age_Gro[Size360to380] EQ 8) AND (Sex_Gro[Size360to380] EQ 1), Age8Size360to380countF)
        age9Size360to380F = WHERE((Age_Gro[Size360to380] EQ 9) AND (Sex_Gro[Size360to380] EQ 1), Age9Size360to380countF)
        age10Size360to380F = WHERE((Age_Gro[Size360to380] EQ 10) AND (Sex_Gro[Size360to380] EQ 1), Age10Size360to380countF)
        age11Size360to380F = WHERE((Age_Gro[Size360to380] EQ 11) AND (Sex_Gro[Size360to380] EQ 1), Age11Size360to380countF)
        AGE12Size360to380F = WHERE((Age_Gro[Size360to380] EQ 12) AND (Sex_Gro[Size360to380] EQ 1), Age12Size360to380countF)
        AGE13Size360to380F = WHERE((Age_Gro[Size360to380] EQ 13) AND (Sex_Gro[Size360to380] EQ 1), Age13Size360to380countF)
        AGE14Size360to380F = WHERE((Age_Gro[Size360to380] EQ 14) AND (Sex_Gro[Size360to380] EQ 1), Age14Size360to380countF)
        AGE15Size360to380F = WHERE((Age_Gro[Size360to380] EQ 15) AND (Sex_Gro[Size360to380] EQ 1), Age15Size360to380countF)
        age16Size360to380F = WHERE((Age_Gro[Size360to380] EQ 16) AND (Sex_Gro[Size360to380] EQ 1), Age16Size360to380countF)
        age17Size360to380F = WHERE((Age_Gro[Size360to380] EQ 17) AND (Sex_Gro[Size360to380] EQ 1), Age17Size360to380countF)
        age18Size360to380F = WHERE((Age_Gro[Size360to380] EQ 18) AND (Sex_Gro[Size360to380] EQ 1), Age18Size360to380countF)
        age19Size360to380F = WHERE((Age_Gro[Size360to380] EQ 19) AND (Sex_Gro[Size360to380] EQ 1), Age19Size360to380countF)
        age20Size360to380F = WHERE((Age_Gro[Size360to380] EQ 20) AND (Sex_Gro[Size360to380] EQ 1), Age20Size360to380countF)
        age21Size360to380F = WHERE((Age_Gro[Size360to380] EQ 21) AND (Sex_Gro[Size360to380] EQ 1), Age21Size360to380countF)
        age22Size360to380F = WHERE((Age_Gro[Size360to380] EQ 22) AND (Sex_Gro[Size360to380] EQ 1), Age22Size360to380countF)
        age23Size360to380F = WHERE((Age_Gro[Size360to380] EQ 23) AND (Sex_Gro[Size360to380] EQ 1), Age23Size360to380countF)
        age24Size360to380F = WHERE((Age_Gro[Size360to380] EQ 24) AND (Sex_Gro[Size360to380] EQ 1), Age24Size360to380countF)
        age25Size360to380F = WHERE((Age_Gro[Size360to380] EQ 25) AND (Sex_Gro[Size360to380] EQ 1), Age25Size360to380countF)
        age26Size360to380F = WHERE((Age_Gro[Size360to380] EQ 26) AND (Sex_Gro[Size360to380] EQ 1), Age26Size360to380countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+14L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+14L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+14L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+14L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+14L] = 360
        WAE_length_bin[75, i*NumLengthBin+adj+14L] = Size360to380countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+14L] = Age0Size360to380countF
        WAE_length_bin[77, i*NumLengthBin+adj+14L] = Age1Size360to380countF
        WAE_length_bin[78, i*NumLengthBin+adj+14L] = Age2Size360to380countF
        WAE_length_bin[79, i*NumLengthBin+adj+14L] = Age3Size360to380countF
        WAE_length_bin[80, i*NumLengthBin+adj+14L] = Age4Size360to380countF
        WAE_length_bin[81, i*NumLengthBin+adj+14L] = Age5Size360to380countF
        WAE_length_bin[82, i*NumLengthBin+adj+14L] = Age6Size360to380countF
        WAE_length_bin[83, i*NumLengthBin+adj+14L] = Age7Size360to380countF
        WAE_length_bin[84, i*NumLengthBin+adj+14L] = Age8Size360to380countF
        WAE_length_bin[85, i*NumLengthBin+adj+14L] = Age9Size360to380countF
        WAE_length_bin[86, i*NumLengthBin+adj+14L] = Age10Size360to380countF
        WAE_length_bin[87, i*NumLengthBin+adj+14L] = Age11Size360to380countF
        WAE_length_bin[88, i*NumLengthBin+adj+14L] = Age12Size360to380countF
        WAE_length_bin[89, i*NumLengthBin+adj+14L] = Age13Size360to380countF
        WAE_length_bin[90, i*NumLengthBin+adj+14L] = Age14Size360to380countF
        WAE_length_bin[91, i*NumLengthBin+adj+14L] = Age15Size360to380countF
        WAE_length_bin[92, i*NumLengthBin+adj+14L] = Age16Size360to380countF
        WAE_length_bin[93, i*NumLengthBin+adj+14L] = Age17Size360to380countF
        WAE_length_bin[94, i*NumLengthBin+adj+14L] = Age18Size360to380countF
        WAE_length_bin[95, i*NumLengthBin+adj+14L] = Age19Size360to380countF
        WAE_length_bin[96, i*NumLengthBin+adj+14L] = Age20Size360to380countF
        WAE_length_bin[97, i*NumLengthBin+adj+14L] = Age21Size360to380countF
        WAE_length_bin[98, i*NumLengthBin+adj+14L] = Age22Size360to380countF
        WAE_length_bin[99, i*NumLengthBin+adj+14L] = Age23Size360to380countF
        WAE_length_bin[100, i*NumLengthBin+adj+14L] = Age24Size360to380countF
        WAE_length_bin[101, i*NumLengthBin+adj+14L] = Age25Size360to380countF
        WAE_length_bin[102, i*NumLengthBin+adj+14L] = Age26Size360to380countF
      ENDIF
      PRINT, 'Size360to380F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+14L])
      
      ; length bin 16
      IF Size380to400count GT 0 THEN BEGIN
        age0Size380to400F = WHERE((Age_Gro[Size380to400] EQ 0) AND (Sex_Gro[Size380to400] EQ 1), Age0Size380to400countF)
        age1Size380to400F = WHERE((Age_Gro[Size380to400] EQ 1) AND (Sex_Gro[Size380to400] EQ 1), Age1Size380to400countF)
        age2Size380to400F = WHERE((Age_Gro[Size380to400] EQ 2) AND (Sex_Gro[Size380to400] EQ 1), Age2Size380to400countF)
        age3Size380to400F = WHERE((Age_Gro[Size380to400] EQ 3) AND (Sex_Gro[Size380to400] EQ 1), Age3Size380to400countF)
        age4Size380to400F = WHERE((Age_Gro[Size380to400] EQ 4) AND (Sex_Gro[Size380to400] EQ 1), Age4Size380to400countF)
        age5Size380to400F = WHERE((Age_Gro[Size380to400] EQ 5) AND (Sex_Gro[Size380to400] EQ 1), Age5Size380to400countF)
        age6Size380to400F = WHERE((Age_Gro[Size380to400] EQ 6) AND (Sex_Gro[Size380to400] EQ 1), Age6Size380to400countF)
        age7Size380to400F = WHERE((Age_Gro[Size380to400] EQ 7) AND (Sex_Gro[Size380to400] EQ 1), Age7Size380to400countF)
        age8Size380to400F = WHERE((Age_Gro[Size380to400] EQ 8) AND (Sex_Gro[Size380to400] EQ 1), Age8Size380to400countF)
        age9Size380to400F = WHERE((Age_Gro[Size380to400] EQ 9) AND (Sex_Gro[Size380to400] EQ 1), Age9Size380to400countF)
        age10Size380to400F = WHERE((Age_Gro[Size380to400] EQ 10) AND (Sex_Gro[Size380to400] EQ 1), Age10Size380to400countF)
        age11Size380to400F = WHERE((Age_Gro[Size380to400] EQ 11) AND (Sex_Gro[Size380to400] EQ 1), Age11Size380to400countF)
        AGE12Size380to400F = WHERE((Age_Gro[Size380to400] EQ 12) AND (Sex_Gro[Size380to400] EQ 1), Age12Size380to400countF)
        AGE13Size380to400F = WHERE((Age_Gro[Size380to400] EQ 13) AND (Sex_Gro[Size380to400] EQ 1), Age13Size380to400countF)
        AGE14Size380to400F = WHERE((Age_Gro[Size380to400] EQ 14) AND (Sex_Gro[Size380to400] EQ 1), Age14Size380to400countF)
        AGE15Size380to400F = WHERE((Age_Gro[Size380to400] EQ 15) AND (Sex_Gro[Size380to400] EQ 1), Age15Size380to400countF)
        age16Size380to400F = WHERE((Age_Gro[Size380to400] EQ 16) AND (Sex_Gro[Size380to400] EQ 1), Age16Size380to400countF)
        age17Size380to400F = WHERE((Age_Gro[Size380to400] EQ 17) AND (Sex_Gro[Size380to400] EQ 1), Age17Size380to400countF)
        age18Size380to400F = WHERE((Age_Gro[Size380to400] EQ 18) AND (Sex_Gro[Size380to400] EQ 1), Age18Size380to400countF)
        age19Size380to400F = WHERE((Age_Gro[Size380to400] EQ 19) AND (Sex_Gro[Size380to400] EQ 1), Age19Size380to400countF)
        age20Size380to400F = WHERE((Age_Gro[Size380to400] EQ 20) AND (Sex_Gro[Size380to400] EQ 1), Age20Size380to400countF)
        age21Size380to400F = WHERE((Age_Gro[Size380to400] EQ 21) AND (Sex_Gro[Size380to400] EQ 1), Age21Size380to400countF)
        age22Size380to400F = WHERE((Age_Gro[Size380to400] EQ 22) AND (Sex_Gro[Size380to400] EQ 1), Age22Size380to400countF)
        age23Size380to400F = WHERE((Age_Gro[Size380to400] EQ 23) AND (Sex_Gro[Size380to400] EQ 1), Age23Size380to400countF)
        age24Size380to400F = WHERE((Age_Gro[Size380to400] EQ 24) AND (Sex_Gro[Size380to400] EQ 1), Age24Size380to400countF)
        age25Size380to400F = WHERE((Age_Gro[Size380to400] EQ 25) AND (Sex_Gro[Size380to400] EQ 1), Age25Size380to400countF)
        age26Size380to400F = WHERE((Age_Gro[Size380to400] EQ 26) AND (Sex_Gro[Size380to400] EQ 1), Age26Size380to400countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+15L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+15L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+15L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+15L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+15L] = 380
        WAE_length_bin[75, i*NumLengthBin+adj+15L] = Size380to400countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+15L] = Age0Size380to400countF
        WAE_length_bin[77, i*NumLengthBin+adj+15L] = Age1Size380to400countF
        WAE_length_bin[78, i*NumLengthBin+adj+15L] = Age2Size380to400countF
        WAE_length_bin[79, i*NumLengthBin+adj+15L] = Age3Size380to400countF
        WAE_length_bin[80, i*NumLengthBin+adj+15L] = Age4Size380to400countF
        WAE_length_bin[81, i*NumLengthBin+adj+15L] = Age5Size380to400countF
        WAE_length_bin[82, i*NumLengthBin+adj+15L] = Age6Size380to400countF
        WAE_length_bin[83, i*NumLengthBin+adj+15L] = Age7Size380to400countF
        WAE_length_bin[84, i*NumLengthBin+adj+15L] = Age8Size380to400countF
        WAE_length_bin[85, i*NumLengthBin+adj+15L] = Age9Size380to400countF
        WAE_length_bin[86, i*NumLengthBin+adj+15L] = Age10Size380to400countF
        WAE_length_bin[87, i*NumLengthBin+adj+15L] = Age11Size380to400countF
        WAE_length_bin[88, i*NumLengthBin+adj+15L] = Age12Size380to400countF
        WAE_length_bin[89, i*NumLengthBin+adj+15L] = Age13Size380to400countF
        WAE_length_bin[90, i*NumLengthBin+adj+15L] = Age14Size380to400countF
        WAE_length_bin[91, i*NumLengthBin+adj+15L] = Age15Size380to400countF
        WAE_length_bin[92, i*NumLengthBin+adj+15L] = Age16Size380to400countF
        WAE_length_bin[93, i*NumLengthBin+adj+15L] = Age17Size380to400countF
        WAE_length_bin[94, i*NumLengthBin+adj+15L] = Age18Size380to400countF
        WAE_length_bin[95, i*NumLengthBin+adj+15L] = Age19Size380to400countF
        WAE_length_bin[96, i*NumLengthBin+adj+15L] = Age20Size380to400countF
        WAE_length_bin[97, i*NumLengthBin+adj+15L] = Age21Size380to400countF
        WAE_length_bin[98, i*NumLengthBin+adj+15L] = Age22Size380to400countF
        WAE_length_bin[99, i*NumLengthBin+adj+15L] = Age23Size380to400countF
        WAE_length_bin[100, i*NumLengthBin+adj+15L] = Age24Size380to400countF
        WAE_length_bin[101, i*NumLengthBin+adj+15L] = Age25Size380to400countF
        WAE_length_bin[102, i*NumLengthBin+adj+15L] = Age26Size380to400countF
      ENDIF
      PRINT, 'Size380to400F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+15L])
      
      ; length bin 17
      IF Size400to420count GT 0 THEN BEGIN
        age0Size400to420F = WHERE((Age_Gro[Size400to420] EQ 0) AND (Sex_Gro[Size400to420] EQ 1), Age0Size400to420countF)
        age1Size400to420F = WHERE((Age_Gro[Size400to420] EQ 1) AND (Sex_Gro[Size400to420] EQ 1), Age1Size400to420countF)
        age2Size400to420F = WHERE((Age_Gro[Size400to420] EQ 2) AND (Sex_Gro[Size400to420] EQ 1), Age2Size400to420countF)
        age3Size400to420F = WHERE((Age_Gro[Size400to420] EQ 3) AND (Sex_Gro[Size400to420] EQ 1), Age3Size400to420countF)
        age4Size400to420F = WHERE((Age_Gro[Size400to420] EQ 4) AND (Sex_Gro[Size400to420] EQ 1), Age4Size400to420countF)
        age5Size400to420F = WHERE((Age_Gro[Size400to420] EQ 5) AND (Sex_Gro[Size400to420] EQ 1), Age5Size400to420countF)
        age6Size400to420F = WHERE((Age_Gro[Size400to420] EQ 6) AND (Sex_Gro[Size400to420] EQ 1), Age6Size400to420countF)
        age7Size400to420F = WHERE((Age_Gro[Size400to420] EQ 7) AND (Sex_Gro[Size400to420] EQ 1), Age7Size400to420countF)
        age8Size400to420F = WHERE((Age_Gro[Size400to420] EQ 8) AND (Sex_Gro[Size400to420] EQ 1), Age8Size400to420countF)
        age9Size400to420F = WHERE((Age_Gro[Size400to420] EQ 9) AND (Sex_Gro[Size400to420] EQ 1), Age9Size400to420countF)
        age10Size400to420F = WHERE((Age_Gro[Size400to420] EQ 10) AND (Sex_Gro[Size400to420] EQ 1), Age10Size400to420countF)
        age11Size400to420F = WHERE((Age_Gro[Size400to420] EQ 11) AND (Sex_Gro[Size400to420] EQ 1), Age11Size400to420countF)
        AGE12Size400to420F = WHERE((Age_Gro[Size400to420] EQ 12) AND (Sex_Gro[Size400to420] EQ 1), Age12Size400to420countF)
        AGE13Size400to420F = WHERE((Age_Gro[Size400to420] EQ 13) AND (Sex_Gro[Size400to420] EQ 1), Age13Size400to420countF)
        AGE14Size400to420F = WHERE((Age_Gro[Size400to420] EQ 14) AND (Sex_Gro[Size400to420] EQ 1), Age14Size400to420countF)
        AGE15Size400to420F = WHERE((Age_Gro[Size400to420] EQ 15) AND (Sex_Gro[Size400to420] EQ 1), Age15Size400to420countF)
        age16Size400to420F = WHERE((Age_Gro[Size400to420] EQ 16) AND (Sex_Gro[Size400to420] EQ 1), Age16Size400to420countF)
        age17Size400to420F = WHERE((Age_Gro[Size400to420] EQ 17) AND (Sex_Gro[Size400to420] EQ 1), Age17Size400to420countF)
        age18Size400to420F = WHERE((Age_Gro[Size400to420] EQ 18) AND (Sex_Gro[Size400to420] EQ 1), Age18Size400to420countF)
        age19Size400to420F = WHERE((Age_Gro[Size400to420] EQ 19) AND (Sex_Gro[Size400to420] EQ 1), Age19Size400to420countF)
        age20Size400to420F = WHERE((Age_Gro[Size400to420] EQ 20) AND (Sex_Gro[Size400to420] EQ 1), Age20Size400to420countF)
        age21Size400to420F = WHERE((Age_Gro[Size400to420] EQ 21) AND (Sex_Gro[Size400to420] EQ 1), Age21Size400to420countF)
        age22Size400to420F = WHERE((Age_Gro[Size400to420] EQ 22) AND (Sex_Gro[Size400to420] EQ 1), Age22Size400to420countF)
        age23Size400to420F = WHERE((Age_Gro[Size400to420] EQ 23) AND (Sex_Gro[Size400to420] EQ 1), Age23Size400to420countF)
        age24Size400to420F = WHERE((Age_Gro[Size400to420] EQ 24) AND (Sex_Gro[Size400to420] EQ 1), Age24Size400to420countF)
        age25Size400to420F = WHERE((Age_Gro[Size400to420] EQ 25) AND (Sex_Gro[Size400to420] EQ 1), Age25Size400to420countF)
        age26Size400to420F = WHERE((Age_Gro[Size400to420] EQ 26) AND (Sex_Gro[Size400to420] EQ 1), Age26Size400to420countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+16L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+16L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+16L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+16L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+16L] = 400
        WAE_length_bin[75, i*NumLengthBin+adj+16L] = Size400to420countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+16L] = Age0Size400to420countF
        WAE_length_bin[77, i*NumLengthBin+adj+16L] = Age1Size400to420countF
        WAE_length_bin[78, i*NumLengthBin+adj+16L] = Age2Size400to420countF
        WAE_length_bin[79, i*NumLengthBin+adj+16L] = Age3Size400to420countF
        WAE_length_bin[80, i*NumLengthBin+adj+16L] = Age4Size400to420countF
        WAE_length_bin[81, i*NumLengthBin+adj+16L] = Age5Size400to420countF
        WAE_length_bin[82, i*NumLengthBin+adj+16L] = Age6Size400to420countF
        WAE_length_bin[83, i*NumLengthBin+adj+16L] = Age7Size400to420countF
        WAE_length_bin[84, i*NumLengthBin+adj+16L] = Age8Size400to420countF
        WAE_length_bin[85, i*NumLengthBin+adj+16L] = Age9Size400to420countF
        WAE_length_bin[86, i*NumLengthBin+adj+16L] = Age10Size400to420countF
        WAE_length_bin[87, i*NumLengthBin+adj+16L] = Age11Size400to420countF
        WAE_length_bin[88, i*NumLengthBin+adj+16L] = Age12Size400to420countF
        WAE_length_bin[89, i*NumLengthBin+adj+16L] = Age13Size400to420countF
        WAE_length_bin[90, i*NumLengthBin+adj+16L] = Age14Size400to420countF
        WAE_length_bin[91, i*NumLengthBin+adj+16L] = Age15Size400to420countF
        WAE_length_bin[92, i*NumLengthBin+adj+16L] = Age16Size400to420countF
        WAE_length_bin[93, i*NumLengthBin+adj+16L] = Age17Size400to420countF
        WAE_length_bin[94, i*NumLengthBin+adj+16L] = Age18Size400to420countF
        WAE_length_bin[95, i*NumLengthBin+adj+16L] = Age19Size400to420countF
        WAE_length_bin[96, i*NumLengthBin+adj+16L] = Age20Size400to420countF
        WAE_length_bin[97, i*NumLengthBin+adj+16L] = Age21Size400to420countF
        WAE_length_bin[98, i*NumLengthBin+adj+16L] = Age22Size400to420countF
        WAE_length_bin[99, i*NumLengthBin+adj+16L] = Age23Size400to420countF
        WAE_length_bin[100, i*NumLengthBin+adj+16L] = Age24Size400to420countF
        WAE_length_bin[101, i*NumLengthBin+adj+16L] = Age25Size400to420countF
        WAE_length_bin[102, i*NumLengthBin+adj+16L] = Age26Size400to420countF
      ENDIF
      PRINT, 'Size400to420F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+16L])
      
      ; length bin 18
      IF Size420to440count GT 0 THEN BEGIN
        age0Size420to440F = WHERE((Age_Gro[Size420to440] EQ 0) AND (Sex_Gro[Size420to440] EQ 1), Age0Size420to440countF)
        age1Size420to440F = WHERE((Age_Gro[Size420to440] EQ 1) AND (Sex_Gro[Size420to440] EQ 1), Age1Size420to440countF)
        age2Size420to440F = WHERE((Age_Gro[Size420to440] EQ 2) AND (Sex_Gro[Size420to440] EQ 1), Age2Size420to440countF)
        age3Size420to440F = WHERE((Age_Gro[Size420to440] EQ 3) AND (Sex_Gro[Size420to440] EQ 1), Age3Size420to440countF)
        age4Size420to440F = WHERE((Age_Gro[Size420to440] EQ 4) AND (Sex_Gro[Size420to440] EQ 1), Age4Size420to440countF)
        age5Size420to440F = WHERE((Age_Gro[Size420to440] EQ 5) AND (Sex_Gro[Size420to440] EQ 1), Age5Size420to440countF)
        age6Size420to440F = WHERE((Age_Gro[Size420to440] EQ 6) AND (Sex_Gro[Size420to440] EQ 1), Age6Size420to440countF)
        age7Size420to440F = WHERE((Age_Gro[Size420to440] EQ 7) AND (Sex_Gro[Size420to440] EQ 1), Age7Size420to440countF)
        age8Size420to440F = WHERE((Age_Gro[Size420to440] EQ 8) AND (Sex_Gro[Size420to440] EQ 1), Age8Size420to440countF)
        age9Size420to440F = WHERE((Age_Gro[Size420to440] EQ 9) AND (Sex_Gro[Size420to440] EQ 1), Age9Size420to440countF)
        age10Size420to440F = WHERE((Age_Gro[Size420to440] EQ 10) AND (Sex_Gro[Size420to440] EQ 1), Age10Size420to440countF)
        age11Size420to440F = WHERE((Age_Gro[Size420to440] EQ 11) AND (Sex_Gro[Size420to440] EQ 1), Age11Size420to440countF)
        AGE12Size420to440F = WHERE((Age_Gro[Size420to440] EQ 12) AND (Sex_Gro[Size420to440] EQ 1), Age12Size420to440countF)
        AGE13Size420to440F = WHERE((Age_Gro[Size420to440] EQ 13) AND (Sex_Gro[Size420to440] EQ 1), Age13Size420to440countF)
        AGE14Size420to440F = WHERE((Age_Gro[Size420to440] EQ 14) AND (Sex_Gro[Size420to440] EQ 1), Age14Size420to440countF)
        AGE15Size420to440F = WHERE((Age_Gro[Size420to440] EQ 15) AND (Sex_Gro[Size420to440] EQ 1), Age15Size420to440countF)
        age16Size420to440F = WHERE((Age_Gro[Size420to440] EQ 16) AND (Sex_Gro[Size420to440] EQ 1), Age16Size420to440countF)
        age17Size420to440F = WHERE((Age_Gro[Size420to440] EQ 17) AND (Sex_Gro[Size420to440] EQ 1), Age17Size420to440countF)
        age18Size420to440F = WHERE((Age_Gro[Size420to440] EQ 18) AND (Sex_Gro[Size420to440] EQ 1), Age18Size420to440countF)
        age19Size420to440F = WHERE((Age_Gro[Size420to440] EQ 19) AND (Sex_Gro[Size420to440] EQ 1), Age19Size420to440countF)
        age20Size420to440F = WHERE((Age_Gro[Size420to440] EQ 20) AND (Sex_Gro[Size420to440] EQ 1), Age20Size420to440countF)
        age21Size420to440F = WHERE((Age_Gro[Size420to440] EQ 21) AND (Sex_Gro[Size420to440] EQ 1), Age21Size420to440countF)
        age22Size420to440F = WHERE((Age_Gro[Size420to440] EQ 22) AND (Sex_Gro[Size420to440] EQ 1), Age22Size420to440countF)
        age23Size420to440F = WHERE((Age_Gro[Size420to440] EQ 23) AND (Sex_Gro[Size420to440] EQ 1), Age23Size420to440countF)
        age24Size420to440F = WHERE((Age_Gro[Size420to440] EQ 24) AND (Sex_Gro[Size420to440] EQ 1), Age24Size420to440countF)
        age25Size420to440F = WHERE((Age_Gro[Size420to440] EQ 25) AND (Sex_Gro[Size420to440] EQ 1), Age25Size420to440countF)
        age26Size420to440F = WHERE((Age_Gro[Size420to440] EQ 26) AND (Sex_Gro[Size420to440] EQ 1), Age26Size420to440countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+17L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+17L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+17L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+17L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+17L] = 420
        WAE_length_bin[75, i*NumLengthBin+adj+17L] = Size420to440countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+17L] = Age0Size420to440countF
        WAE_length_bin[77, i*NumLengthBin+adj+17L] = Age1Size420to440countF
        WAE_length_bin[78, i*NumLengthBin+adj+17L] = Age2Size420to440countF
        WAE_length_bin[79, i*NumLengthBin+adj+17L] = Age3Size420to440countF
        WAE_length_bin[80, i*NumLengthBin+adj+17L] = Age4Size420to440countF
        WAE_length_bin[81, i*NumLengthBin+adj+17L] = Age5Size420to440countF
        WAE_length_bin[82, i*NumLengthBin+adj+17L] = Age6Size420to440countF
        WAE_length_bin[83, i*NumLengthBin+adj+17L] = Age7Size420to440countF
        WAE_length_bin[84, i*NumLengthBin+adj+17L] = Age8Size420to440countF
        WAE_length_bin[85, i*NumLengthBin+adj+17L] = Age9Size420to440countF
        WAE_length_bin[86, i*NumLengthBin+adj+17L] = Age10Size420to440countF
        WAE_length_bin[87, i*NumLengthBin+adj+17L] = Age11Size420to440countF
        WAE_length_bin[88, i*NumLengthBin+adj+17L] = Age12Size420to440countF
        WAE_length_bin[89, i*NumLengthBin+adj+17L] = Age13Size420to440countF
        WAE_length_bin[90, i*NumLengthBin+adj+17L] = Age14Size420to440countF
        WAE_length_bin[91, i*NumLengthBin+adj+17L] = Age15Size420to440countF
        WAE_length_bin[92, i*NumLengthBin+adj+17L] = Age16Size420to440countF
        WAE_length_bin[93, i*NumLengthBin+adj+17L] = Age17Size420to440countF
        WAE_length_bin[94, i*NumLengthBin+adj+17L] = Age18Size420to440countF
        WAE_length_bin[95, i*NumLengthBin+adj+17L] = Age19Size420to440countF
        WAE_length_bin[96, i*NumLengthBin+adj+17L] = Age20Size420to440countF
        WAE_length_bin[97, i*NumLengthBin+adj+17L] = Age21Size420to440countF
        WAE_length_bin[98, i*NumLengthBin+adj+17L] = Age22Size420to440countF
        WAE_length_bin[99, i*NumLengthBin+adj+17L] = Age23Size420to440countF
        WAE_length_bin[100, i*NumLengthBin+adj+17L] = Age24Size420to440countF
        WAE_length_bin[101, i*NumLengthBin+adj+17L] = Age25Size420to440countF
        WAE_length_bin[102, i*NumLengthBin+adj+17L] = Age26Size420to440countF
      ENDIF
      PRINT, 'Size420to440F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+17L])
      
      ; length bin 19
      IF Size440to460count GT 0 THEN BEGIN
        age0Size440to460F = WHERE((Age_Gro[Size440to460] EQ 0) AND (Sex_Gro[Size440to460] EQ 1), Age0Size440to460countF)
        age1Size440to460F = WHERE((Age_Gro[Size440to460] EQ 1) AND (Sex_Gro[Size440to460] EQ 1), Age1Size440to460countF)
        age2Size440to460F = WHERE((Age_Gro[Size440to460] EQ 2) AND (Sex_Gro[Size440to460] EQ 1), Age2Size440to460countF)
        age3Size440to460F = WHERE((Age_Gro[Size440to460] EQ 3) AND (Sex_Gro[Size440to460] EQ 1), Age3Size440to460countF)
        age4Size440to460F = WHERE((Age_Gro[Size440to460] EQ 4) AND (Sex_Gro[Size440to460] EQ 1), Age4Size440to460countF)
        age5Size440to460F = WHERE((Age_Gro[Size440to460] EQ 5) AND (Sex_Gro[Size440to460] EQ 1), Age5Size440to460countF)
        age6Size440to460F = WHERE((Age_Gro[Size440to460] EQ 6) AND (Sex_Gro[Size440to460] EQ 1), Age6Size440to460countF)
        age7Size440to460F = WHERE((Age_Gro[Size440to460] EQ 7) AND (Sex_Gro[Size440to460] EQ 1), Age7Size440to460countF)
        age8Size440to460F = WHERE((Age_Gro[Size440to460] EQ 8) AND (Sex_Gro[Size440to460] EQ 1), Age8Size440to460countF)
        age9Size440to460F = WHERE((Age_Gro[Size440to460] EQ 9) AND (Sex_Gro[Size440to460] EQ 1), Age9Size440to460countF)
        age10Size440to460F = WHERE((Age_Gro[Size440to460] EQ 10) AND (Sex_Gro[Size440to460] EQ 1), Age10Size440to460countF)
        age11Size440to460F = WHERE((Age_Gro[Size440to460] EQ 11) AND (Sex_Gro[Size440to460] EQ 1), Age11Size440to460countF)
        AGE12Size440to460F = WHERE((Age_Gro[Size440to460] EQ 12) AND (Sex_Gro[Size440to460] EQ 1), Age12Size440to460countF)
        AGE13Size440to460F = WHERE((Age_Gro[Size440to460] EQ 13) AND (Sex_Gro[Size440to460] EQ 1), Age13Size440to460countF)
        AGE14Size440to460F = WHERE((Age_Gro[Size440to460] EQ 14) AND (Sex_Gro[Size440to460] EQ 1), Age14Size440to460countF)
        AGE15Size440to460F = WHERE((Age_Gro[Size440to460] EQ 15) AND (Sex_Gro[Size440to460] EQ 1), Age15Size440to460countF)
        age16Size440to460F = WHERE((Age_Gro[Size440to460] EQ 16) AND (Sex_Gro[Size440to460] EQ 1), Age16Size440to460countF)
        age17Size440to460F = WHERE((Age_Gro[Size440to460] EQ 17) AND (Sex_Gro[Size440to460] EQ 1), Age17Size440to460countF)
        age18Size440to460F = WHERE((Age_Gro[Size440to460] EQ 18) AND (Sex_Gro[Size440to460] EQ 1), Age18Size440to460countF)
        age19Size440to460F = WHERE((Age_Gro[Size440to460] EQ 19) AND (Sex_Gro[Size440to460] EQ 1), Age19Size440to460countF)
        age20Size440to460F = WHERE((Age_Gro[Size440to460] EQ 20) AND (Sex_Gro[Size440to460] EQ 1), Age20Size440to460countF)
        age21Size440to460F = WHERE((Age_Gro[Size440to460] EQ 21) AND (Sex_Gro[Size440to460] EQ 1), Age21Size440to460countF)
        age22Size440to460F = WHERE((Age_Gro[Size440to460] EQ 22) AND (Sex_Gro[Size440to460] EQ 1), Age22Size440to460countF)
        age23Size440to460F = WHERE((Age_Gro[Size440to460] EQ 23) AND (Sex_Gro[Size440to460] EQ 1), Age23Size440to460countF)
        age24Size440to460F = WHERE((Age_Gro[Size440to460] EQ 24) AND (Sex_Gro[Size440to460] EQ 1), Age24Size440to460countF)
        age25Size440to460F = WHERE((Age_Gro[Size440to460] EQ 25) AND (Sex_Gro[Size440to460] EQ 1), Age25Size440to460countF)
        age26Size440to460F = WHERE((Age_Gro[Size440to460] EQ 26) AND (Sex_Gro[Size440to460] EQ 1), Age26Size440to460countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+18L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+18L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+18L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+18L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+18L] = 440
        WAE_length_bin[75, i*NumLengthBin+adj+18L] = Size440to460countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+18L] = Age0Size440to460countF
        WAE_length_bin[77, i*NumLengthBin+adj+18L] = Age1Size440to460countF
        WAE_length_bin[78, i*NumLengthBin+adj+18L] = Age2Size440to460countF
        WAE_length_bin[79, i*NumLengthBin+adj+18L] = Age3Size440to460countF
        WAE_length_bin[80, i*NumLengthBin+adj+18L] = Age4Size440to460countF
        WAE_length_bin[81, i*NumLengthBin+adj+18L] = Age5Size440to460countF
        WAE_length_bin[82, i*NumLengthBin+adj+18L] = Age6Size440to460countF
        WAE_length_bin[83, i*NumLengthBin+adj+18L] = Age7Size440to460countF
        WAE_length_bin[84, i*NumLengthBin+adj+18L] = Age8Size440to460countF
        WAE_length_bin[85, i*NumLengthBin+adj+18L] = Age9Size440to460countF
        WAE_length_bin[86, i*NumLengthBin+adj+18L] = Age10Size440to460countF
        WAE_length_bin[87, i*NumLengthBin+adj+18L] = Age11Size440to460countF
        WAE_length_bin[88, i*NumLengthBin+adj+18L] = Age12Size440to460countF
        WAE_length_bin[89, i*NumLengthBin+adj+18L] = Age13Size440to460countF
        WAE_length_bin[90, i*NumLengthBin+adj+18L] = Age14Size440to460countF
        WAE_length_bin[91, i*NumLengthBin+adj+18L] = Age15Size440to460countF
        WAE_length_bin[92, i*NumLengthBin+adj+18L] = Age16Size440to460countF
        WAE_length_bin[93, i*NumLengthBin+adj+18L] = Age17Size440to460countF
        WAE_length_bin[94, i*NumLengthBin+adj+18L] = Age18Size440to460countF
        WAE_length_bin[95, i*NumLengthBin+adj+18L] = Age19Size440to460countF
        WAE_length_bin[96, i*NumLengthBin+adj+18L] = Age20Size440to460countF
        WAE_length_bin[97, i*NumLengthBin+adj+18L] = Age21Size440to460countF
        WAE_length_bin[98, i*NumLengthBin+adj+18L] = Age22Size440to460countF
        WAE_length_bin[99, i*NumLengthBin+adj+18L] = Age23Size440to460countF
        WAE_length_bin[100, i*NumLengthBin+adj+18L] = Age24Size440to460countF
        WAE_length_bin[101, i*NumLengthBin+adj+18L] = Age25Size440to460countF
        WAE_length_bin[102, i*NumLengthBin+adj+18L] = Age26Size440to460countF
      ENDIF
      PRINT, 'Size440to460F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+18L])
      
      ; length bin 20
      IF Size460to480count GT 0 THEN BEGIN
        age0Size460to480F = WHERE((Age_Gro[Size460to480] EQ 0) AND (Sex_Gro[Size460to480] EQ 1), Age0Size460to480countF)
        age1Size460to480F = WHERE((Age_Gro[Size460to480] EQ 1) AND (Sex_Gro[Size460to480] EQ 1), Age1Size460to480countF)
        age2Size460to480F = WHERE((Age_Gro[Size460to480] EQ 2) AND (Sex_Gro[Size460to480] EQ 1), Age2Size460to480countF)
        age3Size460to480F = WHERE((Age_Gro[Size460to480] EQ 3) AND (Sex_Gro[Size460to480] EQ 1), Age3Size460to480countF)
        age4Size460to480F = WHERE((Age_Gro[Size460to480] EQ 4) AND (Sex_Gro[Size460to480] EQ 1), Age4Size460to480countF)
        age5Size460to480F = WHERE((Age_Gro[Size460to480] EQ 5) AND (Sex_Gro[Size460to480] EQ 1), Age5Size460to480countF)
        age6Size460to480F = WHERE((Age_Gro[Size460to480] EQ 6) AND (Sex_Gro[Size460to480] EQ 1), Age6Size460to480countF)
        age7Size460to480F = WHERE((Age_Gro[Size460to480] EQ 7) AND (Sex_Gro[Size460to480] EQ 1), Age7Size460to480countF)
        age8Size460to480F = WHERE((Age_Gro[Size460to480] EQ 8) AND (Sex_Gro[Size460to480] EQ 1), Age8Size460to480countF)
        age9Size460to480F = WHERE((Age_Gro[Size460to480] EQ 9) AND (Sex_Gro[Size460to480] EQ 1), Age9Size460to480countF)
        age10Size460to480F = WHERE((Age_Gro[Size460to480] EQ 10) AND (Sex_Gro[Size460to480] EQ 1), Age10Size460to480countF)
        age11Size460to480F = WHERE((Age_Gro[Size460to480] EQ 11) AND (Sex_Gro[Size460to480] EQ 1), Age11Size460to480countF)
        AGE12Size460to480F = WHERE((Age_Gro[Size460to480] EQ 12) AND (Sex_Gro[Size460to480] EQ 1), Age12Size460to480countF)
        AGE13Size460to480F = WHERE((Age_Gro[Size460to480] EQ 13) AND (Sex_Gro[Size460to480] EQ 1), Age13Size460to480countF)
        AGE14Size460to480F = WHERE((Age_Gro[Size460to480] EQ 14) AND (Sex_Gro[Size460to480] EQ 1), Age14Size460to480countF)
        AGE15Size460to480F = WHERE((Age_Gro[Size460to480] EQ 15) AND (Sex_Gro[Size460to480] EQ 1), Age15Size460to480countF)
        age16Size460to480F = WHERE((Age_Gro[Size460to480] EQ 16) AND (Sex_Gro[Size460to480] EQ 1), Age16Size460to480countF)
        age17Size460to480F = WHERE((Age_Gro[Size460to480] EQ 17) AND (Sex_Gro[Size460to480] EQ 1), Age17Size460to480countF)
        age18Size460to480F = WHERE((Age_Gro[Size460to480] EQ 18) AND (Sex_Gro[Size460to480] EQ 1), Age18Size460to480countF)
        age19Size460to480F = WHERE((Age_Gro[Size460to480] EQ 19) AND (Sex_Gro[Size460to480] EQ 1), Age19Size460to480countF)
        age20Size460to480F = WHERE((Age_Gro[Size460to480] EQ 20) AND (Sex_Gro[Size460to480] EQ 1), Age20Size460to480countF)
        age21Size460to480F = WHERE((Age_Gro[Size460to480] EQ 21) AND (Sex_Gro[Size460to480] EQ 1), Age21Size460to480countF)
        age22Size460to480F = WHERE((Age_Gro[Size460to480] EQ 22) AND (Sex_Gro[Size460to480] EQ 1), Age22Size460to480countF)
        age23Size460to480F = WHERE((Age_Gro[Size460to480] EQ 23) AND (Sex_Gro[Size460to480] EQ 1), Age23Size460to480countF)
        age24Size460to480F = WHERE((Age_Gro[Size460to480] EQ 24) AND (Sex_Gro[Size460to480] EQ 1), Age24Size460to480countF)
        age25Size460to480F = WHERE((Age_Gro[Size460to480] EQ 25) AND (Sex_Gro[Size460to480] EQ 1), Age25Size460to480countF)
        age26Size460to480F = WHERE((Age_Gro[Size460to480] EQ 26) AND (Sex_Gro[Size460to480] EQ 1), Age26Size460to480countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+19L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+19L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+19L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+19L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+19L] = 460
        WAE_length_bin[75, i*NumLengthBin+adj+19L] = Size460to480countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+19L] = Age0Size460to480countF
        WAE_length_bin[77, i*NumLengthBin+adj+19L] = Age1Size460to480countF
        WAE_length_bin[78, i*NumLengthBin+adj+19L] = Age2Size460to480countF
        WAE_length_bin[79, i*NumLengthBin+adj+19L] = Age3Size460to480countF
        WAE_length_bin[80, i*NumLengthBin+adj+19L] = Age4Size460to480countF
        WAE_length_bin[81, i*NumLengthBin+adj+19L] = Age5Size460to480countF
        WAE_length_bin[82, i*NumLengthBin+adj+19L] = Age6Size460to480countF
        WAE_length_bin[83, i*NumLengthBin+adj+19L] = Age7Size460to480countF
        WAE_length_bin[84, i*NumLengthBin+adj+19L] = Age8Size460to480countF
        WAE_length_bin[85, i*NumLengthBin+adj+19L] = Age9Size460to480countF
        WAE_length_bin[86, i*NumLengthBin+adj+19L] = Age10Size460to480countF
        WAE_length_bin[87, i*NumLengthBin+adj+19L] = Age11Size460to480countF
        WAE_length_bin[88, i*NumLengthBin+adj+19L] = Age12Size460to480countF
        WAE_length_bin[89, i*NumLengthBin+adj+19L] = Age13Size460to480countF
        WAE_length_bin[90, i*NumLengthBin+adj+19L] = Age14Size460to480countF
        WAE_length_bin[91, i*NumLengthBin+adj+19L] = Age15Size460to480countF
        WAE_length_bin[92, i*NumLengthBin+adj+19L] = Age16Size460to480countF
        WAE_length_bin[93, i*NumLengthBin+adj+19L] = Age17Size460to480countF
        WAE_length_bin[94, i*NumLengthBin+adj+19L] = Age18Size460to480countF
        WAE_length_bin[95, i*NumLengthBin+adj+19L] = Age19Size460to480countF
        WAE_length_bin[96, i*NumLengthBin+adj+19L] = Age20Size460to480countF
        WAE_length_bin[97, i*NumLengthBin+adj+19L] = Age21Size460to480countF
        WAE_length_bin[98, i*NumLengthBin+adj+19L] = Age22Size460to480countF
        WAE_length_bin[99, i*NumLengthBin+adj+19L] = Age23Size460to480countF
        WAE_length_bin[100, i*NumLengthBin+adj+19L] = Age24Size460to480countF
        WAE_length_bin[101, i*NumLengthBin+adj+19L] = Age25Size460to480countF
        WAE_length_bin[102, i*NumLengthBin+adj+19L] = Age26Size460to480countF
      ENDIF
      PRINT, 'Size460to480F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+19L])
      
      ; length bin 21
      IF Size480to500count GT 0 THEN BEGIN
        age0Size480to500F = WHERE((Age_Gro[Size480to500] EQ 0) AND (Sex_Gro[Size480to500] EQ 1), Age0Size480to500countF)
        age1Size480to500F = WHERE((Age_Gro[Size480to500] EQ 1) AND (Sex_Gro[Size480to500] EQ 1), Age1Size480to500countF)
        age2Size480to500F = WHERE((Age_Gro[Size480to500] EQ 2) AND (Sex_Gro[Size480to500] EQ 1), Age2Size480to500countF)
        age3Size480to500F = WHERE((Age_Gro[Size480to500] EQ 3) AND (Sex_Gro[Size480to500] EQ 1), Age3Size480to500countF)
        age4Size480to500F = WHERE((Age_Gro[Size480to500] EQ 4) AND (Sex_Gro[Size480to500] EQ 1), Age4Size480to500countF)
        age5Size480to500F = WHERE((Age_Gro[Size480to500] EQ 5) AND (Sex_Gro[Size480to500] EQ 1), Age5Size480to500countF)
        age6Size480to500F = WHERE((Age_Gro[Size480to500] EQ 6) AND (Sex_Gro[Size480to500] EQ 1), Age6Size480to500countF)
        age7Size480to500F = WHERE((Age_Gro[Size480to500] EQ 7) AND (Sex_Gro[Size480to500] EQ 1), Age7Size480to500countF)
        age8Size480to500F = WHERE((Age_Gro[Size480to500] EQ 8) AND (Sex_Gro[Size480to500] EQ 1), Age8Size480to500countF)
        age9Size480to500F = WHERE((Age_Gro[Size480to500] EQ 9) AND (Sex_Gro[Size480to500] EQ 1), Age9Size480to500countF)
        age10Size480to500F = WHERE((Age_Gro[Size480to500] EQ 10) AND (Sex_Gro[Size480to500] EQ 1), Age10Size480to500countF)
        age11Size480to500F = WHERE((Age_Gro[Size480to500] EQ 11) AND (Sex_Gro[Size480to500] EQ 1), Age11Size480to500countF)
        AGE12Size480to500F = WHERE((Age_Gro[Size480to500] EQ 12) AND (Sex_Gro[Size480to500] EQ 1), Age12Size480to500countF)
        AGE13Size480to500F = WHERE((Age_Gro[Size480to500] EQ 13) AND (Sex_Gro[Size480to500] EQ 1), Age13Size480to500countF)
        AGE14Size480to500F = WHERE((Age_Gro[Size480to500] EQ 14) AND (Sex_Gro[Size480to500] EQ 1), Age14Size480to500countF)
        AGE15Size480to500F = WHERE((Age_Gro[Size480to500] EQ 15) AND (Sex_Gro[Size480to500] EQ 1), Age15Size480to500countF)
        age16Size480to500F = WHERE((Age_Gro[Size480to500] EQ 16) AND (Sex_Gro[Size480to500] EQ 1), Age16Size480to500countF)
        age17Size480to500F = WHERE((Age_Gro[Size480to500] EQ 17) AND (Sex_Gro[Size480to500] EQ 1), Age17Size480to500countF)
        age18Size480to500F = WHERE((Age_Gro[Size480to500] EQ 18) AND (Sex_Gro[Size480to500] EQ 1), Age18Size480to500countF)
        age19Size480to500F = WHERE((Age_Gro[Size480to500] EQ 19) AND (Sex_Gro[Size480to500] EQ 1), Age19Size480to500countF)
        age20Size480to500F = WHERE((Age_Gro[Size480to500] EQ 20) AND (Sex_Gro[Size480to500] EQ 1), Age20Size480to500countF)
        age21Size480to500F = WHERE((Age_Gro[Size480to500] EQ 21) AND (Sex_Gro[Size480to500] EQ 1), Age21Size480to500countF)
        age22Size480to500F = WHERE((Age_Gro[Size480to500] EQ 22) AND (Sex_Gro[Size480to500] EQ 1), Age22Size480to500countF)
        age23Size480to500F = WHERE((Age_Gro[Size480to500] EQ 23) AND (Sex_Gro[Size480to500] EQ 1), Age23Size480to500countF)
        age24Size480to500F = WHERE((Age_Gro[Size480to500] EQ 24) AND (Sex_Gro[Size480to500] EQ 1), Age24Size480to500countF)
        age25Size480to500F = WHERE((Age_Gro[Size480to500] EQ 25) AND (Sex_Gro[Size480to500] EQ 1), Age25Size480to500countF)
        age26Size480to500F = WHERE((Age_Gro[Size480to500] EQ 26) AND (Sex_Gro[Size480to500] EQ 1), Age26Size480to500countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+20L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+20L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+20L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+20L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+20L] = 480
        WAE_length_bin[75, i*NumLengthBin+adj+20L] = Size480to500countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+20L] = Age0Size480to500countF
        WAE_length_bin[77, i*NumLengthBin+adj+20L] = Age1Size480to500countF
        WAE_length_bin[78, i*NumLengthBin+adj+20L] = Age2Size480to500countF
        WAE_length_bin[79, i*NumLengthBin+adj+20L] = Age3Size480to500countF
        WAE_length_bin[80, i*NumLengthBin+adj+20L] = Age4Size480to500countF
        WAE_length_bin[81, i*NumLengthBin+adj+20L] = Age5Size480to500countF
        WAE_length_bin[82, i*NumLengthBin+adj+20L] = Age6Size480to500countF
        WAE_length_bin[83, i*NumLengthBin+adj+20L] = Age7Size480to500countF
        WAE_length_bin[84, i*NumLengthBin+adj+20L] = Age8Size480to500countF
        WAE_length_bin[85, i*NumLengthBin+adj+20L] = Age9Size480to500countF
        WAE_length_bin[86, i*NumLengthBin+adj+20L] = Age10Size480to500countF
        WAE_length_bin[87, i*NumLengthBin+adj+20L] = Age11Size480to500countF
        WAE_length_bin[88, i*NumLengthBin+adj+20L] = Age12Size480to500countF
        WAE_length_bin[89, i*NumLengthBin+adj+20L] = Age13Size480to500countF
        WAE_length_bin[90, i*NumLengthBin+adj+20L] = Age14Size480to500countF
        WAE_length_bin[91, i*NumLengthBin+adj+20L] = Age15Size480to500countF
        WAE_length_bin[92, i*NumLengthBin+adj+20L] = Age16Size480to500countF
        WAE_length_bin[93, i*NumLengthBin+adj+20L] = Age17Size480to500countF
        WAE_length_bin[94, i*NumLengthBin+adj+20L] = Age18Size480to500countF
        WAE_length_bin[95, i*NumLengthBin+adj+20L] = Age19Size480to500countF
        WAE_length_bin[96, i*NumLengthBin+adj+20L] = Age20Size480to500countF
        WAE_length_bin[97, i*NumLengthBin+adj+20L] = Age21Size480to500countF
        WAE_length_bin[98, i*NumLengthBin+adj+20L] = Age22Size480to500countF
        WAE_length_bin[99, i*NumLengthBin+adj+20L] = Age23Size480to500countF
        WAE_length_bin[100, i*NumLengthBin+adj+20L] = Age24Size480to500countF
        WAE_length_bin[101, i*NumLengthBin+adj+20L] = Age25Size480to500countF
        WAE_length_bin[102, i*NumLengthBin+adj+20L] = Age26Size480to500countF
      ENDIF
      PRINT, 'Size480to500F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+20L])
      
      ; length bin 22
      IF Size500to520count GT 0 THEN BEGIN
        age0Size500to520F = WHERE((Age_Gro[Size500to520] EQ 0) AND (Sex_Gro[Size500to520] EQ 1), Age0Size500to520countF)
        age1Size500to520F = WHERE((Age_Gro[Size500to520] EQ 1) AND (Sex_Gro[Size500to520] EQ 1), Age1Size500to520countF)
        age2Size500to520F = WHERE((Age_Gro[Size500to520] EQ 2) AND (Sex_Gro[Size500to520] EQ 1), Age2Size500to520countF)
        age3Size500to520F = WHERE((Age_Gro[Size500to520] EQ 3) AND (Sex_Gro[Size500to520] EQ 1), Age3Size500to520countF)
        age4Size500to520F = WHERE((Age_Gro[Size500to520] EQ 4) AND (Sex_Gro[Size500to520] EQ 1), Age4Size500to520countF)
        age5Size500to520F = WHERE((Age_Gro[Size500to520] EQ 5) AND (Sex_Gro[Size500to520] EQ 1), Age5Size500to520countF)
        age6Size500to520F = WHERE((Age_Gro[Size500to520] EQ 6) AND (Sex_Gro[Size500to520] EQ 1), Age6Size500to520countF)
        age7Size500to520F = WHERE((Age_Gro[Size500to520] EQ 7) AND (Sex_Gro[Size500to520] EQ 1), Age7Size500to520countF)
        age8Size500to520F = WHERE((Age_Gro[Size500to520] EQ 8) AND (Sex_Gro[Size500to520] EQ 1), Age8Size500to520countF)
        age9Size500to520F = WHERE((Age_Gro[Size500to520] EQ 9) AND (Sex_Gro[Size500to520] EQ 1), Age9Size500to520countF)
        age10Size500to520F = WHERE((Age_Gro[Size500to520] EQ 10) AND (Sex_Gro[Size500to520] EQ 1), Age10Size500to520countF)
        age11Size500to520F = WHERE((Age_Gro[Size500to520] EQ 11) AND (Sex_Gro[Size500to520] EQ 1), Age11Size500to520countF)
        AGE12Size500to520F = WHERE((Age_Gro[Size500to520] EQ 12) AND (Sex_Gro[Size500to520] EQ 1), Age12Size500to520countF)
        AGE13Size500to520F = WHERE((Age_Gro[Size500to520] EQ 13) AND (Sex_Gro[Size500to520] EQ 1), Age13Size500to520countF)
        AGE14Size500to520F = WHERE((Age_Gro[Size500to520] EQ 14) AND (Sex_Gro[Size500to520] EQ 1), Age14Size500to520countF)
        AGE15Size500to520F = WHERE((Age_Gro[Size500to520] EQ 15) AND (Sex_Gro[Size500to520] EQ 1), Age15Size500to520countF)
        age16Size500to520F = WHERE((Age_Gro[Size500to520] EQ 16) AND (Sex_Gro[Size500to520] EQ 1), Age16Size500to520countF)
        age17Size500to520F = WHERE((Age_Gro[Size500to520] EQ 17) AND (Sex_Gro[Size500to520] EQ 1), Age17Size500to520countF)
        age18Size500to520F = WHERE((Age_Gro[Size500to520] EQ 18) AND (Sex_Gro[Size500to520] EQ 1), Age18Size500to520countF)
        age19Size500to520F = WHERE((Age_Gro[Size500to520] EQ 19) AND (Sex_Gro[Size500to520] EQ 1), Age19Size500to520countF)
        age20Size500to520F = WHERE((Age_Gro[Size500to520] EQ 20) AND (Sex_Gro[Size500to520] EQ 1), Age20Size500to520countF)
        age21Size500to520F = WHERE((Age_Gro[Size500to520] EQ 21) AND (Sex_Gro[Size500to520] EQ 1), Age21Size500to520countF)
        age22Size500to520F = WHERE((Age_Gro[Size500to520] EQ 22) AND (Sex_Gro[Size500to520] EQ 1), Age22Size500to520countF)
        age23Size500to520F = WHERE((Age_Gro[Size500to520] EQ 23) AND (Sex_Gro[Size500to520] EQ 1), Age23Size500to520countF)
        age24Size500to520F = WHERE((Age_Gro[Size500to520] EQ 24) AND (Sex_Gro[Size500to520] EQ 1), Age24Size500to520countF)
        age25Size500to520F = WHERE((Age_Gro[Size500to520] EQ 25) AND (Sex_Gro[Size500to520] EQ 1), Age25Size500to520countF)
        age26Size500to520F = WHERE((Age_Gro[Size500to520] EQ 26) AND (Sex_Gro[Size500to520] EQ 1), Age26Size500to520countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+21L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+21L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+21L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+21L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+21L] = 500
        WAE_length_bin[75, i*NumLengthBin+adj+21L] = Size500to520countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+21L] = Age0Size500to520countF
        WAE_length_bin[77, i*NumLengthBin+adj+21L] = Age1Size500to520countF
        WAE_length_bin[78, i*NumLengthBin+adj+21L] = Age2Size500to520countF
        WAE_length_bin[79, i*NumLengthBin+adj+21L] = Age3Size500to520countF
        WAE_length_bin[80, i*NumLengthBin+adj+21L] = Age4Size500to520countF
        WAE_length_bin[81, i*NumLengthBin+adj+21L] = Age5Size500to520countF
        WAE_length_bin[82, i*NumLengthBin+adj+21L] = Age6Size500to520countF
        WAE_length_bin[83, i*NumLengthBin+adj+21L] = Age7Size500to520countF
        WAE_length_bin[84, i*NumLengthBin+adj+21L] = Age8Size500to520countF
        WAE_length_bin[85, i*NumLengthBin+adj+21L] = Age9Size500to520countF
        WAE_length_bin[86, i*NumLengthBin+adj+21L] = Age10Size500to520countF
        WAE_length_bin[87, i*NumLengthBin+adj+21L] = Age11Size500to520countF
        WAE_length_bin[88, i*NumLengthBin+adj+21L] = Age12Size500to520countF
        WAE_length_bin[89, i*NumLengthBin+adj+21L] = Age13Size500to520countF
        WAE_length_bin[90, i*NumLengthBin+adj+21L] = Age14Size500to520countF
        WAE_length_bin[91, i*NumLengthBin+adj+21L] = Age15Size500to520countF
        WAE_length_bin[92, i*NumLengthBin+adj+21L] = Age16Size500to520countF
        WAE_length_bin[93, i*NumLengthBin+adj+21L] = Age17Size500to520countF
        WAE_length_bin[94, i*NumLengthBin+adj+21L] = Age18Size500to520countF
        WAE_length_bin[95, i*NumLengthBin+adj+21L] = Age19Size500to520countF
        WAE_length_bin[96, i*NumLengthBin+adj+21L] = Age20Size500to520countF
        WAE_length_bin[97, i*NumLengthBin+adj+21L] = Age21Size500to520countF
        WAE_length_bin[98, i*NumLengthBin+adj+21L] = Age22Size500to520countF
        WAE_length_bin[99, i*NumLengthBin+adj+21L] = Age23Size500to520countF
        WAE_length_bin[100, i*NumLengthBin+adj+21L] = Age24Size500to520countF
        WAE_length_bin[101, i*NumLengthBin+adj+21L] = Age25Size500to520countF
        WAE_length_bin[102, i*NumLengthBin+adj+21L] = Age26Size500to520countF
      ENDIF
      PRINT, 'Size500to520F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+21L])
      
      ; length bin 23
      IF Size520to540count GT 0 THEN BEGIN
        age0Size520to540F = WHERE((Age_Gro[Size520to540] EQ 0) AND (Sex_Gro[Size520to540] EQ 1), Age0Size520to540countF)
        age1Size520to540F = WHERE((Age_Gro[Size520to540] EQ 1) AND (Sex_Gro[Size520to540] EQ 1), Age1Size520to540countF)
        age2Size520to540F = WHERE((Age_Gro[Size520to540] EQ 2) AND (Sex_Gro[Size520to540] EQ 1), Age2Size520to540countF)
        age3Size520to540F = WHERE((Age_Gro[Size520to540] EQ 3) AND (Sex_Gro[Size520to540] EQ 1), Age3Size520to540countF)
        age4Size520to540F = WHERE((Age_Gro[Size520to540] EQ 4) AND (Sex_Gro[Size520to540] EQ 1), Age4Size520to540countF)
        age5Size520to540F = WHERE((Age_Gro[Size520to540] EQ 5) AND (Sex_Gro[Size520to540] EQ 1), Age5Size520to540countF)
        age6Size520to540F = WHERE((Age_Gro[Size520to540] EQ 6) AND (Sex_Gro[Size520to540] EQ 1), Age6Size520to540countF)
        age7Size520to540F = WHERE((Age_Gro[Size520to540] EQ 7) AND (Sex_Gro[Size520to540] EQ 1), Age7Size520to540countF)
        age8Size520to540F = WHERE((Age_Gro[Size520to540] EQ 8) AND (Sex_Gro[Size520to540] EQ 1), Age8Size520to540countF)
        age9Size520to540F = WHERE((Age_Gro[Size520to540] EQ 9) AND (Sex_Gro[Size520to540] EQ 1), Age9Size520to540countF)
        age10Size520to540F = WHERE((Age_Gro[Size520to540] EQ 10) AND (Sex_Gro[Size520to540] EQ 1), Age10Size520to540countF)
        age11Size520to540F = WHERE((Age_Gro[Size520to540] EQ 11) AND (Sex_Gro[Size520to540] EQ 1), Age11Size520to540countF)
        AGE12Size520to540F = WHERE((Age_Gro[Size520to540] EQ 12) AND (Sex_Gro[Size520to540] EQ 1), Age12Size520to540countF)
        AGE13Size520to540F = WHERE((Age_Gro[Size520to540] EQ 13) AND (Sex_Gro[Size520to540] EQ 1), Age13Size520to540countF)
        AGE14Size520to540F = WHERE((Age_Gro[Size520to540] EQ 14) AND (Sex_Gro[Size520to540] EQ 1), Age14Size520to540countF)
        AGE15Size520to540F = WHERE((Age_Gro[Size520to540] EQ 15) AND (Sex_Gro[Size520to540] EQ 1), Age15Size520to540countF)
        age16Size520to540F = WHERE((Age_Gro[Size520to540] EQ 16) AND (Sex_Gro[Size520to540] EQ 1), Age16Size520to540countF)
        age17Size520to540F = WHERE((Age_Gro[Size520to540] EQ 17) AND (Sex_Gro[Size520to540] EQ 1), Age17Size520to540countF)
        age18Size520to540F = WHERE((Age_Gro[Size520to540] EQ 18) AND (Sex_Gro[Size520to540] EQ 1), Age18Size520to540countF)
        age19Size520to540F = WHERE((Age_Gro[Size520to540] EQ 19) AND (Sex_Gro[Size520to540] EQ 1), Age19Size520to540countF)
        age20Size520to540F = WHERE((Age_Gro[Size520to540] EQ 20) AND (Sex_Gro[Size520to540] EQ 1), Age20Size520to540countF)
        age21Size520to540F = WHERE((Age_Gro[Size520to540] EQ 21) AND (Sex_Gro[Size520to540] EQ 1), Age21Size520to540countF)
        age22Size520to540F = WHERE((Age_Gro[Size520to540] EQ 22) AND (Sex_Gro[Size520to540] EQ 1), Age22Size520to540countF)
        age23Size520to540F = WHERE((Age_Gro[Size520to540] EQ 23) AND (Sex_Gro[Size520to540] EQ 1), Age23Size520to540countF)
        age24Size520to540F = WHERE((Age_Gro[Size520to540] EQ 24) AND (Sex_Gro[Size520to540] EQ 1), Age24Size520to540countF)
        age25Size520to540F = WHERE((Age_Gro[Size520to540] EQ 25) AND (Sex_Gro[Size520to540] EQ 1), Age25Size520to540countF)
        age26Size520to540F = WHERE((Age_Gro[Size520to540] EQ 26) AND (Sex_Gro[Size520to540] EQ 1), Age26Size520to540countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+22L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+22L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+22L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+22L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+22L] = 520
        WAE_length_bin[75, i*NumLengthBin+adj+22L] = Size520to540countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+22L] = Age0Size520to540countF
        WAE_length_bin[77, i*NumLengthBin+adj+22L] = Age1Size520to540countF
        WAE_length_bin[78, i*NumLengthBin+adj+22L] = Age2Size520to540countF
        WAE_length_bin[79, i*NumLengthBin+adj+22L] = Age3Size520to540countF
        WAE_length_bin[80, i*NumLengthBin+adj+22L] = Age4Size520to540countF
        WAE_length_bin[81, i*NumLengthBin+adj+22L] = Age5Size520to540countF
        WAE_length_bin[82, i*NumLengthBin+adj+22L] = Age6Size520to540countF
        WAE_length_bin[83, i*NumLengthBin+adj+22L] = Age7Size520to540countF
        WAE_length_bin[84, i*NumLengthBin+adj+22L] = Age8Size520to540countF
        WAE_length_bin[85, i*NumLengthBin+adj+22L] = Age9Size520to540countF
        WAE_length_bin[86, i*NumLengthBin+adj+22L] = Age10Size520to540countF
        WAE_length_bin[87, i*NumLengthBin+adj+22L] = Age11Size520to540countF
        WAE_length_bin[88, i*NumLengthBin+adj+22L] = Age12Size520to540countF
        WAE_length_bin[89, i*NumLengthBin+adj+22L] = Age13Size520to540countF
        WAE_length_bin[90, i*NumLengthBin+adj+22L] = Age14Size520to540countF
        WAE_length_bin[91, i*NumLengthBin+adj+22L] = Age15Size520to540countF
        WAE_length_bin[92, i*NumLengthBin+adj+22L] = Age16Size520to540countF
        WAE_length_bin[93, i*NumLengthBin+adj+22L] = Age17Size520to540countF
        WAE_length_bin[94, i*NumLengthBin+adj+22L] = Age18Size520to540countF
        WAE_length_bin[95, i*NumLengthBin+adj+22L] = Age19Size520to540countF
        WAE_length_bin[96, i*NumLengthBin+adj+22L] = Age20Size520to540countF
        WAE_length_bin[97, i*NumLengthBin+adj+22L] = Age21Size520to540countF
        WAE_length_bin[98, i*NumLengthBin+adj+22L] = Age22Size520to540countF
        WAE_length_bin[99, i*NumLengthBin+adj+22L] = Age23Size520to540countF
        WAE_length_bin[100, i*NumLengthBin+adj+22L] = Age24Size520to540countF
        WAE_length_bin[101, i*NumLengthBin+adj+22L] = Age25Size520to540countF
        WAE_length_bin[102, i*NumLengthBin+adj+22L] = Age26Size520to540countF
      ENDIF
      PRINT, 'Size520to540F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+22L])
      
      ; length bin 24
      IF Size540to560count GT 0 THEN BEGIN
        age0Size540to560F = WHERE((Age_Gro[Size540to560] EQ 0) AND (Sex_Gro[Size540to560] EQ 1), Age0Size540to560countF)
        age1Size540to560F = WHERE((Age_Gro[Size540to560] EQ 1) AND (Sex_Gro[Size540to560] EQ 1), Age1Size540to560countF)
        age2Size540to560F = WHERE((Age_Gro[Size540to560] EQ 2) AND (Sex_Gro[Size540to560] EQ 1), Age2Size540to560countF)
        age3Size540to560F = WHERE((Age_Gro[Size540to560] EQ 3) AND (Sex_Gro[Size540to560] EQ 1), Age3Size540to560countF)
        age4Size540to560F = WHERE((Age_Gro[Size540to560] EQ 4) AND (Sex_Gro[Size540to560] EQ 1), Age4Size540to560countF)
        age5Size540to560F = WHERE((Age_Gro[Size540to560] EQ 5) AND (Sex_Gro[Size540to560] EQ 1), Age5Size540to560countF)
        age6Size540to560F = WHERE((Age_Gro[Size540to560] EQ 6) AND (Sex_Gro[Size540to560] EQ 1), Age6Size540to560countF)
        age7Size540to560F = WHERE((Age_Gro[Size540to560] EQ 7) AND (Sex_Gro[Size540to560] EQ 1), Age7Size540to560countF)
        age8Size540to560F = WHERE((Age_Gro[Size540to560] EQ 8) AND (Sex_Gro[Size540to560] EQ 1), Age8Size540to560countF)
        age9Size540to560F = WHERE((Age_Gro[Size540to560] EQ 9) AND (Sex_Gro[Size540to560] EQ 1), Age9Size540to560countF)
        age10Size540to560F = WHERE((Age_Gro[Size540to560] EQ 10) AND (Sex_Gro[Size540to560] EQ 1), Age10Size540to560countF)
        age11Size540to560F = WHERE((Age_Gro[Size540to560] EQ 11) AND (Sex_Gro[Size540to560] EQ 1), Age11Size540to560countF)
        AGE12Size540to560F = WHERE((Age_Gro[Size540to560] EQ 12) AND (Sex_Gro[Size540to560] EQ 1), Age12Size540to560countF)
        AGE13Size540to560F = WHERE((Age_Gro[Size540to560] EQ 13) AND (Sex_Gro[Size540to560] EQ 1), Age13Size540to560countF)
        AGE14Size540to560F = WHERE((Age_Gro[Size540to560] EQ 14) AND (Sex_Gro[Size540to560] EQ 1), Age14Size540to560countF)
        AGE15Size540to560F = WHERE((Age_Gro[Size540to560] EQ 15) AND (Sex_Gro[Size540to560] EQ 1), Age15Size540to560countF)
        age16Size540to560F = WHERE((Age_Gro[Size540to560] EQ 16) AND (Sex_Gro[Size540to560] EQ 1), Age16Size540to560countF)
        age17Size540to560F = WHERE((Age_Gro[Size540to560] EQ 17) AND (Sex_Gro[Size540to560] EQ 1), Age17Size540to560countF)
        age18Size540to560F = WHERE((Age_Gro[Size540to560] EQ 18) AND (Sex_Gro[Size540to560] EQ 1), Age18Size540to560countF)
        age19Size540to560F = WHERE((Age_Gro[Size540to560] EQ 19) AND (Sex_Gro[Size540to560] EQ 1), Age19Size540to560countF)
        age20Size540to560F = WHERE((Age_Gro[Size540to560] EQ 20) AND (Sex_Gro[Size540to560] EQ 1), Age20Size540to560countF)
        age21Size540to560F = WHERE((Age_Gro[Size540to560] EQ 21) AND (Sex_Gro[Size540to560] EQ 1), Age21Size540to560countF)
        age22Size540to560F = WHERE((Age_Gro[Size540to560] EQ 22) AND (Sex_Gro[Size540to560] EQ 1), Age22Size540to560countF)
        age23Size540to560F = WHERE((Age_Gro[Size540to560] EQ 23) AND (Sex_Gro[Size540to560] EQ 1), Age23Size540to560countF)
        age24Size540to560F = WHERE((Age_Gro[Size540to560] EQ 24) AND (Sex_Gro[Size540to560] EQ 1), Age24Size540to560countF)
        age25Size540to560F = WHERE((Age_Gro[Size540to560] EQ 25) AND (Sex_Gro[Size540to560] EQ 1), Age25Size540to560countF)
        age26Size540to560F = WHERE((Age_Gro[Size540to560] EQ 26) AND (Sex_Gro[Size540to560] EQ 1), Age26Size540to560countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+23L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+23L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+23L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+23L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+23L] = 540
        WAE_length_bin[75, i*NumLengthBin+adj+23L] = Size540to560countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+23L] = Age0Size540to560countF
        WAE_length_bin[77, i*NumLengthBin+adj+23L] = Age1Size540to560countF
        WAE_length_bin[78, i*NumLengthBin+adj+23L] = Age2Size540to560countF
        WAE_length_bin[79, i*NumLengthBin+adj+23L] = Age3Size540to560countF
        WAE_length_bin[80, i*NumLengthBin+adj+23L] = Age4Size540to560countF
        WAE_length_bin[81, i*NumLengthBin+adj+23L] = Age5Size540to560countF
        WAE_length_bin[82, i*NumLengthBin+adj+23L] = Age6Size540to560countF
        WAE_length_bin[83, i*NumLengthBin+adj+23L] = Age7Size540to560countF
        WAE_length_bin[84, i*NumLengthBin+adj+23L] = Age8Size540to560countF
        WAE_length_bin[85, i*NumLengthBin+adj+23L] = Age9Size540to560countF
        WAE_length_bin[86, i*NumLengthBin+adj+23L] = Age10Size540to560countF
        WAE_length_bin[87, i*NumLengthBin+adj+23L] = Age11Size540to560countF
        WAE_length_bin[88, i*NumLengthBin+adj+23L] = Age12Size540to560countF
        WAE_length_bin[89, i*NumLengthBin+adj+23L] = Age13Size540to560countF
        WAE_length_bin[90, i*NumLengthBin+adj+23L] = Age14Size540to560countF
        WAE_length_bin[91, i*NumLengthBin+adj+23L] = Age15Size540to560countF
        WAE_length_bin[92, i*NumLengthBin+adj+23L] = Age16Size540to560countF
        WAE_length_bin[93, i*NumLengthBin+adj+23L] = Age17Size540to560countF
        WAE_length_bin[94, i*NumLengthBin+adj+23L] = Age18Size540to560countF
        WAE_length_bin[95, i*NumLengthBin+adj+23L] = Age19Size540to560countF
        WAE_length_bin[96, i*NumLengthBin+adj+23L] = Age20Size540to560countF
        WAE_length_bin[97, i*NumLengthBin+adj+23L] = Age21Size540to560countF
        WAE_length_bin[98, i*NumLengthBin+adj+23L] = Age22Size540to560countF
        WAE_length_bin[99, i*NumLengthBin+adj+23L] = Age23Size540to560countF
        WAE_length_bin[100, i*NumLengthBin+adj+23L] = Age24Size540to560countF
        WAE_length_bin[101, i*NumLengthBin+adj+23L] = Age25Size540to560countF
        WAE_length_bin[102, i*NumLengthBin+adj+23L] = Age26Size540to560countF
      ENDIF
      PRINT, 'Size540to560F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+23L])
      
      ; length bin 25
      IF Size560to580count GT 0 THEN BEGIN
        age0Size560to580F = WHERE((Age_Gro[Size560to580] EQ 0) AND (Sex_Gro[Size560to580] EQ 1), Age0Size560to580countF)
        age1Size560to580F = WHERE((Age_Gro[Size560to580] EQ 1) AND (Sex_Gro[Size560to580] EQ 1), Age1Size560to580countF)
        age2Size560to580F = WHERE((Age_Gro[Size560to580] EQ 2) AND (Sex_Gro[Size560to580] EQ 1), Age2Size560to580countF)
        age3Size560to580F = WHERE((Age_Gro[Size560to580] EQ 3) AND (Sex_Gro[Size560to580] EQ 1), Age3Size560to580countF)
        age4Size560to580F = WHERE((Age_Gro[Size560to580] EQ 4) AND (Sex_Gro[Size560to580] EQ 1), Age4Size560to580countF)
        age5Size560to580F = WHERE((Age_Gro[Size560to580] EQ 5) AND (Sex_Gro[Size560to580] EQ 1), Age5Size560to580countF)
        age6Size560to580F = WHERE((Age_Gro[Size560to580] EQ 6) AND (Sex_Gro[Size560to580] EQ 1), Age6Size560to580countF)
        age7Size560to580F = WHERE((Age_Gro[Size560to580] EQ 7) AND (Sex_Gro[Size560to580] EQ 1), Age7Size560to580countF)
        age8Size560to580F = WHERE((Age_Gro[Size560to580] EQ 8) AND (Sex_Gro[Size560to580] EQ 1), Age8Size560to580countF)
        age9Size560to580F = WHERE((Age_Gro[Size560to580] EQ 9) AND (Sex_Gro[Size560to580] EQ 1), Age9Size560to580countF)
        age10Size560to580F = WHERE((Age_Gro[Size560to580] EQ 10) AND (Sex_Gro[Size560to580] EQ 1), Age10Size560to580countF)
        age11Size560to580F = WHERE((Age_Gro[Size560to580] EQ 11) AND (Sex_Gro[Size560to580] EQ 1), Age11Size560to580countF)
        AGE12Size560to580F = WHERE((Age_Gro[Size560to580] EQ 12) AND (Sex_Gro[Size560to580] EQ 1), Age12Size560to580countF)
        AGE13Size560to580F = WHERE((Age_Gro[Size560to580] EQ 13) AND (Sex_Gro[Size560to580] EQ 1), Age13Size560to580countF)
        AGE14Size560to580F = WHERE((Age_Gro[Size560to580] EQ 14) AND (Sex_Gro[Size560to580] EQ 1), Age14Size560to580countF)
        AGE15Size560to580F = WHERE((Age_Gro[Size560to580] EQ 15) AND (Sex_Gro[Size560to580] EQ 1), Age15Size560to580countF)
        age16Size560to580F = WHERE((Age_Gro[Size560to580] EQ 16) AND (Sex_Gro[Size560to580] EQ 1), Age16Size560to580countF)
        age17Size560to580F = WHERE((Age_Gro[Size560to580] EQ 17) AND (Sex_Gro[Size560to580] EQ 1), Age17Size560to580countF)
        age18Size560to580F = WHERE((Age_Gro[Size560to580] EQ 18) AND (Sex_Gro[Size560to580] EQ 1), Age18Size560to580countF)
        age19Size560to580F = WHERE((Age_Gro[Size560to580] EQ 19) AND (Sex_Gro[Size560to580] EQ 1), Age19Size560to580countF)
        age20Size560to580F = WHERE((Age_Gro[Size560to580] EQ 20) AND (Sex_Gro[Size560to580] EQ 1), Age20Size560to580countF)
        age21Size560to580F = WHERE((Age_Gro[Size560to580] EQ 21) AND (Sex_Gro[Size560to580] EQ 1), Age21Size560to580countF)
        age22Size560to580F = WHERE((Age_Gro[Size560to580] EQ 22) AND (Sex_Gro[Size560to580] EQ 1), Age22Size560to580countF)
        age23Size560to580F = WHERE((Age_Gro[Size560to580] EQ 23) AND (Sex_Gro[Size560to580] EQ 1), Age23Size560to580countF)
        age24Size560to580F = WHERE((Age_Gro[Size560to580] EQ 24) AND (Sex_Gro[Size560to580] EQ 1), Age24Size560to580countF)
        age25Size560to580F = WHERE((Age_Gro[Size560to580] EQ 25) AND (Sex_Gro[Size560to580] EQ 1), Age25Size560to580countF)
        age26Size560to580F = WHERE((Age_Gro[Size560to580] EQ 26) AND (Sex_Gro[Size560to580] EQ 1), Age26Size560to580countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+24L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+24L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+24L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+24L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+24L] = 560
        WAE_length_bin[75, i*NumLengthBin+adj+24L] = Size560to580countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+24L] = Age0Size560to580countF
        WAE_length_bin[77, i*NumLengthBin+adj+24L] = Age1Size560to580countF
        WAE_length_bin[78, i*NumLengthBin+adj+24L] = Age2Size560to580countF
        WAE_length_bin[79, i*NumLengthBin+adj+24L] = Age3Size560to580countF
        WAE_length_bin[80, i*NumLengthBin+adj+24L] = Age4Size560to580countF
        WAE_length_bin[81, i*NumLengthBin+adj+24L] = Age5Size560to580countF
        WAE_length_bin[82, i*NumLengthBin+adj+24L] = Age6Size560to580countF
        WAE_length_bin[83, i*NumLengthBin+adj+24L] = Age7Size560to580countF
        WAE_length_bin[84, i*NumLengthBin+adj+24L] = Age8Size560to580countF
        WAE_length_bin[85, i*NumLengthBin+adj+24L] = Age9Size560to580countF
        WAE_length_bin[86, i*NumLengthBin+adj+24L] = Age10Size560to580countF
        WAE_length_bin[87, i*NumLengthBin+adj+24L] = Age11Size560to580countF
        WAE_length_bin[88, i*NumLengthBin+adj+24L] = Age12Size560to580countF
        WAE_length_bin[89, i*NumLengthBin+adj+24L] = Age13Size560to580countF
        WAE_length_bin[90, i*NumLengthBin+adj+24L] = Age14Size560to580countF
        WAE_length_bin[91, i*NumLengthBin+adj+24L] = Age15Size560to580countF
        WAE_length_bin[92, i*NumLengthBin+adj+24L] = Age16Size560to580countF
        WAE_length_bin[93, i*NumLengthBin+adj+24L] = Age17Size560to580countF
        WAE_length_bin[94, i*NumLengthBin+adj+24L] = Age18Size560to580countF
        WAE_length_bin[95, i*NumLengthBin+adj+24L] = Age19Size560to580countF
        WAE_length_bin[96, i*NumLengthBin+adj+24L] = Age20Size560to580countF
        WAE_length_bin[97, i*NumLengthBin+adj+24L] = Age21Size560to580countF
        WAE_length_bin[98, i*NumLengthBin+adj+24L] = Age22Size560to580countF
        WAE_length_bin[99, i*NumLengthBin+adj+24L] = Age23Size560to580countF
        WAE_length_bin[100, i*NumLengthBin+adj+24L] = Age24Size560to580countF
        WAE_length_bin[101, i*NumLengthBin+adj+24L] = Age25Size560to580countF
        WAE_length_bin[102, i*NumLengthBin+adj+24L] = Age26Size560to580countF
      ENDIF
      PRINT, 'Size560to580F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+24L])
      
      ; length bin 26
      IF Size580to600count GT 0 THEN BEGIN
        age0Size580to600F = WHERE((Age_Gro[Size580to600] EQ 0) AND (Sex_Gro[Size580to600] EQ 1), Age0Size580to600countF)
        age1Size580to600F = WHERE((Age_Gro[Size580to600] EQ 1) AND (Sex_Gro[Size580to600] EQ 1), Age1Size580to600countF)
        age2Size580to600F = WHERE((Age_Gro[Size580to600] EQ 2) AND (Sex_Gro[Size580to600] EQ 1), Age2Size580to600countF)
        age3Size580to600F = WHERE((Age_Gro[Size580to600] EQ 3) AND (Sex_Gro[Size580to600] EQ 1), Age3Size580to600countF)
        age4Size580to600F = WHERE((Age_Gro[Size580to600] EQ 4) AND (Sex_Gro[Size580to600] EQ 1), Age4Size580to600countF)
        age5Size580to600F = WHERE((Age_Gro[Size580to600] EQ 5) AND (Sex_Gro[Size580to600] EQ 1), Age5Size580to600countF)
        age6Size580to600F = WHERE((Age_Gro[Size580to600] EQ 6) AND (Sex_Gro[Size580to600] EQ 1), Age6Size580to600countF)
        age7Size580to600F = WHERE((Age_Gro[Size580to600] EQ 7) AND (Sex_Gro[Size580to600] EQ 1), Age7Size580to600countF)
        age8Size580to600F = WHERE((Age_Gro[Size580to600] EQ 8) AND (Sex_Gro[Size580to600] EQ 1), Age8Size580to600countF)
        age9Size580to600F = WHERE((Age_Gro[Size580to600] EQ 9) AND (Sex_Gro[Size580to600] EQ 1), Age9Size580to600countF)
        age10Size580to600F = WHERE((Age_Gro[Size580to600] EQ 10) AND (Sex_Gro[Size580to600] EQ 1), Age10Size580to600countF)
        age11Size580to600F = WHERE((Age_Gro[Size580to600] EQ 11) AND (Sex_Gro[Size580to600] EQ 1), Age11Size580to600countF)
        AGE12Size580to600F = WHERE((Age_Gro[Size580to600] EQ 12) AND (Sex_Gro[Size580to600] EQ 1), Age12Size580to600countF)
        AGE13Size580to600F = WHERE((Age_Gro[Size580to600] EQ 13) AND (Sex_Gro[Size580to600] EQ 1), Age13Size580to600countF)
        AGE14Size580to600F = WHERE((Age_Gro[Size580to600] EQ 14) AND (Sex_Gro[Size580to600] EQ 1), Age14Size580to600countF)
        AGE15Size580to600F = WHERE((Age_Gro[Size580to600] EQ 15) AND (Sex_Gro[Size580to600] EQ 1), Age15Size580to600countF)
        age16Size580to600F = WHERE((Age_Gro[Size580to600] EQ 16) AND (Sex_Gro[Size580to600] EQ 1), Age16Size580to600countF)
        age17Size580to600F = WHERE((Age_Gro[Size580to600] EQ 17) AND (Sex_Gro[Size580to600] EQ 1), Age17Size580to600countF)
        age18Size580to600F = WHERE((Age_Gro[Size580to600] EQ 18) AND (Sex_Gro[Size580to600] EQ 1), Age18Size580to600countF)
        age19Size580to600F = WHERE((Age_Gro[Size580to600] EQ 19) AND (Sex_Gro[Size580to600] EQ 1), Age19Size580to600countF)
        age20Size580to600F = WHERE((Age_Gro[Size580to600] EQ 20) AND (Sex_Gro[Size580to600] EQ 1), Age20Size580to600countF)
        age21Size580to600F = WHERE((Age_Gro[Size580to600] EQ 21) AND (Sex_Gro[Size580to600] EQ 1), Age21Size580to600countF)
        age22Size580to600F = WHERE((Age_Gro[Size580to600] EQ 22) AND (Sex_Gro[Size580to600] EQ 1), Age22Size580to600countF)
        age23Size580to600F = WHERE((Age_Gro[Size580to600] EQ 23) AND (Sex_Gro[Size580to600] EQ 1), Age23Size580to600countF)
        age24Size580to600F = WHERE((Age_Gro[Size580to600] EQ 24) AND (Sex_Gro[Size580to600] EQ 1), Age24Size580to600countF)
        age25Size580to600F = WHERE((Age_Gro[Size580to600] EQ 25) AND (Sex_Gro[Size580to600] EQ 1), Age25Size580to600countF)
        age26Size580to600F = WHERE((Age_Gro[Size580to600] EQ 26) AND (Sex_Gro[Size580to600] EQ 1), Age26Size580to600countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+25L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+25L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+25L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+25L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+25L] = 580
        WAE_length_bin[75, i*NumLengthBin+adj+25L] = Size580to600countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+25L] = Age0Size580to600countF
        WAE_length_bin[77, i*NumLengthBin+adj+25L] = Age1Size580to600countF
        WAE_length_bin[78, i*NumLengthBin+adj+25L] = Age2Size580to600countF
        WAE_length_bin[79, i*NumLengthBin+adj+25L] = Age3Size580to600countF
        WAE_length_bin[80, i*NumLengthBin+adj+25L] = Age4Size580to600countF
        WAE_length_bin[81, i*NumLengthBin+adj+25L] = Age5Size580to600countF
        WAE_length_bin[82, i*NumLengthBin+adj+25L] = Age6Size580to600countF
        WAE_length_bin[83, i*NumLengthBin+adj+25L] = Age7Size580to600countF
        WAE_length_bin[84, i*NumLengthBin+adj+25L] = Age8Size580to600countF
        WAE_length_bin[85, i*NumLengthBin+adj+25L] = Age9Size580to600countF
        WAE_length_bin[86, i*NumLengthBin+adj+25L] = Age10Size580to600countF
        WAE_length_bin[87, i*NumLengthBin+adj+25L] = Age11Size580to600countF
        WAE_length_bin[88, i*NumLengthBin+adj+25L] = Age12Size580to600countF
        WAE_length_bin[89, i*NumLengthBin+adj+25L] = Age13Size580to600countF
        WAE_length_bin[90, i*NumLengthBin+adj+25L] = Age14Size580to600countF
        WAE_length_bin[91, i*NumLengthBin+adj+25L] = Age15Size580to600countF
        WAE_length_bin[92, i*NumLengthBin+adj+25L] = Age16Size580to600countF
        WAE_length_bin[93, i*NumLengthBin+adj+25L] = Age17Size580to600countF
        WAE_length_bin[94, i*NumLengthBin+adj+25L] = Age18Size580to600countF
        WAE_length_bin[95, i*NumLengthBin+adj+25L] = Age19Size580to600countF
        WAE_length_bin[96, i*NumLengthBin+adj+25L] = Age20Size580to600countF
        WAE_length_bin[97, i*NumLengthBin+adj+25L] = Age21Size580to600countF
        WAE_length_bin[98, i*NumLengthBin+adj+25L] = Age22Size580to600countF
        WAE_length_bin[99, i*NumLengthBin+adj+25L] = Age23Size580to600countF
        WAE_length_bin[100, i*NumLengthBin+adj+25L] = Age24Size580to600countF
        WAE_length_bin[101, i*NumLengthBin+adj+25L] = Age25Size580to600countF
        WAE_length_bin[102, i*NumLengthBin+adj+25L] = Age26Size580to600countF
      ENDIF
      PRINT, 'Size580to600F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+25L])
      
      ; length bin 27
      IF Size600to620count GT 0 THEN BEGIN
        age0Size600to620F = WHERE((Age_Gro[Size600to620] EQ 0) AND (Sex_Gro[Size600to620] EQ 1), Age0Size600to620countF)
        age1Size600to620F = WHERE((Age_Gro[Size600to620] EQ 1) AND (Sex_Gro[Size600to620] EQ 1), Age1Size600to620countF)
        age2Size600to620F = WHERE((Age_Gro[Size600to620] EQ 2) AND (Sex_Gro[Size600to620] EQ 1), Age2Size600to620countF)
        age3Size600to620F = WHERE((Age_Gro[Size600to620] EQ 3) AND (Sex_Gro[Size600to620] EQ 1), Age3Size600to620countF)
        age4Size600to620F = WHERE((Age_Gro[Size600to620] EQ 4) AND (Sex_Gro[Size600to620] EQ 1), Age4Size600to620countF)
        age5Size600to620F = WHERE((Age_Gro[Size600to620] EQ 5) AND (Sex_Gro[Size600to620] EQ 1), Age5Size600to620countF)
        age6Size600to620F = WHERE((Age_Gro[Size600to620] EQ 6) AND (Sex_Gro[Size600to620] EQ 1), Age6Size600to620countF)
        age7Size600to620F = WHERE((Age_Gro[Size600to620] EQ 7) AND (Sex_Gro[Size600to620] EQ 1), Age7Size600to620countF)
        age8Size600to620F = WHERE((Age_Gro[Size600to620] EQ 8) AND (Sex_Gro[Size600to620] EQ 1), Age8Size600to620countF)
        age9Size600to620F = WHERE((Age_Gro[Size600to620] EQ 9) AND (Sex_Gro[Size600to620] EQ 1), Age9Size600to620countF)
        age10Size600to620F = WHERE((Age_Gro[Size600to620] EQ 10) AND (Sex_Gro[Size600to620] EQ 1), Age10Size600to620countF)
        age11Size600to620F = WHERE((Age_Gro[Size600to620] EQ 11) AND (Sex_Gro[Size600to620] EQ 1), Age11Size600to620countF)
        AGE12Size600to620F = WHERE((Age_Gro[Size600to620] EQ 12) AND (Sex_Gro[Size600to620] EQ 1), Age12Size600to620countF)
        AGE13Size600to620F = WHERE((Age_Gro[Size600to620] EQ 13) AND (Sex_Gro[Size600to620] EQ 1), Age13Size600to620countF)
        AGE14Size600to620F = WHERE((Age_Gro[Size600to620] EQ 14) AND (Sex_Gro[Size600to620] EQ 1), Age14Size600to620countF)
        AGE15Size600to620F = WHERE((Age_Gro[Size600to620] EQ 15) AND (Sex_Gro[Size600to620] EQ 1), Age15Size600to620countF)
        age16Size600to620F = WHERE((Age_Gro[Size600to620] EQ 16) AND (Sex_Gro[Size600to620] EQ 1), Age16Size600to620countF)
        age17Size600to620F = WHERE((Age_Gro[Size600to620] EQ 17) AND (Sex_Gro[Size600to620] EQ 1), Age17Size600to620countF)
        age18Size600to620F = WHERE((Age_Gro[Size600to620] EQ 18) AND (Sex_Gro[Size600to620] EQ 1), Age18Size600to620countF)
        age19Size600to620F = WHERE((Age_Gro[Size600to620] EQ 19) AND (Sex_Gro[Size600to620] EQ 1), Age19Size600to620countF)
        age20Size600to620F = WHERE((Age_Gro[Size600to620] EQ 20) AND (Sex_Gro[Size600to620] EQ 1), Age20Size600to620countF)
        age21Size600to620F = WHERE((Age_Gro[Size600to620] EQ 21) AND (Sex_Gro[Size600to620] EQ 1), Age21Size600to620countF)
        age22Size600to620F = WHERE((Age_Gro[Size600to620] EQ 22) AND (Sex_Gro[Size600to620] EQ 1), Age22Size600to620countF)
        age23Size600to620F = WHERE((Age_Gro[Size600to620] EQ 23) AND (Sex_Gro[Size600to620] EQ 1), Age23Size600to620countF)
        age24Size600to620F = WHERE((Age_Gro[Size600to620] EQ 24) AND (Sex_Gro[Size600to620] EQ 1), Age24Size600to620countF)
        age25Size600to620F = WHERE((Age_Gro[Size600to620] EQ 25) AND (Sex_Gro[Size600to620] EQ 1), Age25Size600to620countF)
        age26Size600to620F = WHERE((Age_Gro[Size600to620] EQ 26) AND (Sex_Gro[Size600to620] EQ 1), Age26Size600to620countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+26L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+26L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+26L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+26L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+26L] = 600
        WAE_length_bin[75, i*NumLengthBin+adj+26L] = Size600to620countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+26L] = Age0Size600to620countF
        WAE_length_bin[77, i*NumLengthBin+adj+26L] = Age1Size600to620countF
        WAE_length_bin[78, i*NumLengthBin+adj+26L] = Age2Size600to620countF
        WAE_length_bin[79, i*NumLengthBin+adj+26L] = Age3Size600to620countF
        WAE_length_bin[80, i*NumLengthBin+adj+26L] = Age4Size600to620countF
        WAE_length_bin[81, i*NumLengthBin+adj+26L] = Age5Size600to620countF
        WAE_length_bin[82, i*NumLengthBin+adj+26L] = Age6Size600to620countF
        WAE_length_bin[83, i*NumLengthBin+adj+26L] = Age7Size600to620countF
        WAE_length_bin[84, i*NumLengthBin+adj+26L] = Age8Size600to620countF
        WAE_length_bin[85, i*NumLengthBin+adj+26L] = Age9Size600to620countF
        WAE_length_bin[86, i*NumLengthBin+adj+26L] = Age10Size600to620countF
        WAE_length_bin[87, i*NumLengthBin+adj+26L] = Age11Size600to620countF
        WAE_length_bin[88, i*NumLengthBin+adj+26L] = Age12Size600to620countF
        WAE_length_bin[89, i*NumLengthBin+adj+26L] = Age13Size600to620countF
        WAE_length_bin[90, i*NumLengthBin+adj+26L] = Age14Size600to620countF
        WAE_length_bin[91, i*NumLengthBin+adj+26L] = Age15Size600to620countF
        WAE_length_bin[92, i*NumLengthBin+adj+26L] = Age16Size600to620countF
        WAE_length_bin[93, i*NumLengthBin+adj+26L] = Age17Size600to620countF
        WAE_length_bin[94, i*NumLengthBin+adj+26L] = Age18Size600to620countF
        WAE_length_bin[95, i*NumLengthBin+adj+26L] = Age19Size600to620countF
        WAE_length_bin[96, i*NumLengthBin+adj+26L] = Age20Size600to620countF
        WAE_length_bin[97, i*NumLengthBin+adj+26L] = Age21Size600to620countF
        WAE_length_bin[98, i*NumLengthBin+adj+26L] = Age22Size600to620countF
        WAE_length_bin[99, i*NumLengthBin+adj+26L] = Age23Size600to620countF
        WAE_length_bin[100, i*NumLengthBin+adj+26L] = Age24Size600to620countF
        WAE_length_bin[101, i*NumLengthBin+adj+26L] = Age25Size600to620countF
        WAE_length_bin[102, i*NumLengthBin+adj+26L] = Age26Size600to620countF
      ENDIF
      PRINT, 'Size600to620F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+26L])
      
      
      ; length bin 28
      IF Size620to640count GT 0 THEN BEGIN
        age0Size620to640F = WHERE((Age_Gro[Size620to640] EQ 0) AND (Sex_Gro[Size620to640] EQ 1), Age0Size620to640countF)
        age1Size620to640F = WHERE((Age_Gro[Size620to640] EQ 1) AND (Sex_Gro[Size620to640] EQ 1), Age1Size620to640countF)
        age2Size620to640F = WHERE((Age_Gro[Size620to640] EQ 2) AND (Sex_Gro[Size620to640] EQ 1), Age2Size620to640countF)
        age3Size620to640F = WHERE((Age_Gro[Size620to640] EQ 3) AND (Sex_Gro[Size620to640] EQ 1), Age3Size620to640countF)
        age4Size620to640F = WHERE((Age_Gro[Size620to640] EQ 4) AND (Sex_Gro[Size620to640] EQ 1), Age4Size620to640countF)
        age5Size620to640F = WHERE((Age_Gro[Size620to640] EQ 5) AND (Sex_Gro[Size620to640] EQ 1), Age5Size620to640countF)
        age6Size620to640F = WHERE((Age_Gro[Size620to640] EQ 6) AND (Sex_Gro[Size620to640] EQ 1), Age6Size620to640countF)
        age7Size620to640F = WHERE((Age_Gro[Size620to640] EQ 7) AND (Sex_Gro[Size620to640] EQ 1), Age7Size620to640countF)
        age8Size620to640F = WHERE((Age_Gro[Size620to640] EQ 8) AND (Sex_Gro[Size620to640] EQ 1), Age8Size620to640countF)
        age9Size620to640F = WHERE((Age_Gro[Size620to640] EQ 9) AND (Sex_Gro[Size620to640] EQ 1), Age9Size620to640countF)
        age10Size620to640F = WHERE((Age_Gro[Size620to640] EQ 10) AND (Sex_Gro[Size620to640] EQ 1), Age10Size620to640countF)
        age11Size620to640F = WHERE((Age_Gro[Size620to640] EQ 11) AND (Sex_Gro[Size620to640] EQ 1), Age11Size620to640countF)
        AGE12Size620to640F = WHERE((Age_Gro[Size620to640] EQ 12) AND (Sex_Gro[Size620to640] EQ 1), Age12Size620to640countF)
        AGE13Size620to640F = WHERE((Age_Gro[Size620to640] EQ 13) AND (Sex_Gro[Size620to640] EQ 1), Age13Size620to640countF)
        AGE14Size620to640F = WHERE((Age_Gro[Size620to640] EQ 14) AND (Sex_Gro[Size620to640] EQ 1), Age14Size620to640countF)
        AGE15Size620to640F = WHERE((Age_Gro[Size620to640] EQ 15) AND (Sex_Gro[Size620to640] EQ 1), Age15Size620to640countF)
        age16Size620to640F = WHERE((Age_Gro[Size620to640] EQ 16) AND (Sex_Gro[Size620to640] EQ 1), Age16Size620to640countF)
        age17Size620to640F = WHERE((Age_Gro[Size620to640] EQ 17) AND (Sex_Gro[Size620to640] EQ 1), Age17Size620to640countF)
        age18Size620to640F = WHERE((Age_Gro[Size620to640] EQ 18) AND (Sex_Gro[Size620to640] EQ 1), Age18Size620to640countF)
        age19Size620to640F = WHERE((Age_Gro[Size620to640] EQ 19) AND (Sex_Gro[Size620to640] EQ 1), Age19Size620to640countF)
        age20Size620to640F = WHERE((Age_Gro[Size620to640] EQ 20) AND (Sex_Gro[Size620to640] EQ 1), Age20Size620to640countF)
        age21Size620to640F = WHERE((Age_Gro[Size620to640] EQ 21) AND (Sex_Gro[Size620to640] EQ 1), Age21Size620to640countF)
        age22Size620to640F = WHERE((Age_Gro[Size620to640] EQ 22) AND (Sex_Gro[Size620to640] EQ 1), Age22Size620to640countF)
        age23Size620to640F = WHERE((Age_Gro[Size620to640] EQ 23) AND (Sex_Gro[Size620to640] EQ 1), Age23Size620to640countF)
        age24Size620to640F = WHERE((Age_Gro[Size620to640] EQ 24) AND (Sex_Gro[Size620to640] EQ 1), Age24Size620to640countF)
        age25Size620to640F = WHERE((Age_Gro[Size620to640] EQ 25) AND (Sex_Gro[Size620to640] EQ 1), Age25Size620to640countF)
        age26Size620to640F = WHERE((Age_Gro[Size620to640] EQ 26) AND (Sex_Gro[Size620to640] EQ 1), Age26Size620to640countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+27L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+27L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+27L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+27L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+27L] = 620
        WAE_length_bin[75, i*NumLengthBin+adj+27L] = Size620to640countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+27L] = Age0Size620to640countF
        WAE_length_bin[77, i*NumLengthBin+adj+27L] = Age1Size620to640countF
        WAE_length_bin[78, i*NumLengthBin+adj+27L] = Age2Size620to640countF
        WAE_length_bin[79, i*NumLengthBin+adj+27L] = Age3Size620to640countF
        WAE_length_bin[80, i*NumLengthBin+adj+27L] = Age4Size620to640countF
        WAE_length_bin[81, i*NumLengthBin+adj+27L] = Age5Size620to640countF
        WAE_length_bin[82, i*NumLengthBin+adj+27L] = Age6Size620to640countF
        WAE_length_bin[83, i*NumLengthBin+adj+27L] = Age7Size620to640countF
        WAE_length_bin[84, i*NumLengthBin+adj+27L] = Age8Size620to640countF
        WAE_length_bin[85, i*NumLengthBin+adj+27L] = Age9Size620to640countF
        WAE_length_bin[86, i*NumLengthBin+adj+27L] = Age10Size620to640countF
        WAE_length_bin[87, i*NumLengthBin+adj+27L] = Age11Size620to640countF
        WAE_length_bin[88, i*NumLengthBin+adj+27L] = Age12Size620to640countF
        WAE_length_bin[89, i*NumLengthBin+adj+27L] = Age13Size620to640countF
        WAE_length_bin[90, i*NumLengthBin+adj+27L] = Age14Size620to640countF
        WAE_length_bin[91, i*NumLengthBin+adj+27L] = Age15Size620to640countF
        WAE_length_bin[92, i*NumLengthBin+adj+27L] = Age16Size620to640countF
        WAE_length_bin[93, i*NumLengthBin+adj+27L] = Age17Size620to640countF
        WAE_length_bin[94, i*NumLengthBin+adj+27L] = Age18Size620to640countF
        WAE_length_bin[95, i*NumLengthBin+adj+27L] = Age19Size620to640countF
        WAE_length_bin[96, i*NumLengthBin+adj+27L] = Age20Size620to640countF
        WAE_length_bin[97, i*NumLengthBin+adj+27L] = Age21Size620to640countF
        WAE_length_bin[98, i*NumLengthBin+adj+27L] = Age22Size620to640countF
        WAE_length_bin[99, i*NumLengthBin+adj+27L] = Age23Size620to640countF
        WAE_length_bin[100, i*NumLengthBin+adj+27L] = Age24Size620to640countF
        WAE_length_bin[101, i*NumLengthBin+adj+27L] = Age25Size620to640countF
        WAE_length_bin[102, i*NumLengthBin+adj+27L] = Age26Size620to640countF
      ENDIF
      PRINT, 'Size620to640F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+27L])
      
      ; length bin 29
      IF Size640to660count GT 0 THEN BEGIN
        age0Size640to660F = WHERE((Age_Gro[Size640to660] EQ 0) AND (Sex_Gro[Size640to660] EQ 1), Age0Size640to660countF)
        age1Size640to660F = WHERE((Age_Gro[Size640to660] EQ 1) AND (Sex_Gro[Size640to660] EQ 1), Age1Size640to660countF)
        age2Size640to660F = WHERE((Age_Gro[Size640to660] EQ 2) AND (Sex_Gro[Size640to660] EQ 1), Age2Size640to660countF)
        age3Size640to660F = WHERE((Age_Gro[Size640to660] EQ 3) AND (Sex_Gro[Size640to660] EQ 1), Age3Size640to660countF)
        age4Size640to660F = WHERE((Age_Gro[Size640to660] EQ 4) AND (Sex_Gro[Size640to660] EQ 1), Age4Size640to660countF)
        age5Size640to660F = WHERE((Age_Gro[Size640to660] EQ 5) AND (Sex_Gro[Size640to660] EQ 1), Age5Size640to660countF)
        age6Size640to660F = WHERE((Age_Gro[Size640to660] EQ 6) AND (Sex_Gro[Size640to660] EQ 1), Age6Size640to660countF)
        age7Size640to660F = WHERE((Age_Gro[Size640to660] EQ 7) AND (Sex_Gro[Size640to660] EQ 1), Age7Size640to660countF)
        age8Size640to660F = WHERE((Age_Gro[Size640to660] EQ 8) AND (Sex_Gro[Size640to660] EQ 1), Age8Size640to660countF)
        age9Size640to660F = WHERE((Age_Gro[Size640to660] EQ 9) AND (Sex_Gro[Size640to660] EQ 1), Age9Size640to660countF)
        age10Size640to660F = WHERE((Age_Gro[Size640to660] EQ 10) AND (Sex_Gro[Size640to660] EQ 1), Age10Size640to660countF)
        age11Size640to660F = WHERE((Age_Gro[Size640to660] EQ 11) AND (Sex_Gro[Size640to660] EQ 1), Age11Size640to660countF)
        AGE12Size640to660F = WHERE((Age_Gro[Size640to660] EQ 12) AND (Sex_Gro[Size640to660] EQ 1), Age12Size640to660countF)
        AGE13Size640to660F = WHERE((Age_Gro[Size640to660] EQ 13) AND (Sex_Gro[Size640to660] EQ 1), Age13Size640to660countF)
        AGE14Size640to660F = WHERE((Age_Gro[Size640to660] EQ 14) AND (Sex_Gro[Size640to660] EQ 1), Age14Size640to660countF)
        AGE15Size640to660F = WHERE((Age_Gro[Size640to660] EQ 15) AND (Sex_Gro[Size640to660] EQ 1), Age15Size640to660countF)
        age16Size640to660F = WHERE((Age_Gro[Size640to660] EQ 16) AND (Sex_Gro[Size640to660] EQ 1), Age16Size640to660countF)
        age17Size640to660F = WHERE((Age_Gro[Size640to660] EQ 17) AND (Sex_Gro[Size640to660] EQ 1), Age17Size640to660countF)
        age18Size640to660F = WHERE((Age_Gro[Size640to660] EQ 18) AND (Sex_Gro[Size640to660] EQ 1), Age18Size640to660countF)
        age19Size640to660F = WHERE((Age_Gro[Size640to660] EQ 19) AND (Sex_Gro[Size640to660] EQ 1), Age19Size640to660countF)
        age20Size640to660F = WHERE((Age_Gro[Size640to660] EQ 20) AND (Sex_Gro[Size640to660] EQ 1), Age20Size640to660countF)
        age21Size640to660F = WHERE((Age_Gro[Size640to660] EQ 21) AND (Sex_Gro[Size640to660] EQ 1), Age21Size640to660countF)
        age22Size640to660F = WHERE((Age_Gro[Size640to660] EQ 22) AND (Sex_Gro[Size640to660] EQ 1), Age22Size640to660countF)
        age23Size640to660F = WHERE((Age_Gro[Size640to660] EQ 23) AND (Sex_Gro[Size640to660] EQ 1), Age23Size640to660countF)
        age24Size640to660F = WHERE((Age_Gro[Size640to660] EQ 24) AND (Sex_Gro[Size640to660] EQ 1), Age24Size640to660countF)
        age25Size640to660F = WHERE((Age_Gro[Size640to660] EQ 25) AND (Sex_Gro[Size640to660] EQ 1), Age25Size640to660countF)
        age26Size640to660F = WHERE((Age_Gro[Size640to660] EQ 26) AND (Sex_Gro[Size640to660] EQ 1), Age26Size640to660countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+28L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+28L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+28L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+28L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+28L] = 640
        WAE_length_bin[75, i*NumLengthBin+adj+28L] = Size640to660countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+28L] = Age0Size640to660countF
        WAE_length_bin[77, i*NumLengthBin+adj+28L] = Age1Size640to660countF
        WAE_length_bin[78, i*NumLengthBin+adj+28L] = Age2Size640to660countF
        WAE_length_bin[79, i*NumLengthBin+adj+28L] = Age3Size640to660countF
        WAE_length_bin[80, i*NumLengthBin+adj+28L] = Age4Size640to660countF
        WAE_length_bin[81, i*NumLengthBin+adj+28L] = Age5Size640to660countF
        WAE_length_bin[82, i*NumLengthBin+adj+28L] = Age6Size640to660countF
        WAE_length_bin[83, i*NumLengthBin+adj+28L] = Age7Size640to660countF
        WAE_length_bin[84, i*NumLengthBin+adj+28L] = Age8Size640to660countF
        WAE_length_bin[85, i*NumLengthBin+adj+28L] = Age9Size640to660countF
        WAE_length_bin[86, i*NumLengthBin+adj+28L] = Age10Size640to660countF
        WAE_length_bin[87, i*NumLengthBin+adj+28L] = Age11Size640to660countF
        WAE_length_bin[88, i*NumLengthBin+adj+28L] = Age12Size640to660countF
        WAE_length_bin[89, i*NumLengthBin+adj+28L] = Age13Size640to660countF
        WAE_length_bin[90, i*NumLengthBin+adj+28L] = Age14Size640to660countF
        WAE_length_bin[91, i*NumLengthBin+adj+28L] = Age15Size640to660countF
        WAE_length_bin[92, i*NumLengthBin+adj+28L] = Age16Size640to660countF
        WAE_length_bin[93, i*NumLengthBin+adj+28L] = Age17Size640to660countF
        WAE_length_bin[94, i*NumLengthBin+adj+28L] = Age18Size640to660countF
        WAE_length_bin[95, i*NumLengthBin+adj+28L] = Age19Size640to660countF
        WAE_length_bin[96, i*NumLengthBin+adj+28L] = Age20Size640to660countF
        WAE_length_bin[97, i*NumLengthBin+adj+28L] = Age21Size640to660countF
        WAE_length_bin[98, i*NumLengthBin+adj+28L] = Age22Size640to660countF
        WAE_length_bin[99, i*NumLengthBin+adj+28L] = Age23Size640to660countF
        WAE_length_bin[100, i*NumLengthBin+adj+28L] = Age24Size640to660countF
        WAE_length_bin[101, i*NumLengthBin+adj+28L] = Age25Size640to660countF
        WAE_length_bin[102, i*NumLengthBin+adj+28L] = Age26Size640to660countF
      ENDIF
      PRINT, 'Size640to660F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+28L])
      
      ; length bin 30
      IF Size660to680count GT 0 THEN BEGIN
        age0Size660to680F = WHERE((Age_Gro[Size660to680] EQ 0) AND (Sex_Gro[Size660to680] EQ 1), Age0Size660to680countF)
        age1Size660to680F = WHERE((Age_Gro[Size660to680] EQ 1) AND (Sex_Gro[Size660to680] EQ 1), Age1Size660to680countF)
        age2Size660to680F = WHERE((Age_Gro[Size660to680] EQ 2) AND (Sex_Gro[Size660to680] EQ 1), Age2Size660to680countF)
        age3Size660to680F = WHERE((Age_Gro[Size660to680] EQ 3) AND (Sex_Gro[Size660to680] EQ 1), Age3Size660to680countF)
        age4Size660to680F = WHERE((Age_Gro[Size660to680] EQ 4) AND (Sex_Gro[Size660to680] EQ 1), Age4Size660to680countF)
        age5Size660to680F = WHERE((Age_Gro[Size660to680] EQ 5) AND (Sex_Gro[Size660to680] EQ 1), Age5Size660to680countF)
        age6Size660to680F = WHERE((Age_Gro[Size660to680] EQ 6) AND (Sex_Gro[Size660to680] EQ 1), Age6Size660to680countF)
        age7Size660to680F = WHERE((Age_Gro[Size660to680] EQ 7) AND (Sex_Gro[Size660to680] EQ 1), Age7Size660to680countF)
        age8Size660to680F = WHERE((Age_Gro[Size660to680] EQ 8) AND (Sex_Gro[Size660to680] EQ 1), Age8Size660to680countF)
        age9Size660to680F = WHERE((Age_Gro[Size660to680] EQ 9) AND (Sex_Gro[Size660to680] EQ 1), Age9Size660to680countF)
        age10Size660to680F = WHERE((Age_Gro[Size660to680] EQ 10) AND (Sex_Gro[Size660to680] EQ 1), Age10Size660to680countF)
        age11Size660to680F = WHERE((Age_Gro[Size660to680] EQ 11) AND (Sex_Gro[Size660to680] EQ 1), Age11Size660to680countF)
        AGE12Size660to680F = WHERE((Age_Gro[Size660to680] EQ 12) AND (Sex_Gro[Size660to680] EQ 1), Age12Size660to680countF)
        AGE13Size660to680F = WHERE((Age_Gro[Size660to680] EQ 13) AND (Sex_Gro[Size660to680] EQ 1), Age13Size660to680countF)
        AGE14Size660to680F = WHERE((Age_Gro[Size660to680] EQ 14) AND (Sex_Gro[Size660to680] EQ 1), Age14Size660to680countF)
        AGE15Size660to680F = WHERE((Age_Gro[Size660to680] EQ 15) AND (Sex_Gro[Size660to680] EQ 1), Age15Size660to680countF)
        age16Size660to680F = WHERE((Age_Gro[Size660to680] EQ 16) AND (Sex_Gro[Size660to680] EQ 1), Age16Size660to680countF)
        age17Size660to680F = WHERE((Age_Gro[Size660to680] EQ 17) AND (Sex_Gro[Size660to680] EQ 1), Age17Size660to680countF)
        age18Size660to680F = WHERE((Age_Gro[Size660to680] EQ 18) AND (Sex_Gro[Size660to680] EQ 1), Age18Size660to680countF)
        age19Size660to680F = WHERE((Age_Gro[Size660to680] EQ 19) AND (Sex_Gro[Size660to680] EQ 1), Age19Size660to680countF)
        age20Size660to680F = WHERE((Age_Gro[Size660to680] EQ 20) AND (Sex_Gro[Size660to680] EQ 1), Age20Size660to680countF)
        age21Size660to680F = WHERE((Age_Gro[Size660to680] EQ 21) AND (Sex_Gro[Size660to680] EQ 1), Age21Size660to680countF)
        age22Size660to680F = WHERE((Age_Gro[Size660to680] EQ 22) AND (Sex_Gro[Size660to680] EQ 1), Age22Size660to680countF)
        age23Size660to680F = WHERE((Age_Gro[Size660to680] EQ 23) AND (Sex_Gro[Size660to680] EQ 1), Age23Size660to680countF)
        age24Size660to680F = WHERE((Age_Gro[Size660to680] EQ 24) AND (Sex_Gro[Size660to680] EQ 1), Age24Size660to680countF)
        age25Size660to680F = WHERE((Age_Gro[Size660to680] EQ 25) AND (Sex_Gro[Size660to680] EQ 1), Age25Size660to680countF)
        age26Size660to680F = WHERE((Age_Gro[Size660to680] EQ 26) AND (Sex_Gro[Size660to680] EQ 1), Age26Size660to680countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+29L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+29L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+29L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+29L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+29L] = 660
        WAE_length_bin[75, i*NumLengthBin+adj+29L] = Size660to680countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+29L] = Age0Size660to680countF
        WAE_length_bin[77, i*NumLengthBin+adj+29L] = Age1Size660to680countF
        WAE_length_bin[78, i*NumLengthBin+adj+29L] = Age2Size660to680countF
        WAE_length_bin[79, i*NumLengthBin+adj+29L] = Age3Size660to680countF
        WAE_length_bin[80, i*NumLengthBin+adj+29L] = Age4Size660to680countF
        WAE_length_bin[81, i*NumLengthBin+adj+29L] = Age5Size660to680countF
        WAE_length_bin[82, i*NumLengthBin+adj+29L] = Age6Size660to680countF
        WAE_length_bin[83, i*NumLengthBin+adj+29L] = Age7Size660to680countF
        WAE_length_bin[84, i*NumLengthBin+adj+29L] = Age8Size660to680countF
        WAE_length_bin[85, i*NumLengthBin+adj+29L] = Age9Size660to680countF
        WAE_length_bin[86, i*NumLengthBin+adj+29L] = Age10Size660to680countF
        WAE_length_bin[87, i*NumLengthBin+adj+29L] = Age11Size660to680countF
        WAE_length_bin[88, i*NumLengthBin+adj+29L] = Age12Size660to680countF
        WAE_length_bin[89, i*NumLengthBin+adj+29L] = Age13Size660to680countF
        WAE_length_bin[90, i*NumLengthBin+adj+29L] = Age14Size660to680countF
        WAE_length_bin[91, i*NumLengthBin+adj+29L] = Age15Size660to680countF
        WAE_length_bin[92, i*NumLengthBin+adj+29L] = Age16Size660to680countF
        WAE_length_bin[93, i*NumLengthBin+adj+29L] = Age17Size660to680countF
        WAE_length_bin[94, i*NumLengthBin+adj+29L] = Age18Size660to680countF
        WAE_length_bin[95, i*NumLengthBin+adj+29L] = Age19Size660to680countF
        WAE_length_bin[96, i*NumLengthBin+adj+29L] = Age20Size660to680countF
        WAE_length_bin[97, i*NumLengthBin+adj+29L] = Age21Size660to680countF
        WAE_length_bin[98, i*NumLengthBin+adj+29L] = Age22Size660to680countF
        WAE_length_bin[99, i*NumLengthBin+adj+29L] = Age23Size660to680countF
        WAE_length_bin[100, i*NumLengthBin+adj+29L] = Age24Size660to680countF
        WAE_length_bin[101, i*NumLengthBin+adj+29L] = Age25Size660to680countF
        WAE_length_bin[102, i*NumLengthBin+adj+29L] = Age26Size660to680countF
      ENDIF
      PRINT, 'Size660to680F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+29L])
      
      ; length bin 31
      IF Size680to700count GT 0 THEN BEGIN
        age0Size680to700F = WHERE((Age_Gro[Size680to700] EQ 0) AND (Sex_Gro[Size680to700] EQ 1), Age0Size680to700countF)
        age1Size680to700F = WHERE((Age_Gro[Size680to700] EQ 1) AND (Sex_Gro[Size680to700] EQ 1), Age1Size680to700countF)
        age2Size680to700F = WHERE((Age_Gro[Size680to700] EQ 2) AND (Sex_Gro[Size680to700] EQ 1), Age2Size680to700countF)
        age3Size680to700F = WHERE((Age_Gro[Size680to700] EQ 3) AND (Sex_Gro[Size680to700] EQ 1), Age3Size680to700countF)
        age4Size680to700F = WHERE((Age_Gro[Size680to700] EQ 4) AND (Sex_Gro[Size680to700] EQ 1), Age4Size680to700countF)
        age5Size680to700F = WHERE((Age_Gro[Size680to700] EQ 5) AND (Sex_Gro[Size680to700] EQ 1), Age5Size680to700countF)
        age6Size680to700F = WHERE((Age_Gro[Size680to700] EQ 6) AND (Sex_Gro[Size680to700] EQ 1), Age6Size680to700countF)
        age7Size680to700F = WHERE((Age_Gro[Size680to700] EQ 7) AND (Sex_Gro[Size680to700] EQ 1), Age7Size680to700countF)
        age8Size680to700F = WHERE((Age_Gro[Size680to700] EQ 8) AND (Sex_Gro[Size680to700] EQ 1), Age8Size680to700countF)
        age9Size680to700F = WHERE((Age_Gro[Size680to700] EQ 9) AND (Sex_Gro[Size680to700] EQ 1), Age9Size680to700countF)
        age10Size680to700F = WHERE((Age_Gro[Size680to700] EQ 10) AND (Sex_Gro[Size680to700] EQ 1), Age10Size680to700countF)
        age11Size680to700F = WHERE((Age_Gro[Size680to700] EQ 11) AND (Sex_Gro[Size680to700] EQ 1), Age11Size680to700countF)
        AGE12Size680to700F = WHERE((Age_Gro[Size680to700] EQ 12) AND (Sex_Gro[Size680to700] EQ 1), Age12Size680to700countF)
        AGE13Size680to700F = WHERE((Age_Gro[Size680to700] EQ 13) AND (Sex_Gro[Size680to700] EQ 1), Age13Size680to700countF)
        AGE14Size680to700F = WHERE((Age_Gro[Size680to700] EQ 14) AND (Sex_Gro[Size680to700] EQ 1), Age14Size680to700countF)
        AGE15Size680to700F = WHERE((Age_Gro[Size680to700] EQ 15) AND (Sex_Gro[Size680to700] EQ 1), Age15Size680to700countF)
        age16Size680to700F = WHERE((Age_Gro[Size680to700] EQ 16) AND (Sex_Gro[Size680to700] EQ 1), Age16Size680to700countF)
        age17Size680to700F = WHERE((Age_Gro[Size680to700] EQ 17) AND (Sex_Gro[Size680to700] EQ 1), Age17Size680to700countF)
        age18Size680to700F = WHERE((Age_Gro[Size680to700] EQ 18) AND (Sex_Gro[Size680to700] EQ 1), Age18Size680to700countF)
        age19Size680to700F = WHERE((Age_Gro[Size680to700] EQ 19) AND (Sex_Gro[Size680to700] EQ 1), Age19Size680to700countF)
        age20Size680to700F = WHERE((Age_Gro[Size680to700] EQ 20) AND (Sex_Gro[Size680to700] EQ 1), Age20Size680to700countF)
        age21Size680to700F = WHERE((Age_Gro[Size680to700] EQ 21) AND (Sex_Gro[Size680to700] EQ 1), Age21Size680to700countF)
        age22Size680to700F = WHERE((Age_Gro[Size680to700] EQ 22) AND (Sex_Gro[Size680to700] EQ 1), Age22Size680to700countF)
        age23Size680to700F = WHERE((Age_Gro[Size680to700] EQ 23) AND (Sex_Gro[Size680to700] EQ 1), Age23Size680to700countF)
        age24Size680to700F = WHERE((Age_Gro[Size680to700] EQ 24) AND (Sex_Gro[Size680to700] EQ 1), Age24Size680to700countF)
        age25Size680to700F = WHERE((Age_Gro[Size680to700] EQ 25) AND (Sex_Gro[Size680to700] EQ 1), Age25Size680to700countF)
        age26Size680to700F = WHERE((Age_Gro[Size680to700] EQ 26) AND (Sex_Gro[Size680to700] EQ 1), Age26Size680to700countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+30L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+30L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+30L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+30L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+30L] = 680
        WAE_length_bin[75, i*NumLengthBin+adj+30L] = Size680to700countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+30L] = Age0Size680to700countF
        WAE_length_bin[77, i*NumLengthBin+adj+30L] = Age1Size680to700countF
        WAE_length_bin[78, i*NumLengthBin+adj+30L] = Age2Size680to700countF
        WAE_length_bin[79, i*NumLengthBin+adj+30L] = Age3Size680to700countF
        WAE_length_bin[80, i*NumLengthBin+adj+30L] = Age4Size680to700countF
        WAE_length_bin[81, i*NumLengthBin+adj+30L] = Age5Size680to700countF
        WAE_length_bin[82, i*NumLengthBin+adj+30L] = Age6Size680to700countF
        WAE_length_bin[83, i*NumLengthBin+adj+30L] = Age7Size680to700countF
        WAE_length_bin[84, i*NumLengthBin+adj+30L] = Age8Size680to700countF
        WAE_length_bin[85, i*NumLengthBin+adj+30L] = Age9Size680to700countF
        WAE_length_bin[86, i*NumLengthBin+adj+30L] = Age10Size680to700countF
        WAE_length_bin[87, i*NumLengthBin+adj+30L] = Age11Size680to700countF
        WAE_length_bin[88, i*NumLengthBin+adj+30L] = Age12Size680to700countF
        WAE_length_bin[89, i*NumLengthBin+adj+30L] = Age13Size680to700countF
        WAE_length_bin[90, i*NumLengthBin+adj+30L] = Age14Size680to700countF
        WAE_length_bin[91, i*NumLengthBin+adj+30L] = Age15Size680to700countF
        WAE_length_bin[92, i*NumLengthBin+adj+30L] = Age16Size680to700countF
        WAE_length_bin[93, i*NumLengthBin+adj+30L] = Age17Size680to700countF
        WAE_length_bin[94, i*NumLengthBin+adj+30L] = Age18Size680to700countF
        WAE_length_bin[95, i*NumLengthBin+adj+30L] = Age19Size680to700countF
        WAE_length_bin[96, i*NumLengthBin+adj+30L] = Age20Size680to700countF
        WAE_length_bin[97, i*NumLengthBin+adj+30L] = Age21Size680to700countF
        WAE_length_bin[98, i*NumLengthBin+adj+30L] = Age22Size680to700countF
        WAE_length_bin[99, i*NumLengthBin+adj+30L] = Age23Size680to700countF
        WAE_length_bin[100, i*NumLengthBin+adj+30L] = Age24Size680to700countF
        WAE_length_bin[101, i*NumLengthBin+adj+30L] = Age25Size680to700countF
        WAE_length_bin[102, i*NumLengthBin+adj+30L] = Age26Size680to700countF
      ENDIF
      PRINT, 'Size680to700F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+30L])
      
      ; length bin 32
      IF Size700to720count GT 0 THEN BEGIN
        age0Size700to720F = WHERE((Age_Gro[Size700to720] EQ 0) AND (Sex_Gro[Size700to720] EQ 1), Age0Size700to720countF)
        age1Size700to720F = WHERE((Age_Gro[Size700to720] EQ 1) AND (Sex_Gro[Size700to720] EQ 1), Age1Size700to720countF)
        age2Size700to720F = WHERE((Age_Gro[Size700to720] EQ 2) AND (Sex_Gro[Size700to720] EQ 1), Age2Size700to720countF)
        age3Size700to720F = WHERE((Age_Gro[Size700to720] EQ 3) AND (Sex_Gro[Size700to720] EQ 1), Age3Size700to720countF)
        age4Size700to720F = WHERE((Age_Gro[Size700to720] EQ 4) AND (Sex_Gro[Size700to720] EQ 1), Age4Size700to720countF)
        age5Size700to720F = WHERE((Age_Gro[Size700to720] EQ 5) AND (Sex_Gro[Size700to720] EQ 1), Age5Size700to720countF)
        age6Size700to720F = WHERE((Age_Gro[Size700to720] EQ 6) AND (Sex_Gro[Size700to720] EQ 1), Age6Size700to720countF)
        age7Size700to720F = WHERE((Age_Gro[Size700to720] EQ 7) AND (Sex_Gro[Size700to720] EQ 1), Age7Size700to720countF)
        age8Size700to720F = WHERE((Age_Gro[Size700to720] EQ 8) AND (Sex_Gro[Size700to720] EQ 1), Age8Size700to720countF)
        age9Size700to720F = WHERE((Age_Gro[Size700to720] EQ 9) AND (Sex_Gro[Size700to720] EQ 1), Age9Size700to720countF)
        age10Size700to720F = WHERE((Age_Gro[Size700to720] EQ 10) AND (Sex_Gro[Size700to720] EQ 1), Age10Size700to720countF)
        age11Size700to720F = WHERE((Age_Gro[Size700to720] EQ 11) AND (Sex_Gro[Size700to720] EQ 1), Age11Size700to720countF)
        AGE12Size700to720F = WHERE((Age_Gro[Size700to720] EQ 12) AND (Sex_Gro[Size700to720] EQ 1), Age12Size700to720countF)
        AGE13Size700to720F = WHERE((Age_Gro[Size700to720] EQ 13) AND (Sex_Gro[Size700to720] EQ 1), Age13Size700to720countF)
        AGE14Size700to720F = WHERE((Age_Gro[Size700to720] EQ 14) AND (Sex_Gro[Size700to720] EQ 1), Age14Size700to720countF)
        AGE15Size700to720F = WHERE((Age_Gro[Size700to720] EQ 15) AND (Sex_Gro[Size700to720] EQ 1), Age15Size700to720countF)
        age16Size700to720F = WHERE((Age_Gro[Size700to720] EQ 16) AND (Sex_Gro[Size700to720] EQ 1), Age16Size700to720countF)
        age17Size700to720F = WHERE((Age_Gro[Size700to720] EQ 17) AND (Sex_Gro[Size700to720] EQ 1), Age17Size700to720countF)
        age18Size700to720F = WHERE((Age_Gro[Size700to720] EQ 18) AND (Sex_Gro[Size700to720] EQ 1), Age18Size700to720countF)
        age19Size700to720F = WHERE((Age_Gro[Size700to720] EQ 19) AND (Sex_Gro[Size700to720] EQ 1), Age19Size700to720countF)
        age20Size700to720F = WHERE((Age_Gro[Size700to720] EQ 20) AND (Sex_Gro[Size700to720] EQ 1), Age20Size700to720countF)
        age21Size700to720F = WHERE((Age_Gro[Size700to720] EQ 21) AND (Sex_Gro[Size700to720] EQ 1), Age21Size700to720countF)
        age22Size700to720F = WHERE((Age_Gro[Size700to720] EQ 22) AND (Sex_Gro[Size700to720] EQ 1), Age22Size700to720countF)
        age23Size700to720F = WHERE((Age_Gro[Size700to720] EQ 23) AND (Sex_Gro[Size700to720] EQ 1), Age23Size700to720countF)
        age24Size700to720F = WHERE((Age_Gro[Size700to720] EQ 24) AND (Sex_Gro[Size700to720] EQ 1), Age24Size700to720countF)
        age25Size700to720F = WHERE((Age_Gro[Size700to720] EQ 25) AND (Sex_Gro[Size700to720] EQ 1), Age25Size700to720countF)
        age26Size700to720F = WHERE((Age_Gro[Size700to720] EQ 26) AND (Sex_Gro[Size700to720] EQ 1), Age26Size700to720countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+31L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+31L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+31L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+31L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+31L] = 700
        WAE_length_bin[75, i*NumLengthBin+adj+31L] = Size700to720countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+31L] = Age0Size700to720countF
        WAE_length_bin[77, i*NumLengthBin+adj+31L] = Age1Size700to720countF
        WAE_length_bin[78, i*NumLengthBin+adj+31L] = Age2Size700to720countF
        WAE_length_bin[79, i*NumLengthBin+adj+31L] = Age3Size700to720countF
        WAE_length_bin[80, i*NumLengthBin+adj+31L] = Age4Size700to720countF
        WAE_length_bin[81, i*NumLengthBin+adj+31L] = Age5Size700to720countF
        WAE_length_bin[82, i*NumLengthBin+adj+31L] = Age6Size700to720countF
        WAE_length_bin[83, i*NumLengthBin+adj+31L] = Age7Size700to720countF
        WAE_length_bin[84, i*NumLengthBin+adj+31L] = Age8Size700to720countF
        WAE_length_bin[85, i*NumLengthBin+adj+31L] = Age9Size700to720countF
        WAE_length_bin[86, i*NumLengthBin+adj+31L] = Age10Size700to720countF
        WAE_length_bin[87, i*NumLengthBin+adj+31L] = Age11Size700to720countF
        WAE_length_bin[88, i*NumLengthBin+adj+31L] = Age12Size700to720countF
        WAE_length_bin[89, i*NumLengthBin+adj+31L] = Age13Size700to720countF
        WAE_length_bin[90, i*NumLengthBin+adj+31L] = Age14Size700to720countF
        WAE_length_bin[91, i*NumLengthBin+adj+31L] = Age15Size700to720countF
        WAE_length_bin[92, i*NumLengthBin+adj+31L] = Age16Size700to720countF
        WAE_length_bin[93, i*NumLengthBin+adj+31L] = Age17Size700to720countF
        WAE_length_bin[94, i*NumLengthBin+adj+31L] = Age18Size700to720countF
        WAE_length_bin[95, i*NumLengthBin+adj+31L] = Age19Size700to720countF
        WAE_length_bin[96, i*NumLengthBin+adj+31L] = Age20Size700to720countF
        WAE_length_bin[97, i*NumLengthBin+adj+31L] = Age21Size700to720countF
        WAE_length_bin[98, i*NumLengthBin+adj+31L] = Age22Size700to720countF
        WAE_length_bin[99, i*NumLengthBin+adj+31L] = Age23Size700to720countF
        WAE_length_bin[100, i*NumLengthBin+adj+31L] = Age24Size700to720countF
        WAE_length_bin[101, i*NumLengthBin+adj+31L] = Age25Size700to720countF
        WAE_length_bin[102, i*NumLengthBin+adj+31L] = Age26Size700to720countF
      ENDIF
      PRINT, 'Size700to720F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+31L])
      
      ; length bin 33
      IF Size720to740count GT 0 THEN BEGIN
        age0Size720to740F = WHERE((Age_Gro[Size720to740] EQ 0) AND (Sex_Gro[Size720to740] EQ 1), Age0Size720to740countF)
        age1Size720to740F = WHERE((Age_Gro[Size720to740] EQ 1) AND (Sex_Gro[Size720to740] EQ 1), Age1Size720to740countF)
        age2Size720to740F = WHERE((Age_Gro[Size720to740] EQ 2) AND (Sex_Gro[Size720to740] EQ 1), Age2Size720to740countF)
        age3Size720to740F = WHERE((Age_Gro[Size720to740] EQ 3) AND (Sex_Gro[Size720to740] EQ 1), Age3Size720to740countF)
        age4Size720to740F = WHERE((Age_Gro[Size720to740] EQ 4) AND (Sex_Gro[Size720to740] EQ 1), Age4Size720to740countF)
        age5Size720to740F = WHERE((Age_Gro[Size720to740] EQ 5) AND (Sex_Gro[Size720to740] EQ 1), Age5Size720to740countF)
        age6Size720to740F = WHERE((Age_Gro[Size720to740] EQ 6) AND (Sex_Gro[Size720to740] EQ 1), Age6Size720to740countF)
        age7Size720to740F = WHERE((Age_Gro[Size720to740] EQ 7) AND (Sex_Gro[Size720to740] EQ 1), Age7Size720to740countF)
        age8Size720to740F = WHERE((Age_Gro[Size720to740] EQ 8) AND (Sex_Gro[Size720to740] EQ 1), Age8Size720to740countF)
        age9Size720to740F = WHERE((Age_Gro[Size720to740] EQ 9) AND (Sex_Gro[Size720to740] EQ 1), Age9Size720to740countF)
        age10Size720to740F = WHERE((Age_Gro[Size720to740] EQ 10) AND (Sex_Gro[Size720to740] EQ 1), Age10Size720to740countF)
        age11Size720to740F = WHERE((Age_Gro[Size720to740] EQ 11) AND (Sex_Gro[Size720to740] EQ 1), Age11Size720to740countF)
        AGE12Size720to740F = WHERE((Age_Gro[Size720to740] EQ 12) AND (Sex_Gro[Size720to740] EQ 1), Age12Size720to740countF)
        AGE13Size720to740F = WHERE((Age_Gro[Size720to740] EQ 13) AND (Sex_Gro[Size720to740] EQ 1), Age13Size720to740countF)
        AGE14Size720to740F = WHERE((Age_Gro[Size720to740] EQ 14) AND (Sex_Gro[Size720to740] EQ 1), Age14Size720to740countF)
        AGE15Size720to740F = WHERE((Age_Gro[Size720to740] EQ 15) AND (Sex_Gro[Size720to740] EQ 1), Age15Size720to740countF)
        age16Size720to740F = WHERE((Age_Gro[Size720to740] EQ 16) AND (Sex_Gro[Size720to740] EQ 1), Age16Size720to740countF)
        age17Size720to740F = WHERE((Age_Gro[Size720to740] EQ 17) AND (Sex_Gro[Size720to740] EQ 1), Age17Size720to740countF)
        age18Size720to740F = WHERE((Age_Gro[Size720to740] EQ 18) AND (Sex_Gro[Size720to740] EQ 1), Age18Size720to740countF)
        age19Size720to740F = WHERE((Age_Gro[Size720to740] EQ 19) AND (Sex_Gro[Size720to740] EQ 1), Age19Size720to740countF)
        age20Size720to740F = WHERE((Age_Gro[Size720to740] EQ 20) AND (Sex_Gro[Size720to740] EQ 1), Age20Size720to740countF)
        age21Size720to740F = WHERE((Age_Gro[Size720to740] EQ 21) AND (Sex_Gro[Size720to740] EQ 1), Age21Size720to740countF)
        age22Size720to740F = WHERE((Age_Gro[Size720to740] EQ 22) AND (Sex_Gro[Size720to740] EQ 1), Age22Size720to740countF)
        age23Size720to740F = WHERE((Age_Gro[Size720to740] EQ 23) AND (Sex_Gro[Size720to740] EQ 1), Age23Size720to740countF)
        age24Size720to740F = WHERE((Age_Gro[Size720to740] EQ 24) AND (Sex_Gro[Size720to740] EQ 1), Age24Size720to740countF)
        age25Size720to740F = WHERE((Age_Gro[Size720to740] EQ 25) AND (Sex_Gro[Size720to740] EQ 1), Age25Size720to740countF)
        age26Size720to740F = WHERE((Age_Gro[Size720to740] EQ 26) AND (Sex_Gro[Size720to740] EQ 1), Age26Size720to740countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+32L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+32L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+32L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+32L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+32L] = 720
        WAE_length_bin[75, i*NumLengthBin+adj+32L] = Size720to740countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+32L] = Age0Size720to740countF
        WAE_length_bin[77, i*NumLengthBin+adj+32L] = Age1Size720to740countF
        WAE_length_bin[78, i*NumLengthBin+adj+32L] = Age2Size720to740countF
        WAE_length_bin[79, i*NumLengthBin+adj+32L] = Age3Size720to740countF
        WAE_length_bin[80, i*NumLengthBin+adj+32L] = Age4Size720to740countF
        WAE_length_bin[81, i*NumLengthBin+adj+32L] = Age5Size720to740countF
        WAE_length_bin[82, i*NumLengthBin+adj+32L] = Age6Size720to740countF
        WAE_length_bin[83, i*NumLengthBin+adj+32L] = Age7Size720to740countF
        WAE_length_bin[84, i*NumLengthBin+adj+32L] = Age8Size720to740countF
        WAE_length_bin[85, i*NumLengthBin+adj+32L] = Age9Size720to740countF
        WAE_length_bin[86, i*NumLengthBin+adj+32L] = Age10Size720to740countF
        WAE_length_bin[87, i*NumLengthBin+adj+32L] = Age11Size720to740countF
        WAE_length_bin[88, i*NumLengthBin+adj+32L] = Age12Size720to740countF
        WAE_length_bin[89, i*NumLengthBin+adj+32L] = Age13Size720to740countF
        WAE_length_bin[90, i*NumLengthBin+adj+32L] = Age14Size720to740countF
        WAE_length_bin[91, i*NumLengthBin+adj+32L] = Age15Size720to740countF
        WAE_length_bin[92, i*NumLengthBin+adj+32L] = Age16Size720to740countF
        WAE_length_bin[93, i*NumLengthBin+adj+32L] = Age17Size720to740countF
        WAE_length_bin[94, i*NumLengthBin+adj+32L] = Age18Size720to740countF
        WAE_length_bin[95, i*NumLengthBin+adj+32L] = Age19Size720to740countF
        WAE_length_bin[96, i*NumLengthBin+adj+32L] = Age20Size720to740countF
        WAE_length_bin[97, i*NumLengthBin+adj+32L] = Age21Size720to740countF
        WAE_length_bin[98, i*NumLengthBin+adj+32L] = Age22Size720to740countF
        WAE_length_bin[99, i*NumLengthBin+adj+32L] = Age23Size720to740countF
        WAE_length_bin[100, i*NumLengthBin+adj+32L] = Age24Size720to740countF
        WAE_length_bin[101, i*NumLengthBin+adj+32L] = Age25Size720to740countF
        WAE_length_bin[102, i*NumLengthBin+adj+32L] = Age26Size720to740countF
      ENDIF
      PRINT, 'Size720to740F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+32L])
      
      ; length bin 34
      IF Size740to760count GT 0 THEN BEGIN
        age0Size740to760F = WHERE((Age_Gro[Size740to760] EQ 0) AND (Sex_Gro[Size740to760] EQ 1), Age0Size740to760countF)
        age1Size740to760F = WHERE((Age_Gro[Size740to760] EQ 1) AND (Sex_Gro[Size740to760] EQ 1), Age1Size740to760countF)
        age2Size740to760F = WHERE((Age_Gro[Size740to760] EQ 2) AND (Sex_Gro[Size740to760] EQ 1), Age2Size740to760countF)
        age3Size740to760F = WHERE((Age_Gro[Size740to760] EQ 3) AND (Sex_Gro[Size740to760] EQ 1), Age3Size740to760countF)
        age4Size740to760F = WHERE((Age_Gro[Size740to760] EQ 4) AND (Sex_Gro[Size740to760] EQ 1), Age4Size740to760countF)
        age5Size740to760F = WHERE((Age_Gro[Size740to760] EQ 5) AND (Sex_Gro[Size740to760] EQ 1), Age5Size740to760countF)
        age6Size740to760F = WHERE((Age_Gro[Size740to760] EQ 6) AND (Sex_Gro[Size740to760] EQ 1), Age6Size740to760countF)
        age7Size740to760F = WHERE((Age_Gro[Size740to760] EQ 7) AND (Sex_Gro[Size740to760] EQ 1), Age7Size740to760countF)
        age8Size740to760F = WHERE((Age_Gro[Size740to760] EQ 8) AND (Sex_Gro[Size740to760] EQ 1), Age8Size740to760countF)
        age9Size740to760F = WHERE((Age_Gro[Size740to760] EQ 9) AND (Sex_Gro[Size740to760] EQ 1), Age9Size740to760countF)
        age10Size740to760F = WHERE((Age_Gro[Size740to760] EQ 10) AND (Sex_Gro[Size740to760] EQ 1), Age10Size740to760countF)
        age11Size740to760F = WHERE((Age_Gro[Size740to760] EQ 11) AND (Sex_Gro[Size740to760] EQ 1), Age11Size740to760countF)
        AGE12Size740to760F = WHERE((Age_Gro[Size740to760] EQ 12) AND (Sex_Gro[Size740to760] EQ 1), Age12Size740to760countF)
        AGE13Size740to760F = WHERE((Age_Gro[Size740to760] EQ 13) AND (Sex_Gro[Size740to760] EQ 1), Age13Size740to760countF)
        AGE14Size740to760F = WHERE((Age_Gro[Size740to760] EQ 14) AND (Sex_Gro[Size740to760] EQ 1), Age14Size740to760countF)
        AGE15Size740to760F = WHERE((Age_Gro[Size740to760] EQ 15) AND (Sex_Gro[Size740to760] EQ 1), Age15Size740to760countF)
        age16Size740to760F = WHERE((Age_Gro[Size740to760] EQ 16) AND (Sex_Gro[Size740to760] EQ 1), Age16Size740to760countF)
        age17Size740to760F = WHERE((Age_Gro[Size740to760] EQ 17) AND (Sex_Gro[Size740to760] EQ 1), Age17Size740to760countF)
        age18Size740to760F = WHERE((Age_Gro[Size740to760] EQ 18) AND (Sex_Gro[Size740to760] EQ 1), Age18Size740to760countF)
        age19Size740to760F = WHERE((Age_Gro[Size740to760] EQ 19) AND (Sex_Gro[Size740to760] EQ 1), Age19Size740to760countF)
        age20Size740to760F = WHERE((Age_Gro[Size740to760] EQ 20) AND (Sex_Gro[Size740to760] EQ 1), Age20Size740to760countF)
        age21Size740to760F = WHERE((Age_Gro[Size740to760] EQ 21) AND (Sex_Gro[Size740to760] EQ 1), Age21Size740to760countF)
        age22Size740to760F = WHERE((Age_Gro[Size740to760] EQ 22) AND (Sex_Gro[Size740to760] EQ 1), Age22Size740to760countF)
        age23Size740to760F = WHERE((Age_Gro[Size740to760] EQ 23) AND (Sex_Gro[Size740to760] EQ 1), Age23Size740to760countF)
        age24Size740to760F = WHERE((Age_Gro[Size740to760] EQ 24) AND (Sex_Gro[Size740to760] EQ 1), Age24Size740to760countF)
        age25Size740to760F = WHERE((Age_Gro[Size740to760] EQ 25) AND (Sex_Gro[Size740to760] EQ 1), Age25Size740to760countF)
        age26Size740to760F = WHERE((Age_Gro[Size740to760] EQ 26) AND (Sex_Gro[Size740to760] EQ 1), Age26Size740to760countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+33L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+33L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+33L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+33L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+33L] = 740
        WAE_length_bin[75, i*NumLengthBin+adj+33L] = Size740to760countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+33L] = Age0Size740to760countF
        WAE_length_bin[77, i*NumLengthBin+adj+33L] = Age1Size740to760countF
        WAE_length_bin[78, i*NumLengthBin+adj+33L] = Age2Size740to760countF
        WAE_length_bin[79, i*NumLengthBin+adj+33L] = Age3Size740to760countF
        WAE_length_bin[80, i*NumLengthBin+adj+33L] = Age4Size740to760countF
        WAE_length_bin[81, i*NumLengthBin+adj+33L] = Age5Size740to760countF
        WAE_length_bin[82, i*NumLengthBin+adj+33L] = Age6Size740to760countF
        WAE_length_bin[83, i*NumLengthBin+adj+33L] = Age7Size740to760countF
        WAE_length_bin[84, i*NumLengthBin+adj+33L] = Age8Size740to760countF
        WAE_length_bin[85, i*NumLengthBin+adj+33L] = Age9Size740to760countF
        WAE_length_bin[86, i*NumLengthBin+adj+33L] = Age10Size740to760countF
        WAE_length_bin[87, i*NumLengthBin+adj+33L] = Age11Size740to760countF
        WAE_length_bin[88, i*NumLengthBin+adj+33L] = Age12Size740to760countF
        WAE_length_bin[89, i*NumLengthBin+adj+33L] = Age13Size740to760countF
        WAE_length_bin[90, i*NumLengthBin+adj+33L] = Age14Size740to760countF
        WAE_length_bin[91, i*NumLengthBin+adj+33L] = Age15Size740to760countF
        WAE_length_bin[92, i*NumLengthBin+adj+33L] = Age16Size740to760countF
        WAE_length_bin[93, i*NumLengthBin+adj+33L] = Age17Size740to760countF
        WAE_length_bin[94, i*NumLengthBin+adj+33L] = Age18Size740to760countF
        WAE_length_bin[95, i*NumLengthBin+adj+33L] = Age19Size740to760countF
        WAE_length_bin[96, i*NumLengthBin+adj+33L] = Age20Size740to760countF
        WAE_length_bin[97, i*NumLengthBin+adj+33L] = Age21Size740to760countF
        WAE_length_bin[98, i*NumLengthBin+adj+33L] = Age22Size740to760countF
        WAE_length_bin[99, i*NumLengthBin+adj+33L] = Age23Size740to760countF
        WAE_length_bin[100, i*NumLengthBin+adj+33L] = Age24Size740to760countF
        WAE_length_bin[101, i*NumLengthBin+adj+33L] = Age25Size740to760countF
        WAE_length_bin[102, i*NumLengthBin+adj+33L] = Age26Size740to760countF
      ENDIF
      PRINT, 'Size740to760F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+33L])
      
      ; legnth bin 35
      IF Size760to780count GT 0 THEN BEGIN
        age0Size760to780F = WHERE((Age_Gro[Size760to780] EQ 0) AND (Sex_Gro[Size760to780] EQ 1), Age0Size760to780countF)
        age1Size760to780F = WHERE((Age_Gro[Size760to780] EQ 1) AND (Sex_Gro[Size760to780] EQ 1), Age1Size760to780countF)
        age2Size760to780F = WHERE((Age_Gro[Size760to780] EQ 2) AND (Sex_Gro[Size760to780] EQ 1), Age2Size760to780countF)
        age3Size760to780F = WHERE((Age_Gro[Size760to780] EQ 3) AND (Sex_Gro[Size760to780] EQ 1), Age3Size760to780countF)
        age4Size760to780F = WHERE((Age_Gro[Size760to780] EQ 4) AND (Sex_Gro[Size760to780] EQ 1), Age4Size760to780countF)
        age5Size760to780F = WHERE((Age_Gro[Size760to780] EQ 5) AND (Sex_Gro[Size760to780] EQ 1), Age5Size760to780countF)
        age6Size760to780F = WHERE((Age_Gro[Size760to780] EQ 6) AND (Sex_Gro[Size760to780] EQ 1), Age6Size760to780countF)
        age7Size760to780F = WHERE((Age_Gro[Size760to780] EQ 7) AND (Sex_Gro[Size760to780] EQ 1), Age7Size760to780countF)
        age8Size760to780F = WHERE((Age_Gro[Size760to780] EQ 8) AND (Sex_Gro[Size760to780] EQ 1), Age8Size760to780countF)
        age9Size760to780F = WHERE((Age_Gro[Size760to780] EQ 9) AND (Sex_Gro[Size760to780] EQ 1), Age9Size760to780countF)
        age10Size760to780F = WHERE((Age_Gro[Size760to780] EQ 10) AND (Sex_Gro[Size760to780] EQ 1), Age10Size760to780countF)
        age11Size760to780F = WHERE((Age_Gro[Size760to780] EQ 11) AND (Sex_Gro[Size760to780] EQ 1), Age11Size760to780countF)
        AGE12Size760to780F = WHERE((Age_Gro[Size760to780] EQ 12) AND (Sex_Gro[Size760to780] EQ 1), Age12Size760to780countF)
        AGE13Size760to780F = WHERE((Age_Gro[Size760to780] EQ 13) AND (Sex_Gro[Size760to780] EQ 1), Age13Size760to780countF)
        AGE14Size760to780F = WHERE((Age_Gro[Size760to780] EQ 14) AND (Sex_Gro[Size760to780] EQ 1), Age14Size760to780countF)
        AGE15Size760to780F = WHERE((Age_Gro[Size760to780] EQ 15) AND (Sex_Gro[Size760to780] EQ 1), Age15Size760to780countF)
        age16Size760to780F = WHERE((Age_Gro[Size760to780] EQ 16) AND (Sex_Gro[Size760to780] EQ 1), Age16Size760to780countF)
        age17Size760to780F = WHERE((Age_Gro[Size760to780] EQ 17) AND (Sex_Gro[Size760to780] EQ 1), Age17Size760to780countF)
        age18Size760to780F = WHERE((Age_Gro[Size760to780] EQ 18) AND (Sex_Gro[Size760to780] EQ 1), Age18Size760to780countF)
        age19Size760to780F = WHERE((Age_Gro[Size760to780] EQ 19) AND (Sex_Gro[Size760to780] EQ 1), Age19Size760to780countF)
        age20Size760to780F = WHERE((Age_Gro[Size760to780] EQ 20) AND (Sex_Gro[Size760to780] EQ 1), Age20Size760to780countF)
        age21Size760to780F = WHERE((Age_Gro[Size760to780] EQ 21) AND (Sex_Gro[Size760to780] EQ 1), Age21Size760to780countF)
        age22Size760to780F = WHERE((Age_Gro[Size760to780] EQ 22) AND (Sex_Gro[Size760to780] EQ 1), Age22Size760to780countF)
        age23Size760to780F = WHERE((Age_Gro[Size760to780] EQ 23) AND (Sex_Gro[Size760to780] EQ 1), Age23Size760to780countF)
        age24Size760to780F = WHERE((Age_Gro[Size760to780] EQ 24) AND (Sex_Gro[Size760to780] EQ 1), Age24Size760to780countF)
        age25Size760to780F = WHERE((Age_Gro[Size760to780] EQ 25) AND (Sex_Gro[Size760to780] EQ 1), Age25Size760to780countF)
        age26Size760to780F = WHERE((Age_Gro[Size760to780] EQ 26) AND (Sex_Gro[Size760to780] EQ 1), Age26Size760to780countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+34L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+34L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+34L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+34L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+34L] = 760
        WAE_length_bin[75, i*NumLengthBin+adj+34L] = Size760to780countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+34L] = Age0Size760to780countF
        WAE_length_bin[77, i*NumLengthBin+adj+34L] = Age1Size760to780countF
        WAE_length_bin[78, i*NumLengthBin+adj+34L] = Age2Size760to780countF
        WAE_length_bin[79, i*NumLengthBin+adj+34L] = Age3Size760to780countF
        WAE_length_bin[80, i*NumLengthBin+adj+34L] = Age4Size760to780countF
        WAE_length_bin[81, i*NumLengthBin+adj+34L] = Age5Size760to780countF
        WAE_length_bin[82, i*NumLengthBin+adj+34L] = Age6Size760to780countF
        WAE_length_bin[83, i*NumLengthBin+adj+34L] = Age7Size760to780countF
        WAE_length_bin[84, i*NumLengthBin+adj+34L] = Age8Size760to780countF
        WAE_length_bin[85, i*NumLengthBin+adj+34L] = Age9Size760to780countF
        WAE_length_bin[86, i*NumLengthBin+adj+34L] = Age10Size760to780countF
        WAE_length_bin[87, i*NumLengthBin+adj+34L] = Age11Size760to780countF
        WAE_length_bin[88, i*NumLengthBin+adj+34L] = Age12Size760to780countF
        WAE_length_bin[89, i*NumLengthBin+adj+34L] = Age13Size760to780countF
        WAE_length_bin[90, i*NumLengthBin+adj+34L] = Age14Size760to780countF
        WAE_length_bin[91, i*NumLengthBin+adj+34L] = Age15Size760to780countF
        WAE_length_bin[92, i*NumLengthBin+adj+34L] = Age16Size760to780countF
        WAE_length_bin[93, i*NumLengthBin+adj+34L] = Age17Size760to780countF
        WAE_length_bin[94, i*NumLengthBin+adj+34L] = Age18Size760to780countF
        WAE_length_bin[95, i*NumLengthBin+adj+34L] = Age19Size760to780countF
        WAE_length_bin[96, i*NumLengthBin+adj+34L] = Age20Size760to780countF
        WAE_length_bin[97, i*NumLengthBin+adj+34L] = Age21Size760to780countF
        WAE_length_bin[98, i*NumLengthBin+adj+34L] = Age22Size760to780countF
        WAE_length_bin[99, i*NumLengthBin+adj+34L] = Age23Size760to780countF
        WAE_length_bin[100, i*NumLengthBin+adj+34L] = Age24Size760to780countF
        WAE_length_bin[101, i*NumLengthBin+adj+34L] = Age25Size760to780countF
        WAE_length_bin[102, i*NumLengthBin+adj+34L] = Age26Size760to780countF
      ENDIF
      PRINT, 'Size760to780F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+34L])
      
      ; length bin 36
      IF Size780to800count GT 0 THEN BEGIN
        age0Size780to800F = WHERE((Age_Gro[Size780to800] EQ 0) AND (Sex_Gro[Size780to800] EQ 1), Age0Size780to800countF)
        age1Size780to800F = WHERE((Age_Gro[Size780to800] EQ 1) AND (Sex_Gro[Size780to800] EQ 1), Age1Size780to800countF)
        age2Size780to800F = WHERE((Age_Gro[Size780to800] EQ 2) AND (Sex_Gro[Size780to800] EQ 1), Age2Size780to800countF)
        age3Size780to800F = WHERE((Age_Gro[Size780to800] EQ 3) AND (Sex_Gro[Size780to800] EQ 1), Age3Size780to800countF)
        age4Size780to800F = WHERE((Age_Gro[Size780to800] EQ 4) AND (Sex_Gro[Size780to800] EQ 1), Age4Size780to800countF)
        age5Size780to800F = WHERE((Age_Gro[Size780to800] EQ 5) AND (Sex_Gro[Size780to800] EQ 1), Age5Size780to800countF)
        age6Size780to800F = WHERE((Age_Gro[Size780to800] EQ 6) AND (Sex_Gro[Size780to800] EQ 1), Age6Size780to800countF)
        age7Size780to800F = WHERE((Age_Gro[Size780to800] EQ 7) AND (Sex_Gro[Size780to800] EQ 1), Age7Size780to800countF)
        age8Size780to800F = WHERE((Age_Gro[Size780to800] EQ 8) AND (Sex_Gro[Size780to800] EQ 1), Age8Size780to800countF)
        age9Size780to800F = WHERE((Age_Gro[Size780to800] EQ 9) AND (Sex_Gro[Size780to800] EQ 1), Age9Size780to800countF)
        age10Size780to800F = WHERE((Age_Gro[Size780to800] EQ 10) AND (Sex_Gro[Size780to800] EQ 1), Age10Size780to800countF)
        age11Size780to800F = WHERE((Age_Gro[Size780to800] EQ 11) AND (Sex_Gro[Size780to800] EQ 1), Age11Size780to800countF)
        AGE12Size780to800F = WHERE((Age_Gro[Size780to800] EQ 12) AND (Sex_Gro[Size780to800] EQ 1), Age12Size780to800countF)
        AGE13Size780to800F = WHERE((Age_Gro[Size780to800] EQ 13) AND (Sex_Gro[Size780to800] EQ 1), Age13Size780to800countF)
        AGE14Size780to800F = WHERE((Age_Gro[Size780to800] EQ 14) AND (Sex_Gro[Size780to800] EQ 1), Age14Size780to800countF)
        AGE15Size780to800F = WHERE((Age_Gro[Size780to800] EQ 15) AND (Sex_Gro[Size780to800] EQ 1), Age15Size780to800countF)
        age16Size780to800F = WHERE((Age_Gro[Size780to800] EQ 16) AND (Sex_Gro[Size780to800] EQ 1), Age16Size780to800countF)
        age17Size780to800F = WHERE((Age_Gro[Size780to800] EQ 17) AND (Sex_Gro[Size780to800] EQ 1), Age17Size780to800countF)
        age18Size780to800F = WHERE((Age_Gro[Size780to800] EQ 18) AND (Sex_Gro[Size780to800] EQ 1), Age18Size780to800countF)
        age19Size780to800F = WHERE((Age_Gro[Size780to800] EQ 19) AND (Sex_Gro[Size780to800] EQ 1), Age19Size780to800countF)
        age20Size780to800F = WHERE((Age_Gro[Size780to800] EQ 20) AND (Sex_Gro[Size780to800] EQ 1), Age20Size780to800countF)
        age21Size780to800F = WHERE((Age_Gro[Size780to800] EQ 21) AND (Sex_Gro[Size780to800] EQ 1), Age21Size780to800countF)
        age22Size780to800F = WHERE((Age_Gro[Size780to800] EQ 22) AND (Sex_Gro[Size780to800] EQ 1), Age22Size780to800countF)
        age23Size780to800F = WHERE((Age_Gro[Size780to800] EQ 23) AND (Sex_Gro[Size780to800] EQ 1), Age23Size780to800countF)
        age24Size780to800F = WHERE((Age_Gro[Size780to800] EQ 24) AND (Sex_Gro[Size780to800] EQ 1), Age24Size780to800countF)
        age25Size780to800F = WHERE((Age_Gro[Size780to800] EQ 25) AND (Sex_Gro[Size780to800] EQ 1), Age25Size780to800countF)
        age26Size780to800F = WHERE((Age_Gro[Size780to800] EQ 26) AND (Sex_Gro[Size780to800] EQ 1), Age26Size780to800countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+35L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+35L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+35L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+35L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+35L] = 780
        WAE_length_bin[75, i*NumLengthBin+adj+35L] = Size780to800countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+35L] = Age0Size780to800countF
        WAE_length_bin[77, i*NumLengthBin+adj+35L] = Age1Size780to800countF
        WAE_length_bin[78, i*NumLengthBin+adj+35L] = Age2Size780to800countF
        WAE_length_bin[79, i*NumLengthBin+adj+35L] = Age3Size780to800countF
        WAE_length_bin[80, i*NumLengthBin+adj+35L] = Age4Size780to800countF
        WAE_length_bin[81, i*NumLengthBin+adj+35L] = Age5Size780to800countF
        WAE_length_bin[82, i*NumLengthBin+adj+35L] = Age6Size780to800countF
        WAE_length_bin[83, i*NumLengthBin+adj+35L] = Age7Size780to800countF
        WAE_length_bin[84, i*NumLengthBin+adj+35L] = Age8Size780to800countF
        WAE_length_bin[85, i*NumLengthBin+adj+35L] = Age9Size780to800countF
        WAE_length_bin[86, i*NumLengthBin+adj+35L] = Age10Size780to800countF
        WAE_length_bin[87, i*NumLengthBin+adj+35L] = Age11Size780to800countF
        WAE_length_bin[88, i*NumLengthBin+adj+35L] = Age12Size780to800countF
        WAE_length_bin[89, i*NumLengthBin+adj+35L] = Age13Size780to800countF
        WAE_length_bin[90, i*NumLengthBin+adj+35L] = Age14Size780to800countF
        WAE_length_bin[91, i*NumLengthBin+adj+35L] = Age15Size780to800countF
        WAE_length_bin[92, i*NumLengthBin+adj+35L] = Age16Size780to800countF
        WAE_length_bin[93, i*NumLengthBin+adj+35L] = Age17Size780to800countF
        WAE_length_bin[94, i*NumLengthBin+adj+35L] = Age18Size780to800countF
        WAE_length_bin[95, i*NumLengthBin+adj+35L] = Age19Size780to800countF
        WAE_length_bin[96, i*NumLengthBin+adj+35L] = Age20Size780to800countF
        WAE_length_bin[97, i*NumLengthBin+adj+35L] = Age21Size780to800countF
        WAE_length_bin[98, i*NumLengthBin+adj+35L] = Age22Size780to800countF
        WAE_length_bin[99, i*NumLengthBin+adj+35L] = Age23Size780to800countF
        WAE_length_bin[100, i*NumLengthBin+adj+35L] = Age24Size780to800countF
        WAE_length_bin[101, i*NumLengthBin+adj+35L] = Age25Size780to800countF
        WAE_length_bin[102, i*NumLengthBin+adj+35L] = Age26Size780to800countF
      ENDIF
      PRINT, 'Size780to800F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+35L])
      
      
      ; length bin 37
      IF SizeGE800count GT 0 THEN BEGIN
        age0SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 0) AND (Sex_Gro[SizeGE800] EQ 1), Age0SizeGE800countF)
        age1SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 1) AND (Sex_Gro[SizeGE800] EQ 1), Age1SizeGE800countF)
        age2SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 2) AND (Sex_Gro[SizeGE800] EQ 1), Age2SizeGE800countF)
        age3SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 3) AND (Sex_Gro[SizeGE800] EQ 1), Age3SizeGE800countF)
        age4SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 4) AND (Sex_Gro[SizeGE800] EQ 1), Age4SizeGE800countF)
        age5SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 5) AND (Sex_Gro[SizeGE800] EQ 1), Age5SizeGE800countF)
        age6SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 6) AND (Sex_Gro[SizeGE800] EQ 1), Age6SizeGE800countF)
        age7SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 7) AND (Sex_Gro[SizeGE800] EQ 1), Age7SizeGE800countF)
        age8SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 8) AND (Sex_Gro[SizeGE800] EQ 1), Age8SizeGE800countF)
        age9SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 9) AND (Sex_Gro[SizeGE800] EQ 1), Age9SizeGE800countF)
        age10SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 10) AND (Sex_Gro[SizeGE800] EQ 1), Age10SizeGE800countF)
        age11SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 11) AND (Sex_Gro[SizeGE800] EQ 1), Age11SizeGE800countF)
        AGE12SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 12) AND (Sex_Gro[SizeGE800] EQ 1), Age12SizeGE800countF)
        AGE13SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 13) AND (Sex_Gro[SizeGE800] EQ 1), Age13SizeGE800countF)
        AGE14SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 14) AND (Sex_Gro[SizeGE800] EQ 1), Age14SizeGE800countF)
        AGE15SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 15) AND (Sex_Gro[SizeGE800] EQ 1), Age15SizeGE800countF)
        age16SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 16) AND (Sex_Gro[SizeGE800] EQ 1), Age16SizeGE800countF)
        age17SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 17) AND (Sex_Gro[SizeGE800] EQ 1), Age17SizeGE800countF)
        age18SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 18) AND (Sex_Gro[SizeGE800] EQ 1), Age18SizeGE800countF)
        age19SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 19) AND (Sex_Gro[SizeGE800] EQ 1), Age19SizeGE800countF)
        age20SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 20) AND (Sex_Gro[SizeGE800] EQ 1), Age20SizeGE800countF)
        age21SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 21) AND (Sex_Gro[SizeGE800] EQ 1), Age21SizeGE800countF)
        age22SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 22) AND (Sex_Gro[SizeGE800] EQ 1), Age22SizeGE800countF)
        age23SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 23) AND (Sex_Gro[SizeGE800] EQ 1), Age23SizeGE800countF)
        age24SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 24) AND (Sex_Gro[SizeGE800] EQ 1), Age24SizeGE800countF)
        age25SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 25) AND (Sex_Gro[SizeGE800] EQ 1), Age25SizeGE800countF)
        age26SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 26) AND (Sex_Gro[SizeGE800] EQ 1), Age26SizeGE800countF)
      
        WAE_length_bin[70, i*NumLengthBin+adj+36L] = Max(length[INDEX_growthdata[female]])
        WAE_length_bin[71, i*NumLengthBin+adj+36L] = Min(length[INDEX_growthdata[female]])
        WAE_length_bin[72, i*NumLengthBin+adj+36L] = Max(age[INDEX_growthdata[female]])
        WAE_length_bin[73, i*NumLengthBin+adj+36L] = Min(age[INDEX_growthdata[female]])
        WAE_length_bin[74, i*NumLengthBin+adj+36L] = 800
        WAE_length_bin[75, i*NumLengthBin+adj+36L] = SizeGE800countF
      
        WAE_length_bin[76, i*NumLengthBin+adj+36L] = Age0SizeGE800countF
        WAE_length_bin[77, i*NumLengthBin+adj+36L] = Age1SizeGE800countF
        WAE_length_bin[78, i*NumLengthBin+adj+36L] = Age2SizeGE800countF
        WAE_length_bin[79, i*NumLengthBin+adj+36L] = Age3SizeGE800countF
        WAE_length_bin[80, i*NumLengthBin+adj+36L] = Age4SizeGE800countF
        WAE_length_bin[81, i*NumLengthBin+adj+36L] = Age5SizeGE800countF
        WAE_length_bin[82, i*NumLengthBin+adj+36L] = Age6SizeGE800countF
        WAE_length_bin[83, i*NumLengthBin+adj+36L] = Age7SizeGE800countF
        WAE_length_bin[84, i*NumLengthBin+adj+36L] = Age8SizeGE800countF
        WAE_length_bin[85, i*NumLengthBin+adj+36L] = Age9SizeGE800countF
        WAE_length_bin[86, i*NumLengthBin+adj+36L] = Age10SizeGE800countF
        WAE_length_bin[87, i*NumLengthBin+adj+36L] = Age11SizeGE800countF
        WAE_length_bin[88, i*NumLengthBin+adj+36L] = Age12SizeGE800countF
        WAE_length_bin[89, i*NumLengthBin+adj+36L] = Age13SizeGE800countF
        WAE_length_bin[90, i*NumLengthBin+adj+36L] = Age14SizeGE800countF
        WAE_length_bin[91, i*NumLengthBin+adj+36L] = Age15SizeGE800countF
        WAE_length_bin[92, i*NumLengthBin+adj+36L] = Age16SizeGE800countF
        WAE_length_bin[93, i*NumLengthBin+adj+36L] = Age17SizeGE800countF
        WAE_length_bin[94, i*NumLengthBin+adj+36L] = Age18SizeGE800countF
        WAE_length_bin[95, i*NumLengthBin+adj+36L] = Age19SizeGE800countF
        WAE_length_bin[96, i*NumLengthBin+adj+36L] = Age20SizeGE800countF
        WAE_length_bin[97, i*NumLengthBin+adj+36L] = Age21SizeGE800countF
        WAE_length_bin[98, i*NumLengthBin+adj+36L] = Age22SizeGE800countF
        WAE_length_bin[99, i*NumLengthBin+adj+36L] = Age23SizeGE800countF
        WAE_length_bin[100, i*NumLengthBin+adj+36L] = Age24SizeGE800countF
        WAE_length_bin[101, i*NumLengthBin+adj+36L] = Age25SizeGE800countF
        WAE_length_bin[102, i*NumLengthBin+adj+36L] = Age26SizeGE800countF
      ENDIF
      PRINT, 'SizeGE800F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+36L])
      PRINT, 'Total N of fish', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])

      ; Mean length-at-age
      ; All
      age0 = WHERE((AGE[INDEX_growthdata] EQ 0), Age0count)
      age1 = WHERE((AGE[INDEX_growthdata] EQ 1), Age1count)
      age2 = WHERE((AGE[INDEX_growthdata] EQ 2), AGE2count)
      age3 = WHERE((AGE[INDEX_growthdata] EQ 3), AGE3count)
      age4 = WHERE((AGE[INDEX_growthdata] EQ 4), AGE4count)
      age5 = WHERE((AGE[INDEX_growthdata] EQ 5), AGE5count)
      age6 = WHERE((AGE[INDEX_growthdata] EQ 6), AGE6count)
      age7 = WHERE((AGE[INDEX_growthdata] EQ 7), AGE7count)
      age8 = WHERE((AGE[INDEX_growthdata] EQ 8), AGE8count)
      age9 = WHERE((AGE[INDEX_growthdata] EQ 9), AGE9count)
      age10 = WHERE((AGE[INDEX_growthdata] EQ 10), AGE10count)
      age11 = WHERE((AGE[INDEX_growthdata] EQ 11), AGE11count)
      AGE12 = WHERE((AGE[INDEX_GROWTHDATA] EQ 12), AGE12count)
      AGE13 = WHERE((AGE[INDEX_GROWTHDATA] EQ 13), AGE13count)
      AGE14 = WHERE((AGE[INDEX_GROWTHDATA] EQ 14), AGE14count)
      AGE15 = WHERE((AGE[INDEX_GROWTHDATA] EQ 15), AGE15count)
      age16 = WHERE((AGE[INDEX_growthdata] EQ 16), Age16count)
      age17 = WHERE((AGE[INDEX_growthdata] EQ 17), AGE17count)
      age18 = WHERE((AGE[INDEX_growthdata] EQ 18), AGE18count)
      age19 = WHERE((AGE[INDEX_growthdata] EQ 19), AGE19count)
      age20 = WHERE((AGE[INDEX_growthdata] EQ 20), AGE20count)
      age21 = WHERE((AGE[INDEX_growthdata] EQ 21), AGE21count)
      age22 = WHERE((AGE[INDEX_growthdata] EQ 22), AGE22count)
      age23 = WHERE((AGE[INDEX_growthdata] EQ 23), AGE23count)
      age24 = WHERE((AGE[INDEX_growthdata] EQ 24), AGE24count)
      age25 = WHERE((AGE[INDEX_growthdata] EQ 25), AGE25count)
      age26 = WHERE((AGE[INDEX_growthdata] EQ 26), AGE26count)

      ; Male
      age0M = WHERE((AGE[INDEX_growthdata] EQ 0) AND (SEX[INDEX_growthdata] EQ 0), Age0Mcount)
      age1M = WHERE((AGE[INDEX_growthdata] EQ 1) AND (SEX[INDEX_growthdata] EQ 0), Age1Mcount)
      age2M = WHERE((AGE[INDEX_growthdata] EQ 2) AND (SEX[INDEX_growthdata] EQ 0), AGE2Mcount)
      age3M = WHERE((AGE[INDEX_growthdata] EQ 3) AND (SEX[INDEX_growthdata] EQ 0), AGE3Mcount)
      age4M = WHERE((AGE[INDEX_growthdata] EQ 4) AND (SEX[INDEX_growthdata] EQ 0), AGE4Mcount)
      age5M = WHERE((AGE[INDEX_growthdata] EQ 5) AND (SEX[INDEX_growthdata] EQ 0), AGE5Mcount)
      age6M = WHERE((AGE[INDEX_growthdata] EQ 6) AND (SEX[INDEX_growthdata] EQ 0), AGE6Mcount)
      age7M = WHERE((AGE[INDEX_growthdata] EQ 7) AND (SEX[INDEX_growthdata] EQ 0), AGE7Mcount)
      age8M = WHERE((AGE[INDEX_growthdata] EQ 8) AND (SEX[INDEX_growthdata] EQ 0), AGE8Mcount)
      age9M = WHERE((AGE[INDEX_growthdata] EQ 9) AND (SEX[INDEX_growthdata] EQ 0), AGE9Mcount)
      age10M = WHERE((AGE[INDEX_growthdata] EQ 10) AND (SEX[INDEX_growthdata] EQ 0), AGE10Mcount)
      age11M = WHERE((AGE[INDEX_growthdata] EQ 11) AND (SEX[INDEX_growthdata] EQ 0), AGE11Mcount)
      age12M = WHERE((AGE[INDEX_growthdata] EQ 12) AND (SEX[INDEX_growthdata] EQ 0), AGE12Mcount)
      age13M = WHERE((AGE[INDEX_growthdata] EQ 13) AND (SEX[INDEX_growthdata] EQ 0), AGE13Mcount)
      age14M = WHERE((AGE[INDEX_growthdata] EQ 14) AND (SEX[INDEX_growthdata] EQ 0), AGE14Mcount)
      age15M = WHERE((AGE[INDEX_growthdata] EQ 15) AND (SEX[INDEX_growthdata] EQ 0), AGE15Mcount)
      age16M = WHERE((AGE[INDEX_growthdata] EQ 16) AND (SEX[INDEX_growthdata] EQ 0), AGE16Mcount)
      age17M = WHERE((AGE[INDEX_growthdata] EQ 17) AND (SEX[INDEX_growthdata] EQ 0), AGE17Mcount)
      age18M = WHERE((AGE[INDEX_growthdata] EQ 18) AND (SEX[INDEX_growthdata] EQ 0), AGE18Mcount)
      age19M = WHERE((AGE[INDEX_growthdata] EQ 19) AND (SEX[INDEX_growthdata] EQ 0), AGE19Mcount)
      age20M = WHERE((AGE[INDEX_growthdata] EQ 20) AND (SEX[INDEX_growthdata] EQ 0), AGE20Mcount)
      age21M = WHERE((AGE[INDEX_growthdata] EQ 21) AND (SEX[INDEX_growthdata] EQ 0), AGE21Mcount)
      age22M = WHERE((AGE[INDEX_growthdata] EQ 22) AND (SEX[INDEX_growthdata] EQ 0), AGE22Mcount)
      age23M = WHERE((AGE[INDEX_growthdata] EQ 23) AND (SEX[INDEX_growthdata] EQ 0), AGE23Mcount)
      age24M = WHERE((AGE[INDEX_growthdata] EQ 24) AND (SEX[INDEX_growthdata] EQ 0), AGE24Mcount)
      age25M = WHERE((AGE[INDEX_growthdata] EQ 25) AND (SEX[INDEX_growthdata] EQ 0), AGE25Mcount)
      age26M = WHERE((AGE[INDEX_growthdata] EQ 26) AND (SEX[INDEX_growthdata] EQ 0), AGE26Mcount)

      ; Female
      age0F = WHERE((AGE[INDEX_growthdata] EQ 0) AND (SEX[INDEX_growthdata] EQ 1), Age0Fcount)
      age1F = WHERE((AGE[INDEX_growthdata] EQ 1) AND (SEX[INDEX_growthdata] EQ 1), Age1Fcount)
      age2F = WHERE((AGE[INDEX_growthdata] EQ 2) AND (SEX[INDEX_growthdata] EQ 1), AGE2Fcount)
      age3F = WHERE((AGE[INDEX_growthdata] EQ 3) AND (SEX[INDEX_growthdata] EQ 1), AGE3Fcount)
      age4F = WHERE((AGE[INDEX_growthdata] EQ 4) AND (SEX[INDEX_growthdata] EQ 1), AGE4Fcount)
      age5F = WHERE((AGE[INDEX_growthdata] EQ 5) AND (SEX[INDEX_growthdata] EQ 1), AGE5Fcount)
      age6F = WHERE((AGE[INDEX_growthdata] EQ 6) AND (SEX[INDEX_growthdata] EQ 1), AGE6Fcount)
      age7F = WHERE((AGE[INDEX_growthdata] EQ 7) AND (SEX[INDEX_growthdata] EQ 1), AGE7Fcount)
      age8F = WHERE((AGE[INDEX_growthdata] EQ 8) AND (SEX[INDEX_growthdata] EQ 1), AGE8Fcount)
      age9F = WHERE((AGE[INDEX_growthdata] EQ 9) AND (SEX[INDEX_growthdata] EQ 1), AGE9Fcount)
      age10F = WHERE((AGE[INDEX_growthdata] EQ 10) AND (SEX[INDEX_growthdata] EQ 1), AGE10Fcount)
      age11F = WHERE((AGE[INDEX_growthdata] EQ 11) AND (SEX[INDEX_growthdata] EQ 1), AGE11Fcount)
      age12F = WHERE((AGE[INDEX_growthdata] EQ 12) AND (SEX[INDEX_growthdata] EQ 1), AGE12Fcount)
      age13F = WHERE((AGE[INDEX_growthdata] EQ 13) AND (SEX[INDEX_growthdata] EQ 1), AGE13Fcount)
      age14F = WHERE((AGE[INDEX_growthdata] EQ 12) AND (SEX[INDEX_growthdata] EQ 1), AGE14Fcount)
      age15F = WHERE((AGE[INDEX_growthdata] EQ 13) AND (SEX[INDEX_growthdata] EQ 1), AGE15Fcount)
      age16F = WHERE((AGE[INDEX_growthdata] EQ 16) AND (SEX[INDEX_growthdata] EQ 1), AGE16Fcount)
      age17F = WHERE((AGE[INDEX_growthdata] EQ 17) AND (SEX[INDEX_growthdata] EQ 1), AGE17Fcount)
      age18F = WHERE((AGE[INDEX_growthdata] EQ 18) AND (SEX[INDEX_growthdata] EQ 1), AGE18Fcount)
      age19F = WHERE((AGE[INDEX_growthdata] EQ 19) AND (SEX[INDEX_growthdata] EQ 1), AGE19Fcount)
      age20F = WHERE((AGE[INDEX_growthdata] EQ 20) AND (SEX[INDEX_growthdata] EQ 1), AGE20Fcount)
      age21F = WHERE((AGE[INDEX_growthdata] EQ 21) AND (SEX[INDEX_growthdata] EQ 1), AGE21Fcount)
      age22F = WHERE((AGE[INDEX_growthdata] EQ 22) AND (SEX[INDEX_growthdata] EQ 1), AGE22Fcount)
      age23F = WHERE((AGE[INDEX_growthdata] EQ 23) AND (SEX[INDEX_growthdata] EQ 1), AGE23Fcount)
      age24F = WHERE((AGE[INDEX_growthdata] EQ 24) AND (SEX[INDEX_growthdata] EQ 1), AGE24Fcount)
      age25F = WHERE((AGE[INDEX_growthdata] EQ 25) AND (SEX[INDEX_growthdata] EQ 1), AGE25Fcount)
      age26F = WHERE((AGE[INDEX_growthdata] EQ 26) AND (SEX[INDEX_growthdata] EQ 1), AGE26Fcount)

      WAE_size_age[0, i] = WBIC[INDEX_growthdata[0]]
      WAE_size_age[1, i] = WBIC[INDEX_growthdata[0]]
      WAE_size_age[2, i] = SurveyYear[INDEX_growthdata[0]]

      ;all
      IF Age0count GT 0. THEN BEGIN
        WAE_size_age[3, i] = MEAN(Length[INDEX_growthdata[age0]])
        WAE_size_age[4, i] = STDDEV(Length[INDEX_growthdata[age]])
        WAE_size_age[5, i] = N_ELEMENTS(Length[INDEX_growthdata[age0]])
        WAE_size_age[6, i] = MAX(Length[INDEX_growthdata[age0]])
        WAE_size_age[7, i] = MIN(Length[INDEX_growthdata[age0]])

      ENDIF
      IF Age1count GT 0. THEN BEGIN
        WAE_size_age[8, i] = MEAN(Length[INDEX_growthdata[age1]])
        WAE_size_age[9, i] = STDDEV(Length[INDEX_growthdata[age1]])
        WAE_size_age[10, i] = N_ELEMENTS(Length[INDEX_growthdata[age1]])
        WAE_size_age[11, i] = MAX(Length[INDEX_growthdata[age1]])
        WAE_size_age[12, i] = MIN(Length[INDEX_growthdata[age1]])
      ENDIF
      IF Age2count GT 0. THEN BEGIN
        WAE_size_age[13, i] = MEAN(Length[INDEX_growthdata[age2]])
        WAE_size_age[14, i] = STDDEV(Length[INDEX_growthdata[age2]])
        WAE_size_age[15, i] = N_ELEMENTS(Length[INDEX_growthdata[age2]])
        WAE_size_age[16, i] = MAX(Length[INDEX_growthdata[age2]])
        WAE_size_age[17, i] = MIN(Length[INDEX_growthdata[age2]])
      ENDIF
      IF Age3count GT 0. THEN BEGIN
        WAE_size_age[18, i] = MEAN(Length[INDEX_growthdata[age3]])
        WAE_size_age[19, i] = STDDEV(Length[INDEX_growthdata[age3]])
        WAE_size_age[20, i] = N_ELEMENTS(Length[INDEX_growthdata[age4]])
        WAE_size_age[21, i] = MAX(Length[INDEX_growthdata[age3]])
        WAE_size_age[22, i] = MIN(Length[INDEX_growthdata[age3]])
      ENDIF
      IF Age4count GT 0. THEN BEGIN
        WAE_size_age[23, i] = MEAN(Length[INDEX_growthdata[age4]])
        WAE_size_age[24, i] = STDDEV(Length[INDEX_growthdata[age4]])
        WAE_size_age[25, i] = N_ELEMENTS(Length[INDEX_growthdata[age4]])
        WAE_size_age[26, i] = MAX(Length[INDEX_growthdata[age4]])
        WAE_size_age[27, i] = MIN(Length[INDEX_growthdata[age4]])
      ENDIF
      IF Age5count GT 0. THEN BEGIN
        WAE_size_age[28, i] = MEAN(Length[INDEX_growthdata[age5]])
        WAE_size_age[29, i] = STDDEV(Length[INDEX_growthdata[age5]])
        WAE_size_age[30, i] = N_ELEMENTS(Length[INDEX_growthdata[age5]])
        WAE_size_age[31, i] = MAX(Length[INDEX_growthdata[age5]])
        WAE_size_age[32, i] = MIN(Length[INDEX_growthdata[age5]])
      ENDIF
      IF Age6count GT 0. THEN BEGIN
        WAE_size_age[33, i] = MEAN(Length[INDEX_growthdata[age6]])
        WAE_size_age[34, i] = STDDEV(Length[INDEX_growthdata[age6]])
        WAE_size_age[35, i] = N_ELEMENTS(Length[INDEX_growthdata[age6]])
        WAE_size_age[36, i] = MAX(Length[INDEX_growthdata[age6]])
        WAE_size_age[37, i] = MIN(Length[INDEX_growthdata[age6]])
      ENDIF
      IF Age7count GT 0. THEN BEGIN
        WAE_size_age[38, i] = MEAN(Length[INDEX_growthdata[age7]])
        WAE_size_age[39, i] = STDDEV(Length[INDEX_growthdata[age7]])
        WAE_size_age[40, i] = N_ELEMENTS(Length[INDEX_growthdata[age7]])
        WAE_size_age[41, i] = MAX(Length[INDEX_growthdata[age7]])
        WAE_size_age[42, i] = MIN(Length[INDEX_growthdata[age7]])
      ENDIF
      IF Age8count GT 0. THEN BEGIN
        WAE_size_age[43, i] = MEAN(Length[INDEX_growthdata[age8]])
        WAE_size_age[44, i] = STDDEV(Length[INDEX_growthdata[age8]])
        WAE_size_age[45, i] = N_ELEMENTS(Length[INDEX_growthdata[age8]])
        WAE_size_age[46, i] = MAX(Length[INDEX_growthdata[age8]])
        WAE_size_age[47, i] = MIN(Length[INDEX_growthdata[age8]])
      ENDIF
      IF Age9count GT 0. THEN BEGIN
        WAE_size_age[48, i] = MEAN(Length[INDEX_growthdata[age9]])
        WAE_size_age[49, i] = STDDEV(Length[INDEX_growthdata[age9]])
        WAE_size_age[50, i] = N_ELEMENTS(Length[INDEX_growthdata[age9]])
        WAE_size_age[51, i] = MAX(Length[INDEX_growthdata[age9]])
        WAE_size_age[52, i] = MIN(Length[INDEX_growthdata[age9]])
      ENDIF
      IF Age10count GT 0. THEN BEGIN
        WAE_size_age[53, i] = MEAN(Length[INDEX_growthdata[age10]])
        WAE_size_age[54, i] = STDDEV(Length[INDEX_growthdata[age10]])
        WAE_size_age[55, i] = N_ELEMENTS(Length[INDEX_growthdata[age10]])
        WAE_size_age[56, i] = MAX(Length[INDEX_growthdata[age10]])
        WAE_size_age[57, i] = MIN(Length[INDEX_growthdata[age10]])
      ENDIF
      IF Age11count GT 0. THEN BEGIN
        WAE_size_age[58, i] = MEAN(Length[INDEX_growthdata[age11]])
        WAE_size_age[59, i] = STDDEV(Length[INDEX_growthdata[age11]])
        WAE_size_age[60, i] = N_ELEMENTS(Length[INDEX_growthdata[age11]])
        WAE_size_age[61, i] = MAX(Length[INDEX_growthdata[age11]])
        WAE_size_age[62, i] = MIN(Length[INDEX_growthdata[age11]])
      ENDIF
      IF Age12count GT 0. THEN BEGIN
        WAE_size_age[63, i] = MEAN(Length[INDEX_growthdata[age12]])
        WAE_size_age[64, i] = STDDEV(Length[INDEX_growthdata[age12]])
        WAE_size_age[65, i] = N_ELEMENTS(Length[INDEX_growthdata[age12]])
        WAE_size_age[66, i] = MAX(Length[INDEX_growthdata[age12]])
        WAE_size_age[67, i] = MIN(Length[INDEX_growthdata[age12]])
      ENDIF
      IF Age13count GT 0. THEN BEGIN
        WAE_size_age[68, i] = MEAN(Length[INDEX_growthdata[age13]])
        WAE_size_age[69, i] = STDDEV(Length[INDEX_growthdata[age13]])
        WAE_size_age[70, i] = N_ELEMENTS(Length[INDEX_growthdata[age13]])
        WAE_size_age[71, i] = MAX(Length[INDEX_growthdata[age13]])
        WAE_size_age[72, i] = MIN(Length[INDEX_growthdata[age13]])
      ENDIF
      IF Age14count GT 0. THEN BEGIN
        WAE_size_age[73, i] = MEAN(Length[INDEX_growthdata[age14]])
        WAE_size_age[74, i] = STDDEV(Length[INDEX_growthdata[age14]])
        WAE_size_age[75, i] = N_ELEMENTS(Length[INDEX_growthdata[age14]])
        WAE_size_age[76, i] = MAX(Length[INDEX_growthdata[age14]])
        WAE_size_age[77, i] = MIN(Length[INDEX_growthdata[age14]])
      ENDIF
      IF Age15count GT 0. THEN BEGIN
        WAE_size_age[78, i] = MEAN(Length[INDEX_growthdata[age15]])
        WAE_size_age[79, i] = STDDEV(Length[INDEX_growthdata[age15]])
        WAE_size_age[80, i] = N_ELEMENTS(Length[INDEX_growthdata[age15]])
        WAE_size_age[81, i] = MAX(Length[INDEX_growthdata[age15]])
        WAE_size_age[82, i] = MIN(Length[INDEX_growthdata[age15]])
      ENDIF
      IF Age16count GT 0. THEN BEGIN
        WAE_size_age[83, i] = MEAN(Length[INDEX_growthdata[age16]])
        WAE_size_age[84, i] = STDDEV(Length[INDEX_growthdata[age16]])
        WAE_size_age[85, i] = N_ELEMENTS(Length[INDEX_growthdata[age16]])
        WAE_size_age[86, i] = MAX(Length[INDEX_growthdata[age16]])
        WAE_size_age[87, i] = MIN(Length[INDEX_growthdata[age16]])
      ENDIF
      IF Age17count GT 0. THEN BEGIN
        WAE_size_age[88, i] = MEAN(Length[INDEX_growthdata[age17]])
        WAE_size_age[89, i] = STDDEV(Length[INDEX_growthdata[age17]])
        WAE_size_age[90, i] = N_ELEMENTS(Length[INDEX_growthdata[age17]])
        WAE_size_age[91, i] = MAX(Length[INDEX_growthdata[age17]])
        WAE_size_age[92, i] = MIN(Length[INDEX_growthdata[age17]])
      ENDIF
      IF Age18count GT 0. THEN BEGIN
        WAE_size_age[93, i] = MEAN(Length[INDEX_growthdata[age18]])
        WAE_size_age[94, i] = STDDEV(Length[INDEX_growthdata[age18]])
        WAE_size_age[95, i] = N_ELEMENTS(Length[INDEX_growthdata[age18]])
        WAE_size_age[96, i] = MAX(Length[INDEX_growthdata[age18]])
        WAE_size_age[97, i] = MIN(Length[INDEX_growthdata[age18]])
      ENDIF
      IF Age19count GT 0. THEN BEGIN
        WAE_size_age[98, i] = MEAN(Length[INDEX_growthdata[age19]])
        WAE_size_age[99, i] = STDDEV(Length[INDEX_growthdata[age19]])
        WAE_size_age[100, i] = N_ELEMENTS(Length[INDEX_growthdata[age19]])
        WAE_size_age[101, i] = MAX(Length[INDEX_growthdata[age19]])
        WAE_size_age[102, i] = MIN(Length[INDEX_growthdata[age19]])
      ENDIF
      IF Age20count GT 0. THEN BEGIN
        WAE_size_age[103, i] = MEAN(Length[INDEX_growthdata[age20]])
        WAE_size_age[104, i] = STDDEV(Length[INDEX_growthdata[age20]])
        WAE_size_age[105, i] = N_ELEMENTS(Length[INDEX_growthdata[age20]])
        WAE_size_age[106, i] = MAX(Length[INDEX_growthdata[age20]])
        WAE_size_age[107, i] = MIN(Length[INDEX_growthdata[age20]])
      ENDIF
      IF Age21count GT 0. THEN BEGIN
        WAE_size_age[108, i] = MEAN(Length[INDEX_growthdata[age21]])
        WAE_size_age[109, i] = STDDEV(Length[INDEX_growthdata[age21]])
        WAE_size_age[110, i] = N_ELEMENTS(Length[INDEX_growthdata[age21]])
        WAE_size_age[111, i] = MAX(Length[INDEX_growthdata[age21]])
        WAE_size_age[112, i] = MIN(Length[INDEX_growthdata[age21]])
      ENDIF
      IF Age22count GT 0. THEN BEGIN
        WAE_size_age[113, i] = MEAN(Length[INDEX_growthdata[age22]])
        WAE_size_age[114, i] = STDDEV(Length[INDEX_growthdata[age22]])
        WAE_size_age[115, i] = N_ELEMENTS(Length[INDEX_growthdata[age22]])
        WAE_size_age[116, i] = MAX(Length[INDEX_growthdata[age22]])
        WAE_size_age[117, i] = MIN(Length[INDEX_growthdata[age22]])
      ENDIF
      IF Age23count GT 0. THEN BEGIN
        WAE_size_age[118, i] = MEAN(Length[INDEX_growthdata[age23]])
        WAE_size_age[119, i] = STDDEV(Length[INDEX_growthdata[age23]])
        WAE_size_age[120, i] = N_ELEMENTS(Length[INDEX_growthdata[age23]])
        WAE_size_age[121, i] = MAX(Length[INDEX_growthdata[age23]])
        WAE_size_age[122, i] = MIN(Length[INDEX_growthdata[age23]])
      ENDIF
      IF Age24count GT 0. THEN BEGIN
        WAE_size_age[123, i] = MEAN(Length[INDEX_growthdata[age24]])
        WAE_size_age[124, i] = STDDEV(Length[INDEX_growthdata[age24]])
        WAE_size_age[125, i] = N_ELEMENTS(Length[INDEX_growthdata[age24]])
        WAE_size_age[126, i] = MAX(Length[INDEX_growthdata[age24]])
        WAE_size_age[127, i] = MIN(Length[INDEX_growthdata[age24]])
      ENDIF
      IF Age25count GT 0. THEN BEGIN
        WAE_size_age[128, i] = MEAN(Length[INDEX_growthdata[age25]])
        WAE_size_age[129, i] = STDDEV(Length[INDEX_growthdata[age25]])
        WAE_size_age[130, i] = N_ELEMENTS(Length[INDEX_growthdata[age25]])
        WAE_size_age[131, i] = MAX(Length[INDEX_growthdata[age25]])
        WAE_size_age[132, i] = MIN(Length[INDEX_growthdata[age25]])
      ENDIF
      IF Age26count GT 0. THEN BEGIN
        WAE_size_age[133, i] = MEAN(Length[INDEX_growthdata[age26]])
        WAE_size_age[134, i] = STDDEV(Length[INDEX_growthdata[age26]])
        WAE_size_age[135, i] = N_ELEMENTS(Length[INDEX_growthdata[age26]])
        WAE_size_age[136, i] = MAX(Length[INDEX_growthdata[age26]])
        WAE_size_age[137, i] = MIN(Length[INDEX_growthdata[age26]])
      ENDIF


      ; Males
      IF Age0Mcount GT 0. THEN BEGIN
        WAE_size_age[138, i] = MEAN(Length[INDEX_growthdata[age0M]])
        WAE_size_age[139, i] = STDDEV(Length[INDEX_growthdata[age0M]])
        WAE_size_age[140, i] = N_ELEMENTS(Length[INDEX_growthdata[age0M]])
        WAE_size_age[141, i] = MAX(Length[INDEX_growthdata[age0M]])
        WAE_size_age[142, i] = MIN(Length[INDEX_growthdata[age0M]])
      ENDIF
      IF Age1Mcount GT 0. THEN BEGIN
        WAE_size_age[143, i] = MEAN(Length[INDEX_growthdata[age1M]])
        WAE_size_age[144, i] = STDDEV(Length[INDEX_growthdata[age1M]])
        WAE_size_age[145, i] = N_ELEMENTS(Length[INDEX_growthdata[age1M]])
        WAE_size_age[146, i] = MAX(Length[INDEX_growthdata[age1M]])
        WAE_size_age[147, i] = MIN(Length[INDEX_growthdata[age1M]])
      ENDIF
      IF Age2Mcount GT 0. THEN BEGIN
        WAE_size_age[148, i] = MEAN(Length[INDEX_growthdata[age2M]])
        WAE_size_age[149, i] = STDDEV(Length[INDEX_growthdata[age2M]])
        WAE_size_age[150, i] = N_ELEMENTS(Length[INDEX_growthdata[age2M]])
        WAE_size_age[151, i] = MAX(Length[INDEX_growthdata[age2M]])
        WAE_size_age[152, i] = MIN(Length[INDEX_growthdata[age2M]])
      ENDIF
      IF Age3Mcount GT 0. THEN BEGIN
        WAE_size_age[153, i] = MEAN(Length[INDEX_growthdata[age3M]])
        WAE_size_age[154, i] = STDDEV(Length[INDEX_growthdata[age3M]])
        WAE_size_age[155, i] = N_ELEMENTS(Length[INDEX_growthdata[age4M]])
        WAE_size_age[156, i] = MAX(Length[INDEX_growthdata[age3M]])
        WAE_size_age[157, i] = MIN(Length[INDEX_growthdata[age3M]])
      ENDIF
      IF Age4Mcount GT 0. THEN BEGIN
        WAE_size_age[158, i] = MEAN(Length[INDEX_growthdata[age4M]])
        WAE_size_age[159, i] = STDDEV(Length[INDEX_growthdata[age4M]])
        WAE_size_age[160, i] = N_ELEMENTS(Length[INDEX_growthdata[age4M]])
        WAE_size_age[161, i] = MAX(Length[INDEX_growthdata[age4M]])
        WAE_size_age[162, i] = MIN(Length[INDEX_growthdata[age4M]])
      ENDIF
      IF Age5Mcount GT 0. THEN BEGIN
        WAE_size_age[163, i] = MEAN(Length[INDEX_growthdata[age5M]])
        WAE_size_age[164, i] = STDDEV(Length[INDEX_growthdata[age5M]])
        WAE_size_age[165, i] = N_ELEMENTS(Length[INDEX_growthdata[age5M]])
        WAE_size_age[166, i] = MAX(Length[INDEX_growthdata[age5M]])
        WAE_size_age[167, i] = MIN(Length[INDEX_growthdata[age5M]])
      ENDIF
      IF Age6Mcount GT 0. THEN BEGIN
        WAE_size_age[168, i] = MEAN(Length[INDEX_growthdata[age6M]])
        WAE_size_age[169, i] = STDDEV(Length[INDEX_growthdata[age6M]])
        WAE_size_age[170, i] = N_ELEMENTS(Length[INDEX_growthdata[age6M]])
        WAE_size_age[171, i] = MAX(Length[INDEX_growthdata[age6M]])
        WAE_size_age[172, i] = MIN(Length[INDEX_growthdata[age6M]])
      ENDIF
      IF Age7Mcount GT 0. THEN BEGIN
        WAE_size_age[173, i] = MEAN(Length[INDEX_growthdata[age7M]])
        WAE_size_age[174, i] = STDDEV(Length[INDEX_growthdata[age7M]])
        WAE_size_age[175, i] = N_ELEMENTS(Length[INDEX_growthdata[age7M]])
        WAE_size_age[176, i] = MAX(Length[INDEX_growthdata[age7M]])
        WAE_size_age[177, i] = MIN(Length[INDEX_growthdata[age7M]])
      ENDIF
      IF Age8Mcount GT 0. THEN BEGIN
        WAE_size_age[178, i] = MEAN(Length[INDEX_growthdata[age8M]])
        WAE_size_age[179, i] = STDDEV(Length[INDEX_growthdata[age8M]])
        WAE_size_age[180, i] = N_ELEMENTS(Length[INDEX_growthdata[age8M]])
        WAE_size_age[181, i] = MAX(Length[INDEX_growthdata[age8M]])
        WAE_size_age[182, i] = MIN(Length[INDEX_growthdata[age8M]])
      ENDIF
      IF Age9Mcount GT 0. THEN BEGIN
        WAE_size_age[183, i] = MEAN(Length[INDEX_growthdata[age9M]])
        WAE_size_age[184, i] = STDDEV(Length[INDEX_growthdata[age9M]])
        WAE_size_age[185, i] = N_ELEMENTS(Length[INDEX_growthdata[age9M]])
        WAE_size_age[186, i] = MAX(Length[INDEX_growthdata[age9M]])
        WAE_size_age[187, i] = MIN(Length[INDEX_growthdata[age9M]])
      ENDIF
      IF Age10Mcount GT 0. THEN BEGIN
        WAE_size_age[188, i] = MEAN(Length[INDEX_growthdata[age10M]])
        WAE_size_age[189, i] = STDDEV(Length[INDEX_growthdata[age10M]])
        WAE_size_age[190, i] = N_ELEMENTS(Length[INDEX_growthdata[age10M]])
        WAE_size_age[191, i] = MAX(Length[INDEX_growthdata[age10M]])
        WAE_size_age[192, i] = MIN(Length[INDEX_growthdata[age10M]])
      ENDIF
      IF Age11Mcount GT 0. THEN BEGIN
        WAE_size_age[193, i] = MEAN(Length[INDEX_growthdata[age11M]])
        WAE_size_age[194, i] = STDDEV(Length[INDEX_growthdata[age11M]])
        WAE_size_age[195, i] = N_ELEMENTS(Length[INDEX_growthdata[age11M]])
        WAE_size_age[196, i] = MAX(Length[INDEX_growthdata[age11M]])
        WAE_size_age[197, i] = MIN(Length[INDEX_growthdata[age11M]])
      ENDIF
      IF Age12Mcount GT 0. THEN BEGIN
        WAE_size_age[198, i] = MEAN(Length[INDEX_growthdata[age12M]])
        WAE_size_age[199, i] = STDDEV(Length[INDEX_growthdata[age12M]])
        WAE_size_age[200, i] = N_ELEMENTS(Length[INDEX_growthdata[age12M]])
        WAE_size_age[201, i] = MAX(Length[INDEX_growthdata[age12M]])
        WAE_size_age[202, i] = MIN(Length[INDEX_growthdata[age12M]])
      ENDIF
      IF Age13Mcount GT 0. THEN BEGIN
        WAE_size_age[203, i] = MEAN(Length[INDEX_growthdata[age13M]])
        WAE_size_age[204, i] = STDDEV(Length[INDEX_growthdata[age13M]])
        WAE_size_age[205, i] = N_ELEMENTS(Length[INDEX_growthdata[age13M]])
        WAE_size_age[206, i] = MAX(Length[INDEX_growthdata[age13M]])
        WAE_size_age[207, i] = MIN(Length[INDEX_growthdata[age13M]])
      ENDIF
      IF Age14Mcount GT 0. THEN BEGIN
        WAE_size_age[208, i] = MEAN(Length[INDEX_growthdata[age14M]])
        WAE_size_age[209, i] = STDDEV(Length[INDEX_growthdata[age14M]])
        WAE_size_age[210, i] = N_ELEMENTS(Length[INDEX_growthdata[age14M]])
        WAE_size_age[211, i] = MAX(Length[INDEX_growthdata[age14M]])
        WAE_size_age[212, i] = MIN(Length[INDEX_growthdata[age14M]])
      ENDIF
      IF Age15Mcount GT 0. THEN BEGIN
        WAE_size_age[213, i] = MEAN(Length[INDEX_growthdata[age15M]])
        WAE_size_age[214, i] = STDDEV(Length[INDEX_growthdata[age15M]])
        WAE_size_age[215, i] = N_ELEMENTS(Length[INDEX_growthdata[age15M]])
        WAE_size_age[216, i] = MAX(Length[INDEX_growthdata[age15M]])
        WAE_size_age[217, i] = MIN(Length[INDEX_growthdata[age15M]])
      ENDIF
      IF Age16Mcount GT 0. THEN BEGIN
        WAE_size_age[218, i] = MEAN(Length[INDEX_growthdata[age16M]])
        WAE_size_age[219, i] = STDDEV(Length[INDEX_growthdata[age16M]])
        WAE_size_age[220, i] = N_ELEMENTS(Length[INDEX_growthdata[age16M]])
        WAE_size_age[221, i] = MAX(Length[INDEX_growthdata[age16M]])
        WAE_size_age[222, i] = MIN(Length[INDEX_growthdata[age16M]])
      ENDIF
      IF Age17Mcount GT 0. THEN BEGIN
        WAE_size_age[223, i] = MEAN(Length[INDEX_growthdata[age17M]])
        WAE_size_age[224, i] = STDDEV(Length[INDEX_growthdata[age17M]])
        WAE_size_age[225, i] = N_ELEMENTS(Length[INDEX_growthdata[age17M]])
        WAE_size_age[226, i] = MAX(Length[INDEX_growthdata[age17M]])
        WAE_size_age[227, i] = MIN(Length[INDEX_growthdata[age17M]])
      ENDIF
      IF Age18Mcount GT 0. THEN BEGIN
        WAE_size_age[228, i] = MEAN(Length[INDEX_growthdata[age18M]])
        WAE_size_age[229, i] = STDDEV(Length[INDEX_growthdata[age18M]])
        WAE_size_age[230, i] = N_ELEMENTS(Length[INDEX_growthdata[age18M]])
        WAE_size_age[231, i] = MAX(Length[INDEX_growthdata[age18M]])
        WAE_size_age[232, i] = MIN(Length[INDEX_growthdata[age18M]])
      ENDIF
      IF Age19Mcount GT 0. THEN BEGIN
        WAE_size_age[233, i] = MEAN(Length[INDEX_growthdata[age19M]])
        WAE_size_age[234, i] = STDDEV(Length[INDEX_growthdata[age19M]])
        WAE_size_age[235, i] = N_ELEMENTS(Length[INDEX_growthdata[age19M]])
        WAE_size_age[236, i] = MAX(Length[INDEX_growthdata[age19M]])
        WAE_size_age[237, i] = MIN(Length[INDEX_growthdata[age19M]])
      ENDIF
      IF Age20Mcount GT 0. THEN BEGIN
        WAE_size_age[238, i] = MEAN(Length[INDEX_growthdata[age20M]])
        WAE_size_age[239, i] = STDDEV(Length[INDEX_growthdata[age20M]])
        WAE_size_age[240, i] = N_ELEMENTS(Length[INDEX_growthdata[age20M]])
        WAE_size_age[241, i] = MAX(Length[INDEX_growthdata[age20M]])
        WAE_size_age[242, i] = MIN(Length[INDEX_growthdata[age20M]])
      ENDIF
      IF Age21Mcount GT 0. THEN BEGIN
        WAE_size_age[243, i] = MEAN(Length[INDEX_growthdata[age21M]])
        WAE_size_age[244, i] = STDDEV(Length[INDEX_growthdata[age21M]])
        WAE_size_age[245, i] = N_ELEMENTS(Length[INDEX_growthdata[age21M]])
        WAE_size_age[246, i] = MAX(Length[INDEX_growthdata[age21M]])
        WAE_size_age[247, i] = MIN(Length[INDEX_growthdata[age21M]])
      ENDIF
      IF Age22Mcount GT 0. THEN BEGIN
        WAE_size_age[248, i] = MEAN(Length[INDEX_growthdata[age22M]])
        WAE_size_age[249, i] = STDDEV(Length[INDEX_growthdata[age22M]])
        WAE_size_age[250, i] = N_ELEMENTS(Length[INDEX_growthdata[age22M]])
        WAE_size_age[251, i] = MAX(Length[INDEX_growthdata[age22M]])
        WAE_size_age[252, i] = MIN(Length[INDEX_growthdata[age22M]])
      ENDIF
      IF Age23Mcount GT 0. THEN BEGIN
        WAE_size_age[253, i] = MEAN(Length[INDEX_growthdata[age23M]])
        WAE_size_age[254, i] = STDDEV(Length[INDEX_growthdata[age23M]])
        WAE_size_age[255, i] = N_ELEMENTS(Length[INDEX_growthdata[age23M]])
        WAE_size_age[256, i] = MAX(Length[INDEX_growthdata[age23M]])
        WAE_size_age[257, i] = MIN(Length[INDEX_growthdata[age23M]])
      ENDIF
      IF Age24Mcount GT 0. THEN BEGIN
        WAE_size_age[258, i] = MEAN(Length[INDEX_growthdata[age24M]])
        WAE_size_age[259, i] = STDDEV(Length[INDEX_growthdata[age24M]])
        WAE_size_age[260, i] = N_ELEMENTS(Length[INDEX_growthdata[age24M]])
        WAE_size_age[261, i] = MAX(Length[INDEX_growthdata[age24M]])
        WAE_size_age[262, i] = MIN(Length[INDEX_growthdata[age24M]])
      ENDIF
      IF Age25Mcount GT 0. THEN BEGIN
        WAE_size_age[263, i] = MEAN(Length[INDEX_growthdata[age25M]])
        WAE_size_age[264, i] = STDDEV(Length[INDEX_growthdata[age25M]])
        WAE_size_age[265, i] = N_ELEMENTS(Length[INDEX_growthdata[age25M]])
        WAE_size_age[266, i] = MAX(Length[INDEX_growthdata[age25M]])
        WAE_size_age[267, i] = MIN(Length[INDEX_growthdata[age25M]])
      ENDIF
      IF Age26Mcount GT 0. THEN BEGIN
        WAE_size_age[268, i] = MEAN(Length[INDEX_growthdata[age26M]])
        WAE_size_age[269, i] = STDDEV(Length[INDEX_growthdata[age26M]])
        WAE_size_age[270, i] = N_ELEMENTS(Length[INDEX_growthdata[age26M]])
        WAE_size_age[271, i] = MAX(Length[INDEX_growthdata[age26M]])
        WAE_size_age[272, i] = MIN(Length[INDEX_growthdata[age26M]])
      ENDIF



      ; Female
      IF Age0Fcount GT 0. THEN BEGIN
        WAE_size_age[273, i] = MEAN(Length[INDEX_growthdata[age0F]])
        WAE_size_age[274, i] = STDDEV(Length[INDEX_growthdata[age0F]])
        WAE_size_age[275, i] = N_ELEMENTS(Length[INDEX_growthdata[age0F]])
        WAE_size_age[276, i] = MAX(Length[INDEX_growthdata[age0F]])
        WAE_size_age[277, i] = MIN(Length[INDEX_growthdata[age0F]])
      ENDIF
      IF Age1Fcount GT 0. THEN BEGIN
        WAE_size_age[278, i] = MEAN(Length[INDEX_growthdata[age1F]])
        WAE_size_age[279, i] = STDDEV(Length[INDEX_growthdata[age1F]])
        WAE_size_age[280, i] = N_ELEMENTS(Length[INDEX_growthdata[age1F]])
        WAE_size_age[281, i] = MAX(Length[INDEX_growthdata[age1F]])
        WAE_size_age[282, i] = MIN(Length[INDEX_growthdata[age1F]])
      ENDIF
      IF Age2Fcount GT 0. THEN BEGIN
        WAE_size_age[283, i] = MEAN(Length[INDEX_growthdata[age2F]])
        WAE_size_age[284, i] = STDDEV(Length[INDEX_growthdata[age2F]])
        WAE_size_age[285, i] = N_ELEMENTS(Length[INDEX_growthdata[age2F]])
        WAE_size_age[286, i] = MAX(Length[INDEX_growthdata[age2F]])
        WAE_size_age[287, i] = MIN(Length[INDEX_growthdata[age2F]])
      ENDIF
      IF Age3Fcount GT 0. THEN BEGIN
        WAE_size_age[288, i] = MEAN(Length[INDEX_growthdata[age3F]])
        WAE_size_age[289, i] = STDDEV(Length[INDEX_growthdata[age3F]])
        WAE_size_age[290, i] = N_ELEMENTS(Length[INDEX_growthdata[age3F]])
        WAE_size_age[291, i] = MAX(Length[INDEX_growthdata[age3F]])
        WAE_size_age[292, i] = MIN(Length[INDEX_growthdata[age3F]])
      ENDIF
      IF Age4Fcount GT 0. THEN BEGIN
        WAE_size_age[293, i] = MEAN(Length[INDEX_growthdata[age4F]])
        WAE_size_age[294, i] = STDDEV(Length[INDEX_growthdata[age4F]])
        WAE_size_age[295, i] = N_ELEMENTS(Length[INDEX_growthdata[age4F]])
        WAE_size_age[296, i] = MAX(Length[INDEX_growthdata[age4F]])
        WAE_size_age[297, i] = MIN(Length[INDEX_growthdata[age4F]])
      ENDIF
      IF Age5Fcount GT 0. THEN BEGIN
        WAE_size_age[298, i] = MEAN(Length[INDEX_growthdata[age5F]])
        WAE_size_age[299, i] = STDDEV(Length[INDEX_growthdata[age5F]])
        WAE_size_age[300, i] = N_ELEMENTS(Length[INDEX_growthdata[age5F]])
        WAE_size_age[301, i] = MAX(Length[INDEX_growthdata[age5F]])
        WAE_size_age[302, i] = MIN(Length[INDEX_growthdata[age5F]])
      ENDIF
      IF Age6Fcount GT 0. THEN BEGIN
        WAE_size_age[303, i] = MEAN(Length[INDEX_growthdata[age6F]])
        WAE_size_age[304, i] = STDDEV(Length[INDEX_growthdata[age6F]])
        WAE_size_age[305, i] = N_ELEMENTS(Length[INDEX_growthdata[age6F]])
        WAE_size_age[306, i] = MAX(Length[INDEX_growthdata[age6F]])
        WAE_size_age[307, i] = MIN(Length[INDEX_growthdata[age6F]])
      ENDIF
      IF Age7Fcount GT 0. THEN BEGIN
        WAE_size_age[308, i] = MEAN(Length[INDEX_growthdata[age7F]])
        WAE_size_age[309, i] = STDDEV(Length[INDEX_growthdata[age7F]])
        WAE_size_age[310, i] = N_ELEMENTS(Length[INDEX_growthdata[age7F]])
        WAE_size_age[311, i] = MAX(Length[INDEX_growthdata[age7F]])
        WAE_size_age[312, i] = MIN(Length[INDEX_growthdata[age7F]])
      ENDIF
      IF Age8Fcount GT 0. THEN BEGIN
        WAE_size_age[313, i] = MEAN(Length[INDEX_growthdata[age8F]])
        WAE_size_age[314, i] = STDDEV(Length[INDEX_growthdata[age8F]])
        WAE_size_age[315, i] = N_ELEMENTS(Length[INDEX_growthdata[age8F]])
        WAE_size_age[316, i] = MAX(Length[INDEX_growthdata[age8F]])
        WAE_size_age[317, i] = MIN(Length[INDEX_growthdata[age8F]])
      ENDIF
      IF Age9Fcount GT 0. THEN BEGIN
        WAE_size_age[318, i] = MEAN(Length[INDEX_growthdata[age9F]])
        WAE_size_age[319, i] = STDDEV(Length[INDEX_growthdata[age9F]])
        WAE_size_age[320, i] = N_ELEMENTS(Length[INDEX_growthdata[age9F]])
        WAE_size_age[321, i] = MAX(Length[INDEX_growthdata[age9F]])
        WAE_size_age[322, i] = MIN(Length[INDEX_growthdata[age9F]])
      ENDIF
      IF Age10Fcount GT 0. THEN BEGIN
        WAE_size_age[323, i] = MEAN(Length[INDEX_growthdata[age10F]])
        WAE_size_age[324, i] = STDDEV(Length[INDEX_growthdata[age10F]])
        WAE_size_age[325, i] = N_ELEMENTS(Length[INDEX_growthdata[age10F]])
        WAE_size_age[326, i] = MAX(Length[INDEX_growthdata[age10F]])
        WAE_size_age[327, i] = MIN(Length[INDEX_growthdata[age10F]])
      ENDIF
      IF Age11Fcount GT 0. THEN BEGIN
        WAE_size_age[328, i] = MEAN(Length[INDEX_growthdata[age11F]])
        WAE_size_age[329, i] = STDDEV(Length[INDEX_growthdata[age11F]])
        WAE_size_age[330, i] = N_ELEMENTS(Length[INDEX_growthdata[age11F]])
        WAE_size_age[331, i] = MAX(Length[INDEX_growthdata[age11F]])
        WAE_size_age[332, i] = MIN(Length[INDEX_growthdata[age11F]])
      ENDIF
      IF Age12Fcount GT 0. THEN BEGIN
        WAE_size_age[333, i] = MEAN(Length[INDEX_growthdata[age12F]])
        WAE_size_age[334, i] = STDDEV(Length[INDEX_growthdata[age12F]])
        WAE_size_age[335, i] = N_ELEMENTS(Length[INDEX_growthdata[age12F]])
        WAE_size_age[336, i] = MAX(Length[INDEX_growthdata[age12F]])
        WAE_size_age[337, i] = MIN(Length[INDEX_growthdata[age12F]])
      ENDIF
      IF Age13Fcount GT 0. THEN BEGIN
        WAE_size_age[338, i] = MEAN(Length[INDEX_growthdata[age13F]])
        WAE_size_age[339, i] = STDDEV(Length[INDEX_growthdata[age13F]])
        WAE_size_age[340, i] = N_ELEMENTS(Length[INDEX_growthdata[age13F]])
        WAE_size_age[341, i] = MAX(Length[INDEX_growthdata[age13F]])
        WAE_size_age[342, i] = MIN(Length[INDEX_growthdata[age13F]])
      ENDIF
      IF Age14Fcount GT 0. THEN BEGIN
        WAE_size_age[343, i] = MEAN(Length[INDEX_growthdata[age14F]])
        WAE_size_age[344, i] = STDDEV(Length[INDEX_growthdata[age14F]])
        WAE_size_age[345, i] = N_ELEMENTS(Length[INDEX_growthdata[age14F]])
        WAE_size_age[346, i] = MAX(Length[INDEX_growthdata[age14F]])
        WAE_size_age[347, i] = MIN(Length[INDEX_growthdata[age14F]])
      ENDIF
      IF Age15Fcount GT 0. THEN BEGIN
        WAE_size_age[348, i] = MEAN(Length[INDEX_growthdata[age15F]])
        WAE_size_age[349, i] = STDDEV(Length[INDEX_growthdata[age15F]])
        WAE_size_age[350, i] = N_ELEMENTS(Length[INDEX_growthdata[age15F]])
        WAE_size_age[351, i] = MAX(Length[INDEX_growthdata[age15F]])
        WAE_size_age[352, i] = MIN(Length[INDEX_growthdata[age15F]])
      ENDIF
      IF Age16Fcount GT 0. THEN BEGIN
        WAE_size_age[353, i] = MEAN(Length[INDEX_growthdata[age16F]])
        WAE_size_age[354, i] = STDDEV(Length[INDEX_growthdata[age16F]])
        WAE_size_age[355, i] = N_ELEMENTS(Length[INDEX_growthdata[age16F]])
        WAE_size_age[356, i] = MAX(Length[INDEX_growthdata[age16F]])
        WAE_size_age[357, i] = MIN(Length[INDEX_growthdata[age16F]])
      ENDIF
      IF Age17Fcount GT 0. THEN BEGIN
        WAE_size_age[358, i] = MEAN(Length[INDEX_growthdata[age17F]])
        WAE_size_age[359, i] = STDDEV(Length[INDEX_growthdata[age17F]])
        WAE_size_age[360, i] = N_ELEMENTS(Length[INDEX_growthdata[age17F]])
        WAE_size_age[361, i] = MAX(Length[INDEX_growthdata[age17F]])
        WAE_size_age[362, i] = MIN(Length[INDEX_growthdata[age17F]])
      ENDIF
      IF Age18Fcount GT 0. THEN BEGIN
        WAE_size_age[363, i] = MEAN(Length[INDEX_growthdata[age18F]])
        WAE_size_age[364, i] = STDDEV(Length[INDEX_growthdata[age18F]])
        WAE_size_age[365, i] = N_ELEMENTS(Length[INDEX_growthdata[age18F]])
        WAE_size_age[366, i] = MAX(Length[INDEX_growthdata[age18F]])
        WAE_size_age[367, i] = MIN(Length[INDEX_growthdata[age18F]])
      ENDIF
      IF Age19Fcount GT 0. THEN BEGIN
        WAE_size_age[368, i] = MEAN(Length[INDEX_growthdata[age19F]])
        WAE_size_age[369, i] = STDDEV(Length[INDEX_growthdata[age19F]])
        WAE_size_age[370, i] = N_ELEMENTS(Length[INDEX_growthdata[age19F]])
        WAE_size_age[371, i] = MAX(Length[INDEX_growthdata[age19F]])
        WAE_size_age[372, i] = MIN(Length[INDEX_growthdata[age19F]])
      ENDIF
      IF Age20Fcount GT 0. THEN BEGIN
        WAE_size_age[373, i] = MEAN(Length[INDEX_growthdata[age20F]])
        WAE_size_age[374, i] = STDDEV(Length[INDEX_growthdata[age20F]])
        WAE_size_age[375, i] = N_ELEMENTS(Length[INDEX_growthdata[age20F]])
        WAE_size_age[376, i] = MAX(Length[INDEX_growthdata[age20F]])
        WAE_size_age[377, i] = MIN(Length[INDEX_growthdata[age20F]])
      ENDIF
      IF Age21Fcount GT 0. THEN BEGIN
        WAE_size_age[378, i] = MEAN(Length[INDEX_growthdata[age21F]])
        WAE_size_age[379, i] = STDDEV(Length[INDEX_growthdata[age21F]])
        WAE_size_age[380, i] = N_ELEMENTS(Length[INDEX_growthdata[age21F]])
        WAE_size_age[381, i] = MAX(Length[INDEX_growthdata[age21F]])
        WAE_size_age[382, i] = MIN(Length[INDEX_growthdata[age21F]])
      ENDIF
      IF Age22Fcount GT 0. THEN BEGIN
        WAE_size_age[383, i] = MEAN(Length[INDEX_growthdata[age22F]])
        WAE_size_age[384, i] = STDDEV(Length[INDEX_growthdata[age22F]])
        WAE_size_age[385, i] = N_ELEMENTS(Length[INDEX_growthdata[age22F]])
        WAE_size_age[386, i] = MAX(Length[INDEX_growthdata[age22F]])
        WAE_size_age[387, i] = MIN(Length[INDEX_growthdata[age22F]])
      ENDIF
      IF Age23Fcount GT 0. THEN BEGIN
        WAE_size_age[388, i] = MEAN(Length[INDEX_growthdata[age23F]])
        WAE_size_age[389, i] = STDDEV(Length[INDEX_growthdata[age23F]])
        WAE_size_age[390, i] = N_ELEMENTS(Length[INDEX_growthdata[age23F]])
        WAE_size_age[391, i] = MAX(Length[INDEX_growthdata[age23F]])
        WAE_size_age[392, i] = MIN(Length[INDEX_growthdata[age23F]])
      ENDIF
      IF Age24Fcount GT 0. THEN BEGIN
        WAE_size_age[393, i] = MEAN(Length[INDEX_growthdata[age24F]])
        WAE_size_age[394, i] = STDDEV(Length[INDEX_growthdata[age24F]])
        WAE_size_age[396, i] = N_ELEMENTS(Length[INDEX_growthdata[age24F]])
        WAE_size_age[397, i] = MAX(Length[INDEX_growthdata[age24F]])
        WAE_size_age[398, i] = MIN(Length[INDEX_growthdata[age24F]])
      ENDIF
      IF Age25Fcount GT 0. THEN BEGIN
        WAE_size_age[399, i] = MEAN(Length[INDEX_growthdata[age25F]])
        WAE_size_age[400, i] = STDDEV(Length[INDEX_growthdata[age25F]])
        WAE_size_age[401, i] = N_ELEMENTS(Length[INDEX_growthdata[age25F]])
        WAE_size_age[402, i] = MAX(Length[INDEX_growthdata[age25F]])
        WAE_size_age[403, i] = MIN(Length[INDEX_growthdata[age25F]])
      ENDIF
      IF Age26Fcount GT 0. THEN BEGIN
        WAE_size_age[404, i] = MEAN(Length[INDEX_growthdata[age26F]])
        WAE_size_age[405, i] = STDDEV(Length[INDEX_growthdata[age26F]])
        WAE_size_age[406, i] = N_ELEMENTS(Length[INDEX_growthdata[age26F]])
        WAE_size_age[407, i] = MAX(Length[INDEX_growthdata[age26F]])
        WAE_size_age[408, i] = MIN(Length[INDEX_growthdata[age26F]])
      ENDIF
    ENDIF

    ;ENDFOR

    ;PRINT, 'uniqWBIC_Year_NsmplGT30_NageclassGT3[i]', uniqWBIC_Year_NsmplGT30_NageclassGT3[i]
    ;PRINT, INDEX_datafinal


    ;    ; GROWTH MODELS
    ;    ;WRITE_PNG,filename,TVRD()
    ;
    ;    ;Length_Gro = Linf_gro * (1 - EXP(-K_gro * (Age_Gro - t0_gro)))
    ;
    ;    ; NEED TO SUPRIMPOSE FITTED LINE OVER THE DATA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    ;
    ;    ; Example code
    ;    ;function jacksgaussian, x, p; this needs to be a separate function
    ;    ;; x = abscissae
    ;    ;; p = parameters = [amplitude, centroid, width]
    ;    ;argument = (x - p[1]) / p[2]
    ;    ;gaussian = p[0] * exp(-argument^2)
    ;    ;return, gaussian
    ;    ;end
    ;
    ;    ; Plot data
    ;    ;length
    ;    PLOT, Age_Gro, Length_Gro, psym=4, xtitle='Age (year)', ytitle='Length (mm)', xrange=[0,25] $
    ;      , title='Growth_analysis_WI_walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
    ;    filename='Walleye age vs. length'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
    ;
    ;    ; ; Weight
    ;    ;  PLOT, Age_Gro, Length_Gro, psym=4, xtitle='Age (year)', ytitle='Weight (g)', xrange=[0,25] $
    ;    ;    , title='VBGF_WI walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
    ;    ;  filename='Walleye age vs. weight'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
    ;
    ;    ;  ;ln(age) for log linear models
    ;    ;  PLOT, alog(Age_Gro), Length_Gro, psym=4, xtitle='log Age (year)', ytitle='Length (mm)', xrange=[0,5] $
    ;    ;    , title='Loglinear_WI walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
    ;    ;  filename='Walleye age vs. length'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
    ;
    ;
    ;    ; Run mpfitfun (watch as it iteratively improves our initial guess to minimize chi-squared);
    ;    paramset[4, i] = Numageclass
    ;    paramset[5, i] = Maxageclass
    ;    paramset[6, i] = Minageclass
    ;    paramset[7, i] = MAX(Length_Gro)
    ;    paramset[8, i] = MIN(Length_Gro)
    ;
    ;    ; add small variation to each data point
    ;    dy = Length_Gro + RANDOMN(seed, N_ELEMENTS(Length_Gro)) * 0.1
    ;
    ;    ;parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit)
    ;
    ;    ;  ; 1) standard von Bertlanffy model (3 parameters) - all individuals
    ;    ;  startparms = [850.0D, 0.1D, -1.D]
    ;    ;  ;851  0.099 -0.96
    ;    ;  ;WLslope = 3.18
    ;    ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,1500.D]}, 3)
    ;    ;  pi(0).limited(1) = 0; 0=vary; 1=constant
    ;    ;  pi(0).limits(1) = 1500.
    ;    ;  MAXITER = 100000
    ;    ;  num_param = 3.
    ;    ;
    ;    ;  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, $
    ;    ;  perror = dparms, yfit=yfit, PARINFO=pi)
    ;    ;  Length_Gro_EstAll = parms[0] * (1 - EXP(-parms[1] * (Age_Gro - parms[2])));^WLslope
    ;    ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
    ;    ;  paramset[9:11, i] = parms
    ;    ;  paramset[14, i] = BESTNORM
    ;    ;  paramset[15, i] = DOF
    ;    ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
    ;    ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
    ;    ;  paramset[17:19, i] = dparms
    ;    ;  paramset[22, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
    ;    ;  paramset[23, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
    ;    ;  paramset[24, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
    ;    ;  paramset[25, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
    ;    ;  paramset[26, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
    ;    ;  paramset[27, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
    ;    ;  paramset[28, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
    ;    ;  paramset[29, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
    ;    ;  paramset[30, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
    ;    ;  paramset[31, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
    ;    ;  paramset[32, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
    ;    ;  paramset[33, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
    ;    ;  paramset[34, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
    ;    ;  paramset[35, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
    ;    ;  paramset[36, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
    ;    ;  paramset[37, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
    ;    ;  paramset[38, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
    ;    ;  paramset[39, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
    ;    ;  paramset[40, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
    ;    ;  paramset[41, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
    ;    ;  paramset[42, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
    ;
    ;
    ;    ;  ; 2) generalized von Bertlanffy model (4 parameters) - all individuals
    ;    ;  startparms = [900.0D, 0.2D, -0.15D, 1D]
    ;    ;  ;WLslope = 3.18
    ;    ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 4)
    ;    ;  pi(0).limited(1) = 0; 0=vary; 1=constant
    ;    ;  pi(0).limits(1) = 2000.
    ;    ;  num_param = 4.
    ;    ;  MAXITER = 100000.
    ;    ;
    ;    ;  parms = mpfitfun('GvonBertalanffy', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxiter $
    ;    ;  , perror = dparms, yfit=yfit, PARINFO=pi)
    ;    ;  Length_Gro_EstAll = parms[0] * (1 - EXP(-parms[1] * (Age_Gro - parms[2])))^parms[3];^WLslope
    ;    ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
    ;    ;  paramset[9:12, i] = parms
    ;    ;  paramset[14, i] = BESTNORM
    ;    ;  paramset[15, i] = DOF
    ;    ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
    ;    ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
    ;    ;  paramset[17:20, i] = dparms
    ;    ;  paramset[22, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))^parms[3]
    ;    ;  paramset[23, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))^parms[3]
    ;    ;  paramset[24, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))^parms[3]
    ;    ;  paramset[25, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))^parms[3]
    ;    ;  paramset[26, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))^parms[3]
    ;    ;  paramset[27, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))^parms[3]
    ;    ;  paramset[28, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))^parms[3]
    ;    ;  paramset[29, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))^parms[3]
    ;    ;  paramset[30, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))^parms[3]
    ;    ;  paramset[31, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))^parms[3]
    ;    ;  paramset[32, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))^parms[3]
    ;    ;  paramset[33, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))^parms[3]
    ;    ;  paramset[34, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))^parms[3]
    ;    ;  paramset[35, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))^parms[3]
    ;    ;  paramset[36, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))^parms[3]
    ;    ;  paramset[37, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))^parms[3]
    ;    ;  paramset[38, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))^parms[3]
    ;    ;  paramset[39, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))^parms[3]
    ;    ;  paramset[40, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))^parms[3]
    ;    ;  paramset[41, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))^parms[3]
    ;    ;  paramset[42, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))^parms[3]
    ;
    ;
    ;    ;  ; 3) Gompertz model (3 parameters) - all individuals
    ;    ;  startparms = [850.0D, 0.1D, -1.D]
    ;    ;  ;WLslope = 3.18
    ;    ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;    ;  pi(0).limited(1) = 0; 0=vary; 1=constant
    ;    ;  pi(0).limits(1) = 1500.
    ;    ;  MAXITER = 100000
    ;    ;  num_param = 3.
    ;    ;
    ;    ;  parms = mpfitfun('Gompertz', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxter $
    ;    ;  , perror = dparms, yfit=yfit, PARINFO=pi)
    ;    ;  Length_Gro_EstAll = parms[0] * EXP(-EXP(-parms[1] * (Age_Gro - parms[2])))
    ;    ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
    ;    ;  paramset[9:11, i] = parms
    ;    ;  paramset[14, i] = BESTNORM
    ;    ;  paramset[15, i] = DOF
    ;    ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
    ;    ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
    ;    ;  paramset[17:19, i] = dparms
    ;    ;  paramset[22, i] = parms[0] * EXP(-EXP(-parms[1] * (0. - parms[2])))
    ;    ;  paramset[23, i] = parms[0] * EXP(-EXP(-parms[1] * (1. - parms[2])))
    ;    ;  paramset[24, i] = parms[0] * EXP(-EXP(-parms[1] * (2. - parms[2])))
    ;    ;  paramset[25, i] = parms[0] * EXP(-EXP(-parms[1] * (3. - parms[2])))
    ;    ;  paramset[26, i] = parms[0] * EXP(-EXP(-parms[1] * (4. - parms[2])))
    ;    ;  paramset[27, i] = parms[0] * EXP(-EXP(-parms[1] * (5. - parms[2])))
    ;    ;  paramset[28, i] = parms[0] * EXP(-EXP(-parms[1] * (6. - parms[2])))
    ;    ;  paramset[29, i] = parms[0] * EXP(-EXP(-parms[1] * (7. - parms[2])))
    ;    ;  paramset[30, i] = parms[0] * EXP(-EXP(-parms[1] * (8. - parms[2])))
    ;    ;  paramset[31, i] = parms[0] * EXP(-EXP(-parms[1] * (9. - parms[2])))
    ;    ;  paramset[32, i] = parms[0] * EXP(-EXP(-parms[1] * (10. - parms[2])))
    ;    ;  paramset[33, i] = parms[0] * EXP(-EXP(-parms[1] * (11. - parms[2])))
    ;    ;  paramset[34, i] = parms[0] * EXP(-EXP(-parms[1] * (12. - parms[2])))
    ;    ;  paramset[35, i] = parms[0] * EXP(-EXP(-parms[1] * (13. - parms[2])))
    ;    ;  paramset[36, i] = parms[0] * EXP(-EXP(-parms[1] * (14. - parms[2])))
    ;    ;  paramset[37, i] = parms[0] * EXP(-EXP(-parms[1] * (15. - parms[2])))
    ;    ;  paramset[38, i] = parms[0] * EXP(-EXP(-parms[1] * (16. - parms[2])))
    ;    ;  paramset[39, i] = parms[0] * EXP(-EXP(-parms[1] * (17. - parms[2])))
    ;    ;  paramset[40, i] = parms[0] * EXP(-EXP(-parms[1] * (18. - parms[2])))
    ;    ;  paramset[41, i] = parms[0] * EXP(-EXP(-parms[1] * (19. - parms[2])))
    ;    ;  paramset[42, i] = parms[0] * EXP(-EXP(-parms[1] * (20. - parms[2])))
    ;
    ;
    ;    ;  ; 4) Logistic model (3 parameters) - all fish
    ;    ;   startparms = [850.0D, 0.1D, -1.D]
    ;    ;  ;WLslope = 3.18
    ;    ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;    ;  pi(0).limited(1) = 0; 0=vary; 1=constant
    ;    ;  pi(0).limits(1) = 1500.
    ;    ;  num_param = 3.
    ;    ;  MAXITER = 100000
    ;    ;
    ;    ;  parms = mpfitfun('Logistic', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxiter $
    ;    ;  , perror = dparms, yfit=yfit, PARINFO=pi)
    ;    ;  Length_Gro_EstAll = parms[0] * (1.+EXP(-parms[1] * (Age_Gro - parms[2])))^(-1.)
    ;    ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
    ;    ;  paramset[9:11, i] = parms
    ;    ;  paramset[14, i] = BESTNORM
    ;    ;  paramset[15, i] = DOF
    ;    ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
    ;    ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
    ;    ;  paramset[17:19, i] = dparms;
    ;    ;  paramset[22, i] = parms[0] * (1.+EXP(-parms[1] * (0. - parms[2])))^(-1.)
    ;    ;  paramset[23, i] = parms[0] * (1.+EXP(-parms[1] * (1. - parms[2])))^(-1.)
    ;    ;  paramset[24, i] = parms[0] * (1.+EXP(-parms[1] * (2. - parms[2])))^(-1.)
    ;    ;  paramset[25, i] = parms[0] * (1.+EXP(-parms[1] * (3. - parms[2])))^(-1.)
    ;    ;  paramset[26, i] = parms[0] * (1.+EXP(-parms[1] * (4. - parms[2])))^(-1.)
    ;    ;  paramset[27, i] = parms[0] * (1.+EXP(-parms[1] * (5. - parms[2])))^(-1.)
    ;    ;  paramset[28, i] = parms[0] * (1.+EXP(-parms[1] * (6. - parms[2])))^(-1.)
    ;    ;  paramset[29, i] = parms[0] * (1.+EXP(-parms[1] * (7. - parms[2])))^(-1.)
    ;    ;  paramset[30, i] = parms[0] * (1.+EXP(-parms[1] * (8. - parms[2])))^(-1.)
    ;    ;  paramset[31, i] = parms[0] * (1.+EXP(-parms[1] * (9. - parms[2])))^(-1.)
    ;    ;  paramset[32, i] = parms[0] * (1.+EXP(-parms[1] * (10. - parms[2])))^(-1.)
    ;    ;  paramset[33, i] = parms[0] * (1.+EXP(-parms[1] * (11. - parms[2])))^(-1.)
    ;    ;  paramset[34, i] = parms[0] * (1.+EXP(-parms[1] * (12. - parms[2])))^(-1.)
    ;    ;  paramset[35, i] = parms[0] * (1.+EXP(-parms[1] * (13. - parms[2])))^(-1.)
    ;    ;  paramset[36, i] = parms[0] * (1.+EXP(-parms[1] * (14. - parms[2])))^(-1.)
    ;    ;  paramset[37, i] = parms[0] * (1.+EXP(-parms[1] * (15. - parms[2])))^(-1.)
    ;    ;  paramset[38, i] = parms[0] * (1.+EXP(-parms[1] * (16. - parms[2])))^(-1.)
    ;    ;  paramset[39, i] = parms[0] * (1.+EXP(-parms[1] * (17. - parms[2])))^(-1.)
    ;    ;  paramset[40, i] = parms[0] * (1.+EXP(-parms[1] * (18. - parms[2])))^(-1.)
    ;    ;  paramset[41, i] = parms[0] * (1.+EXP(-parms[1] * (19. - parms[2])))^(-1.)
    ;    ;  paramset[42, i] = parms[0] * (1.+EXP(-parms[1] * (20. - parms[2])))^(-1.)
    ;
    ;
    ;    ;  ; 5) Schnute-Richards model (5 parameters) - all fish
    ;    ;  startparms = [850.0D, -0.005D, 0.3D, 0.8D, 0.003D]
    ;    ;  ;845 -0.0046  0.27  0.78  0.0025
    ;    ;  ;WLslope = 3.18
    ;    ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 5)
    ;    ;  pi(0).limited(1) = 0; 0=vary; 1=constant
    ;    ;  pi(0).limits(1) = 1500.
    ;    ;  MAXITER = 100000
    ;    ;  num_param = 5.
    ;    ;
    ;    ;  parms = mpfitfun('Schnute_Richards', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER=MAXITER $
    ;    ;          , perror = dparms, yfit=yfit, PARINFO=pi)
    ;    ;  Length_Gro_EstAll = parms[0] * (1+parms[1]*EXP(-parms[2] * Age_Gro^parms[3]))^(1/parms[4])
    ;    ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
    ;    ;  paramset[9:13, i] = parms
    ;    ;  paramset[14, i] = BESTNORM
    ;    ;  paramset[15, i] = DOF
    ;    ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
    ;    ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
    ;    ;  paramset[17:21, i] = dparms
    ;    ;  paramset[22, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 0.^parms[3]))^(1/parms[4])
    ;    ;  paramset[23, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 1.^parms[3]))^(1/parms[4])
    ;    ;  paramset[24, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 2.^parms[3]))^(1/parms[4])
    ;    ;  paramset[25, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 3.^parms[3]))^(1/parms[4])
    ;    ;  paramset[26, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 4.^parms[3]))^(1/parms[4])
    ;    ;  paramset[27, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 5.^parms[3]))^(1/parms[4])
    ;    ;  paramset[28, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 6.^parms[3]))^(1/parms[4])
    ;    ;  paramset[29, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 7.^parms[3]))^(1/parms[4])
    ;    ;  paramset[30, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 8.^parms[3]))^(1/parms[4])
    ;    ;  paramset[31, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 9.^parms[3]))^(1/parms[4])
    ;    ;  paramset[32, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 10.^parms[3]))^(1/parms[4])
    ;    ;  paramset[33, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 11.^parms[3]))^(1/parms[4])
    ;    ;  paramset[34, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 12.^parms[3]))^(1/parms[4])
    ;    ;  paramset[35, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 13.^parms[3]))^(1/parms[4])
    ;    ;  paramset[36, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 14.^parms[3]))^(1/parms[4])
    ;    ;  paramset[37, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 15.^parms[3]))^(1/parms[4])
    ;    ;  paramset[38, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 16.^parms[3]))^(1/parms[4])
    ;    ;  paramset[39, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 17.^parms[3]))^(1/parms[4])
    ;    ;  paramset[40, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 18.^parms[3]))^(1/parms[4])
    ;    ;  paramset[41, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 19.^parms[3]))^(1/parms[4])
    ;    ;  paramset[42, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 20.^parms[3]))^(1/parms[4])
    ;
    ;
    ;    ;  ; 6)Log-linear model - all individuals
    ;    ;  startparms = [0.D, 0.D]
    ;    ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
    ;    ;  parms = mpfitfun('logLinear', (Age_Gro), Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)
    ;    ;  Length_Gro_EstAll = parms[0] * alog(Age_Gro) + parms[1]
    ;    ;  OPLOT, alog(Age_Gro), Length_Gro_EstAll, THICK = 2
    ;    ;   paramset[9:10, i] = parms
    ;
    ;
    ;    IF MALECOUNT GT 0 THEN BEGIN
    ;      paramset[43, i] = NumageclassM
    ;      paramset[44, i] = MaxageclassM
    ;      paramset[45, i] = MinageclassM
    ;      paramset[46, i] = MAX(Length_Gro[MALE])
    ;      paramset[47, i] = MIN(Length_Gro[MALE])
    ;
    ;      ;    ; 1) standard von Bertanffy model (3 parameters) - males
    ;      ;    ;startparms = [[850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;
    ;      ;    parms = mpfitfun('vonBertalanffy', Age_Gro[MALE], Length_Gro[MALE], DOF=dof, dy, startparms, BESTNORM=bestnorm, MAXITER = MAXITER $
    ;      ;    , perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE] - parms[2])));^WLslope
    ;      ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
    ;      ;    paramset[48:50, i] = parms
    ;      ;    paramset[53, i] = BESTNORM
    ;      ;    paramset[54, i] = DOF
    ;      ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
    ;      ;    paramset[56:58, i] = dparms
    ;      ;    paramset[61, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
    ;      ;    paramset[62, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
    ;      ;    paramset[63, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
    ;      ;    paramset[64, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
    ;      ;    paramset[65, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
    ;      ;    paramset[66, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
    ;      ;    paramset[67, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
    ;      ;    paramset[68, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
    ;      ;    paramset[69, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
    ;      ;    paramset[70, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
    ;      ;    paramset[71, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
    ;      ;    paramset[72, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
    ;      ;    paramset[73, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
    ;      ;    paramset[74, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
    ;      ;    paramset[75, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
    ;      ;    paramset[76, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
    ;      ;    paramset[77, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
    ;      ;    paramset[78, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
    ;      ;    paramset[79, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
    ;      ;    paramset[80, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
    ;      ;    paramset[81, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
    ;
    ;
    ;      ;    ; 2) generalized von Bertanffy model - males
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('GvonBertalanffy', Age_Gro[MALE], Length_Gro[MALE],  DOF=dof, dy, startparms, BESTNORM=bestnorm, MAXITER = MAXITER $
    ;      ;    , perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))^parms[3];^WLslope
    ;      ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
    ;      ;    paramset[48:51, i] = parms
    ;      ;    paramset[53, i] = BESTNORM
    ;      ;    paramset[54, i] = DOF
    ;      ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
    ;      ;    paramset[56:59, i] = dparms
    ;      ;    paramset[61, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))^parms[3]
    ;      ;    paramset[62, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))^parms[3]
    ;      ;    paramset[63, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))^parms[3]
    ;      ;    paramset[64, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))^parms[3]
    ;      ;    paramset[65, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))^parms[3]
    ;      ;    paramset[66, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))^parms[3]
    ;      ;    paramset[67, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))^parms[3]
    ;      ;    paramset[68, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))^parms[3]
    ;      ;    paramset[69, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))^parms[3]
    ;      ;    paramset[70, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))^parms[3]
    ;      ;    paramset[71, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))^parms[3]
    ;      ;    paramset[72, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))^parms[3]
    ;      ;    paramset[73, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))^parms[3]
    ;      ;    paramset[74, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))^parms[3]
    ;      ;    paramset[75, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))^parms[3]
    ;      ;    paramset[76, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))^parms[3]
    ;      ;    paramset[77, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))^parms[3]
    ;      ;    paramset[78, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))^parms[3]
    ;      ;    paramset[79, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))^parms[3]
    ;      ;    paramset[80, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))^parms[3]
    ;      ;    paramset[81, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))^parms[3]
    ;
    ;
    ;      ;    ; 3) Gompertz model (3 parameters) - males
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('Gompertz', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, $
    ;      ;    perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstMale = parms[0] * EXP(-EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))
    ;      ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
    ;      ;    paramset[48:50, i] = parms
    ;      ;    paramset[53, i] = BESTNORM
    ;      ;    paramset[54, i] = DOF
    ;      ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
    ;      ;    paramset[56:58, i] = dparms
    ;      ;    paramset[61, i] = parms[0] * EXP(-EXP(-parms[1] * (0. - parms[2])))
    ;      ;    paramset[62, i] = parms[0] * EXP(-EXP(-parms[1] * (1. - parms[2])))
    ;      ;    paramset[63, i] = parms[0] * EXP(-EXP(-parms[1] * (2. - parms[2])))
    ;      ;    paramset[64, i] = parms[0] * EXP(-EXP(-parms[1] * (3. - parms[2])))
    ;      ;    paramset[65, i] = parms[0] * EXP(-EXP(-parms[1] * (4. - parms[2])))
    ;      ;    paramset[66, i] = parms[0] * EXP(-EXP(-parms[1] * (5. - parms[2])))
    ;      ;    paramset[67, i] = parms[0] * EXP(-EXP(-parms[1] * (6. - parms[2])))
    ;      ;    paramset[68, i] = parms[0] * EXP(-EXP(-parms[1] * (7. - parms[2])))
    ;      ;    paramset[69, i] = parms[0] * EXP(-EXP(-parms[1] * (8. - parms[2])))
    ;      ;    paramset[70, i] = parms[0] * EXP(-EXP(-parms[1] * (9. - parms[2])))
    ;      ;    paramset[71, i] = parms[0] * EXP(-EXP(-parms[1] * (10. - parms[2])))
    ;      ;    paramset[72, i] = parms[0] * EXP(-EXP(-parms[1] * (11. - parms[2])))
    ;      ;    paramset[73, i] = parms[0] * EXP(-EXP(-parms[1] * (12. - parms[2])))
    ;      ;    paramset[74, i] = parms[0] * EXP(-EXP(-parms[1] * (13. - parms[2])))
    ;      ;    paramset[75, i] = parms[0] * EXP(-EXP(-parms[1] * (14. - parms[2])))
    ;      ;    paramset[76, i] = parms[0] * EXP(-EXP(-parms[1] * (15. - parms[2])))
    ;      ;    paramset[77, i] = parms[0] * EXP(-EXP(-parms[1] * (16. - parms[2])))
    ;      ;    paramset[78, i] = parms[0] * EXP(-EXP(-parms[1] * (17. - parms[2])))
    ;      ;    paramset[79, i] = parms[0] * EXP(-EXP(-parms[1] * (18. - parms[2])))
    ;      ;    paramset[80, i] = parms[0] * EXP(-EXP(-parms[1] * (19. - parms[2])))
    ;      ;    paramset[81, i] = parms[0] * EXP(-EXP(-parms[1] * (20. - parms[2])))
    ;
    ;
    ;      ;    ; 4) Logistic model (3 parameters) - males
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('Logistic', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstMale = parms[0] * (1.+EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))^(-1.)
    ;      ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
    ;      ;    paramset[48:50, i] = parms
    ;      ;    paramset[53, i] = BESTNORM
    ;      ;    paramset[54, i] = DOF
    ;      ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
    ;      ;    paramset[56:58, i] = dparms
    ;      ;    paramset[61, i] = parms[0] * (1.+EXP(-parms[1] * (0.- parms[2])))^(-1.)
    ;      ;    paramset[62, i] = parms[0] * (1.+EXP(-parms[1] * (1.- parms[2])))^(-1.)
    ;      ;    paramset[63, i] = parms[0] * (1.+EXP(-parms[1] * (2.- parms[2])))^(-1.)
    ;      ;    paramset[64, i] = parms[0] * (1.+EXP(-parms[1] * (3.- parms[2])))^(-1.)
    ;      ;    paramset[65, i] = parms[0] * (1.+EXP(-parms[1] * (4.- parms[2])))^(-1.)
    ;      ;    paramset[66, i] = parms[0] * (1.+EXP(-parms[1] * (5.- parms[2])))^(-1.)
    ;      ;    paramset[67, i] = parms[0] * (1.+EXP(-parms[1] * (6.- parms[2])))^(-1.)
    ;      ;    paramset[68, i] = parms[0] * (1.+EXP(-parms[1] * (7.- parms[2])))^(-1.)
    ;      ;    paramset[69, i] = parms[0] * (1.+EXP(-parms[1] * (8.- parms[2])))^(-1.)
    ;      ;    paramset[70, i] = parms[0] * (1.+EXP(-parms[1] * (9.- parms[2])))^(-1.)
    ;      ;    paramset[71, i] = parms[0] * (1.+EXP(-parms[1] * (10.- parms[2])))^(-1.)
    ;      ;    paramset[72, i] = parms[0] * (1.+EXP(-parms[1] * (11.- parms[2])))^(-1.)
    ;      ;    paramset[73, i] = parms[0] * (1.+EXP(-parms[1] * (12.- parms[2])))^(-1.)
    ;      ;    paramset[74, i] = parms[0] * (1.+EXP(-parms[1] * (13.- parms[2])))^(-1.)
    ;      ;    paramset[75, i] = parms[0] * (1.+EXP(-parms[1] * (14.- parms[2])))^(-1.)
    ;      ;    paramset[76, i] = parms[0] * (1.+EXP(-parms[1] * (15.- parms[2])))^(-1.)
    ;      ;    paramset[77, i] = parms[0] * (1.+EXP(-parms[1] * (16.- parms[2])))^(-1.)
    ;      ;    paramset[78, i] = parms[0] * (1.+EXP(-parms[1] * (17.- parms[2])))^(-1.)
    ;      ;    paramset[79, i] = parms[0] * (1.+EXP(-parms[1] * (18.- parms[2])))^(-1.)
    ;      ;    paramset[80, i] = parms[0] * (1.+EXP(-parms[1] * (19.- parms[2])))^(-1.)
    ;      ;    paramset[81, i] = parms[0] * (1.+EXP(-parms[1] * (20.- parms[2])))^(-1.)
    ;
    ;      ;
    ;      ;    ; 5) Schnute-Richards model (3 parameters) - males
    ;      ;    ;startparms = [800.0D, 0.4D, -0.15D]
    ;      ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('Schnute_Richards', Age_Gro[MALE], Length_Gro[MALE], dy, DOF=dof, startparms, BESTNORM=bestnorm, MAXITER=MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstMale = parms[0] * (1+parms[1]*EXP(-parms[2] * Age_Gro[MALE]^parms[3]))^(1/parms[4])
    ;      ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
    ;      ;    paramset[48:52, i] = parms
    ;      ;    paramset[53, i] = BESTNORM
    ;      ;    paramset[54, i] = DOF
    ;      ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
    ;      ;    paramset[56:60, i] = dparms
    ;      ;    paramset[61, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 0.^parms[3]))^(1/parms[4])
    ;      ;    paramset[62, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 1.^parms[3]))^(1/parms[4])
    ;      ;    paramset[63, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 2.^parms[3]))^(1/parms[4])
    ;      ;    paramset[64, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 3.^parms[3]))^(1/parms[4])
    ;      ;    paramset[65, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 4.^parms[3]))^(1/parms[4])
    ;      ;    paramset[66, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 5.^parms[3]))^(1/parms[4])
    ;      ;    paramset[67, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 6.^parms[3]))^(1/parms[4])
    ;      ;    paramset[68, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 7.^parms[3]))^(1/parms[4])
    ;      ;    paramset[69, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 8.^parms[3]))^(1/parms[4])
    ;      ;    paramset[70, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 9.^parms[3]))^(1/parms[4])
    ;      ;    paramset[71, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 10.^parms[3]))^(1/parms[4])
    ;      ;    paramset[72, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 11.^parms[3]))^(1/parms[4])
    ;      ;    paramset[73, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 12.^parms[3]))^(1/parms[4])
    ;      ;    paramset[74, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 13.^parms[3]))^(1/parms[4])
    ;      ;    paramset[75, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 14.^parms[3]))^(1/parms[4])
    ;      ;    paramset[76, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 15.^parms[3]))^(1/parms[4])
    ;      ;    paramset[77, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 16.^parms[3]))^(1/parms[4])
    ;      ;    paramset[78, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 17.^parms[3]))^(1/parms[4])
    ;      ;    paramset[79, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 18.^parms[3]))^(1/parms[4])
    ;      ;    paramset[80, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 19.^parms[3]))^(1/parms[4])
    ;      ;    paramset[81, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 20.^parms[3]))^(1/parms[4])
    ;
    ;
    ;      ;  ; 6) log-linear model - males
    ;      ;  startparms = [0.D, 0.D]
    ;      ;  dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
    ;      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
    ;      ;  parms = mpfitfun('logLinear', (Age_Gro[MALE]), Length_Gro[MALE], dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;  Length_Gro_EstMale = parms[0] * alog(Age_Gro[male]) + parms[1]
    ;      ;  OPLOT, alog(Age_Gro[MALE]), Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
    ;      ;  paramset[16:17, i] = parms
    ;
    ;      ;  parinfo = replicate({value:0.0, fixed:0, limited:[0,0], limits:[0.0,0.0]}, 3)
    ;      ;  parinfo[0].limited[1] = 0; parameter 0, the amplitude, has a lower bound
    ;      ;  parinfo[0].limits[1] = 2000.0; do not accept values less than zero
    ;      ;  parinfo[0].fixed = 0
    ;      ;  parinfo[0].value = 600.
    ;      ;  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=parinfo)
    ;    ENDIF
    ;
    ;
    ;    IF FEMALECOUNT GT 0 THEN BEGIN
    ;      paramset[82, i] = NumageclassF
    ;      paramset[83, i] = MaxageclassF
    ;      paramset[84, i] = MinageclassF
    ;      paramset[85, i] = MAX(Length_Gro[FEMALE])
    ;      paramset[86, i] = MIN(Length_Gro[FEMALE])
    ;
    ;      ;    ; 1) standard von Bertalanffy model - females
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;
    ;      ;    parms = mpfitfun('vonBertalanffy', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, $
    ;      ;    MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstFemale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])));^WLslope
    ;      ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
    ;      ;    paramset[87:89, i] = parms
    ;      ;    paramset[92, i] = BESTNORM
    ;      ;    paramset[93, i] = DOF
    ;      ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
    ;      ;    paramset[95:97, i] = dparms
    ;      ;    paramset[100, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
    ;      ;    paramset[101, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
    ;      ;    paramset[102, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
    ;      ;    paramset[103, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
    ;      ;    paramset[104, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
    ;      ;    paramset[105, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
    ;      ;    paramset[106, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
    ;      ;    paramset[107, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
    ;      ;    paramset[108, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
    ;      ;    paramset[109, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
    ;      ;    paramset[110, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
    ;      ;    paramset[111, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
    ;      ;    paramset[112, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
    ;      ;    paramset[113, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
    ;      ;    paramset[114, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
    ;      ;    paramset[115, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
    ;      ;    paramset[116, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
    ;      ;    paramset[117, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
    ;      ;    paramset[118, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
    ;      ;    paramset[119, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
    ;      ;    paramset[120, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
    ;
    ;
    ;      ;    ; 2) generalized von Bertalanffy model - females
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('GvonBertalanffy', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm $
    ;      ;    , MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstFemale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))^parms[3];^WLslope
    ;      ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
    ;      ;    paramset[87:90, i] = parms
    ;      ;    paramset[92, i] = BESTNORM
    ;      ;    paramset[93, i] = DOF
    ;      ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
    ;      ;    paramset[95:98, i] = dparms
    ;      ;    paramset[100, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))^parms[3]
    ;      ;    paramset[101, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))^parms[3]
    ;      ;    paramset[102, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))^parms[3]
    ;      ;    paramset[103, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))^parms[3]
    ;      ;    paramset[104, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))^parms[3]
    ;      ;    paramset[105, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))^parms[3]
    ;      ;    paramset[106, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))^parms[3]
    ;      ;    paramset[107, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))^parms[3]
    ;      ;    paramset[108, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))^parms[3]
    ;      ;    paramset[109, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))^parms[3]
    ;      ;    paramset[110, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))^parms[3]
    ;      ;    paramset[111, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))^parms[3]
    ;      ;    paramset[112, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))^parms[3]
    ;      ;    paramset[113, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))^parms[3]
    ;      ;    paramset[114, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))^parms[3]
    ;      ;    paramset[115, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))^parms[3]
    ;      ;    paramset[116, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))^parms[3]
    ;      ;    paramset[117, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))^parms[3]
    ;      ;    paramset[118, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))^parms[3]
    ;      ;    paramset[119, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))^parms[3]
    ;      ;    paramset[120, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))^parms[3]
    ;
    ;
    ;      ;    ; 3) Gompertz model - females
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('Gompertz', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm $
    ;      ;    , MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstFemale = parms[0] * EXP(-EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))
    ;      ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
    ;      ;    paramset[87:89, i] = parms
    ;      ;    paramset[92, i] = BESTNORM
    ;      ;    paramset[93, i] = DOF
    ;      ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
    ;      ;    paramset[95:97, i] = dparms
    ;      ;    paramset[100, i] = parms[0] * EXP(-EXP(-parms[1] * (0. - parms[2])))
    ;      ;    paramset[101, i] = parms[0] * EXP(-EXP(-parms[1] * (1. - parms[2])))
    ;      ;    paramset[102, i] = parms[0] * EXP(-EXP(-parms[1] * (2. - parms[2])))
    ;      ;    paramset[103, i] = parms[0] * EXP(-EXP(-parms[1] * (3. - parms[2])))
    ;      ;    paramset[104, i] = parms[0] * EXP(-EXP(-parms[1] * (4. - parms[2])))
    ;      ;    paramset[105, i] = parms[0] * EXP(-EXP(-parms[1] * (5. - parms[2])))
    ;      ;    paramset[106, i] = parms[0] * EXP(-EXP(-parms[1] * (6. - parms[2])))
    ;      ;    paramset[107, i] = parms[0] * EXP(-EXP(-parms[1] * (7. - parms[2])))
    ;      ;    paramset[108, i] = parms[0] * EXP(-EXP(-parms[1] * (8. - parms[2])))
    ;      ;    paramset[109, i] = parms[0] * EXP(-EXP(-parms[1] * (9. - parms[2])))
    ;      ;    paramset[110, i] = parms[0] * EXP(-EXP(-parms[1] * (10. - parms[2])))
    ;      ;    paramset[111, i] = parms[0] * EXP(-EXP(-parms[1] * (11. - parms[2])))
    ;      ;    paramset[112, i] = parms[0] * EXP(-EXP(-parms[1] * (12. - parms[2])))
    ;      ;    paramset[113, i] = parms[0] * EXP(-EXP(-parms[1] * (13. - parms[2])))
    ;      ;    paramset[114, i] = parms[0] * EXP(-EXP(-parms[1] * (14. - parms[2])))
    ;      ;    paramset[115, i] = parms[0] * EXP(-EXP(-parms[1] * (15. - parms[2])))
    ;      ;    paramset[116, i] = parms[0] * EXP(-EXP(-parms[1] * (16. - parms[2])))
    ;      ;    paramset[117, i] = parms[0] * EXP(-EXP(-parms[1] * (17. - parms[2])))
    ;      ;    paramset[118, i] = parms[0] * EXP(-EXP(-parms[1] * (18. - parms[2])))
    ;      ;    paramset[119, i] = parms[0] * EXP(-EXP(-parms[1] * (19. - parms[2])))
    ;      ;    paramset[120, i] = parms[0] * EXP(-EXP(-parms[1] * (20. - parms[2])))
    ;
    ;
    ;      ;    ; 4) Logistic model - females
    ;      ;    ;startparms = [850.0D, 0.1D, -1.D]
    ;      ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('Logistic', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, DOF=dof, startparms,  BESTNORM=bestnorm, MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstFemale = parms[0] * (1.+EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))^(-1.)
    ;      ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
    ;      ;    paramset[87:89, i] = parms
    ;      ;    paramset[92, i] = BESTNORM
    ;      ;    paramset[93, i] = DOF
    ;      ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
    ;      ;    paramset[95:97, i] = dparms
    ;      ;    paramset[100, i] = parms[0] * (1.+EXP(-parms[1] * (0. - parms[2])))^(-1.)
    ;      ;    paramset[101, i] = parms[0] * (1.+EXP(-parms[1] * (1. - parms[2])))^(-1.)
    ;      ;    paramset[102, i] = parms[0] * (1.+EXP(-parms[1] * (2. - parms[2])))^(-1.)
    ;      ;    paramset[103, i] = parms[0] * (1.+EXP(-parms[1] * (3. - parms[2])))^(-1.)
    ;      ;    paramset[104, i] = parms[0] * (1.+EXP(-parms[1] * (4. - parms[2])))^(-1.)
    ;      ;    paramset[105, i] = parms[0] * (1.+EXP(-parms[1] * (5. - parms[2])))^(-1.)
    ;      ;    paramset[106, i] = parms[0] * (1.+EXP(-parms[1] * (6. - parms[2])))^(-1.)
    ;      ;    paramset[107, i] = parms[0] * (1.+EXP(-parms[1] * (7. - parms[2])))^(-1.)
    ;      ;    paramset[108, i] = parms[0] * (1.+EXP(-parms[1] * (8. - parms[2])))^(-1.)
    ;      ;    paramset[109, i] = parms[0] * (1.+EXP(-parms[1] * (9. - parms[2])))^(-1.)
    ;      ;    paramset[110, i] = parms[0] * (1.+EXP(-parms[1] * (10. - parms[2])))^(-1.)
    ;      ;    paramset[111, i] = parms[0] * (1.+EXP(-parms[1] * (11. - parms[2])))^(-1.)
    ;      ;    paramset[112, i] = parms[0] * (1.+EXP(-parms[1] * (12. - parms[2])))^(-1.)
    ;      ;    paramset[113, i] = parms[0] * (1.+EXP(-parms[1] * (13. - parms[2])))^(-1.)
    ;      ;    paramset[114, i] = parms[0] * (1.+EXP(-parms[1] * (14. - parms[2])))^(-1.)
    ;      ;    paramset[115, i] = parms[0] * (1.+EXP(-parms[1] * (15. - parms[2])))^(-1.)
    ;      ;    paramset[116, i] = parms[0] * (1.+EXP(-parms[1] * (16. - parms[2])))^(-1.)
    ;      ;    paramset[117, i] = parms[0] * (1.+EXP(-parms[1] * (17. - parms[2])))^(-1.)
    ;      ;    paramset[118, i] = parms[0] * (1.+EXP(-parms[1] * (18. - parms[2])))^(-1.)
    ;      ;    paramset[119, i] = parms[0] * (1.+EXP(-parms[1] * (19. - parms[2])))^(-1.)
    ;      ;    paramset[120, i] = parms[0] * (1.+EXP(-parms[1] * (20. - parms[2])))^(-1.)
    ;
    ;
    ;      ;    ; 5) Schnute-Richards model - females
    ;      ;    ;startparms = [800.0D, 0.4D, -0.15D]
    ;      ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;      ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;      ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;      ;    ;pi(0).limits(1) = 2000.
    ;      ;    parms = mpfitfun('Schnute_Richards', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, DOF=dof, startparms, BESTNORM=bestnorm, MAXITER=MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;    Length_Gro_EstFemale = parms[0] * (1+parms[1]*EXP(-parms[2] * Age_Gro[FEMALE]^parms[3]))^(1/parms[4])
    ;      ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
    ;      ;    paramset[87:91, i] = parms
    ;      ;    paramset[92, i] = BESTNORM
    ;      ;    paramset[93, i] = DOF
    ;      ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
    ;      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
    ;      ;    paramset[95:99, i] = dparms
    ;      ;    paramset[100, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 0.^parms[3]))^(1/parms[4])
    ;      ;    paramset[101, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 1.^parms[3]))^(1/parms[4])
    ;      ;    paramset[102, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 2.^parms[3]))^(1/parms[4])
    ;      ;    paramset[103, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 3.^parms[3]))^(1/parms[4])
    ;      ;    paramset[104, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 4.^parms[3]))^(1/parms[4])
    ;      ;    paramset[105, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 5.^parms[3]))^(1/parms[4])
    ;      ;    paramset[106, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 6.^parms[3]))^(1/parms[4])
    ;      ;    paramset[107, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 7.^parms[3]))^(1/parms[4])
    ;      ;    paramset[108, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 8.^parms[3]))^(1/parms[4])
    ;      ;    paramset[109, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 9.^parms[3]))^(1/parms[4])
    ;      ;    paramset[110, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 10.^parms[3]))^(1/parms[4])
    ;      ;    paramset[111, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 11.^parms[3]))^(1/parms[4])
    ;      ;    paramset[112, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 12.^parms[3]))^(1/parms[4])
    ;      ;    paramset[113, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 13.^parms[3]))^(1/parms[4])
    ;      ;    paramset[114, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 14.^parms[3]))^(1/parms[4])
    ;      ;    paramset[115, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 15.^parms[3]))^(1/parms[4])
    ;      ;    paramset[116, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 16.^parms[3]))^(1/parms[4])
    ;      ;    paramset[117, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 17.^parms[3]))^(1/parms[4])
    ;      ;    paramset[118, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 18.^parms[3]))^(1/parms[4])
    ;      ;    paramset[119, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 19.^parms[3]))^(1/parms[4])
    ;      ;    paramset[120, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 20.^parms[3]))^(1/parms[4])
    ;
    ;
    ;      ;; 6) log-linear model -females
    ;      ;  startparms = [0.D, 1.D]
    ;      ;  dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
    ;      ;  parms = mpfitfun('logLinear', (Age_Gro[feMALE]), Length_Gro[feMALE], dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)
    ;      ;  Length_Gro_EstfeMale = parms[0] * alog(Age_Gro[female]) + parms[1]
    ;      ;  OPLOT, alog(Age_Gro[FEMALE]), Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
    ;      ;  paramset[23:27, i] = parms
    ;
    ;    ENDIF
    ;
    ;    WRITE_PNG, filename, TVRD()

    ; store parameter values
    ;Linf[i] = Linf_gro
    ;K[i] = K_gro2
    ;t0[i] = t0_gro

  ENDFOR; END OF WBIC_  year loop
  ;print, WAE_length_bin;[*, i:i+NumAgeClass*35L]


  ;; Check if parameter values are valid
  ;InvalidParamset = WHERE(paramset[4, *] GT 2000., InvalidParamsetcount, complement = validparamset, ncomplement = validparamsetcount)
  ;IF InvalidParamsetcount GT 0 THEN PRINT, 'Invalid parameter sets' $
  ;;                , paramset[*, InvalidParamset] $
  ;                , 'N of invalid parameter set: ', InvalidParamsetcount
  ;
  ;IF ValidParamsetcount GT 0 THEN PRINT, 'Valid parameter sets' $
  ; ;               , paramset[*, validParamset] $
  ;                , 'N of valid parameter set: ', validParamsetcount
  ;PRINT, 'ALL WBIC_YEAR parameters'
  ;PRINT, paramset

  ;Data = paramset
  INDEX_length_age = WHERE(WAE_length_bin[1, *] GT 0., INDEX_length_agecount)

  Data = WAE_length_bin;[*, INDEX_length_age]

  filename1 = 'Output_walleye_age-length_key.csv'
  ;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
  s = Size(data, /Dimensions)
  xsize = s[0]
  lineWidth = 16000000
  comma = ","

  ; Open the data file for writing.
  OpenW, lun, filename1, /Get_Lun, Width=lineWidth

  ;; Open the data file for writing.
  ;IF pointer1 EQ 0L THEN OpenW, lun, filename1, /Get_Lun, Width=lineWidth
  ;IF pointer1 GT 0L THEN BEGIN;
  ;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
  ;  SKIP_LUN, lun, pointer1, /lines
  ;  READF, lun
  ;ENDIF

  ; Write the data to the file.
  sData = StrTrim(double(data), 2)
  sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
  PrintF, lun, sData

  ; Close the file.
  Free_Lun, lun


  uniqWBIC_growth = paramset[2, UNIQ(paramset[2,*], SORT(paramset[2,*]))]
  print, N_elements(uniqWBIC_growth)
  NWBIC_growth = fltarr(5, N_elements(uniqWBIC_growth))
  FOR i = 0L, N_ELEMENTS(uniqWBIC_growth)-1L DO BEGIN
    WBIC_growth = WHERE(paramset[2,*] EQ uniqWBIC_growth[i], WBIC_growthcount)
    NWBIC_growth[0, i] = uniqWBIC_growth[i]
    NWBIC_growth[1, i] = WBIC_growthcount
    NWBIC_growth[2, i] = max(paramset[3,WBIC_growth])
    NWBIC_growth[3, i] = min(paramset[3,WBIC_growth])
    NWBIC_growth[4, i] = max(paramset[3,WBIC_growth]) - min(paramset[3,WBIC_growth])
    ;print,'Number of unique WBIC',WBIC_growthcount
  ENDFOR
  ;print,NWBIC_growth

  NminYears = 4L
  NWBIC_growthGEmin = where(NWBIC_growth[1, *] GE NminYears, NWBIC_growthGEmincount)
  ;print, NWBIC_growthGEmincount, NWBIC_growth[*, NWBIC_growthGEmin]

  Data2 = NWBIC_growth[*, NWBIC_growthGEmin]

  filename2 = 'SelectOutput_Walleye_Growth.csv'
  ;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
  s = Size(data2, /Dimensions)
  xsize = s[0]
  lineWidth = 16000000
  comma = ","

  ; Open the data file for writing.
  OpenW, lun, filename2, /Get_Lun, Width=lineWidth

  ; Write the data to the file.
  sData2 = StrTrim(double(data2), 2)
  sData2[0:xsize-2, *] = sData2[0:xsize-2, *] + comma
  PrintF, lun, sData2

  ; Close the file.
  Free_Lun, lun

  ;N = 107866L; 162 * 365
  ;Data_Final = DOUBLE(FLTARR(8L, N)); WBIC = 1
  ;NWBIC_growth = fltarr(5, N_elements(uniqWBIC_growth))

  FOR i = 0L, N_ELEMENTS(Data2[0, *])-1L DO BEGIN
    SelectData_Final = WHERE(Data_Final[1, *] EQ Data2[0, i], Data_Final2count)

    IF i EQ 0L THEN SelectData_Final2 = Data_Final[*, SelectData_Final]
    IF i GT 0L THEN SelectData_Final2 = TRANSPOSE([TRANSPOSE(SelectData_Final2), TRANSPOSE(Data_Final[*, SelectData_Final])])

  ENDFOR
  ;print,NWBIC_growth

  Data3 = SelectData_Final2

  filename3 = 'SelectOutput_Walleye_Growth_FULL.csv'
  ;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
  s = Size(data3, /Dimensions)
  xsize = s[0]
  lineWidth = 16000000
  comma = ","

  ; Open the data file for writing.
  OpenW, lun, filename3, /Get_Lun, Width=lineWidth

  ; Write the data to the file.
  sData3 = StrTrim(double(data3), 2)
  sData3[0:xsize-2, *] = sData3[0:xsize-2, *] + comma
  PrintF, lun, sData3

  ; Close the file.
  Free_Lun, lun

  ; Age-specific size data for each lake
  Data4 = WAE_size_age

  filename4 = 'Walleye_size-at-age.csv'
  ;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
  s = Size(data4, /Dimensions)
  xsize = s[0]
  lineWidth = 16000000
  comma = ","

  ; Open the data file for writing.
  OpenW, lun, filename4, /Get_Lun, Width=lineWidth

  ; Write the data to the file.
  sData4 = StrTrim(double(data4), 2)
  sData4[0:xsize-2, *] = sData4[0:xsize-2, *] + comma
  PrintF, lun, sData4

  ; Close the file.
  Free_Lun, lun

  ; Age-specific size data for each lake
  Data5 = WAE_size_age_all

  filename5 = 'Walleye_size-at-age-all.csv'
  ;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
  s = Size(data5, /Dimensions)
  xsize = s[0]
  lineWidth = 16000000
  comma = ","

  ; Open the data file for writing.
  OpenW, lun, filename5, /Get_Lun, Width=lineWidth

  ; Write the data to the file.
  sData5 = StrTrim(double(data5), 2)
  sData5[0:xsize-2, *] = sData5[0:xsize-2, *] + comma
  PrintF, lun, sData5

  ; Close the file.
  Free_Lun, lun

  t_elapsed = SYSTIME(/seconds) - tstart
  PRINT, 'Elapesed time (seconds):', t_elapsed
  PRINT, 'Elapesed time (minutes):', t_elapsed/60.
  ;RETURN, ???; TURN OFF WHEN TESTING
END
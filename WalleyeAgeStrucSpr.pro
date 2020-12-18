;########################################################################################################
PRO WalleyeAgeStrucSpr
; converting length to age for WI walleye data 
; calcualted total production of WI walleye from spring surveys and tribal harvest from creel surveys
PRINT, 'a function to convert length to age for walleye stocks in Wisconsin, USA'
PRINT, 'Created: Apr 26, 2014'
PRINT, 'Updated: Jun 5, 2015'
;########################################################################################################

tstart = SYSTIME(/seconds);

; Identify a direcotry for exporting daily output of state variables as .csv file
CD, 'C:\Users\Daisuke\Desktop\Walleye_production_project\Walleye outputs'

; Input file paths
; 1.walleye length data from spring surveys
file = FILEPATH('walleye_length_PE_data3_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 2.Length key with lake-years
file2 = FILEPATH('walleye_age_length_key_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 3.Length key with lake only
file3 = FILEPATH('walleye_age_length_key_lake_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 4.Length key for region-wide
file4 = FILEPATH('walleye_age_length_key_region_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 5.YOY data
file5 = FILEPATH('walleye_YOY_data_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 6.Length data from creel surveys (Spearing)
file6 = FILEPATH('walleye_length_N_Spr_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 7.length-mass function parameters - lake-year-specific
file7 = FILEPATH('WI.wae_grow_lmem_ranef_lake-year_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')
; 8.length-mass function parameters - lake-specific
file8 = FILEPATH('WI.wae_grow_lmem_ranef_lake_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')

; Check if the file is not blank
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Read the file
; Input file order
; Define the data structure
;N = 272935L                                  ; survey data
N = 289450L                                   ; survey data - data set3
Nkey = 24864L                                 ; lake-year-specific age-length key
Nkey2 = 13542L                                ; lake-specific age-length key
Nkey3 = 37L                                   ; region-wide age-length key
Nyoy = 2340L
NSpr = 57326L                                 ; harvested fish
Nlm = 1050L                            ; lake-year-specific length-mass parameters
Nlm2 = 508L                           ; lake-specific length-mass parameters

Length_Data = DOUBLE(FLTARR(14L, N))
Length_key = DOUBLE(FLTARR(93L, Nkey))
Length_key2 = DOUBLE(FLTARR(93L, Nkey2))
Length_key3 = DOUBLE(FLTARR(93L, Nkey3))
YOY_data = DOUBLE(FLTARR(6L, Nyoy))
Length_Spr_data = DOUBLE(FLTARR(10L, NSpr))
AgeArray = -1+FLTARR(N)
LengthArray = FLTARR(N)
AgeArraySpr = -1+FLTARR(NSpr)
LengthArraySpr = FLTARR(NSpr)
Length_mass_par = DOUBLE(FLTARR(6L, Nlm))
Length_mass_par2 = DOUBLE(FLTARR(3L, Nlm2))

; read input length & PE data
OPENR, lun, file, /GET_LUN
READF, lun, Length_Data;, FORMAT='(A17, x, I0)';
WBIC_Year = Length_Data[0, *]
WBIC = Length_Data[1, *]
SurveyYear = Length_Data[2, *]
Length = Length_Data[3, *]
Sex = Length_Data[4, *]
PE = Length_Data[5, *]
PEmodel = Length_Data[6, *]
LakeArea = Length_Data[7, *]
LakeSizeCode = Length_Data[8, *]
RegionCode = Length_Data[9, *]
LakeCode = Length_Data[10, *]
Longitude = Length_Data[11, *]
Latitude = Length_Data[12, *]
StockType = Length_Data[13, *]
FREE_LUN, lun

; read lake-year-specific age-length key data
OPENR, lun, file2, /GET_LUN
READF, lun, Length_key;, FORMAT='(A17, x, I0)';
FREE_LUN, lun

; read lake-specific age-length key data
OPENR, lun, file3, /GET_LUN
READF, lun, Length_key2;, FORMAT='(A17, x, I0)';
FREE_LUN, lun

; read region key
OPENR, lun, file4, /GET_LUN
READF, lun, Length_key3;, FORMAT='(A17, x, I0)';
FREE_LUN, lun

; read yoy data
OPENR, lun, file5, /GET_LUN
READF, lun, YOY_data;, FORMAT='(A17, x, I0)';
WBIC_Year_YOY = YOY_data[0, *]
WBIC_YOY = YOY_data[1, *]
SurveyYear_YOY = YOY_data[2, *]
Density_YOY = YOY_data[3, *]
Length_YOY = YOY_data[4, *]
Stock_YOY = YOY_data[5, *]
FREE_LUN, lun

; Spearing data
OPENR, lun, file6, /GET_LUN
READF, lun, Length_Spr_Data;, FORMAT='(A17, x, I0)';
WBIC_Year_spr = Length_spr_Data[0, *]
WBIC_spr = Length_spr_Data[1, *]
SurveyYear_spr = Length_spr_Data[2, *]
Length_spr = Length_spr_Data[3, *]
Sex_spr = Length_spr_Data[4, *]
adultPE_spr = Length_spr_Data[5, *]
HarvRate_spr = Length_spr_Data[6, *]
N_harv_spr = Length_spr_Data[7, *]
Season = Length_spr_Data[8, *]
LakeArea_spr = Length_spr_Data[9, *]
FREE_LUN, lun

; read lake-specific age-length key data
OPENR, lun, file7, /GET_LUN
READF, lun, Length_mass_par;, FORMAT='(A17, x, I0)';
FREE_LUN, lun

; read region key
OPENR, lun, file8, /GET_LUN
READF, lun, Length_mass_par2;, FORMAT='(A17, x, I0)';
FREE_LUN, lun


; Array for a cumulative number of lake-years/lakes with the length-age data
N_Lake_year_Wkeys = fltarr(1)                                                 ; number of lake years with lake-year-specific keys
N_Lake_Wkeys = fltarr(1)                                                      ; number of lake years iwth lake-specific keys
N_Lake_WOkeys = fltarr(1)                                                     ; number of lake years w/o keys
N_Lake_year_Spr = fltarr(1)
N_Lake_Spr = fltarr(1)
N_Lake_WOkeys_Spr = fltarr(1)                                                 ; number of lake-years w/o keys
N_Lake_year_LMfunc = fltarr(1)                                                ; number of lake years with lake-year-specific length-mass fucntions
N_Lake_LMfunc = fltarr(1)                                                     ; number of lake years iwth lake-specific length-mass functions
N_state_LMfunc = fltarr(1)                                                    ; number of lake years w/o specfic length-mass fuctions

N_Lake_year_yoy = fltarr(1)
AgeLengthKeyLevel = 0.05                                                      ; age-length key conversion threshold
AgeLengthKeyCheck_Spr1 = fltarr(1)
AgeLengthKeyCheck_Spr2 = fltarr(1)
logMeanLength = 2.612
LengthMassPar1all = 2.781
LengthMassPar2all = 3.177

; Find unique lake-years for production estiamtes
uniqWBIC_Year = WBIC_Year[UNIQ(WBIC_Year, SORT(WBIC_Year))]                   ; 568 lake years with potential estimates
PRINT, 'Total N of WBIC_years', n_elements(uniqWBIC_Year)
uniqWBIC = WBIC[UNIQ(WBIC, SORT(WBIC))]                                       ; 264 lakes
PRINT, 'Total N of WBIC', n_elements(uniqWBIC)

; Create arrays for parameter outputs
paramset = FLTARR(234L, N_ELEMENTS(uniqWBIC_Year))                            ; all fish
paramsetM = FLTARR(217L, N_ELEMENTS(uniqWBIC_Year))                           ; males
paramsetF = FLTARR(217L, N_ELEMENTS(uniqWBIC_Year))                           ; females
paramsetU = FLTARR(217L, N_ELEMENTS(uniqWBIC_Year))                           ; unknowns
paramset_Spr = FLTARR(232L, N_ELEMENTS(uniqWBIC_Year))                        ;
AgeBioProd = FLTARR(40L, N_ELEMENTS(uniqWBIC_Year)*27L)                       ; all fish
AgeBioProd_spr = FLTARR(25L, N_ELEMENTS(uniqWBIC_Year)*27L)                   ; harvested fish
LengthSelect_Data = FLTARR(20, N_ELEMENTS(uniqWBIC_Year)*37L)                 ; output array for size-selectivity

; Create arrays for size-at-age outputs
WAE_size_age = FLTARR(409L, N_ELEMENTS(uniqWBIC_Year)+1L)                     ; an array for mean size-at-age
WAE_size_age_all = FLTARR(198, MAX(SurveyYear)-MIN(SurveyYear)+1L)
;WAE_size_age_all = FLTARR(198, 40)
year = INDGEN(MAX(SurveyYear)-MIN(SurveyYear)+1L)+MIN(SurveyYear)             ; an index for year
NumLengthBin = 37L                                                            ; numebr of length bins in a default array (NEED TO CORRECT)
Nageclass = 28                                                                ; number of age classes
FishProb = FLTARR(27);, Nkey)                                                 ; probability of age in a given length bin
LengthDist = FLTARR(37L+7L, N_ELEMENTS(uniqWBIC_Year))
LengthDist_spr = FLTARR(37L+8L, N_ELEMENTS(uniqWBIC_Year))
LengthDist_spr2 = FLTARR(37L+8L, N_ELEMENTS(uniqWBIC_Year))
LengthDist_spr_PLUS = FLTARR(37L, N_ELEMENTS(uniqWBIC_Year))
Prop_LengthDist_spr_PLUS = FLTARR(N_ELEMENTS(uniqWBIC_Year))
WAE_length_bin=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_mean=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_binM=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_meanM=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_binF=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_meanF=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_binU=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_meanU=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_bin_Spr = fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)
WAE_length_mean_Spr=fltarr(37*3L, N_ELEMENTS(uniqWBIC_Year)*NumLengthBin+37)

; Create arrays for population-level estimates
Total_production = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass = FLTARR(N_ELEMENTS(uniqWBIC_Year))
P_over_B = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_production_adult = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_adult = FLTARR(N_ELEMENTS(uniqWBIC_Year))
P_over_B_adult = FLTARR(N_ELEMENTS(uniqWBIC_Year))
;Output_production = FLTARR(50L, N_ELEMENTS(uniqWBIC_Year))
YOY_PE = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_production_adultM = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_production_adultF = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_production_adultU = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_adultM = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_adultF = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_adultU = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_productionM = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_productionF = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_productionU = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomassM = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomassF = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomassU = FLTARR(N_ELEMENTS(uniqWBIC_Year))

; Spearing
Total_production_Spr = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_Spr = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_Spr_direct = FLTARR(N_ELEMENTS(uniqWBIC_Year))
P_over_B_Spr = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Ecotroph = fltarr(N_ELEMENTS(uniqWBIC_Year))
Total_production_adult_Spr = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Total_biomass_adult_Spr = FLTARR(N_ELEMENTS(uniqWBIC_Year))
P_over_B_adult_Spr = FLTARR(N_ELEMENTS(uniqWBIC_Year))
Adult_ecotroph = fltarr(N_ELEMENTS(uniqWBIC_Year))


; Estimate age structure for each lake-year
; 1. Loop through WBIC_years
FOR i = 0L, N_ELEMENTS(uniqWBIC_Year)-1L DO BEGIN
  PRINT, 'i', i
  IF i EQ 0L THEN adj = 0                                                               ; adjustment to the loop index for outputs
  IF i GT 1L THEN adj = 1

  ; Index for unique WBIC-year walleye stocks spring surveys w/ body length data
  INDEX_lengthdata = WHERE((WBIC_Year[*] EQ uniqWBIC_Year[i]), INDEX_lengthdatacount)
  IF INDEX_lengthdatacount GT 0 THEN PRINT, 'WBIC_year', WBIC_Year[INDEX_lengthdata[0]]

  IF INDEX_lengthdatacount GT 0 THEN BEGIN; if the length survey data exist...
    PRINT, 'WBIC_year', WBIC_Year[INDEX_lengthdata[0]]

    ; Index for unique WBIC_year for walleye YOY
    INDEX_YOYdata = WHERE((WBIC_year_YOY[*] EQ WBIC_Year[INDEX_lengthdata[0]]), INDEX_YOYdatacount)
    paramset[210, i] = INDEX_YOYdatacount

    stock = ' [U]'                                                                      ; code for 'unknown stock type' used in the plot
    IF INDEX_YOYdatacount GT 0 THEN BEGIN; if yoy data exist...
      YOY_PE[i] = ROUND(Density_YOY[INDEX_YOYdata] * LakeArea[INDEX_lengthdata[0]])
      print, 'YOY PE', YOY_PE[i]
      paramset[215, i] = Stock_YOY[INDEX_YOYdata]
      IF Stock_YOY[INDEX_YOYdata] EQ 0 THEN stock = ' [N]'
      IF Stock_YOY[INDEX_YOYdata] EQ 1 THEN stock = ' [S]'
      IF Stock_YOY[INDEX_YOYdata] EQ 2 THEN stock = ' [R]'
      IF Stock_YOY[INDEX_YOYdata] EQ 3 THEN stock = ' [U]'
      paramset[40, i] = Length_YOY[INDEX_YOYdata]
      N_Lake_year_yoy = N_Lake_year_yoy + 1L
      PRINT, 'N of lake-year with yoy data', N_Lake_year_yoy
    ENDIF
    IF INDEX_YOYdatacount LE 0 THEN PRINT, 'No YOY data available'

    Sex_prod = Sex[INDEX_lengthdata]                         ; sex data, male=0; female=1; unknown=2
    Length_prod = Length[INDEX_lengthdata]                   ; length data
    FishAge = AgeArray[INDEX_lengthdata]                     ; assigned age
    FishLength = LengthArray[INDEX_lengthdata]               ; length check
    ;PRINT, 'FishAge', FishAge
    ;PRINT, 'length_prod', length[INDEX_lengthdata]
    PRINT, 'Population demographics info:'
    Male = WHERE(Sex_prod eq 0, malecount)
    Female = WHERE(Sex_prod eq 1, femalecount)
    unknown = WHERE(Sex_prod eq 2, unknowncount)
    print, 'N of males in survey data', malecount
    print, 'N of females in survey data', femalecount
    print, 'N of unknown in survey data', unknowncount

    ; record basic demographic data for output files
    paramset[0, i] = uniqWBIC_Year[i]                                       ; WBIC_year (abbrev)
    paramset[1, i] = WBIC[INDEX_lengthdata[0]]                              ; WBIC
    paramset[2, i] = SurveyYear[INDEX_lengthdata[0]]                        ; year
    paramset[231, i] = LakeSizeCode[INDEX_lengthdata[0]]                    ; lake size <500=0, otherwise, 1
    paramset[232, i] = RegionCode[INDEX_lengthdata[0]]                      ; northeast=1, northwest=2, south=3
    paramset[233, i] = LakeCode[INDEX_lengthdata[0]]                        ; code for size & region combined
    paramset[3, i] = N_ELEMENTS(Length_prod)                                ; N of all fish
    paramset[4, i] = malecount                                              ; N of males
    paramset[5, i] = femalecount                                            ; N of females
    paramset[6, i] = unknowncount                                           ; N of unknowns
    paramset[7, i] = MAX(length[INDEX_lengthdata])                          ; max length for all fish
    paramset[8, i] = MIN(length[INDEX_lengthdata])                          ; min length for all fish
    paramset[9, i] = MAX(length[INDEX_lengthdata[male]])                    ; max length for males
    paramset[10, i] = MIN(length[INDEX_lengthdata[male]])                   ; min length for males
    paramset[11, i] = MAX(length[INDEX_lengthdata[female]])                 ; max length for females
    paramset[12, i] = MIN(length[INDEX_lengthdata[female]])                 ; min length for males
    paramset[219, i] = MEAN(length[INDEX_lengthdata])                       ; mean length for all fish
    paramset[220, i] = STDDEV(length[INDEX_lengthdata])                     ; SD length for all fish
    paramset[221, i] = MEAN(length[INDEX_lengthdata[male]])                 ; mean length for males
    paramset[222, i] = STDDEV(length[INDEX_lengthdata[male]])               ; SD length for males
    paramset[223, i] = MEAN(length[INDEX_lengthdata[female]])               ; mean length for females
    paramset[224, i] = STDDEV(length[INDEX_lengthdata[female]])             ; SD length for females
    print, 'N of fish', paramset[3, i], malecount+femalecount+unknowncount
    print, 'WBIC', paramset[1, i]
    print, 'Year', paramset[2, i]
    print, 'Max length (mm)', Max(length[INDEX_lengthdata])
    print, 'Min length (mm)', Min(length[INDEX_lengthdata])
    print, 'Female max length (mm)', Max(length[INDEX_lengthdata[female]])
    print, 'Female min length (mm)', Min(length[INDEX_lengthdata[female]])
    print, 'Male max length (mm)', Max(length[INDEX_lengthdata[male]])
    print, 'Male min length (mm)', Min(length[INDEX_lengthdata[male]])

    ; Assess length group distributions - ALL FISH
    SizeLT100 = WHERE(Length_prod LT 100., SizeLT100count)
    Size100to120 = WHERE((Length_prod GE 100.) AND (Length_prod LT 120.), Size100to120count)
    Size120to140 = WHERE((Length_prod GE 120.) AND (Length_prod LT 140.), Size120to140count)
    Size140to160 = WHERE((Length_prod GE 140.) AND (Length_prod LT 160.), Size140to160count)
    Size160to180 = WHERE((Length_prod GE 160.) AND (Length_prod LT 180.), Size160to180count)
    Size180to200 = WHERE((Length_prod GE 180.) AND (Length_prod LT 200.), Size180to200count)
    Size200to220 = WHERE((Length_prod GE 200.) AND (Length_prod LT 220.), Size200to220count)
    Size220to240 = WHERE((Length_prod GE 220.) AND (Length_prod LT 240.), Size220to240count)
    Size240to260 = WHERE((Length_prod GE 240.) AND (Length_prod LT 260.), Size240to260count)
    Size260to280 = WHERE((Length_prod GE 260.) AND (Length_prod LT 280.), Size260to280count)
    Size280to300 = WHERE((Length_prod GE 280.) AND (Length_prod LT 300.), Size280to300count)
    Size300to320 = WHERE((Length_prod GE 300.) AND (Length_prod LT 320.), Size300to320count)
    Size320to340 = WHERE((Length_prod GE 320.) AND (Length_prod LT 340.), Size320to340count)
    Size340to360 = WHERE((Length_prod GE 340.) AND (Length_prod LT 360.), Size340to360count)
    Size360to380 = WHERE((Length_prod GE 360.) AND (Length_prod LT 380.), Size360to380count)
    Size380to400 = WHERE((Length_prod GE 380.) AND (Length_prod LT 400.), Size380to400count)
    Size400to420 = WHERE((Length_prod GE 400.) AND (Length_prod LT 420.), Size400to420count)
    Size420to440 = WHERE((Length_prod GE 420.) AND (Length_prod LT 440.), Size420to440count)
    Size440to460 = WHERE((Length_prod GE 440.) AND (Length_prod LT 460.), Size440to460count)
    Size460to480 = WHERE((Length_prod GE 460.) AND (Length_prod LT 480.), Size460to480count)
    Size480to500 = WHERE((Length_prod GE 480.) AND (Length_prod LT 500.), Size480to500count)
    Size500to520 = WHERE((Length_prod GE 500.) AND (Length_prod LT 520.), Size500to520count)
    Size520to540 = WHERE((Length_prod GE 520.) AND (Length_prod LT 540.), Size520to540count)
    Size540to560 = WHERE((Length_prod GE 540.) AND (Length_prod LT 560.), Size540to560count)
    Size560to580 = WHERE((Length_prod GE 560.) AND (Length_prod LT 580.), Size560to580count)
    Size580to600 = WHERE((Length_prod GE 580.) AND (Length_prod LT 600.), Size580to600count)
    Size600to620 = WHERE((Length_prod GE 600.) AND (Length_prod LT 620.), Size600to620count)
    Size620to640 = WHERE((Length_prod GE 620.) AND (Length_prod LT 640.), Size620to640count)
    Size640to660 = WHERE((Length_prod GE 640.) AND (Length_prod LT 660.), Size640to660count)
    Size660to680 = WHERE((Length_prod GE 660.) AND (Length_prod LT 680.), Size660to680count)
    Size680to700 = WHERE((Length_prod GE 680.) AND (Length_prod LT 700.), Size680to700count)
    Size700to720 = WHERE((Length_prod GE 700.) AND (Length_prod LT 720.), Size700to720count)
    Size720to740 = WHERE((Length_prod GE 720.) AND (Length_prod LT 740.), Size720to740count)
    Size740to760 = WHERE((Length_prod GE 740.) AND (Length_prod LT 760.), Size740to760count)
    Size760to780 = WHERE((Length_prod GE 760.) AND (Length_prod LT 780.), Size760to780count)
    Size780to800 = WHERE((Length_prod GE 780.) AND (Length_prod LT 800.), Size780to800count)
    SizeGE800 = WHERE((Length_prod GE 800.), SizeGE800count)

    ; size distribution of the length only data
    LengthDist[0, i] = SizeLT100count
    LengthDist[1, i] = Size100to120count
    LengthDist[2, i] = Size120to140count
    LengthDist[3, i] = Size140to160count
    LengthDist[4, i] = Size160to180count
    LengthDist[5, i] = Size180to200count
    LengthDist[6, i] = Size200to220count
    LengthDist[7, i] = Size220to240count
    LengthDist[8, i] = Size240to260count
    LengthDist[9, i] = Size260to280count
    LengthDist[10, i] = Size280to300count
    LengthDist[11, i] = Size300to320count
    LengthDist[12, i] = Size320to340count
    LengthDist[13, i] = Size340to360count
    LengthDist[14, i] = Size360to380count
    LengthDist[15, i] = Size380to400count
    LengthDist[16, i] = Size400to420count
    LengthDist[17, i] = Size420to440count
    LengthDist[18, i] = Size440to460count
    LengthDist[19, i] = Size460to480count
    LengthDist[20, i] = Size480to500count
    LengthDist[21, i] = Size500to520count
    LengthDist[22, i] = Size520to540count
    LengthDist[23, i] = Size540to560count
    LengthDist[24, i] = Size560to580count
    LengthDist[25, i] = Size580to600count
    LengthDist[26, i] = Size600to620count
    LengthDist[27, i] = Size620to640count
    LengthDist[28, i] = Size640to660count
    LengthDist[29, i] = Size660to680count
    LengthDist[30, i] = Size680to700count
    LengthDist[31, i] = Size700to720count
    LengthDist[32, i] = Size720to740count
    LengthDist[33, i] = Size740to760count
    LengthDist[34, i] = Size760to780count
    LengthDist[35, i] = Size780to800count
    LengthDist[36, i] = SizeGE800count
    PRINT, 'length distribution (bin size = 20mm)', LengthDist[0:36, i]
    LengthDist[37, i] = paramset[1, i]                ; WBIC
    LengthDist[38, i] = paramset[2, i]                ; year
    LengthDist[39, i] = paramset[3, i]                ; sample size
    LengthDist[40, i] = PE[INDEX_lengthdata[0]]       ; adult PE
    LengthDist[41, i] = paramset[4, i]
    LengthDist[42, i] = paramset[5, i]
    LengthDist[43, i] = paramset[6, i]       ;

    
    ; Assign fish to length groups - MALES
    SizeLT100M = WHERE(Length_prod[male] LT 100., SizeLT100Mcount)
    Size100to120M = WHERE((Length_prod[male] GE 100.) AND (Length_prod[male] LT 120.), Size100to120Mcount)
    Size120to140M = WHERE((Length_prod[male] GE 120.) AND (Length_prod[male] LT 140.), Size120to140Mcount)
    Size140to160M = WHERE((Length_prod[male] GE 140.) AND (Length_prod[male] LT 160.), Size140to160Mcount)
    Size160to180M = WHERE((Length_prod[male] GE 160.) AND (Length_prod[male] LT 180.), Size160to180Mcount)
    Size180to200M = WHERE((Length_prod[male] GE 180.) AND (Length_prod[male] LT 200.), Size180to200Mcount)
    Size200to220M = WHERE((Length_prod[male] GE 200.) AND (Length_prod[male] LT 220.), Size200to220Mcount)
    Size220to240M = WHERE((Length_prod[male] GE 220.) AND (Length_prod[male] LT 240.), Size220to240Mcount)
    Size240to260M = WHERE((Length_prod[male] GE 240.) AND (Length_prod[male] LT 260.), Size240to260Mcount)
    Size260to280M = WHERE((Length_prod[male] GE 260.) AND (Length_prod[male] LT 280.), Size260to280Mcount)
    Size280to300M = WHERE((Length_prod[male] GE 280.) AND (Length_prod[male] LT 300.), Size280to300Mcount)
    Size300to320M = WHERE((Length_prod[male] GE 300.) AND (Length_prod[male] LT 320.), Size300to320Mcount)
    Size320to340M = WHERE((Length_prod[male] GE 320.) AND (Length_prod[male] LT 340.), Size320to340Mcount)
    Size340to360M = WHERE((Length_prod[male] GE 340.) AND (Length_prod[male] LT 360.), Size340to360Mcount)
    Size360to380M = WHERE((Length_prod[male] GE 360.) AND (Length_prod[male] LT 380.), Size360to380Mcount)
    Size380to400M = WHERE((Length_prod[male] GE 380.) AND (Length_prod[male] LT 400.), Size380to400Mcount)
    Size400to420M = WHERE((Length_prod[male] GE 400.) AND (Length_prod[male] LT 420.), Size400to420Mcount)
    Size420to440M = WHERE((Length_prod[male] GE 420.) AND (Length_prod[male] LT 440.), Size420to440Mcount)
    Size440to460M = WHERE((Length_prod[male] GE 440.) AND (Length_prod[male] LT 460.), Size440to460Mcount)
    Size460to480M = WHERE((Length_prod[male] GE 460.) AND (Length_prod[male] LT 480.), Size460to480Mcount)
    Size480to500M = WHERE((Length_prod[male] GE 480.) AND (Length_prod[male] LT 500.), Size480to500Mcount)
    Size500to520M = WHERE((Length_prod[male] GE 500.) AND (Length_prod[male] LT 520.), Size500to520Mcount)
    Size520to540M = WHERE((Length_prod[male] GE 520.) AND (Length_prod[male] LT 540.), Size520to540Mcount)
    Size540to560M = WHERE((Length_prod[male] GE 540.) AND (Length_prod[male] LT 560.), Size540to560Mcount)
    Size560to580M = WHERE((Length_prod[male] GE 560.) AND (Length_prod[male] LT 580.), Size560to580Mcount)
    Size580to600M = WHERE((Length_prod[male] GE 580.) AND (Length_prod[male] LT 600.), Size580to600Mcount)
    Size600to620M = WHERE((Length_prod[male] GE 600.) AND (Length_prod[male] LT 620.), Size600to620Mcount)
    Size620to640M = WHERE((Length_prod[male] GE 620.) AND (Length_prod[male] LT 640.), Size620to640Mcount)
    Size640to660M = WHERE((Length_prod[male] GE 640.) AND (Length_prod[male] LT 660.), Size640to660Mcount)
    Size660to680M = WHERE((Length_prod[male] GE 660.) AND (Length_prod[male] LT 680.), Size660to680Mcount)
    Size680to700M = WHERE((Length_prod[male] GE 680.) AND (Length_prod[male] LT 700.), Size680to700Mcount)
    Size700to720M = WHERE((Length_prod[male] GE 700.) AND (Length_prod[male] LT 720.), Size700to720Mcount)
    Size720to740M = WHERE((Length_prod[male] GE 720.) AND (Length_prod[male] LT 740.), Size720to740Mcount)
    Size740to760M = WHERE((Length_prod[male] GE 740.) AND (Length_prod[male] LT 760.), Size740to760Mcount)
    Size760to780M = WHERE((Length_prod[male] GE 760.) AND (Length_prod[male] LT 780.), Size760to780Mcount)
    Size780to800M = WHERE((Length_prod[male] GE 780.) AND (Length_prod[male] LT 800.), Size780to800Mcount)
    SizeGE800M = WHERE((Length_prod[male] GE 800.), SizeGE800Mcount)

    ; Assign fish to length groups - FEMALES
    SizeLT100F = WHERE(Length_prod[female] LT 100., SizeLT100Fcount)
    Size100to120F = WHERE((Length_prod[female] GE 100.) AND (Length_prod[female] LT 120.), Size100to120Fcount)
    Size120to140F = WHERE((Length_prod[female] GE 120.) AND (Length_prod[female] LT 140.), Size120to140Fcount)
    Size140to160F = WHERE((Length_prod[female] GE 140.) AND (Length_prod[female] LT 160.), Size140to160Fcount)
    Size160to180F = WHERE((Length_prod[female] GE 160.) AND (Length_prod[female] LT 180.), Size160to180Fcount)
    Size180to200F = WHERE((Length_prod[female] GE 180.) AND (Length_prod[female] LT 200.), Size180to200Fcount)
    Size200to220F = WHERE((Length_prod[female] GE 200.) AND (Length_prod[female] LT 220.), Size200to220Fcount)
    Size220to240F = WHERE((Length_prod[female] GE 220.) AND (Length_prod[female] LT 240.), Size220to240Fcount)
    Size240to260F = WHERE((Length_prod[female] GE 240.) AND (Length_prod[female] LT 260.), Size240to260Fcount)
    Size260to280F = WHERE((Length_prod[female] GE 260.) AND (Length_prod[female] LT 280.), Size260to280Fcount)
    Size280to300F = WHERE((Length_prod[female] GE 280.) AND (Length_prod[female] LT 300.), Size280to300Fcount)
    Size300to320F = WHERE((Length_prod[female] GE 300.) AND (Length_prod[female] LT 320.), Size300to320Fcount)
    Size320to340F = WHERE((Length_prod[female] GE 320.) AND (Length_prod[female] LT 340.), Size320to340Fcount)
    Size340to360F = WHERE((Length_prod[female] GE 340.) AND (Length_prod[female] LT 360.), Size340to360Fcount)
    Size360to380F = WHERE((Length_prod[female] GE 360.) AND (Length_prod[female] LT 380.), Size360to380Fcount)
    Size380to400F = WHERE((Length_prod[female] GE 380.) AND (Length_prod[female] LT 400.), Size380to400Fcount)
    Size400to420F = WHERE((Length_prod[female] GE 400.) AND (Length_prod[female] LT 420.), Size400to420Fcount)
    Size420to440F = WHERE((Length_prod[female] GE 420.) AND (Length_prod[female] LT 440.), Size420to440Fcount)
    Size440to460F = WHERE((Length_prod[female] GE 440.) AND (Length_prod[female] LT 460.), Size440to460Fcount)
    Size460to480F = WHERE((Length_prod[female] GE 460.) AND (Length_prod[female] LT 480.), Size460to480Fcount)
    Size480to500F = WHERE((Length_prod[female] GE 480.) AND (Length_prod[female] LT 500.), Size480to500Fcount)
    Size500to520F = WHERE((Length_prod[female] GE 500.) AND (Length_prod[female] LT 520.), Size500to520Fcount)
    Size520to540F = WHERE((Length_prod[female] GE 520.) AND (Length_prod[female] LT 540.), Size520to540Fcount)
    Size540to560F = WHERE((Length_prod[female] GE 540.) AND (Length_prod[female] LT 560.), Size540to560Fcount)
    Size560to580F = WHERE((Length_prod[female] GE 560.) AND (Length_prod[female] LT 580.), Size560to580Fcount)
    Size580to600F = WHERE((Length_prod[female] GE 580.) AND (Length_prod[female] LT 600.), Size580to600Fcount)
    Size600to620F = WHERE((Length_prod[female] GE 600.) AND (Length_prod[female] LT 620.), Size600to620Fcount)
    Size620to640F = WHERE((Length_prod[female] GE 620.) AND (Length_prod[female] LT 640.), Size620to640Fcount)
    Size640to660F = WHERE((Length_prod[female] GE 640.) AND (Length_prod[female] LT 660.), Size640to660Fcount)
    Size660to680F = WHERE((Length_prod[female] GE 660.) AND (Length_prod[female] LT 680.), Size660to680Fcount)
    Size680to700F = WHERE((Length_prod[female] GE 680.) AND (Length_prod[female] LT 700.), Size680to700Fcount)
    Size700to720F = WHERE((Length_prod[female] GE 700.) AND (Length_prod[female] LT 720.), Size700to720Fcount)
    Size720to740F = WHERE((Length_prod[female] GE 720.) AND (Length_prod[female] LT 740.), Size720to740Fcount)
    Size740to760F = WHERE((Length_prod[female] GE 740.) AND (Length_prod[female] LT 760.), Size740to760Fcount)
    Size760to780F = WHERE((Length_prod[female] GE 760.) AND (Length_prod[female] LT 780.), Size760to780Fcount)
    Size780to800F = WHERE((Length_prod[female] GE 780.) AND (Length_prod[female] LT 800.), Size780to800Fcount)
    SizeGE800F = WHERE((Length_prod[female] GE 800.), SizeGE800Fcount)

    ; Assign fish to length groups - UNKNOWNS
    SizeLT100U = WHERE(Length_prod[unknown] LT 100., SizeLT100Ucount)
    Size100to120U = WHERE((Length_prod[unknown] GE 100.) AND (Length_prod[unknown] LT 120.), Size100to120Ucount)
    Size120to140U = WHERE((Length_prod[unknown] GE 120.) AND (Length_prod[unknown] LT 140.), Size120to140Ucount)
    Size140to160U = WHERE((Length_prod[unknown] GE 140.) AND (Length_prod[unknown] LT 160.), Size140to160Ucount)
    Size160to180U = WHERE((Length_prod[unknown] GE 160.) AND (Length_prod[unknown] LT 180.), Size160to180Ucount)
    Size180to200U = WHERE((Length_prod[unknown] GE 180.) AND (Length_prod[unknown] LT 200.), Size180to200Ucount)
    Size200to220U = WHERE((Length_prod[unknown] GE 200.) AND (Length_prod[unknown] LT 220.), Size200to220Ucount)
    Size220to240U = WHERE((Length_prod[unknown] GE 220.) AND (Length_prod[unknown] LT 240.), Size220to240Ucount)
    Size240to260U = WHERE((Length_prod[unknown] GE 240.) AND (Length_prod[unknown] LT 260.), Size240to260Ucount)
    Size260to280U = WHERE((Length_prod[unknown] GE 260.) AND (Length_prod[unknown] LT 280.), Size260to280Ucount)
    Size280to300U = WHERE((Length_prod[unknown] GE 280.) AND (Length_prod[unknown] LT 300.), Size280to300Ucount)
    Size300to320U = WHERE((Length_prod[unknown] GE 300.) AND (Length_prod[unknown] LT 320.), Size300to320Ucount)
    Size320to340U = WHERE((Length_prod[unknown] GE 320.) AND (Length_prod[unknown] LT 340.), Size320to340Ucount)
    Size340to360U = WHERE((Length_prod[unknown] GE 340.) AND (Length_prod[unknown] LT 360.), Size340to360Ucount)
    Size360to380U = WHERE((Length_prod[unknown] GE 360.) AND (Length_prod[unknown] LT 380.), Size360to380Ucount)
    Size380to400U = WHERE((Length_prod[unknown] GE 380.) AND (Length_prod[unknown] LT 400.), Size380to400Ucount)
    Size400to420U = WHERE((Length_prod[unknown] GE 400.) AND (Length_prod[unknown] LT 420.), Size400to420Ucount)
    Size420to440U = WHERE((Length_prod[unknown] GE 420.) AND (Length_prod[unknown] LT 440.), Size420to440Ucount)
    Size440to460U = WHERE((Length_prod[unknown] GE 440.) AND (Length_prod[unknown] LT 460.), Size440to460Ucount)
    Size460to480U = WHERE((Length_prod[unknown] GE 460.) AND (Length_prod[unknown] LT 480.), Size460to480Ucount)
    Size480to500U = WHERE((Length_prod[unknown] GE 480.) AND (Length_prod[unknown] LT 500.), Size480to500Ucount)
    Size500to520U = WHERE((Length_prod[unknown] GE 500.) AND (Length_prod[unknown] LT 520.), Size500to520Ucount)
    Size520to540U = WHERE((Length_prod[unknown] GE 520.) AND (Length_prod[unknown] LT 540.), Size520to540Ucount)
    Size540to560U = WHERE((Length_prod[unknown] GE 540.) AND (Length_prod[unknown] LT 560.), Size540to560Ucount)
    Size560to580U = WHERE((Length_prod[unknown] GE 560.) AND (Length_prod[unknown] LT 580.), Size560to580Ucount)
    Size580to600U = WHERE((Length_prod[unknown] GE 580.) AND (Length_prod[unknown] LT 600.), Size580to600Ucount)
    Size600to620U = WHERE((Length_prod[unknown] GE 600.) AND (Length_prod[unknown] LT 620.), Size600to620Ucount)
    Size620to640U = WHERE((Length_prod[unknown] GE 620.) AND (Length_prod[unknown] LT 640.), Size620to640Ucount)
    Size640to660U = WHERE((Length_prod[unknown] GE 640.) AND (Length_prod[unknown] LT 660.), Size640to660Ucount)
    Size660to680U = WHERE((Length_prod[unknown] GE 660.) AND (Length_prod[unknown] LT 680.), Size660to680Ucount)
    Size680to700U = WHERE((Length_prod[unknown] GE 680.) AND (Length_prod[unknown] LT 700.), Size680to700Ucount)
    Size700to720U = WHERE((Length_prod[unknown] GE 700.) AND (Length_prod[unknown] LT 720.), Size700to720Ucount)
    Size720to740U = WHERE((Length_prod[unknown] GE 720.) AND (Length_prod[unknown] LT 740.), Size720to740Ucount)
    Size740to760U = WHERE((Length_prod[unknown] GE 740.) AND (Length_prod[unknown] LT 760.), Size740to760Ucount)
    Size760to780U = WHERE((Length_prod[unknown] GE 760.) AND (Length_prod[unknown] LT 780.), Size760to780Ucount)
    Size780to800U = WHERE((Length_prod[unknown] GE 780.) AND (Length_prod[unknown] LT 800.), Size780to800Ucount)
    SizeGE800U = WHERE((Length_prod[unknown] GE 800.), SizeGE800Ucount)

    ; Assign arrays to age-length keys for lake-years
    WBIC_year_key = Length_key[0, *]
    WBIC_key = Length_key[1, *]
    sample_year_key = Length_key[2, *]
    total_N_fish = Length_key[3, *]
    max_length = Length_key[4, *]
    min_length = Length_key[5, *]
    max_age = Length_key[6, *]
    min_age = Length_key[7, *]
    Length_bin_low = Length_key[8, *]
    Length_N_fish = Length_key[9, *]
    uniqWBIC_Year_key = WBIC_Year_key[UNIQ(WBIC_Year_key, SORT(WBIC_Year_key))]
    ;PRINT, 'Total N of WBIC_year_key', n_elements(uniqWBIC_Year_key)
    uniqWBIC_key = WBIC_key[UNIQ(WBIC_key, SORT(WBIC_key))]
    ;PRINT, 'Total N of WBIC_Key', n_elements(uniqWBIC_key)
      
      ; probability for each age; ALL FISH (length_key 10-36)
      prop_age0 = Length_key[10, *]
      prop_age1 = Length_key[11, *]
      prop_age2 = Length_key[12, *]
      prop_age3 = Length_key[13, *]
      prop_age4 = Length_key[14, *]
      prop_age5 = Length_key[15, *]
      prop_age6 = Length_key[16, *]
      prop_age7 = Length_key[17, *]
      prop_age8 = Length_key[18, *]
      prop_age9 = Length_key[19, *]
      prop_age10 = Length_key[20, *]
      prop_age11 = Length_key[21, *]
      prop_age12 = Length_key[22, *]
      prop_age13 = Length_key[23, *]
      prop_age14 = Length_key[24, *]
      prop_age15 = Length_key[25, *]
      prop_age16 = Length_key[26, *]
      prop_age17 = Length_key[27, *]
      prop_age18 = Length_key[28, *]
      prop_age19 = Length_key[29, *]
      prop_age20 = Length_key[30, *]
      prop_age21 = Length_key[31, *]
      prop_age22 = Length_key[32, *]
      prop_age23 = Length_key[33, *]
      prop_age24 = Length_key[34, *]
      prop_age25 = Length_key[35, *]
      prop_age26 = Length_key[36, *]
      
      ; MALES
      Length_N_fishM = Length_key[37, *]
      prop_age0M = Length_key[38, *]
      prop_age1M = Length_key[39, *]
      prop_age2M = Length_key[40, *]
      prop_age3M = Length_key[41, *]
      prop_age4M = Length_key[42, *]
      prop_age5M = Length_key[43, *]
      prop_age6M = Length_key[44, *]
      prop_age7M = Length_key[45, *]
      prop_age8M = Length_key[46, *]
      prop_age9M = Length_key[47, *]
      prop_age10M = Length_key[48, *]
      prop_age11M = Length_key[49, *]
      prop_age12M = Length_key[50, *]
      prop_age13M = Length_key[51, *]
      prop_age14M = Length_key[52, *]
      prop_age15M = Length_key[53, *]
      prop_age16M = Length_key[54, *]
      prop_age17M = Length_key[55, *]
      prop_age18M = Length_key[56, *]
      prop_age19M = Length_key[57, *]
      prop_age20M = Length_key[58, *]
      prop_age21M = Length_key[59, *]
      prop_age22M = Length_key[60, *]
      prop_age23M = Length_key[61, *]
      prop_age24M = Length_key[62, *]
      prop_age25M = Length_key[63, *]
      prop_age26M = Length_key[64, *]
      
      ; FEMALES
      Length_N_fishF = Length_key[65, *]
      prop_age0F = Length_key[66, *]
      prop_age1F = Length_key[67, *]
      prop_age2F = Length_key[68, *]
      prop_age3F = Length_key[69, *]
      prop_age4F = Length_key[70, *]
      prop_age5F = Length_key[71, *]
      prop_age6F = Length_key[72, *]
      prop_age7F = Length_key[73, *]
      prop_age8F = Length_key[74, *]
      prop_age9F = Length_key[75, *]
      prop_age10F = Length_key[76, *]
      prop_age11F = Length_key[77, *]
      prop_age12F = Length_key[78, *]
      prop_age13F = Length_key[79, *]
      prop_age14F = Length_key[80, *]
      prop_age15F = Length_key[81, *]
      prop_age16F = Length_key[82, *]
      prop_age17F = Length_key[83, *]
      prop_age18F = Length_key[84, *]
      prop_age19F = Length_key[85, *]
      prop_age20F = Length_key[86, *]
      prop_age21F = Length_key[87, *]
      prop_age22F = Length_key[88, *]
      prop_age23F = Length_key[89, *]
      prop_age24F = Length_key[90, *]
      prop_age25F = Length_key[91, *]
      prop_age26F = Length_key[92, *]

;      ; array index for WBIC years w/ key
;      INDEX_lengthdata2 = WHERE((WBIC_year_key[*] EQ WBIC_Year[INDEX_lengthdata[0]]), INDEX_lengthdata2count)
;      IF INDEX_lengthdata2count GT 0 THEN BEGIN; if WBIC_year key exists...
;      PRINT, 'WBIC_year', WBIC_year_key[INDEX_lengthdata2[0]]
;      ; Check if age-key for all fish exist for size bins with data...

      ;########################################################
      ;#Calculate harvested fish age structure for production #
      ;########################################################

      ; Array index for SPEARING data
      INDEX_lengthdataSpr = WHERE((WBIC_year_Spr[*] EQ WBIC_year[INDEX_lengthdata[0]]), INDEX_lengthdataSprcount)

      IF INDEX_lengthdataSprcount GT 0 THEN BEGIN                         ; if Spearing data exist...
        PRINT, 'WBIC_Spr', WBIC_year_Spr[INDEX_lengthdataSpr[0]]
        PRINT, 'Harvest data availabile'

        Length_prod_Spr = Length_Spr[INDEX_lengthdataSpr]             ; WBIC_year data
        Sex_prod_spr = Sex_spr[INDEX_lengthdataSpr]                   ; sex data, male=0; female=1; unknown=2
        FishAgeSpr = AgeArraySpr[INDEX_lengthdataSpr]                 ; assigned age
        FishLengthSpr = LengthArraySpr[INDEX_lengthdataSpr]           ; length check
        
        PRINT, 'Length_prod_Spr', Length_Spr[INDEX_lengthdataSpr]
        
        paramset_Spr[0, i] = uniqWBIC_Year[i]                         ; WBIC_year (abbrev)
        paramset_Spr[1, i] = WBIC_Spr[INDEX_lengthdataSpr[0]]         ; WBIC
        paramset_Spr[2, i] = SurveyYear_Spr[INDEX_lengthdataSpr[0]]   ; year
        paramset_Spr[3, i] = N_ELements(Length_prod_Spr)              ; N of fish
        paramset_Spr[7, i] = Max(length_Spr[INDEX_lengthdataSpr])
        paramset_Spr[8, i] = Min(length_Spr[INDEX_lengthdataSpr])
        Male_spr = WHERE(Sex_prod_spr eq 0, male_sprcount)
        Female_spr = WHERE(Sex_prod_spr eq 1, female_sprcount)
        unknown_spr = WHERE(Sex_prod_spr eq 2, unknown_sprcount)
        print, 'N of males in tribal data', male_sprcount
        print, 'N of females in tribal data', female_sprcount
        print, 'N of unknown in tribal data', unknown_sprcount
        paramset_Spr[4, i] = male_sprcount
        paramset_Spr[5, i] = female_sprcount
        paramset_Spr[6, i] = unknown_sprcount
        paramset_Spr[218, i] = MEAN(length_Spr[INDEX_lengthdataSpr])              ; mean length for all fish
        paramset_Spr[219, i] = STDDEV(length_Spr[INDEX_lengthdataSpr])            ; SD length for all fish
        paramset_Spr[220, i] = MEAN(length_Spr[INDEX_lengthdataSpr[Male_spr]])    ; mean length for males
        paramset_Spr[221, i] = STDDEV(length_Spr[INDEX_lengthdataSpr[Male_spr]])  ; SD length for males
        paramset_Spr[222, i] = MEAN(length_Spr[INDEX_lengthdataSpr[Female_spr]])  ; mean length for females
        paramset_Spr[223, i] = STDDEV(length_Spr[INDEX_lengthdataSpr[Female_spr]]); SD length for females
        print, 'N of fish', paramset_Spr[3, i]                                    ;, malecount+femalecount+unknowncount
        print, 'WBIC', paramset_Spr[1, i]
        print, 'Year', paramset_Spr[2, i]
        print, 'Max length (mm)', Max(length_Spr[INDEX_lengthdataSpr])
        print, 'Min length (mm)', Min(length_Spr[INDEX_lengthdataSpr])
        
        ; Directed estiamted total biomass (kg/km2) - sum of individual masses
        Total_biomass_Spr_direct[i] $
          = TOTAL(1.5868E-006*Length_Spr[INDEX_lengthdataSpr]^3.2962) $
          /LakeArea[INDEX_lengthdata[0]]*1000000./1000.
        PRINT, 'Directedly estimated Total harvested biomass (kg/km2)'
        PRINT, Total_biomass_Spr_direct[i]
        paramset_Spr[203, i] = Total_biomass_Spr_direct[i]
        
        ; Lake-year-specific length-mass relations
        INDEX_lengthmass = WHERE((Length_mass_par[3, *] EQ WBIC_Year[INDEX_lengthdata[0]]), INDEX_lengthmasscount)
        INDEX_lengthmass2 = WHERE((Length_mass_par2[0, *] EQ WBIC[INDEX_lengthdata[0]]), INDEX_lengthmass2count)

        LengthMassPar1a = string(Length_mass_par[4, INDEX_lengthmass], Format='(D0.3)')
        LengthMassPar1b = string(Length_mass_par2[1, INDEX_lengthmass2], Format='(D0.3)')
        print,'LengthMassPar1',LengthMassPar1a,LengthMassPar1b

        IF (INDEX_lengthmasscount GT 0) THEN BEGIN
          LengthMassPar1 = LengthMassPar1all+LengthMassPar1a
          LengthMassPar2 = LengthMassPar2all
          LengthMassParCheck = 1
        ENDIF
        IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count GT 0) THEN BEGIN
          LengthMassPar1 = LengthMassPar1all+LengthMassPar1b
          LengthMassPar2 = LengthMassPar2all
          LengthMassParCheck = 2
        ENDIF
        IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count LE 0) THEN BEGIN
          LengthMassPar1 = LengthMassPar1all
          LengthMassPar2 = LengthMassPar2all
          LengthMassParCheck = 3
        ENDIF
        PRINT, 'LengthMass params=', LengthMassParCheck
        PRINT, LengthMassPar1, LengthMassPar2
        paramset_Spr[231, i] = LengthMassParCheck; age-length key type

        ; Population-mean body mass
        Mean_mass_lakeyear = 10.^(LengthMassPar1 + LengthMassPar2*(ALOG10(Length_Spr[INDEX_lengthdataSpr])-logMeanLength) + 5.006e-03*0.5)
        PRINT, 'Mean_mass_lakeyear', Mean_mass_lakeyear

        Total_biomass_Spr_direct[i] $
          = TOTAL(Mean_mass_lakeyear) $
          /LakeArea[INDEX_lengthdata[0]]*1000000./1000.
        PRINT, 'Directedly estimated Total harvested biomass (kg/km2)'
        PRINT, Total_biomass_Spr_direct[i]
        paramset_Spr[203, i] = Total_biomass_Spr_direct[i]
        
        
        ; Allocate fish to group groups - ALL FISH
        SizeLT100_Spr = WHERE(Length_prod_Spr LT 100., SizeLT100_Sprcount)
        Size100to120_Spr = WHERE((Length_prod_Spr GE 100.) AND (Length_prod_Spr LT 120.), Size100to120_Sprcount)
        Size120to140_Spr = WHERE((Length_prod_Spr GE 120.) AND (Length_prod_Spr LT 140.), Size120to140_Sprcount)
        Size140to160_Spr = WHERE((Length_prod_Spr GE 140.) AND (Length_prod_Spr LT 160.), Size140to160_Sprcount)
        Size160to180_Spr = WHERE((Length_prod_Spr GE 160.) AND (Length_prod_Spr LT 180.), Size160to180_Sprcount)
        Size180to200_Spr = WHERE((Length_prod_Spr GE 180.) AND (Length_prod_Spr LT 200.), Size180to200_Sprcount)
        Size200to220_Spr = WHERE((Length_prod_Spr GE 200.) AND (Length_prod_Spr LT 220.), Size200to220_Sprcount)
        Size220to240_Spr = WHERE((Length_prod_Spr GE 220.) AND (Length_prod_Spr LT 240.), Size220to240_Sprcount)
        Size240to260_Spr = WHERE((Length_prod_Spr GE 240.) AND (Length_prod_Spr LT 260.), Size240to260_Sprcount)
        Size260to280_Spr = WHERE((Length_prod_Spr GE 260.) AND (Length_prod_Spr LT 280.), Size260to280_Sprcount)
        Size280to300_Spr = WHERE((Length_prod_Spr GE 280.) AND (Length_prod_Spr LT 300.), Size280to300_Sprcount)
        Size300to320_Spr = WHERE((Length_prod_Spr GE 300.) AND (Length_prod_Spr LT 320.), Size300to320_Sprcount)
        Size320to340_Spr = WHERE((Length_prod_Spr GE 320.) AND (Length_prod_Spr LT 340.), Size320to340_Sprcount)
        Size340to360_Spr = WHERE((Length_prod_Spr GE 340.) AND (Length_prod_Spr LT 360.), Size340to360_Sprcount)
        Size360to380_Spr = WHERE((Length_prod_Spr GE 360.) AND (Length_prod_Spr LT 380.), Size360to380_Sprcount)
        Size380to400_Spr = WHERE((Length_prod_Spr GE 380.) AND (Length_prod_Spr LT 400.), Size380to400_Sprcount)
        Size400to420_Spr = WHERE((Length_prod_Spr GE 400.) AND (Length_prod_Spr LT 420.), Size400to420_Sprcount)
        Size420to440_Spr = WHERE((Length_prod_Spr GE 420.) AND (Length_prod_Spr LT 440.), Size420to440_Sprcount)
        Size440to460_Spr = WHERE((Length_prod_Spr GE 440.) AND (Length_prod_Spr LT 460.), Size440to460_Sprcount)
        Size460to480_Spr = WHERE((Length_prod_Spr GE 460.) AND (Length_prod_Spr LT 480.), Size460to480_Sprcount)
        Size480to500_Spr = WHERE((Length_prod_Spr GE 480.) AND (Length_prod_Spr LT 500.), Size480to500_Sprcount)
        Size500to520_Spr = WHERE((Length_prod_Spr GE 500.) AND (Length_prod_Spr LT 520.), Size500to520_Sprcount)
        Size520to540_Spr = WHERE((Length_prod_Spr GE 520.) AND (Length_prod_Spr LT 540.), Size520to540_Sprcount)
        Size540to560_Spr = WHERE((Length_prod_Spr GE 540.) AND (Length_prod_Spr LT 560.), Size540to560_Sprcount)
        Size560to580_Spr = WHERE((Length_prod_Spr GE 560.) AND (Length_prod_Spr LT 580.), Size560to580_Sprcount)
        Size580to600_Spr = WHERE((Length_prod_Spr GE 580.) AND (Length_prod_Spr LT 600.), Size580to600_Sprcount)
        Size600to620_Spr = WHERE((Length_prod_Spr GE 600.) AND (Length_prod_Spr LT 620.), Size600to620_Sprcount)
        Size620to640_Spr = WHERE((Length_prod_Spr GE 620.) AND (Length_prod_Spr LT 640.), Size620to640_Sprcount)
        Size640to660_Spr = WHERE((Length_prod_Spr GE 640.) AND (Length_prod_Spr LT 660.), Size640to660_Sprcount)
        Size660to680_Spr = WHERE((Length_prod_Spr GE 660.) AND (Length_prod_Spr LT 680.), Size660to680_Sprcount)
        Size680to700_Spr = WHERE((Length_prod_Spr GE 680.) AND (Length_prod_Spr LT 700.), Size680to700_Sprcount)
        Size700to720_Spr = WHERE((Length_prod_Spr GE 700.) AND (Length_prod_Spr LT 720.), Size700to720_Sprcount)
        Size720to740_Spr = WHERE((Length_prod_Spr GE 720.) AND (Length_prod_Spr LT 740.), Size720to740_Sprcount)
        Size740to760_Spr = WHERE((Length_prod_Spr GE 740.) AND (Length_prod_Spr LT 760.), Size740to760_Sprcount)
        Size760to780_Spr = WHERE((Length_prod_Spr GE 760.) AND (Length_prod_Spr LT 780.), Size760to780_Sprcount)
        Size780to800_Spr = WHERE((Length_prod_Spr GE 780.) AND (Length_prod_Spr LT 800.), Size780to800_Sprcount)
        SizeGE800_Spr = WHERE((Length_prod_Spr GE 800.), SizeGE800_Sprcount)
        LengthDist_spr[0, i] = SizeLT100_sprcount
        LengthDist_spr[1, i] = Size100to120_sprcount
        LengthDist_spr[2, i] = Size120to140_sprcount
        LengthDist_spr[3, i] = Size140to160_sprcount
        LengthDist_spr[4, i] = Size160to180_sprcount
        LengthDist_spr[5, i] = Size180to200_sprcount
        LengthDist_spr[6, i] = Size200to220_sprcount
        LengthDist_spr[7, i] = Size220to240_sprcount
        LengthDist_spr[8, i] = Size240to260_sprcount
        LengthDist_spr[9, i] = Size260to280_sprcount
        LengthDist_spr[10, i] = Size280to300_sprcount
        LengthDist_spr[11, i] = Size300to320_sprcount
        LengthDist_spr[12, i] = Size320to340_sprcount
        LengthDist_spr[13, i] = Size340to360_sprcount
        LengthDist_spr[14, i] = Size360to380_sprcount
        LengthDist_spr[15, i] = Size380to400_sprcount
        LengthDist_spr[16, i] = Size400to420_sprcount
        LengthDist_spr[17, i] = Size420to440_sprcount
        LengthDist_spr[18, i] = Size440to460_sprcount
        LengthDist_spr[19, i] = Size460to480_sprcount
        LengthDist_spr[20, i] = Size480to500_sprcount
        LengthDist_spr[21, i] = Size500to520_sprcount
        LengthDist_spr[22, i] = Size520to540_sprcount
        LengthDist_spr[23, i] = Size540to560_sprcount
        LengthDist_spr[24, i] = Size560to580_sprcount
        LengthDist_spr[25, i] = Size580to600_sprcount
        LengthDist_spr[26, i] = Size600to620_sprcount
        LengthDist_spr[27, i] = Size620to640_sprcount
        LengthDist_spr[28, i] = Size640to660_sprcount
        LengthDist_spr[29, i] = Size660to680_sprcount
        LengthDist_spr[30, i] = Size680to700_sprcount
        LengthDist_spr[31, i] = Size700to720_sprcount
        LengthDist_spr[32, i] = Size720to740_sprcount
        LengthDist_spr[33, i] = Size740to760_sprcount
        LengthDist_spr[34, i] = Size760to780_sprcount
        LengthDist_spr[35, i] = Size780to800_sprcount
        LengthDist_spr[36, i] = SizeGE800_sprcount
        PRINT, 'length distribution - spearing (bin size = 20mm)', LengthDist_spr[0:36, i]
        LengthDist_spr[37, i] = paramset_spr[1, i]                                          ; WBIC
        LengthDist_spr[38, i] = paramset_spr[2, i]                                          ; year
        LengthDist_spr[39, i] = paramset_spr[3, i]                                          ; sample size
        LengthDist_spr[40, i] = adultPE_spr[INDEX_lengthdataSpr[0]]                         ; adult PE
        LengthDist_spr[41, i] = HarvRate_spr[INDEX_lengthdataSpr[0]]                        ; harvest rate
        LengthDist_spr[42, i] = (paramset_spr[4, i])
        LengthDist_spr[43, i] = (paramset_spr[5, i])
        LengthDist_spr[44, i] = (paramset_spr[6, i])
        
        LengthDist_spr2[0, i] = paramset_spr[1, i]                ; WBIC
        LengthDist_spr2[1, i] = paramset_spr[2, i]                ; year
        LengthDist_spr2[2, i] = paramset_spr[3, i]                ; sample size
        LengthDist_spr2[3, i] = adultPE_spr[INDEX_lengthdataSpr[0]]*HarvRate_spr[INDEX_lengthdataSpr[0]]        ; adult PE
        LengthDist_spr2[4, i] = paramset_spr[4, i]                ; n of male
        LengthDist_spr2[5, i] = paramset_spr[5, i]                ; n of female
        LengthDist_spr2[6, i] = paramset_spr[6, i]                ; n of unknowns
        LengthDist_spr2[7:43, i] = LengthDist_spr[0:36, i]/TOTAL(LengthDist_spr[0:36, i]) $
          *adultPE_spr[INDEX_lengthdataSpr[0]]*HarvRate_spr[INDEX_lengthdataSpr[0]]
        
        ; check for discrepancies between spearing data and length-age keys...
        IF (SizeLT100_sprcount GT 0) AND (LengthDist[0, i] LE 0) THEN LengthDist_spr_PLUS[0, i] = SizeLT100_sprcount
        IF (Size100to120_sprcount GT 0) AND (LengthDist[1, i] LE 0) THEN LengthDist_spr_PLUS[1, i] = Size100to120_sprcount
        IF (Size120to140_sprcount GT 0) AND (LengthDist[2, i] LE 0) THEN LengthDist_spr_PLUS[2, i] = Size120to140_sprcount
        IF (Size140to160_sprcount GT 0) AND (LengthDist[3, i] LE 0) THEN LengthDist_spr_PLUS[3, i] = Size140to160_sprcount
        IF (Size160to180_sprcount GT 0) AND (LengthDist[4, i] LE 0) THEN LengthDist_spr_PLUS[4, i] = Size160to180_sprcount
        IF (Size180to200_sprcount GT 0) AND (LengthDist[5, i] LE 0) THEN LengthDist_spr_PLUS[5, i] = Size180to200_sprcount
        IF (Size200to220_sprcount GT 0) AND (LengthDist[6, i] LE 0) THEN LengthDist_spr_PLUS[6, i] = Size200to220_sprcount
        IF (Size220to240_sprcount GT 0) AND (LengthDist[7, i] LE 0) THEN LengthDist_spr_PLUS[7, i] = Size220to240_sprcount
        IF (Size240to260_sprcount GT 0) AND (LengthDist[8, i] LE 0) THEN LengthDist_spr_PLUS[8, i] = Size240to260_sprcount
        IF (Size260to280_sprcount GT 0) AND (LengthDist[9, i] LE 0) THEN LengthDist_spr_PLUS[9, i] = Size260to280_sprcount
        IF (Size280to300_sprcount GT 0) AND (LengthDist[10, i] LE 0) THEN LengthDist_spr_PLUS[10, i] = Size280to300_sprcount
        IF (Size300to320_sprcount GT 0) AND (LengthDist[11, i] LE 0) THEN LengthDist_spr_PLUS[11, i] = Size300to320_sprcount
        IF (Size320to340_sprcount GT 0) AND (LengthDist[12, i] LE 0) THEN LengthDist_spr_PLUS[12, i] = Size320to340_sprcount
        IF (Size340to360_sprcount GT 0) AND (LengthDist[13, i] LE 0) THEN LengthDist_spr_PLUS[13, i] = Size340to360_sprcount
        IF (Size360to380_sprcount GT 0) AND (LengthDist[14, i] LE 0) THEN LengthDist_spr_PLUS[14, i] = Size360to380_sprcount
        IF (Size380to400_sprcount GT 0) AND (LengthDist[15, i] LE 0) THEN LengthDist_spr_PLUS[15, i] = Size380to400_sprcount
        IF (Size400to420_sprcount GT 0) AND (LengthDist[16, i] LE 0) THEN LengthDist_spr_PLUS[16, i] = Size400to420_sprcount
        IF (Size420to440_sprcount GT 0) AND (LengthDist[17, i] LE 0) THEN LengthDist_spr_PLUS[17, i] = Size420to440_sprcount
        IF (Size440to460_sprcount GT 0) AND (LengthDist[18, i] LE 0) THEN LengthDist_spr_PLUS[18, i] = Size440to460_sprcount
        IF (Size460to480_sprcount GT 0) AND (LengthDist[19, i] LE 0) THEN LengthDist_spr_PLUS[19, i] = Size460to480_sprcount
        IF (Size480to500_sprcount GT 0) AND (LengthDist[20, i] LE 0) THEN LengthDist_spr_PLUS[20, i] = Size480to500_sprcount
        IF (Size500to520_sprcount GT 0) AND (LengthDist[21, i] LE 0) THEN LengthDist_spr_PLUS[21, i] = Size500to520_sprcount
        IF (Size520to540_sprcount GT 0) AND (LengthDist[22, i] LE 0) THEN LengthDist_spr_PLUS[22, i] = Size520to540_sprcount
        IF (Size540to560_sprcount GT 0) AND (LengthDist[23, i] LE 0) THEN LengthDist_spr_PLUS[23, i] = Size540to560_sprcount
        IF (Size560to580_sprcount GT 0) AND (LengthDist[24, i] LE 0) THEN LengthDist_spr_PLUS[24, i] = Size560to580_sprcount
        IF (Size580to600_sprcount GT 0) AND (LengthDist[25, i] LE 0) THEN LengthDist_spr_PLUS[25, i] = Size580to600_sprcount
        IF (Size600to620_sprcount GT 0) AND (LengthDist[26, i] LE 0) THEN LengthDist_spr_PLUS[26, i] = Size600to620_sprcount
        IF (Size620to640_sprcount GT 0) AND (LengthDist[27, i] LE 0) THEN LengthDist_spr_PLUS[27, i] = Size620to640_sprcount
        IF (Size640to660_sprcount GT 0) AND (LengthDist[28, i] LE 0) THEN LengthDist_spr_PLUS[28, i] = Size640to660_sprcount
        IF (Size660to680_sprcount GT 0) AND (LengthDist[29, i] LE 0) THEN LengthDist_spr_PLUS[29, i] = Size660to680_sprcount
        IF (Size680to700_sprcount GT 0) AND (LengthDist[30, i] LE 0) THEN LengthDist_spr_PLUS[30, i] = Size680to700_sprcount
        IF (Size700to720_sprcount GT 0) AND (LengthDist[31, i] LE 0) THEN LengthDist_spr_PLUS[31, i] = Size700to720_sprcount
        IF (Size720to740_sprcount GT 0) AND (LengthDist[32, i] LE 0) THEN LengthDist_spr_PLUS[32, i] = Size720to740_sprcount
        IF (Size740to760_sprcount GT 0) AND (LengthDist[33, i] LE 0) THEN LengthDist_spr_PLUS[33, i] = Size740to760_sprcount
        IF (Size760to780_sprcount GT 0) AND (LengthDist[34, i] LE 0) THEN LengthDist_spr_PLUS[34, i] = Size760to780_sprcount
        IF (Size780to800_sprcount GT 0) AND (LengthDist[35, i] LE 0) THEN LengthDist_spr_PLUS[35, i] = Size780to800_sprcount
        IF (SizeGE800_sprcount GT 0) AND (LengthDist[36, i] LE 0) THEN LengthDist_spr_PLUS[36, i] = SizeGE800_sprcount
        IF TOTAL(LengthDist_spr_PLUS[*, i]) GT 0 THEN PRINT, 'length bins w/o spring survey data (bin size = 20mm)', LengthDist_spr_PLUS[0:36, i]
        
        Prop_LengthDist_spr_PLUS[i] = TOTAL(LengthDist_spr_PLUS[*, i]) / TOTAL(LengthDist_spr[*, i])             
        
        ; If fish length bins were not sampled in spring surveys, they were not included in age structure analysis
        IF LengthDist_spr_PLUS[0, i] GT 0 THEN SizeLT100_sprcount = 0
        IF LengthDist_spr_PLUS[1, i] GT 0 THEN Size100to120_sprcount = 0
        IF LengthDist_spr_PLUS[2, i] GT 0 THEN Size120to140_sprcount = 0
        IF LengthDist_spr_PLUS[3, i] GT 0 THEN Size140to160_sprcount = 0
        IF LengthDist_spr_PLUS[4, i] GT 0 THEN Size160to180_sprcount = 0
        IF LengthDist_spr_PLUS[5, i] GT 0 THEN Size180to200_sprcount = 0
        IF LengthDist_spr_PLUS[6, i] GT 0 THEN Size200to220_sprcount = 0
        IF LengthDist_spr_PLUS[7, i] GT 0 THEN Size220to240_sprcount = 0
        IF LengthDist_spr_PLUS[8, i] GT 0 THEN Size240to260_sprcount = 0
        IF LengthDist_spr_PLUS[9, i] GT 0 THEN Size260to280_sprcount = 0
        IF LengthDist_spr_PLUS[10, i] GT 0 THEN Size280to300_sprcount = 0
        IF LengthDist_spr_PLUS[11, i] GT 0 THEN Size300to320_sprcount = 0
        IF LengthDist_spr_PLUS[12, i] GT 0 THEN Size320to340_sprcount = 0
        IF LengthDist_spr_PLUS[13, i] GT 0 THEN Size340to360_sprcount = 0
        IF LengthDist_spr_PLUS[14, i] GT 0 THEN Size360to380_sprcount = 0
        IF LengthDist_spr_PLUS[15, i] GT 0 THEN Size380to400_sprcount = 0
        IF LengthDist_spr_PLUS[16, i] GT 0 THEN Size400to420_sprcount = 0
        IF LengthDist_spr_PLUS[17, i] GT 0 THEN Size420to440_sprcount = 0
        IF LengthDist_spr_PLUS[18, i] GT 0 THEN Size440to460_sprcount = 0
        IF LengthDist_spr_PLUS[19, i] GT 0 THEN Size460to480_sprcount = 0
        IF LengthDist_spr_PLUS[20, i] GT 0 THEN Size480to500_sprcount = 0
        IF LengthDist_spr_PLUS[21, i] GT 0 THEN Size500to520_sprcount = 0
        IF LengthDist_spr_PLUS[22, i] GT 0 THEN Size520to540_sprcount = 0
        IF LengthDist_spr_PLUS[23, i] GT 0 THEN Size540to560_sprcount = 0
        IF LengthDist_spr_PLUS[24, i] GT 0 THEN Size560to580_sprcount = 0
        IF LengthDist_spr_PLUS[25, i] GT 0 THEN Size580to600_sprcount = 0
        IF LengthDist_spr_PLUS[26, i] GT 0 THEN Size600to620_sprcount = 0
        IF LengthDist_spr_PLUS[27, i] GT 0 THEN Size620to640_sprcount = 0
        IF LengthDist_spr_PLUS[28, i] GT 0 THEN Size640to660_sprcount = 0
        IF LengthDist_spr_PLUS[29, i] GT 0 THEN Size660to680_sprcount = 0
        IF LengthDist_spr_PLUS[30, i] GT 0 THEN Size680to700_sprcount = 0
        IF LengthDist_spr_PLUS[31, i] GT 0 THEN Size700to720_sprcount = 0
        IF LengthDist_spr_PLUS[32, i] GT 0 THEN Size720to740_sprcount = 0
        IF LengthDist_spr_PLUS[33, i] GT 0 THEN Size740to760_sprcount = 0
        IF LengthDist_spr_PLUS[34, i] GT 0 THEN Size760to780_sprcount = 0
        IF LengthDist_spr_PLUS[35, i] GT 0 THEN Size780to800_sprcount = 0
        IF LengthDist_spr_PLUS[36, i] GT 0 THEN SizeGE800_sprcount = 0
        
        
        ; Array index for WBIC years w/ key
        INDEX_lengthdataSpr2 = WHERE((WBIC_year_key[*] EQ WBIC_Year_Spr[INDEX_lengthdataSpr[0]]), INDEX_lengthdataSpr2count)

        IF (INDEX_lengthdataSpr2count GT 0) THEN BEGIN                                  ; if a key exists for each lake-year... 
          PRINT, 'WBIC_Year_Spr', WBIC_year_key[INDEX_lengthdataSpr2[0]]
          
              length_key_check_Spr = fltarr(37)
              IF (SizeLT100_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[0]] LE 0) THEN length_key_check_Spr[0] = SizeLT100_Sprcount
              IF (Size100to120_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[1]] LE 0) THEN length_key_check_Spr[1] = Size100to120_Sprcount
              IF (Size120to140_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[2]] LE 0) THEN length_key_check_Spr[2] = Size120to140_Sprcount
              IF (Size140to160_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[3]] LE 0) THEN length_key_check_Spr[3] = Size140to160_Sprcount
              IF (Size160to180_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[4]] LE 0) THEN length_key_check_Spr[4] = Size160to180_Sprcount
              IF (Size180to200_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[5]] LE 0) THEN length_key_check_Spr[5] = Size180to200_Sprcount
              IF (Size200to220_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[6]] LE 0) THEN length_key_check_Spr[6] = Size200to220_Sprcount
              IF (Size220to240_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[7]] LE 0) THEN length_key_check_Spr[7] = Size220to240_Sprcount
              IF (Size240to260_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[8]] LE 0) THEN length_key_check_Spr[8] = Size240to260_Sprcount
              IF (Size260to280_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[9]] LE 0) THEN length_key_check_Spr[9] = Size260to280_Sprcount
              IF (Size280to300_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[10]] LE 0) THEN length_key_check_Spr[10] = Size280to300_Sprcount
              IF (Size300to320_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[11]] LE 0) THEN length_key_check_Spr[11] = Size300to320_Sprcount
              IF (Size320to340_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[12]] LE 0) THEN length_key_check_Spr[12] = Size320to340_Sprcount
              IF (Size340to360_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[13]] LE 0) THEN length_key_check_Spr[13] = Size340to360_Sprcount
              IF (Size360to380_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[14]] LE 0) THEN length_key_check_Spr[14] = Size360to380_Sprcount
              IF (Size380to400_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[15]] LE 0) THEN length_key_check_Spr[15] = Size380to400_Sprcount
              IF (Size400to420_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[16]] LE 0) THEN length_key_check_Spr[16] = Size400to420_Sprcount
              IF (Size420to440_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[17]] LE 0) THEN length_key_check_Spr[17] = Size420to440_Sprcount
              IF (Size440to460_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[18]] LE 0) THEN length_key_check_Spr[18] = Size440to460_Sprcount
              IF (Size460to480_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[19]] LE 0) THEN length_key_check_Spr[19] = Size460to480_Sprcount
              IF (Size480to500_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[20]] LE 0) THEN length_key_check_Spr[20] = Size480to500_Sprcount
              IF (Size500to520_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[21]] LE 0) THEN length_key_check_Spr[21] = Size500to520_Sprcount
              IF (Size520to540_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[22]] LE 0) THEN length_key_check_Spr[22] = Size520to540_Sprcount
              IF (Size540to560_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[23]] LE 0) THEN length_key_check_Spr[23] = Size540to560_Sprcount
              IF (Size560to580_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[24]] LE 0) THEN length_key_check_Spr[24] = Size560to580_Sprcount
              IF (Size580to600_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[25]] LE 0) THEN length_key_check_Spr[25] = Size580to600_Sprcount
              IF (Size600to620_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[26]] LE 0) THEN length_key_check_Spr[26] = Size600to620_Sprcount
              IF (Size620to640_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[27]] LE 0) THEN length_key_check_Spr[27] = Size620to640_Sprcount
              IF (Size640to660_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[28]] LE 0) THEN length_key_check_Spr[28] = Size640to660_Sprcount
              IF (Size660to680_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[29]] LE 0) THEN length_key_check_Spr[29] = Size660to680_Sprcount
              IF (Size680to700_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[30]] LE 0) THEN length_key_check_Spr[30] = Size680to700_Sprcount
              IF (Size700to720_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[31]] LE 0) THEN length_key_check_Spr[31] = Size700to720_Sprcount
              IF (Size720to740_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[32]] LE 0) THEN length_key_check_Spr[32] = Size720to740_Sprcount
              IF (Size740to760_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[33]] LE 0) THEN length_key_check_Spr[33] = Size740to760_Sprcount
              IF (Size760to780_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[34]] LE 0) THEN length_key_check_Spr[34] = Size760to780_Sprcount
              IF (Size780to800_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[35]] LE 0) THEN length_key_check_Spr[35] = Size780to8000_Sprcount
              IF (SizeGE800_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr2[36]] LE 0) THEN length_key_check_Spr[36] = SizeGE800_Sprcount
              PRINT, 'total N of fish w/o key', TOTAL(length_key_check_Spr)
              paramset[212, i] = TOTAL(length_key_check_Spr)
              PRINT, 'size bins w/o key', length_key_check_Spr

              AgeLengthKeyCheck_Spr1 = (TOTAL(length_key_check_Spr)/N_ELEMENTS(Length_prod_Spr))
              PRINT, 'AgeLengthKeyCheck_Spr1', AgeLengthKeyCheck_Spr1

              IF AgeLengthKeyCheck_Spr1 LT AgeLengthKeyLevel THEN BEGIN                     ; the proportion of unaged fish is less than the threshold...
                N_Lake_year_Spr = N_Lake_year_Spr + 1L
                PRINT, 'N of lake-years with harvested biomass estimated with lake-year-specific keys', N_Lake_year_Spr
                
                ;1.Assign age semi-randomly to lengths - ALL FISH
                IF SizeLT100_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 0
                  LengthBinIndex2 = SizeLT100_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size100to120_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 1
                  LengthBinIndex2 = Size100to120_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size120to140_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 2
                  LengthBinIndex2 = Size120to140_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size140to160_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 3
                  LengthBinIndex2 = Size140to160_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size160to180_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 4
                  LengthBinIndex2 = Size160to180_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size180to200_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 5
                  LengthBinIndex2 = Size180to200_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size200to220_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 6
                  LengthBinIndex2 = Size200to220_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size220to240_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 7
                  LengthBinIndex2 = Size220to240_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size240to260_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 8
                  LengthBinIndex2 = Size240to260_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size260to280_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 9
                  LengthBinIndex2 = Size260to280_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size280to300_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 10
                  LengthBinIndex2 = Size280to300_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size300to320_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 11
                  LengthBinIndex2 = Size300to320_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size320to340_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 12
                  LengthBinIndex2 = Size320to340_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size340to360_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 13
                  LengthBinIndex2 = Size340to360_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size360to380_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 14
                  LengthBinIndex2 = Size360to380_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size380to400_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 15
                  LengthBinIndex2 = Size380to400_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size400to420_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 16
                  LengthBinIndex2 = Size400to420_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size420to440_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 17
                  LengthBinIndex2 = Size420to440_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size440to460_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 18
                  LengthBinIndex2 = Size440to460_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size460to480_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 19
                  LengthBinIndex2 = Size460to480_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size480to500_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 20
                  LengthBinIndex2 = Size480to500_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size500to520_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 21
                  LengthBinIndex2 = Size500to520_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size520to540_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 22
                  LengthBinIndex2 = Size520to540_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size540to560_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 23
                  LengthBinIndex2 = Size540to560_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size560to580_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 24
                  LengthBinIndex2 = Size560to580_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size580to600_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 25
                  LengthBinIndex2 = Size580to600_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size600to620_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 26
                  LengthBinIndex2 = Size600to620_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size620to640_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 27
                  LengthBinIndex2 = Size620to640_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size640to660_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 28
                  LengthBinIndex2 = Size640to660_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size660to680_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 29
                  LengthBinIndex2 = Size660to680_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size680to700_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 30
                  LengthBinIndex2 = Size680to700_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size700to720_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 31
                  LengthBinIndex2 = Size700to720_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size720to740_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 32
                  LengthBinIndex2 = Size720to740_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size740to760_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 33
                  LengthBinIndex2 = Size740to760_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size760to780_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 34
                  LengthBinIndex2 = Size760to780_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Size780to800_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 35
                  LengthBinIndex2 = Size780to800_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                IF Sizege800_Sprcount GT 0 THEN BEGIN
                  LengthBinIndex1 = 36
                  LengthBinIndex2 = SizeGE800_Spr
                  FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                    , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                    , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                    , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                    , prop_age26, INDEX_lengthdataSpr2, LengthBinIndex1)
                  ;PRINT, 'FishProb', FishProb
                  AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                  WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                  AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                    , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                  FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                  FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                ENDIF
                PRINT, "Age of fish harvested by tribes (FishAgeSpr)", FishAgeSpr
                PRINT, "Length of fish harvested by tribes (FishLengthSpr)", FishLengthSpr
                
                ; mean age (all fish catch)
                AgeSprAll = WHERE(FishAgeSpr GE 0, AgeSprAllCOUNT)
                IF AgeSprAllCOUNT GT 0 THEN BEGIN
                  paramset_spr[225, i] = MEAN(FishAgeSpr[AgeSprAll])                                                          ; mean age for all fish
                  IF N_ELEMENTS(FishAgeSpr[AgeSprAll]) GT 1 THEN paramset_spr[226, i] = STDDEV(FishAgeSpr[AgeSprAll])         ; SD age for all fish
                ENDIF
;                AgeSprAllM = WHERE(FishAgeSpr[male] GE 0, AgeSprAllMCOUNT)
;                IF AgeSprAllMCOUNT GT 0 THEN BEGIN
;                  paramset_spr[227, i] = MEAN(FishAge[male[AgeSprAllM]])                                                      ; min age for males
;                  IF N_ELEMENTS(FishAgeSpr[AgeSprAllM]) GT 1 THEN paramset_spr[228, i] = STDDEV(FishAgeSpr[male[AgeSprAllM]]) ; min age for males
;                ENDIF
;                AgeSprAllF = WHERE(FishAgeSpr[female] GE 0, AgeSprAllFCOUNT)
;                IF AgeSprAllFCOUNT GT 0 THEN BEGIN
;                  paramset_spr[229, i] = MEAN(FishAgeSpr[female[AgeSprAllF]])                                                   ; max age for females
;                  IF N_ELEMENTS(FishAgeSpr[AgeSprAllF]) GT 1 THEN paramset_spr[230, i] = STDDEV(FishAgeSpr[female[AgeSprAllF]]) ; min age for females
;                ENDIF
                
                ; Age structure of harvested fish by spearing
                Total_N_ageclass_Spr = FLTARR(27L, 2L)
                Total_N_ageclass_Spr[0, 0] = TOTAL(WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 0
                Total_N_ageclass_Spr[1, 0] = TOTAL(WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 1
                Total_N_ageclass_Spr[2, 0] = TOTAL(WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 2
                Total_N_ageclass_Spr[3, 0] = TOTAL(WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 3
                Total_N_ageclass_Spr[4, 0] = TOTAL(WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 4
                Total_N_ageclass_Spr[5, 0] = TOTAL(WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 5
                Total_N_ageclass_Spr[6, 0] = TOTAL(WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 6
                Total_N_ageclass_Spr[7, 0] = TOTAL(WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 7
                Total_N_ageclass_Spr[8, 0] = TOTAL(WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 8
                Total_N_ageclass_Spr[9, 0] = TOTAL(WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 9
                Total_N_ageclass_Spr[10, 0] = TOTAL(WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 10
                Total_N_ageclass_Spr[11, 0] = TOTAL(WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 11
                Total_N_ageclass_Spr[12, 0] = TOTAL(WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 12
                Total_N_ageclass_Spr[13, 0] = TOTAL(WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 13
                Total_N_ageclass_Spr[14, 0] = TOTAL(WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 14
                Total_N_ageclass_Spr[15, 0] = TOTAL(WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 15
                Total_N_ageclass_Spr[16, 0] = TOTAL(WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 16
                Total_N_ageclass_Spr[17, 0] = TOTAL(WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 17
                Total_N_ageclass_Spr[18, 0] = TOTAL(WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 18
                Total_N_ageclass_Spr[19, 0] = TOTAL(WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 19
                Total_N_ageclass_Spr[20, 0] = TOTAL(WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 20
                Total_N_ageclass_Spr[21, 0] = TOTAL(WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 21
                Total_N_ageclass_Spr[22, 0] = TOTAL(WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 22
                Total_N_ageclass_Spr[23, 0] = TOTAL(WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 23
                Total_N_ageclass_Spr[24, 0] = TOTAL(WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 24
                Total_N_ageclass_Spr[25, 0] = TOTAL(WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 25
                Total_N_ageclass_Spr[26, 0] = TOTAL(WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 26
                PRINT, 'Derived age distribution of harvested fish'
                PRINT, Total_N_ageclass_Spr[*, 0]
                PRINT, 'Total number of harvested fish samples', TOTAL(Total_N_ageclass_Spr[*, 0])

                ; Estimate age structure of harvested fish
                Total_prop_ageclass_Spr = FLTARR(27L, 2L)
                IF TOTAL(Total_N_ageclass_Spr[*, 0]) GT 0 THEN Total_prop_ageclass_Spr[*, 0] $
                  = Total_N_ageclass_Spr[*, 0]/TOTAL(Total_N_ageclass_Spr[*, 0])
                PRINT, 'Relative age distribution'
                PRINT, Total_prop_ageclass_Spr[*, 0]
                
                PRINT, 'N of harvested fish (Spearing)', N_harv_Spr[INDEX_lengthdataSpr[0]], $ 
                  HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]]
                
                IF TOTAL(Total_N_ageclass_Spr[*, 0]) GT 0 THEN paramset_Spr[13:39, i] $
                  = ROUND(Total_prop_ageclass_Spr[*, 0]*HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]])
                PRINT, 'Estimated age distribution of harvested fish'
                PRINT, paramset_Spr[13:39, i]

                ; Calculate mean length-at-age for harvested fish
                mean_length_at_age_Spr = FLTARR(27L, 37L)
                mean_length_at_age_Spr[0, *] = (WAE_length_mean_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[1, *] = (WAE_length_mean_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[2, *] = (WAE_length_mean_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[3, *] = (WAE_length_mean_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[4, *] = (WAE_length_mean_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[5, *] = (WAE_length_mean_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[6, *] = (WAE_length_mean_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[7, *] = (WAE_length_mean_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[8, *] = (WAE_length_mean_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[9, *] = (WAE_length_mean_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[10, *] = (WAE_length_mean_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[11, *] = (WAE_length_mean_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[12, *] = (WAE_length_mean_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[13, *] = (WAE_length_mean_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[14, *] = (WAE_length_mean_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[15, *] = (WAE_length_mean_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[16, *] = (WAE_length_mean_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[17, *] = (WAE_length_mean_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[18, *] = (WAE_length_mean_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[19, *] = (WAE_length_mean_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[20, *] = (WAE_length_mean_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[21, *] = (WAE_length_mean_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[22, *] = (WAE_length_mean_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[23, *] = (WAE_length_mean_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[24, *] = (WAE_length_mean_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[25, *] = (WAE_length_mean_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                mean_length_at_age_Spr[26, *] = (WAE_length_mean_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                age0mean_Spr = where(mean_length_at_age_Spr[0, *] GT 0, age0mean_Sprcount)
                age1mean_Spr = where(mean_length_at_age_Spr[1, *] GT 0, age1mean_Sprcount)
                age2mean_Spr = where(mean_length_at_age_Spr[2, *] GT 0, age2mean_Sprcount)
                age3mean_Spr = where(mean_length_at_age_Spr[3, *] GT 0, age3mean_Sprcount)
                age4mean_Spr = where(mean_length_at_age_Spr[4, *] GT 0, age4mean_Sprcount)
                age5mean_Spr = where(mean_length_at_age_Spr[5, *] GT 0, age5mean_Sprcount)
                age6mean_Spr = where(mean_length_at_age_Spr[6, *] GT 0, age6mean_Sprcount)
                age7mean_Spr = where(mean_length_at_age_Spr[7, *] GT 0, age7mean_Sprcount)
                age8mean_Spr = where(mean_length_at_age_Spr[8, *] GT 0, age8mean_Sprcount)
                age9mean_Spr = where(mean_length_at_age_Spr[9, *] GT 0, age9mean_Sprcount)
                age10mean_Spr = where(mean_length_at_age_Spr[10, *] GT 0, age10mean_Sprcount)
                age11mean_Spr = where(mean_length_at_age_Spr[11, *] GT 0, age11mean_Sprcount)
                age12mean_Spr = where(mean_length_at_age_Spr[12, *] GT 0, age12mean_Sprcount)
                age13mean_Spr = where(mean_length_at_age_Spr[13, *] GT 0, age13mean_Sprcount)
                age14mean_Spr = where(mean_length_at_age_Spr[14, *] GT 0, age14mean_Sprcount)
                age15mean_Spr = where(mean_length_at_age_Spr[15, *] GT 0, age15mean_Sprcount)
                age16mean_Spr = where(mean_length_at_age_Spr[16, *] GT 0, age16mean_Sprcount)
                age17mean_Spr = where(mean_length_at_age_Spr[17, *] GT 0, age17mean_Sprcount)
                age18mean_Spr = where(mean_length_at_age_Spr[18, *] GT 0, age18mean_Sprcount)
                age19mean_Spr = where(mean_length_at_age_Spr[19, *] GT 0, age19mean_Sprcount)
                age20mean_Spr = where(mean_length_at_age_Spr[20, *] GT 0, age20mean_Sprcount)
                age21mean_Spr = where(mean_length_at_age_Spr[21, *] GT 0, age21mean_Sprcount)
                age22mean_Spr = where(mean_length_at_age_Spr[22, *] GT 0, age22mean_Sprcount)
                age23mean_Spr = where(mean_length_at_age_Spr[23, *] GT 0, age23mean_Sprcount)
                age24mean_Spr = where(mean_length_at_age_Spr[24, *] GT 0, age24mean_Sprcount)
                age25mean_Spr = where(mean_length_at_age_Spr[25, *] GT 0, age25mean_Sprcount)
                age26mean_Spr = where(mean_length_at_age_Spr[26, *] GT 0, age26mean_Sprcount)
                IF age0mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[0, 1] = TOTAL(WAE_length_mean_Spr[10 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age0mean_Sprcount
                IF age1mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[1, 1] = TOTAL(WAE_length_mean_Spr[11 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age1mean_Sprcount
                IF age2mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[2, 1] = TOTAL(WAE_length_mean_Spr[12 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age2mean_Sprcount
                IF age3mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[3, 1] = TOTAL(WAE_length_mean_Spr[13 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age3mean_Sprcount
                IF age4mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[4, 1] = TOTAL(WAE_length_mean_Spr[14 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age4mean_Sprcount
                IF age5mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[5, 1] = TOTAL(WAE_length_mean_Spr[15 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age5mean_Sprcount
                IF age6mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[6, 1] = TOTAL(WAE_length_mean_Spr[16 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age6mean_Sprcount
                IF age7mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[7, 1] = TOTAL(WAE_length_mean_Spr[17 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age7mean_Sprcount
                IF age8mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[8, 1] = TOTAL(WAE_length_mean_Spr[18 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age8mean_Sprcount
                IF age9mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[9, 1] = TOTAL(WAE_length_mean_Spr[19 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age9mean_Sprcount
                IF age10mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[10, 1] = TOTAL(WAE_length_mean_Spr[20 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age10mean_Sprcount
                IF age11mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[11, 1] = TOTAL(WAE_length_mean_Spr[21 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age11mean_Sprcount
                IF age12mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[12, 1] = TOTAL(WAE_length_mean_Spr[22 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age12mean_Sprcount
                IF age13mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[13, 1] = TOTAL(WAE_length_mean_Spr[23 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age13mean_Sprcount
                IF age14mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[14, 1] = TOTAL(WAE_length_mean_Spr[24 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age14mean_Sprcount
                IF age15mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[15, 1] = TOTAL(WAE_length_mean_Spr[25 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age15mean_Sprcount
                IF age16mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[16, 1] = TOTAL(WAE_length_mean_Spr[26 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age16mean_Sprcount
                IF age17mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[17, 1] = TOTAL(WAE_length_mean_Spr[27 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age17mean_Sprcount
                IF age18mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[18, 1] = TOTAL(WAE_length_mean_Spr[28 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age18mean_Sprcount
                IF age19mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[19, 1] = TOTAL(WAE_length_mean_Spr[29 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age19mean_Sprcount
                IF age20mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[20, 1] = TOTAL(WAE_length_mean_Spr[30 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age20mean_Sprcount
                IF age21mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[21, 1] = TOTAL(WAE_length_mean_Spr[31 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age21mean_Sprcount
                IF age22mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[22, 1] = TOTAL(WAE_length_mean_Spr[32 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age22mean_Sprcount
                IF age23mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[23, 1] = TOTAL(WAE_length_mean_Spr[33 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age23mean_Sprcount
                IF age24mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[24, 1] = TOTAL(WAE_length_mean_Spr[34 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age24mean_Sprcount
                IF age25mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[25, 1] = TOTAL(WAE_length_mean_Spr[35 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age25mean_Sprcount
                IF age26mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[26, 1] = TOTAL(WAE_length_mean_Spr[36 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age26mean_Sprcount
                PRINT, 'Mean length-at-age of harvested fish'
                PRINT, Total_N_ageclass_Spr[*, 1]
                
                ; weighted means-at-age
                IF age0mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[0, 1] = TOTAL(WAE_length_mean_Spr[10 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age1mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[1, 1] = TOTAL(WAE_length_mean_Spr[11 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age2mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[2, 1] = TOTAL(WAE_length_mean_Spr[12 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age3mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[3, 1] = TOTAL(WAE_length_mean_Spr[13 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age4mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[4, 1] = TOTAL(WAE_length_mean_Spr[14 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age5mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[5, 1] = TOTAL(WAE_length_mean_Spr[15 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age6mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[6, 1] = TOTAL(WAE_length_mean_Spr[16 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age7mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[7, 1] = TOTAL(WAE_length_mean_Spr[17 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age8mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[8, 1] = TOTAL(WAE_length_mean_Spr[18 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age9mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[9, 1] = TOTAL(WAE_length_mean_Spr[19 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age10mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[10, 1] = TOTAL(WAE_length_mean_Spr[20 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age11mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[11, 1] = TOTAL(WAE_length_mean_Spr[21 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age12mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[12, 1] = TOTAL(WAE_length_mean_Spr[22 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age13mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[13, 1] = TOTAL(WAE_length_mean_Spr[23 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age14mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[14, 1] = TOTAL(WAE_length_mean_Spr[24 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age15mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[15, 1] = TOTAL(WAE_length_mean_Spr[25 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age16mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[16, 1] = TOTAL(WAE_length_mean_Spr[26 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age17mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[17, 1] = TOTAL(WAE_length_mean_Spr[27 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age18mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[18, 1] = TOTAL(WAE_length_mean_Spr[28 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age19mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[19, 1] = TOTAL(WAE_length_mean_Spr[29 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age20mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[20, 1] = TOTAL(WAE_length_mean_Spr[30 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age21mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[21, 1] = TOTAL(WAE_length_mean_Spr[31 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age22mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[22, 1] = TOTAL(WAE_length_mean_Spr[32 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age23mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[23, 1] = TOTAL(WAE_length_mean_Spr[33 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age24mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[24, 1] = TOTAL(WAE_length_mean_Spr[34 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age25mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[25, 1] = TOTAL(WAE_length_mean_Spr[35 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                IF age26mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[26, 1] = TOTAL(WAE_length_mean_Spr[36 $
                  , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                  /TOTAL(WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                PRINT, 'Mean length-at-age of harvested fish'
                PRINT, Total_N_ageclass_Spr[*, 1]
                
                paramset_Spr[40L:66, i] = Total_N_ageclass_Spr[*, 1]

                Mean_mass_Spr = FLTARR(27L, 1)
                Mean_mass_Spr = 1.5868E-006*Total_N_ageclass_Spr[*, 1]^3.2962               ; ***compare w/ individually converted mass
                PRINT, 'Mean mass-at-age of harvested fish'
                PRINT, Mean_mass_Spr

                ; Lake-year-specific length-mass relations
                INDEX_lengthmass = WHERE((Length_mass_par[3, *] EQ WBIC_Year[INDEX_lengthdata[0]]), INDEX_lengthmasscount)
                INDEX_lengthmass2 = WHERE((Length_mass_par2[0, *] EQ WBIC[INDEX_lengthdata[0]]), INDEX_lengthmass2count)

                LengthMassPar1a = string(Length_mass_par[4, INDEX_lengthmass], Format='(D0.3)')
                LengthMassPar1b = string(Length_mass_par2[1, INDEX_lengthmass2], Format='(D0.3)')
                print,'LengthMassPar1',LengthMassPar1a,LengthMassPar1b

                IF (INDEX_lengthmasscount GT 0) THEN BEGIN
                  LengthMassPar1 = LengthMassPar1all+LengthMassPar1a
                  LengthMassPar2 = LengthMassPar2all
                  LengthMassParCheck = 1
                  N_Lake_year_LMfunc = N_Lake_year_LMfunc + 1L
                ENDIF
                IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count GT 0) THEN BEGIN
                  LengthMassPar1 = LengthMassPar1all+LengthMassPar1b
                  LengthMassPar2 = LengthMassPar2all
                  LengthMassParCheck = 2
                  N_Lake_LMfunc = N_Lake_LMfunc + 1L
                ENDIF
                IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count LE 0) THEN BEGIN
                  LengthMassPar1 = LengthMassPar1all
                  LengthMassPar2 = LengthMassPar2all
                  LengthMassParCheck = 3
                  N_state_LMfunc = N_state_LMfunc + 1L
                ENDIF
                PRINT, 'LengthMass params=', LengthMassParCheck
                PRINT, LengthMassPar1, LengthMassPar2
                paramset_Spr[231, i] = LengthMassParCheck; age-length key type

                ; Population-mean body mass
                Mean_mass_lakeyear = 10.^(LengthMassPar1 + LengthMassPar2*(ALOG10(Total_N_ageclass_Spr[*, 1])-logMeanLength) + 5.006e-03*0.5)
                PRINT, 'Mean_mass_lakeyear', Mean_mass_lakeyear

                Mean_mass_Spr = Mean_mass_lakeyear
                
                paramset_Spr[67L:93, i] = Mean_mass_Spr


                Age_NOmass_Spr = WHERE(Mean_mass_Spr LE 0, Age_NOmass_Sprcount)
                Age_Wmass_Spr = WHERE(Mean_mass_Spr GT 0, Age_Wmass_Sprcount)
                IF Age_Wmass_Sprcount GT 0. THEN PRINT, 'age class with mass data for harvested fish', Age_Wmass_Spr
                IF Age_NOmass_Sprcount GT 0. THEN PRINT, 'age class without mass data of harvested fish', Age_NOmass_Spr
                PRINT, 'max age class with mass of harvested fish', MAX(Age_Wmass_Spr)
                PRINT, 'min age class with mass of harvested fish', MIN(Age_Wmass_Spr)

                Age_mass_Spr_index = INDGEN(27)
                Age_NOmass_Spr_Intrpl = WHERE((Age_NOmass_Spr GT min(Age_Wmass_Spr)) AND (Age_NOmass_Spr LT max(Age_Wmass_Spr)), $
                  Age_NOmass_Spr_Intrplcount)
                IF Age_NOmass_Spr_Intrplcount GT 0 THEN PRINT, 'age class mass need interpolation', Age_NOmass_Spr[Age_NOmass_Spr_Intrpl]

                ; Tribe-harvested biomass
                Biomass_ageclass_Spr = FLTARR(27L, 1)
                Biomass_ageclass_Spr = Mean_mass_Spr*ROUND(Total_prop_ageclass_Spr[*, 0]*HarvRate_spr[INDEX_lengthdataSpr[0]] $
                  *adultPE_spr[INDEX_lengthdataSpr[0]])                                       ; masses are the same as the original stocks
                PRINT, 'Biomass-at-age of harvested fish'
                PRINT, Biomass_ageclass_Spr
                PRINT, 'Max biomass', MAX(Biomass_ageclass_Spr)
                paramset_Spr[94L:120, i] = Biomass_ageclass_Spr

                ; Create age-specific biomass plots
                Biomass_ageclass_SprAll=Biomass_ageclass_Spr/1000.
                ;femaleBiomass=Biomass_ageclassF/1000.
                ;unknownBiomass=Biomass_ageclassU/1000.
                !p.font=0
                ;Device, Set_Character_Size=[8,12]
                Device, Get_Decomposed=currentState
                DEVICE, SET_FONT='Courier', /TT_FONT
                DEVICE, DECOMPOSED=0
                cgDisplay, 750, 400, WID=4
                ;!P.Multi = [0,2,1]
                labels = INDGEN(27); ['Exp 1', 'Exp 2', 'Exp 3', 'Exp 4', 'Exp 5']
                cgLoadct, 33, Clip=[10,245]
                cgBarPlot, Biomass_ageclass_SprAll,  YRange=[0,MAX(Biomass_ageclass_SprALL)*1.2], Colors='DARKGRAY', BarNames=labels $
                  , xtitle='Age (years)'$
                  , ytitle='Biomass (Kg)' $;, xrange=[0, 25]
                  , title='Harvested (SPR) biomass distribution of WI walleye stocks - '+'WBIC: '+STRING(WBIC[INDEX_lengthdata[0]], FORMAT = '(I7)') $
                  +'_Year: '+STRING(fix(SurveyYear[INDEX_lengthdata[0]]), FORMAT = '(I4)')
                ;XYOutS, ROUND(MEDIAN(INDGEN(27))), ROUND(0.5*(MAX(paramset[13:39, i]))*1.3), Orientation=90.0, /DEVICE
                ;cgBarPlot, femaleBiomass, Colors='RED', /Overplot, BaseLines=maleBiomass
                ;cgBarPlot, unknownBiomass, Colors='dark green', /Overplot, BaseLines=maleBiomass+femaleBiomass
                ;items = ['Male', 'Female', 'Unknown']
                ;colors = ['BLUE', 'RED', 'dark green']
                ;AL_Legend, items, Colors=colors, PSym=Replicate(15,3), SymSize=Replicate(1.75,3), $
                ;  Charsize=cgDefCharsize(), Position=[0.75, 0.85], /Normal

                ; file name for WBIC-year-specific age structure
                filename='Walleye harveseted (SPR) biomass'+ STRING(WBIC[INDEX_lengthdata[0]], FORMAT = '(I7)') $
                  +'_'+STRING(fix(SurveyYear[INDEX_lengthdata[0]]), FORMAT = '(I4)')+'.png'
                WRITE_PNG, filename, TVRD(/TRUE)
                DEVICE, DECOMPOSED=old_decomposed
                !p.font=1

                PRINT, 'Total number of harvested fish by spearing', N_harv_Spr[INDEX_lengthdataSpr[0]] $
                  , HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]]
                PRINT, 'Lake area (km2)', LakeArea[INDEX_lengthdata[0]]/1000000.; lake area (km2)
                
                IF (LakeArea[INDEX_lengthdata[0]] GT 0.) THEN Total_biomass_Spr[i] $
                  = TOTAL(Biomass_ageclass_Spr[*, 0]) / LakeArea[INDEX_lengthdata[0]]*1000000./1000.
                PRINT, 'Total harvested biomass (kg/km2)'
                PRINT, Total_biomass_Spr[i]
                paramset_Spr[202, i] = Total_biomass_Spr[i]

                ; Estimates with only >age 3
                IF (LakeArea[INDEX_lengthdata[0]] GT 0.) THEN Total_biomass_adult_Spr[i] $
                  = TOTAL(Biomass_ageclass_Spr[3L:26L, 0]) / LakeArea[INDEX_lengthdata[0]]*1000000./1000.
                PRINT, 'Total harvested adult biomass (kg/km2)'
                PRINT, Total_biomass_adult_Spr[i]
                paramset_Spr[205L, i] = Total_biomass_adult_Spr[i]

                ;;IF (Total_production_adult[i] GT 0.) THEN Adult_ecotroph[i] = Total_production_adult_Spr[i]/Total_production_adult[i]
                ;IF (Total_production_adult[i] GT 0.) THEN Adult_ecotroph[i] = Total_biomass_adult_Spr[i] $
                ;  /(Total_production_adult[i]+(Biomass_ageclass[3,0]/1000.)/(LakeArea[INDEX_lengthdata[0]]/1000000.))
                ;PRINT, 'harvested adult biomass/adult production (age 3 biomass+age4plus production)'
                ;PRINT, Adult_ecotroph[i]
                ;paramset_Spr[209L, i] = Adult_ecotroph[i]
                paramset_Spr[210L, i] = HarvRate_Spr[INDEX_lengthdataSpr[0]]

              ENDIF; <unaged fish threshold
            ;ENDIF; END OF INDEX_lengthdataSprcount
            IF INDEX_lengthdataSprcount LE 0 THEN PRINT, 'Harvest data not availabile'
      ENDIF; END of WBIC_year key

;      IF (INDEX_lengthdata2count LE 0) OR (AgeLengthKeyCheck1 GE AgeLengthKeyLevel) THEN BEGIN; if there is no lake-year-specific key...
;        PRINT, 'Lake-year key not availabile'
;        WBIC2 = WBIC[INDEX_lengthdata[0]]
;        PRINT, 'WBIC', WBIC[INDEX_lengthdata[0]]
        ;INDEX_lengthdata2b = WHERE((WBIC_key[*] EQ WBIC2), INDEX_lengthdata2bcount)
        ;IF INDEX_lengthdata2bcount GT 0 THEN BEGIN; if lake-specific key exists...
          
      ;#########################################################
      ;#Calculate harvested fish age structure for production
      ;#########################################################

      IF (INDEX_lengthdataSpr2count LE 0) OR (AgeLengthKeyCheck_Spr1 GE AgeLengthKeyLevel) THEN BEGIN            ; if there is no lake-year-specific key...
          
          WBIC_year_key = Length_key2[0, *]
          WBIC_key = Length_key2[1, *]
          sample_year_key = Length_key2[2, *]
          total_N_fish = Length_key2[3, *]
          max_length = Length_key2[4, *]
          min_length = Length_key2[5, *]
          max_age = Length_key2[6, *]
          min_age = Length_key2[7, *]
          Length_bin_low = Length_key2[8, *]
          Length_N_fish = Length_key2[9, *]
          
          prop_age0 = Length_key2[10, *]
          prop_age1 = Length_key2[11, *]
          prop_age2 = Length_key2[12, *]
          prop_age3 = Length_key2[13, *]
          prop_age4 = Length_key2[14, *]
          prop_age5 = Length_key2[15, *]
          prop_age6 = Length_key2[16, *]
          prop_age7 = Length_key2[17, *]
          prop_age8 = Length_key2[18, *]
          prop_age9 = Length_key2[19, *]
          prop_age10 = Length_key2[20, *]
          prop_age11 = Length_key2[21, *]
          prop_age12 = Length_key2[22, *]
          prop_age13 = Length_key2[23, *]
          prop_age14 = Length_key2[24, *]
          prop_age15 = Length_key2[25, *]
          prop_age16 = Length_key2[26, *]
          prop_age17 = Length_key2[27, *]
          prop_age18 = Length_key2[28, *]
          prop_age19 = Length_key2[29, *]
          prop_age20 = Length_key2[30, *]
          prop_age21 = Length_key2[31, *]
          prop_age22 = Length_key2[32, *]
          prop_age23 = Length_key2[33, *]
          prop_age24 = Length_key2[34, *]
          prop_age25 = Length_key2[35, *]
          prop_age26 = Length_key2[36, *]

          Length_N_fishM = Length_key2[37, *]
          prop_age0M = Length_key2[38, *]
          prop_age1M = Length_key2[39, *]
          prop_age2M = Length_key2[40, *]
          prop_age3M = Length_key2[41, *]
          prop_age4M = Length_key2[42, *]
          prop_age5M = Length_key2[43, *]
          prop_age6M = Length_key2[44, *]
          prop_age7M = Length_key2[45, *]
          prop_age8M = Length_key2[46, *]
          prop_age9M = Length_key2[47, *]
          prop_age10M = Length_key2[48, *]
          prop_age11M = Length_key2[49, *]
          prop_age12M = Length_key2[50, *]
          prop_age13M = Length_key2[51, *]
          prop_age14M = Length_key2[52, *]
          prop_age15M = Length_key2[53, *]
          prop_age16M = Length_key2[54, *]
          prop_age17M = Length_key2[55, *]
          prop_age18M = Length_key2[56, *]
          prop_age19M = Length_key2[57, *]
          prop_age20M = Length_key2[58, *]
          prop_age21M = Length_key2[59, *]
          prop_age22M = Length_key2[60, *]
          prop_age23M = Length_key2[61, *]
          prop_age24M = Length_key2[62, *]
          prop_age25M = Length_key2[63, *]
          prop_age26M = Length_key2[64, *]

          Length_N_fishF = Length_key2[65, *]
          prop_age0F = Length_key2[66, *]
          prop_age1F = Length_key2[67, *]
          prop_age2F = Length_key2[68, *]
          prop_age3F = Length_key2[69, *]
          prop_age4F = Length_key2[70, *]
          prop_age5F = Length_key2[71, *]
          prop_age6F = Length_key2[72, *]
          prop_age7F = Length_key2[73, *]
          prop_age8F = Length_key2[74, *]
          prop_age9F = Length_key2[75, *]
          prop_age10F = Length_key2[76, *]
          prop_age11F = Length_key2[77, *]
          prop_age12F = Length_key2[78, *]
          prop_age13F = Length_key2[79, *]
          prop_age14F = Length_key2[80, *]
          prop_age15F = Length_key2[81, *]
          prop_age16F = Length_key2[82, *]
          prop_age17F = Length_key2[83, *]
          prop_age18F = Length_key2[84, *]
          prop_age19F = Length_key2[85, *]
          prop_age20F = Length_key2[86, *]
          prop_age21F = Length_key2[87, *]
          prop_age22F = Length_key2[88, *]
          prop_age23F = Length_key2[89, *]
          prop_age24F = Length_key2[90, *]
          prop_age25F = Length_key2[91, *]
          prop_age26F = Length_key2[92, *]
          PRINT, 'WBIC', WBIC[INDEX_lengthdata[0]]

          paramset[211, i] = 2                                                          ; age-length key type
          ; array index for lake-years w/ lake-specific keys
          INDEX_lengthdataSpr3 = WHERE((WBIC_key[*] EQ WBIC_Spr[INDEX_lengthdataSpr[0]]), INDEX_lengthdataSpr3count)

          IF (INDEX_lengthdataSpr3count GT 0) THEN BEGIN                                 ; if A key exists for lake...
            length_key_check_Spr = fltarr(37)
            IF (SizeLT100_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[0]] LE 0) THEN length_key_check_Spr[0] = SizeLT100_Sprcount
            IF (Size100to120_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[1]] LE 0) THEN length_key_check_Spr[1] = Size100to120_Sprcount
            IF (Size120to140_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[2]] LE 0) THEN length_key_check_Spr[2] = Size120to140_Sprcount
            IF (Size140to160_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[3]] LE 0) THEN length_key_check_Spr[3] = Size140to160_Sprcount
            IF (Size160to180_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[4]] LE 0) THEN length_key_check_Spr[4] = Size160to180_Sprcount
            IF (Size180to200_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[5]] LE 0) THEN length_key_check_Spr[5] = Size180to200_Sprcount
            IF (Size200to220_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[6]] LE 0) THEN length_key_check_Spr[6] = Size200to220_Sprcount
            IF (Size220to240_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[7]] LE 0) THEN length_key_check_Spr[7] = Size220to240_Sprcount
            IF (Size240to260_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[8]] LE 0) THEN length_key_check_Spr[8] = Size240to260_Sprcount
            IF (Size260to280_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[9]] LE 0) THEN length_key_check_Spr[9] = Size260to280_Sprcount
            IF (Size280to300_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[10]] LE 0) THEN length_key_check_Spr[10] = Size280to300_Sprcount
            IF (Size300to320_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[11]] LE 0) THEN length_key_check_Spr[11] = Size300to320_Sprcount
            IF (Size320to340_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[12]] LE 0) THEN length_key_check_Spr[12] = Size320to340_Sprcount
            IF (Size340to360_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[13]] LE 0) THEN length_key_check_Spr[13] = Size340to360_Sprcount
            IF (Size360to380_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[14]] LE 0) THEN length_key_check_Spr[14] = Size360to380_Sprcount
            IF (Size380to400_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[15]] LE 0) THEN length_key_check_Spr[15] = Size380to400_Sprcount
            IF (Size400to420_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[16]] LE 0) THEN length_key_check_Spr[16] = Size400to420_Sprcount
            IF (Size420to440_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[17]] LE 0) THEN length_key_check_Spr[17] = Size420to440_Sprcount
            IF (Size440to460_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[18]] LE 0) THEN length_key_check_Spr[18] = Size440to460_Sprcount
            IF (Size460to480_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[19]] LE 0) THEN length_key_check_Spr[19] = Size460to480_Sprcount
            IF (Size480to500_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[20]] LE 0) THEN length_key_check_Spr[20] = Size480to500_Sprcount
            IF (Size500to520_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[21]] LE 0) THEN length_key_check_Spr[21] = Size500to520_Sprcount
            IF (Size520to540_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[22]] LE 0) THEN length_key_check_Spr[22] = Size520to540_Sprcount
            IF (Size540to560_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[23]] LE 0) THEN length_key_check_Spr[23] = Size540to560_Sprcount
            IF (Size560to580_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[24]] LE 0) THEN length_key_check_Spr[24] = Size560to580_Sprcount
            IF (Size580to600_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[25]] LE 0) THEN length_key_check_Spr[25] = Size580to600_Sprcount
            IF (Size600to620_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[26]] LE 0) THEN length_key_check_Spr[26] = Size600to620_Sprcount
            IF (Size620to640_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[27]] LE 0) THEN length_key_check_Spr[27] = Size620to640_Sprcount
            IF (Size640to660_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[28]] LE 0) THEN length_key_check_Spr[28] = Size640to660_Sprcount
            IF (Size660to680_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[29]] LE 0) THEN length_key_check_Spr[29] = Size660to680_Sprcount
            IF (Size680to700_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[30]] LE 0) THEN length_key_check_Spr[30] = Size680to700_Sprcount
            IF (Size700to720_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[31]] LE 0) THEN length_key_check_Spr[31] = Size700to720_Sprcount
            IF (Size720to740_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[32]] LE 0) THEN length_key_check_Spr[32] = Size720to740_Sprcount
            IF (Size740to760_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[33]] LE 0) THEN length_key_check_Spr[33] = Size740to760_Sprcount
            IF (Size760to780_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[34]] LE 0) THEN length_key_check_Spr[34] = Size760to780_Sprcount
            IF (Size780to800_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[35]] LE 0) THEN length_key_check_Spr[35] = Size780to800_Sprcount
            IF (SizeGE800_Sprcount GT 0) AND (Length_N_fish[INDEX_lengthdataSpr3[36]] LE 0) THEN length_key_check_Spr[36] = SizeGE800_Sprcount
            PRINT, 'total N of fish w/o key', TOTAL(length_key_check_Spr)
            paramset[212, i] = TOTAL(length_key_check_Spr)
            PRINT, 'size bins w/o key', length_key_check_Spr
  
            AgeLengthKeyCheck_Spr2 = (TOTAL(length_key_check_Spr)/N_ELEMENTS(Length_prod_Spr))
            PRINT, 'AgeLengthKeyCheck_Spr2', AgeLengthKeyCheck_Spr1
  
            IF AgeLengthKeyCheck_Spr2 LT AgeLengthKeyLevel THEN BEGIN
              N_Lake_Spr = N_Lake_Spr + 1L
              PRINT, 'N of lake-years with harveasted biomass estiamted with a lake-specific key', N_Lake_Wkeys

                      ; 1.Assign age semi-randomly to lengths - all fish
                      IF SizeLT100_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 0
                        LengthBinIndex2 = SizeLT100_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size100to120_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 1
                        LengthBinIndex2 = Size100to120_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size120to140_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 2
                        LengthBinIndex2 = Size120to140_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size140to160_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 3
                        LengthBinIndex2 = Size140to160_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size160to180_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 4
                        LengthBinIndex2 = Size160to180_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size180to200_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 5
                        LengthBinIndex2 = Size180to200_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size200to220_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 6
                        LengthBinIndex2 = Size200to220_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size220to240_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 7
                        LengthBinIndex2 = Size220to240_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size240to260_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 8
                        LengthBinIndex2 = Size240to260_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size260to280_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 9
                        LengthBinIndex2 = Size260to280_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size280to300_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 10
                        LengthBinIndex2 = Size280to300_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size300to320_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 11
                        LengthBinIndex2 = Size300to320_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size320to340_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 12
                        LengthBinIndex2 = Size320to340_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size340to360_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 13
                        LengthBinIndex2 = Size340to360_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size360to380_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 14
                        LengthBinIndex2 = Size360to380_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size380to400_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 15
                        LengthBinIndex2 = Size380to400_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size400to420_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 16
                        LengthBinIndex2 = Size400to420_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size420to440_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 17
                        LengthBinIndex2 = Size420to440_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size440to460_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 18
                        LengthBinIndex2 = Size440to460_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size460to480_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 19
                        LengthBinIndex2 = Size460to480_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size480to500_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 20
                        LengthBinIndex2 = Size480to500_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size500to520_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 21
                        LengthBinIndex2 = Size500to520_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size520to540_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 22
                        LengthBinIndex2 = Size520to540_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size540to560_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 23
                        LengthBinIndex2 = Size540to560_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size560to580_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 24
                        LengthBinIndex2 = Size560to580_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size580to600_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 25
                        LengthBinIndex2 = Size580to600_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size600to620_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 26
                        LengthBinIndex2 = Size600to620_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size620to640_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 27
                        LengthBinIndex2 = Size620to640_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size640to660_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 28
                        LengthBinIndex2 = Size640to660_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size660to680_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 29
                        LengthBinIndex2 = Size660to680_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size680to700_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 30
                        LengthBinIndex2 = Size680to700_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size700to720_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 31
                        LengthBinIndex2 = Size700to720_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size720to740_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 32
                        LengthBinIndex2 = Size720to740_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size740to760_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 33
                        LengthBinIndex2 = Size740to760_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size760to780_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 34
                        LengthBinIndex2 = Size760to780_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Size780to800_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 35
                        LengthBinIndex2 = Size780to800_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      IF Sizege800_Sprcount GT 0 THEN BEGIN
                        LengthBinIndex1 = 36
                        LengthBinIndex2 = SizeGE800_Spr
                        FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                          , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                          , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                          , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                          , prop_age26, INDEX_lengthdataSpr3, LengthBinIndex1)
                        ;PRINT, 'FishProb', FishProb
                        AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
                        WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
                        AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                          , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
                        FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
                        FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
                      ENDIF
                      PRINT, "Age of fish harvested by tribes (FishAgeSpr)", FishAgeSpr
                      PRINT, "Length of fish harvested by tribes (FishLengthSpr)", FishLengthSpr
                      
                      ; mean age (all fish catch)
                      AgeSprAll = WHERE(FishAgeSpr GE 0, AgeSprAllCOUNT)
                      IF AgeSprAllCOUNT GT 0 THEN BEGIN
                        paramset_spr[225, i] = MEAN(FishAgeSpr[AgeSprAll])                                                            ; mean age for all fish
                        IF N_ELEMENTS(FishAgeSpr[AgeSprAll]) GT 1 THEN paramset_spr[226, i] = STDDEV(FishAgeSpr[AgeSprAll])           ; SD age for all fish
                      ENDIF
;                      AgeSprAllM = WHERE(FishAgeSpr[male] GE 0, AgeSprAllMCOUNT)
;                      IF AgeSprAllMCOUNT GT 0 THEN BEGIN
;                        paramset_spr[227, i] = MEAN(FishAge[male[AgeSprAllM]])                                                      ; min age for males
;                        IF N_ELEMENTS(FishAgeSpr[AgeSprAllM]) GT 1 THEN paramset_spr[228, i] = STDDEV(FishAgeSpr[male[AgeSprAllM]]) ; min age for males
;                      ENDIF
;                      AgeSprAllF = WHERE(FishAgeSpr[female] GE 0, AgeSprAllFCOUNT)
;                      IF AgeSprAllFCOUNT GT 0 THEN BEGIN
;                        paramset_spr[229, i] = MEAN(FishAgeSpr[female[AgeSprAllF]])                                                       ; max age for females
;                        IF N_ELEMENTS(FishAgeSpr[AgeSprAllF]) GT 1 THEN paramset_spr[230, i] = STDDEV(FishAgeSpr[female[AgeSprAllF]])     ; min age for females
;                      ENDIF 

                      ; Age structure of harvested fish (Spring)
                      Total_N_ageclass_Spr = FLTARR(27L, 2L)
                      Total_N_ageclass_Spr[0, 0] = TOTAL(WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 0
                      Total_N_ageclass_Spr[1, 0] = TOTAL(WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 1
                      Total_N_ageclass_Spr[2, 0] = TOTAL(WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 2
                      Total_N_ageclass_Spr[3, 0] = TOTAL(WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 3
                      Total_N_ageclass_Spr[4, 0] = TOTAL(WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 4
                      Total_N_ageclass_Spr[5, 0] = TOTAL(WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 5
                      Total_N_ageclass_Spr[6, 0] = TOTAL(WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 6
                      Total_N_ageclass_Spr[7, 0] = TOTAL(WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 7
                      Total_N_ageclass_Spr[8, 0] = TOTAL(WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 8
                      Total_N_ageclass_Spr[9, 0] = TOTAL(WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 9
                      Total_N_ageclass_Spr[10, 0] = TOTAL(WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 10
                      Total_N_ageclass_Spr[11, 0] = TOTAL(WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 11
                      Total_N_ageclass_Spr[12, 0] = TOTAL(WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 12
                      Total_N_ageclass_Spr[13, 0] = TOTAL(WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 13
                      Total_N_ageclass_Spr[14, 0] = TOTAL(WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 14
                      Total_N_ageclass_Spr[15, 0] = TOTAL(WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 15
                      Total_N_ageclass_Spr[16, 0] = TOTAL(WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 16
                      Total_N_ageclass_Spr[17, 0] = TOTAL(WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 17
                      Total_N_ageclass_Spr[18, 0] = TOTAL(WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 18
                      Total_N_ageclass_Spr[19, 0] = TOTAL(WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 19
                      Total_N_ageclass_Spr[20, 0] = TOTAL(WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 20
                      Total_N_ageclass_Spr[21, 0] = TOTAL(WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 21
                      Total_N_ageclass_Spr[22, 0] = TOTAL(WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 22
                      Total_N_ageclass_Spr[23, 0] = TOTAL(WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 23
                      Total_N_ageclass_Spr[24, 0] = TOTAL(WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 24
                      Total_N_ageclass_Spr[25, 0] = TOTAL(WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 25
                      Total_N_ageclass_Spr[26, 0] = TOTAL(WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 26
                      PRINT, 'Derived age distribution of harvested fish'
                      PRINT, Total_N_ageclass_Spr[*, 0]
                      PRINT, 'Total number of harvested fish samples', TOTAL(Total_N_ageclass_Spr[*, 0])

                      ; Estimate age structure of harvested fish
                      Total_prop_ageclass_Spr = FLTARR(27L, 2L)
                      IF TOTAL(Total_N_ageclass_Spr[*, 0]) GT 0 THEN Total_prop_ageclass_Spr[*, 0] $
                        = Total_N_ageclass_Spr[*, 0]/TOTAL(Total_N_ageclass_Spr[*, 0])
                      PRINT, 'Relative age distribution'
                      PRINT, Total_prop_ageclass_Spr[*, 0]
                      
                      PRINT, 'N of harvested fish (Spearing)', N_harv_Spr[INDEX_lengthdataSpr[0]], $ 
                        HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]]
                        
                      IF TOTAL(Total_N_ageclass_Spr[*, 0]) GT 0 THEN paramset_Spr[13:39, i] $
                        = ROUND(Total_prop_ageclass_Spr[*, 0]* HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]])
                      PRINT, 'Estimated age distribution of harvested fish'
                      PRINT, paramset_Spr[13:39, i]

                      ; Calculate mean length-at-age for harvested fish
                      mean_length_at_age_Spr = FLTARR(27L, 37L)
                      mean_length_at_age_Spr[0, *] = (WAE_length_mean_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[1, *] = (WAE_length_mean_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[2, *] = (WAE_length_mean_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[3, *] = (WAE_length_mean_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[4, *] = (WAE_length_mean_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[5, *] = (WAE_length_mean_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[6, *] = (WAE_length_mean_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[7, *] = (WAE_length_mean_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[8, *] = (WAE_length_mean_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[9, *] = (WAE_length_mean_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[10, *] = (WAE_length_mean_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[11, *] = (WAE_length_mean_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[12, *] = (WAE_length_mean_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[13, *] = (WAE_length_mean_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[14, *] = (WAE_length_mean_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[15, *] = (WAE_length_mean_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[16, *] = (WAE_length_mean_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[17, *] = (WAE_length_mean_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[18, *] = (WAE_length_mean_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[19, *] = (WAE_length_mean_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[20, *] = (WAE_length_mean_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[21, *] = (WAE_length_mean_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[22, *] = (WAE_length_mean_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[23, *] = (WAE_length_mean_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[24, *] = (WAE_length_mean_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[25, *] = (WAE_length_mean_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      mean_length_at_age_Spr[26, *] = (WAE_length_mean_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      age0mean_Spr = where(mean_length_at_age_Spr[0, *] GT 0, age0mean_Sprcount)
                      age1mean_Spr = where(mean_length_at_age_Spr[1, *] GT 0, age1mean_Sprcount)
                      age2mean_Spr = where(mean_length_at_age_Spr[2, *] GT 0, age2mean_Sprcount)
                      age3mean_Spr = where(mean_length_at_age_Spr[3, *] GT 0, age3mean_Sprcount)
                      age4mean_Spr = where(mean_length_at_age_Spr[4, *] GT 0, age4mean_Sprcount)
                      age5mean_Spr = where(mean_length_at_age_Spr[5, *] GT 0, age5mean_Sprcount)
                      age6mean_Spr = where(mean_length_at_age_Spr[6, *] GT 0, age6mean_Sprcount)
                      age7mean_Spr = where(mean_length_at_age_Spr[7, *] GT 0, age7mean_Sprcount)
                      age8mean_Spr = where(mean_length_at_age_Spr[8, *] GT 0, age8mean_Sprcount)
                      age9mean_Spr = where(mean_length_at_age_Spr[9, *] GT 0, age9mean_Sprcount)
                      age10mean_Spr = where(mean_length_at_age_Spr[10, *] GT 0, age10mean_Sprcount)
                      age11mean_Spr = where(mean_length_at_age_Spr[11, *] GT 0, age11mean_Sprcount)
                      age12mean_Spr = where(mean_length_at_age_Spr[12, *] GT 0, age12mean_Sprcount)
                      age13mean_Spr = where(mean_length_at_age_Spr[13, *] GT 0, age13mean_Sprcount)
                      age14mean_Spr = where(mean_length_at_age_Spr[14, *] GT 0, age14mean_Sprcount)
                      age15mean_Spr = where(mean_length_at_age_Spr[15, *] GT 0, age15mean_Sprcount)
                      age16mean_Spr = where(mean_length_at_age_Spr[16, *] GT 0, age16mean_Sprcount)
                      age17mean_Spr = where(mean_length_at_age_Spr[17, *] GT 0, age17mean_Sprcount)
                      age18mean_Spr = where(mean_length_at_age_Spr[18, *] GT 0, age18mean_Sprcount)
                      age19mean_Spr = where(mean_length_at_age_Spr[19, *] GT 0, age19mean_Sprcount)
                      age20mean_Spr = where(mean_length_at_age_Spr[20, *] GT 0, age20mean_Sprcount)
                      age21mean_Spr = where(mean_length_at_age_Spr[21, *] GT 0, age21mean_Sprcount)
                      age22mean_Spr = where(mean_length_at_age_Spr[22, *] GT 0, age22mean_Sprcount)
                      age23mean_Spr = where(mean_length_at_age_Spr[23, *] GT 0, age23mean_Sprcount)
                      age24mean_Spr = where(mean_length_at_age_Spr[24, *] GT 0, age24mean_Sprcount)
                      age25mean_Spr = where(mean_length_at_age_Spr[25, *] GT 0, age25mean_Sprcount)
                      age26mean_Spr = where(mean_length_at_age_Spr[26, *] GT 0, age26mean_Sprcount)
                      IF age0mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[0, 1] = TOTAL(WAE_length_mean_Spr[10 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age0mean_Sprcount
                      IF age1mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[1, 1] = TOTAL(WAE_length_mean_Spr[11 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age1mean_Sprcount
                      IF age2mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[2, 1] = TOTAL(WAE_length_mean_Spr[12 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age2mean_Sprcount
                      IF age3mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[3, 1] = TOTAL(WAE_length_mean_Spr[13 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age3mean_Sprcount
                      IF age4mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[4, 1] = TOTAL(WAE_length_mean_Spr[14 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age4mean_Sprcount
                      IF age5mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[5, 1] = TOTAL(WAE_length_mean_Spr[15 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age5mean_Sprcount
                      IF age6mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[6, 1] = TOTAL(WAE_length_mean_Spr[16 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age6mean_Sprcount
                      IF age7mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[7, 1] = TOTAL(WAE_length_mean_Spr[17 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age7mean_Sprcount
                      IF age8mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[8, 1] = TOTAL(WAE_length_mean_Spr[18 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age8mean_Sprcount
                      IF age9mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[9, 1] = TOTAL(WAE_length_mean_Spr[19 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age9mean_Sprcount
                      IF age10mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[10, 1] = TOTAL(WAE_length_mean_Spr[20 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age10mean_Sprcount
                      IF age11mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[11, 1] = TOTAL(WAE_length_mean_Spr[21 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age11mean_Sprcount
                      IF age12mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[12, 1] = TOTAL(WAE_length_mean_Spr[22 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age12mean_Sprcount
                      IF age13mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[13, 1] = TOTAL(WAE_length_mean_Spr[23 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age13mean_Sprcount
                      IF age14mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[14, 1] = TOTAL(WAE_length_mean_Spr[24 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age14mean_Sprcount
                      IF age15mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[15, 1] = TOTAL(WAE_length_mean_Spr[25 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age15mean_Sprcount
                      IF age16mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[16, 1] = TOTAL(WAE_length_mean_Spr[26 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age16mean_Sprcount
                      IF age17mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[17, 1] = TOTAL(WAE_length_mean_Spr[27 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age17mean_Sprcount
                      IF age18mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[18, 1] = TOTAL(WAE_length_mean_Spr[28 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age18mean_Sprcount
                      IF age19mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[19, 1] = TOTAL(WAE_length_mean_Spr[29 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age19mean_Sprcount
                      IF age20mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[20, 1] = TOTAL(WAE_length_mean_Spr[30 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age20mean_Sprcount
                      IF age21mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[21, 1] = TOTAL(WAE_length_mean_Spr[31 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age21mean_Sprcount
                      IF age22mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[22, 1] = TOTAL(WAE_length_mean_Spr[32 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age22mean_Sprcount
                      IF age23mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[23, 1] = TOTAL(WAE_length_mean_Spr[33 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age23mean_Sprcount
                      IF age24mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[24, 1] = TOTAL(WAE_length_mean_Spr[34 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age24mean_Sprcount
                      IF age25mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[25, 1] = TOTAL(WAE_length_mean_Spr[35 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age25mean_Sprcount
                      IF age26mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[26, 1] = TOTAL(WAE_length_mean_Spr[36 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age26mean_Sprcount
                      PRINT, 'Mean length-at-age of harvested fish'
                      PRINT, Total_N_ageclass_Spr[*, 1]
                      
                      ; weighted means-at-age
                      IF age0mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[0, 1] = TOTAL(WAE_length_mean_Spr[10 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age1mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[1, 1] = TOTAL(WAE_length_mean_Spr[11 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age2mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[2, 1] = TOTAL(WAE_length_mean_Spr[12 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age3mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[3, 1] = TOTAL(WAE_length_mean_Spr[13 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age4mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[4, 1] = TOTAL(WAE_length_mean_Spr[14 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age5mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[5, 1] = TOTAL(WAE_length_mean_Spr[15 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age6mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[6, 1] = TOTAL(WAE_length_mean_Spr[16 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age7mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[7, 1] = TOTAL(WAE_length_mean_Spr[17 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age8mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[8, 1] = TOTAL(WAE_length_mean_Spr[18 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age9mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[9, 1] = TOTAL(WAE_length_mean_Spr[19 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age10mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[10, 1] = TOTAL(WAE_length_mean_Spr[20 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age11mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[11, 1] = TOTAL(WAE_length_mean_Spr[21 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age12mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[12, 1] = TOTAL(WAE_length_mean_Spr[22 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age13mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[13, 1] = TOTAL(WAE_length_mean_Spr[23 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age14mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[14, 1] = TOTAL(WAE_length_mean_Spr[24 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age15mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[15, 1] = TOTAL(WAE_length_mean_Spr[25 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age16mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[16, 1] = TOTAL(WAE_length_mean_Spr[26 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age17mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[17, 1] = TOTAL(WAE_length_mean_Spr[27 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age18mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[18, 1] = TOTAL(WAE_length_mean_Spr[28 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age19mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[19, 1] = TOTAL(WAE_length_mean_Spr[29 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age20mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[20, 1] = TOTAL(WAE_length_mean_Spr[30 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age21mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[21, 1] = TOTAL(WAE_length_mean_Spr[31 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age22mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[22, 1] = TOTAL(WAE_length_mean_Spr[32 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age23mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[23, 1] = TOTAL(WAE_length_mean_Spr[33 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age24mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[24, 1] = TOTAL(WAE_length_mean_Spr[34 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age25mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[25, 1] = TOTAL(WAE_length_mean_Spr[35 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      IF age26mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[26, 1] = TOTAL(WAE_length_mean_Spr[36 $
                        , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                        /TOTAL(WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
                      PRINT, 'Mean length-at-age of harvested fish'
                      PRINT, Total_N_ageclass_Spr[*, 1]
                      
                      paramset_Spr[40L:66, i] = Total_N_ageclass_Spr[*, 1]

                      Mean_mass_Spr = FLTARR(27L, 1)
                      Mean_mass_Spr = 1.5868E-006*Total_N_ageclass_Spr[*, 1]^3.2962
                      PRINT, 'Mean mass-at-age of harvested fish'
                      PRINT, Mean_mass_Spr

                      ; Lake-year-specific length-mass relations
                      INDEX_lengthmass = WHERE((Length_mass_par[3, *] EQ WBIC_Year[INDEX_lengthdata[0]]), INDEX_lengthmasscount)
                      INDEX_lengthmass2 = WHERE((Length_mass_par2[0, *] EQ WBIC[INDEX_lengthdata[0]]), INDEX_lengthmass2count)

                      LengthMassPar1a = string(Length_mass_par[4, INDEX_lengthmass], Format='(D0.3)')
                      LengthMassPar1b = string(Length_mass_par2[1, INDEX_lengthmass2], Format='(D0.3)')
                      print,'LengthMassPar1',LengthMassPar1a,LengthMassPar1b

                      IF (INDEX_lengthmasscount GT 0) THEN BEGIN
                        LengthMassPar1 = LengthMassPar1all+LengthMassPar1a
                        LengthMassPar2 = LengthMassPar2all
                        LengthMassParCheck = 1
                        N_Lake_year_LMfunc = N_Lake_year_LMfunc + 1L
                      ENDIF
                      IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count GT 0) THEN BEGIN
                        LengthMassPar1 = LengthMassPar1all+LengthMassPar1b
                        LengthMassPar2 = LengthMassPar2all
                        LengthMassParCheck = 2
                        N_Lake_LMfunc = N_Lake_LMfunc + 1L
                      ENDIF
                      IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count LE 0) THEN BEGIN
                        LengthMassPar1 = LengthMassPar1all
                        LengthMassPar2 = LengthMassPar2all
                        LengthMassParCheck = 3
                        N_state_LMfunc = N_state_LMfunc + 1L
                      ENDIF
                      PRINT, 'LengthMass params=', LengthMassParCheck
                      PRINT, LengthMassPar1, LengthMassPar2
                      paramset_Spr[231, i] = LengthMassParCheck; age-length key type

                      ; Population-mean body mass
                      Mean_mass_lakeyear = 10.^(LengthMassPar1 + LengthMassPar2*(ALOG10(Total_N_ageclass_Spr[*, 1])-logMeanLength) + 5.006e-03*0.5)
                      PRINT, 'Mean_mass_lakeyear', Mean_mass_lakeyear

                      Mean_mass_Spr = Mean_mass_lakeyear

                      paramset_Spr[67L:93, i] = Mean_mass_Spr

                      Age_NOmass_Spr = WHERE(Mean_mass_Spr LE 0, Age_NOmass_Sprcount)
                      Age_Wmass_Spr = WHERE(Mean_mass_Spr GT 0, Age_Wmass_Sprcount)
                      IF Age_Wmass_Sprcount GT 0. THEN PRINT, 'age class with mass data for harvested fish', Age_Wmass_Spr
                      IF Age_NOmass_Sprcount GT 0. THEN PRINT, 'age class without mass data of harvested fish', Age_NOmass_Spr
                      PRINT, 'max age class with mass of harvested fish', MAX(Age_Wmass_Spr)
                      PRINT, 'min age class with mass of harvested fish', MIN(Age_Wmass_Spr)

                      Age_mass_Spr_index = INDGEN(27)
                      Age_NOmass_Spr_Intrpl = WHERE((Age_NOmass_Spr GT min(Age_Wmass_Spr)) AND (Age_NOmass_Spr LT max(Age_Wmass_Spr)) $
                        , Age_NOmass_Spr_Intrplcount)
                      IF Age_NOmass_Spr_Intrplcount GT 0 THEN PRINT, 'age class mass need interpolation', Age_NOmass_Spr[Age_NOmass_Spr_Intrpl]

                      Biomass_ageclass_Spr = FLTARR(27L, 1)
                      Biomass_ageclass_Spr = Mean_mass_Spr*ROUND(Total_prop_ageclass_Spr[*, 0] $
                        *HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]])      ; masses are the same as the original lstocks
                      PRINT, 'Biomass-at-age of harvested fish'
                      PRINT, Biomass_ageclass_Spr
                      PRINT, 'Max biomass', MAX(Biomass_ageclass_Spr)
                      paramset_Spr[94L:120, i] = Biomass_ageclass_Spr

                      ; create age-specific biomass plots
                      Biomass_ageclass_SprAll=Biomass_ageclass_Spr/1000.
                      ;femaleBiomass=Biomass_ageclassF/1000.
                      ;unknownBiomass=Biomass_ageclassU/1000.

                      !p.font=0
                      ;Device, Set_Character_Size=[8,12]
                      Device, Get_Decomposed=currentState
                      DEVICE, SET_FONT='Courier', /TT_FONT
                      DEVICE, DECOMPOSED=0
                      cgDisplay, 750, 400, WID=4
                      ;!P.Multi = [0,2,1]
                      labels = INDGEN(27); ['Exp 1', 'Exp 2', 'Exp 3', 'Exp 4', 'Exp 5']
                      cgLoadct, 33, Clip=[10,245]
                      cgBarPlot, Biomass_ageclass_SprAll,  YRange=[0,MAX(Biomass_ageclass_SprALL)*1.2], Colors='DARKGRAY', BarNames=labels $
                        , xtitle='Age (years)'$
                        , ytitle='Biomass (Kg)' $;, xrange=[0, 25]
                        , title='Harvested (SPR) biomass distribution of WI walleye stocks - '+'WBIC: '+STRING(WBIC[INDEX_lengthdata[0]], FORMAT = '(I7)') $
                        +'_Year: '+STRING(fix(SurveyYear[INDEX_lengthdata[0]]), FORMAT = '(I4)')
                      ;XYOutS, ROUND(MEDIAN(INDGEN(27))), ROUND(0.5*(MAX(paramset[13:39, i]))*1.3), Orientation=90.0, /DEVICE
                      ;cgBarPlot, femaleBiomass, Colors='RED', /Overplot, BaseLines=maleBiomass
                      ;cgBarPlot, unknownBiomass, Colors='dark green', /Overplot, BaseLines=maleBiomass+femaleBiomass
                      ;items = ['Male', 'Female', 'Unknown']
                      ;colors = ['BLUE', 'RED', 'dark green']
                      ;AL_Legend, items, Colors=colors, PSym=Replicate(15,3), SymSize=Replicate(1.75,3), $
                      ;  Charsize=cgDefCharsize(), Position=[0.75, 0.85], /Normal

                      ; file name for WBIC-year-specific age structure
                      filename='Walleye harveseted (SPR) biomass'+ STRING(WBIC[INDEX_lengthdata[0]], FORMAT = '(I7)') $
                        +'_'+STRING(fix(SurveyYear[INDEX_lengthdata[0]]), FORMAT = '(I4)')+'.png'
                      WRITE_PNG, filename, TVRD(/TRUE)
                      DEVICE, DECOMPOSED=old_decomposed
                      !p.font=1

                      ; *******GAPS IN AGE CLASSS STILL NEED TO be INTERPOLATED!!!!!!!!!!!!!!!!!
                      PRINT, 'Total number of harvested fish (Spearing)', N_harv_Spr[INDEX_lengthdataSpr[0]] $
                        , HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]]
                      PRINT, 'Lake area (km2)', LakeArea[INDEX_lengthdata[0]]/1000000.; lake area (km2)

                      IF (LakeArea[INDEX_lengthdata[0]] GT 0.) THEN Total_biomass_Spr[i] $
                        = TOTAL(Biomass_ageclass_Spr[*, 0])/ LakeArea[INDEX_lengthdata[0]]*1000000./1000.
                      PRINT, 'Total harvested biomass (kg/km2)'
                      PRINT, Total_biomass_Spr[i]
                      paramset_Spr[202, i] = Total_biomass_Spr[i]

                      ; Estimates with only >age 3
                      IF (LakeArea[INDEX_lengthdata[0]] GT 0.) THEN Total_biomass_adult_Spr[i] $
                        = TOTAL(Biomass_ageclass_Spr[3L:26L, 0]) / LakeArea[INDEX_lengthdata[0]]*1000000./1000.
                      PRINT, 'Total harvested adult biomass (kg/km2)'
                      PRINT, Total_biomass_adult_Spr[i]
                      paramset_Spr[205L, i] = Total_biomass_adult_Spr[i]

                      ;IF adultPE_Spr[INDEX_lengthdataSpr[0]] GT 0 THEN paramset_Spr[210L, i] = N_harv_Spr[INDEX_lengthdataSpr[0]]/adultPE_Spr[INDEX_lengthdataSpr[0]]
                      paramset_Spr[210L, i] = HarvRate_Spr[INDEX_lengthdataSpr[0]]
              ENDIF; < unaged fish threshold
              ;IF INDEX_lengthdataSprcount LE 0 THEN PRINT, 'Harvest data not availabile'
            ;ENDIF; END of lake-specific key
        ENDIF


    ;#########################################################
    ;#Calculate harvested fish age structure for production
    ;#########################################################
    ;3.If specific length-age key does not exist OR the proportion of unaged fihs ABOVE the threshold...
    IF (INDEX_lengthdataSpr3count LE 0) OR (AgeLengthKeyCheck_Spr2 GE AgeLengthKeyLevel) THEN BEGIN
      N_Lake_WOkeys_Spr = N_Lake_WOkeys_Spr + 1L
      PRINT, 'N of lake-years with harvested biomass estimated with the statewide key', N_Lake_WOkeys_Spr
      
      INDEX_lengthdataSpr2C = INDGEN(37)
      PRINT,'INDEX_lengthdataSpr2C',INDEX_lengthdataSpr2C

      PRINT, 'No length-age key available'
      WBIC_year_key = Length_key3[0, *]
      WBIC_key = Length_key3[1, *]
      sample_year_key = Length_key3[2, *]
      total_N_fish = Length_key3[3, *]
      max_length = Length_key3[4, *]
      min_length = Length_key3[5, *]
      max_age = Length_key3[6, *]
      min_age = Length_key3[7, *]
      Length_bin_low = Length_key3[8, *]
      Length_N_fish = Length_key3[9, *]
      
      prop_age0 = Length_key3[10, *]
      prop_age1 = Length_key3[11, *]
      prop_age2 = Length_key3[12, *]
      prop_age3 = Length_key3[13, *]
      prop_age4 = Length_key3[14, *]
      prop_age5 = Length_key3[15, *]
      prop_age6 = Length_key3[16, *]
      prop_age7 = Length_key3[17, *]
      prop_age8 = Length_key3[18, *]
      prop_age9 = Length_key3[19, *]
      prop_age10 = Length_key3[20, *]
      prop_age11 = Length_key3[21, *]
      prop_age12 = Length_key3[22, *]
      prop_age13 = Length_key3[23, *]
      prop_age14 = Length_key3[24, *]
      prop_age15 = Length_key3[25, *]
      prop_age16 = Length_key3[26, *]
      prop_age17 = Length_key3[27, *]
      prop_age18 = Length_key3[28, *]
      prop_age19 = Length_key3[29, *]
      prop_age20 = Length_key3[30, *]
      prop_age21 = Length_key3[31, *]
      prop_age22 = Length_key3[32, *]
      prop_age23 = Length_key3[33, *]
      prop_age24 = Length_key3[34, *]
      prop_age25 = Length_key3[35, *]
      prop_age26 = Length_key3[36, *]

      Length_N_fishM = Length_key3[37, *]
      prop_age0M = Length_key3[38, *]
      prop_age1M = Length_key3[39, *]
      prop_age2M = Length_key3[40, *]
      prop_age3M = Length_key3[41, *]
      prop_age4M = Length_key3[42, *]
      prop_age5M = Length_key3[43, *]
      prop_age6M = Length_key3[44, *]
      prop_age7M = Length_key3[45, *]
      prop_age8M = Length_key3[46, *]
      prop_age9M = Length_key3[47, *]
      prop_age10M = Length_key3[48, *]
      prop_age11M = Length_key3[49, *]
      prop_age12M = Length_key3[50, *]
      prop_age13M = Length_key3[51, *]
      prop_age14M = Length_key3[52, *]
      prop_age15M = Length_key3[53, *]
      prop_age16M = Length_key3[54, *]
      prop_age17M = Length_key3[55, *]
      prop_age18M = Length_key3[56, *]
      prop_age19M = Length_key3[57, *]
      prop_age20M = Length_key3[58, *]
      prop_age21M = Length_key3[59, *]
      prop_age22M = Length_key3[60, *]
      prop_age23M = Length_key3[61, *]
      prop_age24M = Length_key3[62, *]
      prop_age25M = Length_key3[63, *]
      prop_age26M = Length_key3[64, *]

      Length_N_fishF = Length_key3[65, *]
      prop_age0F = Length_key3[66, *]
      prop_age1F = Length_key3[67, *]
      prop_age2F = Length_key3[68, *]
      prop_age3F = Length_key3[69, *]
      prop_age4F = Length_key3[70, *]
      prop_age5F = Length_key3[71, *]
      prop_age6F = Length_key3[72, *]
      prop_age7F = Length_key3[73, *]
      prop_age8F = Length_key3[74, *]
      prop_age9F = Length_key3[75, *]
      prop_age10F = Length_key3[76, *]
      prop_age11F = Length_key3[77, *]
      prop_age12F = Length_key3[78, *]
      prop_age13F = Length_key3[79, *]
      prop_age14F = Length_key3[80, *]
      prop_age15F = Length_key3[81, *]
      prop_age16F = Length_key3[82, *]
      prop_age17F = Length_key3[83, *]
      prop_age18F = Length_key3[84, *]
      prop_age19F = Length_key3[85, *]
      prop_age20F = Length_key3[86, *]
      prop_age21F = Length_key3[87, *]
      prop_age22F = Length_key3[88, *]
      prop_age23F = Length_key3[89, *]
      prop_age24F = Length_key3[90, *]
      prop_age25F = Length_key3[91, *]
      prop_age26F = Length_key3[92, *]
      PRINT, 'WBIC', WBIC[INDEX_lengthdata[0]]

      paramset[211, i] = 3                    ; age-length key type
      PRINT, paramset[211, i]

             ; 1.Assign age semi-randomly to lengths - ALL FISH
            IF SizeLT100_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 0
              LengthBinIndex2 = SizeLT100_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size100to120_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 1
              LengthBinIndex2 = Size100to120_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size120to140_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 2
              LengthBinIndex2 = Size120to140_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size140to160_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 3
              LengthBinIndex2 = Size140to160_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size160to180_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 4
              LengthBinIndex2 = Size160to180_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size180to200_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 5
              LengthBinIndex2 = Size180to200_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size200to220_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 6
              LengthBinIndex2 = Size200to220_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size220to240_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 7
              LengthBinIndex2 = Size220to240_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size240to260_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 8
              LengthBinIndex2 = Size240to260_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size260to280_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 9
              LengthBinIndex2 = Size260to280_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size280to300_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 10
              LengthBinIndex2 = Size280to300_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size300to320_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 11
              LengthBinIndex2 = Size300to320_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size320to340_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 12
              LengthBinIndex2 = Size320to340_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size340to360_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 13
              LengthBinIndex2 = Size340to360_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size360to380_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 14
              LengthBinIndex2 = Size360to380_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size380to400_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 15
              LengthBinIndex2 = Size380to400_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size400to420_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 16
              LengthBinIndex2 = Size400to420_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size420to440_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 17
              LengthBinIndex2 = Size420to440_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size440to460_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 18
              LengthBinIndex2 = Size440to460_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size460to480_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 19
              LengthBinIndex2 = Size460to480_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size480to500_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 20
              LengthBinIndex2 = Size480to500_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size500to520_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 21
              LengthBinIndex2 = Size500to520_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size520to540_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 22
              LengthBinIndex2 = Size520to540_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size540to560_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 23
              LengthBinIndex2 = Size540to560_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size560to580_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 24
              LengthBinIndex2 = Size560to580_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size580to600_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 25
              LengthBinIndex2 = Size580to600_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size600to620_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 26
              LengthBinIndex2 = Size600to620_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size620to640_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 27
              LengthBinIndex2 = Size620to640_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size640to660_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 28
              LengthBinIndex2 = Size640to660_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size660to680_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 29
              LengthBinIndex2 = Size660to680_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size680to700_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 30
              LengthBinIndex2 = Size680to700_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size700to720_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 31
              LengthBinIndex2 = Size700to720_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size720to740_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 32
              LengthBinIndex2 = Size720to740_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size740to760_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 33
              LengthBinIndex2 = Size740to760_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size760to780_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 34
              LengthBinIndex2 = Size760to780_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Size780to800_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 35
              LengthBinIndex2 = Size780to800_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            IF Sizege800_Sprcount GT 0 THEN BEGIN
              LengthBinIndex1 = 36
              LengthBinIndex2 = SizeGE800_Spr
              FishProb = AgeLengthKey(prop_age0, prop_age1, prop_age2, prop_age3, prop_age4, prop_age5 $
                , prop_age6, prop_age7, prop_age8, prop_age9, prop_age10, prop_age11, prop_age12 $
                , prop_age13, prop_age14, prop_age15, prop_age16, prop_age17, prop_age18, prop_age19 $
                , prop_age20, prop_age21, prop_age22, prop_age23, prop_age24, prop_age25 $
                , prop_age26, INDEX_lengthdataSpr2C, LengthBinIndex1)
              ;PRINT, 'FishProb', FishProb
              AgeAssignSpr = WalleyeAgeAssign(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              WAE_length_mean_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[0, *]
              WAE_length_bin_Spr[10:36, i*NumLengthBin+adj+LengthBinIndex1] = AgeAssignSpr[1, *]
              AgeAssignIndSpr = WalleyeAgeAssignInd(Length_prod_Spr[LengthBinIndex2], LengthBinIndex2 $
                , FishProb, FishAgeSpr[LengthBinIndex2], i+NumLengthBin+adj)
              FishAgeSpr[LengthBinIndex2] = AgeAssignIndSpr[0,*]
              FishLengthSpr[LengthBinIndex2] = AgeAssignIndSpr[1,*]
            ENDIF
            PRINT, "Age of fish harvested by tribes (FishAgeSpr)", FishAgeSpr
            PRINT, "Length of fish harvested by tribes (FishLengthSpr)", FishLengthSpr
            
                              
            ; mean age (all fish catch)
            AgeSprAll = WHERE(FishAgeSpr GE 0, AgeSprAllCOUNT)
            IF AgeSprAllCOUNT GT 0 THEN BEGIN
              paramset_spr[225, i] = MEAN(FishAgeSpr[AgeSprAll]); mean age for all fish
              IF N_ELEMENTS(FishAgeSpr[AgeSprAll]) GT 1 THEN paramset_spr[226, i] = STDDEV(FishAgeSpr[AgeSprAll]); SD age for all fish
            ENDIF
;                  AgeSprAllM = WHERE(FishAgeSpr[male] GE 0, AgeSprAllMCOUNT)
;                  IF AgeSprAllMCOUNT GT 0 THEN BEGIN
;                    paramset_spr[227, i] = MEAN(FishAge[male[AgeSprAllM]]); min age for males
;                    IF N_ELEMENTS(FishAgeSpr[AgeSprAllM]) GT 1 THEN paramset_spr[228, i] = STDDEV(FishAgeSpr[male[AgeSprAllM]]); min age for males
;                  ENDIF
;                  AgeSprAllF = WHERE(FishAgeSpr[female] GE 0, AgeSprAllFCOUNT)
;                  IF AgeSprAllFCOUNT GT 0 THEN BEGIN
;                    paramset_spr[229, i] = MEAN(FishAgeSpr[female[AgeSprAllF]]); max age for females
;                    IF N_ELEMENTS(FishAgeSpr[AgeSprAllF]) GT 1 THEN paramset_spr[230, i] = STDDEV(FishAgeSpr[female[AgeSprAllF]]); min age for females
;                  ENDIF

              ; Age structure of harvested fish (spearing)
              Total_N_ageclass_Spr = FLTARR(27L, 2L)
              Total_N_ageclass_Spr[0, 0] = TOTAL(WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 0
              Total_N_ageclass_Spr[1, 0] = TOTAL(WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 1
              Total_N_ageclass_Spr[2, 0] = TOTAL(WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 2
              Total_N_ageclass_Spr[3, 0] = TOTAL(WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 3
              Total_N_ageclass_Spr[4, 0] = TOTAL(WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 4
              Total_N_ageclass_Spr[5, 0] = TOTAL(WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 5
              Total_N_ageclass_Spr[6, 0] = TOTAL(WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 6
              Total_N_ageclass_Spr[7, 0] = TOTAL(WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 7
              Total_N_ageclass_Spr[8, 0] = TOTAL(WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 8
              Total_N_ageclass_Spr[9, 0] = TOTAL(WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 9
              Total_N_ageclass_Spr[10, 0] = TOTAL(WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 10
              Total_N_ageclass_Spr[11, 0] = TOTAL(WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 11
              Total_N_ageclass_Spr[12, 0] = TOTAL(WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 12
              Total_N_ageclass_Spr[13, 0] = TOTAL(WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 13
              Total_N_ageclass_Spr[14, 0] = TOTAL(WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 14
              Total_N_ageclass_Spr[15, 0] = TOTAL(WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 15
              Total_N_ageclass_Spr[16, 0] = TOTAL(WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 16
              Total_N_ageclass_Spr[17, 0] = TOTAL(WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 17
              Total_N_ageclass_Spr[18, 0] = TOTAL(WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 18
              Total_N_ageclass_Spr[19, 0] = TOTAL(WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 19
              Total_N_ageclass_Spr[20, 0] = TOTAL(WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 20
              Total_N_ageclass_Spr[21, 0] = TOTAL(WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 21
              Total_N_ageclass_Spr[22, 0] = TOTAL(WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 22
              Total_N_ageclass_Spr[23, 0] = TOTAL(WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 23
              Total_N_ageclass_Spr[24, 0] = TOTAL(WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 24
              Total_N_ageclass_Spr[25, 0] = TOTAL(WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 25
              Total_N_ageclass_Spr[26, 0] = TOTAL(WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]); age 26
              PRINT, 'Derived age distribution of harvested fish'
              PRINT, Total_N_ageclass_Spr[*, 0]
              PRINT, 'Total number of harvested fish samples', TOTAL(Total_N_ageclass_Spr[*, 0])

              ; Estimate age structure of harvested fish
              Total_prop_ageclass_Spr = FLTARR(27L, 2L)
              IF TOTAL(Total_N_ageclass_Spr[*, 0]) GT 0 THEN Total_prop_ageclass_Spr[*, 0] $
                = Total_N_ageclass_Spr[*, 0]/TOTAL(Total_N_ageclass_Spr[*, 0])
              PRINT, 'Relative age distribution'
              PRINT, Total_prop_ageclass_Spr[*, 0]
              PRINT, 'N of harvested fish (Spearing)', N_harv_Spr[INDEX_lengthdataSpr[0]], $ 
              HarvRate_spr[INDEX_lengthdataSpr[0]] * adultPE_spr[INDEX_lengthdataSpr[0]]
              
              IF TOTAL(Total_N_ageclass_Spr[*, 0]) GT 0 THEN paramset_Spr[13:39, i] = ROUND(Total_prop_ageclass_Spr[*, 0] $ 
                * HarvRate_spr[INDEX_lengthdataSpr[0]] * adultPE_spr[INDEX_lengthdataSpr[0]])
              PRINT, 'Estimated age distribution of harvested fish'
              PRINT, paramset_Spr[13:39, i]

              ; Calculate mean length-at-age for harvested fish
              mean_length_at_age_Spr = FLTARR(27L, 37L)
              mean_length_at_age_Spr[0, *] = (WAE_length_mean_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[1, *] = (WAE_length_mean_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[2, *] = (WAE_length_mean_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[3, *] = (WAE_length_mean_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[4, *] = (WAE_length_mean_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[5, *] = (WAE_length_mean_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[6, *] = (WAE_length_mean_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[7, *] = (WAE_length_mean_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[8, *] = (WAE_length_mean_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[9, *] = (WAE_length_mean_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[10, *] = (WAE_length_mean_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[11, *] = (WAE_length_mean_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[12, *] = (WAE_length_mean_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[13, *] = (WAE_length_mean_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[14, *] = (WAE_length_mean_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[15, *] = (WAE_length_mean_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[16, *] = (WAE_length_mean_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[17, *] = (WAE_length_mean_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[18, *] = (WAE_length_mean_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[19, *] = (WAE_length_mean_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[20, *] = (WAE_length_mean_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[21, *] = (WAE_length_mean_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[22, *] = (WAE_length_mean_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[23, *] = (WAE_length_mean_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[24, *] = (WAE_length_mean_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[25, *] = (WAE_length_mean_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              mean_length_at_age_Spr[26, *] = (WAE_length_mean_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              age0mean_Spr = where(mean_length_at_age_Spr[0, *] GT 0, age0mean_Sprcount)
              age1mean_Spr = where(mean_length_at_age_Spr[1, *] GT 0, age1mean_Sprcount)
              age2mean_Spr = where(mean_length_at_age_Spr[2, *] GT 0, age2mean_Sprcount)
              age3mean_Spr = where(mean_length_at_age_Spr[3, *] GT 0, age3mean_Sprcount)
              age4mean_Spr = where(mean_length_at_age_Spr[4, *] GT 0, age4mean_Sprcount)
              age5mean_Spr = where(mean_length_at_age_Spr[5, *] GT 0, age5mean_Sprcount)
              age6mean_Spr = where(mean_length_at_age_Spr[6, *] GT 0, age6mean_Sprcount)
              age7mean_Spr = where(mean_length_at_age_Spr[7, *] GT 0, age7mean_Sprcount)
              age8mean_Spr = where(mean_length_at_age_Spr[8, *] GT 0, age8mean_Sprcount)
              age9mean_Spr = where(mean_length_at_age_Spr[9, *] GT 0, age9mean_Sprcount)
              age10mean_Spr = where(mean_length_at_age_Spr[10, *] GT 0, age10mean_Sprcount)
              age11mean_Spr = where(mean_length_at_age_Spr[11, *] GT 0, age11mean_Sprcount)
              age12mean_Spr = where(mean_length_at_age_Spr[12, *] GT 0, age12mean_Sprcount)
              age13mean_Spr = where(mean_length_at_age_Spr[13, *] GT 0, age13mean_Sprcount)
              age14mean_Spr = where(mean_length_at_age_Spr[14, *] GT 0, age14mean_Sprcount)
              age15mean_Spr = where(mean_length_at_age_Spr[15, *] GT 0, age15mean_Sprcount)
              age16mean_Spr = where(mean_length_at_age_Spr[16, *] GT 0, age16mean_Sprcount)
              age17mean_Spr = where(mean_length_at_age_Spr[17, *] GT 0, age17mean_Sprcount)
              age18mean_Spr = where(mean_length_at_age_Spr[18, *] GT 0, age18mean_Sprcount)
              age19mean_Spr = where(mean_length_at_age_Spr[19, *] GT 0, age19mean_Sprcount)
              age20mean_Spr = where(mean_length_at_age_Spr[20, *] GT 0, age20mean_Sprcount)
              age21mean_Spr = where(mean_length_at_age_Spr[21, *] GT 0, age21mean_Sprcount)
              age22mean_Spr = where(mean_length_at_age_Spr[22, *] GT 0, age22mean_Sprcount)
              age23mean_Spr = where(mean_length_at_age_Spr[23, *] GT 0, age23mean_Sprcount)
              age24mean_Spr = where(mean_length_at_age_Spr[24, *] GT 0, age24mean_Sprcount)
              age25mean_Spr = where(mean_length_at_age_Spr[25, *] GT 0, age25mean_Sprcount)
              age26mean_Spr = where(mean_length_at_age_Spr[26, *] GT 0, age26mean_Sprcount)
              IF age0mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[0, 1] = TOTAL(WAE_length_mean_Spr[10 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age0mean_Sprcount
              IF age1mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[1, 1] = TOTAL(WAE_length_mean_Spr[11 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age1mean_Sprcount
              IF age2mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[2, 1] = TOTAL(WAE_length_mean_Spr[12 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age2mean_Sprcount
              IF age3mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[3, 1] = TOTAL(WAE_length_mean_Spr[13 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age3mean_Sprcount
              IF age4mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[4, 1] = TOTAL(WAE_length_mean_Spr[14 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age4mean_Sprcount
              IF age5mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[5, 1] = TOTAL(WAE_length_mean_Spr[15 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age5mean_Sprcount
              IF age6mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[6, 1] = TOTAL(WAE_length_mean_Spr[16 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age6mean_Sprcount
              IF age7mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[7, 1] = TOTAL(WAE_length_mean_Spr[17 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age7mean_Sprcount
              IF age8mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[8, 1] = TOTAL(WAE_length_mean_Spr[18 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age8mean_Sprcount
              IF age9mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[9, 1] = TOTAL(WAE_length_mean_Spr[19 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age9mean_Sprcount
              IF age10mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[10, 1] = TOTAL(WAE_length_mean_Spr[20 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age10mean_Sprcount
              IF age11mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[11, 1] = TOTAL(WAE_length_mean_Spr[21 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age11mean_Sprcount
              IF age12mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[12, 1] = TOTAL(WAE_length_mean_Spr[22 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age12mean_Sprcount
              IF age13mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[13, 1] = TOTAL(WAE_length_mean_Spr[23 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age13mean_Sprcount
              IF age14mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[14, 1] = TOTAL(WAE_length_mean_Spr[24 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age14mean_Sprcount
              IF age15mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[15, 1] = TOTAL(WAE_length_mean_Spr[25 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age15mean_Sprcount
              IF age16mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[16, 1] = TOTAL(WAE_length_mean_Spr[26 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age16mean_Sprcount
              IF age17mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[17, 1] = TOTAL(WAE_length_mean_Spr[27 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age17mean_Sprcount
              IF age18mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[18, 1] = TOTAL(WAE_length_mean_Spr[28 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age18mean_Sprcount
              IF age19mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[19, 1] = TOTAL(WAE_length_mean_Spr[29 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age19mean_Sprcount
              IF age20mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[20, 1] = TOTAL(WAE_length_mean_Spr[30 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age20mean_Sprcount
              IF age21mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[21, 1] = TOTAL(WAE_length_mean_Spr[31 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age21mean_Sprcount
              IF age22mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[22, 1] = TOTAL(WAE_length_mean_Spr[32 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age22mean_Sprcount
              IF age23mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[23, 1] = TOTAL(WAE_length_mean_Spr[33 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age23mean_Sprcount
              IF age24mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[24, 1] = TOTAL(WAE_length_mean_Spr[34 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age24mean_Sprcount
              IF age25mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[25, 1] = TOTAL(WAE_length_mean_Spr[35 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age25mean_Sprcount
              IF age26mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[26, 1] = TOTAL(WAE_length_mean_Spr[36 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L])/age26mean_Sprcount
              PRINT, 'Mean length-at-age of harvested fish'
              PRINT, Total_N_ageclass_Spr[*, 1]
              
              ; weighted means-at-age
              IF age0mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[0, 1] = TOTAL(WAE_length_mean_Spr[10 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[10, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age1mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[1, 1] = TOTAL(WAE_length_mean_Spr[11 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[11, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age2mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[2, 1] = TOTAL(WAE_length_mean_Spr[12 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[12, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age3mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[3, 1] = TOTAL(WAE_length_mean_Spr[13 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[13, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age4mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[4, 1] = TOTAL(WAE_length_mean_Spr[14 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[14, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age5mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[5, 1] = TOTAL(WAE_length_mean_Spr[15 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[15, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age6mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[6, 1] = TOTAL(WAE_length_mean_Spr[16 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[16, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age7mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[7, 1] = TOTAL(WAE_length_mean_Spr[17 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[17, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age8mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[8, 1] = TOTAL(WAE_length_mean_Spr[18 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[18, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age9mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[9, 1] = TOTAL(WAE_length_mean_Spr[19 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[19, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age10mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[10, 1] = TOTAL(WAE_length_mean_Spr[20 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[20, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age11mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[11, 1] = TOTAL(WAE_length_mean_Spr[21 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[21, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age12mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[12, 1] = TOTAL(WAE_length_mean_Spr[22 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[22, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age13mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[13, 1] = TOTAL(WAE_length_mean_Spr[23 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[23, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age14mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[14, 1] = TOTAL(WAE_length_mean_Spr[24 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[24, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age15mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[15, 1] = TOTAL(WAE_length_mean_Spr[25 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[25, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age16mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[16, 1] = TOTAL(WAE_length_mean_Spr[26 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[26, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age17mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[17, 1] = TOTAL(WAE_length_mean_Spr[27 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[27, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age18mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[18, 1] = TOTAL(WAE_length_mean_Spr[28 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[28, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age19mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[19, 1] = TOTAL(WAE_length_mean_Spr[29 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[29, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age20mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[20, 1] = TOTAL(WAE_length_mean_Spr[30 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[30, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age21mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[21, 1] = TOTAL(WAE_length_mean_Spr[31 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[31, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age22mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[22, 1] = TOTAL(WAE_length_mean_Spr[32 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[32, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age23mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[23, 1] = TOTAL(WAE_length_mean_Spr[33 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[33, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age24mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[24, 1] = TOTAL(WAE_length_mean_Spr[34 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[34, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age25mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[25, 1] = TOTAL(WAE_length_mean_Spr[35 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[35, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              IF age26mean_Sprcount GT 0 THEN Total_N_ageclass_Spr[26, 1] = TOTAL(WAE_length_mean_Spr[36 $
                , i*NumLengthBin+adj:i*NumLengthBin+adj+36L]*WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L]) $
                /TOTAL(WAE_length_bin_Spr[36, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])
              PRINT, 'Mean length-at-age of harvested fish'
              PRINT, Total_N_ageclass_Spr[*, 1]
              
              paramset_Spr[40L:66, i] = Total_N_ageclass_Spr[*, 1]

              Mean_mass_Spr = FLTARR(27L, 1)
              Mean_mass_Spr = 1.5868E-006*Total_N_ageclass_Spr[*, 1]^3.2962
              PRINT, 'Mean mass-at-age of harvested fish'
              PRINT, Mean_mass_Spr

              ; Lake-year-specific length-mass relations
              INDEX_lengthmass = WHERE((Length_mass_par[3, *] EQ WBIC_Year[INDEX_lengthdata[0]]), INDEX_lengthmasscount)
              INDEX_lengthmass2 = WHERE((Length_mass_par2[0, *] EQ WBIC[INDEX_lengthdata[0]]), INDEX_lengthmass2count)

              LengthMassPar1a = string(Length_mass_par[4, INDEX_lengthmass], Format='(D0.3)')
              LengthMassPar1b = string(Length_mass_par2[1, INDEX_lengthmass2], Format='(D0.3)')
              print,'LengthMassPar1',LengthMassPar1a,LengthMassPar1b

              IF (INDEX_lengthmasscount GT 0) THEN BEGIN
                LengthMassPar1 = LengthMassPar1all+LengthMassPar1a
                LengthMassPar2 = LengthMassPar2all
                LengthMassParCheck = 1
                N_Lake_year_LMfunc = N_Lake_year_LMfunc + 1L
              ENDIF
              IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count GT 0) THEN BEGIN
                LengthMassPar1 = LengthMassPar1all+LengthMassPar1b
                LengthMassPar2 = LengthMassPar2all
                LengthMassParCheck = 2
                N_Lake_LMfunc = N_Lake_LMfunc + 1L
              ENDIF
              IF (INDEX_lengthmasscount LE 0) AND (INDEX_lengthmass2count LE 0) THEN BEGIN
                LengthMassPar1 = LengthMassPar1all
                LengthMassPar2 = LengthMassPar2all
                LengthMassParCheck = 3
                N_state_LMfunc = N_state_LMfunc + 1L
              ENDIF
              PRINT, 'LengthMass params=', LengthMassParCheck
              PRINT, LengthMassPar1, LengthMassPar2
              paramset_Spr[231, i] = LengthMassParCheck; age-length key type

              ; Population-mean body mass
              Mean_mass_lakeyear = 10.^(LengthMassPar1 + LengthMassPar2*(ALOG10(Total_N_ageclass_Spr[*, 1])-logMeanLength) + 5.006e-03*0.5)
              PRINT, 'Mean_mass_lakeyear', Mean_mass_lakeyear

              Mean_mass_Spr = Mean_mass_lakeyear
              
              paramset_Spr[67L:93, i] = Mean_mass_Spr


              Age_NOmass_Spr = WHERE(Mean_mass_Spr LE 0, Age_NOmass_Sprcount)
              Age_Wmass_Spr = WHERE(Mean_mass_Spr GT 0, Age_Wmass_Sprcount)
              IF Age_Wmass_Sprcount GT 0. THEN PRINT, 'age class with mass data for harvested fish', Age_Wmass_Spr
              IF Age_NOmass_Sprcount GT 0. THEN PRINT, 'age class without mass data of harvested fish', Age_NOmass_Spr
              PRINT, 'max age class with mass of harvested fish', MAX(Age_Wmass_Spr)
              PRINT, 'min age class with mass of harvested fish', MIN(Age_Wmass_Spr)

              Age_mass_Spr_index = INDGEN(27)
              Age_NOmass_Spr_Intrpl = WHERE((Age_NOmass_Spr GT min(Age_Wmass_Spr)) AND (Age_NOmass_Spr LT max(Age_Wmass_Spr)) $
                , Age_NOmass_Spr_Intrplcount)
              IF Age_NOmass_Spr_Intrplcount GT 0 THEN PRINT, 'age class mass need interpolation', Age_NOmass_Spr[Age_NOmass_Spr_Intrpl]

              Biomass_ageclass_Spr = FLTARR(27L, 1)
              Biomass_ageclass_Spr = Mean_mass_Spr*ROUND(Total_prop_ageclass_Spr[*, 0] $
                *HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]])            ; masses are the same as the original lstocks
              PRINT, 'Biomass-at-age of harvested fish'
              PRINT, Biomass_ageclass_Spr
              PRINT, 'Max biomass', MAX(Biomass_ageclass_Spr)
              paramset_Spr[94L:120, i] = Biomass_ageclass_Spr

              ; create age-specific biomass plots
              Biomass_ageclass_SprAll=Biomass_ageclass_Spr/1000.
              ;femaleBiomass=Biomass_ageclassF/1000.
              ;unknownBiomass=Biomass_ageclassU/1000.

              !p.font=0
              ;Device, Set_Character_Size=[8,12]
              Device, Get_Decomposed=currentState
              DEVICE, SET_FONT='Courier', /TT_FONT
              DEVICE, DECOMPOSED=0
              cgDisplay, 750, 400, WID=4
              ;!P.Multi = [0,2,1]
              labels = INDGEN(27); ['Exp 1', 'Exp 2', 'Exp 3', 'Exp 4', 'Exp 5']
              cgLoadct, 33, Clip=[10,245]
              cgBarPlot, Biomass_ageclass_SprAll,  YRange=[0,MAX(Biomass_ageclass_SprALL)*1.2], Colors='DARKGRAY', BarNames=labels $
                , xtitle='Age (years)'$
                , ytitle='Biomass (Kg)' $;, xrange=[0, 25]
                , title='Harvested (SPR) biomass distribution of WI walleye stocks - '+'WBIC: '+STRING(WBIC[INDEX_lengthdata[0]], FORMAT = '(I7)') $
                +'_Year: '+STRING(fix(SurveyYear[INDEX_lengthdata[0]]), FORMAT = '(I4)')
              ;XYOutS, ROUND(MEDIAN(INDGEN(27))), ROUND(0.5*(MAX(paramset[13:39, i]))*1.3), Orientation=90.0, /DEVICE
              ;cgBarPlot, femaleBiomass, Colors='RED', /Overplot, BaseLines=maleBiomass
              ;cgBarPlot, unknownBiomass, Colors='dark green', /Overplot, BaseLines=maleBiomass+femaleBiomass
              ;items = ['Male', 'Female', 'Unknown']
              ;colors = ['BLUE', 'RED', 'dark green']
              ;AL_Legend, items, Colors=colors, PSym=Replicate(15,3), SymSize=Replicate(1.75,3), $
              ;  Charsize=cgDefCharsize(), Position=[0.75, 0.85], /Normal

              ; file name for WBIC-year-specific age structure
              filename='Walleye harveseted (SPR) biomass'+ STRING(WBIC[INDEX_lengthdata[0]], FORMAT = '(I7)') $
                +'_'+STRING(fix(SurveyYear[INDEX_lengthdata[0]]), FORMAT = '(I4)')+'.png'
              WRITE_PNG, filename, TVRD(/TRUE)
              DEVICE, DECOMPOSED=old_decomposed
              !p.font=1


              PRINT, 'Total number of harvested fish (Spring)', N_harv_Spr[INDEX_lengthdataSpr[0]] $
                , HarvRate_spr[INDEX_lengthdataSpr[0]]*adultPE_spr[INDEX_lengthdataSpr[0]]
              PRINT, 'Lake area (km2)', LakeArea[INDEX_lengthdata[0]]/1000000.; lake area (km2)
              
              IF (LakeArea[INDEX_lengthdata[0]] GT 0.) THEN Total_biomass_Spr[i] $
                = TOTAL(Biomass_ageclass_Spr[*, 0])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
              PRINT, 'Total harvested biomass (kg/km2)'
              PRINT, Total_biomass_Spr[i]
              paramset_Spr[202, i] = Total_biomass_Spr[i]

              ; Estimates with only >age 3
              IF (LakeArea[INDEX_lengthdata[0]] GT 0.) THEN Total_biomass_adult_Spr[i] $
                = TOTAL(Biomass_ageclass_Spr[3L:26L, 0])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
              PRINT, 'Total harvested adult biomass (kg/km2)'
              PRINT, Total_biomass_adult_Spr[i]
              paramset_Spr[205L, i] = Total_biomass_adult_Spr[i]

              paramset_Spr[210L, i] = HarvRate_Spr[INDEX_lengthdataSpr[0]]
            ENDIF; END OF REGION KEY FOR spearing                
          ;ENDIF; END OF INDEX_lengthdataSpr4count
          ENDIF; END of no lake-year-specific key
          

        
;      AgeArray[INDEX_lengthdata] = FishAge[*]
;      LengthArray[INDEX_lengthdata] = Fishlength[*]
;
;      ; Create a table for biomass and production -at-age - based on spring monitring surveys
;      AgeBioProd[0, i*27L : i*27L+26L] = paramset[0, i]
;      AgeBioProd[1, i*27L : i*27L+26L] = paramset[1, i]
;      AgeBioProd[2, i*27L : i*27L+26L] = paramset[2, i]
;      AgeBioProd[3, i*27L : i*27L+26L] = paramset[3, i]
;      AgeBioProd[4, i*27L : i*27L+26L] = paramset[4, i]
;      AgeBioProd[5, i*27L : i*27L+26L] = paramset[5, i]
;      AgeBioProd[6, i*27L : i*27L+26L] = paramset[6, i]
;      AgeBioProd[7, i*27L : i*27L+26L] = paramset[208, i]
;      AgeBioProd[8, i*27L : i*27L+26L] = paramset[209, i]
;      AgeBioProd[9, i*27L : i*27L+26L] = paramset[231, i]
;      AgeBioProd[10, i*27L : i*27L+26L] = paramset[232, i]
;      AgeBioProd[11, i*27L : i*27L+26L] = paramset[233, i]
;      AgeBioProd[33, i*27L : i*27L+26L] = paramset[213, i] ; number of age class
;      AgeBioProd[34, i*27L : i*27L+26L] = paramset[219, i] ; mean length of all fish
;      AgeBioProd[35, i*27L : i*27L+26L] = paramset[221, i] ; mean length of female
;      AgeBioProd[36, i*27L : i*27L+26L] = paramset[223, i] ; mean length of male
;      
;      
;      All_biomass = Biomass_ageclassM + Biomass_ageclassF + Biomass_ageclassU
;      IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN BEGIN
;        AgeBioProd[12, i*27L : i*27L+26L] = TOTAL(paramset[13:39, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.; all
;        AgeBioProd[13, i*27L : i*27L+26L] = TOTAL(All_biomass)/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;        AgeBioProd[14, i*27L : i*27L+26L] = TOTAL(paramset[148:174, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;        AgeBioProd[15, i*27L : i*27L+26L] = TOTAL(paramset[175:201, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;
;        AgeBioProd[16, i*27L : i*27L+26L] = TOTAL(paramset[17:39, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.; adult (age 4+)
;        AgeBioProd[17, i*27L : i*27L+26L] = TOTAL(All_biomass[4:26L])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;        AgeBioProd[18, i*27L : i*27L+26L] = TOTAL(paramset[152:174, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;        AgeBioProd[19, i*27L : i*27L+26L] = TOTAL(paramset[179:201, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;
;        AgeBioProd[20, i*27L : i*27L+26L] = TOTAL(All_biomass[5:26L])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
;        ; spawning biomass (age 5+)
;      END
;
;      AgeBioProd[21, i*27L : i*27L+26L] = INDGEN(27)
;      AgeBioProd[22, i*27L : i*27L+26L] = paramset[40:66, i]; mean length
;      AgeBioProd[23, i*27L : i*27L+26L] = paramset[67:93, i]; mean mass
;      AgeBioProd[24, i*27L : i*27L+26L] = paramset[121:147, i]; mean growth in mass
;
;      IF TOTAL(paramset[13:39, i])GT 0 THEN AgeBioProd[25, i*27L : i*27L+26L] = paramset[13:39, i] $
;        / TOTAL(paramset[13:39, i]); relative abundance
;      IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN AgeBioProd[26, i*27L : i*27L+26L] = paramset[13:39, i] $
;        /  LakeArea[INDEX_lengthdata[0]]*1000000.;  abundance
;
;      IF TOTAL(All_biomass) GT 0 THEN AgeBioProd[27, i*27L : i*27L+26L] = (Biomass_ageclassM + Biomass_ageclassF + Biomass_ageclassU) $
;        / TOTAL(All_biomass); relative biomass
;      IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN AgeBioProd[28, i*27L : i*27L+26L] = (Biomass_ageclassM + Biomass_ageclassF + Biomass_ageclassU) / $
;        LakeArea[INDEX_lengthdata[0]]*1000000./1000.; biomass
;
;      IF TOTAL(paramset[148:174, i]) GT 0 THEN AgeBioProd[29, i*27L : i*27L+26L] = paramset[148:174, i] $
;        / TOTAL(paramset[148:174, i]); relative mean biomass
;      IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN AgeBioProd[30, i*27L : i*27L+26L] = paramset[148:174, i] / LakeArea[INDEX_lengthdata[0]]*1000000./1000.; mean biomass
;
;      IF TOTAL(paramset[175:201, i]) GT 0 THEN AgeBioProd[31, i*27L : i*27L+26L] = paramset[175:201, i] $
;        / TOTAL(paramset[175:201, i]); relative production
;      IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN AgeBioProd[32, i*27L : i*27L+26L] = $
;                  paramset[175:201, i] / LakeArea[INDEX_lengthdata[0]]*1000000./1000.; adult production


    ; 2.Create a table for biomass-at-age on spearing
    AgeBioProd_spr[0, i*27L : i*27L+26L] = paramset_spr[0, i]                   ; wbic-year
    AgeBioProd_spr[1, i*27L : i*27L+26L] = paramset_spr[1, i]                   ; wbic
    AgeBioProd_spr[2, i*27L : i*27L+26L] = paramset_spr[2, i]                   ; year
    AgeBioProd_spr[3, i*27L : i*27L+26L] = paramset_spr[3, i]                   ; N of fish

    IF INDEX_lengthdataSpr[0] GT 0 THEN AgeBioProd_spr[4, i*27L : i*27L+26L] $
      = N_harv_spr[INDEX_lengthdataspr[0]]                                      ; N of harvested fish
    AgeBioProd_spr[5, i*27L : i*27L+26L] = paramset[209, i]                     ; area
    AgeBioProd_spr[6, i*27L : i*27L+26L] = paramset_spr[218, i]                 ; mean length - All
    AgeBioProd_spr[7, i*27L : i*27L+26L] = paramset_spr[220, i]                 ; mean length - M
    AgeBioProd_spr[8, i*27L : i*27L+26L] = paramset_spr[222, i]                 ; mean length - F
    AgeBioProd_spr[9, i*27L : i*27L+26L] = paramset_spr[225, i]                 ; mean age - all
    AgeBioProd_spr[10, i*27L : i*27L+26L] = paramset_spr[227, i]                ; mean age - male
    AgeBioProd_spr[11, i*27L : i*27L+26L] = paramset_spr[229, i]                ; mean age - female

    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN BEGIN
      AgeBioProd_spr[12, i*27L : i*27L+26L] = TOTAL(paramset_spr[13:39, i])/LakeArea[INDEX_lengthdata[0]]*1000000.            ; harvested total abundance
      AgeBioProd_spr[13, i*27L : i*27L+26L] = TOTAL(paramset_spr[94:120, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.     ; harvested total biomass
      AgeBioProd_spr[14, i*27L : i*27L+26L] = TOTAL(paramset_spr[17:39, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.      ; harvested adult (age 4+) abundance
      AgeBioProd_spr[15, i*27L : i*27L+26L] = TOTAL(paramset_spr[98:120, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.     ; harvested adult biomass
      PRINT, 'TOTAL(paramset_spr[98:120, i])/LakeArea[INDEX_lengthdataspr[0]]*1000000./1000.' $
        ,TOTAL(paramset_spr[98:120, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.
      AgeBioProd_spr[16, i*27L : i*27L+26L] = TOTAL(paramset_spr[99:120, i])/LakeArea[INDEX_lengthdata[0]]*1000000./1000.     ; harvested spawning biomass
      ; spawning biomass (age 5+)
    END

    AgeBioProd_spr[17, i*27L : i*27L+26L] = INDGEN(27)
    AgeBioProd_spr[18, i*27L : i*27L+26L] = paramset_spr[40:66, i]                                                             ; mean length of harvested fish
    AgeBioProd_spr[19, i*27L : i*27L+26L] = paramset_spr[67:93, i]                                                             ; mean mass of harvested fish

    IF TOTAL(paramset_spr[13:39, i])GT 0 THEN AgeBioProd_spr[20, i*27L : i*27L+26L] $
      = paramset_spr[13:39, i] / TOTAL(paramset_spr[13:39, i])                                                                 ; relative abundance
    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN AgeBioProd_spr[21, i*27L : i*27L+26L] $
      = paramset_spr[13:39, i] /  LakeArea[INDEX_lengthdata[0]]*1000000.                                                       ;  abundance

    IF TOTAL(paramset_spr[94:120, i]) GT 0 THEN AgeBioProd_spr[22, i*27L : i*27L+26L] $
      = paramset_spr[94:120, i] / TOTAL(paramset_spr[94:120, i])                                                               ; relative biomass
    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN AgeBioProd_spr[23, i*27L : i*27L+26L] $
      = paramset_spr[94:120, i] / LakeArea[INDEX_lengthdata[0]]*1000000./1000.                                                  ; biomass


    ; create output arrays for length bins
;    LengthSelect_Data[0, i*37L : i*37L+36L] = paramset[0, i]; wbic-year
;    LengthSelect_Data[1, i*37L : i*37L+36L] = paramset[1, i]; wbic
;    LengthSelect_Data[2, i*37L : i*37L+36L] = paramset[2, i]; year
;    LengthSelect_Data[3, i*37L : i*37L+36L] = paramset[3, i]; N of fish
;    LengthSelect_Data[4, i*37L : i*37L+36L] = PE[INDEX_lengthdata[0]]; adult PE
;    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN LengthSelect_Data[5, i*37L : i*37L+36L] = TOTAL(LengthDist[0:36, i]); harvested total abundance
;    LengthSelect_Data[6, i*37L : i*37L+36L] = INDGEN(37)
;    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN LengthSelect_Data[7, i*37L : i*37L+36L] = LengthDist[0:36, i];  abundance
;    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN LengthSelect_Data[8, i*37L : i*37L+36L] = LengthDist[0:36, i]/TOTAL(LengthDist[0:36, i]); relative abundance
;    IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN LengthSelect_Data[9, i*37L : i*37L+36L] $
;      = LengthDist[0:36, i]/TOTAL(LengthDist[0:36, i])*PE[INDEX_lengthdata[0]];  abundance estiamtes

        LengthSelect_Data[10, i*37L : i*37L+36L] = paramset_spr[0, i]                                                         ; wbic-year
        LengthSelect_Data[11, i*37L : i*37L+36L] = paramset_spr[1, i]                                                         ; wbic
        LengthSelect_Data[12, i*37L : i*37L+36L] = paramset_spr[2, i]                                                         ; year
        LengthSelect_Data[13, i*37L : i*37L+36L] = paramset_spr[3, i]                                                         ; N of fish
        IF paramset_spr[3, i] GT 0 THEN LengthSelect_Data[14, i*37L : i*37L+36L]  $
          = adultPE_spr[INDEX_lengthdataSpr[0]]*HarvRate_spr[INDEX_lengthdataSpr[0]]                                          ; harvested fish
        IF paramset_spr[3, i] GT 0 THEN LengthSelect_Data[15, i*37L : i*37L+36L] $
          = HarvRate_spr[INDEX_lengthdataSpr[0]]                                                                              ; harvest rate
        IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN LengthSelect_Data[16, i*37L : i*37L+36L] = TOTAL(LengthDist_spr[0:36, i])  ; harvested total abundance
        IF LakeArea[INDEX_lengthdata[0]] GT 0 THEN LengthSelect_Data[17, i*37L : i*37L+36L] = LengthDist_spr[0:36, i]         ; abundance
        IF TOTAL(LengthDist_spr[0:36, i]) GT 0 THEN LengthSelect_Data[18, i*37L : i*37L+36L] $
          = LengthDist_spr[0:36, i]/TOTAL(LengthDist_spr[0:36, i]); relative abundance
        IF TOTAL(LengthDist_spr[0:36, i]) GT 0 THEN LengthSelect_Data[19, i*37L : i*37L+36L] $
          = LengthDist_spr[0:36, i] $
          /TOTAL(LengthDist_spr[0:36, i])*adultPE_spr[INDEX_lengthdataSpr[0]]*HarvRate_spr[INDEX_lengthdataSpr[0]]            ; abundance estimates
          
      ENDIF; end of ???? data
    ENDIF; END of length survey data
    IF INDEX_lengthdataSprcount LE 0 THEN PRINT, 'Harvest data not availabile'
 ENDFOR; END OF WBIC_year loop
;  PRINT, 'Total biomass (kg/km2)'
;  PRINT, Total_biomass
;  PRINT, 'Total Production (kg/km2/year)'
;  PRINT, Total_Production
;  PRINT, 'P/B'
;  PRINT, P_over_B
;  PRINT, 'Adult biomass (kg/km2)'
;  PRINT, Total_biomass_adult
;  PRINT, 'Net adult Production (kg/km2/year)'
;  PRINT, Total_Production_adult
;  PRINT, 'Surplus adult Production (kg/km2/year)'
;  PRINT, TRANSPOSE(paramset[217L, *])
;  PRINT, 'Adult P/B'
;  PRINT, P_over_B_adult

PRINT, 'Total harvested biomass (kg/km2)'
PRINT, Total_biomass_Spr
PRINT, 'harvested adult biomass (kg/km2)'
PRINT, Total_biomass_adult_Spr
PRINT, 'Directedly estimated Total harvested biomass (kg/km2)'
PRINT, Total_biomass_Spr_direct
;PRINT, 'Ecotrophic coefficient'
;PRINT, Adult_ecotroph
;PRINT, 'Proportion of unsampled fish in the spring surveys'
;PRINT, Prop_LengthDist_spr_PLUS
;PRINT, 'Total N of production estiamtes'
;PRINT, N_Lake_year_Wkeys+N_Lake_Wkeys+N_Lake_WOkeys
PRINT, 'N of harvested (spearing) biomass estiamtes'
PRINT, N_Lake_year_Spr+N_Lake_Spr+N_Lake_WOkeys_Spr
PRINT, 'Total N of production estiamtes', N_Lake_year_Wkeys+N_Lake_Wkeys+N_Lake_WOkeys
PRINT, 'N of lake-years w/ lake-year-specific functions', N_Lake_year_LMfunc; number of lake years with lake-year-specific length-mass fucntions
PRINT, 'N of lake-years w/ lake-specific fucntions', N_Lake_LMfunc  ; number of lake years iwth lake-specific length-mass functions
PRINT, 'N of lake-years w/ state-wide function', N_state_LMfunc

Length_Age_Data = FLTARR(6, N)
Length_Age_Data[0, *] = WBIC_Year
Length_Age_Data[1, *] = WBIC
Length_Age_Data[2, *] = SurveyYear
Length_Age_Data[3, *] = SEX
Length_Age_Data[4, *] = LengthArray
Length_Age_Data[5, *] = AgeArray
PRINT, 'Lenght-at-age'
;PRINT, (Length_Age_Data)


; Export the output to a file
;; Ouptut 1
;ParamsetWdata = WHERE(paramset[0, *] GT 0, ParamsetWdatacount)
;Data = paramset[*, ParamsetWdata]
;;INDEX_length_age = WHERE(WAE_length_bin[1, *] GT 0., INDEX_length_agecount)
;;Data = WAE_length_bin[*, INDEX_length_age]
;filename1 = 'Out_wae_prod_lake-year.csv'
;;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
;s = Size(data, /Dimensions)
;xsize = s[0]
;lineWidth = 16000000
;comma = ","
;; Open the data file for writing.
;OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;;; Open the data file for writing.
;;IF pointer1 EQ 0L THEN OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;;IF pointer1 GT 0L THEN BEGIN;
;;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;;  SKIP_LUN, lun, pointer1, /lines
;;  READF, lun
;;ENDIF
;; Write the data to the file.
;sData = StrTrim(double(data), 2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;; Close the file.
;Free_Lun, lun

; Output 2
;ParamsetW_angldata = WHERE(paramset_angl[0, *] GT 0, ParamsetW_angldatacount)
Data2 = paramset_spr;[*, ParamsetW_angldata]
filename2 = 'out_wae_biom_spr.csv'
;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data2, /Dimensions)
xsize = s[0]
lineWidth = 16000000
comma = ","
; Open the data file for writing.
OpenW, lun, filename2, /Get_Lun, Width=lineWidth
;; Open the data file for writing.
;IF pointer1 EQ 0L THEN OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;IF pointer1 GT 0L THEN BEGIN;
;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer1, /lines
;  READF, lun
;ENDIF
; Write the data to the file.
sData2 = StrTrim(double(data2), 2)
sData2[0:xsize-2, *] = sData2[0:xsize-2, *] + comma
PrintF, lun, sData2
; Close the file.
Free_Lun, lun

;; Output 3
;;ParamsetW_angldata = WHERE(paramset_angl[0, *] GT 0, ParamsetW_angldatacount)
;Data3 = LengthDist
;filename3 = 'out_wae_length.dist.csv'
;;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
;s = Size(data3, /Dimensions)
;xsize = s[0]
;lineWidth = 16000000
;comma = ","
;; Open the data file for writing.
;OpenW, lun, filename3, /Get_Lun, Width=lineWidth
;;; Open the data file for writing.
;;IF pointer1 EQ 0L THEN OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;;IF pointer1 GT 0L THEN BEGIN;
;;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;;  SKIP_LUN, lun, pointer1, /lines
;;  READF, lun
;;ENDIF
;; Write the data to the file.
;sData3 = StrTrim(double(data3), 2)
;sData3[0:xsize-2, *] = sData3[0:xsize-2, *] + comma
;PrintF, lun, sData3
;; Close the file.
;Free_Lun, lun

; Output 4
;ParamsetW_angldata = WHERE(paramset_angl[0, *] GT 0, ParamsetW_angldatacount)
Data4 = LengthDist_spr2
filename4 = 'out_wae_length.dist_spr.csv'
;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data4, /Dimensions)
xsize = s[0]
lineWidth = 16000000
comma = ","
; Open the data file for writing.
OpenW, lun, filename4, /Get_Lun, Width=lineWidth
;; Open the data file for writing.
;IF pointer1 EQ 0L THEN OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;IF pointer1 GT 0L THEN BEGIN;
;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer1, /lines
;  READF, lun
;ENDIF
; Write the data to the file.
sData4 = StrTrim(double(data4), 2)
sData4[0:xsize-2, *] = sData4[0:xsize-2, *] + comma
PrintF, lun, sData4
; Close the file.
Free_Lun, lun

;; Output 7
;;ParamsetWdata = WHERE(paramset[0, *] GT 0, ParamsetWdatacount)
;Data7 = AgeBioProd;[*, ParamsetWdata]
;filename7 = 'out_wae_prod_lake-year_age.csv'
;;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
;s = Size(data7, /Dimensions)
;xsize = s[0]
;lineWidth = 16000000
;comma = ","
;; Open the data file for writing.
;OpenW, lun, filename7, /Get_Lun, Width=lineWidth
;; Write the data to the file.
;sData7 = StrTrim(double(data7), 2)
;sData7[0:xsize-2, *] = sData7[0:xsize-2, *] + comma
;PrintF, lun, sData7
;; Close the file.
;Free_Lun, lun

; Output 8
;ParamsetWdata = WHERE(paramset[0, *] GT 0, ParamsetWdatacount)
Data8 = AgeBioProd_spr;[*, ParamsetWdata]
filename8 = 'out_wae_biom_lake-year_age_spr.csv'
;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data8, /Dimensions)
xsize = s[0]
lineWidth = 16000000
comma = ","
; Open the data file for writing.
OpenW, lun, filename8, /Get_Lun, Width=lineWidth
; Write the data to the file.
sData8 = StrTrim(double(data8), 2)
sData8[0:xsize-2, *] = sData8[0:xsize-2, *] + comma
PrintF, lun, sData8
; Close the file.
Free_Lun, lun

; Output 9
;ParamsetWdata = WHERE(paramset[0, *] GT 0, ParamsetWdatacount)
Data9 = LengthSelect_Data;[*, ParamsetWdata]
filename9 = 'out_wae_lake-year_size_select_spr.csv'
;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data9, /Dimensions)
xsize = s[0]
lineWidth = 16000000
comma = ","
; Open the data file for writing.
OpenW, lun, filename9, /Get_Lun, Width=lineWidth
; Write the data to the file.
sData9 = StrTrim(double(data9), 2)
sData9[0:xsize-2, *] = sData9[0:xsize-2, *] + comma
PrintF, lun, sData9
; Close the file.
Free_Lun, lun


t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
;RETURN, ???; TURN OFF WHEN TESTING
END
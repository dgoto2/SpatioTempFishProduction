;;#######################################################################################
PRO AgeLengthSelectData
;  ; converting length to age for WI walleye data
;  ; calcualted total production of WI walleye from fishery-independent spring surveys
;  PRINT, 'a function to convert length to age for walleye stocks in Wisconsin, USA'
;  PRINT, 'Created: Apr 26, 2014'
;  PRINT, 'Updated: Jul 5, 2015'
;  ; ***Use (not use) sex-sepcific estimates for the subsequent analsyses
;  ;#######################################################################################

  ; Identify a direcotry for exporting daily output of state variables as .csv file
  CD, 'C:\Users\Daisuke\OneDrive\Walleye_production_project\Walleye outputs'

  ; Input file paths
  ; 1.walleye age & length selection data from spring surveys
  file1 = FILEPATH('WI_wae_ageselectIDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\OneDrive\Walleye_production_project\Data')
  file2 = FILEPATH('WI_wae_sizeselectIDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\OneDrive\Walleye_production_project\Data')

  ; Check if the file is not blank
  IF (N_ELEMENTS(file1) EQ 0L) THEN MESSAGE, 'FILE is undefined'
  IF (N_ELEMENTS(file2) EQ 0L) THEN MESSAGE, 'FILE is undefined'

  ;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

  ; Define the data structure
  N = 543L                             ; survey data - data set3
  AgeSelect_Data = DOUBLE(FLTARR(45L, N))
  LengthSelect_Data = DOUBLE(FLTARR(60L, N))

  ; read input length & PE data
  OPENR, lun, file1, /GET_LUN
  READF, lun, AgeSelect_Data;, FORMAT='(A17, x, I0)';
  FREE_LUN, lun
  ;PRINT, LengthSelect_Data

  WBIC_Year = AgeSelect_Data[0, *]
  WBIC = AgeSelect_Data[2, *]
  SurveyYear = AgeSelect_Data[3, *]
  region_code = AgeSelect_Data[4, *]
  lakearea_km2 = AgeSelect_Data[5, *]
  lakearea_acre = AgeSelect_Data[6, *]
  lakesize_code = AgeSelect_Data[7, *]
  yoy_type = AgeSelect_Data[9, *]
  stock_type = AgeSelect_Data[10, *]
  N_fish_samples = AgeSelect_Data[11, *]
  PE = AgeSelect_Data[12, *]
  Nageclass = AgeSelect_Data[13, *]
  peak_age = AgeSelect_Data[14, *]
  max_age = AgeSelect_Data[15, *]
  harvest_spr = AgeSelect_Data[16, *]
  selectspr = AgeSelect_Data[17:29, *]
  harvest_ang = AgeSelect_Data[30, *]
  legal_size_limit = AgeSelect_Data[31, *]
  selectang = AgeSelect_Data[32:44, *]
  ;print,'selectspr', selectspr
  ;print,'selectang',selectang

  ; read input length & PE data
  OPENR, lun, file2, /GET_LUN
  READF, lun, LengthSelect_Data;, FORMAT='(A17, x, I0)';
  FREE_LUN, lun
  ;PRINT, LengthSelect_Data

  WBIC_Year = LengthSelect_Data[0, *]
  WBIC = LengthSelect_Data[1, *]
  SurveyYear = LengthSelect_Data[2, *]
  region_code = LengthSelect_Data[3, *]
  lakearea_km2 = LengthSelect_Data[4, *]
  lakearea_acre = LengthSelect_Data[5, *]
  lakesize_code = LengthSelect_Data[6, *]
  yoy_type = LengthSelect_Data[8, *]
  stock_type = LengthSelect_Data[9, *]
  N_fish_samples = LengthSelect_Data[10, *]
  PE = LengthSelect_Data[11, *]
  Nageclass = LengthSelect_Data[12, *]
  peak_age = LengthSelect_Data[13, *]
  max_age = LengthSelect_Data[14, *]
  harvest_spr = LengthSelect_Data[15, *]
  selectspr = LengthSelect_Data[16:36, *]
  harvest_ang = LengthSelect_Data[37, *]
  legal_size_limit = LengthSelect_Data[38, *]
  selectang = LengthSelect_Data[39:59, *]

SelectData1 = FLTARR(25L, N_ELEMENTS(WBIC_Year)*13L) 
SelectData2 = FLTARR(25L, N_ELEMENTS(WBIC_Year)*21L)

FOR i = 0L, N_ELEMENTS(WBIC_Year)-1L DO BEGIN
  ;print,'in',transpose(LengthSelect_Data[0:16, i])
  
;  print,i*13L, i*13L+12L
;  SelectData1[0:16, i*13L:i*13L+12L] = transpose(rebin(reform(AgeSelect_Data[0:15, i], 1,17L),13,17))
;  SelectData1[17, i*13L:i*13L+12L] = indgen(13)+3
;  SelectData1[18, i*13L:i*13L+12L] = transpose(AgeSelect_Data[17:29, i])
;  SelectData1[19, i*13L:i*13L+12L] = transpose(rebin(reform(AgeSelect_Data[30, i], 1,1L),1,13))
;  SelectData1[20, i*13L:i*13L+12L] = transpose(rebin(reform(AgeSelect_Data[31, i], 1,1L),1,13))
;  SelectData1[21, i*13L:i*13L+12L] = transpose(AgeSelect_Data[32:44, i])
  
  print,i*21L, i*21L+20L
  SelectData2[0:15, i*21L:i*21L+20L] = transpose(rebin(reform(LengthSelect_Data[0:15, i], 1,16L),21,16))
  SelectData2[16, i*21L:i*21L+20L] = indgen(21)*20+310
  SelectData2[17, i*21L:i*21L+20L] = transpose(LengthSelect_Data[16:36, i])
  SelectData2[18, i*21L:i*21L+20L] = transpose(rebin(reform(LengthSelect_Data[37, i], 1,1L),1,21))
  SelectData2[19, i*21L:i*21L+20L] = transpose(rebin(reform(LengthSelect_Data[38, i], 1,1L),1,21))
  SelectData2[20, i*21L:i*21L+20L] = transpose(LengthSelect_Data[39:59, i])
  ;print, 'out', SelectData[17:20, i*13L:i*13L+12L]
;stop
ENDFOR

; Export the output to a file
; Ouptut 1
Data1 = SelectData2
;INDEX_length_age = WHERE(WAE_length_bin[1, *] GT 0., INDEX_length_agecount)
;Data = WAE_length_bin[*, INDEX_length_age]
filename1 = 'out_wae_sizeselect_lake-year.csv'
;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data1, /Dimensions)
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
sData1 = StrTrim(double(data1), 2)
sData1[0:xsize-2, *] = sData1[0:xsize-2, *] + comma
PrintF, lun, sData1
; Close the file.
Free_Lun, lun

;0 wbic_year
;1 wbic_year2
;2 wbic
;3 year
;4 region_code
;5 lakearea_km2
;6 lakearea_acre
;7 lakesize_code
;8 lake_code
;9 yoy_type
;10  stock_type
;11  N_fish_samples
;12  PE
;13  Nageclass
;14  peak_age
;15  max_age
;16  harvest_rate_spr
;17  selectspr_age3
;18  selectspr_age4
;19  selectspr_age5
;20  selectspr_age6
;21  selectspr_age7
;22  selectspr_age8
;23  selectspr_age9
;24  selectspr_age10
;25  selectspr_age11
;26  selectspr_age12
;27  selectspr_age13
;28  selectspr_age14
;29  selectspr_age15
;30  harvest_rate_ang
;31  legal_size_limit
;32  selectang_age3
;33  selectang_age4
;34  selectang_age5
;35  selectang_age6
;36  selectang_age7
;37  selectang_age8
;38  selectang_age9
;39  selectang_age10
;40  selectang_age11
;41  selectang_age12
;42  selectang_age13
;43  selectang_age14
;44  selectang_age15


;0 wbic_year
;1 wbic
;2 year
;3 region_code
;4 lakearea_km2
;5 lakearea_acre
;6 lakesize_code
;7 lake_code
;8 yoy_type
;9 stock_type
;10  N_fish_samples
;11  PE
;12  Nageclass
;13  peak_age
;14  max_age
;15  harvest_rate_spr
;16  spr300
;17  spr320
;18  spr340
;19  spr360
;20  spr380
;21  spr400
;22  spr420
;23  spr440
;24  spr460
;25  spr480
;26  spr500
;27  spr520
;28  spr540
;29  spr560
;30  spr580
;31  spr600
;32  spr620
;33  spr640
;34  spr660
;35  spr680
;36  spr700
;37  harvest_rate_ang
;38  legal size limit
;39  ang300
;40  ang320
;41  ang340
;42  ang360
;43  ang380
;44  ang400
;45  ang420
;46  ang440
;47  ang460
;48  ang480
;49  ang500
;50  ang520
;51  ang540
;52  ang560
;53  ang580
;54  ang600
;55  ang620
;56  ang640
;57  ang660
;58  ang680
;59  ang700


END
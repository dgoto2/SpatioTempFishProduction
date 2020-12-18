;;#######################################################################################
PRO AgeSelectData
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
  ; 1.walleye length data from spring surveys
  file = FILEPATH('WI_wae_ageselectIDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\OneDrive\Walleye_production_project\Data')

  ; Check if the file is not blank
  IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
  ;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

  ; Define the data structure
  N = 543L                             ; survey data - data set3
  LengthSelect_Data = DOUBLE(FLTARR(45L, N))

  ; read input length & PE data
  OPENR, lun, file, /GET_LUN
  READF, lun, LengthSelect_Data;, FORMAT='(A17, x, I0)';
  FREE_LUN, lun
  ;PRINT, LengthSelect_Data

  WBIC_Year = LengthSelect_Data[0, *]
  WBIC = LengthSelect_Data[2, *]
  SurveyYear = LengthSelect_Data[3, *]
  region_code = LengthSelect_Data[4, *]
  lakearea_km2 = LengthSelect_Data[5, *]
  lakearea_acre = LengthSelect_Data[6, *]
  lakesize_code = LengthSelect_Data[7, *]
  yoy_type = LengthSelect_Data[9, *]
  stock_type = LengthSelect_Data[10, *]
  N_fish_samples = LengthSelect_Data[11, *]
  PE = LengthSelect_Data[12, *]
  Nageclass = LengthSelect_Data[13, *]
  peak_age = LengthSelect_Data[14, *]
  max_age = LengthSelect_Data[15, *]
  harvest_spr = LengthSelect_Data[16, *]
  selectspr = LengthSelect_Data[17:29, *]
  harvest_ang = LengthSelect_Data[30, *]
  legal_size_limit = LengthSelect_Data[31, *]
  selectang = LengthSelect_Data[32:44, *]
;print,'selectspr', selectspr
;print,'selectang',selectang

SelectData = FLTARR(25L, N_ELEMENTS(WBIC_Year)*13L) 
FOR i = 0L, N_ELEMENTS(WBIC_Year)-1L DO BEGIN
  ;print,'in',transpose(LengthSelect_Data[0:16, i])
  print,i*13L, i*13L+12L
  SelectData[0:16, i*13L:i*13L+12L] = transpose(rebin(reform(LengthSelect_Data[0:16, i], 1,17L),13,17))
  SelectData[17, i*13L:i*13L+12L] = indgen(13)+3
  SelectData[18, i*13L:i*13L+12L] = transpose(LengthSelect_Data[17:29, i])
  SelectData[19, i*13L:i*13L+12L] = transpose(rebin(reform(LengthSelect_Data[30, i], 1,1L),1,13))
  SelectData[20, i*13L:i*13L+12L] = transpose(rebin(reform(LengthSelect_Data[31, i], 1,1L),1,13))
  SelectData[21, i*13L:i*13L+12L] = transpose(LengthSelect_Data[32:44, i])
  ;print, 'out', SelectData[17:20, i*13L:i*13L+12L]
;stop
ENDFOR

; Export the output to a file
; Ouptut 1
Data1 = SelectData
;INDEX_length_age = WHERE(WAE_length_bin[1, *] GT 0., INDEX_length_agecount)
;Data = WAE_length_bin[*, INDEX_length_age]
filename1 = 'out_wae_ageselect_lake-year.csv'
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
END
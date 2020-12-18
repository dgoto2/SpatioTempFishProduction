PRO LifetimeGDD
; this routine calculates cumulative gdd over lifetime

; Identify a direcotry for exporting output as .csv file
CD, 'C:\Users\Daisuke\OneDrive\Walleye_production_project\Walleye outputs'

; Input file paths
; 1.walleye length data from spring surveys
file = FILEPATH('WI_gdd_all_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke\OneDrive\Walleye_production_project\Data')

; Check if the file is not blank
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Define the data structure
N = 80114L                             ; survey data - data set3
GDD_Data = DOUBLE(FLTARR(4L, N))
;wbic_year
;year
;wbic
;gdd_5c
;gdd_10c

; read input length & PE data
OPENR, lun, file, /GET_LUN
READF, lun, GDD_Data;, FORMAT='(A17, x, I0)';
FREE_LUN, lun
WBIC_Year = GDD_Data[0, *]
WBIC = GDD_Data[1, *]
SurveyYear = GDD_Data[2, *]
GDD5 = GDD_Data[3, *]
;PRINT, 'GDD_Data', GDD_Data

; Find unique lake-years for production estiamtes
uniqWBIC_Year = WBIC_Year[UNIQ(WBIC_Year, SORT(WBIC_Year))] ; 568 lake years with potential estimates
PRINT, 'Total N of WBIC_years', n_elements(uniqWBIC_Year)
uniqWBIC = WBIC[UNIQ(WBIC, SORT(WBIC))]                     ; 264 lakes
PRINT, 'Total N of WBIC', n_elements(uniqWBIC)

cumGDD5yr = fltarr(2012-1989+1)
meanGDD5yr = fltarr(2012-1989+1)
cumGDD10yr = fltarr(2012-1989+1)
meanGDD10yr = fltarr(2012-1989+1)
cumGDDage = fltarr(15)
outputGDD = fltarr(6L,(2012L-1989+1)*N_ELEMENTS(uniqWBIC))
; (1)WBIC, (2)survey year, (3)cumGDD5yr, (4)meanGDD5yr, (5)cumGDD10yr, (6)meanGDD10yr, 

; 1. Loop through WBIC_years
FOR i = 0L, N_ELEMENTS(uniqWBIC)-1L DO BEGIN
  PRINT, 'WBIC(i)', i
  IF i EQ 0L THEN adj = 0                                         ; adjustment to the loop index for outputs
  IF i GT 1L THEN adj = 1
  INDEX_GDDdata = WHERE((WBIC[*] EQ uniqWBIC[i]), INDEX_GDDdatacount)
  IF INDEX_GDDdatacount GT 0 THEN PRINT, 'WBIC', WBIC[INDEX_GDDdata[0]]
  ;PRINT, 'GDD5',GDD_Data[1:3, INDEX_GDDdata]
  ;initial year: 1989  
  ;1979-2012 = 0-33
  outputGDD[0, 24L*i:23L+i*24] = uniqWBIC[i]
  outputGDD[1, 24L*i:23L+i*24] = findgen(24)+1989

  IF n_elements(INDEX_GDDdata) EQ 34 THEN BEGIN
    ; 5-year cuulative GDDs
    cumGDD5yr[0] = TOTAL(GDD5[INDEX_GDDdata[5:9]]); survey year: 1989
    cumGDD5yr[1] = TOTAL(GDD5[INDEX_GDDdata[5+1:9+1]])
    cumGDD5yr[2] = TOTAL(GDD5[INDEX_GDDdata[5+2:9+2]])
    cumGDD5yr[3] = TOTAL(GDD5[INDEX_GDDdata[5+3:9+3]])
    cumGDD5yr[4] = TOTAL(GDD5[INDEX_GDDdata[5+4:9+4]])
    cumGDD5yr[5] = TOTAL(GDD5[INDEX_GDDdata[5+5:9+5]])
    cumGDD5yr[6] = TOTAL(GDD5[INDEX_GDDdata[5+6:9+6]])
    cumGDD5yr[7] = TOTAL(GDD5[INDEX_GDDdata[5+7:9+7]])
    cumGDD5yr[8] = TOTAL(GDD5[INDEX_GDDdata[5+8:9+8]])
    cumGDD5yr[9] = TOTAL(GDD5[INDEX_GDDdata[5+9:9+9]])
    cumGDD5yr[10] = TOTAL(GDD5[INDEX_GDDdata[5+10:9+10]])
    cumGDD5yr[11] = TOTAL(GDD5[INDEX_GDDdata[5+11:9+11]])
    cumGDD5yr[12] = TOTAL(GDD5[INDEX_GDDdata[5+12:9+12]])
    cumGDD5yr[13] = TOTAL(GDD5[INDEX_GDDdata[5+13:9+13]])
    cumGDD5yr[14] = TOTAL(GDD5[INDEX_GDDdata[5+14:9+14]])
    cumGDD5yr[15] = TOTAL(GDD5[INDEX_GDDdata[5+15:9+15]])
    cumGDD5yr[16] = TOTAL(GDD5[INDEX_GDDdata[5+16:9+16]])
    cumGDD5yr[17] = TOTAL(GDD5[INDEX_GDDdata[5+17:9+17]])
    cumGDD5yr[18] = TOTAL(GDD5[INDEX_GDDdata[5+18:9+18]])
    cumGDD5yr[19] = TOTAL(GDD5[INDEX_GDDdata[5+19:9+19]])
    cumGDD5yr[20] = TOTAL(GDD5[INDEX_GDDdata[5+20:9+20]])
    cumGDD5yr[21] = TOTAL(GDD5[INDEX_GDDdata[5+21:9+21]])
    cumGDD5yr[22] = TOTAL(GDD5[INDEX_GDDdata[5+22:9+22]])
    cumGDD5yr[23] = TOTAL(GDD5[INDEX_GDDdata[5+23:9+23]])
    ;print, 'cumGDD5yr', cumGDD5yr
    outputGDD[2, 24L*i:23L+i*24] = cumGDD5yr
    
    ; 5-year mean GDDs
    meanGDD5yr[0] = MEAN(GDD5[INDEX_GDDdata[5:9]]); survey year: 1989
    meanGDD5yr[1] = MEAN(GDD5[INDEX_GDDdata[5+1:9+1]])
    meanGDD5yr[2] = MEAN(GDD5[INDEX_GDDdata[5+2:9+2]])
    meanGDD5yr[3] = MEAN(GDD5[INDEX_GDDdata[5+3:9+3]])
    meanGDD5yr[4] = MEAN(GDD5[INDEX_GDDdata[5+4:9+4]])
    meanGDD5yr[5] = MEAN(GDD5[INDEX_GDDdata[5+5:9+5]])
    meanGDD5yr[6] = MEAN(GDD5[INDEX_GDDdata[5+6:9+6]])
    meanGDD5yr[7] = MEAN(GDD5[INDEX_GDDdata[5+7:9+7]])
    meanGDD5yr[8] = MEAN(GDD5[INDEX_GDDdata[5+8:9+8]])
    meanGDD5yr[9] = MEAN(GDD5[INDEX_GDDdata[5+9:9+9]])
    meanGDD5yr[10] = MEAN(GDD5[INDEX_GDDdata[5+10:9+10]])
    meanGDD5yr[11] = MEAN(GDD5[INDEX_GDDdata[5+11:9+11]])
    meanGDD5yr[12] = MEAN(GDD5[INDEX_GDDdata[5+12:9+12]])
    meanGDD5yr[13] = MEAN(GDD5[INDEX_GDDdata[5+13:9+13]])
    meanGDD5yr[14] = MEAN(GDD5[INDEX_GDDdata[5+14:9+14]])
    meanGDD5yr[15] = MEAN(GDD5[INDEX_GDDdata[5+15:9+15]])
    meanGDD5yr[16] = MEAN(GDD5[INDEX_GDDdata[5+16:9+16]])
    meanGDD5yr[17] = MEAN(GDD5[INDEX_GDDdata[5+17:9+17]])
    meanGDD5yr[18] = MEAN(GDD5[INDEX_GDDdata[5+18:9+18]])
    meanGDD5yr[19] = MEAN(GDD5[INDEX_GDDdata[5+19:9+19]])
    meanGDD5yr[20] = MEAN(GDD5[INDEX_GDDdata[5+20:9+20]])
    meanGDD5yr[21] = MEAN(GDD5[INDEX_GDDdata[5+21:9+21]])
    meanGDD5yr[22] = MEAN(GDD5[INDEX_GDDdata[5+22:9+22]])
    meanGDD5yr[23] = MEAN(GDD5[INDEX_GDDdata[5+23:9+23]])
    ;PRINT, 'meanGDD5yr', meanGDD5yr
    outputGDD[3, 24L*i:23L+i*24] = meanGDD5yr

    ; 10-year cumulative GDDs
    cumGDD10yr[0] = TOTAL(GDD5[INDEX_GDDdata[0:9]]); survey year: 1989
    cumGDD10yr[1] = TOTAL(GDD5[INDEX_GDDdata[0+1:9+1]])
    cumGDD10yr[2] = TOTAL(GDD5[INDEX_GDDdata[0+2:9+2]])
    cumGDD10yr[3] = TOTAL(GDD5[INDEX_GDDdata[0+3:9+3]])
    cumGDD10yr[4] = TOTAL(GDD5[INDEX_GDDdata[0+4:9+4]])
    cumGDD10yr[5] = TOTAL(GDD5[INDEX_GDDdata[0+5:9+5]])
    cumGDD10yr[6] = TOTAL(GDD5[INDEX_GDDdata[0+6:9+6]])
    cumGDD10yr[7] = TOTAL(GDD5[INDEX_GDDdata[0+7:9+7]])
    cumGDD10yr[8] = TOTAL(GDD5[INDEX_GDDdata[0+8:9+8]])
    cumGDD10yr[9] = TOTAL(GDD5[INDEX_GDDdata[0+9:9+9]])
    cumGDD10yr[10] = TOTAL(GDD5[INDEX_GDDdata[0+10:9+10]])
    cumGDD10yr[11] = TOTAL(GDD5[INDEX_GDDdata[0+11:9+11]])
    cumGDD10yr[12] = TOTAL(GDD5[INDEX_GDDdata[0+12:9+12]])
    cumGDD10yr[13] = TOTAL(GDD5[INDEX_GDDdata[0+13:9+13]])
    cumGDD10yr[14] = TOTAL(GDD5[INDEX_GDDdata[0+14:9+14]])
    cumGDD10yr[15] = TOTAL(GDD5[INDEX_GDDdata[0+15:9+15]])
    cumGDD10yr[16] = TOTAL(GDD5[INDEX_GDDdata[0+16:9+16]])
    cumGDD10yr[17] = TOTAL(GDD5[INDEX_GDDdata[0+17:9+17]])
    cumGDD10yr[18] = TOTAL(GDD5[INDEX_GDDdata[0+18:9+18]])
    cumGDD10yr[19] = TOTAL(GDD5[INDEX_GDDdata[0+19:9+19]])
    cumGDD10yr[20] = TOTAL(GDD5[INDEX_GDDdata[0+20:9+20]])
    cumGDD10yr[21] = TOTAL(GDD5[INDEX_GDDdata[0+21:9+21]])
    cumGDD10yr[22] = TOTAL(GDD5[INDEX_GDDdata[0+22:9+22]])
    cumGDD10yr[23] = TOTAL(GDD5[INDEX_GDDdata[0+23:9+23]])
    ;PRINT, 'cumGDD10yr', cumGDD10yr
    outputGDD[4, 24L*i:23L+i*24] = cumGDD10yr

    ; 10-year mean GDDs
    meanGDD10yr[0] = MEAN(GDD5[INDEX_GDDdata[0:9]]); survey year: 1989
    meanGDD10yr[1] = MEAN(GDD5[INDEX_GDDdata[0+1:9+1]]); 1990
    meanGDD10yr[2] = MEAN(GDD5[INDEX_GDDdata[0+2:9+2]]); 1991
    meanGDD10yr[3] = MEAN(GDD5[INDEX_GDDdata[0+3:9+3]]); 1992
    meanGDD10yr[4] = MEAN(GDD5[INDEX_GDDdata[0+4:9+4]]); 1993
    meanGDD10yr[5] = MEAN(GDD5[INDEX_GDDdata[0+5:9+5]]); 1994
    meanGDD10yr[6] = MEAN(GDD5[INDEX_GDDdata[0+6:9+6]]); 1995
    meanGDD10yr[7] = MEAN(GDD5[INDEX_GDDdata[0+7:9+7]])
    meanGDD10yr[8] = MEAN(GDD5[INDEX_GDDdata[0+8:9+8]])
    meanGDD10yr[9] = MEAN(GDD5[INDEX_GDDdata[0+9:9+9]])
    meanGDD10yr[10] = MEAN(GDD5[INDEX_GDDdata[0+10:9+10]])
    meanGDD10yr[11] = MEAN(GDD5[INDEX_GDDdata[0+11:9+11]])
    meanGDD10yr[12] = MEAN(GDD5[INDEX_GDDdata[0+12:9+12]])
    meanGDD10yr[13] = MEAN(GDD5[INDEX_GDDdata[0+13:9+13]])
    meanGDD10yr[14] = MEAN(GDD5[INDEX_GDDdata[0+14:9+14]])
    meanGDD10yr[15] = MEAN(GDD5[INDEX_GDDdata[0+15:9+15]])
    meanGDD10yr[16] = MEAN(GDD5[INDEX_GDDdata[0+16:9+16]])
    meanGDD10yr[17] = MEAN(GDD5[INDEX_GDDdata[0+17:9+17]])
    meanGDD10yr[18] = MEAN(GDD5[INDEX_GDDdata[0+18:9+18]])
    meanGDD10yr[19] = MEAN(GDD5[INDEX_GDDdata[0+19:9+19]])
    meanGDD10yr[20] = MEAN(GDD5[INDEX_GDDdata[0+20:9+20]])
    meanGDD10yr[21] = MEAN(GDD5[INDEX_GDDdata[0+21:9+21]])
    meanGDD10yr[22] = MEAN(GDD5[INDEX_GDDdata[0+22:9+22]])
    meanGDD10yr[23] = MEAN(GDD5[INDEX_GDDdata[0+23:9+23]])
    ;PRINT, 'meanGDD10yr', meanGDD10yr
    outputGDD[5, 24L*i:23L+i*24] = meanGDD10yr

;  ; Age-specific cumulative GDDs 
;  ;only age age 1-15 -> start in 1994 = 15
;  ; based on growth years (year-1)
;  print, INDEX_GDDdata[15L]
;  for  ii = 15L, n_elements(INDEX_GDDdata)-1L DO BEGIN
;    print, 'ii', ii
;    cumGDDage[0] = TOTAL(GDD5[INDEX_GDDdata[ii-0:ii]])
;    cumGDDage[1] = TOTAL(GDD5[INDEX_GDDdata[ii-1:ii]])
;    cumGDDage[2] = TOTAL(GDD5[INDEX_GDDdata[ii-2:ii]])
;    cumGDDage[3] = TOTAL(GDD5[INDEX_GDDdata[ii-3:ii]])
;    cumGDDage[4] = TOTAL(GDD5[INDEX_GDDdata[ii-4:ii]])
;    cumGDDage[5] = TOTAL(GDD5[INDEX_GDDdata[ii-5:ii]])
;    cumGDDage[6] = TOTAL(GDD5[INDEX_GDDdata[ii-6:ii]])
;    cumGDDage[7] = TOTAL(GDD5[INDEX_GDDdata[ii-7:ii]])
;    cumGDDage[8] = TOTAL(GDD5[INDEX_GDDdata[ii-8:ii]])
;    cumGDDage[9] = TOTAL(GDD5[INDEX_GDDdata[ii-9:ii]])
;    cumGDDage[10] = TOTAL(GDD5[INDEX_GDDdata[ii-10:ii]])
;    cumGDDage[11] = TOTAL(GDD5[INDEX_GDDdata[ii-11:ii]])
;    cumGDDage[12] = TOTAL(GDD5[INDEX_GDDdata[ii-12:ii]])
;    cumGDDage[13] = TOTAL(GDD5[INDEX_GDDdata[ii-13:ii]])
;    cumGDDage[14] = TOTAL(GDD5[INDEX_GDDdata[ii-14:ii]])
;    print, 'cumGDDage', cumGDDage
;   ENDFOR
    
    ;print, outputGDD[*, 24L*i:23L+i*24]
   ENDIF
ENDFOR 

; Export the output to a file
; Ouptut 1

Data1 = outputGDD
;INDEX_length_age = WHERE(WAE_length_bin[1, *] GT 0., INDEX_length_agecount)
;Data = WAE_length_bin[*, INDEX_length_age]
filename1 = 'out_wiGDD_cum5_10yr.csv'
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



END
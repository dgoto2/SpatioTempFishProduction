PRO ReadData_WalleyeGrow; import input data from files 

tstart = SYSTIME(/seconds)

; Identify a direcotry for exporting daily output of state variables as .csv file
CD, 'C:\Users\Daisuke Goto\Desktop\Walleye outputs'; Directory; F:\SNS_SEIBM

; File location
file = FILEPATH('WAE_Length_Weight_Age_Input_Data.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

; Check if the file is not blank
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Read the file 
;Result = READ_ASCII(file); [Filename] [, COMMENT_SYMBOL=string] [, COUNT=variable] [, DATA_START=lines_to_skip]
; [, DELIMITER=string] [, HEADER=variable] [, MISSING_VALUE=value] [, NUM_RECORDS=value] [, RECORD_START=index] 
; [, TEMPLATE=value] [, /VERBOSE] )
;
;data = READ_ASCII(FILEPATH('WAE_Length_Weight_Age_Raw_Data_IV.csv', $
;   Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'), TEMPLATE = sTemplate)
;   ;SUBDIRECTORY=['examples', 'data']), TEMPLATE = sTemplate)

;data = READ_ASCII(file, TEMPLATE=ASCII_TEMPLATE(file))
;InputArray = data

; Input file order
; (1) WBIC_Year (2) WBIC (3) SurveyYear (4) Age (5) FracAge (6) LengthMM (7) Sex

; Define the data structure
N = 112041L; 162 * 365
InputArray = DOUBLE(FLTARR(8L, N))

OPENR, lun, file, /GET_LUN
READF, lun, InputArray;, FORMAT='(A17, x, I0)'; 
WBIC_Year = InputArray[0, *]
WBIC = InputArray[1, *]
SurveyYear = InputArray[2, *]
Age = InputArray[3, *]
FracAge = InputArray[4, *]
LengthMM = InputArray[5, *]
Sex = InputArray[6, *]
FishID = InputArray[7, *]
FREE_LUN, lun


; Find unique WBIC_year
UniqWBIC_Year = WBIC_Year[UNIQ(WBIC_Year, SORT(WBIC_Year))]
PRINT, 'N of unique WBIC_Year', N_ELEMENTS(UniqWBIC_Year)

; Find unique WBIC
UniqWBIC = WBIC[UNIQ(WBIC, SORT(WBIC))]
;PRINT, WBIC[UniqWBIC]
;PRINT, SurveyYear[UniqWBIC]
PRINT, 'N of WBIC records', N_ELEMENTS(WBIC)
PRINT, 'N of unique WBIC', N_ELEMENTS(UniqWBIC)
;lowsample = intarr(N_ELEMENTS(UniqWBIC))

; Calculate sample size for each WBIC_year 
Nsample = INTARR(N_ELEMENTS(UniqWBIC_Year)); subarray w/ unique WBIC_year only
; arrays based on N of samples: all records > unique WBIC_year > unique WBIC
FOR i = 0L, N_ELEMENTS(UniqWBIC_Year)-1L DO BEGIN
  ;if n_elements(UniqWBIC[i]) le 29 then lowsample[i] = 1 
  FOR ii = 0L, N_ELEMENTS(WBIC_Year)-1L DO BEGIN
    Numsample = WHERE(UniqWBIC_Year[i] EQ WBIC_Year[ii], Numsamplecount)
    Nsample[i] = Nsample[i] + Numsamplecount
    ;IF Numsamplecount GT 0 then print, Numsamplecount
  ENDFOR
ENDFOR

; Find WBIC_year w/ sample size <= 29
NumsampleLE29 = WHERE(Nsample LE 29L, NumsampleLE29count, COMPLEMENT=NumsampleGT30, Ncomplement = NumsampleGT30count)
PRINT, 'N of unique WBIC_Year w/ <29',NumsampleLE29count
;PRINT, Nsample[NumsampleLE29]

;PRINT,'', n_elements(WBIC[UniqWBIC_Year[Nsample[NumsampleGT30]]])
PRINT,'N of unique WBIC_year>30', N_ELEMENTS(UniqWBIC_Year[NumsampleGT30])
;PRINT,'N of unique WBIC_year>30', n_elements(WBIC_Year[UniqWBIC_Year[NumsampleGT30]])

; Find unique WBIC w/ WBIC_year>30
;UniqWBICgt30 = UNIQ(WBIC[UniqWBIC_Year[Nsample[NumsampleGT30]]])
UniqWBICgt30 = UNIQ(UniqWBIC_Year[NumsampleGT30], SORT(UniqWBIC_Year[NumsampleGT30]))
PRINT, 'N of unique WBIC w/ WBIC_year>30', N_ELEMENTS(UniqWBICgt30)

;;print, WBIC[UniqWBIC_Year[Nsample[NumsampleGT30]]]
;print, WBIC[UniqWBIC_Year[NumsampleGT30]]
;print, WBIC_year[UniqWBIC_Year[NumsampleGT30]]

;; Check N of the samples for each Uniq WBIC_year
;PRINT, Nsample[NumsampleGT30]
;PRINT, N_elements(Nsample[NumsampleGT30])
PRINT, 'N of WBIC records w/ WBIC_year>30', TOTAL(Nsample[NumsampleGT30])
;;;Nsample = intarr(N_ELEMENTS(UniqWBIC_Year)); subarray w/ unique WBIC_year only;;;

;PRINT, Nsample[NumsampleLE29]
;PRINT, N_elements(Nsample[NumsampleLE29])
PRINT, 'N of WBIC records w/ WBIC_year<29', TOTAL(Nsample[NumsampleLE29])


; Find WBIC_year w/ sample size >= 30 and age classes >=3
; Calculate sample size for each WBIC_year 
Nageclass = INTARR(3L, N_ELEMENTS(NumsampleGT30)); subarray w/ unique WBIC_year only
; arrays based on N of samples: all records > unique WBIC_year > unique WBIC

FOR i = 0L, N_ELEMENTS(NumsampleGT30)-1L DO BEGIN
  ;if n_elements(UniqWBIC[i]) le 29 then lowsample[i] = 1 
  ;for ii = 0L, N_ELEMENTS(WBIC_Year)-1L DO BEGIN
    ;NumsampleGT30AGE = WHERE(WBIC_Year[UniqWBIC_Year[NumsampleGT30[i]]] EQ WBIC_Year[ii], Numsamplecount)
    NumsampleGT30AGE = WHERE(UniqWBIC_Year[NumsampleGT30[i]] EQ WBIC_Year[*], NumsampleGT30AGEcount)
    ;print, NumsampleGT30AGE
    ;PRINT, WBIC_Year[NumsampleGT30AGE]
    ;PRINT, FIX(AGE[NumsampleGT30AGE[SORT(AGE[NumsampleGT30AGE], /L64)]])
    ;PRINT, FIX(AGE[NumsampleGT30AGE])
    ;PRINT, transpose(fix(InputArray[3, NumsampleGT30AGE]))
    ;ageclassGE30 = FIX(AGE[NumsampleGT30AGE])
    ;PRINT, ageclassGE30
        
    IF NumsampleGT30AGEcount GT 0 THEN BEGIN
      Numageclass = N_ELEMENTS(UNIQ(FIX(AGE[NumsampleGT30AGE]), SORT(FIX(AGE[NumsampleGT30AGE]), /L64)))
      Maxageclass = Max(AGE[NumsampleGT30AGE])
      Minageclass = Min(AGE[NumsampleGT30AGE])
      ;PRINT, N_ELEMENTS(AGE[NumsampleGT30AGE]), Numageclass
      ;;PRINT, N_ELEMENTS(AGE[NumsampleGT30AGE]), N_ELEMENTS(UNIQ(FIX(AGE[NumsampleGT30AGE])))
      ;;PRINT, UNIQ(FIX(AGE[NumsampleGT30AGE]), SORT(FIX(AGE[NumsampleGT30AGE]), /L64))
      ;PRINT, FIX(AGE[NumsampleGT30AGE[UNIQ(AGE[NumsampleGT30AGE], SORT(AGE[NumsampleGT30AGE], /L64))]])
      ;;PRINT, FIX(AGE[NumsampleGT30AGE[UNIQ(FIX(AGE[NumsampleGT30AGE]))]])
    ENDIF
    ;Uniqageclass = UNIQ(AGE[[UniqWBIC_Year[NumsampleGT30AGE]])
    Nageclass[0L, i] = Numageclass
    Nageclass[1L, i] = Maxageclass
    Nageclass[2L, i] = Minageclass
ENDFOR
;PRINT, 'N of age classes', Nageclass

; Index for whic_year w/ >30 samples and age class>3
; Nsamples = N of unique WBIC_year
; Nageclass = NumsampleGT30
; UniqWBIC_year->NumsampleGT30->Nageclass>3

NumsampleGT30ageclassGT3 = WHERE(Nageclass[0L, *] GT 3L, NumsampleGT30ageclassGT3count)
;PRINT, NumsampleGT30ageclassGE3
PRINT, 'N of unique WBIC_Year  w/ N>30 + ageclass>3', N_ELEMENTS(NumsampleGT30ageclassGT3)
;PRINT, 'N of WBIC records w/ WBIC_year30 + ageclass >3', TOTAL(Nsample[NumsampleGT30ageclassGT3])

uniqWBIC_Year_NsmplGT30_NageclassGT3 = UniqWBIC_Year[NumsampleGT30[NumsampleGT30ageclassGT3]]
;PRINT, uniqWBIC_Year_NsmplGT30_NageclassGT3


FOR i = 0L, N_ELEMENTS(uniqWBIC_Year_NsmplGT30_NageclassGT3)-1L DO BEGIN
  ;if n_elements(UniqWBIC[i]) le 29 then lowsample[i] = 1 
  INDEX_datafinal = WHERE(WBIC_Year[*] EQ uniqWBIC_Year_NsmplGT30_NageclassGT3[i])
  ;PRINT, 'uniqWBIC_Year_NsmplGT30_NageclassGT3[i]', uniqWBIC_Year_NsmplGT30_NageclassGT3[i]
  ;PRINT, INDEX_datafinal
  INDEX_datafinalarray = INTARR(N_ELEMENTS(INDEX_datafinal))
  INDEX_datafinalarray = INDEX_datafinal
  IF i EQ 0L THEN INDEX_datafinal2 = INDEX_datafinalarray
  IF i GE 1L THEN INDEX_datafinal2 = [INDEX_datafinal2, INDEX_datafinalarray]
  
  ;WBIC_year_subarray1 = WBIC_Year[INDEX_datafinal]
  ;IF i EQ 0L THEN WBIC_year_subarray2 = WBIC_year_subarray1
  ;IF i GE 1L THEN WBIC_year_subarray2 = [WBIC_year_subarray2, WBIC_year_subarray1]
  ;PRINT, WBIC_year_subarray1
ENDFOR
PRINT, 'N of WBIC records w/ WBIC_year30 + ageclass >3', N_ELEMENTS(INDEX_datafinal2)
PRINT, 'FINAL DATA SET TO BE USED FOR GROWTH ANALYSIS'
Data_Final = InputArray[*, INDEX_datafinal2]
;PRINT, Data_Final
PRINT, 'END of the input file'

t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
;RETURN, Data_Final; TURN OFF WHEN TESTING
END
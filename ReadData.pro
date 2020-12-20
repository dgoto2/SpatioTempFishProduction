PRO ReadData; import input data from files 


tstart = SYSTIME(/seconds)

; Identify a direcotry for exporting daily output of state variables as .csv file
CD, 'C:\Users\Daisuke Goto\Desktop\Walleye outputs'; Directory; F:\SNS_SEIBM

; File location
file = FILEPATH('WAE_Length_Weight_Age_Input_Data.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

file_lake = FILEPATH('LakeMorph.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
;file = FILEPATH('LowerPlatteRiverHydrologyInput95.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop')

file_density = FILEPATH('Walleye_density_all.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

file_CiscoLake = FILEPATH('CiscoLake.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

file_WalleyeExpl = FILEPATH('WalleyeExpl.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

file_LMBcpue = FILEPATH('LMBcpue.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')

file_LMBcpue = FILEPATH('LMBcpue.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')


; Check if the file is not blank
IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L

; Read the file
 
; Input file order


; Define the data structure


;array = ''
;line = ''
;InputArray = FLTARR(array, line)
;print, n_elements(inputarray)/5.
;InputArray = FLTARR(32L, N)

;Result = READ_ASCII(file); [Filename] [, COMMENT_SYMBOL=string] [, COUNT=variable] [, DATA_START=lines_to_skip]
; [, DELIMITER=string] [, HEADER=variable] [, MISSING_VALUE=value] [, NUM_RECORDS=value] [, RECORD_START=index] 
; [, TEMPLATE=value] [, /VERBOSE] )
;
;data = READ_ASCII(FILEPATH('WAE_Length_Weight_Age_Raw_Data_IV.csv', $
;   Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop'), TEMPLATE = sTemplate)
;   ;SUBDIRECTORY=['examples', 'data']), TEMPLATE = sTemplate)

;data = READ_ASCII(file, TEMPLATE=ASCII_TEMPLATE(file))
;InputArray = data

N = 112041L; 162 * 365
InputArray = DOUBLE(FLTARR(8L, N))
FishID = indgen(N)

OPENR, lun, file, /GET_LUN
READF, lun, InputArray;, FORMAT='(A17, x, I0)'; 
WBIC_Year = InputArray[0, *]
WBIC = InputArray[1, *]
SurveyYear = InputArray[2, *]
Age = InputArray[3, *]
FracAge = InputArray[4, *]
LengthMM = InputArray[5, *]
Sex = InputArray[6, *]
FREE_LUN, lun


Nlake = 555L
InputArray_lake = double(FLTARR(8L, Nlake))
OPENR, lun, file_lake, /GET_LUN
READF, lun, InputArray_lake;
WBIC_lake = InputArray_lake[0, *]
Drinage_Area = InputArray_lake[1, *]
Watershed_Area = InputArray_lake[2, *]
Lake_Size = InputArray_lake[3, *]
Shoreline_Length = InputArray_lake[4, *]
Max_Depth = InputArray_lake[5, *]
Lon = InputArray_lake[4, *]
Lat = InputArray_lake[5, *]
FREE_LUN, lun


Nciscolake = 111L
InputArray_CiscoLake = double(FLTARR(4L, Nciscolake))
OPENR, lun, file_Ciscolake, /GET_LUN
READF, lun, InputArray_CiscoLake;
WBIC_CiscoLake = InputArray_CiscoLake[0, *]
Strat_Index = InputArray_CiscoLake[1, *]
Conductivity = InputArray_CiscoLake[2, *]
TSI = InputArray_CiscoLake[3, *]
FREE_LUN, lun


; walleye density data
Ndensity = 1206L
InputArray_density = double(FLTARR(4L, Ndensity))
OPENR, lun, file_density, /GET_LUN
READF, lun, InputArray_density;
WBIC_density = InputArray_density[0, *]
year_density = InputArray_density[1, *]
Walleye_density = InputArray_density[2, *]
FREE_LUN, lun

;WBIC_Year WBIC  Year  Ang_Expl  Expl_14 Expl_20 Tribal_Expl Total_Expl

; walleye exploitation data
Nexpl = 346L
InputArray_expl = double(FLTARR(8L, Nexpl))
OPENR, lun, file_WalleyeExpl, /GET_LUN
READF, lun, InputArray_expl;
WBIC_Year_expl = InputArray_expl[0, *]
WBIC_expl = InputArray_expl[1, *]
Year_expl = InputArray_expl[2, *]
Ang_Expl_expl = InputArray_expl[3, *]
Expl_14_expl = InputArray_expl[4, *]
Expl_20 = InputArray_expl[5, *]
Tribal_Expl = InputArray_expl[6, *]
Total_Expl = InputArray_expl[7, *]
FREE_LUN, lun


; largemouth bass data
Nlmb = 599L
InputArray_LMB = double(FLTARR(5L, Nlmb))
OPENR, lun, file_LMBcpue, /GET_LUN
READF, lun, InputArray_LMB;
WBIC_Year_LMB = InputArray_LMB[0, *]
WBIC_LMB = InputArray_LMB[1, *]
Year_LMB = InputArray_LMB[2, *]
CPUEmean_LMB = InputArray_LMB[3, *]
CPUEsd_LMB = InputArray_LMB[4, *]

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
  for ii = 0L, N_ELEMENTS(WBIC_Year)-1L DO BEGIN
    Numsample = WHERE(UniqWBIC_Year[i] EQ WBIC_Year[ii], Numsamplecount)
    Nsample[i] = Nsample[i] + Numsamplecount
    ;IF Numsamplecount GT 0 then print, Numsamplecount
  endfor
  ;print, Nsample[i]
  
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
newN = N_ELEMENTS(INDEX_datafinal2)
Data_Final = double(fltarr(8L, newN))
Data_Final = InputArray[*, INDEX_datafinal2]
Data_Final[7, *] = findgen(newN)
;PRINT, Data_Final
PRINT, 'END of the input file'


;; von Bertalanffy growth model
;; Parameterization
;; from He et al. 2005 Journal of Fish Biology vol 66 pp1459-1470 for walleye

;Linf = FLTARR(N_ELEMENTS(INDEX_datafinal2))
;K = FLTARR(N_ELEMENTS(INDEX_datafinal2))
;t0 = FLTARR(N_ELEMENTS(INDEX_datafinal2))

;Male = WHERE(SEX EQ 0., malecount, complement = female, ncomplement = femalecount)
;IF malecount GT 0. THEN BEGIN
;  ; males
;  Linf[male] = RANDOMU(seed, malecount) * (MAX(438.3) - MIN(424.8)) + MIN(424.8)
;  K[male] = RANDOMU(seed, malecount) * (MAX(0.426) - MIN(0.374)) + MIN(0.374)
;  t0[male] = RANDOMU(seed, malecount) * (MAX(-0.107) - MIN(-0.271)) + MIN(-0.271)
;ENDIF
;IF femalecount GT 0. THEN BEGIN
;  ; females
;  Linf[female] = RANDOMU(seed, femalecount) * (MAX(488.6) - MIN(466.8)) + MIN(466.8)
;  K[female] = RANDOMU(seed, femalecount) * (MAX(0.368) - MIN(0.312)) + MIN(0.312)
;  t0[female] = RANDOMU(seed, femalecount) * (MAX(-0.162) - MIN(-0.366)) + MIN(-0.366)
;ENDIF


;;WBIC_Year = InputArray[0, *]
;;WBIC = InputArray[1, *]
;;SurveyYear = InputArray[2, *]
;;Age = InputArray[3, *]
;;FracAge = InputArray[4, *]
;;LengthMM = InputArray[5, *]

;Data_Final[]

;LENGTH = FLTARR(N_ELEMENTS(INDEX_datafinal2))
WBIC_Year2 = Data_Final[0, *]
WBIC2 = Data_Final[1, *]
SurveyYear2 = Data_Final[2, *]
Age2 = Data_Final[4, *]
Length2 = Data_Final[5, *]
SEX2 = Data_Final[6, *]



; arrays for parameter values for each WBIC_year
;Linf = FLTARR(N_ELEMENTS(NumsampleGT30ageclassGT3))
;K = FLTARR(N_ELEMENTS(NumsampleGT30ageclassGT3))
;t0 = FLTARR(N_ELEMENTS(NumsampleGT30ageclassGT3))

paramset = FLTARR(22L, N_ELEMENTS(NumsampleGT30ageclassGT3))
; NEED TO ADD N of ageclasses, N of samples, YEAR, WBIC_YEAR, WBIC


;Numageclass = Nageclass[NumsampleGT30ageclassGT3]
;PRINT, N_ELEMENTS(Numageclass)
;PRINT, (Numageclass)


; Parameterize the VBGF for each WBIC_year
FOR i = 0L, N_ELEMENTS(uniqWBIC_Year_NsmplGT30_NageclassGT3)-1L DO BEGIN
;FOR i = 0L, 50L do begin
  
  INDEX_growthdata = WHERE(WBIC_Year2[*] EQ uniqWBIC_Year_NsmplGT30_NageclassGT3[i])
  ;PRINT, 'uniqWBIC_Year_NsmplGT30_NageclassGT3[i]', uniqWBIC_Year_NsmplGT30_NageclassGT3[i]
  ;PRINT, INDEX_datafinal
  Length_Gro = Length2[INDEX_growthdata]
  Age_Gro = Age2[INDEX_growthdata]
  Sex_Gro = Sex2[INDEX_growthdata]
  
  Male = WHERE(Sex_Gro eq 0, malecount)
  Female = WHERE(Sex_Gro eq 1, femalecount)
  unknown = WHERE(Sex_Gro eq 2, unknowncount)
    
  paramset[0, i] = uniqWBIC_Year_NsmplGT30_NageclassGT3[i]
  paramset[1, i] = N_ELEMENTS(Length_Gro)
  paramset[2, i] = WBIC2[INDEX_growthdata[0]]
  paramset[3, i] = SurveyYear2[INDEX_growthdata[0]]


  ;PRINT, 'Observed length', Length_Gro
  ;PRINT, 'Observed age', Age_Gro
  
  ;; plot data 
  PLOT, Age_Gro, Length_Gro, psym=4, xtitle='Age (year)', ytitle='Length (mm)', xrange=[0,25] $ 
    , title='VBGF_WI walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
  filename='Walleye age vs. length'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
  
 
  
  ;ADD SS, DOF IN FIGURE?????????
  
  ;WRITE_PNG,filename,TVRD()
  
  ;Length_Gro = Linf_gro * (1 - EXP(-K_gro * (Age_Gro - t0_gro)))

; NEED TO SUPRIMPOSE FITTED LINE OVER THE DATA!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  ; Example code
  ;function jacksgaussian, x, p; this needs to be a separate function
  ;; x = abscissae
  ;; p = parameters = [amplitude, centroid, width]
  ;argument = (x - p[1]) / p[2]
  ;gaussian = p[0] * exp(-argument^2)
  ;return, gaussian
  ;end
  
  ; Run mpfitfun (watch as it iteratively improves our initial guess to minimize chi-squared); 

  paramset[4, i] = Nageclass[0L, NumsampleGT30ageclassGT3[i]]
  paramset[5, i] = Nageclass[1L, NumsampleGT30ageclassGT3[i]]
  paramset[6, i] = Nageclass[2L, NumsampleGT30ageclassGT3[i]]
  paramset[7, i] = MAX(Length_Gro)
  paramset[8, i] = MIN(Length_Gro)
  
  startparms = [600.0D, 0.4D, -0.15D]
  dy = Length_Gro + RANDOMN(seed, N_ELEMENTS(Length_Gro)) * 0.1 
  
  ;parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit)
  
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
  pi(0).limited(1) = 0; 0=vary; 1=constant
  pi(0).limits(1) = 2000.
  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)

  Length_Gro_EstAll = parms[0] * (1 - EXP(-parms[1] * (Age_Gro - parms[2]))) 
  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2

  paramset[9:11, i] = parms

  
  
  IF MALECOUNT GT 0 THEN BEGIN
  
;  paramset[4, i] = Nageclass[0L, NumsampleGT30ageclassGT3[MALE[i]]]
;  paramset[5, i] = Nageclass[1L, NumsampleGT30ageclassGT3[MALE[i]]]
;  paramset[6, i] = Nageclass[2L, NumsampleGT30ageclassGT3[MALE[i]]]
  paramset[12, i] = MAX(Length_Gro[MALE])
  paramset[13, i] = MIN(Length_Gro[MALE])
  
  startparms = [600.0D, 0.4D, -0.15D]
  dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1 
  
  ;parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit)
  
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
  pi(0).limited(1) = 0; 0=vary; 1=constant
  pi(0).limits(1) = 2000.
  parms = mpfitfun('vonBertalanffy', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)

    
;  parinfo = replicate({value:0.0, fixed:0, limited:[0,0], limits:[0.0,0.0]}, 3)
;  parinfo[0].limited[1] = 0; parameter 0, the amplitude, has a lower bound
;  parinfo[0].limits[1] = 2000.0; do not accept values less than zero
;  parinfo[0].fixed = 0
;  parinfo[0].value = 600.
;  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=parinfo)

  Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE] - parms[2]))) 
  OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
  
  ;print, parms
  paramset[14:16, i] = parms
  ENDIF
  
  IF FEMALECOUNT GT 0 THEN BEGIN
;  paramset[9, i] = Nageclass[0L, NumsampleGT30ageclassGT3[FEMALE[i]]]
;  paramset[10, i] = Nageclass[1L, NumsampleGT30ageclassGT3[FEMALE[i]]]
;  paramset[11, i] = Nageclass[2L, NumsampleGT30ageclassGT3[FEMALE[i]]]
  paramset[17, i] = MAX(Length_Gro[FEMALE])
  paramset[18, i] = MIN(Length_Gro[FEMALE])    
  
  
  startparms = [600.0D, 0.4D, -0.15D]
  dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1 
  
  ;parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit)
  
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
  pi(0).limited(1) = 0; 0=vary; 1=constant
  pi(0).limits(1) = 2000.
  parms = mpfitfun('vonBertalanffy', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)

    
;  parinfo = replicate({value:0.0, fixed:0, limited:[0,0], limits:[0.0,0.0]}, 3)
;  parinfo[0].limited[1] = 0; parameter 0, the amplitude, has a lower bound
;  parinfo[0].limits[1] = 2000.0; do not accept values less than zero
;  parinfo[0].fixed = 0
;  parinfo[0].value = 600.
;  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=parinfo)

  Length_Gro_EstFemale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2]))) 
  OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
  
  paramset[19:21, i] = parms
  ENDIF
  
  WRITE_PNG, filename, TVRD()


  ; store parameter values
  ;Linf[i] = Linf_gro
  ;K[i] = K_gro2
  ;t0[i] = t0_gro
ENDFOR

; Check if parameter values are valid
InvalidParamset = WHERE(paramset[4, *] GT 2000., InvalidParamsetcount, complement = validparamset, ncomplement = validparamsetcount)
IF InvalidParamsetcount GT 0 THEN PRINT, 'Invalid parameter sets' $
;                , paramset[*, InvalidParamset] $
                , 'N of invalid parameter set: ', InvalidParamsetcount 
                
IF ValidParamsetcount GT 0 THEN PRINT, 'Valid parameter sets' $
 ;               , paramset[*, validParamset] $
                , 'N of valid parameter set: ', validParamsetcount
;PRINT, 'ALL WBIC_YEAR parameters'
;PRINT, paramset


; Export data to the file
;data = paramset; von Bertalanffy
data = Data_Final; clean data



; Set up variables.
;Output_WalleyeProd='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
;filename1 = 'Output_WalleyeProd.csv'
filename1 = 'Data_Final.csv'

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data, /Dimensions)
xsize = s[0]
lineWidth = 16000000
comma = ","

;IF counter EQ 1L THEN pointer1 = LiveIndiv2count 

; Open the data file for writing.
;IF counter EQ 0L THEN BEGIN; 
;  LiveIndiv2count2 = LiveIndiv2count
  OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;ENDIF
;IF counter GT 0L AND counter LT 20L THEN BEGIN; 
;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;  pointer1 = LiveIndiv2count2
;  SKIP_LUN, lun, pointer1, /lines
;  READF, lun
;  LiveIndiv2count2 = LiveIndiv2count2 + LiveIndiv2count
;ENDIF


; Write the data to the file.
sData = StrTrim(double(data), 2)
sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
PrintF, lun, sData

; Close the file.
Free_Lun, lun
;PRINT, '"Your SNS Output File is Ready"'



;  Data = fltarr(3, 673)
;  pointer1 = iREP - 1L 
;  Data[0, i] = iter
;  Data[1, i] = fnorm
;  Data[2, i] = dof
;      
;filename1 = 'Output_WalleyeProd_stat.csv'
;;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
;s = Size(data, /Dimensions)
;xsize = s[0]
;lineWidth = 16000000
;comma = ","
;
;; Open the data file for writing.
;IF pointer1 EQ 0L THEN OpenW, lun, filename1, /Get_Lun, Width=lineWidth
;IF pointer1 GT 0L THEN BEGIN; 
;  OpenU, lun, filename1, /Get_Lun, Width=lineWidth
;  SKIP_LUN, lun, pointer1, /lines
;  READF, lun
;ENDIF
;
;; Write the data to the file.
;sData = StrTrim(double(data), 2)
;sData[0:xsize-2, *] = sData[0:xsize-2, *] + comma
;PrintF, lun, sData
;
;; Close the file.
;Free_Lun, lun



; create a new lake array for WBIC_year
LakeMorph = fltarr(8L, n_elements(paramset[0, *]))
;paramset; VBGF parameter set
FOR iii = 0L, Nlake-1L do begin
  FOR iv = 0L, n_elements(paramset[0, *])-1L do begin  
    LakeMorph2 = WHERE(long(paramset[2, iv]) EQ long(InputArray_lake[0, iii]), LakeMorph2count)
    ;print, long(paramset[2, iv]), long(InputArray_lake[0, iii])
    ;PRINT, LakeMorph2count
    ;PRINT, LakeMorph2
    
    IF iii EQ 0 THEN LakeMorph2count2 = 0 
    IF iii GT 0 THEN LakeMorph2count2 = LakeMorph2count2 

    IF LakeMorph2count GT 0 then BEGIN
      ;if iv gt 1 then LakeMorph2count2 = LakeMorph2count2 + LakeMorph2count
      ;print, LakeMorph2count2
      LakeMorph[*, LakeMorph2count2 : (LakeMorph2count2 + LakeMorph2count)-1L] = InputArray_lake[*, iii]   
      LakeMorph2count2 = LakeMorph2count2 + LakeMorph2count
    ENDIF
    ;print, LakeMorph2count2 
  ENDFOR
ENDFOR  
;PRINT, LAKEMORPH


; Export data to the file
data2 = LAKEMORPH

; Set up variables.
;Output_WalleyeProd='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
filename2 = 'WILakeMorph.csv'

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data2, /Dimensions)
xsize2 = s[0]
lineWidth = 16000000
comma = ","

; Open the data file for writing.
  OpenW, lun, filename2, /Get_Lun, Width=lineWidth

; Write the data to the file.
sData2 = StrTrim(double(data2), 2)
sData2[0:xsize2-2, *] = sData2[0:xsize2-2, *] + comma
PrintF, lun, sData2
; Close the file.
Free_Lun, lun
;PRINT, '"Your SNS Output File is Ready"'



; create a new lake array for individual fish
LakeMorph2 = fltarr(9L, newN)
;paramset; VBGF parameter set
FOR v = 0L, Nlake-1L do begin
  FOR vi = 0L, newN-1L do begin  
    LakeMorph3 = WHERE(long(Data_Final[1, vi]) EQ long(InputArray_lake[0, v]), LakeMorph3count)
    ;print, long(Data_Final[1, vi]), long(InputArray_lake[0, v])

    
    IF v EQ 0 THEN LakeMorph3count2 = 0 
    IF v GT 0 THEN LakeMorph3count2 = LakeMorph3count2 

    IF LakeMorph3count GT 0 then BEGIN
        print, long(Data_Final[1, vi]);, long(InputArray_lake[0, v])
        print, long(Data_Final[7, vi])
        PRINT, LakeMorph3count
        PRINT, LakeMorph3
      LakeMorph2[1:8, LakeMorph3count2 : (LakeMorph3count2 + LakeMorph3count)-1L] = InputArray_lake[*, v]  
      LakeMorph2[0, LakeMorph3count2 : (LakeMorph3count2 + LakeMorph3count)-1L] = Data_Final[7, vi:vi+LakeMorph3count-1L]  
       
      LakeMorph3count2 = LakeMorph3count2 + LakeMorph3count
    ENDIF
    ;PRINT, LakeMorph3count2     
    
  ENDFOR
ENDFOR  
;PRINT, LAKEMORPH2

; Export data to the file
data3 = LAKEMORPH2

; Set up variables.
;Output_WalleyeProd='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
filename3 = 'WILakeMorph2.csv'

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data3, /Dimensions)
xsize3 = s[0]
lineWidth = 16000000
comma = ","

; Open the data file for writing.
  OpenW, lun, filename3, /Get_Lun, Width=lineWidth

; Write the data to the file.
sData3 = StrTrim(double(data3), 2)
sData3[0:xsize3-2, *] = sData3[0:xsize3-2, *] + comma
PrintF, lun, sData3
; Close the file.
Free_Lun, lun
;PRINT, '"Your SNS Output File is Ready"


; create a new density array for individual fish
WAEdensity = fltarr(5L, newN)
;paramset; VBGF parameter set
FOR vii = 0L, Ndensity-1L do begin
  FOR viii = 0L, newN-1L do begin  
    WAEdensity2 = WHERE(long(Data_Final[0, viii]) EQ long(InputArray_density[0, vii]), WAEdensity2count)
    ;print, long(InputArray[0, viii]), long(InputArray_density[0, vii])
    ;PRINT, WAEdensity2count
    ;PRINT, WAEdensity2
    
    IF vii EQ 0 THEN WAEdensity2count2 = 0 
    IF vii GT 0 THEN WAEdensity2count2 = WAEdensity2count2 

    IF WAEdensity2count GT 0 then BEGIN
      WAEdensity[1:4, WAEdensity2count2 : (WAEdensity2count2 + WAEdensity2count)-1L] = InputArray_density[*, vii] 
      WAEdensity[0, WAEdensity2count2 : (WAEdensity2count2 + WAEdensity2count)-1L] = Data_Final[7, viii:viii+WAEdensity2count-1L]     
      
        
      WAEdensity2count2 = WAEdensity2count2 + WAEdensity2count
    ENDIF    
  ENDFOR
ENDFOR  
;PRINT, WAEdensity

; Export data to the file
data4 = WAEdensity

; Set up variables.
;Output_WalleyeProd='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
filename4 = 'WAEdensity.csv'

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data4, /Dimensions)
xsize4 = s[0]
lineWidth = 16000000
comma = ","

; Open the data file for writing.
  OpenW, lun, filename4, /Get_Lun, Width=lineWidth

; Write the data to the file.
sData4 = StrTrim(double(data4), 2)
sData4[0:xsize4-2, *] = sData4[0:xsize4-2, *] + comma
PrintF, lun, sData4
; Close the file.
Free_Lun, lun
;PRINT, '"Walleye Output File is Ready"'


; create a new cisco lake array for individual fish
CiscoLake2 = fltarr(5L, newN)
;paramset; VBGF parameter set
FOR ix = 0L, Nciscolake-1L do begin
  FOR x = 0L, newN-1L do begin  
    CiscoLake3 = WHERE(long(Data_Final[1, x]) EQ long(InputArray_ciscolake[0, ix]), CiscoLake2count)
    ;print, long(InputArray[1, vi]), long(InputArray_lake[0, v])
    ;PRINT, LakeMorph3count
    ;PRINT, LakeMorph3
    
    IF ix EQ 0 THEN CiscoLake2count2 = 0 
    IF ix GT 0 THEN CiscoLake2count2 = CiscoLake2count2 

    IF CiscoLake2count GT 0 then BEGIN
      CiscoLake2[1:4, CiscoLake2count2 : (CiscoLake2count2 + CiscoLake2count)-1L] = InputArray_ciscolake[*, ix]
      CiscoLake2[0, CiscoLake2count2 : (CiscoLake2count2 + CiscoLake2count)-1L] = Data_Final[7, x:x+CiscoLake2count-1L] 
               
      CiscoLake2count2 = CiscoLake2count2 + CiscoLake2count
    ENDIF
    
  ENDFOR
ENDFOR  

; Export data to the file
data5 = CiscoLake2

; Set up variables.
;Output_WalleyeProd='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
filename5 = 'CiscoLake2.csv'

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data5, /Dimensions)
xsize5 = s[0]
lineWidth = 16000000
comma = ","

; Open the data file for writing.
  OpenW, lun, filename5, /Get_Lun, Width=lineWidth

; Write the data to the file.
sData5 = StrTrim(double(data5), 2)
sData5[0:xsize5-2, *] = sData5[0:xsize5-2, *] + comma
PrintF, lun, sData5
; Close the file.
Free_Lun, lun
;PRINT, '"Your SNS Output File is Ready"




; create a new exploitation array for individual fish
WAEexpl = fltarr(9L, newN)
;paramset; VBGF parameter set
FOR xi = 0L, Nexpl-1L do begin
  FOR xii = 0L, newN-1L do begin  
    WAEexpl2 = WHERE(long(Data_Final[0, xii]) EQ long(InputArray_expl[0, xi]), WAEexpl2count)
    ;print, long(InputArray[0, viii]), long(InputArray_density[0, vii])
    ;PRINT, WAEdensity2count
    ;PRINT, WAEdensity2
    
    IF xi EQ 0 THEN WAEexpl2count2 = 0 
    IF xi GT 0 THEN WAEexpl2count2 = WAEexpl2count2 

    IF WAEexpl2count GT 0 then BEGIN
      WAEexpl[1:8, WAEexpl2count2 : (WAEexpl2count2 + WAEexpl2count)-1L] = InputArray_expl[*, xi] 
      WAEexpl[0, WAEexpl2count2 : (WAEexpl2count2 + WAEexpl2count)-1L] = Data_Final[7, xii:xii+WAEexpl2count-1L] 
      
        
      WAEexpl2count2 = WAEexpl2count2 + WAEexpl2count
    ENDIF    
  ENDFOR
ENDFOR  
;PRINT, WAEexpl

; Export data to the file
data6 = WAEexpl

; Set up variables.
;Output_WalleyeProd='EDC_'+EndDisChem+'_DD_'+DensityDependence+Time+'_Rep_'+Rep+'_IDLoutputSNS_1.csv'
filename6 = 'WAEexpl.csv'

;****the files should be in the same directory as the "IDLWorksapce81" default folder.****
s = Size(data6, /Dimensions)
xsize6 = s[0]
lineWidth = 16000000
comma = ","

; Open the data file for writing.
  OpenW, lun, filename6, /Get_Lun, Width=lineWidth

; Write the data to the file.
sData6 = StrTrim(double(data6), 2)
sData6[0:xsize6-2, *] = sData6[0:xsize6-2, *] + comma
PrintF, lun, sData6
; Close the file.
Free_Lun, lun
;PRINT, '"Walleye Output File is Ready"'



t_elapsed = SYSTIME(/seconds) - tstart
PRINT, 'Elapesed time (seconds):', t_elapsed 
PRINT, 'Elapesed time (minutes):', t_elapsed/60.
;RETURN, ???; TURN OFF WHEN TESTING
END
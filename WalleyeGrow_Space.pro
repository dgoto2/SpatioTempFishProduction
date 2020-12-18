PRO WalleyeGrow_space; import input data from files

  tstart = SYSTIME(/seconds)
  
  ; Identify a direcotry for exporting daily output of state variables as .csv file
CD, 'C:\Users\Daisuke\Desktop\Walleye_production_project\Walleye outputs'; Directory; F:\SNS_SEIBM
  
  ; File location
  ; All lakes
  file = FILEPATH('Walleye_growth_data_IDL.csv', Root_dir = 'C:' $
    , SUBDIR = 'Users\Daisuke\Desktop\Walleye_production_project\Data')

  ; Lakes w/ 4 or more years of data
  ;file = FILEPATH('WAE_growth_data_Select_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
  
  ; Escanaba only
  ; length
  ;file = FILEPATH('WAE_growth_L_data_Escanaba_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
  ; weight
  ;file = FILEPATH('WAE_growth_W_data_Escanaba_IDL.csv', Root_dir = 'C:', SUBDIR = 'Users\Daisuke Goto\Desktop\Walleye_production_project\Data')
  
  ; Derived body mass data for yellow perch
  
  
  
  ; Check if the file is not blank
  IF (N_ELEMENTS(file) EQ 0L) THEN MESSAGE, 'FILE is undefined'
  ;IF (N_ELEMENTS(maxcols) EQ 0L) THEN maxcols = 8L
  
  ; Read the file
  ; Input file order
  ; (1) WBIC_Year (2) WBIC (3) SurveyYear (4) Age (5) FracAge (6) LengthMM (7) Sex
  
  ; Define the data structure
  N = 107866L; all lakes
  ;N = 26667L; Lakes w/ >4 years of data
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
  
  ; NEED TO ADD N of ageclasses, N of samples, YEAR, WBIC_YEAR, WBIC
  
  ;Numageclass = Nageclass[NumsampleGT30ageclassGT3]
  ;PRINT, N_ELEMENTS(Numageclass)
  ;PRINT, (Numageclass)
  
  
  ; HOW TO CONSTRAIN PARAMETER VALUES
  ;You pass an array of structures through the PARINFO keyword, one structure for each parameter.
  ;The structure describes which parameters should be fixed, and also whether any constraints should be imposed
  ;on the parameter (such as lower or upper bounds). The structures must have a few required fields.
  ;You can do this by replicating a single one like this:
  
  ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]},4)
  
  ;A total of four structures are made because there are four parameters. Once we have the blank template, then
  ;we can fill in any values we desire. For example, we want to fix the first parameter, the constant:
  ;
  ;pi(0).fixed = 1
  ;start(0) = 1000
  ;I have reset the starting value to 1000 (the desired value), and "fixed" that parameter by setting it to one.
  ;If fixed is zero for a particular parameter, then it is allowed to vary. Now we run the fit again, but pass pi
  ;to the fitter using the PARINFO keyword:
  ;
  ;result = MPFITEXPR(expr,     t, r, rerr, start, PARINFO=pi)
  ;result = MPFITFUN('MYGAUSS', t, r, rerr, start, PARINFO=pi)
  
  ;Specifying Constraining Bounds
  ;All of the fitting procedures here also allow you to impose lower and upper bounding constraints on
  ;any combination of the parameters you choose. This might be important, say, if you need to require a
  ;certain parameter to be positive, or be constrained between two fixed values. The technique again uses
  ;the PARINFO keyword. You see above that in addition to the fixed entry, there are some others, including
  ;limited and limits. They work in a similar fashion to fixed.
  
  ;For example, let us say we know a priori that the Gaussian mean must be above a value of 2.3. I need to fill
  ;that information into the PARINFO structure like this:
  
  ;pi(1).limited(0) = 1
  ;pi(1).limits(0) = 2.3
  
  ;Here, for parameter number 1, I have set limited(0) equal to 1. The limited entry has two values corresponding to
  ;the lower and upper boundaries, respectively. If limited(0) is set to 1, then the lower boundary is activated. The
  ;boundary itself is found in limits(0), where I entered the value of 2.3. The same logic applies to the upper limits
  ;(which for each parameter are specified in limited(1) and limits(1)). You can have any combination of lower and upper
  ;limits for each parameter. Just make sure that you set both the limited and limits entries: one enables the bound, and
  ;the other gives the actual boundary value.
  
  ;Advanced Fitting: Controlling and Limiting the Parameters
  ;
  ;The mpfit routines allow for some additional control over the fitting. For example, what if you had some information that the amplitude of the gaussian had to be greater than zero? What if you knew that the centroid was precisely 10.2? You want to provide the fitting routine with this information so that it doesn't go off on the wrong path.
  ;
  ;Control information is passed through the structure variable parinfo, which is easier to learn by example rather than by explanation (there is detailed documentation in the mpfitfun.pro file). Here's an example of parinfo for the situation I just described.
  ;
  ;parinfo = replicate({value:0.0, fixed:0, limited:[0,0], limits:[0.0,0.0]}, 3)
  ;
  ;This statement initializes the control array to its defaults; i.e., all parameters vary freely. The last number is the number of parameters in your model; for the gaussian, 3.
  ;
  ;Now, we want to fix the amplitude to be greater than 0.
  ;
  ;parinfo[0].limited[0] = 1; parameter 0, the amplitude, has a lower bound
  ;parinfo[0].limits[0] = 0.0; do not accept values less than zero
  ;
  ;Now lets force the centroid to be 10.2.
  ;
  ;parinfo[1].fixed = 1
  ;parinfo[1].value = 10.2
  
  ;By the way, it's a good idea not to use startparms if you are going to use parinfo.
  ;Instead, set your initial guesses in parinfo.
  ;
  ;parinfo[0].value = 1.0
  ;parinfo[2].value = 10.0
  ;
  ;And, of course, we've already set parinfo[1].value when we fixed the centroid.
  ;Now, retry the fit and see what happens.
  ;
  ;startparms[1] = 10.2
  ;parms = mpfitfun('jacksgaussian', x, y, dy, perror = dparms, yfit=yfit, parinfo=parinfo)
  
  ; Find unique lake-years for growth curve parameterization
  uniqWBIC_Year = WBIC_Year[UNIQ(WBIC_Year, SORT(WBIC_Year))]
  ; Allocate an array for paramter outputs
  paramset = FLTARR(121L, N_ELEMENTS(uniqWBIC_Year))
  
  WAE_size_age = FLTARR(198L, N_ELEMENTS(uniqWBIC_Year)+1L)
  WAE_size_age_all = FLTARR(198, max(SurveyYear2)-min(SurveyYear2)+1L)
  ;WAE_size_age_all = FLTARR(198, 40)
  year = indgen(max(SurveyYear2)-min(SurveyYear2)+1L)+min(SurveyYear2)
  
  
  ; Pooling by YEAR
  For i = 0L, max(SurveyYear2)-min(SurveyYear2) do begin
    INDEX_growthdata_ALL = WHERE(SurveyYear2[*] EQ year[i], INDEX_growthdata_allcount)
    
    ;INDEX_growthdata = WHERE(WBIC_Year2[*] EQ uniqWBIC_Year[i], INDEX_growthdatacount)
    
    ; arrays based on N of samples: all records > unique WBIC_year > unique WBIC
    IF INDEX_growthdata_allcount GT 0 THEN BEGIN
      Nageclass = INTARR(3L, INDEX_growthdata_allcount); subarray w/ unique WBIC_year only
      
      ;   FOR ii = 0L, INDEX_growthdata_allcount-1L DO BEGIN
      Numageclass = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL]), SORT(FIX(AGE[INDEX_growthdata_ALL]), /L64)))
      Maxageclass = Max(AGE[INDEX_growthdata_ALL])
      Minageclass = Min(AGE[INDEX_growthdata_ALL])
      
      
      Length_Gro = Length2[INDEX_growthdata_ALL]
      Age_Gro = Age2[INDEX_growthdata_ALL]
      Sex_Gro = Sex2[INDEX_growthdata_ALL]
      
      Male = WHERE(Sex_Gro eq 0, malecount)
      Female = WHERE(Sex_Gro eq 1, femalecount)
      unknown = WHERE(Sex_Gro eq 2, unknowncount)
      
      IF malecouNt gt 0 then begin
        NumageclassM = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL[male]]), SORT(FIX(AGE[INDEX_growthdata_ALL[male]]), /L64)))
        MaxageclassM = Max(AGE[INDEX_growthdata_ALL[male]])
        MinageclassM = Min(AGE[INDEX_growthdata_ALL[male]])
      endif
      if femalecount gt 0 then begin
        NumageclassF = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL[female]]), SORT(FIX(AGE[INDEX_growthdata_ALL[female]]), /L64)))
        MaxageclassF = Max(AGE[INDEX_growthdata_ALL[female]])
        MinageclassF = Min(AGE[INDEX_growthdata_ALL[female]])
      endif
      
      ;paramset[0, i] = uniqWBIC_Year[i]
      paramset[1, i] = N_ELEMENTS(Length_Gro)
      ;paramset[2, i] = WBIC2[INDEX_growthdata_ALL[0]]
      paramset[3, i] = SurveyYear2[INDEX_growthdata_ALL[0]]
      ;   ENDFOR
      
      
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
      
      
      
      ; Parameterize the VBGF for each WBIC_year
      ;FOR i = 0L, N_ELEMENTS(uniqWBIC_Year)-1L DO BEGIN
      ;
      ;  INDEX_growthdata = WHERE(WBIC_Year2[*] EQ uniqWBIC_Year[i], INDEX_growthdatacount)
      ;  ;paramset[22L, i] = INDEX_growthdatacount
      ;  print,'Number of unique WBIC_year',INDEX_growthdatacount
      ;
      ;  Nageclass = INTARR(3L, INDEX_growthdatacount); subarray w/ unique WBIC_year only
      ;; arrays based on N of samples: all records > unique WBIC_year > unique WBIC
      ;
      ;
      ;  FOR ii = 0L, INDEX_growthdatacount-1L DO BEGIN
      ;      IF INDEX_growthdatacount GT 0 THEN BEGIN
      ;        Numageclass = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata]), SORT(FIX(AGE[INDEX_growthdata]), /L64)))
      ;        Maxageclass = Max(AGE[INDEX_growthdata])
      ;        Minageclass = Min(AGE[INDEX_growthdata])
      ;
      ;        Length_Gro = Length2[INDEX_growthdata]
      ;        Age_Gro = Age2[INDEX_growthdata]
      ;        Sex_Gro = Sex2[INDEX_growthdata]
      ;
      ;        Male = WHERE(Sex_Gro eq 0, malecount)
      ;        Female = WHERE(Sex_Gro eq 1, femalecount)
      ;        unknown = WHERE(Sex_Gro eq 2, unknowncount)
      ;
      ;        paramset[0, i] = uniqWBIC_Year[i]
      ;        paramset[1, i] = N_ELEMENTS(Length_Gro)
      ;        paramset[2, i] = WBIC2[INDEX_growthdata[0]]
      ;        paramset[3, i] = SurveyYear2[INDEX_growthdata[0]]
      ;    ;PRINT, 'Observed length', Length_Gro
      ;    ;PRINT, 'Observed age', Age_Gro
      
      
      ;      ; All
      ;      age1 = WHERE((AGE[INDEX_growthdata] EQ 1), Age1count)
      ;      age2 = WHERE((AGE[INDEX_growthdata] EQ 2), AGE2count)
      ;      age3 = WHERE((AGE[INDEX_growthdata] EQ 3), AGE3count)
      ;      age4 = WHERE((AGE[INDEX_growthdata] EQ 4), AGE4count)
      ;      age5 = WHERE((AGE[INDEX_growthdata] EQ 5) , AGE5count)
      ;      age6 = WHERE((AGE[INDEX_growthdata] EQ 6) , AGE6count)
      ;      age7 = WHERE((AGE[INDEX_growthdata] EQ 7) , AGE7count)
      ;      age8 = WHERE((AGE[INDEX_growthdata] EQ 8), AGE8count)
      ;      age9 = WHERE((AGE[INDEX_growthdata] EQ 9), AGE9count)
      ;      age10 = WHERE((AGE[INDEX_growthdata] EQ 10), AGE10count)
      ;      age11 = WHERE((AGE[INDEX_growthdata] EQ 11) , AGE11count)
      ;      age12 = WHERE((AGE[INDEX_growthdata] EQ 12) , AGE12count)
      ;      age13 = WHERE((AGE[INDEX_growthdata] EQ 13), AGE13count)
      ;      ; Male
      ;      age1M = WHERE((AGE[INDEX_growthdata] EQ 1) AND (SEX[INDEX_growthdata] EQ 0), Age1Mcount)
      ;      age2M = WHERE((AGE[INDEX_growthdata] EQ 2) AND (SEX[INDEX_growthdata] EQ 0), AGE2Mcount)
      ;      age3M = WHERE((AGE[INDEX_growthdata] EQ 3) AND (SEX[INDEX_growthdata] EQ 0), AGE3Mcount)
      ;      age4M = WHERE((AGE[INDEX_growthdata] EQ 4) AND (SEX[INDEX_growthdata] EQ 0), AGE4Mcount)
      ;      age5M = WHERE((AGE[INDEX_growthdata] EQ 5) AND (SEX[INDEX_growthdata] EQ 0), AGE5Mcount)
      ;      age6M = WHERE((AGE[INDEX_growthdata] EQ 6) AND (SEX[INDEX_growthdata] EQ 0), AGE6Mcount)
      ;      age7M = WHERE((AGE[INDEX_growthdata] EQ 7) AND (SEX[INDEX_growthdata] EQ 0), AGE7Mcount)
      ;      age8M = WHERE((AGE[INDEX_growthdata] EQ 8) AND (SEX[INDEX_growthdata] EQ 0), AGE8Mcount)
      ;      age9M = WHERE((AGE[INDEX_growthdata] EQ 9) AND (SEX[INDEX_growthdata] EQ 0), AGE9Mcount)
      ;      age10M = WHERE((AGE[INDEX_growthdata] EQ 10) AND (SEX[INDEX_growthdata] EQ 0), AGE10Mcount)
      ;      age11M = WHERE((AGE[INDEX_growthdata] EQ 11) AND (SEX[INDEX_growthdata] EQ 0), AGE11Mcount)
      ;      age12M = WHERE((AGE[INDEX_growthdata] EQ 12) AND (SEX[INDEX_growthdata] EQ 0), AGE12Mcount)
      ;      age13M = WHERE((AGE[INDEX_growthdata] EQ 13) AND (SEX[INDEX_growthdata] EQ 0), AGE13Mcount)
      ;      ; Female
      ;      age1F = WHERE((AGE[INDEX_growthdata] EQ 1) AND (SEX[INDEX_growthdata] EQ 1), Age1Fcount)
      ;      age2F = WHERE((AGE[INDEX_growthdata] EQ 2) AND (SEX[INDEX_growthdata] EQ 1), AGE2Fcount)
      ;      age3F = WHERE((AGE[INDEX_growthdata] EQ 3) AND (SEX[INDEX_growthdata] EQ 1), AGE3Fcount)
      ;      age4F = WHERE((AGE[INDEX_growthdata] EQ 4) AND (SEX[INDEX_growthdata] EQ 1), AGE4Fcount)
      ;      age5F = WHERE((AGE[INDEX_growthdata] EQ 5) AND (SEX[INDEX_growthdata] EQ 1), AGE5Fcount)
      ;      age6F = WHERE((AGE[INDEX_growthdata] EQ 6) AND (SEX[INDEX_growthdata] EQ 1), AGE6Fcount)
      ;      age7F = WHERE((AGE[INDEX_growthdata] EQ 7) AND (SEX[INDEX_growthdata] EQ 1), AGE7Fcount)
      ;      age8F = WHERE((AGE[INDEX_growthdata] EQ 8) AND (SEX[INDEX_growthdata] EQ 1), AGE8Fcount)
      ;      age9F = WHERE((AGE[INDEX_growthdata] EQ 9) AND (SEX[INDEX_growthdata] EQ 1), AGE9Fcount)
      ;      age10F = WHERE((AGE[INDEX_growthdata] EQ 10) AND (SEX[INDEX_growthdata] EQ 1), AGE10Fcount)
      ;      age11F = WHERE((AGE[INDEX_growthdata] EQ 11) AND (SEX[INDEX_growthdata] EQ 1), AGE11Fcount)
      ;      age12F = WHERE((AGE[INDEX_growthdata] EQ 12) AND (SEX[INDEX_growthdata] EQ 1), AGE12Fcount)
      ;      age13F = WHERE((AGE[INDEX_growthdata] EQ 13) AND (SEX[INDEX_growthdata] EQ 1), AGE13Fcount)
      ;
      ;      WAE_size_age[0, i] = WBIC_Year[INDEX_growthdata[0]]
      ;      WAE_size_age[1, i] = WBIC[INDEX_growthdata[0]]
      ;      WAE_size_age[2, i] = SurveyYear[INDEX_growthdata[0]]
      ;
      ;      IF Age1Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[3, i] = MEAN(Length[INDEX_growthdata[age1M]])
      ;        WAE_size_age[4, i] = STDDEV(Length[INDEX_growthdata[age1M]])
      ;        WAE_size_age[5, i] = N_ELEMENTS(Length[INDEX_growthdata[age1M]])
      ;        WAE_size_age[6, i] = MAX(Length[INDEX_growthdata[age1M]])
      ;        WAE_size_age[7, i] = MIN(Length[INDEX_growthdata[age1M]])
      ;      ENDIF
      ;      IF Age2Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[8, i] = MEAN(Length[INDEX_growthdata[age2M]])
      ;        WAE_size_age[9, i] = STDDEV(Length[INDEX_growthdata[age2M]])
      ;        WAE_size_age[10, i] = N_ELEMENTS(Length[INDEX_growthdata[age2M]])
      ;        WAE_size_age[11, i] = MAX(Length[INDEX_growthdata[age2M]])
      ;        WAE_size_age[12, i] = MIN(Length[INDEX_growthdata[age2M]])
      ;      ENDIF
      ;      IF Age3Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[13, i] = MEAN(Length[INDEX_growthdata[age3M]])
      ;        WAE_size_age[14, i] = STDDEV(Length[INDEX_growthdata[age3M]])
      ;        WAE_size_age[15, i] = N_ELEMENTS(Length[INDEX_growthdata[age4M]])
      ;        WAE_size_age[16, i] = MAX(Length[INDEX_growthdata[age3M]])
      ;        WAE_size_age[17, i] = MIN(Length[INDEX_growthdata[age3M]])
      ;      ENDIF
      ;      IF Age4Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[18, i] = MEAN(Length[INDEX_growthdata[age4M]])
      ;        WAE_size_age[19, i] = STDDEV(Length[INDEX_growthdata[age4M]])
      ;        WAE_size_age[20, i] = N_ELEMENTS(Length[INDEX_growthdata[age4M]])
      ;        WAE_size_age[21, i] = MAX(Length[INDEX_growthdata[age4M]])
      ;        WAE_size_age[22, i] = MIN(Length[INDEX_growthdata[age4M]])
      ;      ENDIF
      ;       IF Age5Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[23, i] = MEAN(Length[INDEX_growthdata[age5M]])
      ;        WAE_size_age[24, i] = STDDEV(Length[INDEX_growthdata[age5M]])
      ;        WAE_size_age[25, i] = N_ELEMENTS(Length[INDEX_growthdata[age5M]])
      ;        WAE_size_age[26, i] = MAX(Length[INDEX_growthdata[age5M]])
      ;        WAE_size_age[27, i] = MIN(Length[INDEX_growthdata[age5M]])
      ;      ENDIF
      ;      IF Age6Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[28, i] = MEAN(Length[INDEX_growthdata[age6M]])
      ;        WAE_size_age[29, i] = STDDEV(Length[INDEX_growthdata[age6M]])
      ;        WAE_size_age[30, i] = N_ELEMENTS(Length[INDEX_growthdata[age6M]])
      ;        WAE_size_age[31, i] = MAX(Length[INDEX_growthdata[age6M]])
      ;        WAE_size_age[32, i] = MIN(Length[INDEX_growthdata[age6M]])
      ;      ENDIF
      ;       IF Age7Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[33, i] = MEAN(Length[INDEX_growthdata[age7M]])
      ;        WAE_size_age[34, i] = STDDEV(Length[INDEX_growthdata[age7M]])
      ;        WAE_size_age[35, i] = N_ELEMENTS(Length[INDEX_growthdata[age7M]])
      ;        WAE_size_age[36, i] = MAX(Length[INDEX_growthdata[age7M]])
      ;        WAE_size_age[37, i] = MIN(Length[INDEX_growthdata[age7M]])
      ;      ENDIF
      ;      IF Age8Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[38, i] = MEAN(Length[INDEX_growthdata[age8M]])
      ;        WAE_size_age[39, i] = STDDEV(Length[INDEX_growthdata[age8M]])
      ;        WAE_size_age[40, i] = N_ELEMENTS(Length[INDEX_growthdata[age8M]])
      ;        WAE_size_age[41, i] = MAX(Length[INDEX_growthdata[age8M]])
      ;        WAE_size_age[42, i] = MIN(Length[INDEX_growthdata[age8M]])
      ;      ENDIF
      ;      IF Age9Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[43, i] = MEAN(Length[INDEX_growthdata[age9M]])
      ;        WAE_size_age[44, i] = STDDEV(Length[INDEX_growthdata[age9M]])
      ;        WAE_size_age[45, i] = N_ELEMENTS(Length[INDEX_growthdata[age9M]])
      ;        WAE_size_age[46, i] = MAX(Length[INDEX_growthdata[age9M]])
      ;        WAE_size_age[47, i] = MIN(Length[INDEX_growthdata[age9M]])
      ;      ENDIF
      ;      IF Age10Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[48, i] = MEAN(Length[INDEX_growthdata[age10M]])
      ;        WAE_size_age[49, i] = STDDEV(Length[INDEX_growthdata[age10M]])
      ;        WAE_size_age[50, i] = N_ELEMENTS(Length[INDEX_growthdata[age10M]])
      ;        WAE_size_age[51, i] = MAX(Length[INDEX_growthdata[age10M]])
      ;        WAE_size_age[52, i] = MIN(Length[INDEX_growthdata[age10M]])
      ;      ENDIF
      ;      IF Age11Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[53, i] = MEAN(Length[INDEX_growthdata[age11M]])
      ;        WAE_size_age[54, i] = STDDEV(Length[INDEX_growthdata[age11M]])
      ;        WAE_size_age[55, i] = N_ELEMENTS(Length[INDEX_growthdata[age11M]])
      ;        WAE_size_age[56, i] = MAX(Length[INDEX_growthdata[age11M]])
      ;        WAE_size_age[57, i] = MIN(Length[INDEX_growthdata[age11M]])
      ;      ENDIF
      ;      IF Age12Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[58, i] = MEAN(Length[INDEX_growthdata[age12M]])
      ;        WAE_size_age[59, i] = STDDEV(Length[INDEX_growthdata[age12M]])
      ;        WAE_size_age[60, i] = N_ELEMENTS(Length[INDEX_growthdata[age12M]])
      ;        WAE_size_age[61, i] = MAX(Length[INDEX_growthdata[age12M]])
      ;        WAE_size_age[62, i] = MIN(Length[INDEX_growthdata[age12M]])
      ;      ENDIF
      ;      IF Age13Mcount GT 0. THEN BEGIN
      ;        WAE_size_age[63, i] = MEAN(Length[INDEX_growthdata[age13M]])
      ;        WAE_size_age[64, i] = STDDEV(Length[INDEX_growthdata[age13M]])
      ;        WAE_size_age[65, i] = N_ELEMENTS(Length[INDEX_growthdata[age13M]])
      ;        WAE_size_age[66, i] = MAX(Length[INDEX_growthdata[age13M]])
      ;        WAE_size_age[67, i] = MIN(Length[INDEX_growthdata[age13M]])
      ;      ENDIF
      ;
      ;      ; Female
      ;      IF Age1Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[68, i] = MEAN(Length[INDEX_growthdata[age1F]])
      ;        WAE_size_age[69, i] = STDDEV(Length[INDEX_growthdata[age1F]])
      ;        WAE_size_age[70, i] = N_ELEMENTS(Length[INDEX_growthdata[age1F]])
      ;        WAE_size_age[71, i] = MAX(Length[INDEX_growthdata[age1F]])
      ;        WAE_size_age[72, i] = MIN(Length[INDEX_growthdata[age1F]])
      ;      ENDIF
      ;      IF Age2Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[73, i] = MEAN(Length[INDEX_growthdata[age2F]])
      ;        WAE_size_age[74, i] = STDDEV(Length[INDEX_growthdata[age2F]])
      ;        WAE_size_age[75, i] = N_ELEMENTS(Length[INDEX_growthdata[age2F]])
      ;        WAE_size_age[76, i] = MAX(Length[INDEX_growthdata[age2F]])
      ;        WAE_size_age[77, i] = MIN(Length[INDEX_growthdata[age2F]])
      ;      ENDIF
      ;      IF Age3Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[78, i] = MEAN(Length[INDEX_growthdata[age3F]])
      ;        WAE_size_age[79, i] = STDDEV(Length[INDEX_growthdata[age3F]])
      ;        WAE_size_age[80, i] = N_ELEMENTS(Length[INDEX_growthdata[age3F]])
      ;        WAE_size_age[81, i] = MAX(Length[INDEX_growthdata[age3F]])
      ;        WAE_size_age[82, i] = MIN(Length[INDEX_growthdata[age3F]])
      ;      ENDIF
      ;      IF Age4Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[83, i] = MEAN(Length[INDEX_growthdata[age4F]])
      ;        WAE_size_age[84, i] = STDDEV(Length[INDEX_growthdata[age4F]])
      ;        WAE_size_age[85, i] = N_ELEMENTS(Length[INDEX_growthdata[age4F]])
      ;        WAE_size_age[86, i] = MAX(Length[INDEX_growthdata[age4F]])
      ;        WAE_size_age[87, i] = MIN(Length[INDEX_growthdata[age4F]])
      ;      ENDIF
      ;       IF Age5Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[88, i] = MEAN(Length[INDEX_growthdata[age5F]])
      ;        WAE_size_age[89, i] = STDDEV(Length[INDEX_growthdata[age5F]])
      ;        WAE_size_age[90, i] = N_ELEMENTS(Length[INDEX_growthdata[age5F]])
      ;        WAE_size_age[91, i] = MAX(Length[INDEX_growthdata[age5F]])
      ;        WAE_size_age[92, i] = MIN(Length[INDEX_growthdata[age5F]])
      ;      ENDIF
      ;      IF Age6Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[93, i] = MEAN(Length[INDEX_growthdata[age6F]])
      ;        WAE_size_age[94, i] = STDDEV(Length[INDEX_growthdata[age6F]])
      ;        WAE_size_age[95, i] = N_ELEMENTS(Length[INDEX_growthdata[age6F]])
      ;        WAE_size_age[96, i] = MAX(Length[INDEX_growthdata[age6F]])
      ;        WAE_size_age[97, i] = MIN(Length[INDEX_growthdata[age6F]])
      ;      ENDIF
      ;       IF Age7Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[98, i] = MEAN(Length[INDEX_growthdata[age7F]])
      ;        WAE_size_age[99, i] = STDDEV(Length[INDEX_growthdata[age7F]])
      ;        WAE_size_age[100, i] = N_ELEMENTS(Length[INDEX_growthdata[age7F]])
      ;        WAE_size_age[101, i] = MAX(Length[INDEX_growthdata[age7F]])
      ;        WAE_size_age[102, i] = MIN(Length[INDEX_growthdata[age7F]])
      ;      ENDIF
      ;      IF Age8Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[103, i] = MEAN(Length[INDEX_growthdata[age8F]])
      ;        WAE_size_age[104, i] = STDDEV(Length[INDEX_growthdata[age8F]])
      ;        WAE_size_age[105, i] = N_ELEMENTS(Length[INDEX_growthdata[age8F]])
      ;        WAE_size_age[106, i] = MAX(Length[INDEX_growthdata[age8F]])
      ;        WAE_size_age[107, i] = MIN(Length[INDEX_growthdata[age8F]])
      ;      ENDIF
      ;      IF Age9Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[108, i] = MEAN(Length[INDEX_growthdata[age9F]])
      ;        WAE_size_age[109, i] = STDDEV(Length[INDEX_growthdata[age9F]])
      ;        WAE_size_age[110, i] = N_ELEMENTS(Length[INDEX_growthdata[age9F]])
      ;        WAE_size_age[111, i] = MAX(Length[INDEX_growthdata[age9F]])
      ;        WAE_size_age[112, i] = MIN(Length[INDEX_growthdata[age9F]])
      ;      ENDIF
      ;      IF Age10Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[113, i] = MEAN(Length[INDEX_growthdata[age10F]])
      ;        WAE_size_age[114, i] = STDDEV(Length[INDEX_growthdata[age10F]])
      ;        WAE_size_age[115, i] = N_ELEMENTS(Length[INDEX_growthdata[age10F]])
      ;        WAE_size_age[116, i] = MAX(Length[INDEX_growthdata[age10F]])
      ;        WAE_size_age[117, i] = MIN(Length[INDEX_growthdata[age10F]])
      ;      ENDIF
      ;      IF Age11Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[118, i] = MEAN(Length[INDEX_growthdata[age11F]])
      ;        WAE_size_age[119, i] = STDDEV(Length[INDEX_growthdata[age11F]])
      ;        WAE_size_age[120, i] = N_ELEMENTS(Length[INDEX_growthdata[age11F]])
      ;        WAE_size_age[121, i] = MAX(Length[INDEX_growthdata[age11F]])
      ;        WAE_size_age[122, i] = MIN(Length[INDEX_growthdata[age11F]])
      ;      ENDIF
      ;      IF Age12Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[123, i] = MEAN(Length[INDEX_growthdata[age12F]])
      ;        WAE_size_age[124, i] = STDDEV(Length[INDEX_growthdata[age12F]])
      ;        WAE_size_age[125, i] = N_ELEMENTS(Length[INDEX_growthdata[age12F]])
      ;        WAE_size_age[126, i] = MAX(Length[INDEX_growthdata[age12F]])
      ;        WAE_size_age[127, i] = MIN(Length[INDEX_growthdata[age12F]])
      ;      ENDIF
      ;      IF Age13Fcount GT 0. THEN BEGIN
      ;        WAE_size_age[128, i] = MEAN(Length[INDEX_growthdata[age13F]])
      ;        WAE_size_age[129, i] = STDDEV(Length[INDEX_growthdata[age13F]])
      ;        WAE_size_age[130, i] = N_ELEMENTS(Length[INDEX_growthdata[age13F]])
      ;        WAE_size_age[131, i] = MAX(Length[INDEX_growthdata[age13F]])
      ;        WAE_size_age[132, i] = MIN(Length[INDEX_growthdata[age13F]])
      ;      ENDIF
      ;
      ;      ;all
      ;      IF Age1count GT 0. THEN BEGIN
      ;        WAE_size_age[133, i] = MEAN(Length[INDEX_growthdata[age1]])
      ;        WAE_size_age[134, i] = STDDEV(Length[INDEX_growthdata[age1]])
      ;        WAE_size_age[135, i] = N_ELEMENTS(Length[INDEX_growthdata[age1]])
      ;        WAE_size_age[136, i] = MAX(Length[INDEX_growthdata[age1]])
      ;        WAE_size_age[137, i] = MIN(Length[INDEX_growthdata[age1]])
      ;      ENDIF
      ;      IF Age2count GT 0. THEN BEGIN
      ;        WAE_size_age[138, i] = MEAN(Length[INDEX_growthdata[age2]])
      ;        WAE_size_age[139, i] = STDDEV(Length[INDEX_growthdata[age2]])
      ;        WAE_size_age[140, i] = N_ELEMENTS(Length[INDEX_growthdata[age2]])
      ;        WAE_size_age[141, i] = MAX(Length[INDEX_growthdata[age2]])
      ;        WAE_size_age[142, i] = MIN(Length[INDEX_growthdata[age2]])
      ;      ENDIF
      ;      IF Age3count GT 0. THEN BEGIN
      ;        WAE_size_age[143, i] = MEAN(Length[INDEX_growthdata[age3]])
      ;        WAE_size_age[144, i] = STDDEV(Length[INDEX_growthdata[age3]])
      ;        WAE_size_age[145, i] = N_ELEMENTS(Length[INDEX_growthdata[age4]])
      ;        WAE_size_age[146, i] = MAX(Length[INDEX_growthdata[age3]])
      ;        WAE_size_age[147, i] = MIN(Length[INDEX_growthdata[age3]])
      ;      ENDIF
      ;      IF Age4count GT 0. THEN BEGIN
      ;        WAE_size_age[148, i] = MEAN(Length[INDEX_growthdata[age4]])
      ;        WAE_size_age[149, i] = STDDEV(Length[INDEX_growthdata[age4]])
      ;        WAE_size_age[150, i] = N_ELEMENTS(Length[INDEX_growthdata[age4]])
      ;        WAE_size_age[151, i] = MAX(Length[INDEX_growthdata[age4]])
      ;        WAE_size_age[152, i] = MIN(Length[INDEX_growthdata[age4]])
      ;      ENDIF
      ;       IF Age5count GT 0. THEN BEGIN
      ;        WAE_size_age[153, i] = MEAN(Length[INDEX_growthdata[age5]])
      ;        WAE_size_age[154, i] = STDDEV(Length[INDEX_growthdata[age5]])
      ;        WAE_size_age[155, i] = N_ELEMENTS(Length[INDEX_growthdata[age5]])
      ;        WAE_size_age[156, i] = MAX(Length[INDEX_growthdata[age5]])
      ;        WAE_size_age[157, i] = MIN(Length[INDEX_growthdata[age5]])
      ;      ENDIF
      ;      IF Age6count GT 0. THEN BEGIN
      ;        WAE_size_age[158, i] = MEAN(Length[INDEX_growthdata[age6]])
      ;        WAE_size_age[159, i] = STDDEV(Length[INDEX_growthdata[age6]])
      ;        WAE_size_age[160, i] = N_ELEMENTS(Length[INDEX_growthdata[age6]])
      ;        WAE_size_age[161, i] = MAX(Length[INDEX_growthdata[age6]])
      ;        WAE_size_age[162, i] = MIN(Length[INDEX_growthdata[age6]])
      ;      ENDIF
      ;       IF Age7count GT 0. THEN BEGIN
      ;        WAE_size_age[163, i] = MEAN(Length[INDEX_growthdata[age7]])
      ;        WAE_size_age[164, i] = STDDEV(Length[INDEX_growthdata[age7]])
      ;        WAE_size_age[165, i] = N_ELEMENTS(Length[INDEX_growthdata[age7]])
      ;        WAE_size_age[166, i] = MAX(Length[INDEX_growthdata[age7]])
      ;        WAE_size_age[167, i] = MIN(Length[INDEX_growthdata[age7]])
      ;      ENDIF
      ;      IF Age8count GT 0. THEN BEGIN
      ;        WAE_size_age[168, i] = MEAN(Length[INDEX_growthdata[age8]])
      ;        WAE_size_age[169, i] = STDDEV(Length[INDEX_growthdata[age8]])
      ;        WAE_size_age[170, i] = N_ELEMENTS(Length[INDEX_growthdata[age8]])
      ;        WAE_size_age[171, i] = MAX(Length[INDEX_growthdata[age8]])
      ;        WAE_size_age[172, i] = MIN(Length[INDEX_growthdata[age8]])
      ;      ENDIF
      ;      IF Age9count GT 0. THEN BEGIN
      ;        WAE_size_age[173, i] = MEAN(Length[INDEX_growthdata[age9]])
      ;        WAE_size_age[174, i] = STDDEV(Length[INDEX_growthdata[age9]])
      ;        WAE_size_age[175, i] = N_ELEMENTS(Length[INDEX_growthdata[age9]])
      ;        WAE_size_age[176, i] = MAX(Length[INDEX_growthdata[age9]])
      ;        WAE_size_age[177, i] = MIN(Length[INDEX_growthdata[age9]])
      ;      ENDIF
      ;      IF Age10count GT 0. THEN BEGIN
      ;        WAE_size_age[178, i] = MEAN(Length[INDEX_growthdata[age10]])
      ;        WAE_size_age[179, i] = STDDEV(Length[INDEX_growthdata[age10]])
      ;        WAE_size_age[170, i] = N_ELEMENTS(Length[INDEX_growthdata[age10]])
      ;        WAE_size_age[181, i] = MAX(Length[INDEX_growthdata[age10]])
      ;        WAE_size_age[182, i] = MIN(Length[INDEX_growthdata[age10]])
      ;      ENDIF
      ;      IF Age11count GT 0. THEN BEGIN
      ;        WAE_size_age[183, i] = MEAN(Length[INDEX_growthdata[age11]])
      ;        WAE_size_age[184, i] = STDDEV(Length[INDEX_growthdata[age11]])
      ;        WAE_size_age[185, i] = N_ELEMENTS(Length[INDEX_growthdata[age11]])
      ;        WAE_size_age[186, i] = MAX(Length[INDEX_growthdata[age11]])
      ;        WAE_size_age[187, i] = MIN(Length[INDEX_growthdata[age11]])
      ;      ENDIF
      ;      IF Age12count GT 0. THEN BEGIN
      ;        WAE_size_age[188, i] = MEAN(Length[INDEX_growthdata[age12]])
      ;        WAE_size_age[189, i] = STDDEV(Length[INDEX_growthdata[age12]])
      ;        WAE_size_age[190, i] = N_ELEMENTS(Length[INDEX_growthdata[age12]])
      ;        WAE_size_age[191, i] = MAX(Length[INDEX_growthdata[age12]])
      ;        WAE_size_age[192, i] = MIN(Length[INDEX_growthdata[age12]])
      ;      ENDIF
      ;      IF Age13count GT 0. THEN BEGIN
      ;        WAE_size_age[193, i] = MEAN(Length[INDEX_growthdata[age13]])
      ;        WAE_size_age[194, i] = STDDEV(Length[INDEX_growthdata[age13]])
      ;        WAE_size_age[195, i] = N_ELEMENTS(Length[INDEX_growthdata[age13]])
      ;        WAE_size_age[196, i] = MAX(Length[INDEX_growthdata[age13]])
      ;        WAE_size_age[197, i] = MIN(Length[INDEX_growthdata[age13]])
      ;      ENDIF
      
      ;    ENDIF
      ;ENDFOR
      ;PRINT, 'uniqWBIC_Year_NsmplGT30_NageclassGT3[i]', uniqWBIC_Year_NsmplGT30_NageclassGT3[i]
      ;PRINT, INDEX_datafinal
      
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
      
      ; Plot data
      ;length
      PLOT, Age_Gro, Length_Gro, psym=4, xtitle='Age (year)', ytitle='Length (mm)', xrange=[0,25] $
        , title='Growth_analysis_WI_walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
      filename='Walleye age vs. length'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
      
      ; ; Weight
      ;  PLOT, Age_Gro, Length_Gro, psym=4, xtitle='Age (year)', ytitle='Weight (g)', xrange=[0,25] $
      ;    , title='VBGF_WI walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
      ;  filename='Walleye age vs. weight'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
      
      ;  ;ln(age) for log linear models
      ;  PLOT, alog(Age_Gro), Length_Gro, psym=4, xtitle='log Age (year)', ytitle='Length (mm)', xrange=[0,5] $
      ;    , title='Loglinear_WI walleye_'+'WBIC_'+STRING(paramset[2, i])+'_Year_'+STRING(fix(paramset[3, i]))
      ;  filename='Walleye age vs. length'+ STRING(paramset[2, i])+'_'+STRING(fix(paramset[3, i]))+'.png'
      
      
      ; Run mpfitfun (watch as it iteratively improves our initial guess to minimize chi-squared);
      paramset[4, i] = Numageclass
      paramset[5, i] = Maxageclass
      paramset[6, i] = Minageclass
      paramset[7, i] = MAX(Length_Gro)
      paramset[8, i] = MIN(Length_Gro)
      
      ; add small variation to each data point
      dy = Length_Gro + RANDOMN(seed, N_ELEMENTS(Length_Gro)) * 0.1
      
      ;parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit)
      
      ;  ; 1) standard von Bertlanffy model (3 parameters) - all individuals
      ;  startparms = [850.0D, 0.1D, -1.D]
      ;  ;851  0.099 -0.96
      ;  ;WLslope = 3.18
      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,1500.D]}, 3)
      ;  pi(0).limited(1) = 0; 0=vary; 1=constant
      ;  pi(0).limits(1) = 1500.
      ;  MAXITER = 100000
      ;  num_param = 3.
      ;
      ;  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, $
      ;  perror = dparms, yfit=yfit, PARINFO=pi)
      ;  Length_Gro_EstAll = parms[0] * (1 - EXP(-parms[1] * (Age_Gro - parms[2])));^WLslope
      ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
      ;  paramset[9:11, i] = parms
      ;  paramset[14, i] = BESTNORM
      ;  paramset[15, i] = DOF
      ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
      ;  paramset[17:19, i] = dparms
      ;  paramset[22, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
      ;  paramset[23, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
      ;  paramset[24, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
      ;  paramset[25, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
      ;  paramset[26, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
      ;  paramset[27, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
      ;  paramset[28, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
      ;  paramset[29, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
      ;  paramset[30, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
      ;  paramset[31, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
      ;  paramset[32, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
      ;  paramset[33, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
      ;  paramset[34, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
      ;  paramset[35, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
      ;  paramset[36, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
      ;  paramset[37, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
      ;  paramset[38, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
      ;  paramset[39, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
      ;  paramset[40, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
      ;  paramset[41, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
      ;  paramset[42, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
      
      
      ;  ; 2) generalized von Bertlanffy model (4 parameters) - all individuals
      ;  startparms = [900.0D, 0.2D, -0.15D, 1D]
      ;  ;WLslope = 3.18
      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 4)
      ;  pi(0).limited(1) = 0; 0=vary; 1=constant
      ;  pi(0).limits(1) = 2000.
      ;  num_param = 4.
      ;  MAXITER = 100000.
      ;
      ;  parms = mpfitfun('GvonBertalanffy', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxiter $
      ;  , perror = dparms, yfit=yfit, PARINFO=pi)
      ;  Length_Gro_EstAll = parms[0] * (1 - EXP(-parms[1] * (Age_Gro - parms[2])))^parms[3];^WLslope
      ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
      ;  paramset[9:12, i] = parms
      ;  paramset[14, i] = BESTNORM
      ;  paramset[15, i] = DOF
      ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
      ;  paramset[17:20, i] = dparms
      ;  paramset[22, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))^parms[3]
      ;  paramset[23, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))^parms[3]
      ;  paramset[24, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))^parms[3]
      ;  paramset[25, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))^parms[3]
      ;  paramset[26, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))^parms[3]
      ;  paramset[27, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))^parms[3]
      ;  paramset[28, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))^parms[3]
      ;  paramset[29, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))^parms[3]
      ;  paramset[30, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))^parms[3]
      ;  paramset[31, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))^parms[3]
      ;  paramset[32, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))^parms[3]
      ;  paramset[33, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))^parms[3]
      ;  paramset[34, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))^parms[3]
      ;  paramset[35, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))^parms[3]
      ;  paramset[36, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))^parms[3]
      ;  paramset[37, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))^parms[3]
      ;  paramset[38, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))^parms[3]
      ;  paramset[39, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))^parms[3]
      ;  paramset[40, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))^parms[3]
      ;  paramset[41, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))^parms[3]
      ;  paramset[42, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))^parms[3]
      
      
      ;  ; 3) Gompertz model (3 parameters) - all individuals
      ;  startparms = [850.0D, 0.1D, -1.D]
      ;  ;WLslope = 3.18
      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
      ;  pi(0).limited(1) = 0; 0=vary; 1=constant
      ;  pi(0).limits(1) = 1500.
      ;  MAXITER = 100000
      ;  num_param = 3.
      ;
      ;  parms = mpfitfun('Gompertz', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxter $
      ;  , perror = dparms, yfit=yfit, PARINFO=pi)
      ;  Length_Gro_EstAll = parms[0] * EXP(-EXP(-parms[1] * (Age_Gro - parms[2])))
      ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
      ;  paramset[9:11, i] = parms
      ;  paramset[14, i] = BESTNORM
      ;  paramset[15, i] = DOF
      ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
      ;  paramset[17:19, i] = dparms
      ;  paramset[22, i] = parms[0] * EXP(-EXP(-parms[1] * (0. - parms[2])))
      ;  paramset[23, i] = parms[0] * EXP(-EXP(-parms[1] * (1. - parms[2])))
      ;  paramset[24, i] = parms[0] * EXP(-EXP(-parms[1] * (2. - parms[2])))
      ;  paramset[25, i] = parms[0] * EXP(-EXP(-parms[1] * (3. - parms[2])))
      ;  paramset[26, i] = parms[0] * EXP(-EXP(-parms[1] * (4. - parms[2])))
      ;  paramset[27, i] = parms[0] * EXP(-EXP(-parms[1] * (5. - parms[2])))
      ;  paramset[28, i] = parms[0] * EXP(-EXP(-parms[1] * (6. - parms[2])))
      ;  paramset[29, i] = parms[0] * EXP(-EXP(-parms[1] * (7. - parms[2])))
      ;  paramset[30, i] = parms[0] * EXP(-EXP(-parms[1] * (8. - parms[2])))
      ;  paramset[31, i] = parms[0] * EXP(-EXP(-parms[1] * (9. - parms[2])))
      ;  paramset[32, i] = parms[0] * EXP(-EXP(-parms[1] * (10. - parms[2])))
      ;  paramset[33, i] = parms[0] * EXP(-EXP(-parms[1] * (11. - parms[2])))
      ;  paramset[34, i] = parms[0] * EXP(-EXP(-parms[1] * (12. - parms[2])))
      ;  paramset[35, i] = parms[0] * EXP(-EXP(-parms[1] * (13. - parms[2])))
      ;  paramset[36, i] = parms[0] * EXP(-EXP(-parms[1] * (14. - parms[2])))
      ;  paramset[37, i] = parms[0] * EXP(-EXP(-parms[1] * (15. - parms[2])))
      ;  paramset[38, i] = parms[0] * EXP(-EXP(-parms[1] * (16. - parms[2])))
      ;  paramset[39, i] = parms[0] * EXP(-EXP(-parms[1] * (17. - parms[2])))
      ;  paramset[40, i] = parms[0] * EXP(-EXP(-parms[1] * (18. - parms[2])))
      ;  paramset[41, i] = parms[0] * EXP(-EXP(-parms[1] * (19. - parms[2])))
      ;  paramset[42, i] = parms[0] * EXP(-EXP(-parms[1] * (20. - parms[2])))
      
      
      ; 4) Logistic model (3 parameters) - all fish
      startparms = [850.0D, 0.1D, -1.D]
      ;WLslope = 3.18
      pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
      pi(0).limited(1) = 0; 0=vary; 1=constant
      pi(0).limits(1) = 1500.
      num_param = 3.
      MAXITER = 100000
      
      parms = mpfitfun('Logistic', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxiter $
        , perror = dparms, yfit=yfit, PARINFO=pi)
      Length_Gro_EstAll = parms[0] * (1.+EXP(-parms[1] * (Age_Gro - parms[2])))^(-1.)
      OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
      paramset[9:11, i] = parms
      paramset[14, i] = BESTNORM
      paramset[15, i] = DOF
      paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
        + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
      paramset[17:19, i] = dparms;
      paramset[22, i] = parms[0] * (1.+EXP(-parms[1] * (0. - parms[2])))^(-1.)
      paramset[23, i] = parms[0] * (1.+EXP(-parms[1] * (1. - parms[2])))^(-1.)
      paramset[24, i] = parms[0] * (1.+EXP(-parms[1] * (2. - parms[2])))^(-1.)
      paramset[25, i] = parms[0] * (1.+EXP(-parms[1] * (3. - parms[2])))^(-1.)
      paramset[26, i] = parms[0] * (1.+EXP(-parms[1] * (4. - parms[2])))^(-1.)
      paramset[27, i] = parms[0] * (1.+EXP(-parms[1] * (5. - parms[2])))^(-1.)
      paramset[28, i] = parms[0] * (1.+EXP(-parms[1] * (6. - parms[2])))^(-1.)
      paramset[29, i] = parms[0] * (1.+EXP(-parms[1] * (7. - parms[2])))^(-1.)
      paramset[30, i] = parms[0] * (1.+EXP(-parms[1] * (8. - parms[2])))^(-1.)
      paramset[31, i] = parms[0] * (1.+EXP(-parms[1] * (9. - parms[2])))^(-1.)
      paramset[32, i] = parms[0] * (1.+EXP(-parms[1] * (10. - parms[2])))^(-1.)
      paramset[33, i] = parms[0] * (1.+EXP(-parms[1] * (11. - parms[2])))^(-1.)
      paramset[34, i] = parms[0] * (1.+EXP(-parms[1] * (12. - parms[2])))^(-1.)
      paramset[35, i] = parms[0] * (1.+EXP(-parms[1] * (13. - parms[2])))^(-1.)
      paramset[36, i] = parms[0] * (1.+EXP(-parms[1] * (14. - parms[2])))^(-1.)
      paramset[37, i] = parms[0] * (1.+EXP(-parms[1] * (15. - parms[2])))^(-1.)
      paramset[38, i] = parms[0] * (1.+EXP(-parms[1] * (16. - parms[2])))^(-1.)
      paramset[39, i] = parms[0] * (1.+EXP(-parms[1] * (17. - parms[2])))^(-1.)
      paramset[40, i] = parms[0] * (1.+EXP(-parms[1] * (18. - parms[2])))^(-1.)
      paramset[41, i] = parms[0] * (1.+EXP(-parms[1] * (19. - parms[2])))^(-1.)
      paramset[42, i] = parms[0] * (1.+EXP(-parms[1] * (20. - parms[2])))^(-1.)
      
      
      ;  ; 5) Schnute-Richards model (5 parameters) - all fish
      ;  startparms = [850.0D, -0.005D, 0.3D, 0.8D, 0.003D]
      ;  ;845 -0.0046  0.27  0.78  0.0025
      ;  ;WLslope = 3.18
      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 5)
      ;  pi(0).limited(1) = 0; 0=vary; 1=constant
      ;  pi(0).limits(1) = 1500.
      ;  MAXITER = 100000
      ;  num_param = 5.
      ;
      ;  parms = mpfitfun('Schnute_Richards', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER=MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
      ;  Length_Gro_EstAll = parms[0] * (1+parms[1]*EXP(-parms[2] * Age_Gro^parms[3]))^(1/parms[4])
      ;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
      ;  paramset[9:13, i] = parms
      ;  paramset[14, i] = BESTNORM
      ;  paramset[15, i] = DOF
      ;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
      ;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
      ;  paramset[17:21, i] = dparms
      ;  paramset[22, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 0.^parms[3]))^(1/parms[4])
      ;  paramset[23, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 1.^parms[3]))^(1/parms[4])
      ;  paramset[24, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 2.^parms[3]))^(1/parms[4])
      ;  paramset[25, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 3.^parms[3]))^(1/parms[4])
      ;  paramset[26, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 4.^parms[3]))^(1/parms[4])
      ;  paramset[27, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 5.^parms[3]))^(1/parms[4])
      ;  paramset[28, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 6.^parms[3]))^(1/parms[4])
      ;  paramset[29, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 7.^parms[3]))^(1/parms[4])
      ;  paramset[30, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 8.^parms[3]))^(1/parms[4])
      ;  paramset[31, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 9.^parms[3]))^(1/parms[4])
      ;  paramset[32, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 10.^parms[3]))^(1/parms[4])
      ;  paramset[33, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 11.^parms[3]))^(1/parms[4])
      ;  paramset[34, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 12.^parms[3]))^(1/parms[4])
      ;  paramset[35, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 13.^parms[3]))^(1/parms[4])
      ;  paramset[36, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 14.^parms[3]))^(1/parms[4])
      ;  paramset[37, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 15.^parms[3]))^(1/parms[4])
      ;  paramset[38, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 16.^parms[3]))^(1/parms[4])
      ;  paramset[39, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 17.^parms[3]))^(1/parms[4])
      ;  paramset[40, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 18.^parms[3]))^(1/parms[4])
      ;  paramset[41, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 19.^parms[3]))^(1/parms[4])
      ;  paramset[42, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 20.^parms[3]))^(1/parms[4])
      
      
      ;  ; 6)Log-linear model - all individuals
      ;  startparms = [0.D, 0.D]
      ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
      ;  parms = mpfitfun('logLinear', (Age_Gro), Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)
      ;  Length_Gro_EstAll = parms[0] * alog(Age_Gro) + parms[1]
      ;  OPLOT, alog(Age_Gro), Length_Gro_EstAll, THICK = 2
      ;   paramset[9:10, i] = parms
      
      
      IF MALECOUNT GT 0 THEN BEGIN
        paramset[43, i] = NumageclassM
        paramset[44, i] = MaxageclassM
        paramset[45, i] = MinageclassM
        paramset[46, i] = MAX(Length_Gro[MALE])
        paramset[47, i] = MIN(Length_Gro[MALE])
        
        ;     ; 1) standard von Bertanffy model (3 parameters) - males
        ;    ;startparms = [[850.0D, 0.1D, -1.D]
        ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;
        ;    parms = mpfitfun('vonBertalanffy', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, BESTNORM=bestnorm, MAXITER = MAXITER $
        ;    , perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE] - parms[2])));^WLslope
        ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
        ;    paramset[48:50, i] = parms
        ;    paramset[53, i] = BESTNORM
        ;    paramset[54, i] = DOF
        ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[54, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
        ;    paramset[56:58, i] = dparms
        ;    paramset[61, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
        ;    paramset[62, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
        ;    paramset[63, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
        ;    paramset[64, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
        ;    paramset[65, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
        ;    paramset[66, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
        ;    paramset[67, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
        ;    paramset[68, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
        ;    paramset[69, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
        ;    paramset[70, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
        ;    paramset[71, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
        ;    paramset[72, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
        ;    paramset[73, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
        ;    paramset[74, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
        ;    paramset[75, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
        ;    paramset[76, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
        ;    paramset[77, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
        ;    paramset[78, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
        ;    paramset[79, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
        ;    paramset[80, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
        ;    paramset[81, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
        
        
        ;    ; 2) generalized von Bertanffy model - males
        ;    ;startparms = [850.0D, 0.1D, -1.D]
        ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;    parms = mpfitfun('GvonBertalanffy', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, BESTNORM=bestnorm, MAXITER = MAXITER $
        ;    , perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))^parms[3];^WLslope
        ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
        ;    paramset[48:51, i] = parms
        ;    paramset[53, i] = BESTNORM
        ;    paramset[54, i] = DOF
        ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[54, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
        ;    paramset[56:59, i] = dparms
        ;    paramset[61, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))^parms[3]
        ;    paramset[62, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))^parms[3]
        ;    paramset[63, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))^parms[3]
        ;    paramset[64, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))^parms[3]
        ;    paramset[65, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))^parms[3]
        ;    paramset[66, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))^parms[3]
        ;    paramset[67, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))^parms[3]
        ;    paramset[68, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))^parms[3]
        ;    paramset[69, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))^parms[3]
        ;    paramset[70, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))^parms[3]
        ;    paramset[71, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))^parms[3]
        ;    paramset[72, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))^parms[3]
        ;    paramset[73, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))^parms[3]
        ;    paramset[74, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))^parms[3]
        ;    paramset[75, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))^parms[3]
        ;    paramset[76, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))^parms[3]
        ;    paramset[77, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))^parms[3]
        ;    paramset[78, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))^parms[3]
        ;    paramset[79, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))^parms[3]
        ;    paramset[80, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))^parms[3]
        ;    paramset[81, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))^parms[3]
        
        
        ;    ; 3) Gompertz model (3 parameters) - males
        ;    ;startparms = [850.0D, 0.1D, -1.D]
        ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;    parms = mpfitfun('Gompertz', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, $
        ;    perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstMale = parms[0] * EXP(-EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))
        ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
        ;    paramset[48:50, i] = parms
        ;    paramset[53, i] = BESTNORM
        ;    paramset[54, i] = DOF
        ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[54, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
        ;    paramset[56:58, i] = dparms
        ;    paramset[61, i] = parms[0] * EXP(-EXP(-parms[1] * (0. - parms[2])))
        ;    paramset[62, i] = parms[0] * EXP(-EXP(-parms[1] * (1. - parms[2])))
        ;    paramset[63, i] = parms[0] * EXP(-EXP(-parms[1] * (2. - parms[2])))
        ;    paramset[64, i] = parms[0] * EXP(-EXP(-parms[1] * (3. - parms[2])))
        ;    paramset[65, i] = parms[0] * EXP(-EXP(-parms[1] * (4. - parms[2])))
        ;    paramset[66, i] = parms[0] * EXP(-EXP(-parms[1] * (5. - parms[2])))
        ;    paramset[67, i] = parms[0] * EXP(-EXP(-parms[1] * (6. - parms[2])))
        ;    paramset[68, i] = parms[0] * EXP(-EXP(-parms[1] * (7. - parms[2])))
        ;    paramset[69, i] = parms[0] * EXP(-EXP(-parms[1] * (8. - parms[2])))
        ;    paramset[70, i] = parms[0] * EXP(-EXP(-parms[1] * (9. - parms[2])))
        ;    paramset[71, i] = parms[0] * EXP(-EXP(-parms[1] * (10. - parms[2])))
        ;    paramset[72, i] = parms[0] * EXP(-EXP(-parms[1] * (11. - parms[2])))
        ;    paramset[73, i] = parms[0] * EXP(-EXP(-parms[1] * (12. - parms[2])))
        ;    paramset[74, i] = parms[0] * EXP(-EXP(-parms[1] * (13. - parms[2])))
        ;    paramset[75, i] = parms[0] * EXP(-EXP(-parms[1] * (14. - parms[2])))
        ;    paramset[76, i] = parms[0] * EXP(-EXP(-parms[1] * (15. - parms[2])))
        ;    paramset[77, i] = parms[0] * EXP(-EXP(-parms[1] * (16. - parms[2])))
        ;    paramset[78, i] = parms[0] * EXP(-EXP(-parms[1] * (17. - parms[2])))
        ;    paramset[79, i] = parms[0] * EXP(-EXP(-parms[1] * (18. - parms[2])))
        ;    paramset[80, i] = parms[0] * EXP(-EXP(-parms[1] * (19. - parms[2])))
        ;    paramset[81, i] = parms[0] * EXP(-EXP(-parms[1] * (20. - parms[2])))
        
        
        ; 4) Logistic model (3 parameters) - males
        ;startparms = [850.0D, 0.1D, -1.D]
        dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
        ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;pi(0).limits(1) = 2000.
        parms = mpfitfun('Logistic', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        Length_Gro_EstMale = parms[0] * (1.+EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))^(-1.)
        OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
        paramset[48:50, i] = parms
        paramset[53, i] = BESTNORM
        paramset[54, i] = DOF
        paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[54, i]^2.) $
          + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
        paramset[56:58, i] = dparms
        paramset[61, i] = parms[0] * (1.+EXP(-parms[1] * (0.- parms[2])))^(-1.)
        paramset[62, i] = parms[0] * (1.+EXP(-parms[1] * (1.- parms[2])))^(-1.)
        paramset[63, i] = parms[0] * (1.+EXP(-parms[1] * (2.- parms[2])))^(-1.)
        paramset[64, i] = parms[0] * (1.+EXP(-parms[1] * (3.- parms[2])))^(-1.)
        paramset[65, i] = parms[0] * (1.+EXP(-parms[1] * (4.- parms[2])))^(-1.)
        paramset[66, i] = parms[0] * (1.+EXP(-parms[1] * (5.- parms[2])))^(-1.)
        paramset[67, i] = parms[0] * (1.+EXP(-parms[1] * (6.- parms[2])))^(-1.)
        paramset[68, i] = parms[0] * (1.+EXP(-parms[1] * (7.- parms[2])))^(-1.)
        paramset[69, i] = parms[0] * (1.+EXP(-parms[1] * (8.- parms[2])))^(-1.)
        paramset[70, i] = parms[0] * (1.+EXP(-parms[1] * (9.- parms[2])))^(-1.)
        paramset[71, i] = parms[0] * (1.+EXP(-parms[1] * (10.- parms[2])))^(-1.)
        paramset[72, i] = parms[0] * (1.+EXP(-parms[1] * (11.- parms[2])))^(-1.)
        paramset[73, i] = parms[0] * (1.+EXP(-parms[1] * (12.- parms[2])))^(-1.)
        paramset[74, i] = parms[0] * (1.+EXP(-parms[1] * (13.- parms[2])))^(-1.)
        paramset[75, i] = parms[0] * (1.+EXP(-parms[1] * (14.- parms[2])))^(-1.)
        paramset[76, i] = parms[0] * (1.+EXP(-parms[1] * (15.- parms[2])))^(-1.)
        paramset[77, i] = parms[0] * (1.+EXP(-parms[1] * (16.- parms[2])))^(-1.)
        paramset[78, i] = parms[0] * (1.+EXP(-parms[1] * (17.- parms[2])))^(-1.)
        paramset[79, i] = parms[0] * (1.+EXP(-parms[1] * (18.- parms[2])))^(-1.)
        paramset[80, i] = parms[0] * (1.+EXP(-parms[1] * (19.- parms[2])))^(-1.)
        paramset[81, i] = parms[0] * (1.+EXP(-parms[1] * (20.- parms[2])))^(-1.)
        
        
        ;    ; 5) Schnute-Richards model (3 parameters) - males
        ;    ;startparms = [800.0D, 0.4D, -0.15D]
        ;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;    parms = mpfitfun('Schnute_Richards', Age_Gro[MALE], Length_Gro[MALE], dy, DOF=dof, startparms, BESTNORM=bestnorm, MAXITER=MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstMale = parms[0] * (1+parms[1]*EXP(-parms[2] * Age_Gro[MALE]^parms[3]))^(1/parms[4])
        ;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
        ;    paramset[48:52, i] = parms
        ;    paramset[53, i] = BESTNORM
        ;    paramset[54, i] = DOF
        ;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[54, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
        ;    paramset[56:60, i] = dparms
        ;    paramset[61, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 0.^parms[3]))^(1/parms[4])
        ;    paramset[62, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 1.^parms[3]))^(1/parms[4])
        ;    paramset[63, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 2.^parms[3]))^(1/parms[4])
        ;    paramset[64, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 3.^parms[3]))^(1/parms[4])
        ;    paramset[65, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 4.^parms[3]))^(1/parms[4])
        ;    paramset[66, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 5.^parms[3]))^(1/parms[4])
        ;    paramset[67, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 6.^parms[3]))^(1/parms[4])
        ;    paramset[68, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 7.^parms[3]))^(1/parms[4])
        ;    paramset[69, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 8.^parms[3]))^(1/parms[4])
        ;    paramset[70, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 9.^parms[3]))^(1/parms[4])
        ;    paramset[71, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 10.^parms[3]))^(1/parms[4])
        ;    paramset[72, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 11.^parms[3]))^(1/parms[4])
        ;    paramset[73, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 12.^parms[3]))^(1/parms[4])
        ;    paramset[74, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 13.^parms[3]))^(1/parms[4])
        ;    paramset[75, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 14.^parms[3]))^(1/parms[4])
        ;    paramset[76, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 15.^parms[3]))^(1/parms[4])
        ;    paramset[77, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 16.^parms[3]))^(1/parms[4])
        ;    paramset[78, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 17.^parms[3]))^(1/parms[4])
        ;    paramset[79, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 18.^parms[3]))^(1/parms[4])
        ;    paramset[80, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 19.^parms[3]))^(1/parms[4])
        ;    paramset[81, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 20.^parms[3]))^(1/parms[4])
        
        
        ;  ; 6) log-linear model - males
        ;  startparms = [0.D, 0.D]
        ;  dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
        ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
        ;  parms = mpfitfun('logLinear', (Age_Gro[MALE]), Length_Gro[MALE], dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)
        ;  Length_Gro_EstMale = parms[0] * alog(Age_Gro[male]) + parms[1]
        ;  OPLOT, alog(Age_Gro[MALE]), Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
        ;  paramset[16:17, i] = parms
        
        ;  parinfo = replicate({value:0.0, fixed:0, limited:[0,0], limits:[0.0,0.0]}, 3)
        ;  parinfo[0].limited[1] = 0; parameter 0, the amplitude, has a lower bound
        ;  parinfo[0].limits[1] = 2000.0; do not accept values less than zero
        ;  parinfo[0].fixed = 0
        ;  parinfo[0].value = 600.
        ;  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, perror = dparms, yfit=yfit, PARINFO=parinfo)
      ENDIF
      
      
      IF FEMALECOUNT GT 0 THEN BEGIN
        paramset[82, i] = NumageclassF
        paramset[83, i] = MaxageclassF
        paramset[84, i] = MinageclassF
        paramset[85, i] = MAX(Length_Gro[FEMALE])
        paramset[86, i] = MIN(Length_Gro[FEMALE])
        
        ;    ; 1) standard von Bertalanffy model - females
        ;    ;startparms = [850.0D, 0.1D, -1.D]
        ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;
        ;    parms = mpfitfun('vonBertalanffy', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, $
        ;    MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstFemale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])));^WLslope
        ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
        ;    paramset[87:89, i] = parms
        ;    paramset[92, i] = BESTNORM
        ;    paramset[93, i] = DOF
        ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[50, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
        ;    paramset[95:97, i] = dparms
        ;    paramset[100, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
        ;    paramset[101, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
        ;    paramset[102, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
        ;    paramset[103, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
        ;    paramset[104, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
        ;    paramset[105, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
        ;    paramset[106, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
        ;    paramset[107, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
        ;    paramset[108, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
        ;    paramset[109, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
        ;    paramset[110, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
        ;    paramset[111, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
        ;    paramset[112, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
        ;    paramset[113, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
        ;    paramset[114, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
        ;    paramset[115, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
        ;    paramset[116, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
        ;    paramset[117, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
        ;    paramset[118, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
        ;    paramset[119, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
        ;    paramset[120, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
        
        ;
        ;    ; 2) generalized von Bertalanffy model - females
        ;    ;startparms = [850.0D, 0.1D, -1.D]
        ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;    parms = mpfitfun('GvonBertalanffy', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm $
        ;    , MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstFemale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))^parms[3];^WLslope
        ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
        ;    paramset[87:90, i] = parms
        ;    paramset[92, i] = BESTNORM
        ;    paramset[93, i] = DOF
        ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[50, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
        ;    paramset[95:98, i] = dparms
        ;    paramset[100, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))^parms[3]
        ;    paramset[101, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))^parms[3]
        ;    paramset[102, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))^parms[3]
        ;    paramset[103, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))^parms[3]
        ;    paramset[104, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))^parms[3]
        ;    paramset[105, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))^parms[3]
        ;    paramset[106, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))^parms[3]
        ;    paramset[107, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))^parms[3]
        ;    paramset[108, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))^parms[3]
        ;    paramset[109, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))^parms[3]
        ;    paramset[110, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))^parms[3]
        ;    paramset[111, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))^parms[3]
        ;    paramset[112, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))^parms[3]
        ;    paramset[113, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))^parms[3]
        ;    paramset[114, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))^parms[3]
        ;    paramset[115, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))^parms[3]
        ;    paramset[116, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))^parms[3]
        ;    paramset[117, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))^parms[3]
        ;    paramset[118, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))^parms[3]
        ;    paramset[119, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))^parms[3]
        ;    paramset[120, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))^parms[3]
        
        
        ;    ; 3) Gompertz model - females
        ;    ;startparms = [850.0D, 0.1D, -1.D]
        ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;    parms = mpfitfun('Gompertz', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm $
        ;    , MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstFemale = parms[0] * EXP(-EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))
        ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
        ;    paramset[87:89, i] = parms
        ;    paramset[92, i] = BESTNORM
        ;    paramset[93, i] = DOF
        ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[50, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
        ;    paramset[95:97, i] = dparms
        ;    paramset[100, i] = parms[0] * EXP(-EXP(-parms[1] * (0. - parms[2])))
        ;    paramset[101, i] = parms[0] * EXP(-EXP(-parms[1] * (1. - parms[2])))
        ;    paramset[102, i] = parms[0] * EXP(-EXP(-parms[1] * (2. - parms[2])))
        ;    paramset[103, i] = parms[0] * EXP(-EXP(-parms[1] * (3. - parms[2])))
        ;    paramset[104, i] = parms[0] * EXP(-EXP(-parms[1] * (4. - parms[2])))
        ;    paramset[105, i] = parms[0] * EXP(-EXP(-parms[1] * (5. - parms[2])))
        ;    paramset[106, i] = parms[0] * EXP(-EXP(-parms[1] * (6. - parms[2])))
        ;    paramset[107, i] = parms[0] * EXP(-EXP(-parms[1] * (7. - parms[2])))
        ;    paramset[108, i] = parms[0] * EXP(-EXP(-parms[1] * (8. - parms[2])))
        ;    paramset[109, i] = parms[0] * EXP(-EXP(-parms[1] * (9. - parms[2])))
        ;    paramset[110, i] = parms[0] * EXP(-EXP(-parms[1] * (10. - parms[2])))
        ;    paramset[111, i] = parms[0] * EXP(-EXP(-parms[1] * (11. - parms[2])))
        ;    paramset[112, i] = parms[0] * EXP(-EXP(-parms[1] * (12. - parms[2])))
        ;    paramset[113, i] = parms[0] * EXP(-EXP(-parms[1] * (13. - parms[2])))
        ;    paramset[114, i] = parms[0] * EXP(-EXP(-parms[1] * (14. - parms[2])))
        ;    paramset[115, i] = parms[0] * EXP(-EXP(-parms[1] * (15. - parms[2])))
        ;    paramset[116, i] = parms[0] * EXP(-EXP(-parms[1] * (16. - parms[2])))
        ;    paramset[117, i] = parms[0] * EXP(-EXP(-parms[1] * (17. - parms[2])))
        ;    paramset[118, i] = parms[0] * EXP(-EXP(-parms[1] * (18. - parms[2])))
        ;    paramset[119, i] = parms[0] * EXP(-EXP(-parms[1] * (19. - parms[2])))
        ;    paramset[120, i] = parms[0] * EXP(-EXP(-parms[1] * (20. - parms[2])))
        
        
        ; 4) Logistic model - females
        ;startparms = [850.0D, 0.1D, -1.D]
        dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
        ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;pi(0).limits(1) = 2000.
        parms = mpfitfun('Logistic', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, DOF=dof, startparms,  BESTNORM=bestnorm, MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        Length_Gro_EstFemale = parms[0] * (1.+EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))^(-1.)
        OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
        paramset[87:89, i] = parms
        paramset[92, i] = BESTNORM
        paramset[93, i] = DOF
        paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[50, i]^2.) $
          + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
        paramset[95:97, i] = dparms
        paramset[100, i] = parms[0] * (1.+EXP(-parms[1] * (0. - parms[2])))^(-1.)
        paramset[101, i] = parms[0] * (1.+EXP(-parms[1] * (1. - parms[2])))^(-1.)
        paramset[102, i] = parms[0] * (1.+EXP(-parms[1] * (2. - parms[2])))^(-1.)
        paramset[103, i] = parms[0] * (1.+EXP(-parms[1] * (3. - parms[2])))^(-1.)
        paramset[104, i] = parms[0] * (1.+EXP(-parms[1] * (4. - parms[2])))^(-1.)
        paramset[105, i] = parms[0] * (1.+EXP(-parms[1] * (5. - parms[2])))^(-1.)
        paramset[106, i] = parms[0] * (1.+EXP(-parms[1] * (6. - parms[2])))^(-1.)
        paramset[107, i] = parms[0] * (1.+EXP(-parms[1] * (7. - parms[2])))^(-1.)
        paramset[108, i] = parms[0] * (1.+EXP(-parms[1] * (8. - parms[2])))^(-1.)
        paramset[109, i] = parms[0] * (1.+EXP(-parms[1] * (9. - parms[2])))^(-1.)
        paramset[110, i] = parms[0] * (1.+EXP(-parms[1] * (10. - parms[2])))^(-1.)
        paramset[111, i] = parms[0] * (1.+EXP(-parms[1] * (11. - parms[2])))^(-1.)
        paramset[112, i] = parms[0] * (1.+EXP(-parms[1] * (12. - parms[2])))^(-1.)
        paramset[113, i] = parms[0] * (1.+EXP(-parms[1] * (13. - parms[2])))^(-1.)
        paramset[114, i] = parms[0] * (1.+EXP(-parms[1] * (14. - parms[2])))^(-1.)
        paramset[115, i] = parms[0] * (1.+EXP(-parms[1] * (15. - parms[2])))^(-1.)
        paramset[116, i] = parms[0] * (1.+EXP(-parms[1] * (16. - parms[2])))^(-1.)
        paramset[117, i] = parms[0] * (1.+EXP(-parms[1] * (17. - parms[2])))^(-1.)
        paramset[118, i] = parms[0] * (1.+EXP(-parms[1] * (18. - parms[2])))^(-1.)
        paramset[119, i] = parms[0] * (1.+EXP(-parms[1] * (19. - parms[2])))^(-1.)
        paramset[120, i] = parms[0] * (1.+EXP(-parms[1] * (20. - parms[2])))^(-1.)
        
        
        ;    ; 5) Schnute-Richards model - females
        ;    ;startparms = [800.0D, 0.4D, -0.15D]
        ;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
        ;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
        ;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
        ;    ;pi(0).limits(1) = 2000.
        ;    parms = mpfitfun('Schnute_Richards', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, DOF=dof, startparms, BESTNORM=bestnorm, MAXITER=MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
        ;    Length_Gro_EstFemale = parms[0] * (1+parms[1]*EXP(-parms[2] * Age_Gro[FEMALE]^parms[3]))^(1/parms[4])
        ;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
        ;    paramset[87:91, i] = parms
        ;    paramset[92, i] = BESTNORM
        ;    paramset[93, i] = DOF
        ;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[50, i]^2.) $
        ;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
        ;    paramset[95:99, i] = dparms
        ;    paramset[100, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 0.^parms[3]))^(1/parms[4])
        ;    paramset[101, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 1.^parms[3]))^(1/parms[4])
        ;    paramset[102, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 2.^parms[3]))^(1/parms[4])
        ;    paramset[103, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 3.^parms[3]))^(1/parms[4])
        ;    paramset[104, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 4.^parms[3]))^(1/parms[4])
        ;    paramset[105, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 5.^parms[3]))^(1/parms[4])
        ;    paramset[106, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 6.^parms[3]))^(1/parms[4])
        ;    paramset[107, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 7.^parms[3]))^(1/parms[4])
        ;    paramset[108, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 8.^parms[3]))^(1/parms[4])
        ;    paramset[109, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 9.^parms[3]))^(1/parms[4])
        ;    paramset[110, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 10.^parms[3]))^(1/parms[4])
        ;    paramset[111, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 11.^parms[3]))^(1/parms[4])
        ;    paramset[112, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 12.^parms[3]))^(1/parms[4])
        ;    paramset[113, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 13.^parms[3]))^(1/parms[4])
        ;    paramset[114, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 14.^parms[3]))^(1/parms[4])
        ;    paramset[115, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 15.^parms[3]))^(1/parms[4])
        ;    paramset[116, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 16.^parms[3]))^(1/parms[4])
        ;    paramset[117, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 17.^parms[3]))^(1/parms[4])
        ;    paramset[118, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 18.^parms[3]))^(1/parms[4])
        ;    paramset[119, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 19.^parms[3]))^(1/parms[4])
        ;    paramset[120, i] = parms[0] * (1+parms[1]*EXP(-parms[2] * 20.^parms[3]))^(1/parms[4])
        
        
        ;; 6) log-linear model -females
        ;  startparms = [0.D, 1.D]
        ;  dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
        ;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 2)
        ;  parms = mpfitfun('logLinear', (Age_Gro[feMALE]), Length_Gro[feMALE], dy, startparms, perror = dparms, yfit=yfit, PARINFO=pi)
        ;  Length_Gro_EstfeMale = parms[0] * alog(Age_Gro[female]) + parms[1]
        ;  OPLOT, alog(Age_Gro[FEMALE]), Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
        ;  paramset[23:27, i] = parms
        
        
      ENDIF
    ENDIF
    
    WRITE_PNG, filename, TVRD()
    
    ; store parameter values
    ;Linf[i] = Linf_gro
    ;K[i] = K_gro2
    ;t0[i] = t0_gro
  ENDFOR
  
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
  
  Data = paramset
  
  filename1 = 'Output_Walleye_Growth.csv'
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
  print, NWBIC_growthGEmincount, NWBIC_growth[*, NWBIC_growthGEmin]
  
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
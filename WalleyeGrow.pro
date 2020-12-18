PRO WalleyeGrow
; this function parameterize somatic growth models for walleye stocks in Wisconsin

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
paramset = FLTARR(156L, N_ELEMENTS(uniqWBIC_Year)); an array for growth model parameters
WAE_size_age = FLTARR(409L, N_ELEMENTS(uniqWBIC_Year)+1L); an array for mean size-at-age 
WAE_size_age_all = FLTARR(198, max(SurveyYear2)-min(SurveyYear2)+1L)
;WAE_size_age_all = FLTARR(198, 40)
year = indgen(max(SurveyYear2)-min(SurveyYear2)+1L)+min(SurveyYear2)

; Pooling by YEAR
For i = 0L, max(SurveyYear2)-min(SurveyYear2) do begin
  INDEX_growthdata_ALL = WHERE(SurveyYear2[*] EQ year[i], INDEX_growthdata_allcount)
  ;INDEX_growthdata = WHERE(WBIC_Year2[*] EQ uniqWBIC_Year[i], INDEX_growthdatacount)
  
  uniqWBICperYear = WBIC[INDEX_growthdata_ALL[UNIQ(WBIC[INDEX_growthdata_ALL], SORT(WBIC[INDEX_growthdata_ALL]))]]
  PRINT, uniqWBICperYear

  WAE_size_age[0, i] = SurveyYear[INDEX_growthdata_ALL[0]]; year
  WAE_size_age[1, i] = N_ELEMENTS(uniqWBICperYear); the number of lakes sampled
  WAE_size_age[2, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL]); total number of fish samples
  
  
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
         
             ; age infomation for males
              IF malecouNt gt 0 then begin
                NumageclassM = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL[male]]), SORT(FIX(AGE[INDEX_growthdata_ALL[male]]), /L64)))
                MaxageclassM = Max(AGE[INDEX_growthdata_ALL[male]])
                MinageclassM = Min(AGE[INDEX_growthdata_ALL[male]])
              endif
              ; age information for females
              if femalecount gt 0 then begin
                NumageclassF = N_ELEMENTS(UNIQ(FIX(AGE[INDEX_growthdata_ALL[female]]), SORT(FIX(AGE[INDEX_growthdata_ALL[female]]), /L64)))
                MaxageclassF = Max(AGE[INDEX_growthdata_ALL[female]])
                MinageclassF = Min(AGE[INDEX_growthdata_ALL[female]])
              endif
              
              paramset[0, i] = uniqWBIC_Year[i]
              paramset[1, i] = N_ELEMENTS(Length_Gro)
              paramset[2, i] = WBIC2[INDEX_growthdata_ALL[0]]
              paramset[3, i] = SurveyYear2[INDEX_growthdata_ALL[0]]
          ;PRINT, 'Observed length', Length_Gro
          ;PRINT, 'Observed age', Age_Gro
      
;          ; Length group distributions
;            SizeLT100 = WHERE(Length_Gro LT 100, SizeLT100count)
;            Size100to120 = WHERE((Length_Gro GE 100) AND (Length_Gro LT 120), Size100to120count)
;            Size120to140 = WHERE((Length_Gro GE 120) AND (Length_Gro LT 140), Size120to140count)
;            Size140to160 = WHERE((Length_Gro GE 140) AND (Length_Gro LT 160), Size140to160count)
;            Size160to180 = WHERE((Length_Gro GE 160) AND (Length_Gro LT 180), Size160to180count)
;            Size180to200 = WHERE((Length_Gro GE 180) AND (Length_Gro LT 200), Size180to200count)
;            Size200to220 = WHERE((Length_Gro GE 200) AND (Length_Gro LT 220), Size200to220count)
;            Size220to240 = WHERE((Length_Gro GE 220) AND (Length_Gro LT 240), Size220to240count)
;            Size240to260 = WHERE((Length_Gro GE 240) AND (Length_Gro LT 260), Size240to260count)
;            Size260to280 = WHERE((Length_Gro GE 260) AND (Length_Gro LT 280), Size260to280count)
;            Size280to300 = WHERE((Length_Gro GE 280) AND (Length_Gro LT 300), Size280to300count)
;            Size300to320 = WHERE((Length_Gro GE 300) AND (Length_Gro LT 320), Size300to320count)
;            Size320to340 = WHERE((Length_Gro GE 320) AND (Length_Gro LT 340), Size320to340count)
;            Size340to360 = WHERE((Length_Gro GE 340) AND (Length_Gro LT 360), Size340to360count)
;            Size360to380 = WHERE((Length_Gro GE 360) AND (Length_Gro LT 380), Size360to380count)
;            Size380to400 = WHERE((Length_Gro GE 380) AND (Length_Gro LT 400), Size380to400count)
;            Size400to420 = WHERE((Length_Gro GE 400) AND (Length_Gro LT 420), Size400to420count)
;            Size420to440 = WHERE((Length_Gro GE 420) AND (Length_Gro LT 440), Size420to440count)
;            Size440to460 = WHERE((Length_Gro GE 440) AND (Length_Gro LT 460), Size440to460count)
;            Size460to480 = WHERE((Length_Gro GE 460) AND (Length_Gro LT 480), Size460to480count)
;            Size480to500 = WHERE((Length_Gro GE 480) AND (Length_Gro LT 500), Size480to500count)
;            Size500to520 = WHERE((Length_Gro GE 500) AND (Length_Gro LT 520), Size500to520count)
;            Size520to540 = WHERE((Length_Gro GE 520) AND (Length_Gro LT 540), Size520to540count)
;            Size540to560 = WHERE((Length_Gro GE 540) AND (Length_Gro LT 560), Size540to560count)
;            Size560to580 = WHERE((Length_Gro GE 560) AND (Length_Gro LT 580), Size560to580count)
;            Size580to600 = WHERE((Length_Gro GE 580) AND (Length_Gro LT 600), Size580to600count)
;            Size600to620 = WHERE((Length_Gro GE 600) AND (Length_Gro LT 620), Size600to620count)
;            Size620to640 = WHERE((Length_Gro GE 620) AND (Length_Gro LT 640), Size620to640count)
;            Size640to660 = WHERE((Length_Gro GE 640) AND (Length_Gro LT 660), Size640to660count)
;            Size660to680 = WHERE((Length_Gro GE 660) AND (Length_Gro LT 680), Size660to680count)
;            Size680to700 = WHERE((Length_Gro GE 680) AND (Length_Gro LT 700), Size680to700count)
;            Size700to720 = WHERE((Length_Gro GE 700) AND (Length_Gro LT 720), Size700to720count)
;            Size720to740 = WHERE((Length_Gro GE 720) AND (Length_Gro LT 740), Size720to740count)
;            Size740to760 = WHERE((Length_Gro GE 740) AND (Length_Gro LT 760), Size740to760count)
;            Size760to780 = WHERE((Length_Gro GE 760) AND (Length_Gro LT 780), Size760to780count)
;            Size780to800 = WHERE((Length_Gro GE 780) AND (Length_Gro LT 800), Size780to800count)
;       
;            IF Size100to120count GT 0 THEN paramset[121, i] = Size100to120count
;            IF Size120to140count GT 0 THEN paramset[122, i] = Size120to140count
;            IF Size140to160count GT 0 THEN paramset[123, i] = Size140to160count
;            IF Size160to180count GT 0 THEN paramset[124, i] = Size160to180count
;            IF Size180to200count GT 0 THEN paramset[125, i] = Size180to200count
;            IF Size200to220count GT 0 THEN paramset[126, i] = Size200to220count
;            IF Size220to240count GT 0 THEN paramset[127, i] = Size220to240count
;            IF Size240to260count GT 0 THEN paramset[128, i] = Size240to260count
;            IF Size260to280count GT 0 THEN paramset[129, i] = Size260to280count
;            IF Size280to300count GT 0 THEN paramset[130, i] = Size280to300count
;            IF Size300to320count GT 0 THEN paramset[131, i] = Size300to320count
;            IF Size320to340count GT 0 THEN paramset[132, i] = Size320to340count
;            IF Size340to360count GT 0 THEN paramset[133, i] = Size340to360count
;            IF Size360to380count GT 0 THEN paramset[134, i] = Size360to380count
;            IF Size380to400count GT 0 THEN paramset[135, i] = Size380to400count
;            IF Size400to420count GT 0 THEN paramset[136, i] = Size400to420count
;            IF Size420to440count GT 0 THEN paramset[137, i] = Size420to440count
;            IF Size440to460count GT 0 THEN paramset[138, i] = Size440to460count
;            IF Size460to480count GT 0 THEN paramset[139, i] = Size460to480count
;            IF Size480to500count GT 0 THEN paramset[140, i] = Size480to500count
;            IF Size500to520count GT 0 THEN paramset[141, i] = Size500to520count
;            IF Size520to540count GT 0 THEN paramset[142, i] = Size520to540count
;            IF Size540to560count GT 0 THEN paramset[143, i] = Size540to560count
;            IF Size560to580count GT 0 THEN paramset[144, i] = Size560to580count
;            IF Size580to600count GT 0 THEN paramset[145, i] = Size580to600count
;            IF Size600to620count GT 0 THEN paramset[146, i] = Size600to620count
;            IF Size620to640count GT 0 THEN paramset[147, i] = Size620to640count
;            IF Size640to660count GT 0 THEN paramset[148, i] = Size640to660count
;            IF Size660to680count GT 0 THEN paramset[149, i] = Size660to680count
;            IF Size680to700count GT 0 THEN paramset[150, i] = Size680to700count
;            IF Size700to720count GT 0 THEN paramset[151, i] = Size700to720count           
;            IF Size720to740count GT 0 THEN paramset[152, i] = Size720to740count
;            IF Size740to760count GT 0 THEN paramset[153, i] = Size740to760count
;            IF Size760to780count GT 0 THEN paramset[154, i] = Size760to780count
;            IF Size780to800count GT 0 THEN paramset[155, i] = Size780to800count
;          
;          
;            ; Mean length-at-age 
; ; All
;age0 = WHERE((AGE[INDEX_growthdata_ALL] EQ 0), Age0count)
;age1 = WHERE((AGE[INDEX_growthdata_ALL] EQ 1), Age1count)
;age2 = WHERE((AGE[INDEX_growthdata_ALL] EQ 2), AGE2count)
;age3 = WHERE((AGE[INDEX_growthdata_ALL] EQ 3), AGE3count)
;age4 = WHERE((AGE[INDEX_growthdata_ALL] EQ 4), AGE4count)
;age5 = WHERE((AGE[INDEX_growthdata_ALL] EQ 5), AGE5count)
;age6 = WHERE((AGE[INDEX_growthdata_ALL] EQ 6), AGE6count)
;age7 = WHERE((AGE[INDEX_growthdata_ALL] EQ 7), AGE7count)
;age8 = WHERE((AGE[INDEX_growthdata_ALL] EQ 8), AGE8count)
;age9 = WHERE((AGE[INDEX_growthdata_ALL] EQ 9), AGE9count)
;age10 = WHERE((AGE[INDEX_growthdata_ALL] EQ 10), AGE10count)
;age11 = WHERE((AGE[INDEX_growthdata_ALL] EQ 11), AGE11count)
;AGE12 = WHERE((AGE[INDEX_growthdata_ALL] EQ 12), AGE12COUNT)
;AGE13 = WHERE((AGE[INDEX_growthdata_ALL] EQ 13), AGE13COUNT)
;AGE14 = WHERE((AGE[INDEX_growthdata_ALL] EQ 14), AGE14COUNT)
;AGE15 = WHERE((AGE[INDEX_growthdata_ALL] EQ 15), AGE15COUNT)
;age16 = WHERE((AGE[INDEX_growthdata_ALL] EQ 16), Age16count)
;age17 = WHERE((AGE[INDEX_growthdata_ALL] EQ 17), AGE17count)
;age18 = WHERE((AGE[INDEX_growthdata_ALL] EQ 18), AGE18count)
;age19 = WHERE((AGE[INDEX_growthdata_ALL] EQ 19), AGE19count)
;age20 = WHERE((AGE[INDEX_growthdata_ALL] EQ 20), AGE20count)
;age21 = WHERE((AGE[INDEX_growthdata_ALL] EQ 21), AGE21count)
;age22 = WHERE((AGE[INDEX_growthdata_ALL] EQ 22), AGE22count)
;age23 = WHERE((AGE[INDEX_growthdata_ALL] EQ 23), AGE23count)
;age24 = WHERE((AGE[INDEX_growthdata_ALL] EQ 24), AGE24count)
;age25 = WHERE((AGE[INDEX_growthdata_ALL] EQ 25), AGE25count)
;age26 = WHERE((AGE[INDEX_growthdata_ALL] EQ 26), AGE26count)
;
;; Male
;age0M = WHERE((AGE[INDEX_growthdata_ALL] EQ 0) AND (SEX[INDEX_growthdata_ALL] EQ 0), Age0Mcount)
;age1M = WHERE((AGE[INDEX_growthdata_ALL] EQ 1) AND (SEX[INDEX_growthdata_ALL] EQ 0), Age1Mcount)
;age2M = WHERE((AGE[INDEX_growthdata_ALL] EQ 2) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE2Mcount)
;age3M = WHERE((AGE[INDEX_growthdata_ALL] EQ 3) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE3Mcount)
;age4M = WHERE((AGE[INDEX_growthdata_ALL] EQ 4) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE4Mcount)
;age5M = WHERE((AGE[INDEX_growthdata_ALL] EQ 5) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE5Mcount)
;age6M = WHERE((AGE[INDEX_growthdata_ALL] EQ 6) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE6Mcount)
;age7M = WHERE((AGE[INDEX_growthdata_ALL] EQ 7) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE7Mcount)
;age8M = WHERE((AGE[INDEX_growthdata_ALL] EQ 8) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE8Mcount)
;age9M = WHERE((AGE[INDEX_growthdata_ALL] EQ 9) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE9Mcount)
;age10M = WHERE((AGE[INDEX_growthdata_ALL] EQ 10) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE10Mcount)
;age11M = WHERE((AGE[INDEX_growthdata_ALL] EQ 11) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE11Mcount)
;age12M = WHERE((AGE[INDEX_growthdata_ALL] EQ 12) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE12Mcount)
;age13M = WHERE((AGE[INDEX_growthdata_ALL] EQ 13) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE13Mcount)
;age14M = WHERE((AGE[INDEX_growthdata_ALL] EQ 14) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE14Mcount)
;age15M = WHERE((AGE[INDEX_growthdata_ALL] EQ 15) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE15Mcount)
;age16M = WHERE((AGE[INDEX_growthdata_ALL] EQ 16) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE16Mcount)
;age17M = WHERE((AGE[INDEX_growthdata_ALL] EQ 17) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE17Mcount)
;age18M = WHERE((AGE[INDEX_growthdata_ALL] EQ 18) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE18Mcount)
;age19M = WHERE((AGE[INDEX_growthdata_ALL] EQ 19) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE19Mcount)
;age20M = WHERE((AGE[INDEX_growthdata_ALL] EQ 20) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE20Mcount)
;age21M = WHERE((AGE[INDEX_growthdata_ALL] EQ 21) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE21Mcount)
;age22M = WHERE((AGE[INDEX_growthdata_ALL] EQ 22) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE22Mcount)
;age23M = WHERE((AGE[INDEX_growthdata_ALL] EQ 23) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE23Mcount)
;age24M = WHERE((AGE[INDEX_growthdata_ALL] EQ 24) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE24Mcount)
;age25M = WHERE((AGE[INDEX_growthdata_ALL] EQ 25) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE25Mcount)
;age26M = WHERE((AGE[INDEX_growthdata_ALL] EQ 26) AND (SEX[INDEX_growthdata_ALL] EQ 0), AGE26Mcount)
;
;; Female
;age0F = WHERE((AGE[INDEX_growthdata_ALL] EQ 0) AND (SEX[INDEX_growthdata_ALL] EQ 1), Age0Fcount)
;age1F = WHERE((AGE[INDEX_growthdata_ALL] EQ 1) AND (SEX[INDEX_growthdata_ALL] EQ 1), Age1Fcount)
;age2F = WHERE((AGE[INDEX_growthdata_ALL] EQ 2) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE2Fcount)
;age3F = WHERE((AGE[INDEX_growthdata_ALL] EQ 3) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE3Fcount)
;age4F = WHERE((AGE[INDEX_growthdata_ALL] EQ 4) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE4Fcount)
;age5F = WHERE((AGE[INDEX_growthdata_ALL] EQ 5) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE5Fcount)
;age6F = WHERE((AGE[INDEX_growthdata_ALL] EQ 6) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE6Fcount)
;age7F = WHERE((AGE[INDEX_growthdata_ALL] EQ 7) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE7Fcount)
;age8F = WHERE((AGE[INDEX_growthdata_ALL] EQ 8) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE8Fcount)
;age9F = WHERE((AGE[INDEX_growthdata_ALL] EQ 9) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE9Fcount)
;age10F = WHERE((AGE[INDEX_growthdata_ALL] EQ 10) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE10Fcount)
;age11F = WHERE((AGE[INDEX_growthdata_ALL] EQ 11) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE11Fcount)
;age12F = WHERE((AGE[INDEX_growthdata_ALL] EQ 12) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE12Fcount)
;age13F = WHERE((AGE[INDEX_growthdata_ALL] EQ 13) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE13Fcount)
;age14F = WHERE((AGE[INDEX_growthdata_ALL] EQ 12) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE14Fcount)
;age15F = WHERE((AGE[INDEX_growthdata_ALL] EQ 13) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE15Fcount)
;age16F = WHERE((AGE[INDEX_growthdata_ALL] EQ 16) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE16Fcount)
;age17F = WHERE((AGE[INDEX_growthdata_ALL] EQ 17) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE17Fcount)
;age18F = WHERE((AGE[INDEX_growthdata_ALL] EQ 18) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE18Fcount)
;age19F = WHERE((AGE[INDEX_growthdata_ALL] EQ 19) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE19Fcount)
;age20F = WHERE((AGE[INDEX_growthdata_ALL] EQ 20) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE20Fcount)
;age21F = WHERE((AGE[INDEX_growthdata_ALL] EQ 21) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE21Fcount)
;age22F = WHERE((AGE[INDEX_growthdata_ALL] EQ 22) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE22Fcount)
;age23F = WHERE((AGE[INDEX_growthdata_ALL] EQ 23) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE23Fcount)
;age24F = WHERE((AGE[INDEX_growthdata_ALL] EQ 24) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE24Fcount)
;age25F = WHERE((AGE[INDEX_growthdata_ALL] EQ 25) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE25Fcount)
;age26F = WHERE((AGE[INDEX_growthdata_ALL] EQ 26) AND (SEX[INDEX_growthdata_ALL] EQ 1), AGE26Fcount)
;
;
;
;;all
;IF Age0count GT 0. THEN BEGIN
;  WAE_size_age[3, i] = MEAN(Length[INDEX_growthdata_ALL[age0]])
;  WAE_size_age[4, i] = STDDEV(Length[INDEX_growthdata_ALL[age]])
;  WAE_size_age[5, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age0]])
;  WAE_size_age[6, i] = MAX(Length[INDEX_growthdata_ALL[age0]])
;  WAE_size_age[7, i] = MIN(Length[INDEX_growthdata_ALL[age0]])
;ENDIF
;IF Age1count GT 0. THEN BEGIN
;  WAE_size_age[8, i] = MEAN(Length[INDEX_growthdata_ALL[age1]])
;  WAE_size_age[9, i] = STDDEV(Length[INDEX_growthdata_ALL[age1]])
;  WAE_size_age[10, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age1]])
;  WAE_size_age[11, i] = MAX(Length[INDEX_growthdata_ALL[age1]])
;  WAE_size_age[12, i] = MIN(Length[INDEX_growthdata_ALL[age1]])
;ENDIF
;IF Age2count GT 0. THEN BEGIN
;  WAE_size_age[13, i] = MEAN(Length[INDEX_growthdata_ALL[age2]])
;  WAE_size_age[14, i] = STDDEV(Length[INDEX_growthdata_ALL[age2]])
;  WAE_size_age[15, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age2]])
;  WAE_size_age[16, i] = MAX(Length[INDEX_growthdata_ALL[age2]])
;  WAE_size_age[17, i] = MIN(Length[INDEX_growthdata_ALL[age2]])
;ENDIF
;IF Age3count GT 0. THEN BEGIN
;  WAE_size_age[18, i] = MEAN(Length[INDEX_growthdata_ALL[age3]])
;  WAE_size_age[19, i] = STDDEV(Length[INDEX_growthdata_ALL[age3]])
;  WAE_size_age[20, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age4]])
;  WAE_size_age[21, i] = MAX(Length[INDEX_growthdata_ALL[age3]])
;  WAE_size_age[22, i] = MIN(Length[INDEX_growthdata_ALL[age3]])
;ENDIF
;IF Age4count GT 0. THEN BEGIN
;  WAE_size_age[23, i] = MEAN(Length[INDEX_growthdata_ALL[age4]])
;  WAE_size_age[24, i] = STDDEV(Length[INDEX_growthdata_ALL[age4]])
;  WAE_size_age[25, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age4]])
;  WAE_size_age[26, i] = MAX(Length[INDEX_growthdata_ALL[age4]])
;  WAE_size_age[27, i] = MIN(Length[INDEX_growthdata_ALL[age4]])
;ENDIF
;IF Age5count GT 0. THEN BEGIN
;  WAE_size_age[28, i] = MEAN(Length[INDEX_growthdata_ALL[age5]])
;  WAE_size_age[29, i] = STDDEV(Length[INDEX_growthdata_ALL[age5]])
;  WAE_size_age[30, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age5]])
;  WAE_size_age[31, i] = MAX(Length[INDEX_growthdata_ALL[age5]])
;  WAE_size_age[32, i] = MIN(Length[INDEX_growthdata_ALL[age5]])
;ENDIF
;IF Age6count GT 0. THEN BEGIN
;  WAE_size_age[33, i] = MEAN(Length[INDEX_growthdata_ALL[age6]])
;  WAE_size_age[34, i] = STDDEV(Length[INDEX_growthdata_ALL[age6]])
;  WAE_size_age[35, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age6]])
;  WAE_size_age[36, i] = MAX(Length[INDEX_growthdata_ALL[age6]])
;  WAE_size_age[37, i] = MIN(Length[INDEX_growthdata_ALL[age6]])
;ENDIF
;IF Age7count GT 0. THEN BEGIN
;  WAE_size_age[38, i] = MEAN(Length[INDEX_growthdata_ALL[age7]])
;  WAE_size_age[39, i] = STDDEV(Length[INDEX_growthdata_ALL[age7]])
;  WAE_size_age[40, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age7]])
;  WAE_size_age[41, i] = MAX(Length[INDEX_growthdata_ALL[age7]])
;  WAE_size_age[42, i] = MIN(Length[INDEX_growthdata_ALL[age7]])
;ENDIF
;IF Age8count GT 0. THEN BEGIN
;  WAE_size_age[43, i] = MEAN(Length[INDEX_growthdata_ALL[age8]])
;  WAE_size_age[44, i] = STDDEV(Length[INDEX_growthdata_ALL[age8]])
;  WAE_size_age[45, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age8]])
;  WAE_size_age[46, i] = MAX(Length[INDEX_growthdata_ALL[age8]])
;  WAE_size_age[47, i] = MIN(Length[INDEX_growthdata_ALL[age8]])
;ENDIF
;IF Age9count GT 0. THEN BEGIN
;  WAE_size_age[48, i] = MEAN(Length[INDEX_growthdata_ALL[age9]])
;  WAE_size_age[49, i] = STDDEV(Length[INDEX_growthdata_ALL[age9]])
;  WAE_size_age[50, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age9]])
;  WAE_size_age[51, i] = MAX(Length[INDEX_growthdata_ALL[age9]])
;  WAE_size_age[52, i] = MIN(Length[INDEX_growthdata_ALL[age9]])
;ENDIF
;IF Age10count GT 0. THEN BEGIN
;  WAE_size_age[53, i] = MEAN(Length[INDEX_growthdata_ALL[age10]])
;  WAE_size_age[54, i] = STDDEV(Length[INDEX_growthdata_ALL[age10]])
;  WAE_size_age[55, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age10]])
;  WAE_size_age[56, i] = MAX(Length[INDEX_growthdata_ALL[age10]])
;  WAE_size_age[57, i] = MIN(Length[INDEX_growthdata_ALL[age10]])
;ENDIF
;IF Age11count GT 0. THEN BEGIN
;  WAE_size_age[58, i] = MEAN(Length[INDEX_growthdata_ALL[age11]])
;  WAE_size_age[59, i] = STDDEV(Length[INDEX_growthdata_ALL[age11]])
;  WAE_size_age[60, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age11]])
;  WAE_size_age[61, i] = MAX(Length[INDEX_growthdata_ALL[age11]])
;  WAE_size_age[62, i] = MIN(Length[INDEX_growthdata_ALL[age11]])
;ENDIF
;IF Age12count GT 0. THEN BEGIN
;  WAE_size_age[63, i] = MEAN(Length[INDEX_growthdata_ALL[age12]])
;  WAE_size_age[64, i] = STDDEV(Length[INDEX_growthdata_ALL[age12]])
;  WAE_size_age[65, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age12]])
;  WAE_size_age[66, i] = MAX(Length[INDEX_growthdata_ALL[age12]])
;  WAE_size_age[67, i] = MIN(Length[INDEX_growthdata_ALL[age12]])
;ENDIF
;IF Age13count GT 0. THEN BEGIN
;  WAE_size_age[68, i] = MEAN(Length[INDEX_growthdata_ALL[age13]])
;  WAE_size_age[69, i] = STDDEV(Length[INDEX_growthdata_ALL[age13]])
;  WAE_size_age[70, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age13]])
;  WAE_size_age[71, i] = MAX(Length[INDEX_growthdata_ALL[age13]])
;  WAE_size_age[72, i] = MIN(Length[INDEX_growthdata_ALL[age13]])
;ENDIF
;IF Age14count GT 0. THEN BEGIN
;  WAE_size_age[73, i] = MEAN(Length[INDEX_growthdata_ALL[age14]])
;  WAE_size_age[74, i] = STDDEV(Length[INDEX_growthdata_ALL[age14]])
;  WAE_size_age[75, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age14]])
;  WAE_size_age[76, i] = MAX(Length[INDEX_growthdata_ALL[age14]])
;  WAE_size_age[77, i] = MIN(Length[INDEX_growthdata_ALL[age14]])
;ENDIF
;IF Age15count GT 0. THEN BEGIN
;  WAE_size_age[78, i] = MEAN(Length[INDEX_growthdata_ALL[age15]])
;  WAE_size_age[79, i] = STDDEV(Length[INDEX_growthdata_ALL[age15]])
;  WAE_size_age[80, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age15]])
;  WAE_size_age[81, i] = MAX(Length[INDEX_growthdata_ALL[age15]])
;  WAE_size_age[82, i] = MIN(Length[INDEX_growthdata_ALL[age15]])
;ENDIF
;IF Age16count GT 0. THEN BEGIN
;  WAE_size_age[83, i] = MEAN(Length[INDEX_growthdata_ALL[age16]])
;  WAE_size_age[84, i] = STDDEV(Length[INDEX_growthdata_ALL[age16]])
;  WAE_size_age[85, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age16]])
;  WAE_size_age[86, i] = MAX(Length[INDEX_growthdata_ALL[age16]])
;  WAE_size_age[87, i] = MIN(Length[INDEX_growthdata_ALL[age16]])
;ENDIF
;IF Age17count GT 0. THEN BEGIN
;  WAE_size_age[88, i] = MEAN(Length[INDEX_growthdata_ALL[age17]])
;  WAE_size_age[89, i] = STDDEV(Length[INDEX_growthdata_ALL[age17]])
;  WAE_size_age[90, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age17]])
;  WAE_size_age[91, i] = MAX(Length[INDEX_growthdata_ALL[age17]])
;  WAE_size_age[92, i] = MIN(Length[INDEX_growthdata_ALL[age17]])
;ENDIF
;IF Age18count GT 0. THEN BEGIN
;  WAE_size_age[93, i] = MEAN(Length[INDEX_growthdata_ALL[age18]])
;  WAE_size_age[94, i] = STDDEV(Length[INDEX_growthdata_ALL[age18]])
;  WAE_size_age[95, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age18]])
;  WAE_size_age[96, i] = MAX(Length[INDEX_growthdata_ALL[age18]])
;  WAE_size_age[97, i] = MIN(Length[INDEX_growthdata_ALL[age18]])
;ENDIF
;IF Age19count GT 0. THEN BEGIN
;  WAE_size_age[98, i] = MEAN(Length[INDEX_growthdata_ALL[age19]])
;  WAE_size_age[99, i] = STDDEV(Length[INDEX_growthdata_ALL[age19]])
;  WAE_size_age[100, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age19]])
;  WAE_size_age[101, i] = MAX(Length[INDEX_growthdata_ALL[age19]])
;  WAE_size_age[102, i] = MIN(Length[INDEX_growthdata_ALL[age19]])
;ENDIF
;IF Age20count GT 0. THEN BEGIN
;  WAE_size_age[103, i] = MEAN(Length[INDEX_growthdata_ALL[age20]])
;  WAE_size_age[104, i] = STDDEV(Length[INDEX_growthdata_ALL[age20]])
;  WAE_size_age[105, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age20]])
;  WAE_size_age[106, i] = MAX(Length[INDEX_growthdata_ALL[age20]])
;  WAE_size_age[107, i] = MIN(Length[INDEX_growthdata_ALL[age20]])
;ENDIF
;IF Age21count GT 0. THEN BEGIN
;  WAE_size_age[108, i] = MEAN(Length[INDEX_growthdata_ALL[age21]])
;  WAE_size_age[109, i] = STDDEV(Length[INDEX_growthdata_ALL[age21]])
;  WAE_size_age[110, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age21]])
;  WAE_size_age[111, i] = MAX(Length[INDEX_growthdata_ALL[age21]])
;  WAE_size_age[112, i] = MIN(Length[INDEX_growthdata_ALL[age21]])
;ENDIF
;IF Age22count GT 0. THEN BEGIN
;  WAE_size_age[113, i] = MEAN(Length[INDEX_growthdata_ALL[age22]])
;  WAE_size_age[114, i] = STDDEV(Length[INDEX_growthdata_ALL[age22]])
;  WAE_size_age[115, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age22]])
;  WAE_size_age[116, i] = MAX(Length[INDEX_growthdata_ALL[age22]])
;  WAE_size_age[117, i] = MIN(Length[INDEX_growthdata_ALL[age22]])
;ENDIF
;IF Age23count GT 0. THEN BEGIN
;  WAE_size_age[118, i] = MEAN(Length[INDEX_growthdata_ALL[age23]])
;  WAE_size_age[119, i] = STDDEV(Length[INDEX_growthdata_ALL[age23]])
;  WAE_size_age[120, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age23]])
;  WAE_size_age[121, i] = MAX(Length[INDEX_growthdata_ALL[age23]])
;  WAE_size_age[122, i] = MIN(Length[INDEX_growthdata_ALL[age23]])
;ENDIF
;IF Age24count GT 0. THEN BEGIN
;  WAE_size_age[123, i] = MEAN(Length[INDEX_growthdata_ALL[age24]])
;  WAE_size_age[124, i] = STDDEV(Length[INDEX_growthdata_ALL[age24]])
;  WAE_size_age[125, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age24]])
;  WAE_size_age[126, i] = MAX(Length[INDEX_growthdata_ALL[age24]])
;  WAE_size_age[127, i] = MIN(Length[INDEX_growthdata_ALL[age24]])
;ENDIF
;IF Age25count GT 0. THEN BEGIN
;  WAE_size_age[128, i] = MEAN(Length[INDEX_growthdata_ALL[age25]])
;  WAE_size_age[129, i] = STDDEV(Length[INDEX_growthdata_ALL[age25]])
;  WAE_size_age[130, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age25]])
;  WAE_size_age[131, i] = MAX(Length[INDEX_growthdata_ALL[age25]])
;  WAE_size_age[132, i] = MIN(Length[INDEX_growthdata_ALL[age25]])
;ENDIF
;IF Age26count GT 0. THEN BEGIN
;  WAE_size_age[133, i] = MEAN(Length[INDEX_growthdata_ALL[age26]])
;  WAE_size_age[134, i] = STDDEV(Length[INDEX_growthdata_ALL[age26]])
;  WAE_size_age[135, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age26]])
;  WAE_size_age[136, i] = MAX(Length[INDEX_growthdata_ALL[age26]])
;  WAE_size_age[137, i] = MIN(Length[INDEX_growthdata_ALL[age26]])
;ENDIF
;
;
;; Males
;IF Age0Mcount GT 0. THEN BEGIN
;  WAE_size_age[138, i] = MEAN(Length[INDEX_growthdata_ALL[age0M]])
;  WAE_size_age[139, i] = STDDEV(Length[INDEX_growthdata_ALL[age0M]])
;  WAE_size_age[140, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age0M]])
;  WAE_size_age[141, i] = MAX(Length[INDEX_growthdata_ALL[age0M]])
;  WAE_size_age[142, i] = MIN(Length[INDEX_growthdata_ALL[age0M]])
;ENDIF
;IF Age1Mcount GT 0. THEN BEGIN
;  WAE_size_age[143, i] = MEAN(Length[INDEX_growthdata_ALL[age1M]])
;  WAE_size_age[144, i] = STDDEV(Length[INDEX_growthdata_ALL[age1M]])
;  WAE_size_age[145, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age1M]])
;  WAE_size_age[146, i] = MAX(Length[INDEX_growthdata_ALL[age1M]])
;  WAE_size_age[147, i] = MIN(Length[INDEX_growthdata_ALL[age1M]])
;ENDIF
;IF Age2Mcount GT 0. THEN BEGIN
;  WAE_size_age[148, i] = MEAN(Length[INDEX_growthdata_ALL[age2M]])
;  WAE_size_age[149, i] = STDDEV(Length[INDEX_growthdata_ALL[age2M]])
;  WAE_size_age[150, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age2M]])
;  WAE_size_age[151, i] = MAX(Length[INDEX_growthdata_ALL[age2M]])
;  WAE_size_age[152, i] = MIN(Length[INDEX_growthdata_ALL[age2M]])
;ENDIF
;IF Age3Mcount GT 0. THEN BEGIN
;  WAE_size_age[153, i] = MEAN(Length[INDEX_growthdata_ALL[age3M]])
;  WAE_size_age[154, i] = STDDEV(Length[INDEX_growthdata_ALL[age3M]])
;  WAE_size_age[155, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age4M]])
;  WAE_size_age[156, i] = MAX(Length[INDEX_growthdata_ALL[age3M]])
;  WAE_size_age[157, i] = MIN(Length[INDEX_growthdata_ALL[age3M]])
;ENDIF
;IF Age4Mcount GT 0. THEN BEGIN
;  WAE_size_age[158, i] = MEAN(Length[INDEX_growthdata_ALL[age4M]])
;  WAE_size_age[159, i] = STDDEV(Length[INDEX_growthdata_ALL[age4M]])
;  WAE_size_age[160, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age4M]])
;  WAE_size_age[161, i] = MAX(Length[INDEX_growthdata_ALL[age4M]])
;  WAE_size_age[162, i] = MIN(Length[INDEX_growthdata_ALL[age4M]])
;ENDIF
;IF Age5Mcount GT 0. THEN BEGIN
;  WAE_size_age[163, i] = MEAN(Length[INDEX_growthdata_ALL[age5M]])
;  WAE_size_age[164, i] = STDDEV(Length[INDEX_growthdata_ALL[age5M]])
;  WAE_size_age[165, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age5M]])
;  WAE_size_age[166, i] = MAX(Length[INDEX_growthdata_ALL[age5M]])
;  WAE_size_age[167, i] = MIN(Length[INDEX_growthdata_ALL[age5M]])
;ENDIF
;IF Age6Mcount GT 0. THEN BEGIN
;  WAE_size_age[168, i] = MEAN(Length[INDEX_growthdata_ALL[age6M]])
;  WAE_size_age[169, i] = STDDEV(Length[INDEX_growthdata_ALL[age6M]])
;  WAE_size_age[170, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age6M]])
;  WAE_size_age[171, i] = MAX(Length[INDEX_growthdata_ALL[age6M]])
;  WAE_size_age[172, i] = MIN(Length[INDEX_growthdata_ALL[age6M]])
;ENDIF
;IF Age7Mcount GT 0. THEN BEGIN
;  WAE_size_age[173, i] = MEAN(Length[INDEX_growthdata_ALL[age7M]])
;  WAE_size_age[174, i] = STDDEV(Length[INDEX_growthdata_ALL[age7M]])
;  WAE_size_age[175, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age7M]])
;  WAE_size_age[176, i] = MAX(Length[INDEX_growthdata_ALL[age7M]])
;  WAE_size_age[177, i] = MIN(Length[INDEX_growthdata_ALL[age7M]])
;ENDIF
;IF Age8Mcount GT 0. THEN BEGIN
;  WAE_size_age[178, i] = MEAN(Length[INDEX_growthdata_ALL[age8M]])
;  WAE_size_age[179, i] = STDDEV(Length[INDEX_growthdata_ALL[age8M]])
;  WAE_size_age[180, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age8M]])
;  WAE_size_age[181, i] = MAX(Length[INDEX_growthdata_ALL[age8M]])
;  WAE_size_age[182, i] = MIN(Length[INDEX_growthdata_ALL[age8M]])
;ENDIF
;IF Age9Mcount GT 0. THEN BEGIN
;  WAE_size_age[183, i] = MEAN(Length[INDEX_growthdata_ALL[age9M]])
;  WAE_size_age[184, i] = STDDEV(Length[INDEX_growthdata_ALL[age9M]])
;  WAE_size_age[185, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age9M]])
;  WAE_size_age[186, i] = MAX(Length[INDEX_growthdata_ALL[age9M]])
;  WAE_size_age[187, i] = MIN(Length[INDEX_growthdata_ALL[age9M]])
;ENDIF
;IF Age10Mcount GT 0. THEN BEGIN
;  WAE_size_age[188, i] = MEAN(Length[INDEX_growthdata_ALL[age10M]])
;  WAE_size_age[189, i] = STDDEV(Length[INDEX_growthdata_ALL[age10M]])
;  WAE_size_age[190, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age10M]])
;  WAE_size_age[191, i] = MAX(Length[INDEX_growthdata_ALL[age10M]])
;  WAE_size_age[192, i] = MIN(Length[INDEX_growthdata_ALL[age10M]])
;ENDIF
;IF Age11Mcount GT 0. THEN BEGIN
;  WAE_size_age[193, i] = MEAN(Length[INDEX_growthdata_ALL[age11M]])
;  WAE_size_age[194, i] = STDDEV(Length[INDEX_growthdata_ALL[age11M]])
;  WAE_size_age[195, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age11M]])
;  WAE_size_age[196, i] = MAX(Length[INDEX_growthdata_ALL[age11M]])
;  WAE_size_age[197, i] = MIN(Length[INDEX_growthdata_ALL[age11M]])
;ENDIF
;IF Age12Mcount GT 0. THEN BEGIN
;  WAE_size_age[198, i] = MEAN(Length[INDEX_growthdata_ALL[age12M]])
;  WAE_size_age[199, i] = STDDEV(Length[INDEX_growthdata_ALL[age12M]])
;  WAE_size_age[200, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age12M]])
;  WAE_size_age[201, i] = MAX(Length[INDEX_growthdata_ALL[age12M]])
;  WAE_size_age[202, i] = MIN(Length[INDEX_growthdata_ALL[age12M]])
;ENDIF
;IF Age13Mcount GT 0. THEN BEGIN
;  WAE_size_age[203, i] = MEAN(Length[INDEX_growthdata_ALL[age13M]])
;  WAE_size_age[204, i] = STDDEV(Length[INDEX_growthdata_ALL[age13M]])
;  WAE_size_age[205, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age13M]])
;  WAE_size_age[206, i] = MAX(Length[INDEX_growthdata_ALL[age13M]])
;  WAE_size_age[207, i] = MIN(Length[INDEX_growthdata_ALL[age13M]])
;ENDIF
;IF Age14Mcount GT 0. THEN BEGIN
;  WAE_size_age[208, i] = MEAN(Length[INDEX_growthdata_ALL[age14M]])
;  WAE_size_age[209, i] = STDDEV(Length[INDEX_growthdata_ALL[age14M]])
;  WAE_size_age[210, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age14M]])
;  WAE_size_age[211, i] = MAX(Length[INDEX_growthdata_ALL[age14M]])
;  WAE_size_age[212, i] = MIN(Length[INDEX_growthdata_ALL[age14M]])
;ENDIF
;IF Age15Mcount GT 0. THEN BEGIN
;  WAE_size_age[213, i] = MEAN(Length[INDEX_growthdata_ALL[age15M]])
;  WAE_size_age[214, i] = STDDEV(Length[INDEX_growthdata_ALL[age15M]])
;  WAE_size_age[215, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age15M]])
;  WAE_size_age[216, i] = MAX(Length[INDEX_growthdata_ALL[age15M]])
;  WAE_size_age[217, i] = MIN(Length[INDEX_growthdata_ALL[age15M]])
;ENDIF
;IF Age16Mcount GT 0. THEN BEGIN
;  WAE_size_age[218, i] = MEAN(Length[INDEX_growthdata_ALL[age16M]])
;  WAE_size_age[219, i] = STDDEV(Length[INDEX_growthdata_ALL[age16M]])
;  WAE_size_age[220, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age16M]])
;  WAE_size_age[221, i] = MAX(Length[INDEX_growthdata_ALL[age16M]])
;  WAE_size_age[222, i] = MIN(Length[INDEX_growthdata_ALL[age16M]])
;ENDIF
;IF Age17Mcount GT 0. THEN BEGIN
;  WAE_size_age[223, i] = MEAN(Length[INDEX_growthdata_ALL[age17M]])
;  WAE_size_age[224, i] = STDDEV(Length[INDEX_growthdata_ALL[age17M]])
;  WAE_size_age[225, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age17M]])
;  WAE_size_age[226, i] = MAX(Length[INDEX_growthdata_ALL[age17M]])
;  WAE_size_age[227, i] = MIN(Length[INDEX_growthdata_ALL[age17M]])
;ENDIF
;IF Age18Mcount GT 0. THEN BEGIN
;  WAE_size_age[228, i] = MEAN(Length[INDEX_growthdata_ALL[age18M]])
;  WAE_size_age[229, i] = STDDEV(Length[INDEX_growthdata_ALL[age18M]])
;  WAE_size_age[230, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age18M]])
;  WAE_size_age[231, i] = MAX(Length[INDEX_growthdata_ALL[age18M]])
;  WAE_size_age[232, i] = MIN(Length[INDEX_growthdata_ALL[age18M]])
;ENDIF
;IF Age19Mcount GT 0. THEN BEGIN
;  WAE_size_age[233, i] = MEAN(Length[INDEX_growthdata_ALL[age19M]])
;  WAE_size_age[234, i] = STDDEV(Length[INDEX_growthdata_ALL[age19M]])
;  WAE_size_age[235, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age19M]])
;  WAE_size_age[236, i] = MAX(Length[INDEX_growthdata_ALL[age19M]])
;  WAE_size_age[237, i] = MIN(Length[INDEX_growthdata_ALL[age19M]])
;ENDIF
;IF Age20Mcount GT 0. THEN BEGIN
;  WAE_size_age[238, i] = MEAN(Length[INDEX_growthdata_ALL[age20M]])
;  WAE_size_age[239, i] = STDDEV(Length[INDEX_growthdata_ALL[age20M]])
;  WAE_size_age[240, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age20M]])
;  WAE_size_age[241, i] = MAX(Length[INDEX_growthdata_ALL[age20M]])
;  WAE_size_age[242, i] = MIN(Length[INDEX_growthdata_ALL[age20M]])
;ENDIF
;IF Age21Mcount GT 0. THEN BEGIN
;  WAE_size_age[243, i] = MEAN(Length[INDEX_growthdata_ALL[age21M]])
;  WAE_size_age[244, i] = STDDEV(Length[INDEX_growthdata_ALL[age21M]])
;  WAE_size_age[245, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age21M]])
;  WAE_size_age[246, i] = MAX(Length[INDEX_growthdata_ALL[age21M]])
;  WAE_size_age[247, i] = MIN(Length[INDEX_growthdata_ALL[age21M]])
;ENDIF
;IF Age22Mcount GT 0. THEN BEGIN
;  WAE_size_age[248, i] = MEAN(Length[INDEX_growthdata_ALL[age22M]])
;  WAE_size_age[249, i] = STDDEV(Length[INDEX_growthdata_ALL[age22M]])
;  WAE_size_age[250, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age22M]])
;  WAE_size_age[251, i] = MAX(Length[INDEX_growthdata_ALL[age22M]])
;  WAE_size_age[252, i] = MIN(Length[INDEX_growthdata_ALL[age22M]])
;ENDIF
;IF Age23Mcount GT 0. THEN BEGIN
;  WAE_size_age[253, i] = MEAN(Length[INDEX_growthdata_ALL[age23M]])
;  WAE_size_age[254, i] = STDDEV(Length[INDEX_growthdata_ALL[age23M]])
;  WAE_size_age[255, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age23M]])
;  WAE_size_age[256, i] = MAX(Length[INDEX_growthdata_ALL[age23M]])
;  WAE_size_age[257, i] = MIN(Length[INDEX_growthdata_ALL[age23M]])
;ENDIF
;IF Age24Mcount GT 0. THEN BEGIN
;  WAE_size_age[258, i] = MEAN(Length[INDEX_growthdata_ALL[age24M]])
;  WAE_size_age[259, i] = STDDEV(Length[INDEX_growthdata_ALL[age24M]])
;  WAE_size_age[260, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age24M]])
;  WAE_size_age[261, i] = MAX(Length[INDEX_growthdata_ALL[age24M]])
;  WAE_size_age[262, i] = MIN(Length[INDEX_growthdata_ALL[age24M]])
;ENDIF
;IF Age25Mcount GT 0. THEN BEGIN
;  WAE_size_age[263, i] = MEAN(Length[INDEX_growthdata_ALL[age25M]])
;  WAE_size_age[264, i] = STDDEV(Length[INDEX_growthdata_ALL[age25M]])
;  WAE_size_age[265, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age25M]])
;  WAE_size_age[266, i] = MAX(Length[INDEX_growthdata_ALL[age25M]])
;  WAE_size_age[267, i] = MIN(Length[INDEX_growthdata_ALL[age25M]])
;ENDIF
;IF Age26Mcount GT 0. THEN BEGIN
;  WAE_size_age[268, i] = MEAN(Length[INDEX_growthdata_ALL[age26M]])
;  WAE_size_age[269, i] = STDDEV(Length[INDEX_growthdata_ALL[age26M]])
;  WAE_size_age[270, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age26M]])
;  WAE_size_age[271, i] = MAX(Length[INDEX_growthdata_ALL[age26M]])
;  WAE_size_age[272, i] = MIN(Length[INDEX_growthdata_ALL[age26M]])
;ENDIF
;
;; Female
;IF Age0Fcount GT 0. THEN BEGIN
;  WAE_size_age[273, i] = MEAN(Length[INDEX_growthdata_ALL[age0F]])
;  WAE_size_age[274, i] = STDDEV(Length[INDEX_growthdata_ALL[age0F]])
;  WAE_size_age[275, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age0F]])
;  WAE_size_age[276, i] = MAX(Length[INDEX_growthdata_ALL[age0F]])
;  WAE_size_age[277, i] = MIN(Length[INDEX_growthdata_ALL[age0F]])
;ENDIF
;IF Age1Fcount GT 0. THEN BEGIN
;  WAE_size_age[278, i] = MEAN(Length[INDEX_growthdata_ALL[age1F]])
;  WAE_size_age[279, i] = STDDEV(Length[INDEX_growthdata_ALL[age1F]])
;  WAE_size_age[280, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age1F]])
;  WAE_size_age[281, i] = MAX(Length[INDEX_growthdata_ALL[age1F]])
;  WAE_size_age[282, i] = MIN(Length[INDEX_growthdata_ALL[age1F]])
;ENDIF
;IF Age2Fcount GT 0. THEN BEGIN
;  WAE_size_age[283, i] = MEAN(Length[INDEX_growthdata_ALL[age2F]])
;  WAE_size_age[284, i] = STDDEV(Length[INDEX_growthdata_ALL[age2F]])
;  WAE_size_age[285, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age2F]])
;  WAE_size_age[286, i] = MAX(Length[INDEX_growthdata_ALL[age2F]])
;  WAE_size_age[287, i] = MIN(Length[INDEX_growthdata_ALL[age2F]])
;ENDIF
;IF Age3Fcount GT 0. THEN BEGIN
;  WAE_size_age[288, i] = MEAN(Length[INDEX_growthdata_ALL[age3F]])
;  WAE_size_age[289, i] = STDDEV(Length[INDEX_growthdata_ALL[age3F]])
;  WAE_size_age[290, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age3F]])
;  WAE_size_age[291, i] = MAX(Length[INDEX_growthdata_ALL[age3F]])
;  WAE_size_age[292, i] = MIN(Length[INDEX_growthdata_ALL[age3F]])
;ENDIF
;IF Age4Fcount GT 0. THEN BEGIN
;  WAE_size_age[293, i] = MEAN(Length[INDEX_growthdata_ALL[age4F]])
;  WAE_size_age[294, i] = STDDEV(Length[INDEX_growthdata_ALL[age4F]])
;  WAE_size_age[295, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age4F]])
;  WAE_size_age[296, i] = MAX(Length[INDEX_growthdata_ALL[age4F]])
;  WAE_size_age[297, i] = MIN(Length[INDEX_growthdata_ALL[age4F]])
;ENDIF
;IF Age5Fcount GT 0. THEN BEGIN
;  WAE_size_age[298, i] = MEAN(Length[INDEX_growthdata_ALL[age5F]])
;  WAE_size_age[299, i] = STDDEV(Length[INDEX_growthdata_ALL[age5F]])
;  WAE_size_age[300, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age5F]])
;  WAE_size_age[301, i] = MAX(Length[INDEX_growthdata_ALL[age5F]])
;  WAE_size_age[302, i] = MIN(Length[INDEX_growthdata_ALL[age5F]])
;ENDIF
;IF Age6Fcount GT 0. THEN BEGIN
;  WAE_size_age[303, i] = MEAN(Length[INDEX_growthdata_ALL[age6F]])
;  WAE_size_age[304, i] = STDDEV(Length[INDEX_growthdata_ALL[age6F]])
;  WAE_size_age[305, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age6F]])
;  WAE_size_age[306, i] = MAX(Length[INDEX_growthdata_ALL[age6F]])
;  WAE_size_age[307, i] = MIN(Length[INDEX_growthdata_ALL[age6F]])
;ENDIF
;IF Age7Fcount GT 0. THEN BEGIN
;  WAE_size_age[308, i] = MEAN(Length[INDEX_growthdata_ALL[age7F]])
;  WAE_size_age[309, i] = STDDEV(Length[INDEX_growthdata_ALL[age7F]])
;  WAE_size_age[310, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age7F]])
;  WAE_size_age[311, i] = MAX(Length[INDEX_growthdata_ALL[age7F]])
;  WAE_size_age[312, i] = MIN(Length[INDEX_growthdata_ALL[age7F]])
;ENDIF
;IF Age8Fcount GT 0. THEN BEGIN
;  WAE_size_age[313, i] = MEAN(Length[INDEX_growthdata_ALL[age8F]])
;  WAE_size_age[314, i] = STDDEV(Length[INDEX_growthdata_ALL[age8F]])
;  WAE_size_age[315, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age8F]])
;  WAE_size_age[316, i] = MAX(Length[INDEX_growthdata_ALL[age8F]])
;  WAE_size_age[317, i] = MIN(Length[INDEX_growthdata_ALL[age8F]])
;ENDIF
;IF Age9Fcount GT 0. THEN BEGIN
;  WAE_size_age[318, i] = MEAN(Length[INDEX_growthdata_ALL[age9F]])
;  WAE_size_age[319, i] = STDDEV(Length[INDEX_growthdata_ALL[age9F]])
;  WAE_size_age[320, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age9F]])
;  WAE_size_age[321, i] = MAX(Length[INDEX_growthdata_ALL[age9F]])
;  WAE_size_age[322, i] = MIN(Length[INDEX_growthdata_ALL[age9F]])
;ENDIF
;IF Age10Fcount GT 0. THEN BEGIN
;  WAE_size_age[323, i] = MEAN(Length[INDEX_growthdata_ALL[age10F]])
;  WAE_size_age[324, i] = STDDEV(Length[INDEX_growthdata_ALL[age10F]])
;  WAE_size_age[325, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age10F]])
;  WAE_size_age[326, i] = MAX(Length[INDEX_growthdata_ALL[age10F]])
;  WAE_size_age[327, i] = MIN(Length[INDEX_growthdata_ALL[age10F]])
;ENDIF
;IF Age11Fcount GT 0. THEN BEGIN
;  WAE_size_age[328, i] = MEAN(Length[INDEX_growthdata_ALL[age11F]])
;  WAE_size_age[329, i] = STDDEV(Length[INDEX_growthdata_ALL[age11F]])
;  WAE_size_age[330, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age11F]])
;  WAE_size_age[331, i] = MAX(Length[INDEX_growthdata_ALL[age11F]])
;  WAE_size_age[332, i] = MIN(Length[INDEX_growthdata_ALL[age11F]])
;ENDIF
;IF Age12Fcount GT 0. THEN BEGIN
;  WAE_size_age[333, i] = MEAN(Length[INDEX_growthdata_ALL[age12F]])
;  WAE_size_age[334, i] = STDDEV(Length[INDEX_growthdata_ALL[age12F]])
;  WAE_size_age[335, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age12F]])
;  WAE_size_age[336, i] = MAX(Length[INDEX_growthdata_ALL[age12F]])
;  WAE_size_age[337, i] = MIN(Length[INDEX_growthdata_ALL[age12F]])
;ENDIF
;IF Age13Fcount GT 0. THEN BEGIN
;  WAE_size_age[338, i] = MEAN(Length[INDEX_growthdata_ALL[age13F]])
;  WAE_size_age[339, i] = STDDEV(Length[INDEX_growthdata_ALL[age13F]])
;  WAE_size_age[340, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age13F]])
;  WAE_size_age[341, i] = MAX(Length[INDEX_growthdata_ALL[age13F]])
;  WAE_size_age[342, i] = MIN(Length[INDEX_growthdata_ALL[age13F]])
;ENDIF
;IF Age14Fcount GT 0. THEN BEGIN
;  WAE_size_age[343, i] = MEAN(Length[INDEX_growthdata_ALL[age14F]])
;  WAE_size_age[344, i] = STDDEV(Length[INDEX_growthdata_ALL[age14F]])
;  WAE_size_age[345, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age14F]])
;  WAE_size_age[346, i] = MAX(Length[INDEX_growthdata_ALL[age14F]])
;  WAE_size_age[347, i] = MIN(Length[INDEX_growthdata_ALL[age14F]])
;ENDIF
;IF Age15Fcount GT 0. THEN BEGIN
;  WAE_size_age[348, i] = MEAN(Length[INDEX_growthdata_ALL[age15F]])
;  WAE_size_age[349, i] = STDDEV(Length[INDEX_growthdata_ALL[age15F]])
;  WAE_size_age[350, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age15F]])
;  WAE_size_age[351, i] = MAX(Length[INDEX_growthdata_ALL[age15F]])
;  WAE_size_age[352, i] = MIN(Length[INDEX_growthdata_ALL[age15F]])
;ENDIF
;IF Age16Fcount GT 0. THEN BEGIN
;  WAE_size_age[353, i] = MEAN(Length[INDEX_growthdata_ALL[age16F]])
;  WAE_size_age[354, i] = STDDEV(Length[INDEX_growthdata_ALL[age16F]])
;  WAE_size_age[355, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age16F]])
;  WAE_size_age[356, i] = MAX(Length[INDEX_growthdata_ALL[age16F]])
;  WAE_size_age[357, i] = MIN(Length[INDEX_growthdata_ALL[age16F]])
;ENDIF
;IF Age17Fcount GT 0. THEN BEGIN
;  WAE_size_age[358, i] = MEAN(Length[INDEX_growthdata_ALL[age17F]])
;  WAE_size_age[359, i] = STDDEV(Length[INDEX_growthdata_ALL[age17F]])
;  WAE_size_age[360, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age17F]])
;  WAE_size_age[361, i] = MAX(Length[INDEX_growthdata_ALL[age17F]])
;  WAE_size_age[362, i] = MIN(Length[INDEX_growthdata_ALL[age17F]])
;ENDIF
;IF Age18Fcount GT 0. THEN BEGIN
;  WAE_size_age[363, i] = MEAN(Length[INDEX_growthdata_ALL[age18F]])
;  WAE_size_age[364, i] = STDDEV(Length[INDEX_growthdata_ALL[age18F]])
;  WAE_size_age[365, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age18F]])
;  WAE_size_age[366, i] = MAX(Length[INDEX_growthdata_ALL[age18F]])
;  WAE_size_age[367, i] = MIN(Length[INDEX_growthdata_ALL[age18F]])
;ENDIF
;IF Age19Fcount GT 0. THEN BEGIN
;  WAE_size_age[368, i] = MEAN(Length[INDEX_growthdata_ALL[age19F]])
;  WAE_size_age[369, i] = STDDEV(Length[INDEX_growthdata_ALL[age19F]])
;  WAE_size_age[370, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age19F]])
;  WAE_size_age[371, i] = MAX(Length[INDEX_growthdata_ALL[age19F]])
;  WAE_size_age[372, i] = MIN(Length[INDEX_growthdata_ALL[age19F]])
;ENDIF
;IF Age20Fcount GT 0. THEN BEGIN
;  WAE_size_age[373, i] = MEAN(Length[INDEX_growthdata_ALL[age20F]])
;  WAE_size_age[374, i] = STDDEV(Length[INDEX_growthdata_ALL[age20F]])
;  WAE_size_age[375, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age20F]])
;  WAE_size_age[376, i] = MAX(Length[INDEX_growthdata_ALL[age20F]])
;  WAE_size_age[377, i] = MIN(Length[INDEX_growthdata_ALL[age20F]])
;ENDIF
;IF Age21Fcount GT 0. THEN BEGIN
;  WAE_size_age[378, i] = MEAN(Length[INDEX_growthdata_ALL[age21F]])
;  WAE_size_age[379, i] = STDDEV(Length[INDEX_growthdata_ALL[age21F]])
;  WAE_size_age[380, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age21F]])
;  WAE_size_age[381, i] = MAX(Length[INDEX_growthdata_ALL[age21F]])
;  WAE_size_age[382, i] = MIN(Length[INDEX_growthdata_ALL[age21F]])
;ENDIF
;IF Age22Fcount GT 0. THEN BEGIN
;  WAE_size_age[383, i] = MEAN(Length[INDEX_growthdata_ALL[age22F]])
;  WAE_size_age[384, i] = STDDEV(Length[INDEX_growthdata_ALL[age22F]])
;  WAE_size_age[385, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age22F]])
;  WAE_size_age[386, i] = MAX(Length[INDEX_growthdata_ALL[age22F]])
;  WAE_size_age[387, i] = MIN(Length[INDEX_growthdata_ALL[age22F]])
;ENDIF
;IF Age23Fcount GT 0. THEN BEGIN
;  WAE_size_age[388, i] = MEAN(Length[INDEX_growthdata_ALL[age23F]])
;  WAE_size_age[389, i] = STDDEV(Length[INDEX_growthdata_ALL[age23F]])
;  WAE_size_age[390, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age23F]])
;  WAE_size_age[391, i] = MAX(Length[INDEX_growthdata_ALL[age23F]])
;  WAE_size_age[392, i] = MIN(Length[INDEX_growthdata_ALL[age23F]])
;ENDIF
;IF Age24Fcount GT 0. THEN BEGIN
;  WAE_size_age[393, i] = MEAN(Length[INDEX_growthdata_ALL[age24F]])
;  WAE_size_age[394, i] = STDDEV(Length[INDEX_growthdata_ALL[age24F]])
;  WAE_size_age[396, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age24F]])
;  WAE_size_age[397, i] = MAX(Length[INDEX_growthdata_ALL[age24F]])
;  WAE_size_age[398, i] = MIN(Length[INDEX_growthdata_ALL[age24F]])
;ENDIF
;IF Age25Fcount GT 0. THEN BEGIN
;  WAE_size_age[399, i] = MEAN(Length[INDEX_growthdata_ALL[age25F]])
;  WAE_size_age[400, i] = STDDEV(Length[INDEX_growthdata_ALL[age25F]])
;  WAE_size_age[401, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age25F]])
;  WAE_size_age[402, i] = MAX(Length[INDEX_growthdata_ALL[age25F]])
;  WAE_size_age[403, i] = MIN(Length[INDEX_growthdata_ALL[age25F]])
;ENDIF
;IF Age26Fcount GT 0. THEN BEGIN
;  WAE_size_age[404, i] = MEAN(Length[INDEX_growthdata_ALL[age26F]])
;  WAE_size_age[405, i] = STDDEV(Length[INDEX_growthdata_ALL[age26F]])
;  WAE_size_age[406, i] = N_ELEMENTS(Length[INDEX_growthdata_ALL[age26F]])
;  WAE_size_age[407, i] = MAX(Length[INDEX_growthdata_ALL[age26F]])
;  WAE_size_age[408, i] = MIN(Length[INDEX_growthdata_ALL[age26F]])
;ENDIF
;
ENDIF
      ;ENDFOR
      ;PRINT, 'uniqWBIC_Year_NsmplGT30_NageclassGT3[i]', uniqWBIC_Year_NsmplGT30_NageclassGT3[i]
      ;PRINT, INDEX_datafinal


  
  ;ADD SS, DOF IN FIGURE?????????
  
      ; GROWTH MODELS
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
      Device, Set_Character_Size=[8,12]
      Device, Get_Decomposed=currentState

      ;DEVICE, GET_DECOMPOSED=old_decomposed
      DEVICE, DECOMPOSED=0
      ;LOADCT, 13
      ;!P.Background = cgColor('white')
      ;!P.Color = cgColor('black')
      cgLoadCT, 4, /Brewer
      ;XColors, /Brewer, Index=4
      ;
      ; Create an image and display it
      ;IMAGE1 = DIST(300)

      ;WINDOW, 1, XSIZE=300, YSIZE=300

      ;TV, IMAGE1
      ; Write a PNG file to the temporary directory

      ; Note the use of the TRUE keyword to TVRD
      ;filename = FILEPATH('test.png', /TMP)
      
      ;keywords = PSConfig(Cancel=cancelled)
      ;IF cancelled THEN RETURN
      ;thisDevice = !D.Name
      ;Set_Plot, 'PS'
      ;Device, _Extra=keywords
      ;Plot, findgen(11) ; Or whatever graphics commands you use.


      
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
      
  ; 1) standard von Bertlanffy model (3 parameters) - all individuals
  startparms = [850.0D, 0.1D, -1.D]
  ;851  0.099 -0.96
  ;WLslope = 3.18
  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,1500.D]}, 3)
  pi(0).limited(1) = 0; 0=vary; 1=constant
  pi(0).limits(1) = 1500.
  MAXITER = 100000
  num_param = 3.
  
  parms = mpfitfun('vonBertalanffy', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, $
  perror = dparms, yfit=yfit, PARINFO=pi)
  Length_Gro_EstAll = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[SORT(Age_Gro)] - parms[2])));^WLslope

  ;!P.Color = cgColor('black')
  ;Device, Decomposed=0
  OPLOT, Age_Gro[SORT(Age_Gro)], Length_Gro_EstAll, THICK = 2, Color=cgColor('green')
  
  paramset[9:11, i] = parms
  paramset[14, i] = BESTNORM
  paramset[15, i] = DOF
  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
  paramset[17:19, i] = dparms
  paramset[22, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
  paramset[23, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
  paramset[24, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
  paramset[25, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
  paramset[26, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
  paramset[27, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
  paramset[28, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
  paramset[29, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
  paramset[30, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
  paramset[31, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
  paramset[32, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
  paramset[33, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
  paramset[34, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
  paramset[35, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
  paramset[36, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
  paramset[37, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
  paramset[38, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
  paramset[39, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
  paramset[40, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
  paramset[41, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
  paramset[42, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
  
  
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
;  
;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
;  
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


;  ; 4) Logistic model (3 parameters) - all fish
;   startparms = [850.0D, 0.1D, -1.D]
;  ;WLslope = 3.18
;  pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
;  pi(0).limited(1) = 0; 0=vary; 1=constant
;  pi(0).limits(1) = 1500.
;  num_param = 3.
;  MAXITER = 100000
;
;  parms = mpfitfun('Logistic', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = maxiter $
;  , perror = dparms, yfit=yfit, PARINFO=pi)
;  Length_Gro_EstAll = parms[0] * (1.+EXP(-parms[1] * (Age_Gro - parms[2])))^(-1.)
;  OPLOT, Age_Gro, Length_Gro_EstAll, THICK = 2
;  paramset[9:11, i] = parms
;  paramset[14, i] = BESTNORM
;  paramset[15, i] = DOF
;  paramset[16, i] = paramset[1, i] * ALOG(paramset[14, i]^2.) + 2. * num_param $
;      + 2. * num_param + (2 * num_param * (num_param+1))/(paramset[1, i]-num_param-1)
;  paramset[17:19, i] = dparms;
;  paramset[22, i] = parms[0] * (1.+EXP(-parms[1] * (0. - parms[2])))^(-1.)
;  paramset[23, i] = parms[0] * (1.+EXP(-parms[1] * (1. - parms[2])))^(-1.)
;  paramset[24, i] = parms[0] * (1.+EXP(-parms[1] * (2. - parms[2])))^(-1.)
;  paramset[25, i] = parms[0] * (1.+EXP(-parms[1] * (3. - parms[2])))^(-1.)
;  paramset[26, i] = parms[0] * (1.+EXP(-parms[1] * (4. - parms[2])))^(-1.)
;  paramset[27, i] = parms[0] * (1.+EXP(-parms[1] * (5. - parms[2])))^(-1.)
;  paramset[28, i] = parms[0] * (1.+EXP(-parms[1] * (6. - parms[2])))^(-1.)
;  paramset[29, i] = parms[0] * (1.+EXP(-parms[1] * (7. - parms[2])))^(-1.)
;  paramset[30, i] = parms[0] * (1.+EXP(-parms[1] * (8. - parms[2])))^(-1.)
;  paramset[31, i] = parms[0] * (1.+EXP(-parms[1] * (9. - parms[2])))^(-1.)
;  paramset[32, i] = parms[0] * (1.+EXP(-parms[1] * (10. - parms[2])))^(-1.)
;  paramset[33, i] = parms[0] * (1.+EXP(-parms[1] * (11. - parms[2])))^(-1.)
;  paramset[34, i] = parms[0] * (1.+EXP(-parms[1] * (12. - parms[2])))^(-1.)
;  paramset[35, i] = parms[0] * (1.+EXP(-parms[1] * (13. - parms[2])))^(-1.)
;  paramset[36, i] = parms[0] * (1.+EXP(-parms[1] * (14. - parms[2])))^(-1.)
;  paramset[37, i] = parms[0] * (1.+EXP(-parms[1] * (15. - parms[2])))^(-1.)
;  paramset[38, i] = parms[0] * (1.+EXP(-parms[1] * (16. - parms[2])))^(-1.)
;  paramset[39, i] = parms[0] * (1.+EXP(-parms[1] * (17. - parms[2])))^(-1.)
;  paramset[40, i] = parms[0] * (1.+EXP(-parms[1] * (18. - parms[2])))^(-1.)
;  paramset[41, i] = parms[0] * (1.+EXP(-parms[1] * (19. - parms[2])))^(-1.)
;  paramset[42, i] = parms[0] * (1.+EXP(-parms[1] * (20. - parms[2])))^(-1.)
 
 
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
;  parms = mpfitfun('Schnute_Richards', Age_Gro, Length_Gro, dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER=MAXITER $
;          , perror = dparms, yfit=yfit, PARINFO=pi)
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
        
    ; 1) standard von Bertanffy model (3 parameters) - males
    ;startparms = [[850.0D, 0.1D, -1.D]
    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1 
    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;pi(0).limits(1) = 2000.
    
    parms = mpfitfun('vonBertalanffy', Age_Gro[MALE], Length_Gro[MALE], DOF=dof, dy, startparms, BESTNORM=bestnorm, MAXITER = MAXITER $
    , perror = dparms, yfit=yfit, PARINFO=pi)
    Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE[SORT(Age_Gro[MALE])]] - parms[2])));^WLslope 

    OPLOT, Age_Gro[MALE[SORT(Age_Gro[MALE])]], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3 $; 2=dahsed
    , Color=cgColor('blue')
    
    paramset[48:50, i] = parms  
    paramset[53, i] = BESTNORM
    paramset[54, i] = DOF
    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
    paramset[56:58, i] = dparms
    paramset[61, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
    paramset[62, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
    paramset[63, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
    paramset[64, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
    paramset[65, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
    paramset[66, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
    paramset[67, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
    paramset[68, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
    paramset[69, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
    paramset[70, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
    paramset[71, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
    paramset[72, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
    paramset[73, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
    paramset[74, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
    paramset[75, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
    paramset[76, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
    paramset[77, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
    paramset[78, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
    paramset[79, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
    paramset[80, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
    paramset[81, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))
  
  
;    ; 2) generalized von Bertanffy model - males
;    ;startparms = [850.0D, 0.1D, -1.D]
;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1 
;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
;    ;pi(0).limits(1) = 2000.
;    parms = mpfitfun('GvonBertalanffy', Age_Gro[MALE], Length_Gro[MALE],  DOF=dof, dy, startparms, BESTNORM=bestnorm, MAXITER = MAXITER $
;    , perror = dparms, yfit=yfit, PARINFO=pi)
;    Length_Gro_EstMale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))^parms[3];^WLslope 
;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
;    paramset[48:51, i] = parms  
;    paramset[53, i] = BESTNORM
;    paramset[54, i] = DOF
;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
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
;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
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

  
;    ; 4) Logistic model (3 parameters) - males
;    ;startparms = [850.0D, 0.1D, -1.D]
;    dy = Length_Gro[MALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[MALE])) * 0.1
;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
;    ;pi(0).limits(1) = 2000.
;    parms = mpfitfun('Logistic', Age_Gro[MALE], Length_Gro[MALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
;    Length_Gro_EstMale = parms[0] * (1.+EXP(-parms[1] * (Age_Gro[MALE] - parms[2])))^(-1.)
;    OPLOT, Age_Gro[MALE], Length_Gro_EstMale, LINESTYLE = 2, THICK = 3; 2=dahsed
;    paramset[48:50, i] = parms
;    paramset[53, i] = BESTNORM
;    paramset[54, i] = DOF
;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[MALE])-num_param-1)
;    paramset[56:58, i] = dparms
;    paramset[61, i] = parms[0] * (1.+EXP(-parms[1] * (0.- parms[2])))^(-1.)
;    paramset[62, i] = parms[0] * (1.+EXP(-parms[1] * (1.- parms[2])))^(-1.)
;    paramset[63, i] = parms[0] * (1.+EXP(-parms[1] * (2.- parms[2])))^(-1.)
;    paramset[64, i] = parms[0] * (1.+EXP(-parms[1] * (3.- parms[2])))^(-1.)
;    paramset[65, i] = parms[0] * (1.+EXP(-parms[1] * (4.- parms[2])))^(-1.)
;    paramset[66, i] = parms[0] * (1.+EXP(-parms[1] * (5.- parms[2])))^(-1.)
;    paramset[67, i] = parms[0] * (1.+EXP(-parms[1] * (6.- parms[2])))^(-1.)
;    paramset[68, i] = parms[0] * (1.+EXP(-parms[1] * (7.- parms[2])))^(-1.)
;    paramset[69, i] = parms[0] * (1.+EXP(-parms[1] * (8.- parms[2])))^(-1.)
;    paramset[70, i] = parms[0] * (1.+EXP(-parms[1] * (9.- parms[2])))^(-1.)
;    paramset[71, i] = parms[0] * (1.+EXP(-parms[1] * (10.- parms[2])))^(-1.)
;    paramset[72, i] = parms[0] * (1.+EXP(-parms[1] * (11.- parms[2])))^(-1.)
;    paramset[73, i] = parms[0] * (1.+EXP(-parms[1] * (12.- parms[2])))^(-1.)
;    paramset[74, i] = parms[0] * (1.+EXP(-parms[1] * (13.- parms[2])))^(-1.)
;    paramset[75, i] = parms[0] * (1.+EXP(-parms[1] * (14.- parms[2])))^(-1.)
;    paramset[76, i] = parms[0] * (1.+EXP(-parms[1] * (15.- parms[2])))^(-1.)
;    paramset[77, i] = parms[0] * (1.+EXP(-parms[1] * (16.- parms[2])))^(-1.)
;    paramset[78, i] = parms[0] * (1.+EXP(-parms[1] * (17.- parms[2])))^(-1.)
;    paramset[79, i] = parms[0] * (1.+EXP(-parms[1] * (18.- parms[2])))^(-1.)
;    paramset[80, i] = parms[0] * (1.+EXP(-parms[1] * (19.- parms[2])))^(-1.)
;    paramset[81, i] = parms[0] * (1.+EXP(-parms[1] * (20.- parms[2])))^(-1.)
  
;  
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
;    paramset[55, i] = N_ELEMENTS(Length_Gro[MALE]) * ALOG(paramset[53, i]^2.) $
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
        
    ; 1) standard von Bertalanffy model - females
    ;startparms = [850.0D, 0.1D, -1.D]
    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1
    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
    ;pi(0).limited(1) = 0; 0=vary; 1=constant
    ;pi(0).limits(1) = 2000.

    parms = mpfitfun('vonBertalanffy', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, startparms, DOF=dof, BESTNORM=bestnorm, $
    MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
    Length_Gro_EstFemale = parms[0] * (1 - EXP(-parms[1] * (Age_Gro[FEMALE[SORT(Age_Gro[FEMALE])]]- parms[2])));^WLslope
    ;PRINT, Age_Gro[FEMALE[SORT(Age_Gro[FEMALE])]]
    ;PRINT, Length_Gro_EstFemale[SORT(Length_Gro_EstFemale)]
    OPLOT, Age_Gro[FEMALE[SORT(Age_Gro[FEMALE])]], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4 $; 1=dotted
    , Color=cgColor('red')
    ;Device, Decomposed=1

    paramset[87:89, i] = parms
    paramset[92, i] = BESTNORM
    paramset[93, i] = DOF
    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
    paramset[95:97, i] = dparms
    paramset[100, i] = parms[0] * (1 - EXP(-parms[1] * (0. - parms[2])))
    paramset[101, i] = parms[0] * (1 - EXP(-parms[1] * (1. - parms[2])))
    paramset[102, i] = parms[0] * (1 - EXP(-parms[1] * (2. - parms[2])))
    paramset[103, i] = parms[0] * (1 - EXP(-parms[1] * (3. - parms[2])))
    paramset[104, i] = parms[0] * (1 - EXP(-parms[1] * (4. - parms[2])))
    paramset[105, i] = parms[0] * (1 - EXP(-parms[1] * (5. - parms[2])))
    paramset[106, i] = parms[0] * (1 - EXP(-parms[1] * (6. - parms[2])))
    paramset[107, i] = parms[0] * (1 - EXP(-parms[1] * (7. - parms[2])))
    paramset[108, i] = parms[0] * (1 - EXP(-parms[1] * (8. - parms[2])))
    paramset[109, i] = parms[0] * (1 - EXP(-parms[1] * (9. - parms[2])))
    paramset[110, i] = parms[0] * (1 - EXP(-parms[1] * (10. - parms[2])))
    paramset[111, i] = parms[0] * (1 - EXP(-parms[1] * (11. - parms[2])))
    paramset[112, i] = parms[0] * (1 - EXP(-parms[1] * (12. - parms[2])))
    paramset[113, i] = parms[0] * (1 - EXP(-parms[1] * (13. - parms[2])))
    paramset[114, i] = parms[0] * (1 - EXP(-parms[1] * (14. - parms[2])))
    paramset[115, i] = parms[0] * (1 - EXP(-parms[1] * (15. - parms[2])))
    paramset[116, i] = parms[0] * (1 - EXP(-parms[1] * (16. - parms[2])))
    paramset[117, i] = parms[0] * (1 - EXP(-parms[1] * (17. - parms[2])))
    paramset[118, i] = parms[0] * (1 - EXP(-parms[1] * (18. - parms[2])))
    paramset[119, i] = parms[0] * (1 - EXP(-parms[1] * (19. - parms[2])))
    paramset[120, i] = parms[0] * (1 - EXP(-parms[1] * (20. - parms[2])))


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
;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
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
;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
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
;

;    ; 4) Logistic model - females 
;    ;startparms = [850.0D, 0.1D, -1.D]
;    dy = Length_Gro[FEMALE] + RANDOMN(seed, N_ELEMENTS(Length_Gro[FEMALE])) * 0.1 
;    ;pi = replicate({fixed:0, limited:[0,0], limits:[0.D,0.D]}, 3)
;    ;pi(0).limited(1) = 0; 0=vary; 1=constant
;    ;pi(0).limits(1) = 2000.
;    parms = mpfitfun('Logistic', Age_Gro[FEMALE], Length_Gro[FEMALE], dy, DOF=dof, startparms,  BESTNORM=bestnorm, MAXITER = MAXITER, perror = dparms, yfit=yfit, PARINFO=pi)
;    Length_Gro_EstFemale = parms[0] * (1.+EXP(-parms[1] * (Age_Gro[FEMALE] - parms[2])))^(-1.)
;    OPLOT, Age_Gro[FEMALE], Length_Gro_EstFemale, LINESTYLE = 1, THICK = 4; 1=dotted
;    paramset[87:89, i] = parms
;    paramset[92, i] = BESTNORM
;    paramset[93, i] = DOF
;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
;      + 2. * num_param + (2 * num_param * (num_param+1))/(N_ELEMENTS(Length_Gro[FEMALE])-num_param-1)
;    paramset[95:97, i] = dparms
;    paramset[100, i] = parms[0] * (1.+EXP(-parms[1] * (0. - parms[2])))^(-1.)
;    paramset[101, i] = parms[0] * (1.+EXP(-parms[1] * (1. - parms[2])))^(-1.)
;    paramset[102, i] = parms[0] * (1.+EXP(-parms[1] * (2. - parms[2])))^(-1.)
;    paramset[103, i] = parms[0] * (1.+EXP(-parms[1] * (3. - parms[2])))^(-1.)
;    paramset[104, i] = parms[0] * (1.+EXP(-parms[1] * (4. - parms[2])))^(-1.)
;    paramset[105, i] = parms[0] * (1.+EXP(-parms[1] * (5. - parms[2])))^(-1.)
;    paramset[106, i] = parms[0] * (1.+EXP(-parms[1] * (6. - parms[2])))^(-1.)
;    paramset[107, i] = parms[0] * (1.+EXP(-parms[1] * (7. - parms[2])))^(-1.)
;    paramset[108, i] = parms[0] * (1.+EXP(-parms[1] * (8. - parms[2])))^(-1.)
;    paramset[109, i] = parms[0] * (1.+EXP(-parms[1] * (9. - parms[2])))^(-1.)
;    paramset[110, i] = parms[0] * (1.+EXP(-parms[1] * (10. - parms[2])))^(-1.)
;    paramset[111, i] = parms[0] * (1.+EXP(-parms[1] * (11. - parms[2])))^(-1.)
;    paramset[112, i] = parms[0] * (1.+EXP(-parms[1] * (12. - parms[2])))^(-1.)
;    paramset[113, i] = parms[0] * (1.+EXP(-parms[1] * (13. - parms[2])))^(-1.)
;    paramset[114, i] = parms[0] * (1.+EXP(-parms[1] * (14. - parms[2])))^(-1.)
;    paramset[115, i] = parms[0] * (1.+EXP(-parms[1] * (15. - parms[2])))^(-1.)
;    paramset[116, i] = parms[0] * (1.+EXP(-parms[1] * (16. - parms[2])))^(-1.)
;    paramset[117, i] = parms[0] * (1.+EXP(-parms[1] * (17. - parms[2])))^(-1.)
;    paramset[118, i] = parms[0] * (1.+EXP(-parms[1] * (18. - parms[2])))^(-1.)
;    paramset[119, i] = parms[0] * (1.+EXP(-parms[1] * (19. - parms[2])))^(-1.)
;    paramset[120, i] = parms[0] * (1.+EXP(-parms[1] * (20. - parms[2])))^(-1.)
    
    
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
;    paramset[94, i] = N_ELEMENTS(Length_Gro[FEMALE]) * ALOG(paramset[92, i]^2.) $
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
        
;      ENDIF

    ENDIF
    
    WRITE_PNG, filename, TVRD(/TRUE)

    ; Restore device settings.
    DEVICE, DECOMPOSED=old_decomposed
    ;WRITE_PNG, filename, TVRD()
    
    
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
FUNCTION WalleyeAgeAssignInd, FishLength, FishAgeIndArray, FishProbSub, FishAgeInd, LengthIndex
; a fiunction to assgin age to length data

       ; variables      
;       ; in
;       FishLength = Length_prod[SizeLT100]
;       FishAgeIndArray = SizeLT100
;       FishProbSub[0:26] = prop_age0[0];prop_age26[[0]]
;       FishAgeInd = Age_prod[SizeLT100]
;       i+NumLengthBin+adj = LengthIndex
;        
;       ; out 
;       Length_mean[0:26] = WAE_length_mean[10:37, i*NumLengthBin+adj+0L]
;       Length_bin[0:26] = WAE_length_bin[10:37, i*NumLengthBin+adj+0L]
;       FishAgeInd     

;PRINT, N_ELEMENTS(FISHLENGTH)
 
Length_bin = FLTARR(27)
Length_mean = FLTARR(27) 
FishAgeInd = 0
FishLengthInd = 0
;PRINT, 'FishProbSub', FishProbSub

; Randomly select fish for ageing
;n = N_ELements(Length_prod[SizeLT100]); number of fish ine a length bin
n = N_ELements(FishLength); number of fish ine a length bin
;print, n

;im = SizeLT100; array of fish
im = FishAgeIndArray; array of fish
IF n GT 0 THEN arr = RANDOMU(seed, n); select random numbers from the uniform distribution
ind = SORT(arr); sort the random number

; age 0
;m0 = N_ELements(Length_prod[SizeLT100]) * prop_age0[[0]]; number of fish to select
m0 = N_ELements(FishLength) * FishProbSub[0]; number of fish to select
FishAgeInd0ID = im[ind[0:ROUND(m0)-1]]
;WAE_length_bin[10, LengthIndex+0L] = ROUND(m0)
Length_bin[0] = ROUND(m0)
;IF ROUND(m0) GT 0 THEN WAE_length_mean[10, i*NumLengthBin+adj+0L] = TOTAL(Length_prod[SizeLT100[FishAgeInd0ID]])/ROUND(m0)
IF ROUND(m0) GT 0 THEN Length_mean[0] = TOTAL(FishLength[FishAgeInd0ID])/ROUND(m0)
IF ROUND(m0) GT 0 THEN BEGIN
  FishAgeInd0 = 0+INTARR(Length_bin[0])
  FishAgeInd = FishAgeInd0  
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd

; age 1          
m1 = N_ELements(FishLength) * FishProbSub[1]; number of fish to select
FishAgeInd1ID = im[ind[0:ROUND(m1)-1]]
Length_bin[1] = ROUND(m1)
IF ROUND(m1) GT 0 THEN Length_mean[1] = TOTAL(FishLength[FishAgeInd1ID])/ROUND(m1)
IF ROUND(m1) GT 0 THEN BEGIN
  FishAgeInd1 = 1+INTARR(Length_bin[1])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd1 ELSE FishAgeInd = [FishAgeInd, FishAgeInd1]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd1]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 2          
m2 = N_ELements(FishLength) * FishProbSub[2]; number of fish to select
FishAgeInd2ID = im[ind[0:ROUND(m2)-1]]
Length_bin[2] = ROUND(m2)
IF ROUND(m2) GT 0 THEN Length_mean[2] = TOTAL(FishLength[FishAgeInd2ID])/ROUND(m2)
IF ROUND(m2) GT 0 THEN BEGIN
  FishAgeInd2 = 2+INTARR(Length_bin[2])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd2 ELSE FishAgeInd = [FishAgeInd, FishAgeInd2]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd2]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 3        
m3 = N_ELements(FishLength) * FishProbSub[3]; number of fish to select
FishAgeInd3ID = im[ind[0:ROUND(m3)-1]]
Length_bin[3] = ROUND(m3)
IF ROUND(m3) GT 0 THEN Length_mean[3] = TOTAL(FishLength[FishAgeInd3ID])/ROUND(m3)
IF ROUND(m3) GT 0 THEN BEGIN
  FishAgeInd3 = 3+INTARR(Length_bin[3])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd3 ELSE FishAgeInd = [FishAgeInd, FishAgeInd3]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd3]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 4
m4 = N_ELements(FishLength) * FishProbSub[4]; number of fish to select
FishAgeInd4ID = im[ind[0:ROUND(m4)-1]]
Length_bin[4] = ROUND(m4)
IF ROUND(m4) GT 0 THEN Length_mean[4] = TOTAL(FishLength[FishAgeInd4ID])/ROUND(m4)
  IF ROUND(m4) GT 0 THEN BEGIN
  FishAgeInd4 = 4+INTARR(Length_bin[4])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd4 ELSE FishAgeInd = [FishAgeInd, FishAgeInd4]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd4]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 5
m5 = N_ELements(FishLength) * FishProbSub[5]; number of fish to select
FishAgeInd5ID = im[ind[0:ROUND(m5)-1]]
Length_bin[5] = ROUND(m5)
IF ROUND(m5) GT 0 THEN Length_mean[5] = TOTAL(FishLength[FishAgeInd5ID])/ROUND(m5)
IF ROUND(m5) GT 0 THEN BEGIN
  FishAgeInd5 = 5+INTARR(Length_bin[5])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd5 ELSE FishAgeInd = [FishAgeInd, FishAgeInd5]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd5]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 6
m6 = N_ELements(FishLength) * FishProbSub[6]; number of fish to select
FishAgeInd6ID = im[ind[0:ROUND(m6)-1]]
Length_bin[6] = ROUND(m6)
IF ROUND(m6) GT 0 THEN Length_mean[6] = TOTAL(FishLength[FishAgeInd6ID])/ROUND(m6)
IF ROUND(m6) GT 0 THEN BEGIN
  FishAgeInd6 = 6+INTARR(Length_bin[6])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd6 ELSE FishAgeInd = [FishAgeInd, FishAgeInd6]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd6]
ENDIF
;RINT, 'FishAgeInd', FishAgeInd
; age 7          
m7 = N_ELements(FishLength) * FishProbSub[7]; number of fish to select
FishAgeInd7ID = im[ind[0:ROUND(m7)-1]]
Length_bin[7] = ROUND(m7)
IF ROUND(m7) GT 0 THEN Length_mean[7] = TOTAL(FishLength[FishAgeInd7ID])/ROUND(m7)
IF ROUND(m7) GT 0 THEN BEGIN
  FishAgeInd7 = 7+INTARR(Length_bin[7])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd7 ELSE FishAgeInd = [FishAgeInd, FishAgeInd7]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd7]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 8          
m8 = N_ELements(FishLength) * FishProbSub[8]; number of fish to select
FishAgeInd8ID = im[ind[0:ROUND(m8)-1]]
Length_bin[8] = ROUND(m8)
IF ROUND(m8) GT 0 THEN Length_mean[8] = TOTAL(FishLength[FishAgeInd8ID])/ROUND(m8)
IF ROUND(m8) GT 0 THEN BEGIN
  FishAgeInd8 = 8+INTARR(Length_bin[8])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd8 ELSE FishAgeInd = [FishAgeInd, FishAgeInd8]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd8]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 9      
m9 = N_ELements(FishLength) * FishProbSub[9]; number of fish to select
FishAgeInd9ID = im[ind[0:ROUND(m9)-1]]
Length_bin[9] = ROUND(m9)
IF ROUND(m9) GT 0 THEN Length_mean[9] = TOTAL(FishLength[FishAgeInd9ID])/ROUND(m9)
IF ROUND(m9) GT 0 THEN BEGIN
  FishAgeInd9 = 9+INTARR(Length_bin[9])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd9 ELSE FishAgeInd = [FishAgeInd, FishAgeInd9]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd9]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 10          
m10 = N_ELements(FishLength) * FishProbSub[10]; number of fish to select
FishAgeInd10ID = im[ind[0:ROUND(m10)-1]]
Length_bin[10] = ROUND(m10)
;print, round(m10)
IF ROUND(m10) GT 0 THEN Length_mean[10] = TOTAL(FishLength[FishAgeInd10ID])/ROUND(m10)
IF ROUND(m10) GT 0 THEN BEGIN
  FishAgeInd10 = 10+INTARR(Length_bin[10])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd10 ELSE FishAgeInd = [FishAgeInd, FishAgeInd10]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd10]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 11          
m11 = N_ELements(FishLength) * FishProbSub[11]; number of fish to select
FishAgeInd11ID = im[ind[0:ROUND(m11)-1]]
Length_bin[11] = ROUND(m11)
IF ROUND(m11) GT 0 THEN Length_mean[11] = TOTAL(FishLength[FishAgeInd11ID])/ROUND(m11)
IF ROUND(m11) GT 0 THEN BEGIN
  FishAgeInd11 = 11+INTARR(Length_bin[11])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd11 ELSE FishAgeInd = [FishAgeInd, FishAgeInd11]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd11]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 12          
m12 = N_ELements(FishLength) * FishProbSub[12]; number of fish to select
FishAgeInd12ID = im[ind[0:ROUND(m12)-1]]
Length_bin[12] = ROUND(m12)
IF ROUND(m12) GT 0 THEN Length_mean[12] = TOTAL(FishLength[FishAgeInd12ID])/ROUND(m12)
IF ROUND(m12) GT 0 THEN BEGIN
  FishAgeInd12 = 12+INTARR(Length_bin[12])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd12 ELSE FishAgeInd = [FishAgeInd, FishAgeInd12]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd12]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 13          
m13 = N_ELements(FishLength) * FishProbSub[13]; number of fish to select
FishAgeInd13ID = im[ind[0:ROUND(m13)-1]]
Length_bin[13] = ROUND(m13)
IF ROUND(m13) GT 0 THEN Length_mean[13] = TOTAL(FishLength[FishAgeInd13ID])/ROUND(m13)
IF ROUND(m13) GT 0 THEN BEGIN
  FishAgeInd13 = 13+INTARR(Length_bin[13])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd13 ELSE FishAgeInd = [FishAgeInd, FishAgeInd13]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd13]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 14          
m14 = N_ELements(FishLength) * FishProbSub[14]; number of fish to select
FishAgeInd14ID = im[ind[0:ROUND(m14)-1]]
Length_bin[14] = ROUND(m14)
IF ROUND(m14) GT 0 THEN Length_mean[14] = TOTAL(FishLength[FishAgeInd14ID])/ROUND(m14)
 IF ROUND(m14) GT 0 THEN BEGIN
  FishAgeInd14 = 14+INTARR(Length_bin[14])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd14 ELSE FishAgeInd = [FishAgeInd, FishAgeInd14]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd14]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 15          
m15 = N_ELements(FishLength) * FishProbSub[15]; number of fish to select
FishAgeInd15ID = im[ind[0:ROUND(m15)-1]]
Length_bin[15] = ROUND(m15)
IF ROUND(m15) GT 0 THEN Length_mean[15] = TOTAL(FishLength[FishAgeInd15ID])/ROUND(m15)
IF ROUND(m15) GT 0 THEN BEGIN
  FishAgeInd15 = 15+INTARR(Length_bin[15])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd15 ELSE FishAgeInd = [FishAgeInd, FishAgeInd15]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd15]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 16     
m16 = N_ELements(FishLength) * FishProbSub[16]; number of fish to select
FishAgeInd16ID = im[ind[0:ROUND(m16)-1]]
Length_bin[16] = ROUND(m16)
IF ROUND(m16) GT 0 THEN Length_mean[16] = TOTAL(FishLength[FishAgeInd16ID])/ROUND(m16)
IF ROUND(m16) GT 0 THEN BEGIN
  FishAgeInd16 = 16+INTARR(Length_bin[16])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd16 ELSE FishAgeInd = [FishAgeInd, FishAgeInd16]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd16]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 17         
m17 = N_ELements(FishLength) * FishProbSub[17]; number of fish to select
FishAgeInd17ID = im[ind[0:ROUND(m17)-1]]
Length_bin[17] = ROUND(m17)
IF ROUND(m17) GT 0 THEN Length_mean[17] = TOTAL(FishLength[FishAgeInd17ID])/ROUND(m17)
IF ROUND(m17) GT 0 THEN BEGIN
  FishAgeInd17 = 17+INTARR(Length_bin[17])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd17 ELSE FishAgeInd = [FishAgeInd, FishAgeInd17]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd17]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 18          
m18 = N_ELements(FishLength) * FishProbSub[18]; number of fish to select
FishAgeInd18ID = im[ind[0:ROUND(m18)-1]]
Length_bin[18] = ROUND(m18)
IF ROUND(m18) GT 0 THEN Length_mean[18] = TOTAL(FishLength[FishAgeInd18ID])/ROUND(m18)
IF ROUND(m18) GT 0 THEN BEGIN
  FishAgeInd18 = 18+INTARR(Length_bin[18])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd18 ELSE FishAgeInd = [FishAgeInd, FishAgeInd18]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd18]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 19
m19 = N_ELements(FishLength) * FishProbSub[19]; number of fish to select
FishAgeInd19ID = im[ind[0:ROUND(m19)-1]]
Length_bin[19] = ROUND(m19)
IF ROUND(m19) GT 0 THEN Length_mean[19] = TOTAL(FishLength[FishAgeInd19ID])/ROUND(m19)
IF ROUND(m19) GT 0 THEN BEGIN
  FishAgeInd19 = 19+INTARR(Length_bin[19])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd19 ELSE FishAgeInd = [FishAgeInd, FishAgeInd19]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd19]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 20          
m20 = N_ELements(FishLength) * FishProbSub[20]; number of fish to select
FishAgeInd20ID = im[ind[0:ROUND(m20)-1]]
Length_bin[20] = ROUND(m20)
IF ROUND(m20) GT 0 THEN Length_mean[20] = TOTAL(FishLength[FishAgeInd20ID])/ROUND(m20)
IF ROUND(m20) GT 0 THEN BEGIN
  FishAgeInd20 = 20+INTARR(Length_bin[20])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd20 ELSE FishAgeInd = [FishAgeInd, FishAgeInd20]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd20]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 21        
m21 = N_ELements(FishLength) * FishProbSub[21]; number of fish to select
FishAgeInd21ID = im[ind[0:ROUND(m21)-1]]
Length_bin[21] = ROUND(m21)
IF ROUND(m21) GT 0 THEN Length_mean[21] = TOTAL(FishLength[FishAgeInd21ID])/ROUND(m21)
IF ROUND(m21) GT 0 THEN BEGIN
  FishAgeInd21 = 21+INTARR(Length_bin[21])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd21 ELSE FishAgeInd = [FishAgeInd, FishAgeInd21]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd21]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 22
m22 = N_ELements(FishLength) * FishProbSub[22]; number of fish to select
FishAgeInd22ID = im[ind[0:ROUND(m22)-1]]
Length_bin[22] = ROUND(m22)
IF ROUND(m22) GT 0 THEN Length_mean[22] = TOTAL(FishLength[FishAgeInd22ID])/ROUND(m22)
IF ROUND(m22) GT 0 THEN BEGIN
  FishAgeInd22 = 22+INTARR(Length_bin[22])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd22 ELSE FishAgeInd = [FishAgeInd, FishAgeInd22]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd22]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 23
m23 = N_ELements(FishLength) * FishProbSub[23]; number of fish to select
FishAgeInd23ID = im[ind[0:ROUND(m23)-1]]
Length_bin[23] = ROUND(m23)
IF ROUND(m23) GT 0 THEN Length_mean[23] = TOTAL(FishLength[FishAgeInd23ID])/ROUND(m23)
IF ROUND(m23) GT 0 THEN BEGIN
  FishAgeInd23 = 23+INTARR(Length_bin[23])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd23 ELSE FishAgeInd = [FishAgeInd, FishAgeInd23]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd23]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 24          
m24 = N_ELements(FishLength) * FishProbSub[24]; number of fish to select
FishAgeInd24ID = im[ind[0:ROUND(m24)-1]]
Length_bin[24] = ROUND(m24)
IF ROUND(m24) GT 0 THEN Length_mean[24] = TOTAL(FishLength[FishAgeInd24ID])/ROUND(m24)
IF ROUND(m24) GT 0 THEN BEGIN
  FishAgeInd24 = 24+INTARR(Length_bin[24])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd24 ELSE FishAgeInd = [FishAgeInd, FishAgeInd24]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd24]
ENDIF 
;PRINT, 'FishAgeInd', FishAgeInd
; age 25
m25 = N_ELements(FishLength) * FishProbSub[25]; number of fish to select
FishAgeInd25ID = im[ind[0:ROUND(m25)-1]]
Length_bin[25] = ROUND(m25)
IF ROUND(m25) GT 0 THEN Length_mean[25] = TOTAL(FishLength[FishAgeInd25ID])/ROUND(m25)
IF ROUND(m25) GT 0 THEN BEGIN
  FishAgeInd25 = 25+INTARR(Length_bin[25])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd25 ELSE FishAgeInd = [FishAgeInd, FishAgeInd25]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd25]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
; age 26
m26 = N_ELements(FishLength) * FishProbSub[26]; number of fish to select
FishAgeInd26ID = im[ind[0:ROUND(m26)-1]]
Length_bin[26] = ROUND(m26)
IF ROUND(m26) GT 0 THEN Length_mean[26] = TOTAL(FishLength[FishAgeInd26ID])/ROUND(m26)
IF ROUND(m26) GT 0 THEN BEGIN
  FishAgeInd26 = 26+INTARR(Length_bin[26])
  IF (N_ELements(FishAgeInd) EQ 1) THEN BEGIN
    IF (FishAgeInd EQ 0) THEN FishAgeInd = FishAgeInd26 ELSE FishAgeInd = [FishAgeInd, FishAgeInd26]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd26]
ENDIF
;PRINT, 'FishAgeInd', FishAgeInd
        
nAge = N_ELements(FishAgeInd); number of fish ine a length bin
;PRINT, nAge
imAge = INDGEN(nAge); array of fish
IF nAge GT 0 THEN arrAge = RANDOMU(seed, nAge); select random numbers from the uniform distribution
indAge = SORT(arrAge); sort the random number
FishAgeIndIndex = imAge[indAge[0:ROUND(nAge)-1]]
FishAgeInd = FishAgeInd[FishAgeIndIndex]

IF nAge GT n THEN BEGIN 
  ;FishAgeInd = FishAgeInd[FishAgeIndIndex]
  FishAgeInd = FishAgeInd[0:n-1L]
ENDIF
IF (nAge LT n) THEN BEGIN 
  ;FishAgeInd = FishAgeInd[FishAgeIndIndex]
  IF (nAge EQ 1) THEN BEGIN  
    IF (FishAgeInd EQ 0) THEN BEGIN
      FishAgeInd = INTARR(n)
      FishAgeInd[*] = -1 
    ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd[nAge-(n-nAge):nAge-1L]]
  ENDIF ELSE FishAgeInd = [FishAgeInd, FishAgeInd[nAge-(n-nAge):nAge-1L]]
  IF N_ELEMENTS(FishAgeInd) LT n THEN $
  FishAgeInd = [FishAgeInd, FishAgeInd[N_ELEMENTS(FishAgeInd)-(n-N_ELEMENTS(FishAgeInd)):N_ELEMENTS(FishAgeInd)-1L]]
ENDIF
;PRINT, FishAgeInd

FishLenInd = FishLength

FishInd = FLTARR(2, n)
FishInd[0, *] = FishAgeInd       
FishInd[1, *] = FishLenInd

RETURN, FishInd
END
FUNCTION WalleyeAgeAssign, FishLength, FishAgeIndArray, FishProbSub, FishAgeInd, LengthIndex
; a fiunction to assgin age to length data

;PRINT, N_ELEMENTS(FISHLENGTH)
;PRINT, FishAgeIndIndArray
;PRINT, FishProbSub
       ; variables      
;       ; in
;       FishLength = Length_prod[SizeLT100]
;       FishAgeIndIndArray = SizeLT100
;       FishProbSub[0:26] = prop_age0[0];prop_age26[[0]]
;       FishAgeInd = Age_prod[SizeLT100]
;       i+NumLengthBin+adj = LengthIndex
;       ; out 
;       Length_mean[0:26] = WAE_length_mean[10:37, i*NumLengthBin+adj+0L]
;       Length_bin[0:26] = WAE_length_bin[10:37, i*NumLengthBin+adj+0L]
;       FishAgeInd     
        
 Length_bin = FLTARR(27)
 Length_mean = FLTARR(27)
 
; Randomly select fish for ageing

;n = N_ELements(Length_prod[SizeLT100]); number of fish ine a length bin
n = N_ELements(FishLength); number of fish ine a length bin
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
;IF ROUND(m0) GT 0 THEN FishAgeInd[FishAgeInd0ID] = 0
; age 1
m1 = N_ELements(FishLength) * FishProbSub[1]; number of fish to select
FishAgeInd1ID = im[ind[0:ROUND(m1)-1]]
Length_bin[1] = ROUND(m1)
IF ROUND(m1) GT 0 THEN Length_mean[1] = TOTAL(FishLength[FishAgeInd1ID])/ROUND(m1)
;IF ROUND(m1) GT 0 THEN FishAgeInd[FishAgeInd1ID] = 1    
; age 2          
m2 = N_ELements(FishLength) * FishProbSub[2]; number of fish to select
FishAgeInd2ID = im[ind[0:ROUND(m2)-1]]
Length_bin[2] = ROUND(m2)
IF ROUND(m2) GT 0 THEN Length_mean[2] = TOTAL(FishLength[FishAgeInd2ID])/ROUND(m2)
;IF ROUND(m2) GT 0 THEN FishAgeInd[FishAgeInd2ID] = 2
; age 3        
m3 = N_ELements(FishLength) * FishProbSub[3]; number of fish to select
FishAgeInd3ID = im[ind[0:ROUND(m3)-1]]
Length_bin[3] = ROUND(m3)
IF ROUND(m3) GT 0 THEN Length_mean[3] = TOTAL(FishLength[FishAgeInd3ID])/ROUND(m3)
;IF ROUND(m3) GT 0 THEN FishAgeInd[FishAgeInd3ID] = 3
; age 4
m4 = N_ELements(FishLength) * FishProbSub[4]; number of fish to select
FishAgeInd4ID = im[ind[0:ROUND(m4)-1]]
Length_bin[4] = ROUND(m4)
IF ROUND(m4) GT 0 THEN Length_mean[4] = TOTAL(FishLength[FishAgeInd4ID])/ROUND(m4)
;IF ROUND(m4) GT 0 THEN FishAgeInd[FishAgeInd4ID] = 4
; age 5
m5 = N_ELements(FishLength) * FishProbSub[5]; number of fish to select
FishAgeInd5ID = im[ind[0:ROUND(m5)-1]]
Length_bin[5] = ROUND(m5)
IF ROUND(m5) GT 0 THEN Length_mean[5] = TOTAL(FishLength[FishAgeInd5ID])/ROUND(m5)
;IF ROUND(m5) GT 0 THEN FishAgeInd[FishAgeInd5ID] = 5
; age 6
m6 = N_ELements(FishLength) * FishProbSub[6]; number of fish to select
FishAgeInd6ID = im[ind[0:ROUND(m6)-1]]
Length_bin[6] = ROUND(m6)
IF ROUND(m6) GT 0 THEN Length_mean[6] = TOTAL(FishLength[FishAgeInd6ID])/ROUND(m6)
;IF ROUND(m6) GT 0 THEN FishAgeInd[FishAgeInd6ID] = 6
; age 7          
m7 = N_ELements(FishLength) * FishProbSub[7]; number of fish to select
FishAgeInd7ID = im[ind[0:ROUND(m7)-1]]
Length_bin[7] = ROUND(m7)
IF ROUND(m7) GT 0 THEN Length_mean[7] = TOTAL(FishLength[FishAgeInd7ID])/ROUND(m7)
;IF ROUND(m7) GT 0 THEN FishAgeInd[FishAgeInd7ID] = 7
; age 8          
m8 = N_ELements(FishLength) * FishProbSub[8]; number of fish to select
FishAgeInd8ID = im[ind[0:ROUND(m8)-1]]
Length_bin[8] = ROUND(m8)
IF ROUND(m8) GT 0 THEN Length_mean[8] = TOTAL(FishLength[FishAgeInd8ID])/ROUND(m8)
;IF ROUND(m8) GT 0 THEN FishAgeInd[FishAgeInd8ID] = 8
; age 9      
m9 = N_ELements(FishLength) * FishProbSub[9]; number of fish to select
FishAgeInd9ID = im[ind[0:ROUND(m9)-1]]
Length_bin[9] = ROUND(m9)
IF ROUND(m9) GT 0 THEN Length_mean[9] = TOTAL(FishLength[FishAgeInd9ID])/ROUND(m9)
;IF ROUND(m9) GT 0 THEN FishAgeInd[FishAgeInd9ID] = 9
; age 10          
m10 = N_ELements(FishLength) * FishProbSub[10]; number of fish to select
FishAgeInd10ID = im[ind[0:ROUND(m10)-1]]
Length_bin[10] = ROUND(m10)
IF ROUND(m10) GT 0 THEN Length_mean[10] = TOTAL(FishLength[FishAgeInd10ID])/ROUND(m10)
;IF ROUND(m10) GT 0 THEN FishAgeInd[FishAgeInd10ID] = 10 
; age 11          
m11 = N_ELements(FishLength) * FishProbSub[11]; number of fish to select
FishAgeInd11ID = im[ind[0:ROUND(m11)-1]]
Length_bin[11] = ROUND(m11)
IF ROUND(m11) GT 0 THEN Length_mean[11] = TOTAL(FishLength[FishAgeInd11ID])/ROUND(m11)
;IF ROUND(m11) GT 0 THEN FishAgeInd[FishAgeInd11ID] = 11
; age 12          
m12 = N_ELements(FishLength) * FishProbSub[12]; number of fish to select
FishAgeInd12ID = im[ind[0:ROUND(m12)-1]]
Length_bin[12] = ROUND(m12)
IF ROUND(m12) GT 0 THEN Length_mean[12] = TOTAL(FishLength[FishAgeInd12ID])/ROUND(m12)
;IF ROUND(m12) GT 0 THEN FishAgeInd[FishAgeInd12ID] = 12
; age 13          
m13 = N_ELements(FishLength) * FishProbSub[13]; number of fish to select
FishAgeInd13ID = im[ind[0:ROUND(m13)-1]]
Length_bin[13] = ROUND(m13)
IF ROUND(m13) GT 0 THEN Length_mean[13] = TOTAL(FishLength[FishAgeInd13ID])/ROUND(m13)
;IF ROUND(m13) GT 0 THEN FishAgeInd[FishAgeInd13ID] = 13  
; age 14          
m14 = N_ELements(FishLength) * FishProbSub[14]; number of fish to select
FishAgeInd14ID = im[ind[0:ROUND(m14)-1]]
Length_bin[14] = ROUND(m14)
IF ROUND(m14) GT 0 THEN Length_mean[14] = TOTAL(FishLength[FishAgeInd14ID])/ROUND(m14)
;IF ROUND(m14) GT 0 THEN FishAgeInd[FishAgeInd14ID] = 14
; age 15          
m15 = N_ELements(FishLength) * FishProbSub[15]; number of fish to select
FishAgeInd15ID = im[ind[0:ROUND(m15)-1]]
Length_bin[15] = ROUND(m15)
IF ROUND(m15) GT 0 THEN Length_mean[15] = TOTAL(FishLength[FishAgeInd15ID])/ROUND(m15)
;IF ROUND(m15) GT 0 THEN FishAgeInd[FishAgeInd15ID] = 15
; age 16     
m16 = N_ELements(FishLength) * FishProbSub[16]; number of fish to select
FishAgeInd16ID = im[ind[0:ROUND(m16)-1]]
Length_bin[16] = ROUND(m16)
IF ROUND(m16) GT 0 THEN Length_mean[16] = TOTAL(FishLength[FishAgeInd16ID])/ROUND(m16)
;IF ROUND(m16) GT 0 THEN FishAgeInd[FishAgeInd16ID] = 16
; age 17         
m17 = N_ELements(FishLength) * FishProbSub[17]; number of fish to select
FishAgeInd17ID = im[ind[0:ROUND(m17)-1]]
Length_bin[17] = ROUND(m17)
IF ROUND(m17) GT 0 THEN Length_mean[17] = TOTAL(FishLength[FishAgeInd17ID])/ROUND(m17)
;IF ROUND(m17) GT 0 THEN FishAgeInd[FishAgeInd17ID] = 17
; age 18          
m18 = N_ELements(FishLength) * FishProbSub[18]; number of fish to select
FishAgeInd18ID = im[ind[0:ROUND(m18)-1]]
Length_bin[18] = ROUND(m18)
IF ROUND(m18) GT 0 THEN Length_mean[18] = TOTAL(FishLength[FishAgeInd18ID])/ROUND(m18)
;IF ROUND(m18) GT 0 THEN FishAgeInd[FishAgeInd18ID] = 18      
; age 19
m19 = N_ELements(FishLength) * FishProbSub[19]; number of fish to select
FishAgeInd19ID = im[ind[0:ROUND(m19)-1]]
Length_bin[19] = ROUND(m19)
IF ROUND(m19) GT 0 THEN Length_mean[19] = TOTAL(FishLength[FishAgeInd19ID])/ROUND(m19)
;IF ROUND(m19) GT 0 THEN FishAgeInd[FishAgeInd19ID] = 19  
; age 20          
m20 = N_ELements(FishLength) * FishProbSub[20]; number of fish to select
FishAgeInd20ID = im[ind[0:ROUND(m20)-1]]
Length_bin[20] = ROUND(m20)
IF ROUND(m20) GT 0 THEN Length_mean[20] = TOTAL(FishLength[FishAgeInd20ID])/ROUND(m20)
;IF ROUND(m20) GT 0 THEN FishAgeInd[FishAgeInd20ID] = 20
; age 21        
m21 = N_ELements(FishLength) * FishProbSub[21]; number of fish to select
FishAgeInd21ID = im[ind[0:ROUND(m21)-1]]
Length_bin[21] = ROUND(m21)
IF ROUND(m21) GT 0 THEN Length_mean[21] = TOTAL(FishLength[FishAgeInd21ID])/ROUND(m21)
;IF ROUND(m21) GT 0 THEN FishAgeInd[FishAgeInd21ID] = 21
; age 22
m22 = N_ELements(FishLength) * FishProbSub[22]; number of fish to select
FishAgeInd22ID = im[ind[0:ROUND(m22)-1]]
Length_bin[22] = ROUND(m22)
IF ROUND(m22) GT 0 THEN Length_mean[22] = TOTAL(FishLength[FishAgeInd22ID])/ROUND(m22)
;IF ROUND(m22) GT 0 THEN FishAgeInd[FishAgeInd22ID] = 22  
; age 23
m23 = N_ELements(FishLength) * FishProbSub[23]; number of fish to select
FishAgeInd23ID = im[ind[0:ROUND(m23)-1]]
Length_bin[23] = ROUND(m23)
IF ROUND(m23) GT 0 THEN Length_mean[23] = TOTAL(FishLength[FishAgeInd23ID])/ROUND(m23)
;IF ROUND(m23) GT 0 THEN FishAgeInd[FishAgeInd23ID] = 23  
; age 24          
m24 = N_ELements(FishLength) * FishProbSub[24]; number of fish to select
FishAgeInd24ID = im[ind[0:ROUND(m24)-1]]
Length_bin[24] = ROUND(m24)
IF ROUND(m24) GT 0 THEN Length_mean[24] = TOTAL(FishLength[FishAgeInd24ID])/ROUND(m24)
;IF ROUND(m24) GT 0 THEN FishAgeInd[FishAgeInd24ID] = 24    
; age 25
m25 = N_ELements(FishLength) * FishProbSub[25]; number of fish to select
FishAgeInd25ID = im[ind[0:ROUND(m25)-1]]
Length_bin[25] = ROUND(m25)
IF ROUND(m25) GT 0 THEN Length_mean[25] = TOTAL(FishLength[FishAgeInd25ID])/ROUND(m25)
;IF ROUND(m25) GT 0 THEN FishAgeInd[FishAgeInd25ID] = 25       
; age 26
m26 = N_ELements(FishLength) * FishProbSub[26]; number of fish to select
FishAgeInd26ID = im[ind[0:ROUND(m26)-1]]
Length_bin[26] = ROUND(m26)
IF ROUND(m26) GT 0 THEN Length_mean[26] = TOTAL(FishLength[FishAgeInd26ID])/ROUND(m26)
;IF ROUND(m26) GT 0 THEN FishAgeInd[FishAgeInd26ID] = 26

AgeAssignOut = FLTARR(3, 27)
AgeAssignOut[0, *] = Length_mean[0:26]        
AgeAssignOut[1, *] = Length_bin[0:26]

RETURN, AgeAssignOut
END
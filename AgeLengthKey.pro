FUNCTION AgeLengthKey, p_age0, p_age1, p_age2, p_age3, p_age4, p_age5, p_age6, p_age7, p_age8, p_age9, p_age10 $
, p_age11, p_age12, p_age13, p_age14, p_age15, p_age16, p_age17, p_age18, p_age19, p_age20, p_age21, p_age22 $
, p_age23, p_age24, p_age25, p_age26, INDEX_data, LengthIndex
;


FishAgeProb = fltarr(27)

FishAgeProb[0] = p_age0[INDEX_data[LengthIndex]]
FishAgeProb[1] = p_age1[INDEX_data[LengthIndex]]
FishAgeProb[2] = p_age2[INDEX_data[LengthIndex]]
FishAgeProb[3] = p_age3[INDEX_data[LengthIndex]]
FishAgeProb[4] = p_age4[INDEX_data[LengthIndex]]
FishAgeProb[5] = p_age5[INDEX_data[LengthIndex]]
FishAgeProb[6] = p_age6[INDEX_data[LengthIndex]]
FishAgeProb[7] = p_age7[INDEX_data[LengthIndex]]
FishAgeProb[8] = p_age8[INDEX_data[LengthIndex]]
FishAgeProb[9] = p_age9[INDEX_data[LengthIndex]]
FishAgeProb[10] = p_age10[INDEX_data[LengthIndex]]
FishAgeProb[11] = p_age11[INDEX_data[LengthIndex]]
FishAgeProb[12] = p_age12[INDEX_data[LengthIndex]]
FishAgeProb[13] = p_age13[INDEX_data[LengthIndex]]
FishAgeProb[14] = p_age14[INDEX_data[LengthIndex]]
FishAgeProb[15] = p_age15[INDEX_data[LengthIndex]]
FishAgeProb[16] = p_age16[INDEX_data[LengthIndex]]
FishAgeProb[17] = p_age17[INDEX_data[LengthIndex]]
FishAgeProb[18] = p_age18[INDEX_data[LengthIndex]]
FishAgeProb[19] = p_age19[INDEX_data[LengthIndex]]
FishAgeProb[20] = p_age20[INDEX_data[LengthIndex]]
FishAgeProb[21] = p_age21[INDEX_data[LengthIndex]]
FishAgeProb[22] = p_age22[INDEX_data[LengthIndex]]
FishAgeProb[23] = p_age23[INDEX_data[LengthIndex]]
FishAgeProb[24] = p_age24[INDEX_data[LengthIndex]]
FishAgeProb[25] = p_age25[INDEX_data[LengthIndex]]
FishAgeProb[26] = p_age26[INDEX_data[LengthIndex]]

;PRINT, 'FishAgeProb', FishAgeProb
RETURN, FishAgeProb

END
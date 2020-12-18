; length bin 1
IF SizeLT100countF GT 0 THEN BEGIN
age0SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 1) AND (Sex_Gro[SizeLT100] EQ 1), Age0SizeLT100countF)
age1SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 1) AND (Sex_Gro[SizeLT100] EQ 1), Age1SizeLT100countF)
age2SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 2) AND (Sex_Gro[SizeLT100] EQ 1), Age2SizeLT100countF)
age3SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 3) AND (Sex_Gro[SizeLT100] EQ 1), Age3SizeLT100countF)
age4SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 4) AND (Sex_Gro[SizeLT100] EQ 1), Age4SizeLT100countF)
age5SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 5) AND (Sex_Gro[SizeLT100] EQ 1), Age5SizeLT100countF)
age6SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 6) AND (Sex_Gro[SizeLT100] EQ 1), Age6SizeLT100countF)
age7SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 7) AND (Sex_Gro[SizeLT100] EQ 1), Age7SizeLT100countF)
age8SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 8) AND (Sex_Gro[SizeLT100] EQ 1), Age8SizeLT100countF)
age9SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 9) AND (Sex_Gro[SizeLT100] EQ 1), Age9SizeLT100countF)
age10SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 10) AND (Sex_Gro[SizeLT100] EQ 1), Age10SizeLT100countF)
age11SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 11) AND (Sex_Gro[SizeLT100] EQ 1), Age11SizeLT100countF)
AGE12SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 12) AND (Sex_Gro[SizeLT100] EQ 1), Age12SizeLT100countF)
AGE13SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 13) AND (Sex_Gro[SizeLT100] EQ 1), Age13SizeLT100countF)
AGE14SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 14) AND (Sex_Gro[SizeLT100] EQ 1), Age14SizeLT100countF)
AGE15SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 15) AND (Sex_Gro[SizeLT100] EQ 1), Age15SizeLT100countF)
age16SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 16) AND (Sex_Gro[SizeLT100] EQ 1), Age16SizeLT100countF)
age17SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 17) AND (Sex_Gro[SizeLT100] EQ 1), Age17SizeLT100countF)
age18SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 18) AND (Sex_Gro[SizeLT100] EQ 1), Age18SizeLT100countF)
age19SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 19) AND (Sex_Gro[SizeLT100] EQ 1), Age19SizeLT100countF)
age20SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 20) AND (Sex_Gro[SizeLT100] EQ 1), Age20SizeLT100countF)
age21SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 21) AND (Sex_Gro[SizeLT100] EQ 1), Age21SizeLT100countF)
age22SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 22) AND (Sex_Gro[SizeLT100] EQ 1), Age22SizeLT100countF)
age23SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 23) AND (Sex_Gro[SizeLT100] EQ 1), Age23SizeLT100countF)
age24SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 24) AND (Sex_Gro[SizeLT100] EQ 1), Age24SizeLT100countF)
age25SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 25) AND (Sex_Gro[SizeLT100] EQ 1), Age25SizeLT100countF)
age26SizeLT100F = WHERE((Age_Gro[SizeLT100] EQ 26) AND (Sex_Gro[SizeLT100] EQ 1), Age26SizeLT100countF)

  WAE_length_bin[70, i*NumLengthBin+adj] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj] = 99
  WAE_length_bin[75, i*NumLengthBin+adj] = SizeLT100countF

  WAE_length_bin[76, i*NumLengthBin+adj] = Age0SizeLT100countF
  WAE_length_bin[77, i*NumLengthBin+adj] = Age1SizeLT100countF
  WAE_length_bin[78, i*NumLengthBin+adj] = Age2SizeLT100countF
  WAE_length_bin[79, i*NumLengthBin+adj] = Age3SizeLT100countF
  WAE_length_bin[80, i*NumLengthBin+adj] = Age4SizeLT100countF
  WAE_length_bin[81, i*NumLengthBin+adj] = Age5SizeLT100countF
  WAE_length_bin[82, i*NumLengthBin+adj] = Age6SizeLT100countF
  WAE_length_bin[83, i*NumLengthBin+adj] = Age7SizeLT100countF
  WAE_length_bin[84, i*NumLengthBin+adj] = Age8SizeLT100countF
  WAE_length_bin[85, i*NumLengthBin+adj] = Age9SizeLT100countF
  WAE_length_bin[86, i*NumLengthBin+adj] = Age10SizeLT100countF
  WAE_length_bin[87, i*NumLengthBin+adj] = Age11SizeLT100countF
  WAE_length_bin[88, i*NumLengthBin+adj] = Age12SizeLT100countF
  WAE_length_bin[89, i*NumLengthBin+adj] = Age13SizeLT100countF
  WAE_length_bin[90, i*NumLengthBin+adj] = Age14SizeLT100countF
  WAE_length_bin[91, i*NumLengthBin+adj] = Age15SizeLT100countF
  WAE_length_bin[92, i*NumLengthBin+adj] = Age16SizeLT100countF
  WAE_length_bin[93, i*NumLengthBin+adj] = Age17SizeLT100countF
  WAE_length_bin[94, i*NumLengthBin+adj] = Age18SizeLT100countF
  WAE_length_bin[95, i*NumLengthBin+adj] = Age19SizeLT100countF
  WAE_length_bin[96, i*NumLengthBin+adj] = Age20SizeLT100countF
  WAE_length_bin[97, i*NumLengthBin+adj] = Age21SizeLT100countF
  WAE_length_bin[98, i*NumLengthBin+adj] = Age22SizeLT100countF
  WAE_length_bin[99, i*NumLengthBin+adj] = Age23SizeLT100countF
  WAE_length_bin[100, i*NumLengthBin+adj] = Age24SizeLT100countF
  WAE_length_bin[101, i*NumLengthBin+adj] = Age25SizeLT100countF
  WAE_length_bin[102, i*NumLengthBin+adj] = Age26SizeLT100countF
ENDIF
PRINT, 'SizeLT100F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj])


; length bin 2
IF Size100to120countF GT 0 THEN BEGIN
age0Size100to120F = WHERE((Age_Gro[Size100to120] EQ 1) AND (Sex_Gro[Size100to120] EQ 1), Age0Size100to120countF)
age1Size100to120F = WHERE((Age_Gro[Size100to120] EQ 1) AND (Sex_Gro[Size100to120] EQ 1), Age1Size100to120countF)
age2Size100to120F = WHERE((Age_Gro[Size100to120] EQ 2) AND (Sex_Gro[Size100to120] EQ 1), Age2Size100to120countF)
age3Size100to120F = WHERE((Age_Gro[Size100to120] EQ 3) AND (Sex_Gro[Size100to120] EQ 1), Age3Size100to120countF)
age4Size100to120F = WHERE((Age_Gro[Size100to120] EQ 4) AND (Sex_Gro[Size100to120] EQ 1), Age4Size100to120countF)
age5Size100to120F = WHERE((Age_Gro[Size100to120] EQ 5) AND (Sex_Gro[Size100to120] EQ 1), Age5Size100to120countF)
age6Size100to120F = WHERE((Age_Gro[Size100to120] EQ 6) AND (Sex_Gro[Size100to120] EQ 1), Age6Size100to120countF)
age7Size100to120F = WHERE((Age_Gro[Size100to120] EQ 7) AND (Sex_Gro[Size100to120] EQ 1), Age7Size100to120countF)
age8Size100to120F = WHERE((Age_Gro[Size100to120] EQ 8) AND (Sex_Gro[Size100to120] EQ 1), Age8Size100to120countF)
age9Size100to120F = WHERE((Age_Gro[Size100to120] EQ 9) AND (Sex_Gro[Size100to120] EQ 1), Age9Size100to120countF)
age10Size100to120F = WHERE((Age_Gro[Size100to120] EQ 10) AND (Sex_Gro[Size100to120] EQ 1), Age10Size100to120countF)
age11Size100to120F = WHERE((Age_Gro[Size100to120] EQ 11) AND (Sex_Gro[Size100to120] EQ 1), Age11Size100to120countF)
AGE12Size100to120F = WHERE((Age_Gro[Size100to120] EQ 12) AND (Sex_Gro[Size100to120] EQ 1), Age12Size100to120countF)
AGE13Size100to120F = WHERE((Age_Gro[Size100to120] EQ 13) AND (Sex_Gro[Size100to120] EQ 1), Age13Size100to120countF)
AGE14Size100to120F = WHERE((Age_Gro[Size100to120] EQ 14) AND (Sex_Gro[Size100to120] EQ 1), Age14Size100to120countF)
AGE15Size100to120F = WHERE((Age_Gro[Size100to120] EQ 15) AND (Sex_Gro[Size100to120] EQ 1), Age15Size100to120countF)
age16Size100to120F = WHERE((Age_Gro[Size100to120] EQ 16) AND (Sex_Gro[Size100to120] EQ 1), Age16Size100to120countF)
age17Size100to120F = WHERE((Age_Gro[Size100to120] EQ 17) AND (Sex_Gro[Size100to120] EQ 1), Age17Size100to120countF)
age18Size100to120F = WHERE((Age_Gro[Size100to120] EQ 18) AND (Sex_Gro[Size100to120] EQ 1), Age18Size100to120countF)
age19Size100to120F = WHERE((Age_Gro[Size100to120] EQ 19) AND (Sex_Gro[Size100to120] EQ 1), Age19Size100to120countF)
age20Size100to120F = WHERE((Age_Gro[Size100to120] EQ 20) AND (Sex_Gro[Size100to120] EQ 1), Age20Size100to120countF)
age21Size100to120F = WHERE((Age_Gro[Size100to120] EQ 21) AND (Sex_Gro[Size100to120] EQ 1), Age21Size100to120countF)
age22Size100to120F = WHERE((Age_Gro[Size100to120] EQ 22) AND (Sex_Gro[Size100to120] EQ 1), Age22Size100to120countF)
age23Size100to120F = WHERE((Age_Gro[Size100to120] EQ 23) AND (Sex_Gro[Size100to120] EQ 1), Age23Size100to120countF)
age24Size100to120F = WHERE((Age_Gro[Size100to120] EQ 24) AND (Sex_Gro[Size100to120] EQ 1), Age24Size100to120countF)
age25Size100to120F = WHERE((Age_Gro[Size100to120] EQ 25) AND (Sex_Gro[Size100to120] EQ 1), Age25Size100to120countF)
age26Size100to120F = WHERE((Age_Gro[Size100to120] EQ 26) AND (Sex_Gro[Size100to120] EQ 1), Age26Size100to120countF)

  WAE_length_bin[70, i*NumLengthBin+adj+1L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+1L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+1L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+1L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+1L] = 100
  WAE_length_bin[75, i*NumLengthBin+adj+1L] = Size100to120countF

  WAE_length_bin[76, i*NumLengthBin+adj+1L] = Age0Size100to120countF
  WAE_length_bin[77, i*NumLengthBin+adj+1L] = Age1Size100to120countF
  WAE_length_bin[78, i*NumLengthBin+adj+1L] = Age2Size100to120countF
  WAE_length_bin[79, i*NumLengthBin+adj+1L] = Age3Size100to120countF
  WAE_length_bin[80, i*NumLengthBin+adj+1L] = Age4Size100to120countF
  WAE_length_bin[81, i*NumLengthBin+adj+1L] = Age5Size100to120countF
  WAE_length_bin[82, i*NumLengthBin+adj+1L] = Age6Size100to120countF
  WAE_length_bin[83, i*NumLengthBin+adj+1L] = Age7Size100to120countF
  WAE_length_bin[84, i*NumLengthBin+adj+1L] = Age8Size100to120countF
  WAE_length_bin[85, i*NumLengthBin+adj+1L] = Age9Size100to120countF
  WAE_length_bin[86, i*NumLengthBin+adj+1L] = Age10Size100to120countF
  WAE_length_bin[87, i*NumLengthBin+adj+1L] = Age11Size100to120countF
  WAE_length_bin[88, i*NumLengthBin+adj+1L] = Age12Size100to120countF
  WAE_length_bin[89, i*NumLengthBin+adj+1L] = Age13Size100to120countF
  WAE_length_bin[90, i*NumLengthBin+adj+1L] = Age14Size100to120countF
  WAE_length_bin[91, i*NumLengthBin+adj+1L] = Age15Size100to120countF
  WAE_length_bin[92, i*NumLengthBin+adj+1L] = Age16Size100to120countF
  WAE_length_bin[93, i*NumLengthBin+adj+1L] = Age17Size100to120countF
  WAE_length_bin[94, i*NumLengthBin+adj+1L] = Age18Size100to120countF
  WAE_length_bin[95, i*NumLengthBin+adj+1L] = Age19Size100to120countF
  WAE_length_bin[96, i*NumLengthBin+adj+1L] = Age20Size100to120countF
  WAE_length_bin[97, i*NumLengthBin+adj+1L] = Age21Size100to120countF
  WAE_length_bin[98, i*NumLengthBin+adj+1L] = Age22Size100to120countF
  WAE_length_bin[99, i*NumLengthBin+adj+1L] = Age23Size100to120countF
  WAE_length_bin[100, i*NumLengthBin+adj+1L] = Age24Size100to120countF
  WAE_length_bin[101, i*NumLengthBin+adj+1L] = Age25Size100to120countF
  WAE_length_bin[102, i*NumLengthBin+adj+1L] = Age26Size100to120countF
ENDIF
PRINT, 'Size100to120F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+1L])


; length bin 3
IF Size120to140countF GT 0 THEN BEGIN
age0Size120to140F = WHERE((Age_Gro[Size120to140] EQ 1) AND (Sex_Gro[Size120to140] EQ 1), Age0Size120to140countF)
age1Size120to140F = WHERE((Age_Gro[Size120to140] EQ 1) AND (Sex_Gro[Size120to140] EQ 1), Age1Size120to140countF)
age2Size120to140F = WHERE((Age_Gro[Size120to140] EQ 2) AND (Sex_Gro[Size120to140] EQ 1), Age2Size120to140countF)
age3Size120to140F = WHERE((Age_Gro[Size120to140] EQ 3) AND (Sex_Gro[Size120to140] EQ 1), Age3Size120to140countF)
age4Size120to140F = WHERE((Age_Gro[Size120to140] EQ 4) AND (Sex_Gro[Size120to140] EQ 1), Age4Size120to140countF)
age5Size120to140F = WHERE((Age_Gro[Size120to140] EQ 5) AND (Sex_Gro[Size120to140] EQ 1), Age5Size120to140countF)
age6Size120to140F = WHERE((Age_Gro[Size120to140] EQ 6) AND (Sex_Gro[Size120to140] EQ 1), Age6Size120to140countF)
age7Size120to140F = WHERE((Age_Gro[Size120to140] EQ 7) AND (Sex_Gro[Size120to140] EQ 1), Age7Size120to140countF)
age8Size120to140F = WHERE((Age_Gro[Size120to140] EQ 8) AND (Sex_Gro[Size120to140] EQ 1), Age8Size120to140countF)
age9Size120to140F = WHERE((Age_Gro[Size120to140] EQ 9) AND (Sex_Gro[Size120to140] EQ 1), Age9Size120to140countF)
age10Size120to140F = WHERE((Age_Gro[Size120to140] EQ 10) AND (Sex_Gro[Size120to140] EQ 1), Age10Size120to140countF)
age11Size120to140F = WHERE((Age_Gro[Size120to140] EQ 11) AND (Sex_Gro[Size120to140] EQ 1), Age11Size120to140countF)
AGE12Size120to140F = WHERE((Age_Gro[Size120to140] EQ 12) AND (Sex_Gro[Size120to140] EQ 1), Age12Size120to140countF)
AGE13Size120to140F = WHERE((Age_Gro[Size120to140] EQ 13) AND (Sex_Gro[Size120to140] EQ 1), Age13Size120to140countF)
AGE14Size120to140F = WHERE((Age_Gro[Size120to140] EQ 14) AND (Sex_Gro[Size120to140] EQ 1), Age14Size120to140countF)
AGE15Size120to140F = WHERE((Age_Gro[Size120to140] EQ 15) AND (Sex_Gro[Size120to140] EQ 1), Age15Size120to140countF)
age16Size120to140F = WHERE((Age_Gro[Size120to140] EQ 16) AND (Sex_Gro[Size120to140] EQ 1), Age16Size120to140countF)
age17Size120to140F = WHERE((Age_Gro[Size120to140] EQ 17) AND (Sex_Gro[Size120to140] EQ 1), Age17Size120to140countF)
age18Size120to140F = WHERE((Age_Gro[Size120to140] EQ 18) AND (Sex_Gro[Size120to140] EQ 1), Age18Size120to140countF)
age19Size120to140F = WHERE((Age_Gro[Size120to140] EQ 19) AND (Sex_Gro[Size120to140] EQ 1), Age19Size120to140countF)
age20Size120to140F = WHERE((Age_Gro[Size120to140] EQ 20) AND (Sex_Gro[Size120to140] EQ 1), Age20Size120to140countF)
age21Size120to140F = WHERE((Age_Gro[Size120to140] EQ 21) AND (Sex_Gro[Size120to140] EQ 1), Age21Size120to140countF)
age22Size120to140F = WHERE((Age_Gro[Size120to140] EQ 22) AND (Sex_Gro[Size120to140] EQ 1), Age22Size120to140countF)
age23Size120to140F = WHERE((Age_Gro[Size120to140] EQ 23) AND (Sex_Gro[Size120to140] EQ 1), Age23Size120to140countF)
age24Size120to140F = WHERE((Age_Gro[Size120to140] EQ 24) AND (Sex_Gro[Size120to140] EQ 1), Age24Size120to140countF)
age25Size120to140F = WHERE((Age_Gro[Size120to140] EQ 25) AND (Sex_Gro[Size120to140] EQ 1), Age25Size120to140countF)
age26Size120to140F = WHERE((Age_Gro[Size120to140] EQ 26) AND (Sex_Gro[Size120to140] EQ 1), Age26Size120to140countF)

  WAE_length_bin[70, i*NumLengthBin+adj+2L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+2L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+2L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+2L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+2L] = 120
  WAE_length_bin[75, i*NumLengthBin+adj+2L] = Size120to140countF

  WAE_length_bin[76, i*NumLengthBin+adj+2L] = Age0Size120to140countF
  WAE_length_bin[77, i*NumLengthBin+adj+2L] = Age1Size120to140countF
  WAE_length_bin[78, i*NumLengthBin+adj+2L] = Age2Size120to140countF
  WAE_length_bin[79, i*NumLengthBin+adj+2L] = Age3Size120to140countF
  WAE_length_bin[80, i*NumLengthBin+adj+2L] = Age4Size120to140countF
  WAE_length_bin[81, i*NumLengthBin+adj+2L] = Age5Size120to140countF
  WAE_length_bin[82, i*NumLengthBin+adj+2L] = Age6Size120to140countF
  WAE_length_bin[83, i*NumLengthBin+adj+2L] = Age7Size120to140countF
  WAE_length_bin[84, i*NumLengthBin+adj+2L] = Age8Size120to140countF
  WAE_length_bin[85, i*NumLengthBin+adj+2L] = Age9Size120to140countF
  WAE_length_bin[86, i*NumLengthBin+adj+2L] = Age10Size120to140countF
  WAE_length_bin[87, i*NumLengthBin+adj+2L] = Age11Size120to140countF
  WAE_length_bin[88, i*NumLengthBin+adj+2L] = Age12Size120to140countF
  WAE_length_bin[89, i*NumLengthBin+adj+2L] = Age13Size120to140countF
  WAE_length_bin[90, i*NumLengthBin+adj+2L] = Age14Size120to140countF
  WAE_length_bin[91, i*NumLengthBin+adj+2L] = Age15Size120to140countF
  WAE_length_bin[92, i*NumLengthBin+adj+2L] = Age16Size120to140countF
  WAE_length_bin[93, i*NumLengthBin+adj+2L] = Age17Size120to140countF
  WAE_length_bin[94, i*NumLengthBin+adj+2L] = Age18Size120to140countF
  WAE_length_bin[95, i*NumLengthBin+adj+2L] = Age19Size120to140countF
  WAE_length_bin[96, i*NumLengthBin+adj+2L] = Age20Size120to140countF
  WAE_length_bin[97, i*NumLengthBin+adj+2L] = Age21Size120to140countF
  WAE_length_bin[98, i*NumLengthBin+adj+2L] = Age22Size120to140countF
  WAE_length_bin[99, i*NumLengthBin+adj+2L] = Age23Size120to140countF
  WAE_length_bin[100, i*NumLengthBin+adj+2L] = Age24Size120to140countF
  WAE_length_bin[101, i*NumLengthBin+adj+2L] = Age25Size120to140countF
  WAE_length_bin[102, i*NumLengthBin+adj+2L] = Age26Size120to140countF
ENDIF
PRINT, 'Size120to140F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+2L])

; length bin 4
IF Size140to160countF GT 0 THEN BEGIN
age0Size140to160F = WHERE((Age_Gro[Size140to160] EQ 1) AND (Sex_Gro[Size140to160] EQ 1), Age0Size140to160countF)
age1Size140to160F = WHERE((Age_Gro[Size140to160] EQ 1) AND (Sex_Gro[Size140to160] EQ 1), Age1Size140to160countF)
age2Size140to160F = WHERE((Age_Gro[Size140to160] EQ 2) AND (Sex_Gro[Size140to160] EQ 1), Age2Size140to160countF)
age3Size140to160F = WHERE((Age_Gro[Size140to160] EQ 3) AND (Sex_Gro[Size140to160] EQ 1), Age3Size140to160countF)
age4Size140to160F = WHERE((Age_Gro[Size140to160] EQ 4) AND (Sex_Gro[Size140to160] EQ 1), Age4Size140to160countF)
age5Size140to160F = WHERE((Age_Gro[Size140to160] EQ 5) AND (Sex_Gro[Size140to160] EQ 1), Age5Size140to160countF)
age6Size140to160F = WHERE((Age_Gro[Size140to160] EQ 6) AND (Sex_Gro[Size140to160] EQ 1), Age6Size140to160countF)
age7Size140to160F = WHERE((Age_Gro[Size140to160] EQ 7) AND (Sex_Gro[Size140to160] EQ 1), Age7Size140to160countF)
age8Size140to160F = WHERE((Age_Gro[Size140to160] EQ 8) AND (Sex_Gro[Size140to160] EQ 1), Age8Size140to160countF)
age9Size140to160F = WHERE((Age_Gro[Size140to160] EQ 9) AND (Sex_Gro[Size140to160] EQ 1), Age9Size140to160countF)
age10Size140to160F = WHERE((Age_Gro[Size140to160] EQ 10) AND (Sex_Gro[Size140to160] EQ 1), Age10Size140to160countF)
age11Size140to160F = WHERE((Age_Gro[Size140to160] EQ 11) AND (Sex_Gro[Size140to160] EQ 1), Age11Size140to160countF)
AGE12Size140to160F = WHERE((Age_Gro[Size140to160] EQ 12) AND (Sex_Gro[Size140to160] EQ 1), Age12Size140to160countF)
AGE13Size140to160F = WHERE((Age_Gro[Size140to160] EQ 13) AND (Sex_Gro[Size140to160] EQ 1), Age13Size140to160countF)
AGE14Size140to160F = WHERE((Age_Gro[Size140to160] EQ 14) AND (Sex_Gro[Size140to160] EQ 1), Age14Size140to160countF)
AGE15Size140to160F = WHERE((Age_Gro[Size140to160] EQ 15) AND (Sex_Gro[Size140to160] EQ 1), Age15Size140to160countF)
age16Size140to160F = WHERE((Age_Gro[Size140to160] EQ 16) AND (Sex_Gro[Size140to160] EQ 1), Age16Size140to160countF)
age17Size140to160F = WHERE((Age_Gro[Size140to160] EQ 17) AND (Sex_Gro[Size140to160] EQ 1), Age17Size140to160countF)
age18Size140to160F = WHERE((Age_Gro[Size140to160] EQ 18) AND (Sex_Gro[Size140to160] EQ 1), Age18Size140to160countF)
age19Size140to160F = WHERE((Age_Gro[Size140to160] EQ 19) AND (Sex_Gro[Size140to160] EQ 1), Age19Size140to160countF)
age20Size140to160F = WHERE((Age_Gro[Size140to160] EQ 20) AND (Sex_Gro[Size140to160] EQ 1), Age20Size140to160countF)
age21Size140to160F = WHERE((Age_Gro[Size140to160] EQ 21) AND (Sex_Gro[Size140to160] EQ 1), Age21Size140to160countF)
age22Size140to160F = WHERE((Age_Gro[Size140to160] EQ 22) AND (Sex_Gro[Size140to160] EQ 1), Age22Size140to160countF)
age23Size140to160F = WHERE((Age_Gro[Size140to160] EQ 23) AND (Sex_Gro[Size140to160] EQ 1), Age23Size140to160countF)
age24Size140to160F = WHERE((Age_Gro[Size140to160] EQ 24) AND (Sex_Gro[Size140to160] EQ 1), Age24Size140to160countF)
age25Size140to160F = WHERE((Age_Gro[Size140to160] EQ 25) AND (Sex_Gro[Size140to160] EQ 1), Age25Size140to160countF)
age26Size140to160F = WHERE((Age_Gro[Size140to160] EQ 26) AND (Sex_Gro[Size140to160] EQ 1), Age26Size140to160countF)

  WAE_length_bin[70, i*NumLengthBin+adj+3L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+3L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+3L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+3L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+3L] = 140
  WAE_length_bin[75, i*NumLengthBin+adj+3L] = Size140to160countF

  WAE_length_bin[76, i*NumLengthBin+adj+3L] = Age0Size140to160countF
  WAE_length_bin[77, i*NumLengthBin+adj+3L] = Age1Size140to160countF
  WAE_length_bin[78, i*NumLengthBin+adj+3L] = Age2Size140to160countF
  WAE_length_bin[79, i*NumLengthBin+adj+3L] = Age3Size140to160countF
  WAE_length_bin[80, i*NumLengthBin+adj+3L] = Age4Size140to160countF
  WAE_length_bin[81, i*NumLengthBin+adj+3L] = Age5Size140to160countF
  WAE_length_bin[82, i*NumLengthBin+adj+3L] = Age6Size140to160countF
  WAE_length_bin[83, i*NumLengthBin+adj+3L] = Age7Size140to160countF
  WAE_length_bin[84, i*NumLengthBin+adj+3L] = Age8Size140to160countF
  WAE_length_bin[85, i*NumLengthBin+adj+3L] = Age9Size140to160countF
  WAE_length_bin[86, i*NumLengthBin+adj+3L] = Age10Size140to160countF
  WAE_length_bin[87, i*NumLengthBin+adj+3L] = Age11Size140to160countF
  WAE_length_bin[88, i*NumLengthBin+adj+3L] = Age12Size140to160countF
  WAE_length_bin[89, i*NumLengthBin+adj+3L] = Age13Size140to160countF
  WAE_length_bin[90, i*NumLengthBin+adj+3L] = Age14Size140to160countF
  WAE_length_bin[91, i*NumLengthBin+adj+3L] = Age15Size140to160countF
  WAE_length_bin[92, i*NumLengthBin+adj+3L] = Age16Size140to160countF
  WAE_length_bin[93, i*NumLengthBin+adj+3L] = Age17Size140to160countF
  WAE_length_bin[94, i*NumLengthBin+adj+3L] = Age18Size140to160countF
  WAE_length_bin[95, i*NumLengthBin+adj+3L] = Age19Size140to160countF
  WAE_length_bin[96, i*NumLengthBin+adj+3L] = Age20Size140to160countF
  WAE_length_bin[97, i*NumLengthBin+adj+3L] = Age21Size140to160countF
  WAE_length_bin[98, i*NumLengthBin+adj+3L] = Age22Size140to160countF
  WAE_length_bin[99, i*NumLengthBin+adj+3L] = Age23Size140to160countF
  WAE_length_bin[100, i*NumLengthBin+adj+3L] = Age24Size140to160countF
  WAE_length_bin[101, i*NumLengthBin+adj+3L] = Age25Size140to160countF
  WAE_length_bin[102, i*NumLengthBin+adj+3L] = Age26Size140to160countF
ENDIF
PRINT, 'Size140to160F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+3L])

; length bin 5
IF Size160to180countF GT 0 THEN BEGIN
age0Size160to180F = WHERE((Age_Gro[Size160to180] EQ 1) AND (Sex_Gro[Size160to180] EQ 1), Age0Size160to180countF)
age1Size160to180F = WHERE((Age_Gro[Size160to180] EQ 1) AND (Sex_Gro[Size160to180] EQ 1), Age1Size160to180countF)
age2Size160to180F = WHERE((Age_Gro[Size160to180] EQ 2) AND (Sex_Gro[Size160to180] EQ 1), Age2Size160to180countF)
age3Size160to180F = WHERE((Age_Gro[Size160to180] EQ 3) AND (Sex_Gro[Size160to180] EQ 1), Age3Size160to180countF)
age4Size160to180F = WHERE((Age_Gro[Size160to180] EQ 4) AND (Sex_Gro[Size160to180] EQ 1), Age4Size160to180countF)
age5Size160to180F = WHERE((Age_Gro[Size160to180] EQ 5) AND (Sex_Gro[Size160to180] EQ 1), Age5Size160to180countF)
age6Size160to180F = WHERE((Age_Gro[Size160to180] EQ 6) AND (Sex_Gro[Size160to180] EQ 1), Age6Size160to180countF)
age7Size160to180F = WHERE((Age_Gro[Size160to180] EQ 7) AND (Sex_Gro[Size160to180] EQ 1), Age7Size160to180countF)
age8Size160to180F = WHERE((Age_Gro[Size160to180] EQ 8) AND (Sex_Gro[Size160to180] EQ 1), Age8Size160to180countF)
age9Size160to180F = WHERE((Age_Gro[Size160to180] EQ 9) AND (Sex_Gro[Size160to180] EQ 1), Age9Size160to180countF)
age10Size160to180F = WHERE((Age_Gro[Size160to180] EQ 10) AND (Sex_Gro[Size160to180] EQ 1), Age10Size160to180countF)
age11Size160to180F = WHERE((Age_Gro[Size160to180] EQ 11) AND (Sex_Gro[Size160to180] EQ 1), Age11Size160to180countF)
AGE12Size160to180F = WHERE((Age_Gro[Size160to180] EQ 12) AND (Sex_Gro[Size160to180] EQ 1), Age12Size160to180countF)
AGE13Size160to180F = WHERE((Age_Gro[Size160to180] EQ 13) AND (Sex_Gro[Size160to180] EQ 1), Age13Size160to180countF)
AGE14Size160to180F = WHERE((Age_Gro[Size160to180] EQ 14) AND (Sex_Gro[Size160to180] EQ 1), Age14Size160to180countF)
AGE15Size160to180F = WHERE((Age_Gro[Size160to180] EQ 15) AND (Sex_Gro[Size160to180] EQ 1), Age15Size160to180countF)
age16Size160to180F = WHERE((Age_Gro[Size160to180] EQ 16) AND (Sex_Gro[Size160to180] EQ 1), Age16Size160to180countF)
age17Size160to180F = WHERE((Age_Gro[Size160to180] EQ 17) AND (Sex_Gro[Size160to180] EQ 1), Age17Size160to180countF)
age18Size160to180F = WHERE((Age_Gro[Size160to180] EQ 18) AND (Sex_Gro[Size160to180] EQ 1), Age18Size160to180countF)
age19Size160to180F = WHERE((Age_Gro[Size160to180] EQ 19) AND (Sex_Gro[Size160to180] EQ 1), Age19Size160to180countF)
age20Size160to180F = WHERE((Age_Gro[Size160to180] EQ 20) AND (Sex_Gro[Size160to180] EQ 1), Age20Size160to180countF)
age21Size160to180F = WHERE((Age_Gro[Size160to180] EQ 21) AND (Sex_Gro[Size160to180] EQ 1), Age21Size160to180countF)
age22Size160to180F = WHERE((Age_Gro[Size160to180] EQ 22) AND (Sex_Gro[Size160to180] EQ 1), Age22Size160to180countF)
age23Size160to180F = WHERE((Age_Gro[Size160to180] EQ 23) AND (Sex_Gro[Size160to180] EQ 1), Age23Size160to180countF)
age24Size160to180F = WHERE((Age_Gro[Size160to180] EQ 24) AND (Sex_Gro[Size160to180] EQ 1), Age24Size160to180countF)
age25Size160to180F = WHERE((Age_Gro[Size160to180] EQ 25) AND (Sex_Gro[Size160to180] EQ 1), Age25Size160to180countF)
age26Size160to180F = WHERE((Age_Gro[Size160to180] EQ 26) AND (Sex_Gro[Size160to180] EQ 1), Age26Size160to180countF)

  WAE_length_bin[70, i*NumLengthBin+adj+4L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+4L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+4L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+4L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+4L] = 160
  WAE_length_bin[75, i*NumLengthBin+adj+4L] = Size160to180countF

  WAE_length_bin[76, i*NumLengthBin+adj+4L] = Age0Size160to180countF
  WAE_length_bin[77, i*NumLengthBin+adj+4L] = Age1Size160to180countF
  WAE_length_bin[78, i*NumLengthBin+adj+4L] = Age2Size160to180countF
  WAE_length_bin[79, i*NumLengthBin+adj+4L] = Age3Size160to180countF
  WAE_length_bin[80, i*NumLengthBin+adj+4L] = Age4Size160to180countF
  WAE_length_bin[81, i*NumLengthBin+adj+4L] = Age5Size160to180countF
  WAE_length_bin[82, i*NumLengthBin+adj+4L] = Age6Size160to180countF
  WAE_length_bin[83, i*NumLengthBin+adj+4L] = Age7Size160to180countF
  WAE_length_bin[84, i*NumLengthBin+adj+4L] = Age8Size160to180countF
  WAE_length_bin[85, i*NumLengthBin+adj+4L] = Age9Size160to180countF
  WAE_length_bin[86, i*NumLengthBin+adj+4L] = Age10Size160to180countF
  WAE_length_bin[87, i*NumLengthBin+adj+4L] = Age11Size160to180countF
  WAE_length_bin[88, i*NumLengthBin+adj+4L] = Age12Size160to180countF
  WAE_length_bin[89, i*NumLengthBin+adj+4L] = Age13Size160to180countF
  WAE_length_bin[90, i*NumLengthBin+adj+4L] = Age14Size160to180countF
  WAE_length_bin[91, i*NumLengthBin+adj+4L] = Age15Size160to180countF
  WAE_length_bin[92, i*NumLengthBin+adj+4L] = Age16Size160to180countF
  WAE_length_bin[93, i*NumLengthBin+adj+4L] = Age17Size160to180countF
  WAE_length_bin[94, i*NumLengthBin+adj+4L] = Age18Size160to180countF
  WAE_length_bin[95, i*NumLengthBin+adj+4L] = Age19Size160to180countF
  WAE_length_bin[96, i*NumLengthBin+adj+4L] = Age20Size160to180countF
  WAE_length_bin[97, i*NumLengthBin+adj+4L] = Age21Size160to180countF
  WAE_length_bin[98, i*NumLengthBin+adj+4L] = Age22Size160to180countF
  WAE_length_bin[99, i*NumLengthBin+adj+4L] = Age23Size160to180countF
  WAE_length_bin[100, i*NumLengthBin+adj+4L] = Age24Size160to180countF
  WAE_length_bin[101, i*NumLengthBin+adj+4L] = Age25Size160to180countF
  WAE_length_bin[102, i*NumLengthBin+adj+4L] = Age26Size160to180countF
  ENDIF
PRINT, 'Size160to180F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+4L])

; length bin 6
IF Size180to200countF GT 0 THEN BEGIN
age0Size180to200F = WHERE((Age_Gro[Size180to200] EQ 1) AND (Sex_Gro[Size180to200] EQ 1), Age0Size180to200countF)
age1Size180to200F = WHERE((Age_Gro[Size180to200] EQ 1) AND (Sex_Gro[Size180to200] EQ 1), Age1Size180to200countF)
age2Size180to200F = WHERE((Age_Gro[Size180to200] EQ 2) AND (Sex_Gro[Size180to200] EQ 1), Age2Size180to200countF)
age3Size180to200F = WHERE((Age_Gro[Size180to200] EQ 3) AND (Sex_Gro[Size180to200] EQ 1), Age3Size180to200countF)
age4Size180to200F = WHERE((Age_Gro[Size180to200] EQ 4) AND (Sex_Gro[Size180to200] EQ 1), Age4Size180to200countF)
age5Size180to200F = WHERE((Age_Gro[Size180to200] EQ 5) AND (Sex_Gro[Size180to200] EQ 1), Age5Size180to200countF)
age6Size180to200F = WHERE((Age_Gro[Size180to200] EQ 6) AND (Sex_Gro[Size180to200] EQ 1), Age6Size180to200countF)
age7Size180to200F = WHERE((Age_Gro[Size180to200] EQ 7) AND (Sex_Gro[Size180to200] EQ 1), Age7Size180to200countF)
age8Size180to200F = WHERE((Age_Gro[Size180to200] EQ 8) AND (Sex_Gro[Size180to200] EQ 1), Age8Size180to200countF)
age9Size180to200F = WHERE((Age_Gro[Size180to200] EQ 9) AND (Sex_Gro[Size180to200] EQ 1), Age9Size180to200countF)
age10Size180to200F = WHERE((Age_Gro[Size180to200] EQ 10) AND (Sex_Gro[Size180to200] EQ 1), Age10Size180to200countF)
age11Size180to200F = WHERE((Age_Gro[Size180to200] EQ 11) AND (Sex_Gro[Size180to200] EQ 1), Age11Size180to200countF)
AGE12Size180to200F = WHERE((Age_Gro[Size180to200] EQ 12) AND (Sex_Gro[Size180to200] EQ 1), Age12Size180to200countF)
AGE13Size180to200F = WHERE((Age_Gro[Size180to200] EQ 13) AND (Sex_Gro[Size180to200] EQ 1), Age13Size180to200countF)
AGE14Size180to200F = WHERE((Age_Gro[Size180to200] EQ 14) AND (Sex_Gro[Size180to200] EQ 1), Age14Size180to200countF)
AGE15Size180to200F = WHERE((Age_Gro[Size180to200] EQ 15) AND (Sex_Gro[Size180to200] EQ 1), Age15Size180to200countF)
age16Size180to200F = WHERE((Age_Gro[Size180to200] EQ 16) AND (Sex_Gro[Size180to200] EQ 1), Age16Size180to200countF)
age17Size180to200F = WHERE((Age_Gro[Size180to200] EQ 17) AND (Sex_Gro[Size180to200] EQ 1), Age17Size180to200countF)
age18Size180to200F = WHERE((Age_Gro[Size180to200] EQ 18) AND (Sex_Gro[Size180to200] EQ 1), Age18Size180to200countF)
age19Size180to200F = WHERE((Age_Gro[Size180to200] EQ 19) AND (Sex_Gro[Size180to200] EQ 1), Age19Size180to200countF)
age20Size180to200F = WHERE((Age_Gro[Size180to200] EQ 20) AND (Sex_Gro[Size180to200] EQ 1), Age20Size180to200countF)
age21Size180to200F = WHERE((Age_Gro[Size180to200] EQ 21) AND (Sex_Gro[Size180to200] EQ 1), Age21Size180to200countF)
age22Size180to200F = WHERE((Age_Gro[Size180to200] EQ 22) AND (Sex_Gro[Size180to200] EQ 1), Age22Size180to200countF)
age23Size180to200F = WHERE((Age_Gro[Size180to200] EQ 23) AND (Sex_Gro[Size180to200] EQ 1), Age23Size180to200countF)
age24Size180to200F = WHERE((Age_Gro[Size180to200] EQ 24) AND (Sex_Gro[Size180to200] EQ 1), Age24Size180to200countF)
age25Size180to200F = WHERE((Age_Gro[Size180to200] EQ 25) AND (Sex_Gro[Size180to200] EQ 1), Age25Size180to200countF)
age26Size180to200F = WHERE((Age_Gro[Size180to200] EQ 26) AND (Sex_Gro[Size180to200] EQ 1), Age26Size180to200countF)

  WAE_length_bin[70, i*NumLengthBin+adj+5L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+5L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+5L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+5L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+5L] = 180
  WAE_length_bin[75, i*NumLengthBin+adj+5L] = Size180to200countF

  WAE_length_bin[76, i*NumLengthBin+adj+5L] = Age0Size180to200countF
  WAE_length_bin[77, i*NumLengthBin+adj+5L] = Age1Size180to200countF
  WAE_length_bin[78, i*NumLengthBin+adj+5L] = Age2Size180to200countF
  WAE_length_bin[79, i*NumLengthBin+adj+5L] = Age3Size180to200countF
  WAE_length_bin[80, i*NumLengthBin+adj+5L] = Age4Size180to200countF
  WAE_length_bin[81, i*NumLengthBin+adj+5L] = Age5Size180to200countF
  WAE_length_bin[82, i*NumLengthBin+adj+5L] = Age6Size180to200countF
  WAE_length_bin[83, i*NumLengthBin+adj+5L] = Age7Size180to200countF
  WAE_length_bin[84, i*NumLengthBin+adj+5L] = Age8Size180to200countF
  WAE_length_bin[85, i*NumLengthBin+adj+5L] = Age9Size180to200countF
  WAE_length_bin[86, i*NumLengthBin+adj+5L] = Age10Size180to200countF
  WAE_length_bin[87, i*NumLengthBin+adj+5L] = Age11Size180to200countF
  WAE_length_bin[88, i*NumLengthBin+adj+5L] = Age12Size180to200countF
  WAE_length_bin[89, i*NumLengthBin+adj+5L] = Age13Size180to200countF
  WAE_length_bin[90, i*NumLengthBin+adj+5L] = Age14Size180to200countF
  WAE_length_bin[91, i*NumLengthBin+adj+5L] = Age15Size180to200countF
  WAE_length_bin[92, i*NumLengthBin+adj+5L] = Age16Size180to200countF
  WAE_length_bin[93, i*NumLengthBin+adj+5L] = Age17Size180to200countF
  WAE_length_bin[94, i*NumLengthBin+adj+5L] = Age18Size180to200countF
  WAE_length_bin[95, i*NumLengthBin+adj+5L] = Age19Size180to200countF
  WAE_length_bin[96, i*NumLengthBin+adj+5L] = Age20Size180to200countF
  WAE_length_bin[97, i*NumLengthBin+adj+5L] = Age21Size180to200countF
  WAE_length_bin[98, i*NumLengthBin+adj+5L] = Age22Size180to200countF
  WAE_length_bin[99, i*NumLengthBin+adj+5L] = Age23Size180to200countF
  WAE_length_bin[100, i*NumLengthBin+adj+5L] = Age24Size180to200countF
  WAE_length_bin[101, i*NumLengthBin+adj+5L] = Age25Size180to200countF
  WAE_length_bin[102, i*NumLengthBin+adj+5L] = Age26Size180to200countF
  ENDIF
PRINT, 'Size180to200F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+5L])

; length bin 7
IF Size200to220countF GT 0 THEN BEGIN
age0Size200to220F = WHERE((Age_Gro[Size200to220] EQ 1) AND (Sex_Gro[Size200to220] EQ 1), Age0Size200to220countF)
age1Size200to220F = WHERE((Age_Gro[Size200to220] EQ 1) AND (Sex_Gro[Size200to220] EQ 1), Age1Size200to220countF)
age2Size200to220F = WHERE((Age_Gro[Size200to220] EQ 2) AND (Sex_Gro[Size200to220] EQ 1), Age2Size200to220countF)
age3Size200to220F = WHERE((Age_Gro[Size200to220] EQ 3) AND (Sex_Gro[Size200to220] EQ 1), Age3Size200to220countF)
age4Size200to220F = WHERE((Age_Gro[Size200to220] EQ 4) AND (Sex_Gro[Size200to220] EQ 1), Age4Size200to220countF)
age5Size200to220F = WHERE((Age_Gro[Size200to220] EQ 5) AND (Sex_Gro[Size200to220] EQ 1), Age5Size200to220countF)
age6Size200to220F = WHERE((Age_Gro[Size200to220] EQ 6) AND (Sex_Gro[Size200to220] EQ 1), Age6Size200to220countF)
age7Size200to220F = WHERE((Age_Gro[Size200to220] EQ 7) AND (Sex_Gro[Size200to220] EQ 1), Age7Size200to220countF)
age8Size200to220F = WHERE((Age_Gro[Size200to220] EQ 8) AND (Sex_Gro[Size200to220] EQ 1), Age8Size200to220countF)
age9Size200to220F = WHERE((Age_Gro[Size200to220] EQ 9) AND (Sex_Gro[Size200to220] EQ 1), Age9Size200to220countF)
age10Size200to220F = WHERE((Age_Gro[Size200to220] EQ 10) AND (Sex_Gro[Size200to220] EQ 1), Age10Size200to220countF)
age11Size200to220F = WHERE((Age_Gro[Size200to220] EQ 11) AND (Sex_Gro[Size200to220] EQ 1), Age11Size200to220countF)
AGE12Size200to220F = WHERE((Age_Gro[Size200to220] EQ 12) AND (Sex_Gro[Size200to220] EQ 1), Age12Size200to220countF)
AGE13Size200to220F = WHERE((Age_Gro[Size200to220] EQ 13) AND (Sex_Gro[Size200to220] EQ 1), Age13Size200to220countF)
AGE14Size200to220F = WHERE((Age_Gro[Size200to220] EQ 14) AND (Sex_Gro[Size200to220] EQ 1), Age14Size200to220countF)
AGE15Size200to220F = WHERE((Age_Gro[Size200to220] EQ 15) AND (Sex_Gro[Size200to220] EQ 1), Age15Size200to220countF)
age16Size200to220F = WHERE((Age_Gro[Size200to220] EQ 16) AND (Sex_Gro[Size200to220] EQ 1), Age16Size200to220countF)
age17Size200to220F = WHERE((Age_Gro[Size200to220] EQ 17) AND (Sex_Gro[Size200to220] EQ 1), Age17Size200to220countF)
age18Size200to220F = WHERE((Age_Gro[Size200to220] EQ 18) AND (Sex_Gro[Size200to220] EQ 1), Age18Size200to220countF)
age19Size200to220F = WHERE((Age_Gro[Size200to220] EQ 19) AND (Sex_Gro[Size200to220] EQ 1), Age19Size200to220countF)
age20Size200to220F = WHERE((Age_Gro[Size200to220] EQ 20) AND (Sex_Gro[Size200to220] EQ 1), Age20Size200to220countF)
age21Size200to220F = WHERE((Age_Gro[Size200to220] EQ 21) AND (Sex_Gro[Size200to220] EQ 1), Age21Size200to220countF)
age22Size200to220F = WHERE((Age_Gro[Size200to220] EQ 22) AND (Sex_Gro[Size200to220] EQ 1), Age22Size200to220countF)
age23Size200to220F = WHERE((Age_Gro[Size200to220] EQ 23) AND (Sex_Gro[Size200to220] EQ 1), Age23Size200to220countF)
age24Size200to220F = WHERE((Age_Gro[Size200to220] EQ 24) AND (Sex_Gro[Size200to220] EQ 1), Age24Size200to220countF)
age25Size200to220F = WHERE((Age_Gro[Size200to220] EQ 25) AND (Sex_Gro[Size200to220] EQ 1), Age25Size200to220countF)
age26Size200to220F = WHERE((Age_Gro[Size200to220] EQ 26) AND (Sex_Gro[Size200to220] EQ 1), Age26Size200to220countF)

  WAE_length_bin[70, i*NumLengthBin+adj+6L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+6L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+6L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+6L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+6L] = 200
  WAE_length_bin[75, i*NumLengthBin+adj+6L] = Size200to220countF

  WAE_length_bin[76, i*NumLengthBin+adj+6L] = Age0Size200to220countF
  WAE_length_bin[77, i*NumLengthBin+adj+6L] = Age1Size200to220countF
  WAE_length_bin[78, i*NumLengthBin+adj+6L] = Age2Size200to220countF
  WAE_length_bin[79, i*NumLengthBin+adj+6L] = Age3Size200to220countF
  WAE_length_bin[80, i*NumLengthBin+adj+6L] = Age4Size200to220countF
  WAE_length_bin[81, i*NumLengthBin+adj+6L] = Age5Size200to220countF
  WAE_length_bin[82, i*NumLengthBin+adj+6L] = Age6Size200to220countF
  WAE_length_bin[83, i*NumLengthBin+adj+6L] = Age7Size200to220countF
  WAE_length_bin[84, i*NumLengthBin+adj+6L] = Age8Size200to220countF
  WAE_length_bin[85, i*NumLengthBin+adj+6L] = Age9Size200to220countF
  WAE_length_bin[86, i*NumLengthBin+adj+6L] = Age10Size200to220countF
  WAE_length_bin[87, i*NumLengthBin+adj+6L] = Age11Size200to220countF
  WAE_length_bin[88, i*NumLengthBin+adj+6L] = Age12Size200to220countF
  WAE_length_bin[89, i*NumLengthBin+adj+6L] = Age13Size200to220countF
  WAE_length_bin[90, i*NumLengthBin+adj+6L] = Age14Size200to220countF
  WAE_length_bin[91, i*NumLengthBin+adj+6L] = Age15Size200to220countF
  WAE_length_bin[92, i*NumLengthBin+adj+6L] = Age16Size200to220countF
  WAE_length_bin[93, i*NumLengthBin+adj+6L] = Age17Size200to220countF
  WAE_length_bin[94, i*NumLengthBin+adj+6L] = Age18Size200to220countF
  WAE_length_bin[95, i*NumLengthBin+adj+6L] = Age19Size200to220countF
  WAE_length_bin[96, i*NumLengthBin+adj+6L] = Age20Size200to220countF
  WAE_length_bin[97, i*NumLengthBin+adj+6L] = Age21Size200to220countF
  WAE_length_bin[98, i*NumLengthBin+adj+6L] = Age22Size200to220countF
  WAE_length_bin[99, i*NumLengthBin+adj+6L] = Age23Size200to220countF
  WAE_length_bin[100, i*NumLengthBin+adj+6L] = Age24Size200to220countF
  WAE_length_bin[101, i*NumLengthBin+adj+6L] = Age25Size200to220countF
  WAE_length_bin[102, i*NumLengthBin+adj+6L] = Age26Size200to220countF
  ENDIF
PRINT, 'Size200to220F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+6L])

; length bin 8
IF Size220to240countF GT 0 THEN BEGIN
age0Size220to240M = WHERE((Age_Gro[Size220to240] EQ 0) AND (Sex_Gro[Size220to240] EQ 0), Age0Size220to240countM)
age1Size220to240M = WHERE((Age_Gro[Size220to240] EQ 1) AND (Sex_Gro[Size220to240] EQ 0), Age1Size220to240countM)
age2Size220to240M = WHERE((Age_Gro[Size220to240] EQ 2) AND (Sex_Gro[Size220to240] EQ 0), Age2Size220to240countM)
age3Size220to240M = WHERE((Age_Gro[Size220to240] EQ 3) AND (Sex_Gro[Size220to240] EQ 0), Age3Size220to240countM)
age4Size220to240M = WHERE((Age_Gro[Size220to240] EQ 4) AND (Sex_Gro[Size220to240] EQ 0), Age4Size220to240countM)
age5Size220to240M = WHERE((Age_Gro[Size220to240] EQ 5) AND (Sex_Gro[Size220to240] EQ 0), Age5Size220to240countM)
age6Size220to240M = WHERE((Age_Gro[Size220to240] EQ 6) AND (Sex_Gro[Size220to240] EQ 0), Age6Size220to240countM)
age7Size220to240M = WHERE((Age_Gro[Size220to240] EQ 7) AND (Sex_Gro[Size220to240] EQ 0), Age7Size220to240countM)
age8Size220to240M = WHERE((Age_Gro[Size220to240] EQ 8) AND (Sex_Gro[Size220to240] EQ 0), Age8Size220to240countM)
age9Size220to240M = WHERE((Age_Gro[Size220to240] EQ 9) AND (Sex_Gro[Size220to240] EQ 0), Age9Size220to240countM)
age10Size220to240M = WHERE((Age_Gro[Size220to240] EQ 10) AND (Sex_Gro[Size220to240] EQ 0), Age10Size220to240countM)
age11Size220to240M = WHERE((Age_Gro[Size220to240] EQ 11) AND (Sex_Gro[Size220to240] EQ 0), Age11Size220to240countM)
AGE12Size220to240M = WHERE((Age_Gro[Size220to240] EQ 12) AND (Sex_Gro[Size220to240] EQ 0), Age12Size220to240countM)
AGE13Size220to240M = WHERE((Age_Gro[Size220to240] EQ 13) AND (Sex_Gro[Size220to240] EQ 0), Age13Size220to240countM)
AGE14Size220to240M = WHERE((Age_Gro[Size220to240] EQ 14) AND (Sex_Gro[Size220to240] EQ 0), Age14Size220to240countM)
AGE15Size220to240M = WHERE((Age_Gro[Size220to240] EQ 15) AND (Sex_Gro[Size220to240] EQ 0), Age15Size220to240countM)
age16Size220to240M = WHERE((Age_Gro[Size220to240] EQ 16) AND (Sex_Gro[Size220to240] EQ 0), Age16Size220to240countM)
age17Size220to240M = WHERE((Age_Gro[Size220to240] EQ 17) AND (Sex_Gro[Size220to240] EQ 0), Age17Size220to240countM)
age18Size220to240M = WHERE((Age_Gro[Size220to240] EQ 18) AND (Sex_Gro[Size220to240] EQ 0), Age18Size220to240countM)
age19Size220to240M = WHERE((Age_Gro[Size220to240] EQ 19) AND (Sex_Gro[Size220to240] EQ 0), Age19Size220to240countM)
age20Size220to240M = WHERE((Age_Gro[Size220to240] EQ 20) AND (Sex_Gro[Size220to240] EQ 0), Age20Size220to240countM)
age21Size220to240M = WHERE((Age_Gro[Size220to240] EQ 21) AND (Sex_Gro[Size220to240] EQ 0), Age21Size220to240countM)
age22Size220to240M = WHERE((Age_Gro[Size220to240] EQ 22) AND (Sex_Gro[Size220to240] EQ 0), Age22Size220to240countM)
age23Size220to240M = WHERE((Age_Gro[Size220to240] EQ 23) AND (Sex_Gro[Size220to240] EQ 0), Age23Size220to240countM)
age24Size220to240M = WHERE((Age_Gro[Size220to240] EQ 24) AND (Sex_Gro[Size220to240] EQ 0), Age24Size220to240countM)
age25Size220to240M = WHERE((Age_Gro[Size220to240] EQ 25) AND (Sex_Gro[Size220to240] EQ 0), Age25Size220to240countM)
age26Size220to240M = WHERE((Age_Gro[Size220to240] EQ 26) AND (Sex_Gro[Size220to240] EQ 0), Age26Size220to240countM)

  WAE_length_bin[70, i*NumLengthBin+adj+7L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+7L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+7L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+7L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+7L] = 220
  WAE_length_bin[75, i*NumLengthBin+adj+7L] =Size220to240countF

  WAE_length_bin[76, i*NumLengthBin+adj+7L] = Age0Size220to240countF
  WAE_length_bin[77, i*NumLengthBin+adj+7L] = Age1Size220to240countF
  WAE_length_bin[78, i*NumLengthBin+adj+7L] = Age2Size220to240countF
  WAE_length_bin[79, i*NumLengthBin+adj+7L] = Age3Size220to240countF
  WAE_length_bin[80, i*NumLengthBin+adj+7L] = Age4Size220to240countF
  WAE_length_bin[81, i*NumLengthBin+adj+7L] = Age5Size220to240countF
  WAE_length_bin[82, i*NumLengthBin+adj+7L] = Age6Size220to240countF
  WAE_length_bin[83, i*NumLengthBin+adj+7L] = Age7Size220to240countF
  WAE_length_bin[84, i*NumLengthBin+adj+7L] = Age8Size220to240countF
  WAE_length_bin[85, i*NumLengthBin+adj+7L] = Age9Size220to240countF
  WAE_length_bin[86, i*NumLengthBin+adj+7L] = Age10Size220to240countF
  WAE_length_bin[87, i*NumLengthBin+adj+7L] = Age11Size220to240countF
  WAE_length_bin[88, i*NumLengthBin+adj+7L] = Age12Size220to240countF
  WAE_length_bin[89, i*NumLengthBin+adj+7L] = Age13Size220to240countF
  WAE_length_bin[90, i*NumLengthBin+adj+7L] = Age14Size220to240countF
  WAE_length_bin[91, i*NumLengthBin+adj+7L] = Age15Size220to240countF
  WAE_length_bin[92, i*NumLengthBin+adj+7L] = Age16Size220to240countF
  WAE_length_bin[93, i*NumLengthBin+adj+7L] = Age17Size220to240countF
  WAE_length_bin[94, i*NumLengthBin+adj+7L] = Age18Size220to240countF
  WAE_length_bin[95, i*NumLengthBin+adj+7L] = Age19Size220to240countF
  WAE_length_bin[96, i*NumLengthBin+adj+7L] = Age20Size220to240countF
  WAE_length_bin[97, i*NumLengthBin+adj+7L] = Age21Size220to240countF
  WAE_length_bin[98, i*NumLengthBin+adj+7L] = Age22Size220to240countF
  WAE_length_bin[99, i*NumLengthBin+adj+7L] = Age23Size220to240countF
  WAE_length_bin[100, i*NumLengthBin+adj+7L] = Age24Size220to240countF
  WAE_length_bin[101, i*NumLengthBin+adj+7L] = Age25Size220to240countF
  WAE_length_bin[102, i*NumLengthBin+adj+7L] = Age26Size220to240countF
  ENDIF
PRINT, 'Size220to240F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+7L])

; length bin 9
IF Size240to260countF GT 0 THEN BEGIN
age0Size240to260F = WHERE((Age_Gro[Size240to260] EQ 1) AND (Sex_Gro[Size240to260] EQ 1), Age0Size240to260countF)
age1Size240to260F = WHERE((Age_Gro[Size240to260] EQ 1) AND (Sex_Gro[Size240to260] EQ 1), Age1Size240to260countF)
age2Size240to260F = WHERE((Age_Gro[Size240to260] EQ 2) AND (Sex_Gro[Size240to260] EQ 1), Age2Size240to260countF)
age3Size240to260F = WHERE((Age_Gro[Size240to260] EQ 3) AND (Sex_Gro[Size240to260] EQ 1), Age3Size240to260countF)
age4Size240to260F = WHERE((Age_Gro[Size240to260] EQ 4) AND (Sex_Gro[Size240to260] EQ 1), Age4Size240to260countF)
age5Size240to260F = WHERE((Age_Gro[Size240to260] EQ 5) AND (Sex_Gro[Size240to260] EQ 1), Age5Size240to260countF)
age6Size240to260F = WHERE((Age_Gro[Size240to260] EQ 6) AND (Sex_Gro[Size240to260] EQ 1), Age6Size240to260countF)
age7Size240to260F = WHERE((Age_Gro[Size240to260] EQ 7) AND (Sex_Gro[Size240to260] EQ 1), Age7Size240to260countF)
age8Size240to260F = WHERE((Age_Gro[Size240to260] EQ 8) AND (Sex_Gro[Size240to260] EQ 1), Age8Size240to260countF)
age9Size240to260F = WHERE((Age_Gro[Size240to260] EQ 9) AND (Sex_Gro[Size240to260] EQ 1), Age9Size240to260countF)
age10Size240to260F = WHERE((Age_Gro[Size240to260] EQ 10) AND (Sex_Gro[Size240to260] EQ 1), Age10Size240to260countF)
age11Size240to260F = WHERE((Age_Gro[Size240to260] EQ 11) AND (Sex_Gro[Size240to260] EQ 1), Age11Size240to260countF)
AGE12Size240to260F = WHERE((Age_Gro[Size240to260] EQ 12) AND (Sex_Gro[Size240to260] EQ 1), Age12Size240to260countF)
AGE13Size240to260F = WHERE((Age_Gro[Size240to260] EQ 13) AND (Sex_Gro[Size240to260] EQ 1), Age13Size240to260countF)
AGE14Size240to260F = WHERE((Age_Gro[Size240to260] EQ 14) AND (Sex_Gro[Size240to260] EQ 1), Age14Size240to260countF)
AGE15Size240to260F = WHERE((Age_Gro[Size240to260] EQ 15) AND (Sex_Gro[Size240to260] EQ 1), Age15Size240to260countF)
age16Size240to260F = WHERE((Age_Gro[Size240to260] EQ 16) AND (Sex_Gro[Size240to260] EQ 1), Age16Size240to260countF)
age17Size240to260F = WHERE((Age_Gro[Size240to260] EQ 17) AND (Sex_Gro[Size240to260] EQ 1), Age17Size240to260countF)
age18Size240to260F = WHERE((Age_Gro[Size240to260] EQ 18) AND (Sex_Gro[Size240to260] EQ 1), Age18Size240to260countF)
age19Size240to260F = WHERE((Age_Gro[Size240to260] EQ 19) AND (Sex_Gro[Size240to260] EQ 1), Age19Size240to260countF)
age20Size240to260F = WHERE((Age_Gro[Size240to260] EQ 20) AND (Sex_Gro[Size240to260] EQ 1), Age20Size240to260countF)
age21Size240to260F = WHERE((Age_Gro[Size240to260] EQ 21) AND (Sex_Gro[Size240to260] EQ 1), Age21Size240to260countF)
age22Size240to260F = WHERE((Age_Gro[Size240to260] EQ 22) AND (Sex_Gro[Size240to260] EQ 1), Age22Size240to260countF)
age23Size240to260F = WHERE((Age_Gro[Size240to260] EQ 23) AND (Sex_Gro[Size240to260] EQ 1), Age23Size240to260countF)
age24Size240to260F = WHERE((Age_Gro[Size240to260] EQ 24) AND (Sex_Gro[Size240to260] EQ 1), Age24Size240to260countF)
age25Size240to260F = WHERE((Age_Gro[Size240to260] EQ 25) AND (Sex_Gro[Size240to260] EQ 1), Age25Size240to260countF)
age26Size240to260F = WHERE((Age_Gro[Size240to260] EQ 26) AND (Sex_Gro[Size240to260] EQ 1), Age26Size240to260countF)

  WAE_length_bin[70, i*NumLengthBin+adj+8L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+8L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+8L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+8L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+8L] = 180
  WAE_length_bin[75, i*NumLengthBin+adj+8L] =Size240to260countF

  WAE_length_bin[76, i*NumLengthBin+adj+8L] = Age0Size240to260countF
  WAE_length_bin[77, i*NumLengthBin+adj+8L] = Age1Size240to260countF
  WAE_length_bin[78, i*NumLengthBin+adj+8L] = Age2Size240to260countF
  WAE_length_bin[79, i*NumLengthBin+adj+8L] = Age3Size240to260countF
  WAE_length_bin[80, i*NumLengthBin+adj+8L] = Age4Size240to260countF
  WAE_length_bin[81, i*NumLengthBin+adj+8L] = Age5Size240to260countF
  WAE_length_bin[82, i*NumLengthBin+adj+8L] = Age6Size240to260countF
  WAE_length_bin[83, i*NumLengthBin+adj+8L] = Age7Size240to260countF
  WAE_length_bin[84, i*NumLengthBin+adj+8L] = Age8Size240to260countF
  WAE_length_bin[85, i*NumLengthBin+adj+8L] = Age9Size240to260countF
  WAE_length_bin[86, i*NumLengthBin+adj+8L] = Age10Size240to260countF
  WAE_length_bin[87, i*NumLengthBin+adj+8L] = Age11Size240to260countF
  WAE_length_bin[88, i*NumLengthBin+adj+8L] = Age12Size240to260countF
  WAE_length_bin[89, i*NumLengthBin+adj+8L] = Age13Size240to260countF
  WAE_length_bin[90, i*NumLengthBin+adj+8L] = Age14Size240to260countF
  WAE_length_bin[91, i*NumLengthBin+adj+8L] = Age15Size240to260countF
  WAE_length_bin[92, i*NumLengthBin+adj+8L] = Age16Size240to260countF
  WAE_length_bin[93, i*NumLengthBin+adj+8L] = Age17Size240to260countF
  WAE_length_bin[94, i*NumLengthBin+adj+8L] = Age18Size240to260countF
  WAE_length_bin[95, i*NumLengthBin+adj+8L] = Age19Size240to260countF
  WAE_length_bin[96, i*NumLengthBin+adj+8L] = Age20Size240to260countF
  WAE_length_bin[97, i*NumLengthBin+adj+8L] = Age21Size240to260countF
  WAE_length_bin[98, i*NumLengthBin+adj+8L] = Age22Size240to260countF
  WAE_length_bin[99, i*NumLengthBin+adj+8L] = Age23Size240to260countF
  WAE_length_bin[100, i*NumLengthBin+adj+8L] = Age24Size240to260countF
  WAE_length_bin[101, i*NumLengthBin+adj+8L] = Age25Size240to260countF
  WAE_length_bin[102, i*NumLengthBin+adj+8L] = Age26Size240to260countF
  ENDIF
PRINT, 'Size240to260F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+8L])

; length bin 10
IF Size260to280countF GT 0 THEN BEGIN
age0Size260to280F = WHERE((Age_Gro[Size260to280] EQ 1) AND (Sex_Gro[Size260to280] EQ 1), Age0Size260to280countF)
age1Size260to280F = WHERE((Age_Gro[Size260to280] EQ 1) AND (Sex_Gro[Size260to280] EQ 1), Age1Size260to280countF)
age2Size260to280F = WHERE((Age_Gro[Size260to280] EQ 2) AND (Sex_Gro[Size260to280] EQ 1), Age2Size260to280countF)
age3Size260to280F = WHERE((Age_Gro[Size260to280] EQ 3) AND (Sex_Gro[Size260to280] EQ 1), Age3Size260to280countF)
age4Size260to280F = WHERE((Age_Gro[Size260to280] EQ 4) AND (Sex_Gro[Size260to280] EQ 1), Age4Size260to280countF)
age5Size260to280F = WHERE((Age_Gro[Size260to280] EQ 5) AND (Sex_Gro[Size260to280] EQ 1), Age5Size260to280countF)
age6Size260to280F = WHERE((Age_Gro[Size260to280] EQ 6) AND (Sex_Gro[Size260to280] EQ 1), Age6Size260to280countF)
age7Size260to280F = WHERE((Age_Gro[Size260to280] EQ 7) AND (Sex_Gro[Size260to280] EQ 1), Age7Size260to280countF)
age8Size260to280F = WHERE((Age_Gro[Size260to280] EQ 8) AND (Sex_Gro[Size260to280] EQ 1), Age8Size260to280countF)
age9Size260to280F = WHERE((Age_Gro[Size260to280] EQ 9) AND (Sex_Gro[Size260to280] EQ 1), Age9Size260to280countF)
age10Size260to280F = WHERE((Age_Gro[Size260to280] EQ 10) AND (Sex_Gro[Size260to280] EQ 1), Age10Size260to280countF)
age11Size260to280F = WHERE((Age_Gro[Size260to280] EQ 11) AND (Sex_Gro[Size260to280] EQ 1), Age11Size260to280countF)
AGE12Size260to280F = WHERE((Age_Gro[Size260to280] EQ 12) AND (Sex_Gro[Size260to280] EQ 1), Age12Size260to280countF)
AGE13Size260to280F = WHERE((Age_Gro[Size260to280] EQ 13) AND (Sex_Gro[Size260to280] EQ 1), Age13Size260to280countF)
AGE14Size260to280F = WHERE((Age_Gro[Size260to280] EQ 14) AND (Sex_Gro[Size260to280] EQ 1), Age14Size260to280countF)
AGE15Size260to280F = WHERE((Age_Gro[Size260to280] EQ 15) AND (Sex_Gro[Size260to280] EQ 1), Age15Size260to280countF)
age16Size260to280F = WHERE((Age_Gro[Size260to280] EQ 16) AND (Sex_Gro[Size260to280] EQ 1), Age16Size260to280countF)
age17Size260to280F = WHERE((Age_Gro[Size260to280] EQ 17) AND (Sex_Gro[Size260to280] EQ 1), Age17Size260to280countF)
age18Size260to280F = WHERE((Age_Gro[Size260to280] EQ 18) AND (Sex_Gro[Size260to280] EQ 1), Age18Size260to280countF)
age19Size260to280F = WHERE((Age_Gro[Size260to280] EQ 19) AND (Sex_Gro[Size260to280] EQ 1), Age19Size260to280countF)
age20Size260to280F = WHERE((Age_Gro[Size260to280] EQ 20) AND (Sex_Gro[Size260to280] EQ 1), Age20Size260to280countF)
age21Size260to280F = WHERE((Age_Gro[Size260to280] EQ 21) AND (Sex_Gro[Size260to280] EQ 1), Age21Size260to280countF)
age22Size260to280F = WHERE((Age_Gro[Size260to280] EQ 22) AND (Sex_Gro[Size260to280] EQ 1), Age22Size260to280countF)
age23Size260to280F = WHERE((Age_Gro[Size260to280] EQ 23) AND (Sex_Gro[Size260to280] EQ 1), Age23Size260to280countF)
age24Size260to280F = WHERE((Age_Gro[Size260to280] EQ 24) AND (Sex_Gro[Size260to280] EQ 1), Age24Size260to280countF)
age25Size260to280F = WHERE((Age_Gro[Size260to280] EQ 25) AND (Sex_Gro[Size260to280] EQ 1), Age25Size260to280countF)
age26Size260to280F = WHERE((Age_Gro[Size260to280] EQ 26) AND (Sex_Gro[Size260to280] EQ 1), Age26Size260to280countF)

  WAE_length_bin[70, i*NumLengthBin+adj+9L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+9L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+9L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+9L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+9L] = 260
  WAE_length_bin[75, i*NumLengthBin+adj+9L] =Size260to280countF

  WAE_length_bin[76, i*NumLengthBin+adj+9L] = Age0Size260to280countF
  WAE_length_bin[77, i*NumLengthBin+adj+9L] = Age1Size260to280countF
  WAE_length_bin[78, i*NumLengthBin+adj+9L] = Age2Size260to280countF
  WAE_length_bin[79, i*NumLengthBin+adj+9L] = Age3Size260to280countF
  WAE_length_bin[80, i*NumLengthBin+adj+9L] = Age4Size260to280countF
  WAE_length_bin[81, i*NumLengthBin+adj+9L] = Age5Size260to280countF
  WAE_length_bin[82, i*NumLengthBin+adj+9L] = Age6Size260to280countF
  WAE_length_bin[83, i*NumLengthBin+adj+9L] = Age7Size260to280countF
  WAE_length_bin[84, i*NumLengthBin+adj+9L] = Age8Size260to280countF
  WAE_length_bin[85, i*NumLengthBin+adj+9L] = Age9Size260to280countF
  WAE_length_bin[86, i*NumLengthBin+adj+9L] = Age10Size260to280countF
  WAE_length_bin[87, i*NumLengthBin+adj+9L] = Age11Size260to280countF
  WAE_length_bin[88, i*NumLengthBin+adj+9L] = Age12Size260to280countF
  WAE_length_bin[89, i*NumLengthBin+adj+9L] = Age13Size260to280countF
  WAE_length_bin[90, i*NumLengthBin+adj+9L] = Age14Size260to280countF
  WAE_length_bin[91, i*NumLengthBin+adj+9L] = Age15Size260to280countF
  WAE_length_bin[92, i*NumLengthBin+adj+9L] = Age16Size260to280countF
  WAE_length_bin[93, i*NumLengthBin+adj+9L] = Age17Size260to280countF
  WAE_length_bin[94, i*NumLengthBin+adj+9L] = Age18Size260to280countF
  WAE_length_bin[95, i*NumLengthBin+adj+9L] = Age19Size260to280countF
  WAE_length_bin[96, i*NumLengthBin+adj+9L] = Age20Size260to280countF
  WAE_length_bin[97, i*NumLengthBin+adj+9L] = Age21Size260to280countF
  WAE_length_bin[98, i*NumLengthBin+adj+9L] = Age22Size260to280countF
  WAE_length_bin[99, i*NumLengthBin+adj+9L] = Age23Size260to280countF
  WAE_length_bin[100, i*NumLengthBin+adj+9L] = Age24Size260to280countF
  WAE_length_bin[101, i*NumLengthBin+adj+9L] = Age25Size260to280countF
  WAE_length_bin[102, i*NumLengthBin+adj+9L] = Age26Size260to280countF
  ENDIF
PRINT, 'Size260to280F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+9L])

; length bin 11
IF Size280to300countF GT 0 THEN BEGIN
age0Size280to300F = WHERE((Age_Gro[Size280to300] EQ 1) AND (Sex_Gro[Size280to300] EQ 1), Age0Size280to300countF)
age1Size280to300F = WHERE((Age_Gro[Size280to300] EQ 1) AND (Sex_Gro[Size280to300] EQ 1), Age1Size280to300countF)
age2Size280to300F = WHERE((Age_Gro[Size280to300] EQ 2) AND (Sex_Gro[Size280to300] EQ 1), Age2Size280to300countF)
age3Size280to300F = WHERE((Age_Gro[Size280to300] EQ 3) AND (Sex_Gro[Size280to300] EQ 1), Age3Size280to300countF)
age4Size280to300F = WHERE((Age_Gro[Size280to300] EQ 4) AND (Sex_Gro[Size280to300] EQ 1), Age4Size280to300countF)
age5Size280to300F = WHERE((Age_Gro[Size280to300] EQ 5) AND (Sex_Gro[Size280to300] EQ 1), Age5Size280to300countF)
age6Size280to300F = WHERE((Age_Gro[Size280to300] EQ 6) AND (Sex_Gro[Size280to300] EQ 1), Age6Size280to300countF)
age7Size280to300F = WHERE((Age_Gro[Size280to300] EQ 7) AND (Sex_Gro[Size280to300] EQ 1), Age7Size280to300countF)
age8Size280to300F = WHERE((Age_Gro[Size280to300] EQ 8) AND (Sex_Gro[Size280to300] EQ 1), Age8Size280to300countF)
age9Size280to300F = WHERE((Age_Gro[Size280to300] EQ 9) AND (Sex_Gro[Size280to300] EQ 1), Age9Size280to300countF)
age10Size280to300F = WHERE((Age_Gro[Size280to300] EQ 10) AND (Sex_Gro[Size280to300] EQ 1), Age10Size280to300countF)
age11Size280to300F = WHERE((Age_Gro[Size280to300] EQ 11) AND (Sex_Gro[Size280to300] EQ 1), Age11Size280to300countF)
AGE12Size280to300F = WHERE((Age_Gro[Size280to300] EQ 12) AND (Sex_Gro[Size280to300] EQ 1), Age12Size280to300countF)
AGE13Size280to300F = WHERE((Age_Gro[Size280to300] EQ 13) AND (Sex_Gro[Size280to300] EQ 1), Age13Size280to300countF)
AGE14Size280to300F = WHERE((Age_Gro[Size280to300] EQ 14) AND (Sex_Gro[Size280to300] EQ 1), Age14Size280to300countF)
AGE15Size280to300F = WHERE((Age_Gro[Size280to300] EQ 15) AND (Sex_Gro[Size280to300] EQ 1), Age15Size280to300countF)
age16Size280to300F = WHERE((Age_Gro[Size280to300] EQ 16) AND (Sex_Gro[Size280to300] EQ 1), Age16Size280to300countF)
age17Size280to300F = WHERE((Age_Gro[Size280to300] EQ 17) AND (Sex_Gro[Size280to300] EQ 1), Age17Size280to300countF)
age18Size280to300F = WHERE((Age_Gro[Size280to300] EQ 18) AND (Sex_Gro[Size280to300] EQ 1), Age18Size280to300countF)
age19Size280to300F = WHERE((Age_Gro[Size280to300] EQ 19) AND (Sex_Gro[Size280to300] EQ 1), Age19Size280to300countF)
age20Size280to300F = WHERE((Age_Gro[Size280to300] EQ 20) AND (Sex_Gro[Size280to300] EQ 1), Age20Size280to300countF)
age21Size280to300F = WHERE((Age_Gro[Size280to300] EQ 21) AND (Sex_Gro[Size280to300] EQ 1), Age21Size280to300countF)
age22Size280to300F = WHERE((Age_Gro[Size280to300] EQ 22) AND (Sex_Gro[Size280to300] EQ 1), Age22Size280to300countF)
age23Size280to300F = WHERE((Age_Gro[Size280to300] EQ 23) AND (Sex_Gro[Size280to300] EQ 1), Age23Size280to300countF)
age24Size280to300F = WHERE((Age_Gro[Size280to300] EQ 24) AND (Sex_Gro[Size280to300] EQ 1), Age24Size280to300countF)
age25Size280to300F = WHERE((Age_Gro[Size280to300] EQ 25) AND (Sex_Gro[Size280to300] EQ 1), Age25Size280to300countF)
age26Size280to300F = WHERE((Age_Gro[Size280to300] EQ 26) AND (Sex_Gro[Size280to300] EQ 1), Age26Size280to300countF)

  WAE_length_bin[70, i*NumLengthBin+adj+10L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+10L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+10L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+10L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+10L] = 280
  WAE_length_bin[75, i*NumLengthBin+adj+10L] = Size280to300countF

  WAE_length_bin[76, i*NumLengthBin+adj+10L] = Age0Size280to300countF
  WAE_length_bin[77, i*NumLengthBin+adj+10L] = Age1Size280to300countF
  WAE_length_bin[78, i*NumLengthBin+adj+10L] = Age2Size280to300countF
  WAE_length_bin[79, i*NumLengthBin+adj+10L] = Age3Size280to300countF
  WAE_length_bin[80, i*NumLengthBin+adj+10L] = Age4Size280to300countF
  WAE_length_bin[81, i*NumLengthBin+adj+10L] = Age5Size280to300countF
  WAE_length_bin[82, i*NumLengthBin+adj+10L] = Age6Size280to300countF
  WAE_length_bin[83, i*NumLengthBin+adj+10L] = Age7Size280to300countF
  WAE_length_bin[84, i*NumLengthBin+adj+10L] = Age8Size280to300countF
  WAE_length_bin[85, i*NumLengthBin+adj+10L] = Age9Size280to300countF
  WAE_length_bin[86, i*NumLengthBin+adj+10L] = Age10Size280to300countF
  WAE_length_bin[87, i*NumLengthBin+adj+10L] = Age11Size280to300countF
  WAE_length_bin[88, i*NumLengthBin+adj+10L] = Age12Size280to300countF
  WAE_length_bin[89, i*NumLengthBin+adj+10L] = Age13Size280to300countF
  WAE_length_bin[90, i*NumLengthBin+adj+10L] = Age14Size280to300countF
  WAE_length_bin[91, i*NumLengthBin+adj+10L] = Age15Size280to300countF
  WAE_length_bin[92, i*NumLengthBin+adj+10L] = Age16Size280to300countF
  WAE_length_bin[93, i*NumLengthBin+adj+10L] = Age17Size280to300countF
  WAE_length_bin[94, i*NumLengthBin+adj+10L] = Age18Size280to300countF
  WAE_length_bin[95, i*NumLengthBin+adj+10L] = Age19Size280to300countF
  WAE_length_bin[96, i*NumLengthBin+adj+10L] = Age20Size280to300countF
  WAE_length_bin[97, i*NumLengthBin+adj+10L] = Age21Size280to300countF
  WAE_length_bin[98, i*NumLengthBin+adj+10L] = Age22Size280to300countF
  WAE_length_bin[99, i*NumLengthBin+adj+10L] = Age23Size280to300countF
  WAE_length_bin[100, i*NumLengthBin+adj+10L] = Age24Size280to300countF
  WAE_length_bin[101, i*NumLengthBin+adj+10L] = Age25Size280to300countF
  WAE_length_bin[102, i*NumLengthBin+adj+10L] = Age26Size280to300countF
ENDIF
PRINT, 'Size280to300F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+10L])

; length bin 12
IF Size300to320countF GT 0 THEN BEGIN
age0Size300to320F = WHERE((Age_Gro[Size300to320] EQ 1) AND (Sex_Gro[Size300to320] EQ 1), Age0Size300to320countF)
age1Size300to320F = WHERE((Age_Gro[Size300to320] EQ 1) AND (Sex_Gro[Size300to320] EQ 1), Age1Size300to320countF)
age2Size300to320F = WHERE((Age_Gro[Size300to320] EQ 2) AND (Sex_Gro[Size300to320] EQ 1), Age2Size300to320countF)
age3Size300to320F = WHERE((Age_Gro[Size300to320] EQ 3) AND (Sex_Gro[Size300to320] EQ 1), Age3Size300to320countF)
age4Size300to320F = WHERE((Age_Gro[Size300to320] EQ 4) AND (Sex_Gro[Size300to320] EQ 1), Age4Size300to320countF)
age5Size300to320F = WHERE((Age_Gro[Size300to320] EQ 5) AND (Sex_Gro[Size300to320] EQ 1), Age5Size300to320countF)
age6Size300to320F = WHERE((Age_Gro[Size300to320] EQ 6) AND (Sex_Gro[Size300to320] EQ 1), Age6Size300to320countF)
age7Size300to320F = WHERE((Age_Gro[Size300to320] EQ 7) AND (Sex_Gro[Size300to320] EQ 1), Age7Size300to320countF)
age8Size300to320F = WHERE((Age_Gro[Size300to320] EQ 8) AND (Sex_Gro[Size300to320] EQ 1), Age8Size300to320countF)
age9Size300to320F = WHERE((Age_Gro[Size300to320] EQ 9) AND (Sex_Gro[Size300to320] EQ 1), Age9Size300to320countF)
age10Size300to320F = WHERE((Age_Gro[Size300to320] EQ 10) AND (Sex_Gro[Size300to320] EQ 1), Age10Size300to320countF)
age11Size300to320F = WHERE((Age_Gro[Size300to320] EQ 11) AND (Sex_Gro[Size300to320] EQ 1), Age11Size300to320countF)
AGE12Size300to320F = WHERE((Age_Gro[Size300to320] EQ 12) AND (Sex_Gro[Size300to320] EQ 1), Age12Size300to320countF)
AGE13Size300to320F = WHERE((Age_Gro[Size300to320] EQ 13) AND (Sex_Gro[Size300to320] EQ 1), Age13Size300to320countF)
AGE14Size300to320F = WHERE((Age_Gro[Size300to320] EQ 14) AND (Sex_Gro[Size300to320] EQ 1), Age14Size300to320countF)
AGE15Size300to320F = WHERE((Age_Gro[Size300to320] EQ 15) AND (Sex_Gro[Size300to320] EQ 1), Age15Size300to320countF)
age16Size300to320F = WHERE((Age_Gro[Size300to320] EQ 16) AND (Sex_Gro[Size300to320] EQ 1), Age16Size300to320countF)
age17Size300to320F = WHERE((Age_Gro[Size300to320] EQ 17) AND (Sex_Gro[Size300to320] EQ 1), Age17Size300to320countF)
age18Size300to320F = WHERE((Age_Gro[Size300to320] EQ 18) AND (Sex_Gro[Size300to320] EQ 1), Age18Size300to320countF)
age19Size300to320F = WHERE((Age_Gro[Size300to320] EQ 19) AND (Sex_Gro[Size300to320] EQ 1), Age19Size300to320countF)
age20Size300to320F = WHERE((Age_Gro[Size300to320] EQ 20) AND (Sex_Gro[Size300to320] EQ 1), Age20Size300to320countF)
age21Size300to320F = WHERE((Age_Gro[Size300to320] EQ 21) AND (Sex_Gro[Size300to320] EQ 1), Age21Size300to320countF)
age22Size300to320F = WHERE((Age_Gro[Size300to320] EQ 22) AND (Sex_Gro[Size300to320] EQ 1), Age22Size300to320countF)
age23Size300to320F = WHERE((Age_Gro[Size300to320] EQ 23) AND (Sex_Gro[Size300to320] EQ 1), Age23Size300to320countF)
age24Size300to320F = WHERE((Age_Gro[Size300to320] EQ 24) AND (Sex_Gro[Size300to320] EQ 1), Age24Size300to320countF)
age25Size300to320F = WHERE((Age_Gro[Size300to320] EQ 25) AND (Sex_Gro[Size300to320] EQ 1), Age25Size300to320countF)
age26Size300to320F = WHERE((Age_Gro[Size300to320] EQ 26) AND (Sex_Gro[Size300to320] EQ 1), Age26Size300to320countF)

  WAE_length_bin[70, i*NumLengthBin+adj+11L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+11L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+11L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+11L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+11L] = 300
  WAE_length_bin[75, i*NumLengthBin+adj+11L] = Size300to320countF

  WAE_length_bin[76, i*NumLengthBin+adj+11L] = Age0Size300to320countF
  WAE_length_bin[77, i*NumLengthBin+adj+11L] = Age1Size300to320countF
  WAE_length_bin[78, i*NumLengthBin+adj+11L] = Age2Size300to320countF
  WAE_length_bin[79, i*NumLengthBin+adj+11L] = Age3Size300to320countF
  WAE_length_bin[80, i*NumLengthBin+adj+11L] = Age4Size300to320countF
  WAE_length_bin[81, i*NumLengthBin+adj+11L] = Age5Size300to320countF
  WAE_length_bin[82, i*NumLengthBin+adj+11L] = Age6Size300to320countF
  WAE_length_bin[83, i*NumLengthBin+adj+11L] = Age7Size300to320countF
  WAE_length_bin[84, i*NumLengthBin+adj+11L] = Age8Size300to320countF
  WAE_length_bin[85, i*NumLengthBin+adj+11L] = Age9Size300to320countF
  WAE_length_bin[86, i*NumLengthBin+adj+11L] = Age10Size300to320countF
  WAE_length_bin[87, i*NumLengthBin+adj+11L] = Age11Size300to320countF
  WAE_length_bin[88, i*NumLengthBin+adj+11L] = Age12Size300to320countF
  WAE_length_bin[89, i*NumLengthBin+adj+11L] = Age13Size300to320countF
  WAE_length_bin[90, i*NumLengthBin+adj+11L] = Age14Size300to320countF
  WAE_length_bin[91, i*NumLengthBin+adj+11L] = Age15Size300to320countF
  WAE_length_bin[92, i*NumLengthBin+adj+11L] = Age16Size300to320countF
  WAE_length_bin[93, i*NumLengthBin+adj+11L] = Age17Size300to320countF
  WAE_length_bin[94, i*NumLengthBin+adj+11L] = Age18Size300to320countF
  WAE_length_bin[95, i*NumLengthBin+adj+11L] = Age19Size300to320countF
  WAE_length_bin[96, i*NumLengthBin+adj+11L] = Age20Size300to320countF
  WAE_length_bin[97, i*NumLengthBin+adj+11L] = Age21Size300to320countF
  WAE_length_bin[98, i*NumLengthBin+adj+11L] = Age22Size300to320countF
  WAE_length_bin[99, i*NumLengthBin+adj+11L] = Age23Size300to320countF
  WAE_length_bin[100, i*NumLengthBin+adj+11L] = Age24Size300to320countF
  WAE_length_bin[101, i*NumLengthBin+adj+11L] = Age25Size300to320countF
  WAE_length_bin[102, i*NumLengthBin+adj+11L] = Age26Size300to320countF
  ENDIF
PRINT, 'Size300to320F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+11L])

; length bin 13
IF Size320to340countF GT 0 THEN BEGIN
age0Size320to340F = WHERE((Age_Gro[Size320to340] EQ 1) AND (Sex_Gro[Size320to340] EQ 1), Age0Size320to340countF)
age1Size320to340F = WHERE((Age_Gro[Size320to340] EQ 1) AND (Sex_Gro[Size320to340] EQ 1), Age1Size320to340countF)
age2Size320to340F = WHERE((Age_Gro[Size320to340] EQ 2) AND (Sex_Gro[Size320to340] EQ 1), Age2Size320to340countF)
age3Size320to340F = WHERE((Age_Gro[Size320to340] EQ 3) AND (Sex_Gro[Size320to340] EQ 1), Age3Size320to340countF)
age4Size320to340F = WHERE((Age_Gro[Size320to340] EQ 4) AND (Sex_Gro[Size320to340] EQ 1), Age4Size320to340countF)
age5Size320to340F = WHERE((Age_Gro[Size320to340] EQ 5) AND (Sex_Gro[Size320to340] EQ 1), Age5Size320to340countF)
age6Size320to340F = WHERE((Age_Gro[Size320to340] EQ 6) AND (Sex_Gro[Size320to340] EQ 1), Age6Size320to340countF)
age7Size320to340F = WHERE((Age_Gro[Size320to340] EQ 7) AND (Sex_Gro[Size320to340] EQ 1), Age7Size320to340countF)
age8Size320to340F = WHERE((Age_Gro[Size320to340] EQ 8) AND (Sex_Gro[Size320to340] EQ 1), Age8Size320to340countF)
age9Size320to340F = WHERE((Age_Gro[Size320to340] EQ 9) AND (Sex_Gro[Size320to340] EQ 1), Age9Size320to340countF)
age10Size320to340F = WHERE((Age_Gro[Size320to340] EQ 10) AND (Sex_Gro[Size320to340] EQ 1), Age10Size320to340countF)
age11Size320to340F = WHERE((Age_Gro[Size320to340] EQ 11) AND (Sex_Gro[Size320to340] EQ 1), Age11Size320to340countF)
AGE12Size320to340F = WHERE((Age_Gro[Size320to340] EQ 12) AND (Sex_Gro[Size320to340] EQ 1), Age12Size320to340countF)
AGE13Size320to340F = WHERE((Age_Gro[Size320to340] EQ 13) AND (Sex_Gro[Size320to340] EQ 1), Age13Size320to340countF)
AGE14Size320to340F = WHERE((Age_Gro[Size320to340] EQ 14) AND (Sex_Gro[Size320to340] EQ 1), Age14Size320to340countF)
AGE15Size320to340F = WHERE((Age_Gro[Size320to340] EQ 15) AND (Sex_Gro[Size320to340] EQ 1), Age15Size320to340countF)
age16Size320to340F = WHERE((Age_Gro[Size320to340] EQ 16) AND (Sex_Gro[Size320to340] EQ 1), Age16Size320to340countF)
age17Size320to340F = WHERE((Age_Gro[Size320to340] EQ 17) AND (Sex_Gro[Size320to340] EQ 1), Age17Size320to340countF)
age18Size320to340F = WHERE((Age_Gro[Size320to340] EQ 18) AND (Sex_Gro[Size320to340] EQ 1), Age18Size320to340countF)
age19Size320to340F = WHERE((Age_Gro[Size320to340] EQ 19) AND (Sex_Gro[Size320to340] EQ 1), Age19Size320to340countF)
age20Size320to340F = WHERE((Age_Gro[Size320to340] EQ 20) AND (Sex_Gro[Size320to340] EQ 1), Age20Size320to340countF)
age21Size320to340F = WHERE((Age_Gro[Size320to340] EQ 21) AND (Sex_Gro[Size320to340] EQ 1), Age21Size320to340countF)
age22Size320to340F = WHERE((Age_Gro[Size320to340] EQ 22) AND (Sex_Gro[Size320to340] EQ 1), Age22Size320to340countF)
age23Size320to340F = WHERE((Age_Gro[Size320to340] EQ 23) AND (Sex_Gro[Size320to340] EQ 1), Age23Size320to340countF)
age24Size320to340F = WHERE((Age_Gro[Size320to340] EQ 24) AND (Sex_Gro[Size320to340] EQ 1), Age24Size320to340countF)
age25Size320to340F = WHERE((Age_Gro[Size320to340] EQ 25) AND (Sex_Gro[Size320to340] EQ 1), Age25Size320to340countF)
age26Size320to340F = WHERE((Age_Gro[Size320to340] EQ 26) AND (Sex_Gro[Size320to340] EQ 1), Age26Size320to340countF)

  WAE_length_bin[70, i*NumLengthBin+adj+12L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+12L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+12L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+12L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+12L] = 320
  WAE_length_bin[75, i*NumLengthBin+adj+12L] = Size320to340countF

  WAE_length_bin[76, i*NumLengthBin+adj+12L] = Age0Size320to340countF
  WAE_length_bin[77, i*NumLengthBin+adj+12L] = Age1Size320to340countF
  WAE_length_bin[78, i*NumLengthBin+adj+12L] = Age2Size320to340countF
  WAE_length_bin[79, i*NumLengthBin+adj+12L] = Age3Size320to340countF
  WAE_length_bin[80, i*NumLengthBin+adj+12L] = Age4Size320to340countF
  WAE_length_bin[81, i*NumLengthBin+adj+12L] = Age5Size320to340countF
  WAE_length_bin[82, i*NumLengthBin+adj+12L] = Age6Size320to340countF
  WAE_length_bin[83, i*NumLengthBin+adj+12L] = Age7Size320to340countF
  WAE_length_bin[84, i*NumLengthBin+adj+12L] = Age8Size320to340countF
  WAE_length_bin[85, i*NumLengthBin+adj+12L] = Age9Size320to340countF
  WAE_length_bin[86, i*NumLengthBin+adj+12L] = Age10Size320to340countF
  WAE_length_bin[87, i*NumLengthBin+adj+12L] = Age11Size320to340countF
  WAE_length_bin[88, i*NumLengthBin+adj+12L] = Age12Size320to340countF
  WAE_length_bin[89, i*NumLengthBin+adj+12L] = Age13Size320to340countF
  WAE_length_bin[90, i*NumLengthBin+adj+12L] = Age14Size320to340countF
  WAE_length_bin[91, i*NumLengthBin+adj+12L] = Age15Size320to340countF
  WAE_length_bin[92, i*NumLengthBin+adj+12L] = Age16Size320to340countF
  WAE_length_bin[93, i*NumLengthBin+adj+12L] = Age17Size320to340countF
  WAE_length_bin[94, i*NumLengthBin+adj+12L] = Age18Size320to340countF
  WAE_length_bin[95, i*NumLengthBin+adj+12L] = Age19Size320to340countF
  WAE_length_bin[96, i*NumLengthBin+adj+12L] = Age20Size320to340countF
  WAE_length_bin[97, i*NumLengthBin+adj+12L] = Age21Size320to340countF
  WAE_length_bin[98, i*NumLengthBin+adj+12L] = Age22Size320to340countF
  WAE_length_bin[99, i*NumLengthBin+adj+12L] = Age23Size320to340countF
  WAE_length_bin[100, i*NumLengthBin+adj+12L] = Age24Size320to340countF
  WAE_length_bin[101, i*NumLengthBin+adj+12L] = Age25Size320to340countF
  WAE_length_bin[102, i*NumLengthBin+adj+12L] = Age26Size320to340countF
  ENDIF
PRINT, 'Size320to340F', TOTAL(WAE_length_bin[70L:102, i*NumLengthBin+adj+13L])

; length bin 14
IF Size340to360countF GT 0 THEN BEGIN
age0Size340to360F = WHERE((Age_Gro[Size340to360] EQ 1) AND (Sex_Gro[Size340to360] EQ 1), Age0Size340to360countF)
age1Size340to360F = WHERE((Age_Gro[Size340to360] EQ 1) AND (Sex_Gro[Size340to360] EQ 1), Age1Size340to360countF)
age2Size340to360F = WHERE((Age_Gro[Size340to360] EQ 2) AND (Sex_Gro[Size340to360] EQ 1), Age2Size340to360countF)
age3Size340to360F = WHERE((Age_Gro[Size340to360] EQ 3) AND (Sex_Gro[Size340to360] EQ 1), Age3Size340to360countF)
age4Size340to360F = WHERE((Age_Gro[Size340to360] EQ 4) AND (Sex_Gro[Size340to360] EQ 1), Age4Size340to360countF)
age5Size340to360F = WHERE((Age_Gro[Size340to360] EQ 5) AND (Sex_Gro[Size340to360] EQ 1), Age5Size340to360countF)
age6Size340to360F = WHERE((Age_Gro[Size340to360] EQ 6) AND (Sex_Gro[Size340to360] EQ 1), Age6Size340to360countF)
age7Size340to360F = WHERE((Age_Gro[Size340to360] EQ 7) AND (Sex_Gro[Size340to360] EQ 1), Age7Size340to360countF)
age8Size340to360F = WHERE((Age_Gro[Size340to360] EQ 8) AND (Sex_Gro[Size340to360] EQ 1), Age8Size340to360countF)
age9Size340to360F = WHERE((Age_Gro[Size340to360] EQ 9) AND (Sex_Gro[Size340to360] EQ 1), Age9Size340to360countF)
age10Size340to360F = WHERE((Age_Gro[Size340to360] EQ 10) AND (Sex_Gro[Size340to360] EQ 1), Age10Size340to360countF)
age11Size340to360F = WHERE((Age_Gro[Size340to360] EQ 11) AND (Sex_Gro[Size340to360] EQ 1), Age11Size340to360countF)
AGE12Size340to360F = WHERE((Age_Gro[Size340to360] EQ 12) AND (Sex_Gro[Size340to360] EQ 1), Age12Size340to360countF)
AGE13Size340to360F = WHERE((Age_Gro[Size340to360] EQ 13) AND (Sex_Gro[Size340to360] EQ 1), Age13Size340to360countF)
AGE14Size340to360F = WHERE((Age_Gro[Size340to360] EQ 14) AND (Sex_Gro[Size340to360] EQ 1), Age14Size340to360countF)
AGE15Size340to360F = WHERE((Age_Gro[Size340to360] EQ 15) AND (Sex_Gro[Size340to360] EQ 1), Age15Size340to360countF)
age16Size340to360F = WHERE((Age_Gro[Size340to360] EQ 16) AND (Sex_Gro[Size340to360] EQ 1), Age16Size340to360countF)
age17Size340to360F = WHERE((Age_Gro[Size340to360] EQ 17) AND (Sex_Gro[Size340to360] EQ 1), Age17Size340to360countF)
age18Size340to360F = WHERE((Age_Gro[Size340to360] EQ 18) AND (Sex_Gro[Size340to360] EQ 1), Age18Size340to360countF)
age19Size340to360F = WHERE((Age_Gro[Size340to360] EQ 19) AND (Sex_Gro[Size340to360] EQ 1), Age19Size340to360countF)
age20Size340to360F = WHERE((Age_Gro[Size340to360] EQ 20) AND (Sex_Gro[Size340to360] EQ 1), Age20Size340to360countF)
age21Size340to360F = WHERE((Age_Gro[Size340to360] EQ 21) AND (Sex_Gro[Size340to360] EQ 1), Age21Size340to360countF)
age22Size340to360F = WHERE((Age_Gro[Size340to360] EQ 22) AND (Sex_Gro[Size340to360] EQ 1), Age22Size340to360countF)
age23Size340to360F = WHERE((Age_Gro[Size340to360] EQ 23) AND (Sex_Gro[Size340to360] EQ 1), Age23Size340to360countF)
age24Size340to360F = WHERE((Age_Gro[Size340to360] EQ 24) AND (Sex_Gro[Size340to360] EQ 1), Age24Size340to360countF)
age25Size340to360F = WHERE((Age_Gro[Size340to360] EQ 25) AND (Sex_Gro[Size340to360] EQ 1), Age25Size340to360countF)
age26Size340to360F = WHERE((Age_Gro[Size340to360] EQ 26) AND (Sex_Gro[Size340to360] EQ 1), Age26Size340to360countF)

  WAE_length_bin[70, i*NumLengthBin+adj+13L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+13L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+13L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+13L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+13L] = 340
  WAE_length_bin[75, i*NumLengthBin+adj+14L] = Size340to360countF

  WAE_length_bin[76, i*NumLengthBin+adj+13L] = Age0Size340to360countF
  WAE_length_bin[77, i*NumLengthBin+adj+13L] = Age1Size340to360countF
  WAE_length_bin[78, i*NumLengthBin+adj+13L] = Age2Size340to360countF
  WAE_length_bin[79, i*NumLengthBin+adj+13L] = Age3Size340to360countF
  WAE_length_bin[80, i*NumLengthBin+adj+13L] = Age4Size340to360countF
  WAE_length_bin[81, i*NumLengthBin+adj+13L] = Age5Size340to360countF
  WAE_length_bin[82, i*NumLengthBin+adj+13L] = Age6Size340to360countF
  WAE_length_bin[83, i*NumLengthBin+adj+13L] = Age7Size340to360countF
  WAE_length_bin[84, i*NumLengthBin+adj+13L] = Age8Size340to360countF
  WAE_length_bin[85, i*NumLengthBin+adj+13L] = Age9Size340to360countF
  WAE_length_bin[86, i*NumLengthBin+adj+13L] = Age10Size340to360countF
  WAE_length_bin[87, i*NumLengthBin+adj+13L] = Age11Size340to360countF
  WAE_length_bin[88, i*NumLengthBin+adj+13L] = Age12Size340to360countF
  WAE_length_bin[89, i*NumLengthBin+adj+13L] = Age13Size340to360countF
  WAE_length_bin[90, i*NumLengthBin+adj+13L] = Age14Size340to360countF
  WAE_length_bin[91, i*NumLengthBin+adj+13L] = Age15Size340to360countF
  WAE_length_bin[92, i*NumLengthBin+adj+13L] = Age16Size340to360countF
  WAE_length_bin[93, i*NumLengthBin+adj+13L] = Age17Size340to360countF
  WAE_length_bin[94, i*NumLengthBin+adj+13L] = Age18Size340to360countF
  WAE_length_bin[95, i*NumLengthBin+adj+13L] = Age19Size340to360countF
  WAE_length_bin[96, i*NumLengthBin+adj+13L] = Age20Size340to360countF
  WAE_length_bin[97, i*NumLengthBin+adj+13L] = Age21Size340to360countF
  WAE_length_bin[98, i*NumLengthBin+adj+13L] = Age22Size340to360countF
  WAE_length_bin[99, i*NumLengthBin+adj+13L] = Age23Size340to360countF
  WAE_length_bin[100, i*NumLengthBin+adj+13L] = Age24Size340to360countF
  WAE_length_bin[101, i*NumLengthBin+adj+13L] = Age25Size340to360countF
  WAE_length_bin[102, i*NumLengthBin+adj+13L] = Age26Size340to360countF
  ENDIF
PRINT, 'Size340to360F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+14L])

; length bin 15
IF Size360to380countF GT 0 THEN BEGIN
age0Size360to380F = WHERE((Age_Gro[Size360to380] EQ 1) AND (Sex_Gro[Size360to380] EQ 1), Age0Size360to380countF)
age1Size360to380F = WHERE((Age_Gro[Size360to380] EQ 1) AND (Sex_Gro[Size360to380] EQ 1), Age1Size360to380countF)
age2Size360to380F = WHERE((Age_Gro[Size360to380] EQ 2) AND (Sex_Gro[Size360to380] EQ 1), Age2Size360to380countF)
age3Size360to380F = WHERE((Age_Gro[Size360to380] EQ 3) AND (Sex_Gro[Size360to380] EQ 1), Age3Size360to380countF)
age4Size360to380F = WHERE((Age_Gro[Size360to380] EQ 4) AND (Sex_Gro[Size360to380] EQ 1), Age4Size360to380countF)
age5Size360to380F = WHERE((Age_Gro[Size360to380] EQ 5) AND (Sex_Gro[Size360to380] EQ 1), Age5Size360to380countF)
age6Size360to380F = WHERE((Age_Gro[Size360to380] EQ 6) AND (Sex_Gro[Size360to380] EQ 1), Age6Size360to380countF)
age7Size360to380F = WHERE((Age_Gro[Size360to380] EQ 7) AND (Sex_Gro[Size360to380] EQ 1), Age7Size360to380countF)
age8Size360to380F = WHERE((Age_Gro[Size360to380] EQ 8) AND (Sex_Gro[Size360to380] EQ 1), Age8Size360to380countF)
age9Size360to380F = WHERE((Age_Gro[Size360to380] EQ 9) AND (Sex_Gro[Size360to380] EQ 1), Age9Size360to380countF)
age10Size360to380F = WHERE((Age_Gro[Size360to380] EQ 10) AND (Sex_Gro[Size360to380] EQ 1), Age10Size360to380countF)
age11Size360to380F = WHERE((Age_Gro[Size360to380] EQ 11) AND (Sex_Gro[Size360to380] EQ 1), Age11Size360to380countF)
AGE12Size360to380F = WHERE((Age_Gro[Size360to380] EQ 12) AND (Sex_Gro[Size360to380] EQ 1), Age12Size360to380countF)
AGE13Size360to380F = WHERE((Age_Gro[Size360to380] EQ 13) AND (Sex_Gro[Size360to380] EQ 1), Age13Size360to380countF)
AGE14Size360to380F = WHERE((Age_Gro[Size360to380] EQ 14) AND (Sex_Gro[Size360to380] EQ 1), Age14Size360to380countF)
AGE15Size360to380F = WHERE((Age_Gro[Size360to380] EQ 15) AND (Sex_Gro[Size360to380] EQ 1), Age15Size360to380countF)
age16Size360to380F = WHERE((Age_Gro[Size360to380] EQ 16) AND (Sex_Gro[Size360to380] EQ 1), Age16Size360to380countF)
age17Size360to380F = WHERE((Age_Gro[Size360to380] EQ 17) AND (Sex_Gro[Size360to380] EQ 1), Age17Size360to380countF)
age18Size360to380F = WHERE((Age_Gro[Size360to380] EQ 18) AND (Sex_Gro[Size360to380] EQ 1), Age18Size360to380countF)
age19Size360to380F = WHERE((Age_Gro[Size360to380] EQ 19) AND (Sex_Gro[Size360to380] EQ 1), Age19Size360to380countF)
age20Size360to380F = WHERE((Age_Gro[Size360to380] EQ 20) AND (Sex_Gro[Size360to380] EQ 1), Age20Size360to380countF)
age21Size360to380F = WHERE((Age_Gro[Size360to380] EQ 21) AND (Sex_Gro[Size360to380] EQ 1), Age21Size360to380countF)
age22Size360to380F = WHERE((Age_Gro[Size360to380] EQ 22) AND (Sex_Gro[Size360to380] EQ 1), Age22Size360to380countF)
age23Size360to380F = WHERE((Age_Gro[Size360to380] EQ 23) AND (Sex_Gro[Size360to380] EQ 1), Age23Size360to380countF)
age24Size360to380F = WHERE((Age_Gro[Size360to380] EQ 24) AND (Sex_Gro[Size360to380] EQ 1), Age24Size360to380countF)
age25Size360to380F = WHERE((Age_Gro[Size360to380] EQ 25) AND (Sex_Gro[Size360to380] EQ 1), Age25Size360to380countF)
age26Size360to380F = WHERE((Age_Gro[Size360to380] EQ 26) AND (Sex_Gro[Size360to380] EQ 1), Age26Size360to380countF)

  WAE_length_bin[70, i*NumLengthBin+adj+14L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+14L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+14L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+14L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+14L] = 360
  WAE_length_bin[75, i*NumLengthBin+adj+14L] = Size360to380countF

  WAE_length_bin[76, i*NumLengthBin+adj+14L] = Age0Size360to380countF
  WAE_length_bin[77, i*NumLengthBin+adj+14L] = Age1Size360to380countF
  WAE_length_bin[78, i*NumLengthBin+adj+14L] = Age2Size360to380countF
  WAE_length_bin[79, i*NumLengthBin+adj+14L] = Age3Size360to380countF
  WAE_length_bin[80, i*NumLengthBin+adj+14L] = Age4Size360to380countF
  WAE_length_bin[81, i*NumLengthBin+adj+14L] = Age5Size360to380countF
  WAE_length_bin[82, i*NumLengthBin+adj+14L] = Age6Size360to380countF
  WAE_length_bin[83, i*NumLengthBin+adj+14L] = Age7Size360to380countF
  WAE_length_bin[84, i*NumLengthBin+adj+14L] = Age8Size360to380countF
  WAE_length_bin[85, i*NumLengthBin+adj+14L] = Age9Size360to380countF
  WAE_length_bin[86, i*NumLengthBin+adj+14L] = Age10Size360to380countF
  WAE_length_bin[87, i*NumLengthBin+adj+14L] = Age11Size360to380countF
  WAE_length_bin[88, i*NumLengthBin+adj+14L] = Age12Size360to380countF
  WAE_length_bin[89, i*NumLengthBin+adj+14L] = Age13Size360to380countF
  WAE_length_bin[90, i*NumLengthBin+adj+14L] = Age14Size360to380countF
  WAE_length_bin[91, i*NumLengthBin+adj+14L] = Age15Size360to380countF
  WAE_length_bin[92, i*NumLengthBin+adj+14L] = Age16Size360to380countF
  WAE_length_bin[93, i*NumLengthBin+adj+14L] = Age17Size360to380countF
  WAE_length_bin[94, i*NumLengthBin+adj+14L] = Age18Size360to380countF
  WAE_length_bin[95, i*NumLengthBin+adj+14L] = Age19Size360to380countF
  WAE_length_bin[96, i*NumLengthBin+adj+14L] = Age20Size360to380countF
  WAE_length_bin[97, i*NumLengthBin+adj+14L] = Age21Size360to380countF
  WAE_length_bin[98, i*NumLengthBin+adj+14L] = Age22Size360to380countF
  WAE_length_bin[99, i*NumLengthBin+adj+14L] = Age23Size360to380countF
  WAE_length_bin[100, i*NumLengthBin+adj+14L] = Age24Size360to380countF
  WAE_length_bin[101, i*NumLengthBin+adj+14L] = Age25Size360to380countF
  WAE_length_bin[102, i*NumLengthBin+adj+14L] = Age26Size360to380countF
  ENDIF
PRINT, 'Size360to380F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+14L])

; length bin 16
IF Size380to400countF GT 0 THEN BEGIN
age0Size380to400F = WHERE((Age_Gro[Size380to400] EQ 1) AND (Sex_Gro[Size380to400] EQ 1), Age0Size380to400countF)
age1Size380to400F = WHERE((Age_Gro[Size380to400] EQ 1) AND (Sex_Gro[Size380to400] EQ 1), Age1Size380to400countF)
age2Size380to400F = WHERE((Age_Gro[Size380to400] EQ 2) AND (Sex_Gro[Size380to400] EQ 1), Age2Size380to400countF)
age3Size380to400F = WHERE((Age_Gro[Size380to400] EQ 3) AND (Sex_Gro[Size380to400] EQ 1), Age3Size380to400countF)
age4Size380to400F = WHERE((Age_Gro[Size380to400] EQ 4) AND (Sex_Gro[Size380to400] EQ 1), Age4Size380to400countF)
age5Size380to400F = WHERE((Age_Gro[Size380to400] EQ 5) AND (Sex_Gro[Size380to400] EQ 1), Age5Size380to400countF)
age6Size380to400F = WHERE((Age_Gro[Size380to400] EQ 6) AND (Sex_Gro[Size380to400] EQ 1), Age6Size380to400countF)
age7Size380to400F = WHERE((Age_Gro[Size380to400] EQ 7) AND (Sex_Gro[Size380to400] EQ 1), Age7Size380to400countF)
age8Size380to400F = WHERE((Age_Gro[Size380to400] EQ 8) AND (Sex_Gro[Size380to400] EQ 1), Age8Size380to400countF)
age9Size380to400F = WHERE((Age_Gro[Size380to400] EQ 9) AND (Sex_Gro[Size380to400] EQ 1), Age9Size380to400countF)
age10Size380to400F = WHERE((Age_Gro[Size380to400] EQ 10) AND (Sex_Gro[Size380to400] EQ 1), Age10Size380to400countF)
age11Size380to400F = WHERE((Age_Gro[Size380to400] EQ 11) AND (Sex_Gro[Size380to400] EQ 1), Age11Size380to400countF)
AGE12Size380to400F = WHERE((Age_Gro[Size380to400] EQ 12) AND (Sex_Gro[Size380to400] EQ 1), Age12Size380to400countF)
AGE13Size380to400F = WHERE((Age_Gro[Size380to400] EQ 13) AND (Sex_Gro[Size380to400] EQ 1), Age13Size380to400countF)
AGE14Size380to400F = WHERE((Age_Gro[Size380to400] EQ 14) AND (Sex_Gro[Size380to400] EQ 1), Age14Size380to400countF)
AGE15Size380to400F = WHERE((Age_Gro[Size380to400] EQ 15) AND (Sex_Gro[Size380to400] EQ 1), Age15Size380to400countF)
age16Size380to400F = WHERE((Age_Gro[Size380to400] EQ 16) AND (Sex_Gro[Size380to400] EQ 1), Age16Size380to400countF)
age17Size380to400F = WHERE((Age_Gro[Size380to400] EQ 17) AND (Sex_Gro[Size380to400] EQ 1), Age17Size380to400countF)
age18Size380to400F = WHERE((Age_Gro[Size380to400] EQ 18) AND (Sex_Gro[Size380to400] EQ 1), Age18Size380to400countF)
age19Size380to400F = WHERE((Age_Gro[Size380to400] EQ 19) AND (Sex_Gro[Size380to400] EQ 1), Age19Size380to400countF)
age20Size380to400F = WHERE((Age_Gro[Size380to400] EQ 20) AND (Sex_Gro[Size380to400] EQ 1), Age20Size380to400countF)
age21Size380to400F = WHERE((Age_Gro[Size380to400] EQ 21) AND (Sex_Gro[Size380to400] EQ 1), Age21Size380to400countF)
age22Size380to400F = WHERE((Age_Gro[Size380to400] EQ 22) AND (Sex_Gro[Size380to400] EQ 1), Age22Size380to400countF)
age23Size380to400F = WHERE((Age_Gro[Size380to400] EQ 23) AND (Sex_Gro[Size380to400] EQ 1), Age23Size380to400countF)
age24Size380to400F = WHERE((Age_Gro[Size380to400] EQ 24) AND (Sex_Gro[Size380to400] EQ 1), Age24Size380to400countF)
age25Size380to400F = WHERE((Age_Gro[Size380to400] EQ 25) AND (Sex_Gro[Size380to400] EQ 1), Age25Size380to400countF)
age26Size380to400F = WHERE((Age_Gro[Size380to400] EQ 26) AND (Sex_Gro[Size380to400] EQ 1), Age26Size380to400countF)

  WAE_length_bin[70, i*NumLengthBin+adj+15L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+15L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+15L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+15L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+15L] = 380
  WAE_length_bin[75, i*NumLengthBin+adj+15L] = Size380to400countF

  WAE_length_bin[76, i*NumLengthBin+adj+15L] = Age0Size380to400countF
  WAE_length_bin[77, i*NumLengthBin+adj+15L] = Age1Size380to400countF
  WAE_length_bin[78, i*NumLengthBin+adj+15L] = Age2Size380to400countF
  WAE_length_bin[79, i*NumLengthBin+adj+15L] = Age3Size380to400countF
  WAE_length_bin[80, i*NumLengthBin+adj+15L] = Age4Size380to400countF
  WAE_length_bin[81, i*NumLengthBin+adj+15L] = Age5Size380to400countF
  WAE_length_bin[82, i*NumLengthBin+adj+15L] = Age6Size380to400countF
  WAE_length_bin[83, i*NumLengthBin+adj+15L] = Age7Size380to400countF
  WAE_length_bin[84, i*NumLengthBin+adj+15L] = Age8Size380to400countF
  WAE_length_bin[85, i*NumLengthBin+adj+15L] = Age9Size380to400countF
  WAE_length_bin[86, i*NumLengthBin+adj+15L] = Age10Size380to400countF
  WAE_length_bin[87, i*NumLengthBin+adj+15L] = Age11Size380to400countF
  WAE_length_bin[88, i*NumLengthBin+adj+15L] = Age12Size380to400countF
  WAE_length_bin[89, i*NumLengthBin+adj+15L] = Age13Size380to400countF
  WAE_length_bin[90, i*NumLengthBin+adj+15L] = Age14Size380to400countF
  WAE_length_bin[91, i*NumLengthBin+adj+15L] = Age15Size380to400countF
  WAE_length_bin[92, i*NumLengthBin+adj+15L] = Age16Size380to400countF
  WAE_length_bin[93, i*NumLengthBin+adj+15L] = Age17Size380to400countF
  WAE_length_bin[94, i*NumLengthBin+adj+15L] = Age18Size380to400countF
  WAE_length_bin[95, i*NumLengthBin+adj+15L] = Age19Size380to400countF
  WAE_length_bin[96, i*NumLengthBin+adj+15L] = Age20Size380to400countF
  WAE_length_bin[97, i*NumLengthBin+adj+15L] = Age21Size380to400countF
  WAE_length_bin[98, i*NumLengthBin+adj+15L] = Age22Size380to400countF
  WAE_length_bin[99, i*NumLengthBin+adj+15L] = Age23Size380to400countF
  WAE_length_bin[100, i*NumLengthBin+adj+15L] = Age24Size380to400countF
  WAE_length_bin[101, i*NumLengthBin+adj+15L] = Age25Size380to400countF
  WAE_length_bin[102, i*NumLengthBin+adj+15L] = Age26Size380to400countF
  ENDIF
PRINT, 'Size380to400F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+15L])

; length bin 17
IF Size400to420countF GT 0 THEN BEGIN
age0Size400to420F = WHERE((Age_Gro[Size400to420] EQ 1) AND (Sex_Gro[Size400to420] EQ 1), Age0Size400to420countF)
age1Size400to420F = WHERE((Age_Gro[Size400to420] EQ 1) AND (Sex_Gro[Size400to420] EQ 1), Age1Size400to420countF)
age2Size400to420F = WHERE((Age_Gro[Size400to420] EQ 2) AND (Sex_Gro[Size400to420] EQ 1), Age2Size400to420countF)
age3Size400to420F = WHERE((Age_Gro[Size400to420] EQ 3) AND (Sex_Gro[Size400to420] EQ 1), Age3Size400to420countF)
age4Size400to420F = WHERE((Age_Gro[Size400to420] EQ 4) AND (Sex_Gro[Size400to420] EQ 1), Age4Size400to420countF)
age5Size400to420F = WHERE((Age_Gro[Size400to420] EQ 5) AND (Sex_Gro[Size400to420] EQ 1), Age5Size400to420countF)
age6Size400to420F = WHERE((Age_Gro[Size400to420] EQ 6) AND (Sex_Gro[Size400to420] EQ 1), Age6Size400to420countF)
age7Size400to420F = WHERE((Age_Gro[Size400to420] EQ 7) AND (Sex_Gro[Size400to420] EQ 1), Age7Size400to420countF)
age8Size400to420F = WHERE((Age_Gro[Size400to420] EQ 8) AND (Sex_Gro[Size400to420] EQ 1), Age8Size400to420countF)
age9Size400to420F = WHERE((Age_Gro[Size400to420] EQ 9) AND (Sex_Gro[Size400to420] EQ 1), Age9Size400to420countF)
age10Size400to420F = WHERE((Age_Gro[Size400to420] EQ 10) AND (Sex_Gro[Size400to420] EQ 1), Age10Size400to420countF)
age11Size400to420F = WHERE((Age_Gro[Size400to420] EQ 11) AND (Sex_Gro[Size400to420] EQ 1), Age11Size400to420countF)
AGE12Size400to420F = WHERE((Age_Gro[Size400to420] EQ 12) AND (Sex_Gro[Size400to420] EQ 1), Age12Size400to420countF)
AGE13Size400to420F = WHERE((Age_Gro[Size400to420] EQ 13) AND (Sex_Gro[Size400to420] EQ 1), Age13Size400to420countF)
AGE14Size400to420F = WHERE((Age_Gro[Size400to420] EQ 14) AND (Sex_Gro[Size400to420] EQ 1), Age14Size400to420countF)
AGE15Size400to420F = WHERE((Age_Gro[Size400to420] EQ 15) AND (Sex_Gro[Size400to420] EQ 1), Age15Size400to420countF)
age16Size400to420F = WHERE((Age_Gro[Size400to420] EQ 16) AND (Sex_Gro[Size400to420] EQ 1), Age16Size400to420countF)
age17Size400to420F = WHERE((Age_Gro[Size400to420] EQ 17) AND (Sex_Gro[Size400to420] EQ 1), Age17Size400to420countF)
age18Size400to420F = WHERE((Age_Gro[Size400to420] EQ 18) AND (Sex_Gro[Size400to420] EQ 1), Age18Size400to420countF)
age19Size400to420F = WHERE((Age_Gro[Size400to420] EQ 19) AND (Sex_Gro[Size400to420] EQ 1), Age19Size400to420countF)
age20Size400to420F = WHERE((Age_Gro[Size400to420] EQ 20) AND (Sex_Gro[Size400to420] EQ 1), Age20Size400to420countF)
age21Size400to420F = WHERE((Age_Gro[Size400to420] EQ 21) AND (Sex_Gro[Size400to420] EQ 1), Age21Size400to420countF)
age22Size400to420F = WHERE((Age_Gro[Size400to420] EQ 22) AND (Sex_Gro[Size400to420] EQ 1), Age22Size400to420countF)
age23Size400to420F = WHERE((Age_Gro[Size400to420] EQ 23) AND (Sex_Gro[Size400to420] EQ 1), Age23Size400to420countF)
age24Size400to420F = WHERE((Age_Gro[Size400to420] EQ 24) AND (Sex_Gro[Size400to420] EQ 1), Age24Size400to420countF)
age25Size400to420F = WHERE((Age_Gro[Size400to420] EQ 25) AND (Sex_Gro[Size400to420] EQ 1), Age25Size400to420countF)
age26Size400to420F = WHERE((Age_Gro[Size400to420] EQ 26) AND (Sex_Gro[Size400to420] EQ 1), Age26Size400to420countF)

  WAE_length_bin[70, i*NumLengthBin+adj+16L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+16L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+16L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+16L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+16L] = 400
  WAE_length_bin[75, i*NumLengthBin+adj+16L] = Size400to420countF

  WAE_length_bin[76, i*NumLengthBin+adj+16L] = Age0Size400to420countF
  WAE_length_bin[77, i*NumLengthBin+adj+16L] = Age1Size400to420countF
  WAE_length_bin[78, i*NumLengthBin+adj+16L] = Age2Size400to420countF
  WAE_length_bin[79, i*NumLengthBin+adj+16L] = Age3Size400to420countF
  WAE_length_bin[80, i*NumLengthBin+adj+16L] = Age4Size400to420countF
  WAE_length_bin[81, i*NumLengthBin+adj+16L] = Age5Size400to420countF
  WAE_length_bin[82, i*NumLengthBin+adj+16L] = Age6Size400to420countF
  WAE_length_bin[83, i*NumLengthBin+adj+16L] = Age7Size400to420countF
  WAE_length_bin[84, i*NumLengthBin+adj+16L] = Age8Size400to420countF
  WAE_length_bin[85, i*NumLengthBin+adj+16L] = Age9Size400to420countF
  WAE_length_bin[86, i*NumLengthBin+adj+16L] = Age10Size400to420countF
  WAE_length_bin[87, i*NumLengthBin+adj+16L] = Age11Size400to420countF
  WAE_length_bin[88, i*NumLengthBin+adj+16L] = Age12Size400to420countF
  WAE_length_bin[89, i*NumLengthBin+adj+16L] = Age13Size400to420countF
  WAE_length_bin[90, i*NumLengthBin+adj+16L] = Age14Size400to420countF
  WAE_length_bin[91, i*NumLengthBin+adj+16L] = Age15Size400to420countF
  WAE_length_bin[92, i*NumLengthBin+adj+16L] = Age16Size400to420countF
  WAE_length_bin[93, i*NumLengthBin+adj+16L] = Age17Size400to420countF
  WAE_length_bin[94, i*NumLengthBin+adj+16L] = Age18Size400to420countF
  WAE_length_bin[95, i*NumLengthBin+adj+16L] = Age19Size400to420countF
  WAE_length_bin[96, i*NumLengthBin+adj+16L] = Age20Size400to420countF
  WAE_length_bin[97, i*NumLengthBin+adj+16L] = Age21Size400to420countF
  WAE_length_bin[98, i*NumLengthBin+adj+16L] = Age22Size400to420countF
  WAE_length_bin[99, i*NumLengthBin+adj+16L] = Age23Size400to420countF
  WAE_length_bin[100, i*NumLengthBin+adj+16L] = Age24Size400to420countF
  WAE_length_bin[101, i*NumLengthBin+adj+16L] = Age25Size400to420countF
  WAE_length_bin[102, i*NumLengthBin+adj+16L] = Age26Size400to420countF
  ENDIF
PRINT, 'Size400to420F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+16L])

; length bin 18
IF Size420to440countF GT 0 THEN BEGIN
age0Size420to440F = WHERE((Age_Gro[Size420to440] EQ 1) AND (Sex_Gro[Size420to440] EQ 1), Age0Size420to440countF)
age1Size420to440F = WHERE((Age_Gro[Size420to440] EQ 1) AND (Sex_Gro[Size420to440] EQ 1), Age1Size420to440countF)
age2Size420to440F = WHERE((Age_Gro[Size420to440] EQ 2) AND (Sex_Gro[Size420to440] EQ 1), Age2Size420to440countF)
age3Size420to440F = WHERE((Age_Gro[Size420to440] EQ 3) AND (Sex_Gro[Size420to440] EQ 1), Age3Size420to440countF)
age4Size420to440F = WHERE((Age_Gro[Size420to440] EQ 4) AND (Sex_Gro[Size420to440] EQ 1), Age4Size420to440countF)
age5Size420to440F = WHERE((Age_Gro[Size420to440] EQ 5) AND (Sex_Gro[Size420to440] EQ 1), Age5Size420to440countF)
age6Size420to440F = WHERE((Age_Gro[Size420to440] EQ 6) AND (Sex_Gro[Size420to440] EQ 1), Age6Size420to440countF)
age7Size420to440F = WHERE((Age_Gro[Size420to440] EQ 7) AND (Sex_Gro[Size420to440] EQ 1), Age7Size420to440countF)
age8Size420to440F = WHERE((Age_Gro[Size420to440] EQ 8) AND (Sex_Gro[Size420to440] EQ 1), Age8Size420to440countF)
age9Size420to440F = WHERE((Age_Gro[Size420to440] EQ 9) AND (Sex_Gro[Size420to440] EQ 1), Age9Size420to440countF)
age10Size420to440F = WHERE((Age_Gro[Size420to440] EQ 10) AND (Sex_Gro[Size420to440] EQ 1), Age10Size420to440countF)
age11Size420to440F = WHERE((Age_Gro[Size420to440] EQ 11) AND (Sex_Gro[Size420to440] EQ 1), Age11Size420to440countF)
AGE12Size420to440F = WHERE((Age_Gro[Size420to440] EQ 12) AND (Sex_Gro[Size420to440] EQ 1), Age12Size420to440countF)
AGE13Size420to440F = WHERE((Age_Gro[Size420to440] EQ 13) AND (Sex_Gro[Size420to440] EQ 1), Age13Size420to440countF)
AGE14Size420to440F = WHERE((Age_Gro[Size420to440] EQ 14) AND (Sex_Gro[Size420to440] EQ 1), Age14Size420to440countF)
AGE15Size420to440F = WHERE((Age_Gro[Size420to440] EQ 15) AND (Sex_Gro[Size420to440] EQ 1), Age15Size420to440countF)
age16Size420to440F = WHERE((Age_Gro[Size420to440] EQ 16) AND (Sex_Gro[Size420to440] EQ 1), Age16Size420to440countF)
age17Size420to440F = WHERE((Age_Gro[Size420to440] EQ 17) AND (Sex_Gro[Size420to440] EQ 1), Age17Size420to440countF)
age18Size420to440F = WHERE((Age_Gro[Size420to440] EQ 18) AND (Sex_Gro[Size420to440] EQ 1), Age18Size420to440countF)
age19Size420to440F = WHERE((Age_Gro[Size420to440] EQ 19) AND (Sex_Gro[Size420to440] EQ 1), Age19Size420to440countF)
age20Size420to440F = WHERE((Age_Gro[Size420to440] EQ 20) AND (Sex_Gro[Size420to440] EQ 1), Age20Size420to440countF)
age21Size420to440F = WHERE((Age_Gro[Size420to440] EQ 21) AND (Sex_Gro[Size420to440] EQ 1), Age21Size420to440countF)
age22Size420to440F = WHERE((Age_Gro[Size420to440] EQ 22) AND (Sex_Gro[Size420to440] EQ 1), Age22Size420to440countF)
age23Size420to440F = WHERE((Age_Gro[Size420to440] EQ 23) AND (Sex_Gro[Size420to440] EQ 1), Age23Size420to440countF)
age24Size420to440F = WHERE((Age_Gro[Size420to440] EQ 24) AND (Sex_Gro[Size420to440] EQ 1), Age24Size420to440countF)
age25Size420to440F = WHERE((Age_Gro[Size420to440] EQ 25) AND (Sex_Gro[Size420to440] EQ 1), Age25Size420to440countF)
age26Size420to440F = WHERE((Age_Gro[Size420to440] EQ 26) AND (Sex_Gro[Size420to440] EQ 1), Age26Size420to440countF)

  WAE_length_bin[70, i*NumLengthBin+adj+17L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+17L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+17L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+17L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+17L] = 420
  WAE_length_bin[75, i*NumLengthBin+adj+17L] = Size420to440countF

  WAE_length_bin[76, i*NumLengthBin+adj+17L] = Age0Size420to440countF
  WAE_length_bin[77, i*NumLengthBin+adj+17L] = Age1Size420to440countF
  WAE_length_bin[78, i*NumLengthBin+adj+17L] = Age2Size420to440countF
  WAE_length_bin[79, i*NumLengthBin+adj+17L] = Age3Size420to440countF
  WAE_length_bin[80, i*NumLengthBin+adj+17L] = Age4Size420to440countF
  WAE_length_bin[81, i*NumLengthBin+adj+17L] = Age5Size420to440countF
  WAE_length_bin[82, i*NumLengthBin+adj+17L] = Age6Size420to440countF
  WAE_length_bin[83, i*NumLengthBin+adj+17L] = Age7Size420to440countF
  WAE_length_bin[84, i*NumLengthBin+adj+17L] = Age8Size420to440countF
  WAE_length_bin[85, i*NumLengthBin+adj+17L] = Age9Size420to440countF
  WAE_length_bin[86, i*NumLengthBin+adj+17L] = Age10Size420to440countF
  WAE_length_bin[87, i*NumLengthBin+adj+17L] = Age11Size420to440countF
  WAE_length_bin[88, i*NumLengthBin+adj+17L] = Age12Size420to440countF
  WAE_length_bin[89, i*NumLengthBin+adj+17L] = Age13Size420to440countF
  WAE_length_bin[90, i*NumLengthBin+adj+17L] = Age14Size420to440countF
  WAE_length_bin[91, i*NumLengthBin+adj+17L] = Age15Size420to440countF
  WAE_length_bin[92, i*NumLengthBin+adj+17L] = Age16Size420to440countF
  WAE_length_bin[93, i*NumLengthBin+adj+17L] = Age17Size420to440countF
  WAE_length_bin[94, i*NumLengthBin+adj+17L] = Age18Size420to440countF
  WAE_length_bin[95, i*NumLengthBin+adj+17L] = Age19Size420to440countF
  WAE_length_bin[96, i*NumLengthBin+adj+17L] = Age20Size420to440countF
  WAE_length_bin[97, i*NumLengthBin+adj+17L] = Age21Size420to440countF
  WAE_length_bin[98, i*NumLengthBin+adj+17L] = Age22Size420to440countF
  WAE_length_bin[99, i*NumLengthBin+adj+17L] = Age23Size420to440countF
  WAE_length_bin[100, i*NumLengthBin+adj+17L] = Age24Size420to440countF
  WAE_length_bin[101, i*NumLengthBin+adj+17L] = Age25Size420to440countF
  WAE_length_bin[102, i*NumLengthBin+adj+17L] = Age26Size420to440countF
  ENDIF
PRINT, 'Size420to440F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+17L])

; length bin 19
IF Size440to460countF GT 0 THEN BEGIN
age0Size440to460F = WHERE((Age_Gro[Size440to460] EQ 1) AND (Sex_Gro[Size440to460] EQ 1), Age0Size440to460countF)
age1Size440to460F = WHERE((Age_Gro[Size440to460] EQ 1) AND (Sex_Gro[Size440to460] EQ 1), Age1Size440to460countF)
age2Size440to460F = WHERE((Age_Gro[Size440to460] EQ 2) AND (Sex_Gro[Size440to460] EQ 1), Age2Size440to460countF)
age3Size440to460F = WHERE((Age_Gro[Size440to460] EQ 3) AND (Sex_Gro[Size440to460] EQ 1), Age3Size440to460countF)
age4Size440to460F = WHERE((Age_Gro[Size440to460] EQ 4) AND (Sex_Gro[Size440to460] EQ 1), Age4Size440to460countF)
age5Size440to460F = WHERE((Age_Gro[Size440to460] EQ 5) AND (Sex_Gro[Size440to460] EQ 1), Age5Size440to460countF)
age6Size440to460F = WHERE((Age_Gro[Size440to460] EQ 6) AND (Sex_Gro[Size440to460] EQ 1), Age6Size440to460countF)
age7Size440to460F = WHERE((Age_Gro[Size440to460] EQ 7) AND (Sex_Gro[Size440to460] EQ 1), Age7Size440to460countF)
age8Size440to460F = WHERE((Age_Gro[Size440to460] EQ 8) AND (Sex_Gro[Size440to460] EQ 1), Age8Size440to460countF)
age9Size440to460F = WHERE((Age_Gro[Size440to460] EQ 9) AND (Sex_Gro[Size440to460] EQ 1), Age9Size440to460countF)
age10Size440to460F = WHERE((Age_Gro[Size440to460] EQ 10) AND (Sex_Gro[Size440to460] EQ 1), Age10Size440to460countF)
age11Size440to460F = WHERE((Age_Gro[Size440to460] EQ 11) AND (Sex_Gro[Size440to460] EQ 1), Age11Size440to460countF)
AGE12Size440to460F = WHERE((Age_Gro[Size440to460] EQ 12) AND (Sex_Gro[Size440to460] EQ 1), Age12Size440to460countF)
AGE13Size440to460F = WHERE((Age_Gro[Size440to460] EQ 13) AND (Sex_Gro[Size440to460] EQ 1), Age13Size440to460countF)
AGE14Size440to460F = WHERE((Age_Gro[Size440to460] EQ 14) AND (Sex_Gro[Size440to460] EQ 1), Age14Size440to460countF)
AGE15Size440to460F = WHERE((Age_Gro[Size440to460] EQ 15) AND (Sex_Gro[Size440to460] EQ 1), Age15Size440to460countF)
age16Size440to460F = WHERE((Age_Gro[Size440to460] EQ 16) AND (Sex_Gro[Size440to460] EQ 1), Age16Size440to460countF)
age17Size440to460F = WHERE((Age_Gro[Size440to460] EQ 17) AND (Sex_Gro[Size440to460] EQ 1), Age17Size440to460countF)
age18Size440to460F = WHERE((Age_Gro[Size440to460] EQ 18) AND (Sex_Gro[Size440to460] EQ 1), Age18Size440to460countF)
age19Size440to460F = WHERE((Age_Gro[Size440to460] EQ 19) AND (Sex_Gro[Size440to460] EQ 1), Age19Size440to460countF)
age20Size440to460F = WHERE((Age_Gro[Size440to460] EQ 20) AND (Sex_Gro[Size440to460] EQ 1), Age20Size440to460countF)
age21Size440to460F = WHERE((Age_Gro[Size440to460] EQ 21) AND (Sex_Gro[Size440to460] EQ 1), Age21Size440to460countF)
age22Size440to460F = WHERE((Age_Gro[Size440to460] EQ 22) AND (Sex_Gro[Size440to460] EQ 1), Age22Size440to460countF)
age23Size440to460F = WHERE((Age_Gro[Size440to460] EQ 23) AND (Sex_Gro[Size440to460] EQ 1), Age23Size440to460countF)
age24Size440to460F = WHERE((Age_Gro[Size440to460] EQ 24) AND (Sex_Gro[Size440to460] EQ 1), Age24Size440to460countF)
age25Size440to460F = WHERE((Age_Gro[Size440to460] EQ 25) AND (Sex_Gro[Size440to460] EQ 1), Age25Size440to460countF)
age26Size440to460F = WHERE((Age_Gro[Size440to460] EQ 26) AND (Sex_Gro[Size440to460] EQ 1), Age26Size440to460countF)

  WAE_length_bin[70, i*NumLengthBin+adj+18L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+18L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+18L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+18L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+18L] = 440
  WAE_length_bin[75, i*NumLengthBin+adj+18L] = Size440to460countF

  WAE_length_bin[76, i*NumLengthBin+adj+18L] = Age0Size440to460countF
  WAE_length_bin[77, i*NumLengthBin+adj+18L] = Age1Size440to460countF
  WAE_length_bin[78, i*NumLengthBin+adj+18L] = Age2Size440to460countF
  WAE_length_bin[79, i*NumLengthBin+adj+18L] = Age3Size440to460countF
  WAE_length_bin[80, i*NumLengthBin+adj+18L] = Age4Size440to460countF
  WAE_length_bin[81, i*NumLengthBin+adj+18L] = Age5Size440to460countF
  WAE_length_bin[82, i*NumLengthBin+adj+18L] = Age6Size440to460countF
  WAE_length_bin[83, i*NumLengthBin+adj+18L] = Age7Size440to460countF
  WAE_length_bin[84, i*NumLengthBin+adj+18L] = Age8Size440to460countF
  WAE_length_bin[85, i*NumLengthBin+adj+18L] = Age9Size440to460countF
  WAE_length_bin[86, i*NumLengthBin+adj+18L] = Age10Size440to460countF
  WAE_length_bin[87, i*NumLengthBin+adj+18L] = Age11Size440to460countF
  WAE_length_bin[88, i*NumLengthBin+adj+18L] = Age12Size440to460countF
  WAE_length_bin[89, i*NumLengthBin+adj+18L] = Age13Size440to460countF
  WAE_length_bin[90, i*NumLengthBin+adj+18L] = Age14Size440to460countF
  WAE_length_bin[91, i*NumLengthBin+adj+18L] = Age15Size440to460countF
  WAE_length_bin[92, i*NumLengthBin+adj+18L] = Age16Size440to460countF
  WAE_length_bin[93, i*NumLengthBin+adj+18L] = Age17Size440to460countF
  WAE_length_bin[94, i*NumLengthBin+adj+18L] = Age18Size440to460countF
  WAE_length_bin[95, i*NumLengthBin+adj+18L] = Age19Size440to460countF
  WAE_length_bin[96, i*NumLengthBin+adj+18L] = Age20Size440to460countF
  WAE_length_bin[97, i*NumLengthBin+adj+18L] = Age21Size440to460countF
  WAE_length_bin[98, i*NumLengthBin+adj+18L] = Age22Size440to460countF
  WAE_length_bin[99, i*NumLengthBin+adj+18L] = Age23Size440to460countF
  WAE_length_bin[100, i*NumLengthBin+adj+18L] = Age24Size440to460countF
  WAE_length_bin[101, i*NumLengthBin+adj+18L] = Age25Size440to460countF
  WAE_length_bin[102, i*NumLengthBin+adj+18L] = Age26Size440to460countF
  ENDIF
PRINT, 'Size440to460F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+18L])

; length bin 20
IF Size460to480countF GT 0 THEN BEGIN
age0Size460to480F = WHERE((Age_Gro[Size460to480] EQ 1) AND (Sex_Gro[Size460to480] EQ 1), Age0Size460to480countF)
age1Size460to480F = WHERE((Age_Gro[Size460to480] EQ 1) AND (Sex_Gro[Size460to480] EQ 1), Age1Size460to480countF)
age2Size460to480F = WHERE((Age_Gro[Size460to480] EQ 2) AND (Sex_Gro[Size460to480] EQ 1), Age2Size460to480countF)
age3Size460to480F = WHERE((Age_Gro[Size460to480] EQ 3) AND (Sex_Gro[Size460to480] EQ 1), Age3Size460to480countF)
age4Size460to480F = WHERE((Age_Gro[Size460to480] EQ 4) AND (Sex_Gro[Size460to480] EQ 1), Age4Size460to480countF)
age5Size460to480F = WHERE((Age_Gro[Size460to480] EQ 5) AND (Sex_Gro[Size460to480] EQ 1), Age5Size460to480countF)
age6Size460to480F = WHERE((Age_Gro[Size460to480] EQ 6) AND (Sex_Gro[Size460to480] EQ 1), Age6Size460to480countF)
age7Size460to480F = WHERE((Age_Gro[Size460to480] EQ 7) AND (Sex_Gro[Size460to480] EQ 1), Age7Size460to480countF)
age8Size460to480F = WHERE((Age_Gro[Size460to480] EQ 8) AND (Sex_Gro[Size460to480] EQ 1), Age8Size460to480countF)
age9Size460to480F = WHERE((Age_Gro[Size460to480] EQ 9) AND (Sex_Gro[Size460to480] EQ 1), Age9Size460to480countF)
age10Size460to480F = WHERE((Age_Gro[Size460to480] EQ 10) AND (Sex_Gro[Size460to480] EQ 1), Age10Size460to480countF)
age11Size460to480F = WHERE((Age_Gro[Size460to480] EQ 11) AND (Sex_Gro[Size460to480] EQ 1), Age11Size460to480countF)
AGE12Size460to480F = WHERE((Age_Gro[Size460to480] EQ 12) AND (Sex_Gro[Size460to480] EQ 1), Age12Size460to480countF)
AGE13Size460to480F = WHERE((Age_Gro[Size460to480] EQ 13) AND (Sex_Gro[Size460to480] EQ 1), Age13Size460to480countF)
AGE14Size460to480F = WHERE((Age_Gro[Size460to480] EQ 14) AND (Sex_Gro[Size460to480] EQ 1), Age14Size460to480countF)
AGE15Size460to480F = WHERE((Age_Gro[Size460to480] EQ 15) AND (Sex_Gro[Size460to480] EQ 1), Age15Size460to480countF)
age16Size460to480F = WHERE((Age_Gro[Size460to480] EQ 16) AND (Sex_Gro[Size460to480] EQ 1), Age16Size460to480countF)
age17Size460to480F = WHERE((Age_Gro[Size460to480] EQ 17) AND (Sex_Gro[Size460to480] EQ 1), Age17Size460to480countF)
age18Size460to480F = WHERE((Age_Gro[Size460to480] EQ 18) AND (Sex_Gro[Size460to480] EQ 1), Age18Size460to480countF)
age19Size460to480F = WHERE((Age_Gro[Size460to480] EQ 19) AND (Sex_Gro[Size460to480] EQ 1), Age19Size460to480countF)
age20Size460to480F = WHERE((Age_Gro[Size460to480] EQ 20) AND (Sex_Gro[Size460to480] EQ 1), Age20Size460to480countF)
age21Size460to480F = WHERE((Age_Gro[Size460to480] EQ 21) AND (Sex_Gro[Size460to480] EQ 1), Age21Size460to480countF)
age22Size460to480F = WHERE((Age_Gro[Size460to480] EQ 22) AND (Sex_Gro[Size460to480] EQ 1), Age22Size460to480countF)
age23Size460to480F = WHERE((Age_Gro[Size460to480] EQ 23) AND (Sex_Gro[Size460to480] EQ 1), Age23Size460to480countF)
age24Size460to480F = WHERE((Age_Gro[Size460to480] EQ 24) AND (Sex_Gro[Size460to480] EQ 1), Age24Size460to480countF)
age25Size460to480F = WHERE((Age_Gro[Size460to480] EQ 25) AND (Sex_Gro[Size460to480] EQ 1), Age25Size460to480countF)
age26Size460to480F = WHERE((Age_Gro[Size460to480] EQ 26) AND (Sex_Gro[Size460to480] EQ 1), Age26Size460to480countF)

  WAE_length_bin[70, i*NumLengthBin+adj+19L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+19L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+19L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+19L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+19L] = 460
  WAE_length_bin[75, i*NumLengthBin+adj+19L] = Size460to480countF

  WAE_length_bin[76, i*NumLengthBin+adj+19L] = Age0Size460to480countF
  WAE_length_bin[77, i*NumLengthBin+adj+19L] = Age1Size460to480countF
  WAE_length_bin[78, i*NumLengthBin+adj+19L] = Age2Size460to480countF
  WAE_length_bin[79, i*NumLengthBin+adj+19L] = Age3Size460to480countF
  WAE_length_bin[80, i*NumLengthBin+adj+19L] = Age4Size460to480countF
  WAE_length_bin[81, i*NumLengthBin+adj+19L] = Age5Size460to480countF
  WAE_length_bin[82, i*NumLengthBin+adj+19L] = Age6Size460to480countF
  WAE_length_bin[83, i*NumLengthBin+adj+19L] = Age7Size460to480countF
  WAE_length_bin[84, i*NumLengthBin+adj+19L] = Age8Size460to480countF
  WAE_length_bin[85, i*NumLengthBin+adj+19L] = Age9Size460to480countF
  WAE_length_bin[86, i*NumLengthBin+adj+19L] = Age10Size460to480countF
  WAE_length_bin[87, i*NumLengthBin+adj+19L] = Age11Size460to480countF
  WAE_length_bin[88, i*NumLengthBin+adj+19L] = Age12Size460to480countF
  WAE_length_bin[89, i*NumLengthBin+adj+19L] = Age13Size460to480countF
  WAE_length_bin[90, i*NumLengthBin+adj+19L] = Age14Size460to480countF
  WAE_length_bin[91, i*NumLengthBin+adj+19L] = Age15Size460to480countF
  WAE_length_bin[92, i*NumLengthBin+adj+19L] = Age16Size460to480countF
  WAE_length_bin[93, i*NumLengthBin+adj+19L] = Age17Size460to480countF
  WAE_length_bin[94, i*NumLengthBin+adj+19L] = Age18Size460to480countF
  WAE_length_bin[95, i*NumLengthBin+adj+19L] = Age19Size460to480countF
  WAE_length_bin[96, i*NumLengthBin+adj+19L] = Age20Size460to480countF
  WAE_length_bin[97, i*NumLengthBin+adj+19L] = Age21Size460to480countF
  WAE_length_bin[98, i*NumLengthBin+adj+19L] = Age22Size460to480countF
  WAE_length_bin[99, i*NumLengthBin+adj+19L] = Age23Size460to480countF
  WAE_length_bin[100, i*NumLengthBin+adj+19L] = Age24Size460to480countF
  WAE_length_bin[101, i*NumLengthBin+adj+19L] = Age25Size460to480countF
  WAE_length_bin[102, i*NumLengthBin+adj+19L] = Age26Size460to480countF
  ENDIF
PRINT, 'Size460to480F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+19L])

; length bin 21
IF Size480to500countF GT 0 THEN BEGIN
age0Size480to500F = WHERE((Age_Gro[Size480to500] EQ 1) AND (Sex_Gro[Size480to500] EQ 1), Age0Size480to500countF)
age1Size480to500F = WHERE((Age_Gro[Size480to500] EQ 1) AND (Sex_Gro[Size480to500] EQ 1), Age1Size480to500countF)
age2Size480to500F = WHERE((Age_Gro[Size480to500] EQ 2) AND (Sex_Gro[Size480to500] EQ 1), Age2Size480to500countF)
age3Size480to500F = WHERE((Age_Gro[Size480to500] EQ 3) AND (Sex_Gro[Size480to500] EQ 1), Age3Size480to500countF)
age4Size480to500F = WHERE((Age_Gro[Size480to500] EQ 4) AND (Sex_Gro[Size480to500] EQ 1), Age4Size480to500countF)
age5Size480to500F = WHERE((Age_Gro[Size480to500] EQ 5) AND (Sex_Gro[Size480to500] EQ 1), Age5Size480to500countF)
age6Size480to500F = WHERE((Age_Gro[Size480to500] EQ 6) AND (Sex_Gro[Size480to500] EQ 1), Age6Size480to500countF)
age7Size480to500F = WHERE((Age_Gro[Size480to500] EQ 7) AND (Sex_Gro[Size480to500] EQ 1), Age7Size480to500countF)
age8Size480to500F = WHERE((Age_Gro[Size480to500] EQ 8) AND (Sex_Gro[Size480to500] EQ 1), Age8Size480to500countF)
age9Size480to500F = WHERE((Age_Gro[Size480to500] EQ 9) AND (Sex_Gro[Size480to500] EQ 1), Age9Size480to500countF)
age10Size480to500F = WHERE((Age_Gro[Size480to500] EQ 10) AND (Sex_Gro[Size480to500] EQ 1), Age10Size480to500countF)
age11Size480to500F = WHERE((Age_Gro[Size480to500] EQ 11) AND (Sex_Gro[Size480to500] EQ 1), Age11Size480to500countF)
AGE12Size480to500F = WHERE((Age_Gro[Size480to500] EQ 12) AND (Sex_Gro[Size480to500] EQ 1), Age12Size480to500countF)
AGE13Size480to500F = WHERE((Age_Gro[Size480to500] EQ 13) AND (Sex_Gro[Size480to500] EQ 1), Age13Size480to500countF)
AGE14Size480to500F = WHERE((Age_Gro[Size480to500] EQ 14) AND (Sex_Gro[Size480to500] EQ 1), Age14Size480to500countF)
AGE15Size480to500F = WHERE((Age_Gro[Size480to500] EQ 15) AND (Sex_Gro[Size480to500] EQ 1), Age15Size480to500countF)
age16Size480to500F = WHERE((Age_Gro[Size480to500] EQ 16) AND (Sex_Gro[Size480to500] EQ 1), Age16Size480to500countF)
age17Size480to500F = WHERE((Age_Gro[Size480to500] EQ 17) AND (Sex_Gro[Size480to500] EQ 1), Age17Size480to500countF)
age18Size480to500F = WHERE((Age_Gro[Size480to500] EQ 18) AND (Sex_Gro[Size480to500] EQ 1), Age18Size480to500countF)
age19Size480to500F = WHERE((Age_Gro[Size480to500] EQ 19) AND (Sex_Gro[Size480to500] EQ 1), Age19Size480to500countF)
age20Size480to500F = WHERE((Age_Gro[Size480to500] EQ 20) AND (Sex_Gro[Size480to500] EQ 1), Age20Size480to500countF)
age21Size480to500F = WHERE((Age_Gro[Size480to500] EQ 21) AND (Sex_Gro[Size480to500] EQ 1), Age21Size480to500countF)
age22Size480to500F = WHERE((Age_Gro[Size480to500] EQ 22) AND (Sex_Gro[Size480to500] EQ 1), Age22Size480to500countF)
age23Size480to500F = WHERE((Age_Gro[Size480to500] EQ 23) AND (Sex_Gro[Size480to500] EQ 1), Age23Size480to500countF)
age24Size480to500F = WHERE((Age_Gro[Size480to500] EQ 24) AND (Sex_Gro[Size480to500] EQ 1), Age24Size480to500countF)
age25Size480to500F = WHERE((Age_Gro[Size480to500] EQ 25) AND (Sex_Gro[Size480to500] EQ 1), Age25Size480to500countF)
age26Size480to500F = WHERE((Age_Gro[Size480to500] EQ 26) AND (Sex_Gro[Size480to500] EQ 1), Age26Size480to500countF)

  WAE_length_bin[70, i*NumLengthBin+adj+20L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+20L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+20L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+20L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+20L] = 480
  WAE_length_bin[75, i*NumLengthBin+adj+20L] = Size480to500countF

  WAE_length_bin[76, i*NumLengthBin+adj+20L] = Age0Size480to500countF
  WAE_length_bin[77, i*NumLengthBin+adj+20L] = Age1Size480to500countF
  WAE_length_bin[78, i*NumLengthBin+adj+20L] = Age2Size480to500countF
  WAE_length_bin[79, i*NumLengthBin+adj+20L] = Age3Size480to500countF
  WAE_length_bin[80, i*NumLengthBin+adj+20L] = Age4Size480to500countF
  WAE_length_bin[81, i*NumLengthBin+adj+20L] = Age5Size480to500countF
  WAE_length_bin[82, i*NumLengthBin+adj+20L] = Age6Size480to500countF
  WAE_length_bin[83, i*NumLengthBin+adj+20L] = Age7Size480to500countF
  WAE_length_bin[84, i*NumLengthBin+adj+20L] = Age8Size480to500countF
  WAE_length_bin[85, i*NumLengthBin+adj+20L] = Age9Size480to500countF
  WAE_length_bin[86, i*NumLengthBin+adj+20L] = Age10Size480to500countF
  WAE_length_bin[87, i*NumLengthBin+adj+20L] = Age11Size480to500countF
  WAE_length_bin[88, i*NumLengthBin+adj+20L] = Age12Size480to500countF
  WAE_length_bin[89, i*NumLengthBin+adj+20L] = Age13Size480to500countF
  WAE_length_bin[90, i*NumLengthBin+adj+20L] = Age14Size480to500countF
  WAE_length_bin[91, i*NumLengthBin+adj+20L] = Age15Size480to500countF
  WAE_length_bin[92, i*NumLengthBin+adj+20L] = Age16Size480to500countF
  WAE_length_bin[93, i*NumLengthBin+adj+20L] = Age17Size480to500countF
  WAE_length_bin[94, i*NumLengthBin+adj+20L] = Age18Size480to500countF
  WAE_length_bin[95, i*NumLengthBin+adj+20L] = Age19Size480to500countF
  WAE_length_bin[96, i*NumLengthBin+adj+20L] = Age20Size480to500countF
  WAE_length_bin[97, i*NumLengthBin+adj+20L] = Age21Size480to500countF
  WAE_length_bin[98, i*NumLengthBin+adj+20L] = Age22Size480to500countF
  WAE_length_bin[99, i*NumLengthBin+adj+20L] = Age23Size480to500countF
  WAE_length_bin[100, i*NumLengthBin+adj+20L] = Age24Size480to500countF
  WAE_length_bin[101, i*NumLengthBin+adj+20L] = Age25Size480to500countF
  WAE_length_bin[102, i*NumLengthBin+adj+20L] = Age26Size480to500countF
  ENDIF
PRINT, 'Size480to500F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+20L])

; length bin 22
IF Size500to520countF GT 0 THEN BEGIN
age0Size500to520F = WHERE((Age_Gro[Size500to520] EQ 1) AND (Sex_Gro[Size500to520] EQ 1), Age0Size500to520countF)
age1Size500to520F = WHERE((Age_Gro[Size500to520] EQ 1) AND (Sex_Gro[Size500to520] EQ 1), Age1Size500to520countF)
age2Size500to520F = WHERE((Age_Gro[Size500to520] EQ 2) AND (Sex_Gro[Size500to520] EQ 1), Age2Size500to520countF)
age3Size500to520F = WHERE((Age_Gro[Size500to520] EQ 3) AND (Sex_Gro[Size500to520] EQ 1), Age3Size500to520countF)
age4Size500to520F = WHERE((Age_Gro[Size500to520] EQ 4) AND (Sex_Gro[Size500to520] EQ 1), Age4Size500to520countF)
age5Size500to520F = WHERE((Age_Gro[Size500to520] EQ 5) AND (Sex_Gro[Size500to520] EQ 1), Age5Size500to520countF)
age6Size500to520F = WHERE((Age_Gro[Size500to520] EQ 6) AND (Sex_Gro[Size500to520] EQ 1), Age6Size500to520countF)
age7Size500to520F = WHERE((Age_Gro[Size500to520] EQ 7) AND (Sex_Gro[Size500to520] EQ 1), Age7Size500to520countF)
age8Size500to520F = WHERE((Age_Gro[Size500to520] EQ 8) AND (Sex_Gro[Size500to520] EQ 1), Age8Size500to520countF)
age9Size500to520F = WHERE((Age_Gro[Size500to520] EQ 9) AND (Sex_Gro[Size500to520] EQ 1), Age9Size500to520countF)
age10Size500to520F = WHERE((Age_Gro[Size500to520] EQ 10) AND (Sex_Gro[Size500to520] EQ 1), Age10Size500to520countF)
age11Size500to520F = WHERE((Age_Gro[Size500to520] EQ 11) AND (Sex_Gro[Size500to520] EQ 1), Age11Size500to520countF)
AGE12Size500to520F = WHERE((Age_Gro[Size500to520] EQ 12) AND (Sex_Gro[Size500to520] EQ 1), Age12Size500to520countF)
AGE13Size500to520F = WHERE((Age_Gro[Size500to520] EQ 13) AND (Sex_Gro[Size500to520] EQ 1), Age13Size500to520countF)
AGE14Size500to520F = WHERE((Age_Gro[Size500to520] EQ 14) AND (Sex_Gro[Size500to520] EQ 1), Age14Size500to520countF)
AGE15Size500to520F = WHERE((Age_Gro[Size500to520] EQ 15) AND (Sex_Gro[Size500to520] EQ 1), Age15Size500to520countF)
age16Size500to520F = WHERE((Age_Gro[Size500to520] EQ 16) AND (Sex_Gro[Size500to520] EQ 1), Age16Size500to520countF)
age17Size500to520F = WHERE((Age_Gro[Size500to520] EQ 17) AND (Sex_Gro[Size500to520] EQ 1), Age17Size500to520countF)
age18Size500to520F = WHERE((Age_Gro[Size500to520] EQ 18) AND (Sex_Gro[Size500to520] EQ 1), Age18Size500to520countF)
age19Size500to520F = WHERE((Age_Gro[Size500to520] EQ 19) AND (Sex_Gro[Size500to520] EQ 1), Age19Size500to520countF)
age20Size500to520F = WHERE((Age_Gro[Size500to520] EQ 20) AND (Sex_Gro[Size500to520] EQ 1), Age20Size500to520countF)
age21Size500to520F = WHERE((Age_Gro[Size500to520] EQ 21) AND (Sex_Gro[Size500to520] EQ 1), Age21Size500to520countF)
age22Size500to520F = WHERE((Age_Gro[Size500to520] EQ 22) AND (Sex_Gro[Size500to520] EQ 1), Age22Size500to520countF)
age23Size500to520F = WHERE((Age_Gro[Size500to520] EQ 23) AND (Sex_Gro[Size500to520] EQ 1), Age23Size500to520countF)
age24Size500to520F = WHERE((Age_Gro[Size500to520] EQ 24) AND (Sex_Gro[Size500to520] EQ 1), Age24Size500to520countF)
age25Size500to520F = WHERE((Age_Gro[Size500to520] EQ 25) AND (Sex_Gro[Size500to520] EQ 1), Age25Size500to520countF)
age26Size500to520F = WHERE((Age_Gro[Size500to520] EQ 26) AND (Sex_Gro[Size500to520] EQ 1), Age26Size500to520countF)

  WAE_length_bin[70, i*NumLengthBin+adj+21L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+21L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+21L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+21L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+21L] = 500
  WAE_length_bin[75, i*NumLengthBin+adj+21L] = Size500to520countF

  WAE_length_bin[76, i*NumLengthBin+adj+21L] = Age0Size500to520countF
  WAE_length_bin[77, i*NumLengthBin+adj+21L] = Age1Size500to520countF
  WAE_length_bin[78, i*NumLengthBin+adj+21L] = Age2Size500to520countF
  WAE_length_bin[79, i*NumLengthBin+adj+21L] = Age3Size500to520countF
  WAE_length_bin[80, i*NumLengthBin+adj+21L] = Age4Size500to520countF
  WAE_length_bin[81, i*NumLengthBin+adj+21L] = Age5Size500to520countF
  WAE_length_bin[82, i*NumLengthBin+adj+21L] = Age6Size500to520countF
  WAE_length_bin[83, i*NumLengthBin+adj+21L] = Age7Size500to520countF
  WAE_length_bin[84, i*NumLengthBin+adj+21L] = Age8Size500to520countF
  WAE_length_bin[85, i*NumLengthBin+adj+21L] = Age9Size500to520countF
  WAE_length_bin[86, i*NumLengthBin+adj+21L] = Age10Size500to520countF
  WAE_length_bin[87, i*NumLengthBin+adj+21L] = Age11Size500to520countF
  WAE_length_bin[88, i*NumLengthBin+adj+21L] = Age12Size500to520countF
  WAE_length_bin[89, i*NumLengthBin+adj+21L] = Age13Size500to520countF
  WAE_length_bin[90, i*NumLengthBin+adj+21L] = Age14Size500to520countF
  WAE_length_bin[91, i*NumLengthBin+adj+21L] = Age15Size500to520countF
  WAE_length_bin[92, i*NumLengthBin+adj+21L] = Age16Size500to520countF
  WAE_length_bin[93, i*NumLengthBin+adj+21L] = Age17Size500to520countF
  WAE_length_bin[94, i*NumLengthBin+adj+21L] = Age18Size500to520countF
  WAE_length_bin[95, i*NumLengthBin+adj+21L] = Age19Size500to520countF
  WAE_length_bin[96, i*NumLengthBin+adj+21L] = Age20Size500to520countF
  WAE_length_bin[97, i*NumLengthBin+adj+21L] = Age21Size500to520countF
  WAE_length_bin[98, i*NumLengthBin+adj+21L] = Age22Size500to520countF
  WAE_length_bin[99, i*NumLengthBin+adj+21L] = Age23Size500to520countF
  WAE_length_bin[100, i*NumLengthBin+adj+21L] = Age24Size500to520countF
  WAE_length_bin[101, i*NumLengthBin+adj+21L] = Age25Size500to520countF
  WAE_length_bin[102, i*NumLengthBin+adj+21L] = Age26Size500to520countF
  ENDIF
PRINT, 'Size500to520F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+21L])

; length bin 23
IF Size520to540countF GT 0 THEN BEGIN
age0Size520to540F = WHERE((Age_Gro[Size520to540] EQ 1) AND (Sex_Gro[Size520to540] EQ 1), Age0Size520to540countF)
age1Size520to540F = WHERE((Age_Gro[Size520to540] EQ 1) AND (Sex_Gro[Size520to540] EQ 1), Age1Size520to540countF)
age2Size520to540F = WHERE((Age_Gro[Size520to540] EQ 2) AND (Sex_Gro[Size520to540] EQ 1), Age2Size520to540countF)
age3Size520to540F = WHERE((Age_Gro[Size520to540] EQ 3) AND (Sex_Gro[Size520to540] EQ 1), Age3Size520to540countF)
age4Size520to540F = WHERE((Age_Gro[Size520to540] EQ 4) AND (Sex_Gro[Size520to540] EQ 1), Age4Size520to540countF)
age5Size520to540F = WHERE((Age_Gro[Size520to540] EQ 5) AND (Sex_Gro[Size520to540] EQ 1), Age5Size520to540countF)
age6Size520to540F = WHERE((Age_Gro[Size520to540] EQ 6) AND (Sex_Gro[Size520to540] EQ 1), Age6Size520to540countF)
age7Size520to540F = WHERE((Age_Gro[Size520to540] EQ 7) AND (Sex_Gro[Size520to540] EQ 1), Age7Size520to540countF)
age8Size520to540F = WHERE((Age_Gro[Size520to540] EQ 8) AND (Sex_Gro[Size520to540] EQ 1), Age8Size520to540countF)
age9Size520to540F = WHERE((Age_Gro[Size520to540] EQ 9) AND (Sex_Gro[Size520to540] EQ 1), Age9Size520to540countF)
age10Size520to540F = WHERE((Age_Gro[Size520to540] EQ 10) AND (Sex_Gro[Size520to540] EQ 1), Age10Size520to540countF)
age11Size520to540F = WHERE((Age_Gro[Size520to540] EQ 11) AND (Sex_Gro[Size520to540] EQ 1), Age11Size520to540countF)
AGE12Size520to540F = WHERE((Age_Gro[Size520to540] EQ 12) AND (Sex_Gro[Size520to540] EQ 1), Age12Size520to540countF)
AGE13Size520to540F = WHERE((Age_Gro[Size520to540] EQ 13) AND (Sex_Gro[Size520to540] EQ 1), Age13Size520to540countF)
AGE14Size520to540F = WHERE((Age_Gro[Size520to540] EQ 14) AND (Sex_Gro[Size520to540] EQ 1), Age14Size520to540countF)
AGE15Size520to540F = WHERE((Age_Gro[Size520to540] EQ 15) AND (Sex_Gro[Size520to540] EQ 1), Age15Size520to540countF)
age16Size520to540F = WHERE((Age_Gro[Size520to540] EQ 16) AND (Sex_Gro[Size520to540] EQ 1), Age16Size520to540countF)
age17Size520to540F = WHERE((Age_Gro[Size520to540] EQ 17) AND (Sex_Gro[Size520to540] EQ 1), Age17Size520to540countF)
age18Size520to540F = WHERE((Age_Gro[Size520to540] EQ 18) AND (Sex_Gro[Size520to540] EQ 1), Age18Size520to540countF)
age19Size520to540F = WHERE((Age_Gro[Size520to540] EQ 19) AND (Sex_Gro[Size520to540] EQ 1), Age19Size520to540countF)
age20Size520to540F = WHERE((Age_Gro[Size520to540] EQ 20) AND (Sex_Gro[Size520to540] EQ 1), Age20Size520to540countF)
age21Size520to540F = WHERE((Age_Gro[Size520to540] EQ 21) AND (Sex_Gro[Size520to540] EQ 1), Age21Size520to540countF)
age22Size520to540F = WHERE((Age_Gro[Size520to540] EQ 22) AND (Sex_Gro[Size520to540] EQ 1), Age22Size520to540countF)
age23Size520to540F = WHERE((Age_Gro[Size520to540] EQ 23) AND (Sex_Gro[Size520to540] EQ 1), Age23Size520to540countF)
age24Size520to540F = WHERE((Age_Gro[Size520to540] EQ 24) AND (Sex_Gro[Size520to540] EQ 1), Age24Size520to540countF)
age25Size520to540F = WHERE((Age_Gro[Size520to540] EQ 25) AND (Sex_Gro[Size520to540] EQ 1), Age25Size520to540countF)
age26Size520to540F = WHERE((Age_Gro[Size520to540] EQ 26) AND (Sex_Gro[Size520to540] EQ 1), Age26Size520to540countF)

  WAE_length_bin[70, i*NumLengthBin+adj+22L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+22L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+22L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+22L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+22L] = 520
  WAE_length_bin[75, i*NumLengthBin+adj+22L] = Size520to540countF

  WAE_length_bin[76, i*NumLengthBin+adj+22L] = Age0Size520to540countF
  WAE_length_bin[77, i*NumLengthBin+adj+22L] = Age1Size520to540countF
  WAE_length_bin[78, i*NumLengthBin+adj+22L] = Age2Size520to540countF
  WAE_length_bin[79, i*NumLengthBin+adj+22L] = Age3Size520to540countF
  WAE_length_bin[80, i*NumLengthBin+adj+22L] = Age4Size520to540countF
  WAE_length_bin[81, i*NumLengthBin+adj+22L] = Age5Size520to540countF
  WAE_length_bin[82, i*NumLengthBin+adj+22L] = Age6Size520to540countF
  WAE_length_bin[83, i*NumLengthBin+adj+22L] = Age7Size520to540countF
  WAE_length_bin[84, i*NumLengthBin+adj+22L] = Age8Size520to540countF
  WAE_length_bin[85, i*NumLengthBin+adj+22L] = Age9Size520to540countF
  WAE_length_bin[86, i*NumLengthBin+adj+22L] = Age10Size520to540countF
  WAE_length_bin[87, i*NumLengthBin+adj+22L] = Age11Size520to540countF
  WAE_length_bin[88, i*NumLengthBin+adj+22L] = Age12Size520to540countF
  WAE_length_bin[89, i*NumLengthBin+adj+22L] = Age13Size520to540countF
  WAE_length_bin[90, i*NumLengthBin+adj+22L] = Age14Size520to540countF
  WAE_length_bin[91, i*NumLengthBin+adj+22L] = Age15Size520to540countF
  WAE_length_bin[92, i*NumLengthBin+adj+22L] = Age16Size520to540countF
  WAE_length_bin[93, i*NumLengthBin+adj+22L] = Age17Size520to540countF
  WAE_length_bin[94, i*NumLengthBin+adj+22L] = Age18Size520to540countF
  WAE_length_bin[95, i*NumLengthBin+adj+22L] = Age19Size520to540countF
  WAE_length_bin[96, i*NumLengthBin+adj+22L] = Age20Size520to540countF
  WAE_length_bin[97, i*NumLengthBin+adj+22L] = Age21Size520to540countF
  WAE_length_bin[98, i*NumLengthBin+adj+22L] = Age22Size520to540countF
  WAE_length_bin[99, i*NumLengthBin+adj+22L] = Age23Size520to540countF
  WAE_length_bin[100, i*NumLengthBin+adj+22L] = Age24Size520to540countF
  WAE_length_bin[101, i*NumLengthBin+adj+22L] = Age25Size520to540countF
  WAE_length_bin[102, i*NumLengthBin+adj+22L] = Age26Size520to540countF
  ENDIF
PRINT, 'Size520to540F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+22L])

; length bin 24
IF Size540to560countF GT 0 THEN BEGIN
age0Size540to560F = WHERE((Age_Gro[Size540to560] EQ 1) AND (Sex_Gro[Size540to560] EQ 1), Age0Size540to560countF)
age1Size540to560F = WHERE((Age_Gro[Size540to560] EQ 1) AND (Sex_Gro[Size540to560] EQ 1), Age1Size540to560countF)
age2Size540to560F = WHERE((Age_Gro[Size540to560] EQ 2) AND (Sex_Gro[Size540to560] EQ 1), Age2Size540to560countF)
age3Size540to560F = WHERE((Age_Gro[Size540to560] EQ 3) AND (Sex_Gro[Size540to560] EQ 1), Age3Size540to560countF)
age4Size540to560F = WHERE((Age_Gro[Size540to560] EQ 4) AND (Sex_Gro[Size540to560] EQ 1), Age4Size540to560countF)
age5Size540to560F = WHERE((Age_Gro[Size540to560] EQ 5) AND (Sex_Gro[Size540to560] EQ 1), Age5Size540to560countF)
age6Size540to560F = WHERE((Age_Gro[Size540to560] EQ 6) AND (Sex_Gro[Size540to560] EQ 1), Age6Size540to560countF)
age7Size540to560F = WHERE((Age_Gro[Size540to560] EQ 7) AND (Sex_Gro[Size540to560] EQ 1), Age7Size540to560countF)
age8Size540to560F = WHERE((Age_Gro[Size540to560] EQ 8) AND (Sex_Gro[Size540to560] EQ 1), Age8Size540to560countF)
age9Size540to560F = WHERE((Age_Gro[Size540to560] EQ 9) AND (Sex_Gro[Size540to560] EQ 1), Age9Size540to560countF)
age10Size540to560F = WHERE((Age_Gro[Size540to560] EQ 10) AND (Sex_Gro[Size540to560] EQ 1), Age10Size540to560countF)
age11Size540to560F = WHERE((Age_Gro[Size540to560] EQ 11) AND (Sex_Gro[Size540to560] EQ 1), Age11Size540to560countF)
AGE12Size540to560F = WHERE((Age_Gro[Size540to560] EQ 12) AND (Sex_Gro[Size540to560] EQ 1), Age12Size540to560countF)
AGE13Size540to560F = WHERE((Age_Gro[Size540to560] EQ 13) AND (Sex_Gro[Size540to560] EQ 1), Age13Size540to560countF)
AGE14Size540to560F = WHERE((Age_Gro[Size540to560] EQ 14) AND (Sex_Gro[Size540to560] EQ 1), Age14Size540to560countF)
AGE15Size540to560F = WHERE((Age_Gro[Size540to560] EQ 15) AND (Sex_Gro[Size540to560] EQ 1), Age15Size540to560countF)
age16Size540to560F = WHERE((Age_Gro[Size540to560] EQ 16) AND (Sex_Gro[Size540to560] EQ 1), Age16Size540to560countF)
age17Size540to560F = WHERE((Age_Gro[Size540to560] EQ 17) AND (Sex_Gro[Size540to560] EQ 1), Age17Size540to560countF)
age18Size540to560F = WHERE((Age_Gro[Size540to560] EQ 18) AND (Sex_Gro[Size540to560] EQ 1), Age18Size540to560countF)
age19Size540to560F = WHERE((Age_Gro[Size540to560] EQ 19) AND (Sex_Gro[Size540to560] EQ 1), Age19Size540to560countF)
age20Size540to560F = WHERE((Age_Gro[Size540to560] EQ 20) AND (Sex_Gro[Size540to560] EQ 1), Age20Size540to560countF)
age21Size540to560F = WHERE((Age_Gro[Size540to560] EQ 21) AND (Sex_Gro[Size540to560] EQ 1), Age21Size540to560countF)
age22Size540to560F = WHERE((Age_Gro[Size540to560] EQ 22) AND (Sex_Gro[Size540to560] EQ 1), Age22Size540to560countF)
age23Size540to560F = WHERE((Age_Gro[Size540to560] EQ 23) AND (Sex_Gro[Size540to560] EQ 1), Age23Size540to560countF)
age24Size540to560F = WHERE((Age_Gro[Size540to560] EQ 24) AND (Sex_Gro[Size540to560] EQ 1), Age24Size540to560countF)
age25Size540to560F = WHERE((Age_Gro[Size540to560] EQ 25) AND (Sex_Gro[Size540to560] EQ 1), Age25Size540to560countF)
age26Size540to560F = WHERE((Age_Gro[Size540to560] EQ 26) AND (Sex_Gro[Size540to560] EQ 1), Age26Size540to560countF)

  WAE_length_bin[70, i*NumLengthBin+adj+23L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+23L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+23L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+23L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+23L] = 540
  WAE_length_bin[75, i*NumLengthBin+adj+23L] = Size540to560countF

  WAE_length_bin[76, i*NumLengthBin+adj+23L] = Age0Size540to560countF
  WAE_length_bin[77, i*NumLengthBin+adj+23L] = Age1Size540to560countF
  WAE_length_bin[78, i*NumLengthBin+adj+23L] = Age2Size540to560countF
  WAE_length_bin[79, i*NumLengthBin+adj+23L] = Age3Size540to560countF
  WAE_length_bin[80, i*NumLengthBin+adj+23L] = Age4Size540to560countF
  WAE_length_bin[81, i*NumLengthBin+adj+23L] = Age5Size540to560countF
  WAE_length_bin[82, i*NumLengthBin+adj+23L] = Age6Size540to560countF
  WAE_length_bin[83, i*NumLengthBin+adj+23L] = Age7Size540to560countF
  WAE_length_bin[84, i*NumLengthBin+adj+23L] = Age8Size540to560countF
  WAE_length_bin[85, i*NumLengthBin+adj+23L] = Age9Size540to560countF
  WAE_length_bin[86, i*NumLengthBin+adj+23L] = Age10Size540to560countF
  WAE_length_bin[87, i*NumLengthBin+adj+23L] = Age11Size540to560countF
  WAE_length_bin[88, i*NumLengthBin+adj+23L] = Age12Size540to560countF
  WAE_length_bin[89, i*NumLengthBin+adj+23L] = Age13Size540to560countF
  WAE_length_bin[90, i*NumLengthBin+adj+23L] = Age14Size540to560countF
  WAE_length_bin[91, i*NumLengthBin+adj+23L] = Age15Size540to560countF
  WAE_length_bin[92, i*NumLengthBin+adj+23L] = Age16Size540to560countF
  WAE_length_bin[93, i*NumLengthBin+adj+23L] = Age17Size540to560countF
  WAE_length_bin[94, i*NumLengthBin+adj+23L] = Age18Size540to560countF
  WAE_length_bin[95, i*NumLengthBin+adj+23L] = Age19Size540to560countF
  WAE_length_bin[96, i*NumLengthBin+adj+23L] = Age20Size540to560countF
  WAE_length_bin[97, i*NumLengthBin+adj+23L] = Age21Size540to560countF
  WAE_length_bin[98, i*NumLengthBin+adj+23L] = Age22Size540to560countF
  WAE_length_bin[99, i*NumLengthBin+adj+23L] = Age23Size540to560countF
  WAE_length_bin[100, i*NumLengthBin+adj+23L] = Age24Size540to560countF
  WAE_length_bin[101, i*NumLengthBin+adj+23L] = Age25Size540to560countF
  WAE_length_bin[102, i*NumLengthBin+adj+23L] = Age26Size540to560countF
  ENDIF
PRINT, 'Size540to560F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+23L])

; length bin 25
IF Size560to580countF GT 0 THEN BEGIN
age0Size560to580F = WHERE((Age_Gro[Size560to580] EQ 1) AND (Sex_Gro[Size560to580] EQ 1), Age0Size560to580countF)
age1Size560to580F = WHERE((Age_Gro[Size560to580] EQ 1) AND (Sex_Gro[Size560to580] EQ 1), Age1Size560to580countF)
age2Size560to580F = WHERE((Age_Gro[Size560to580] EQ 2) AND (Sex_Gro[Size560to580] EQ 1), Age2Size560to580countF)
age3Size560to580F = WHERE((Age_Gro[Size560to580] EQ 3) AND (Sex_Gro[Size560to580] EQ 1), Age3Size560to580countF)
age4Size560to580F = WHERE((Age_Gro[Size560to580] EQ 4) AND (Sex_Gro[Size560to580] EQ 1), Age4Size560to580countF)
age5Size560to580F = WHERE((Age_Gro[Size560to580] EQ 5) AND (Sex_Gro[Size560to580] EQ 1), Age5Size560to580countF)
age6Size560to580F = WHERE((Age_Gro[Size560to580] EQ 6) AND (Sex_Gro[Size560to580] EQ 1), Age6Size560to580countF)
age7Size560to580F = WHERE((Age_Gro[Size560to580] EQ 7) AND (Sex_Gro[Size560to580] EQ 1), Age7Size560to580countF)
age8Size560to580F = WHERE((Age_Gro[Size560to580] EQ 8) AND (Sex_Gro[Size560to580] EQ 1), Age8Size560to580countF)
age9Size560to580F = WHERE((Age_Gro[Size560to580] EQ 9) AND (Sex_Gro[Size560to580] EQ 1), Age9Size560to580countF)
age10Size560to580F = WHERE((Age_Gro[Size560to580] EQ 10) AND (Sex_Gro[Size560to580] EQ 1), Age10Size560to580countF)
age11Size560to580F = WHERE((Age_Gro[Size560to580] EQ 11) AND (Sex_Gro[Size560to580] EQ 1), Age11Size560to580countF)
AGE12Size560to580F = WHERE((Age_Gro[Size560to580] EQ 12) AND (Sex_Gro[Size560to580] EQ 1), Age12Size560to580countF)
AGE13Size560to580F = WHERE((Age_Gro[Size560to580] EQ 13) AND (Sex_Gro[Size560to580] EQ 1), Age13Size560to580countF)
AGE14Size560to580F = WHERE((Age_Gro[Size560to580] EQ 14) AND (Sex_Gro[Size560to580] EQ 1), Age14Size560to580countF)
AGE15Size560to580F = WHERE((Age_Gro[Size560to580] EQ 15) AND (Sex_Gro[Size560to580] EQ 1), Age15Size560to580countF)
age16Size560to580F = WHERE((Age_Gro[Size560to580] EQ 16) AND (Sex_Gro[Size560to580] EQ 1), Age16Size560to580countF)
age17Size560to580F = WHERE((Age_Gro[Size560to580] EQ 17) AND (Sex_Gro[Size560to580] EQ 1), Age17Size560to580countF)
age18Size560to580F = WHERE((Age_Gro[Size560to580] EQ 18) AND (Sex_Gro[Size560to580] EQ 1), Age18Size560to580countF)
age19Size560to580F = WHERE((Age_Gro[Size560to580] EQ 19) AND (Sex_Gro[Size560to580] EQ 1), Age19Size560to580countF)
age20Size560to580F = WHERE((Age_Gro[Size560to580] EQ 20) AND (Sex_Gro[Size560to580] EQ 1), Age20Size560to580countF)
age21Size560to580F = WHERE((Age_Gro[Size560to580] EQ 21) AND (Sex_Gro[Size560to580] EQ 1), Age21Size560to580countF)
age22Size560to580F = WHERE((Age_Gro[Size560to580] EQ 22) AND (Sex_Gro[Size560to580] EQ 1), Age22Size560to580countF)
age23Size560to580F = WHERE((Age_Gro[Size560to580] EQ 23) AND (Sex_Gro[Size560to580] EQ 1), Age23Size560to580countF)
age24Size560to580F = WHERE((Age_Gro[Size560to580] EQ 24) AND (Sex_Gro[Size560to580] EQ 1), Age24Size560to580countF)
age25Size560to580F = WHERE((Age_Gro[Size560to580] EQ 25) AND (Sex_Gro[Size560to580] EQ 1), Age25Size560to580countF)
age26Size560to580F = WHERE((Age_Gro[Size560to580] EQ 26) AND (Sex_Gro[Size560to580] EQ 1), Age26Size560to580countF)

  WAE_length_bin[70, i*NumLengthBin+adj+24L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+24L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+24L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+24L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+24L] = 560
  WAE_length_bin[75, i*NumLengthBin+adj+24L] = Size560to580countF

  WAE_length_bin[76, i*NumLengthBin+adj+24L] = Age0Size560to580countF
  WAE_length_bin[77, i*NumLengthBin+adj+24L] = Age1Size560to580countF
  WAE_length_bin[78, i*NumLengthBin+adj+24L] = Age2Size560to580countF
  WAE_length_bin[79, i*NumLengthBin+adj+24L] = Age3Size560to580countF
  WAE_length_bin[80, i*NumLengthBin+adj+24L] = Age4Size560to580countF
  WAE_length_bin[81, i*NumLengthBin+adj+24L] = Age5Size560to580countF
  WAE_length_bin[82, i*NumLengthBin+adj+24L] = Age6Size560to580countF
  WAE_length_bin[83, i*NumLengthBin+adj+24L] = Age7Size560to580countF
  WAE_length_bin[84, i*NumLengthBin+adj+24L] = Age8Size560to580countF
  WAE_length_bin[85, i*NumLengthBin+adj+24L] = Age9Size560to580countF
  WAE_length_bin[86, i*NumLengthBin+adj+24L] = Age10Size560to580countF
  WAE_length_bin[87, i*NumLengthBin+adj+24L] = Age11Size560to580countF
  WAE_length_bin[88, i*NumLengthBin+adj+24L] = Age12Size560to580countF
  WAE_length_bin[89, i*NumLengthBin+adj+24L] = Age13Size560to580countF
  WAE_length_bin[90, i*NumLengthBin+adj+24L] = Age14Size560to580countF
  WAE_length_bin[91, i*NumLengthBin+adj+24L] = Age15Size560to580countF
  WAE_length_bin[92, i*NumLengthBin+adj+24L] = Age16Size560to580countF
  WAE_length_bin[93, i*NumLengthBin+adj+24L] = Age17Size560to580countF
  WAE_length_bin[94, i*NumLengthBin+adj+24L] = Age18Size560to580countF
  WAE_length_bin[95, i*NumLengthBin+adj+24L] = Age19Size560to580countF
  WAE_length_bin[96, i*NumLengthBin+adj+24L] = Age20Size560to580countF
  WAE_length_bin[97, i*NumLengthBin+adj+24L] = Age21Size560to580countF
  WAE_length_bin[98, i*NumLengthBin+adj+24L] = Age22Size560to580countF
  WAE_length_bin[99, i*NumLengthBin+adj+24L] = Age23Size560to580countF
  WAE_length_bin[100, i*NumLengthBin+adj+24L] = Age24Size560to580countF
  WAE_length_bin[101, i*NumLengthBin+adj+24L] = Age25Size560to580countF
  WAE_length_bin[102, i*NumLengthBin+adj+24L] = Age26Size560to580countF
  ENDIF
PRINT, 'Size560to580F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+24L])

; length bin 26
IF Size580to600countF GT 0 THEN BEGIN
age0Size580to600F = WHERE((Age_Gro[Size580to600] EQ 1) AND (Sex_Gro[Size580to600] EQ 1), Age0Size580to600countF)
age1Size580to600F = WHERE((Age_Gro[Size580to600] EQ 1) AND (Sex_Gro[Size580to600] EQ 1), Age1Size580to600countF)
age2Size580to600F = WHERE((Age_Gro[Size580to600] EQ 2) AND (Sex_Gro[Size580to600] EQ 1), Age2Size580to600countF)
age3Size580to600F = WHERE((Age_Gro[Size580to600] EQ 3) AND (Sex_Gro[Size580to600] EQ 1), Age3Size580to600countF)
age4Size580to600F = WHERE((Age_Gro[Size580to600] EQ 4) AND (Sex_Gro[Size580to600] EQ 1), Age4Size580to600countF)
age5Size580to600F = WHERE((Age_Gro[Size580to600] EQ 5) AND (Sex_Gro[Size580to600] EQ 1), Age5Size580to600countF)
age6Size580to600F = WHERE((Age_Gro[Size580to600] EQ 6) AND (Sex_Gro[Size580to600] EQ 1), Age6Size580to600countF)
age7Size580to600F = WHERE((Age_Gro[Size580to600] EQ 7) AND (Sex_Gro[Size580to600] EQ 1), Age7Size580to600countF)
age8Size580to600F = WHERE((Age_Gro[Size580to600] EQ 8) AND (Sex_Gro[Size580to600] EQ 1), Age8Size580to600countF)
age9Size580to600F = WHERE((Age_Gro[Size580to600] EQ 9) AND (Sex_Gro[Size580to600] EQ 1), Age9Size580to600countF)
age10Size580to600F = WHERE((Age_Gro[Size580to600] EQ 10) AND (Sex_Gro[Size580to600] EQ 1), Age10Size580to600countF)
age11Size580to600F = WHERE((Age_Gro[Size580to600] EQ 11) AND (Sex_Gro[Size580to600] EQ 1), Age11Size580to600countF)
AGE12Size580to600F = WHERE((Age_Gro[Size580to600] EQ 12) AND (Sex_Gro[Size580to600] EQ 1), Age12Size580to600countF)
AGE13Size580to600F = WHERE((Age_Gro[Size580to600] EQ 13) AND (Sex_Gro[Size580to600] EQ 1), Age13Size580to600countF)
AGE14Size580to600F = WHERE((Age_Gro[Size580to600] EQ 14) AND (Sex_Gro[Size580to600] EQ 1), Age14Size580to600countF)
AGE15Size580to600F = WHERE((Age_Gro[Size580to600] EQ 15) AND (Sex_Gro[Size580to600] EQ 1), Age15Size580to600countF)
age16Size580to600F = WHERE((Age_Gro[Size580to600] EQ 16) AND (Sex_Gro[Size580to600] EQ 1), Age16Size580to600countF)
age17Size580to600F = WHERE((Age_Gro[Size580to600] EQ 17) AND (Sex_Gro[Size580to600] EQ 1), Age17Size580to600countF)
age18Size580to600F = WHERE((Age_Gro[Size580to600] EQ 18) AND (Sex_Gro[Size580to600] EQ 1), Age18Size580to600countF)
age19Size580to600F = WHERE((Age_Gro[Size580to600] EQ 19) AND (Sex_Gro[Size580to600] EQ 1), Age19Size580to600countF)
age20Size580to600F = WHERE((Age_Gro[Size580to600] EQ 20) AND (Sex_Gro[Size580to600] EQ 1), Age20Size580to600countF)
age21Size580to600F = WHERE((Age_Gro[Size580to600] EQ 21) AND (Sex_Gro[Size580to600] EQ 1), Age21Size580to600countF)
age22Size580to600F = WHERE((Age_Gro[Size580to600] EQ 22) AND (Sex_Gro[Size580to600] EQ 1), Age22Size580to600countF)
age23Size580to600F = WHERE((Age_Gro[Size580to600] EQ 23) AND (Sex_Gro[Size580to600] EQ 1), Age23Size580to600countF)
age24Size580to600F = WHERE((Age_Gro[Size580to600] EQ 24) AND (Sex_Gro[Size580to600] EQ 1), Age24Size580to600countF)
age25Size580to600F = WHERE((Age_Gro[Size580to600] EQ 25) AND (Sex_Gro[Size580to600] EQ 1), Age25Size580to600countF)
age26Size580to600F = WHERE((Age_Gro[Size580to600] EQ 26) AND (Sex_Gro[Size580to600] EQ 1), Age26Size580to600countF)

  WAE_length_bin[70, i*NumLengthBin+adj+25L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+25L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+25L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+25L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+25L] = 580
  WAE_length_bin[75, i*NumLengthBin+adj+25L] = Size580to600countF

  WAE_length_bin[76, i*NumLengthBin+adj+25L] = Age0Size580to600countF
  WAE_length_bin[77, i*NumLengthBin+adj+25L] = Age1Size580to600countF
  WAE_length_bin[78, i*NumLengthBin+adj+25L] = Age2Size580to600countF
  WAE_length_bin[79, i*NumLengthBin+adj+25L] = Age3Size580to600countF
  WAE_length_bin[80, i*NumLengthBin+adj+25L] = Age4Size580to600countF
  WAE_length_bin[81, i*NumLengthBin+adj+25L] = Age5Size580to600countF
  WAE_length_bin[82, i*NumLengthBin+adj+25L] = Age6Size580to600countF
  WAE_length_bin[83, i*NumLengthBin+adj+25L] = Age7Size580to600countF
  WAE_length_bin[84, i*NumLengthBin+adj+25L] = Age8Size580to600countF
  WAE_length_bin[85, i*NumLengthBin+adj+25L] = Age9Size580to600countF
  WAE_length_bin[86, i*NumLengthBin+adj+25L] = Age10Size580to600countF
  WAE_length_bin[87, i*NumLengthBin+adj+25L] = Age11Size580to600countF
  WAE_length_bin[88, i*NumLengthBin+adj+25L] = Age12Size580to600countF
  WAE_length_bin[89, i*NumLengthBin+adj+25L] = Age13Size580to600countF
  WAE_length_bin[90, i*NumLengthBin+adj+25L] = Age14Size580to600countF
  WAE_length_bin[91, i*NumLengthBin+adj+25L] = Age15Size580to600countF
  WAE_length_bin[92, i*NumLengthBin+adj+25L] = Age16Size580to600countF
  WAE_length_bin[93, i*NumLengthBin+adj+25L] = Age17Size580to600countF
  WAE_length_bin[94, i*NumLengthBin+adj+25L] = Age18Size580to600countF
  WAE_length_bin[95, i*NumLengthBin+adj+25L] = Age19Size580to600countF
  WAE_length_bin[96, i*NumLengthBin+adj+25L] = Age20Size580to600countF
  WAE_length_bin[97, i*NumLengthBin+adj+25L] = Age21Size580to600countF
  WAE_length_bin[98, i*NumLengthBin+adj+25L] = Age22Size580to600countF
  WAE_length_bin[99, i*NumLengthBin+adj+25L] = Age23Size580to600countF
  WAE_length_bin[100, i*NumLengthBin+adj+25L] = Age24Size580to600countF
  WAE_length_bin[101, i*NumLengthBin+adj+25L] = Age25Size580to600countF
  WAE_length_bin[102, i*NumLengthBin+adj+25L] = Age26Size580to600countF
  ENDIF
PRINT, 'Size580to600F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+25L])

; length bin 27
IF Size600to620countF GT 0 THEN BEGIN
age0Size600to620F = WHERE((Age_Gro[Size600to620] EQ 1) AND (Sex_Gro[Size600to620] EQ 1), Age0Size600to620countF)
age1Size600to620F = WHERE((Age_Gro[Size600to620] EQ 1) AND (Sex_Gro[Size600to620] EQ 1), Age1Size600to620countF)
age2Size600to620F = WHERE((Age_Gro[Size600to620] EQ 2) AND (Sex_Gro[Size600to620] EQ 1), Age2Size600to620countF)
age3Size600to620F = WHERE((Age_Gro[Size600to620] EQ 3) AND (Sex_Gro[Size600to620] EQ 1), Age3Size600to620countF)
age4Size600to620F = WHERE((Age_Gro[Size600to620] EQ 4) AND (Sex_Gro[Size600to620] EQ 1), Age4Size600to620countF)
age5Size600to620F = WHERE((Age_Gro[Size600to620] EQ 5) AND (Sex_Gro[Size600to620] EQ 1), Age5Size600to620countF)
age6Size600to620F = WHERE((Age_Gro[Size600to620] EQ 6) AND (Sex_Gro[Size600to620] EQ 1), Age6Size600to620countF)
age7Size600to620F = WHERE((Age_Gro[Size600to620] EQ 7) AND (Sex_Gro[Size600to620] EQ 1), Age7Size600to620countF)
age8Size600to620F = WHERE((Age_Gro[Size600to620] EQ 8) AND (Sex_Gro[Size600to620] EQ 1), Age8Size600to620countF)
age9Size600to620F = WHERE((Age_Gro[Size600to620] EQ 9) AND (Sex_Gro[Size600to620] EQ 1), Age9Size600to620countF)
age10Size600to620F = WHERE((Age_Gro[Size600to620] EQ 10) AND (Sex_Gro[Size600to620] EQ 1), Age10Size600to620countF)
age11Size600to620F = WHERE((Age_Gro[Size600to620] EQ 11) AND (Sex_Gro[Size600to620] EQ 1), Age11Size600to620countF)
AGE12Size600to620F = WHERE((Age_Gro[Size600to620] EQ 12) AND (Sex_Gro[Size600to620] EQ 1), Age12Size600to620countF)
AGE13Size600to620F = WHERE((Age_Gro[Size600to620] EQ 13) AND (Sex_Gro[Size600to620] EQ 1), Age13Size600to620countF)
AGE14Size600to620F = WHERE((Age_Gro[Size600to620] EQ 14) AND (Sex_Gro[Size600to620] EQ 1), Age14Size600to620countF)
AGE15Size600to620F = WHERE((Age_Gro[Size600to620] EQ 15) AND (Sex_Gro[Size600to620] EQ 1), Age15Size600to620countF)
age16Size600to620F = WHERE((Age_Gro[Size600to620] EQ 16) AND (Sex_Gro[Size600to620] EQ 1), Age16Size600to620countF)
age17Size600to620F = WHERE((Age_Gro[Size600to620] EQ 17) AND (Sex_Gro[Size600to620] EQ 1), Age17Size600to620countF)
age18Size600to620F = WHERE((Age_Gro[Size600to620] EQ 18) AND (Sex_Gro[Size600to620] EQ 1), Age18Size600to620countF)
age19Size600to620F = WHERE((Age_Gro[Size600to620] EQ 19) AND (Sex_Gro[Size600to620] EQ 1), Age19Size600to620countF)
age20Size600to620F = WHERE((Age_Gro[Size600to620] EQ 20) AND (Sex_Gro[Size600to620] EQ 1), Age20Size600to620countF)
age21Size600to620F = WHERE((Age_Gro[Size600to620] EQ 21) AND (Sex_Gro[Size600to620] EQ 1), Age21Size600to620countF)
age22Size600to620F = WHERE((Age_Gro[Size600to620] EQ 22) AND (Sex_Gro[Size600to620] EQ 1), Age22Size600to620countF)
age23Size600to620F = WHERE((Age_Gro[Size600to620] EQ 23) AND (Sex_Gro[Size600to620] EQ 1), Age23Size600to620countF)
age24Size600to620F = WHERE((Age_Gro[Size600to620] EQ 24) AND (Sex_Gro[Size600to620] EQ 1), Age24Size600to620countF)
age25Size600to620F = WHERE((Age_Gro[Size600to620] EQ 25) AND (Sex_Gro[Size600to620] EQ 1), Age25Size600to620countF)
age26Size600to620F = WHERE((Age_Gro[Size600to620] EQ 26) AND (Sex_Gro[Size600to620] EQ 1), Age26Size600to620countF)

  WAE_length_bin[70, i*NumLengthBin+adj+26L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+26L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+26L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+26L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+26L] = 600
  WAE_length_bin[75, i*NumLengthBin+adj+26L] = Size600to620countF

  WAE_length_bin[76, i*NumLengthBin+adj+26L] = Age0Size600to620countF
  WAE_length_bin[77, i*NumLengthBin+adj+26L] = Age1Size600to620countF
  WAE_length_bin[78, i*NumLengthBin+adj+26L] = Age2Size600to620countF
  WAE_length_bin[79, i*NumLengthBin+adj+26L] = Age3Size600to620countF
  WAE_length_bin[80, i*NumLengthBin+adj+26L] = Age4Size600to620countF
  WAE_length_bin[81, i*NumLengthBin+adj+26L] = Age5Size600to620countF
  WAE_length_bin[82, i*NumLengthBin+adj+26L] = Age6Size600to620countF
  WAE_length_bin[83, i*NumLengthBin+adj+26L] = Age7Size600to620countF
  WAE_length_bin[84, i*NumLengthBin+adj+26L] = Age8Size600to620countF
  WAE_length_bin[85, i*NumLengthBin+adj+26L] = Age9Size600to620countF
  WAE_length_bin[86, i*NumLengthBin+adj+26L] = Age10Size600to620countF
  WAE_length_bin[87, i*NumLengthBin+adj+26L] = Age11Size600to620countF
  WAE_length_bin[88, i*NumLengthBin+adj+26L] = Age12Size600to620countF
  WAE_length_bin[89, i*NumLengthBin+adj+26L] = Age13Size600to620countF
  WAE_length_bin[90, i*NumLengthBin+adj+26L] = Age14Size600to620countF
  WAE_length_bin[91, i*NumLengthBin+adj+26L] = Age15Size600to620countF
  WAE_length_bin[92, i*NumLengthBin+adj+26L] = Age16Size600to620countF
  WAE_length_bin[93, i*NumLengthBin+adj+26L] = Age17Size600to620countF
  WAE_length_bin[94, i*NumLengthBin+adj+26L] = Age18Size600to620countF
  WAE_length_bin[95, i*NumLengthBin+adj+26L] = Age19Size600to620countF
  WAE_length_bin[96, i*NumLengthBin+adj+26L] = Age20Size600to620countF
  WAE_length_bin[97, i*NumLengthBin+adj+26L] = Age21Size600to620countF
  WAE_length_bin[98, i*NumLengthBin+adj+26L] = Age22Size600to620countF
  WAE_length_bin[99, i*NumLengthBin+adj+26L] = Age23Size600to620countF
  WAE_length_bin[100, i*NumLengthBin+adj+26L] = Age24Size600to620countF
  WAE_length_bin[101, i*NumLengthBin+adj+26L] = Age25Size600to620countF
  WAE_length_bin[102, i*NumLengthBin+adj+26L] = Age26Size600to620countF
  ENDIF
PRINT, 'Size600to620F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+26L])


; length bin 28
IF Size620to640countF GT 0 THEN BEGIN
age0Size620to640F = WHERE((Age_Gro[Size620to640] EQ 1) AND (Sex_Gro[Size620to640] EQ 1), Age0Size620to640countF)
age1Size620to640F = WHERE((Age_Gro[Size620to640] EQ 1) AND (Sex_Gro[Size620to640] EQ 1), Age1Size620to640countF)
age2Size620to640F = WHERE((Age_Gro[Size620to640] EQ 2) AND (Sex_Gro[Size620to640] EQ 1), Age2Size620to640countF)
age3Size620to640F = WHERE((Age_Gro[Size620to640] EQ 3) AND (Sex_Gro[Size620to640] EQ 1), Age3Size620to640countF)
age4Size620to640F = WHERE((Age_Gro[Size620to640] EQ 4) AND (Sex_Gro[Size620to640] EQ 1), Age4Size620to640countF)
age5Size620to640F = WHERE((Age_Gro[Size620to640] EQ 5) AND (Sex_Gro[Size620to640] EQ 1), Age5Size620to640countF)
age6Size620to640F = WHERE((Age_Gro[Size620to640] EQ 6) AND (Sex_Gro[Size620to640] EQ 1), Age6Size620to640countF)
age7Size620to640F = WHERE((Age_Gro[Size620to640] EQ 7) AND (Sex_Gro[Size620to640] EQ 1), Age7Size620to640countF)
age8Size620to640F = WHERE((Age_Gro[Size620to640] EQ 8) AND (Sex_Gro[Size620to640] EQ 1), Age8Size620to640countF)
age9Size620to640F = WHERE((Age_Gro[Size620to640] EQ 9) AND (Sex_Gro[Size620to640] EQ 1), Age9Size620to640countF)
age10Size620to640F = WHERE((Age_Gro[Size620to640] EQ 10) AND (Sex_Gro[Size620to640] EQ 1), Age10Size620to640countF)
age11Size620to640F = WHERE((Age_Gro[Size620to640] EQ 11) AND (Sex_Gro[Size620to640] EQ 1), Age11Size620to640countF)
AGE12Size620to640F = WHERE((Age_Gro[Size620to640] EQ 12) AND (Sex_Gro[Size620to640] EQ 1), Age12Size620to640countF)
AGE13Size620to640F = WHERE((Age_Gro[Size620to640] EQ 13) AND (Sex_Gro[Size620to640] EQ 1), Age13Size620to640countF)
AGE14Size620to640F = WHERE((Age_Gro[Size620to640] EQ 14) AND (Sex_Gro[Size620to640] EQ 1), Age14Size620to640countF)
AGE15Size620to640F = WHERE((Age_Gro[Size620to640] EQ 15) AND (Sex_Gro[Size620to640] EQ 1), Age15Size620to640countF)
age16Size620to640F = WHERE((Age_Gro[Size620to640] EQ 16) AND (Sex_Gro[Size620to640] EQ 1), Age16Size620to640countF)
age17Size620to640F = WHERE((Age_Gro[Size620to640] EQ 17) AND (Sex_Gro[Size620to640] EQ 1), Age17Size620to640countF)
age18Size620to640F = WHERE((Age_Gro[Size620to640] EQ 18) AND (Sex_Gro[Size620to640] EQ 1), Age18Size620to640countF)
age19Size620to640F = WHERE((Age_Gro[Size620to640] EQ 19) AND (Sex_Gro[Size620to640] EQ 1), Age19Size620to640countF)
age20Size620to640F = WHERE((Age_Gro[Size620to640] EQ 20) AND (Sex_Gro[Size620to640] EQ 1), Age20Size620to640countF)
age21Size620to640F = WHERE((Age_Gro[Size620to640] EQ 21) AND (Sex_Gro[Size620to640] EQ 1), Age21Size620to640countF)
age22Size620to640F = WHERE((Age_Gro[Size620to640] EQ 22) AND (Sex_Gro[Size620to640] EQ 1), Age22Size620to640countF)
age23Size620to640F = WHERE((Age_Gro[Size620to640] EQ 23) AND (Sex_Gro[Size620to640] EQ 1), Age23Size620to640countF)
age24Size620to640F = WHERE((Age_Gro[Size620to640] EQ 24) AND (Sex_Gro[Size620to640] EQ 1), Age24Size620to640countF)
age25Size620to640F = WHERE((Age_Gro[Size620to640] EQ 25) AND (Sex_Gro[Size620to640] EQ 1), Age25Size620to640countF)
age26Size620to640F = WHERE((Age_Gro[Size620to640] EQ 26) AND (Sex_Gro[Size620to640] EQ 1), Age26Size620to640countF)

  WAE_length_bin[70, i*NumLengthBin+adj+27L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+27L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+27L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+27L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+27L] = 620
  WAE_length_bin[75, i*NumLengthBin+adj+27L] = Size620to640countF

  WAE_length_bin[76, i*NumLengthBin+adj+27L] = Age0Size620to640countF
  WAE_length_bin[77, i*NumLengthBin+adj+27L] = Age1Size620to640countF
  WAE_length_bin[78, i*NumLengthBin+adj+27L] = Age2Size620to640countF
  WAE_length_bin[79, i*NumLengthBin+adj+27L] = Age3Size620to640countF
  WAE_length_bin[80, i*NumLengthBin+adj+27L] = Age4Size620to640countF
  WAE_length_bin[81, i*NumLengthBin+adj+27L] = Age5Size620to640countF
  WAE_length_bin[82, i*NumLengthBin+adj+27L] = Age6Size620to640countF
  WAE_length_bin[83, i*NumLengthBin+adj+27L] = Age7Size620to640countF
  WAE_length_bin[84, i*NumLengthBin+adj+27L] = Age8Size620to640countF
  WAE_length_bin[85, i*NumLengthBin+adj+27L] = Age9Size620to640countF
  WAE_length_bin[86, i*NumLengthBin+adj+27L] = Age10Size620to640countF
  WAE_length_bin[87, i*NumLengthBin+adj+27L] = Age11Size620to640countF
  WAE_length_bin[88, i*NumLengthBin+adj+27L] = Age12Size620to640countF
  WAE_length_bin[89, i*NumLengthBin+adj+27L] = Age13Size620to640countF
  WAE_length_bin[90, i*NumLengthBin+adj+27L] = Age14Size620to640countF
  WAE_length_bin[91, i*NumLengthBin+adj+27L] = Age15Size620to640countF
  WAE_length_bin[92, i*NumLengthBin+adj+27L] = Age16Size620to640countF
  WAE_length_bin[93, i*NumLengthBin+adj+27L] = Age17Size620to640countF
  WAE_length_bin[94, i*NumLengthBin+adj+27L] = Age18Size620to640countF
  WAE_length_bin[95, i*NumLengthBin+adj+27L] = Age19Size620to640countF
  WAE_length_bin[96, i*NumLengthBin+adj+27L] = Age20Size620to640countF
  WAE_length_bin[97, i*NumLengthBin+adj+27L] = Age21Size620to640countF
  WAE_length_bin[98, i*NumLengthBin+adj+27L] = Age22Size620to640countF
  WAE_length_bin[99, i*NumLengthBin+adj+27L] = Age23Size620to640countF
  WAE_length_bin[100, i*NumLengthBin+adj+27L] = Age24Size620to640countF
  WAE_length_bin[101, i*NumLengthBin+adj+27L] = Age25Size620to640countF
  WAE_length_bin[102, i*NumLengthBin+adj+27L] = Age26Size620to640countF
  ENDIF
PRINT, 'Size620to640F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+27L])

; length bin 29
IF Size640to660countF GT 0 THEN BEGIN
age0Size640to660F = WHERE((Age_Gro[Size640to660] EQ 1) AND (Sex_Gro[Size640to660] EQ 1), Age0Size640to660countF)
age1Size640to660F = WHERE((Age_Gro[Size640to660] EQ 1) AND (Sex_Gro[Size640to660] EQ 1), Age1Size640to660countF)
age2Size640to660F = WHERE((Age_Gro[Size640to660] EQ 2) AND (Sex_Gro[Size640to660] EQ 1), Age2Size640to660countF)
age3Size640to660F = WHERE((Age_Gro[Size640to660] EQ 3) AND (Sex_Gro[Size640to660] EQ 1), Age3Size640to660countF)
age4Size640to660F = WHERE((Age_Gro[Size640to660] EQ 4) AND (Sex_Gro[Size640to660] EQ 1), Age4Size640to660countF)
age5Size640to660F = WHERE((Age_Gro[Size640to660] EQ 5) AND (Sex_Gro[Size640to660] EQ 1), Age5Size640to660countF)
age6Size640to660F = WHERE((Age_Gro[Size640to660] EQ 6) AND (Sex_Gro[Size640to660] EQ 1), Age6Size640to660countF)
age7Size640to660F = WHERE((Age_Gro[Size640to660] EQ 7) AND (Sex_Gro[Size640to660] EQ 1), Age7Size640to660countF)
age8Size640to660F = WHERE((Age_Gro[Size640to660] EQ 8) AND (Sex_Gro[Size640to660] EQ 1), Age8Size640to660countF)
age9Size640to660F = WHERE((Age_Gro[Size640to660] EQ 9) AND (Sex_Gro[Size640to660] EQ 1), Age9Size640to660countF)
age10Size640to660F = WHERE((Age_Gro[Size640to660] EQ 10) AND (Sex_Gro[Size640to660] EQ 1), Age10Size640to660countF)
age11Size640to660F = WHERE((Age_Gro[Size640to660] EQ 11) AND (Sex_Gro[Size640to660] EQ 1), Age11Size640to660countF)
AGE12Size640to660F = WHERE((Age_Gro[Size640to660] EQ 12) AND (Sex_Gro[Size640to660] EQ 1), Age12Size640to660countF)
AGE13Size640to660F = WHERE((Age_Gro[Size640to660] EQ 13) AND (Sex_Gro[Size640to660] EQ 1), Age13Size640to660countF)
AGE14Size640to660F = WHERE((Age_Gro[Size640to660] EQ 14) AND (Sex_Gro[Size640to660] EQ 1), Age14Size640to660countF)
AGE15Size640to660F = WHERE((Age_Gro[Size640to660] EQ 15) AND (Sex_Gro[Size640to660] EQ 1), Age15Size640to660countF)
age16Size640to660F = WHERE((Age_Gro[Size640to660] EQ 16) AND (Sex_Gro[Size640to660] EQ 1), Age16Size640to660countF)
age17Size640to660F = WHERE((Age_Gro[Size640to660] EQ 17) AND (Sex_Gro[Size640to660] EQ 1), Age17Size640to660countF)
age18Size640to660F = WHERE((Age_Gro[Size640to660] EQ 18) AND (Sex_Gro[Size640to660] EQ 1), Age18Size640to660countF)
age19Size640to660F = WHERE((Age_Gro[Size640to660] EQ 19) AND (Sex_Gro[Size640to660] EQ 1), Age19Size640to660countF)
age20Size640to660F = WHERE((Age_Gro[Size640to660] EQ 20) AND (Sex_Gro[Size640to660] EQ 1), Age20Size640to660countF)
age21Size640to660F = WHERE((Age_Gro[Size640to660] EQ 21) AND (Sex_Gro[Size640to660] EQ 1), Age21Size640to660countF)
age22Size640to660F = WHERE((Age_Gro[Size640to660] EQ 22) AND (Sex_Gro[Size640to660] EQ 1), Age22Size640to660countF)
age23Size640to660F = WHERE((Age_Gro[Size640to660] EQ 23) AND (Sex_Gro[Size640to660] EQ 1), Age23Size640to660countF)
age24Size640to660F = WHERE((Age_Gro[Size640to660] EQ 24) AND (Sex_Gro[Size640to660] EQ 1), Age24Size640to660countF)
age25Size640to660F = WHERE((Age_Gro[Size640to660] EQ 25) AND (Sex_Gro[Size640to660] EQ 1), Age25Size640to660countF)
age26Size640to660F = WHERE((Age_Gro[Size640to660] EQ 26) AND (Sex_Gro[Size640to660] EQ 1), Age26Size640to660countF)

  WAE_length_bin[70, i*NumLengthBin+adj+28L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+28L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+28L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+28L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+28L] = 640
  WAE_length_bin[75, i*NumLengthBin+adj+28L] = Size640to660countF

  WAE_length_bin[76, i*NumLengthBin+adj+28L] = Age0Size640to660countF
  WAE_length_bin[77, i*NumLengthBin+adj+28L] = Age1Size640to660countF
  WAE_length_bin[78, i*NumLengthBin+adj+28L] = Age2Size640to660countF
  WAE_length_bin[79, i*NumLengthBin+adj+28L] = Age3Size640to660countF
  WAE_length_bin[80, i*NumLengthBin+adj+28L] = Age4Size640to660countF
  WAE_length_bin[81, i*NumLengthBin+adj+28L] = Age5Size640to660countF
  WAE_length_bin[82, i*NumLengthBin+adj+28L] = Age6Size640to660countF
  WAE_length_bin[83, i*NumLengthBin+adj+28L] = Age7Size640to660countF
  WAE_length_bin[84, i*NumLengthBin+adj+28L] = Age8Size640to660countF
  WAE_length_bin[85, i*NumLengthBin+adj+28L] = Age9Size640to660countF
  WAE_length_bin[86, i*NumLengthBin+adj+28L] = Age10Size640to660countF
  WAE_length_bin[87, i*NumLengthBin+adj+28L] = Age11Size640to660countF
  WAE_length_bin[88, i*NumLengthBin+adj+28L] = Age12Size640to660countF
  WAE_length_bin[89, i*NumLengthBin+adj+28L] = Age13Size640to660countF
  WAE_length_bin[90, i*NumLengthBin+adj+28L] = Age14Size640to660countF
  WAE_length_bin[91, i*NumLengthBin+adj+28L] = Age15Size640to660countF
  WAE_length_bin[92, i*NumLengthBin+adj+28L] = Age16Size640to660countF
  WAE_length_bin[93, i*NumLengthBin+adj+28L] = Age17Size640to660countF
  WAE_length_bin[94, i*NumLengthBin+adj+28L] = Age18Size640to660countF
  WAE_length_bin[95, i*NumLengthBin+adj+28L] = Age19Size640to660countF
  WAE_length_bin[96, i*NumLengthBin+adj+28L] = Age20Size640to660countF
  WAE_length_bin[97, i*NumLengthBin+adj+28L] = Age21Size640to660countF
  WAE_length_bin[98, i*NumLengthBin+adj+28L] = Age22Size640to660countF
  WAE_length_bin[99, i*NumLengthBin+adj+28L] = Age23Size640to660countF
  WAE_length_bin[100, i*NumLengthBin+adj+28L] = Age24Size640to660countF
  WAE_length_bin[101, i*NumLengthBin+adj+28L] = Age25Size640to660countF
  WAE_length_bin[102, i*NumLengthBin+adj+28L] = Age26Size640to660countF
  ENDIF
PRINT, 'Size640to660F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+28L])

; length bin 30
IF Size660to680countF GT 0 THEN BEGIN
age0Size660to680F = WHERE((Age_Gro[Size660to680] EQ 1) AND (Sex_Gro[Size660to680] EQ 1), Age0Size660to680countF)
age1Size660to680F = WHERE((Age_Gro[Size660to680] EQ 1) AND (Sex_Gro[Size660to680] EQ 1), Age1Size660to680countF)
age2Size660to680F = WHERE((Age_Gro[Size660to680] EQ 2) AND (Sex_Gro[Size660to680] EQ 1), Age2Size660to680countF)
age3Size660to680F = WHERE((Age_Gro[Size660to680] EQ 3) AND (Sex_Gro[Size660to680] EQ 1), Age3Size660to680countF)
age4Size660to680F = WHERE((Age_Gro[Size660to680] EQ 4) AND (Sex_Gro[Size660to680] EQ 1), Age4Size660to680countF)
age5Size660to680F = WHERE((Age_Gro[Size660to680] EQ 5) AND (Sex_Gro[Size660to680] EQ 1), Age5Size660to680countF)
age6Size660to680F = WHERE((Age_Gro[Size660to680] EQ 6) AND (Sex_Gro[Size660to680] EQ 1), Age6Size660to680countF)
age7Size660to680F = WHERE((Age_Gro[Size660to680] EQ 7) AND (Sex_Gro[Size660to680] EQ 1), Age7Size660to680countF)
age8Size660to680F = WHERE((Age_Gro[Size660to680] EQ 8) AND (Sex_Gro[Size660to680] EQ 1), Age8Size660to680countF)
age9Size660to680F = WHERE((Age_Gro[Size660to680] EQ 9) AND (Sex_Gro[Size660to680] EQ 1), Age9Size660to680countF)
age10Size660to680F = WHERE((Age_Gro[Size660to680] EQ 10) AND (Sex_Gro[Size660to680] EQ 1), Age10Size660to680countF)
age11Size660to680F = WHERE((Age_Gro[Size660to680] EQ 11) AND (Sex_Gro[Size660to680] EQ 1), Age11Size660to680countF)
AGE12Size660to680F = WHERE((Age_Gro[Size660to680] EQ 12) AND (Sex_Gro[Size660to680] EQ 1), Age12Size660to680countF)
AGE13Size660to680F = WHERE((Age_Gro[Size660to680] EQ 13) AND (Sex_Gro[Size660to680] EQ 1), Age13Size660to680countF)
AGE14Size660to680F = WHERE((Age_Gro[Size660to680] EQ 14) AND (Sex_Gro[Size660to680] EQ 1), Age14Size660to680countF)
AGE15Size660to680F = WHERE((Age_Gro[Size660to680] EQ 15) AND (Sex_Gro[Size660to680] EQ 1), Age15Size660to680countF)
age16Size660to680F = WHERE((Age_Gro[Size660to680] EQ 16) AND (Sex_Gro[Size660to680] EQ 1), Age16Size660to680countF)
age17Size660to680F = WHERE((Age_Gro[Size660to680] EQ 17) AND (Sex_Gro[Size660to680] EQ 1), Age17Size660to680countF)
age18Size660to680F = WHERE((Age_Gro[Size660to680] EQ 18) AND (Sex_Gro[Size660to680] EQ 1), Age18Size660to680countF)
age19Size660to680F = WHERE((Age_Gro[Size660to680] EQ 19) AND (Sex_Gro[Size660to680] EQ 1), Age19Size660to680countF)
age20Size660to680F = WHERE((Age_Gro[Size660to680] EQ 20) AND (Sex_Gro[Size660to680] EQ 1), Age20Size660to680countF)
age21Size660to680F = WHERE((Age_Gro[Size660to680] EQ 21) AND (Sex_Gro[Size660to680] EQ 1), Age21Size660to680countF)
age22Size660to680F = WHERE((Age_Gro[Size660to680] EQ 22) AND (Sex_Gro[Size660to680] EQ 1), Age22Size660to680countF)
age23Size660to680F = WHERE((Age_Gro[Size660to680] EQ 23) AND (Sex_Gro[Size660to680] EQ 1), Age23Size660to680countF)
age24Size660to680F = WHERE((Age_Gro[Size660to680] EQ 24) AND (Sex_Gro[Size660to680] EQ 1), Age24Size660to680countF)
age25Size660to680F = WHERE((Age_Gro[Size660to680] EQ 25) AND (Sex_Gro[Size660to680] EQ 1), Age25Size660to680countF)
age26Size660to680F = WHERE((Age_Gro[Size660to680] EQ 26) AND (Sex_Gro[Size660to680] EQ 1), Age26Size660to680countF)

  WAE_length_bin[70, i*NumLengthBin+adj+29L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+29L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+29L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+29L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+29L] = 660
  WAE_length_bin[75, i*NumLengthBin+adj+29L] = Size660to680countF

  WAE_length_bin[76, i*NumLengthBin+adj+29L] = Age0Size660to680countF
  WAE_length_bin[77, i*NumLengthBin+adj+29L] = Age1Size660to680countF
  WAE_length_bin[78, i*NumLengthBin+adj+29L] = Age2Size660to680countF
  WAE_length_bin[79, i*NumLengthBin+adj+29L] = Age3Size660to680countF
  WAE_length_bin[80, i*NumLengthBin+adj+29L] = Age4Size660to680countF
  WAE_length_bin[81, i*NumLengthBin+adj+29L] = Age5Size660to680countF
  WAE_length_bin[82, i*NumLengthBin+adj+29L] = Age6Size660to680countF
  WAE_length_bin[83, i*NumLengthBin+adj+29L] = Age7Size660to680countF
  WAE_length_bin[84, i*NumLengthBin+adj+29L] = Age8Size660to680countF
  WAE_length_bin[85, i*NumLengthBin+adj+29L] = Age9Size660to680countF
  WAE_length_bin[86, i*NumLengthBin+adj+29L] = Age10Size660to680countF
  WAE_length_bin[87, i*NumLengthBin+adj+29L] = Age11Size660to680countF
  WAE_length_bin[88, i*NumLengthBin+adj+29L] = Age12Size660to680countF
  WAE_length_bin[89, i*NumLengthBin+adj+29L] = Age13Size660to680countF
  WAE_length_bin[90, i*NumLengthBin+adj+29L] = Age14Size660to680countF
  WAE_length_bin[91, i*NumLengthBin+adj+29L] = Age15Size660to680countF
  WAE_length_bin[92, i*NumLengthBin+adj+29L] = Age16Size660to680countF
  WAE_length_bin[93, i*NumLengthBin+adj+29L] = Age17Size660to680countF
  WAE_length_bin[94, i*NumLengthBin+adj+29L] = Age18Size660to680countF
  WAE_length_bin[95, i*NumLengthBin+adj+29L] = Age19Size660to680countF
  WAE_length_bin[96, i*NumLengthBin+adj+29L] = Age20Size660to680countF
  WAE_length_bin[97, i*NumLengthBin+adj+29L] = Age21Size660to680countF
  WAE_length_bin[98, i*NumLengthBin+adj+29L] = Age22Size660to680countF
  WAE_length_bin[99, i*NumLengthBin+adj+29L] = Age23Size660to680countF
  WAE_length_bin[100, i*NumLengthBin+adj+29L] = Age24Size660to680countF
  WAE_length_bin[101, i*NumLengthBin+adj+29L] = Age25Size660to680countF
  WAE_length_bin[102, i*NumLengthBin+adj+29L] = Age26Size660to680countF
  ENDIF
PRINT, 'Size660to680F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+29L])

; length bin 31
IF Size680to700countF GT 0 THEN BEGIN
age0Size680to700F = WHERE((Age_Gro[Size680to700] EQ 1) AND (Sex_Gro[Size680to700] EQ 1), Age0Size680to700countF)
age1Size680to700F = WHERE((Age_Gro[Size680to700] EQ 1) AND (Sex_Gro[Size680to700] EQ 1), Age1Size680to700countF)
age2Size680to700F = WHERE((Age_Gro[Size680to700] EQ 2) AND (Sex_Gro[Size680to700] EQ 1), Age2Size680to700countF)
age3Size680to700F = WHERE((Age_Gro[Size680to700] EQ 3) AND (Sex_Gro[Size680to700] EQ 1), Age3Size680to700countF)
age4Size680to700F = WHERE((Age_Gro[Size680to700] EQ 4) AND (Sex_Gro[Size680to700] EQ 1), Age4Size680to700countF)
age5Size680to700F = WHERE((Age_Gro[Size680to700] EQ 5) AND (Sex_Gro[Size680to700] EQ 1), Age5Size680to700countF)
age6Size680to700F = WHERE((Age_Gro[Size680to700] EQ 6) AND (Sex_Gro[Size680to700] EQ 1), Age6Size680to700countF)
age7Size680to700F = WHERE((Age_Gro[Size680to700] EQ 7) AND (Sex_Gro[Size680to700] EQ 1), Age7Size680to700countF)
age8Size680to700F = WHERE((Age_Gro[Size680to700] EQ 8) AND (Sex_Gro[Size680to700] EQ 1), Age8Size680to700countF)
age9Size680to700F = WHERE((Age_Gro[Size680to700] EQ 9) AND (Sex_Gro[Size680to700] EQ 1), Age9Size680to700countF)
age10Size680to700F = WHERE((Age_Gro[Size680to700] EQ 10) AND (Sex_Gro[Size680to700] EQ 1), Age10Size680to700countF)
age11Size680to700F = WHERE((Age_Gro[Size680to700] EQ 11) AND (Sex_Gro[Size680to700] EQ 1), Age11Size680to700countF)
AGE12Size680to700F = WHERE((Age_Gro[Size680to700] EQ 12) AND (Sex_Gro[Size680to700] EQ 1), Age12Size680to700countF)
AGE13Size680to700F = WHERE((Age_Gro[Size680to700] EQ 13) AND (Sex_Gro[Size680to700] EQ 1), Age13Size680to700countF)
AGE14Size680to700F = WHERE((Age_Gro[Size680to700] EQ 14) AND (Sex_Gro[Size680to700] EQ 1), Age14Size680to700countF)
AGE15Size680to700F = WHERE((Age_Gro[Size680to700] EQ 15) AND (Sex_Gro[Size680to700] EQ 1), Age15Size680to700countF)
age16Size680to700F = WHERE((Age_Gro[Size680to700] EQ 16) AND (Sex_Gro[Size680to700] EQ 1), Age16Size680to700countF)
age17Size680to700F = WHERE((Age_Gro[Size680to700] EQ 17) AND (Sex_Gro[Size680to700] EQ 1), Age17Size680to700countF)
age18Size680to700F = WHERE((Age_Gro[Size680to700] EQ 18) AND (Sex_Gro[Size680to700] EQ 1), Age18Size680to700countF)
age19Size680to700F = WHERE((Age_Gro[Size680to700] EQ 19) AND (Sex_Gro[Size680to700] EQ 1), Age19Size680to700countF)
age20Size680to700F = WHERE((Age_Gro[Size680to700] EQ 20) AND (Sex_Gro[Size680to700] EQ 1), Age20Size680to700countF)
age21Size680to700F = WHERE((Age_Gro[Size680to700] EQ 21) AND (Sex_Gro[Size680to700] EQ 1), Age21Size680to700countF)
age22Size680to700F = WHERE((Age_Gro[Size680to700] EQ 22) AND (Sex_Gro[Size680to700] EQ 1), Age22Size680to700countF)
age23Size680to700F = WHERE((Age_Gro[Size680to700] EQ 23) AND (Sex_Gro[Size680to700] EQ 1), Age23Size680to700countF)
age24Size680to700F = WHERE((Age_Gro[Size680to700] EQ 24) AND (Sex_Gro[Size680to700] EQ 1), Age24Size680to700countF)
age25Size680to700F = WHERE((Age_Gro[Size680to700] EQ 25) AND (Sex_Gro[Size680to700] EQ 1), Age25Size680to700countF)
age26Size680to700F = WHERE((Age_Gro[Size680to700] EQ 26) AND (Sex_Gro[Size680to700] EQ 1), Age26Size680to700countF)

  WAE_length_bin[70, i*NumLengthBin+adj+30L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+30L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+30L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+30L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+30L] = 680
  WAE_length_bin[75, i*NumLengthBin+adj+30L] = Size680to700countF

  WAE_length_bin[76, i*NumLengthBin+adj+30L] = Age0Size680to700countF
  WAE_length_bin[77, i*NumLengthBin+adj+30L] = Age1Size680to700countF
  WAE_length_bin[78, i*NumLengthBin+adj+30L] = Age2Size680to700countF
  WAE_length_bin[79, i*NumLengthBin+adj+30L] = Age3Size680to700countF
  WAE_length_bin[80, i*NumLengthBin+adj+30L] = Age4Size680to700countF
  WAE_length_bin[81, i*NumLengthBin+adj+30L] = Age5Size680to700countF
  WAE_length_bin[82, i*NumLengthBin+adj+30L] = Age6Size680to700countF
  WAE_length_bin[83, i*NumLengthBin+adj+30L] = Age7Size680to700countF
  WAE_length_bin[84, i*NumLengthBin+adj+30L] = Age8Size680to700countF
  WAE_length_bin[85, i*NumLengthBin+adj+30L] = Age9Size680to700countF
  WAE_length_bin[86, i*NumLengthBin+adj+30L] = Age10Size680to700countF
  WAE_length_bin[87, i*NumLengthBin+adj+30L] = Age11Size680to700countF
  WAE_length_bin[88, i*NumLengthBin+adj+30L] = Age12Size680to700countF
  WAE_length_bin[89, i*NumLengthBin+adj+30L] = Age13Size680to700countF
  WAE_length_bin[90, i*NumLengthBin+adj+30L] = Age14Size680to700countF
  WAE_length_bin[91, i*NumLengthBin+adj+30L] = Age15Size680to700countF
  WAE_length_bin[92, i*NumLengthBin+adj+30L] = Age16Size680to700countF
  WAE_length_bin[93, i*NumLengthBin+adj+30L] = Age17Size680to700countF
  WAE_length_bin[94, i*NumLengthBin+adj+30L] = Age18Size680to700countF
  WAE_length_bin[95, i*NumLengthBin+adj+30L] = Age19Size680to700countF
  WAE_length_bin[96, i*NumLengthBin+adj+30L] = Age20Size680to700countF
  WAE_length_bin[97, i*NumLengthBin+adj+30L] = Age21Size680to700countF
  WAE_length_bin[98, i*NumLengthBin+adj+30L] = Age22Size680to700countF
  WAE_length_bin[99, i*NumLengthBin+adj+30L] = Age23Size680to700countF
  WAE_length_bin[100, i*NumLengthBin+adj+30L] = Age24Size680to700countF
  WAE_length_bin[101, i*NumLengthBin+adj+30L] = Age25Size680to700countF
  WAE_length_bin[102, i*NumLengthBin+adj+30L] = Age26Size680to700countF
  ENDIF
PRINT, 'Size680to700F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+30L])

; length bin 32
IF Size700to720countF GT 0 THEN BEGIN
age0Size700to720F = WHERE((Age_Gro[Size700to720] EQ 1) AND (Sex_Gro[Size700to720] EQ 1), Age0Size700to720countF)
age1Size700to720F = WHERE((Age_Gro[Size700to720] EQ 1) AND (Sex_Gro[Size700to720] EQ 1), Age1Size700to720countF)
age2Size700to720F = WHERE((Age_Gro[Size700to720] EQ 2) AND (Sex_Gro[Size700to720] EQ 1), Age2Size700to720countF)
age3Size700to720F = WHERE((Age_Gro[Size700to720] EQ 3) AND (Sex_Gro[Size700to720] EQ 1), Age3Size700to720countF)
age4Size700to720F = WHERE((Age_Gro[Size700to720] EQ 4) AND (Sex_Gro[Size700to720] EQ 1), Age4Size700to720countF)
age5Size700to720F = WHERE((Age_Gro[Size700to720] EQ 5) AND (Sex_Gro[Size700to720] EQ 1), Age5Size700to720countF)
age6Size700to720F = WHERE((Age_Gro[Size700to720] EQ 6) AND (Sex_Gro[Size700to720] EQ 1), Age6Size700to720countF)
age7Size700to720F = WHERE((Age_Gro[Size700to720] EQ 7) AND (Sex_Gro[Size700to720] EQ 1), Age7Size700to720countF)
age8Size700to720F = WHERE((Age_Gro[Size700to720] EQ 8) AND (Sex_Gro[Size700to720] EQ 1), Age8Size700to720countF)
age9Size700to720F = WHERE((Age_Gro[Size700to720] EQ 9) AND (Sex_Gro[Size700to720] EQ 1), Age9Size700to720countF)
age10Size700to720F = WHERE((Age_Gro[Size700to720] EQ 10) AND (Sex_Gro[Size700to720] EQ 1), Age10Size700to720countF)
age11Size700to720F = WHERE((Age_Gro[Size700to720] EQ 11) AND (Sex_Gro[Size700to720] EQ 1), Age11Size700to720countF)
AGE12Size700to720F = WHERE((Age_Gro[Size700to720] EQ 12) AND (Sex_Gro[Size700to720] EQ 1), Age12Size700to720countF)
AGE13Size700to720F = WHERE((Age_Gro[Size700to720] EQ 13) AND (Sex_Gro[Size700to720] EQ 1), Age13Size700to720countF)
AGE14Size700to720F = WHERE((Age_Gro[Size700to720] EQ 14) AND (Sex_Gro[Size700to720] EQ 1), Age14Size700to720countF)
AGE15Size700to720F = WHERE((Age_Gro[Size700to720] EQ 15) AND (Sex_Gro[Size700to720] EQ 1), Age15Size700to720countF)
age16Size700to720F = WHERE((Age_Gro[Size700to720] EQ 16) AND (Sex_Gro[Size700to720] EQ 1), Age16Size700to720countF)
age17Size700to720F = WHERE((Age_Gro[Size700to720] EQ 17) AND (Sex_Gro[Size700to720] EQ 1), Age17Size700to720countF)
age18Size700to720F = WHERE((Age_Gro[Size700to720] EQ 18) AND (Sex_Gro[Size700to720] EQ 1), Age18Size700to720countF)
age19Size700to720F = WHERE((Age_Gro[Size700to720] EQ 19) AND (Sex_Gro[Size700to720] EQ 1), Age19Size700to720countF)
age20Size700to720F = WHERE((Age_Gro[Size700to720] EQ 20) AND (Sex_Gro[Size700to720] EQ 1), Age20Size700to720countF)
age21Size700to720F = WHERE((Age_Gro[Size700to720] EQ 21) AND (Sex_Gro[Size700to720] EQ 1), Age21Size700to720countF)
age22Size700to720F = WHERE((Age_Gro[Size700to720] EQ 22) AND (Sex_Gro[Size700to720] EQ 1), Age22Size700to720countF)
age23Size700to720F = WHERE((Age_Gro[Size700to720] EQ 23) AND (Sex_Gro[Size700to720] EQ 1), Age23Size700to720countF)
age24Size700to720F = WHERE((Age_Gro[Size700to720] EQ 24) AND (Sex_Gro[Size700to720] EQ 1), Age24Size700to720countF)
age25Size700to720F = WHERE((Age_Gro[Size700to720] EQ 25) AND (Sex_Gro[Size700to720] EQ 1), Age25Size700to720countF)
age26Size700to720F = WHERE((Age_Gro[Size700to720] EQ 26) AND (Sex_Gro[Size700to720] EQ 1), Age26Size700to720countF)

  WAE_length_bin[70, i*NumLengthBin+adj+31L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+31L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+31L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+31L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+31L] = 700
  WAE_length_bin[75, i*NumLengthBin+adj+31L] = Size700to720countF

  WAE_length_bin[76, i*NumLengthBin+adj+31L] = Age0Size700to720countF
  WAE_length_bin[77, i*NumLengthBin+adj+31L] = Age1Size700to720countF
  WAE_length_bin[78, i*NumLengthBin+adj+31L] = Age2Size700to720countF
  WAE_length_bin[79, i*NumLengthBin+adj+31L] = Age3Size700to720countF
  WAE_length_bin[80, i*NumLengthBin+adj+31L] = Age4Size700to720countF
  WAE_length_bin[81, i*NumLengthBin+adj+31L] = Age5Size700to720countF
  WAE_length_bin[82, i*NumLengthBin+adj+31L] = Age6Size700to720countF
  WAE_length_bin[83, i*NumLengthBin+adj+31L] = Age7Size700to720countF
  WAE_length_bin[84, i*NumLengthBin+adj+31L] = Age8Size700to720countF
  WAE_length_bin[85, i*NumLengthBin+adj+31L] = Age9Size700to720countF
  WAE_length_bin[86, i*NumLengthBin+adj+31L] = Age10Size700to720countF
  WAE_length_bin[87, i*NumLengthBin+adj+31L] = Age11Size700to720countF
  WAE_length_bin[88, i*NumLengthBin+adj+31L] = Age12Size700to720countF
  WAE_length_bin[89, i*NumLengthBin+adj+31L] = Age13Size700to720countF
  WAE_length_bin[90, i*NumLengthBin+adj+31L] = Age14Size700to720countF
  WAE_length_bin[91, i*NumLengthBin+adj+31L] = Age15Size700to720countF
  WAE_length_bin[92, i*NumLengthBin+adj+31L] = Age16Size700to720countF
  WAE_length_bin[93, i*NumLengthBin+adj+31L] = Age17Size700to720countF
  WAE_length_bin[94, i*NumLengthBin+adj+31L] = Age18Size700to720countF
  WAE_length_bin[95, i*NumLengthBin+adj+31L] = Age19Size700to720countF
  WAE_length_bin[96, i*NumLengthBin+adj+31L] = Age20Size700to720countF
  WAE_length_bin[97, i*NumLengthBin+adj+31L] = Age21Size700to720countF
  WAE_length_bin[98, i*NumLengthBin+adj+31L] = Age22Size700to720countF
  WAE_length_bin[99, i*NumLengthBin+adj+31L] = Age23Size700to720countF
  WAE_length_bin[100, i*NumLengthBin+adj+31L] = Age24Size700to720countF
  WAE_length_bin[101, i*NumLengthBin+adj+31L] = Age25Size700to720countF
  WAE_length_bin[102, i*NumLengthBin+adj+31L] = Age26Size700to720countF
  ENDIF
PRINT, 'Size700to720F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+31L])

; length bin 33
IF Size720to740countF GT 0 THEN BEGIN
age0Size720to740F = WHERE((Age_Gro[Size720to740] EQ 1) AND (Sex_Gro[Size720to740] EQ 1), Age0Size720to740countF)
age1Size720to740F = WHERE((Age_Gro[Size720to740] EQ 1) AND (Sex_Gro[Size720to740] EQ 1), Age1Size720to740countF)
age2Size720to740F = WHERE((Age_Gro[Size720to740] EQ 2) AND (Sex_Gro[Size720to740] EQ 1), Age2Size720to740countF)
age3Size720to740F = WHERE((Age_Gro[Size720to740] EQ 3) AND (Sex_Gro[Size720to740] EQ 1), Age3Size720to740countF)
age4Size720to740F = WHERE((Age_Gro[Size720to740] EQ 4) AND (Sex_Gro[Size720to740] EQ 1), Age4Size720to740countF)
age5Size720to740F = WHERE((Age_Gro[Size720to740] EQ 5) AND (Sex_Gro[Size720to740] EQ 1), Age5Size720to740countF)
age6Size720to740F = WHERE((Age_Gro[Size720to740] EQ 6) AND (Sex_Gro[Size720to740] EQ 1), Age6Size720to740countF)
age7Size720to740F = WHERE((Age_Gro[Size720to740] EQ 7) AND (Sex_Gro[Size720to740] EQ 1), Age7Size720to740countF)
age8Size720to740F = WHERE((Age_Gro[Size720to740] EQ 8) AND (Sex_Gro[Size720to740] EQ 1), Age8Size720to740countF)
age9Size720to740F = WHERE((Age_Gro[Size720to740] EQ 9) AND (Sex_Gro[Size720to740] EQ 1), Age9Size720to740countF)
age10Size720to740F = WHERE((Age_Gro[Size720to740] EQ 10) AND (Sex_Gro[Size720to740] EQ 1), Age10Size720to740countF)
age11Size720to740F = WHERE((Age_Gro[Size720to740] EQ 11) AND (Sex_Gro[Size720to740] EQ 1), Age11Size720to740countF)
AGE12Size720to740F = WHERE((Age_Gro[Size720to740] EQ 12) AND (Sex_Gro[Size720to740] EQ 1), Age12Size720to740countF)
AGE13Size720to740F = WHERE((Age_Gro[Size720to740] EQ 13) AND (Sex_Gro[Size720to740] EQ 1), Age13Size720to740countF)
AGE14Size720to740F = WHERE((Age_Gro[Size720to740] EQ 14) AND (Sex_Gro[Size720to740] EQ 1), Age14Size720to740countF)
AGE15Size720to740F = WHERE((Age_Gro[Size720to740] EQ 15) AND (Sex_Gro[Size720to740] EQ 1), Age15Size720to740countF)
age16Size720to740F = WHERE((Age_Gro[Size720to740] EQ 16) AND (Sex_Gro[Size720to740] EQ 1), Age16Size720to740countF)
age17Size720to740F = WHERE((Age_Gro[Size720to740] EQ 17) AND (Sex_Gro[Size720to740] EQ 1), Age17Size720to740countF)
age18Size720to740F = WHERE((Age_Gro[Size720to740] EQ 18) AND (Sex_Gro[Size720to740] EQ 1), Age18Size720to740countF)
age19Size720to740F = WHERE((Age_Gro[Size720to740] EQ 19) AND (Sex_Gro[Size720to740] EQ 1), Age19Size720to740countF)
age20Size720to740F = WHERE((Age_Gro[Size720to740] EQ 20) AND (Sex_Gro[Size720to740] EQ 1), Age20Size720to740countF)
age21Size720to740F = WHERE((Age_Gro[Size720to740] EQ 21) AND (Sex_Gro[Size720to740] EQ 1), Age21Size720to740countF)
age22Size720to740F = WHERE((Age_Gro[Size720to740] EQ 22) AND (Sex_Gro[Size720to740] EQ 1), Age22Size720to740countF)
age23Size720to740F = WHERE((Age_Gro[Size720to740] EQ 23) AND (Sex_Gro[Size720to740] EQ 1), Age23Size720to740countF)
age24Size720to740F = WHERE((Age_Gro[Size720to740] EQ 24) AND (Sex_Gro[Size720to740] EQ 1), Age24Size720to740countF)
age25Size720to740F = WHERE((Age_Gro[Size720to740] EQ 25) AND (Sex_Gro[Size720to740] EQ 1), Age25Size720to740countF)
age26Size720to740F = WHERE((Age_Gro[Size720to740] EQ 26) AND (Sex_Gro[Size720to740] EQ 1), Age26Size720to740countF)

  WAE_length_bin[70, i*NumLengthBin+adj+32L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+32L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+32L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+32L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+32L] = 720
  WAE_length_bin[75, i*NumLengthBin+adj+32L] = Size720to740countF

  WAE_length_bin[76, i*NumLengthBin+adj+32L] = Age0Size720to740countF
  WAE_length_bin[77, i*NumLengthBin+adj+32L] = Age1Size720to740countF
  WAE_length_bin[78, i*NumLengthBin+adj+32L] = Age2Size720to740countF
  WAE_length_bin[79, i*NumLengthBin+adj+32L] = Age3Size720to740countF
  WAE_length_bin[80, i*NumLengthBin+adj+32L] = Age4Size720to740countF
  WAE_length_bin[81, i*NumLengthBin+adj+32L] = Age5Size720to740countF
  WAE_length_bin[82, i*NumLengthBin+adj+32L] = Age6Size720to740countF
  WAE_length_bin[83, i*NumLengthBin+adj+32L] = Age7Size720to740countF
  WAE_length_bin[84, i*NumLengthBin+adj+32L] = Age8Size720to740countF
  WAE_length_bin[85, i*NumLengthBin+adj+32L] = Age9Size720to740countF
  WAE_length_bin[86, i*NumLengthBin+adj+32L] = Age10Size720to740countF
  WAE_length_bin[87, i*NumLengthBin+adj+32L] = Age11Size720to740countF
  WAE_length_bin[88, i*NumLengthBin+adj+32L] = Age12Size720to740countF
  WAE_length_bin[89, i*NumLengthBin+adj+32L] = Age13Size720to740countF
  WAE_length_bin[90, i*NumLengthBin+adj+32L] = Age14Size720to740countF
  WAE_length_bin[91, i*NumLengthBin+adj+32L] = Age15Size720to740countF
  WAE_length_bin[92, i*NumLengthBin+adj+32L] = Age16Size720to740countF
  WAE_length_bin[93, i*NumLengthBin+adj+32L] = Age17Size720to740countF
  WAE_length_bin[94, i*NumLengthBin+adj+32L] = Age18Size720to740countF
  WAE_length_bin[95, i*NumLengthBin+adj+32L] = Age19Size720to740countF
  WAE_length_bin[96, i*NumLengthBin+adj+32L] = Age20Size720to740countF
  WAE_length_bin[97, i*NumLengthBin+adj+32L] = Age21Size720to740countF
  WAE_length_bin[98, i*NumLengthBin+adj+32L] = Age22Size720to740countF
  WAE_length_bin[99, i*NumLengthBin+adj+32L] = Age23Size720to740countF
  WAE_length_bin[100, i*NumLengthBin+adj+32L] = Age24Size720to740countF
  WAE_length_bin[101, i*NumLengthBin+adj+32L] = Age25Size720to740countF
  WAE_length_bin[102, i*NumLengthBin+adj+32L] = Age26Size720to740countF
  ENDIF
PRINT, 'Size720to740F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+32L])

; length bin 34
IF Size740to760countF GT 0 THEN BEGIN
age0Size740to760F = WHERE((Age_Gro[Size740to760] EQ 1) AND (Sex_Gro[Size740to760] EQ 1), Age0Size740to760countF)
age1Size740to760F = WHERE((Age_Gro[Size740to760] EQ 1) AND (Sex_Gro[Size740to760] EQ 1), Age1Size740to760countF)
age2Size740to760F = WHERE((Age_Gro[Size740to760] EQ 2) AND (Sex_Gro[Size740to760] EQ 1), Age2Size740to760countF)
age3Size740to760F = WHERE((Age_Gro[Size740to760] EQ 3) AND (Sex_Gro[Size740to760] EQ 1), Age3Size740to760countF)
age4Size740to760F = WHERE((Age_Gro[Size740to760] EQ 4) AND (Sex_Gro[Size740to760] EQ 1), Age4Size740to760countF)
age5Size740to760F = WHERE((Age_Gro[Size740to760] EQ 5) AND (Sex_Gro[Size740to760] EQ 1), Age5Size740to760countF)
age6Size740to760F = WHERE((Age_Gro[Size740to760] EQ 6) AND (Sex_Gro[Size740to760] EQ 1), Age6Size740to760countF)
age7Size740to760F = WHERE((Age_Gro[Size740to760] EQ 7) AND (Sex_Gro[Size740to760] EQ 1), Age7Size740to760countF)
age8Size740to760F = WHERE((Age_Gro[Size740to760] EQ 8) AND (Sex_Gro[Size740to760] EQ 1), Age8Size740to760countF)
age9Size740to760F = WHERE((Age_Gro[Size740to760] EQ 9) AND (Sex_Gro[Size740to760] EQ 1), Age9Size740to760countF)
age10Size740to760F = WHERE((Age_Gro[Size740to760] EQ 10) AND (Sex_Gro[Size740to760] EQ 1), Age10Size740to760countF)
age11Size740to760F = WHERE((Age_Gro[Size740to760] EQ 11) AND (Sex_Gro[Size740to760] EQ 1), Age11Size740to760countF)
AGE12Size740to760F = WHERE((Age_Gro[Size740to760] EQ 12) AND (Sex_Gro[Size740to760] EQ 1), Age12Size740to760countF)
AGE13Size740to760F = WHERE((Age_Gro[Size740to760] EQ 13) AND (Sex_Gro[Size740to760] EQ 1), Age13Size740to760countF)
AGE14Size740to760F = WHERE((Age_Gro[Size740to760] EQ 14) AND (Sex_Gro[Size740to760] EQ 1), Age14Size740to760countF)
AGE15Size740to760F = WHERE((Age_Gro[Size740to760] EQ 15) AND (Sex_Gro[Size740to760] EQ 1), Age15Size740to760countF)
age16Size740to760F = WHERE((Age_Gro[Size740to760] EQ 16) AND (Sex_Gro[Size740to760] EQ 1), Age16Size740to760countF)
age17Size740to760F = WHERE((Age_Gro[Size740to760] EQ 17) AND (Sex_Gro[Size740to760] EQ 1), Age17Size740to760countF)
age18Size740to760F = WHERE((Age_Gro[Size740to760] EQ 18) AND (Sex_Gro[Size740to760] EQ 1), Age18Size740to760countF)
age19Size740to760F = WHERE((Age_Gro[Size740to760] EQ 19) AND (Sex_Gro[Size740to760] EQ 1), Age19Size740to760countF)
age20Size740to760F = WHERE((Age_Gro[Size740to760] EQ 20) AND (Sex_Gro[Size740to760] EQ 1), Age20Size740to760countF)
age21Size740to760F = WHERE((Age_Gro[Size740to760] EQ 21) AND (Sex_Gro[Size740to760] EQ 1), Age21Size740to760countF)
age22Size740to760F = WHERE((Age_Gro[Size740to760] EQ 22) AND (Sex_Gro[Size740to760] EQ 1), Age22Size740to760countF)
age23Size740to760F = WHERE((Age_Gro[Size740to760] EQ 23) AND (Sex_Gro[Size740to760] EQ 1), Age23Size740to760countF)
age24Size740to760F = WHERE((Age_Gro[Size740to760] EQ 24) AND (Sex_Gro[Size740to760] EQ 1), Age24Size740to760countF)
age25Size740to760F = WHERE((Age_Gro[Size740to760] EQ 25) AND (Sex_Gro[Size740to760] EQ 1), Age25Size740to760countF)
age26Size740to760F = WHERE((Age_Gro[Size740to760] EQ 26) AND (Sex_Gro[Size740to760] EQ 1), Age26Size740to760countF)

  WAE_length_bin[70, i*NumLengthBin+adj+33L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+33L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+33L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+33L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+33L] = 740
  WAE_length_bin[75, i*NumLengthBin+adj+33L] = Size740to760countF

  WAE_length_bin[76, i*NumLengthBin+adj+33L] = Age0Size740to760countF
  WAE_length_bin[77, i*NumLengthBin+adj+33L] = Age1Size740to760countF
  WAE_length_bin[78, i*NumLengthBin+adj+33L] = Age2Size740to760countF
  WAE_length_bin[79, i*NumLengthBin+adj+33L] = Age3Size740to760countF
  WAE_length_bin[80, i*NumLengthBin+adj+33L] = Age4Size740to760countF
  WAE_length_bin[81, i*NumLengthBin+adj+33L] = Age5Size740to760countF
  WAE_length_bin[82, i*NumLengthBin+adj+33L] = Age6Size740to760countF
  WAE_length_bin[83, i*NumLengthBin+adj+33L] = Age7Size740to760countF
  WAE_length_bin[84, i*NumLengthBin+adj+33L] = Age8Size740to760countF
  WAE_length_bin[85, i*NumLengthBin+adj+33L] = Age9Size740to760countF
  WAE_length_bin[86, i*NumLengthBin+adj+33L] = Age10Size740to760countF
  WAE_length_bin[87, i*NumLengthBin+adj+33L] = Age11Size740to760countF
  WAE_length_bin[88, i*NumLengthBin+adj+33L] = Age12Size740to760countF
  WAE_length_bin[89, i*NumLengthBin+adj+33L] = Age13Size740to760countF
  WAE_length_bin[90, i*NumLengthBin+adj+33L] = Age14Size740to760countF
  WAE_length_bin[91, i*NumLengthBin+adj+33L] = Age15Size740to760countF
  WAE_length_bin[92, i*NumLengthBin+adj+33L] = Age16Size740to760countF
  WAE_length_bin[93, i*NumLengthBin+adj+33L] = Age17Size740to760countF
  WAE_length_bin[94, i*NumLengthBin+adj+33L] = Age18Size740to760countF
  WAE_length_bin[95, i*NumLengthBin+adj+33L] = Age19Size740to760countF
  WAE_length_bin[96, i*NumLengthBin+adj+33L] = Age20Size740to760countF
  WAE_length_bin[97, i*NumLengthBin+adj+33L] = Age21Size740to760countF
  WAE_length_bin[98, i*NumLengthBin+adj+33L] = Age22Size740to760countF
  WAE_length_bin[99, i*NumLengthBin+adj+33L] = Age23Size740to760countF
  WAE_length_bin[100, i*NumLengthBin+adj+33L] = Age24Size740to760countF
  WAE_length_bin[101, i*NumLengthBin+adj+33L] = Age25Size740to760countF
  WAE_length_bin[102, i*NumLengthBin+adj+33L] = Age26Size740to760countF
  ENDIF
PRINT, 'Size740to760F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+33L])

; legnth bin 35
IF Size760to780countF GT 0 THEN BEGIN
age0Size760to780F = WHERE((Age_Gro[Size760to780] EQ 1) AND (Sex_Gro[Size760to780] EQ 1), Age0Size760to780countF)
age1Size760to780F = WHERE((Age_Gro[Size760to780] EQ 1) AND (Sex_Gro[Size760to780] EQ 1), Age1Size760to780countF)
age2Size760to780F = WHERE((Age_Gro[Size760to780] EQ 2) AND (Sex_Gro[Size760to780] EQ 1), Age2Size760to780countF)
age3Size760to780F = WHERE((Age_Gro[Size760to780] EQ 3) AND (Sex_Gro[Size760to780] EQ 1), Age3Size760to780countF)
age4Size760to780F = WHERE((Age_Gro[Size760to780] EQ 4) AND (Sex_Gro[Size760to780] EQ 1), Age4Size760to780countF)
age5Size760to780F = WHERE((Age_Gro[Size760to780] EQ 5) AND (Sex_Gro[Size760to780] EQ 1), Age5Size760to780countF)
age6Size760to780F = WHERE((Age_Gro[Size760to780] EQ 6) AND (Sex_Gro[Size760to780] EQ 1), Age6Size760to780countF)
age7Size760to780F = WHERE((Age_Gro[Size760to780] EQ 7) AND (Sex_Gro[Size760to780] EQ 1), Age7Size760to780countF)
age8Size760to780F = WHERE((Age_Gro[Size760to780] EQ 8) AND (Sex_Gro[Size760to780] EQ 1), Age8Size760to780countF)
age9Size760to780F = WHERE((Age_Gro[Size760to780] EQ 9) AND (Sex_Gro[Size760to780] EQ 1), Age9Size760to780countF)
age10Size760to780F = WHERE((Age_Gro[Size760to780] EQ 10) AND (Sex_Gro[Size760to780] EQ 1), Age10Size760to780countF)
age11Size760to780F = WHERE((Age_Gro[Size760to780] EQ 11) AND (Sex_Gro[Size760to780] EQ 1), Age11Size760to780countF)
AGE12Size760to780F = WHERE((Age_Gro[Size760to780] EQ 12) AND (Sex_Gro[Size760to780] EQ 1), Age12Size760to780countF)
AGE13Size760to780F = WHERE((Age_Gro[Size760to780] EQ 13) AND (Sex_Gro[Size760to780] EQ 1), Age13Size760to780countF)
AGE14Size760to780F = WHERE((Age_Gro[Size760to780] EQ 14) AND (Sex_Gro[Size760to780] EQ 1), Age14Size760to780countF)
AGE15Size760to780F = WHERE((Age_Gro[Size760to780] EQ 15) AND (Sex_Gro[Size760to780] EQ 1), Age15Size760to780countF)
age16Size760to780F = WHERE((Age_Gro[Size760to780] EQ 16) AND (Sex_Gro[Size760to780] EQ 1), Age16Size760to780countF)
age17Size760to780F = WHERE((Age_Gro[Size760to780] EQ 17) AND (Sex_Gro[Size760to780] EQ 1), Age17Size760to780countF)
age18Size760to780F = WHERE((Age_Gro[Size760to780] EQ 18) AND (Sex_Gro[Size760to780] EQ 1), Age18Size760to780countF)
age19Size760to780F = WHERE((Age_Gro[Size760to780] EQ 19) AND (Sex_Gro[Size760to780] EQ 1), Age19Size760to780countF)
age20Size760to780F = WHERE((Age_Gro[Size760to780] EQ 20) AND (Sex_Gro[Size760to780] EQ 1), Age20Size760to780countF)
age21Size760to780F = WHERE((Age_Gro[Size760to780] EQ 21) AND (Sex_Gro[Size760to780] EQ 1), Age21Size760to780countF)
age22Size760to780F = WHERE((Age_Gro[Size760to780] EQ 22) AND (Sex_Gro[Size760to780] EQ 1), Age22Size760to780countF)
age23Size760to780F = WHERE((Age_Gro[Size760to780] EQ 23) AND (Sex_Gro[Size760to780] EQ 1), Age23Size760to780countF)
age24Size760to780F = WHERE((Age_Gro[Size760to780] EQ 24) AND (Sex_Gro[Size760to780] EQ 1), Age24Size760to780countF)
age25Size760to780F = WHERE((Age_Gro[Size760to780] EQ 25) AND (Sex_Gro[Size760to780] EQ 1), Age25Size760to780countF)
age26Size760to780F = WHERE((Age_Gro[Size760to780] EQ 26) AND (Sex_Gro[Size760to780] EQ 1), Age26Size760to780countF)

  WAE_length_bin[70, i*NumLengthBin+adj+34L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+34L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+34L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+34L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+34L] = 760
  WAE_length_bin[75, i*NumLengthBin+adj+34L] = Size760to780countF

  WAE_length_bin[76, i*NumLengthBin+adj+34L] = Age0Size760to780countF
  WAE_length_bin[77, i*NumLengthBin+adj+34L] = Age1Size760to780countF
  WAE_length_bin[78, i*NumLengthBin+adj+34L] = Age2Size760to780countF
  WAE_length_bin[79, i*NumLengthBin+adj+34L] = Age3Size760to780countF
  WAE_length_bin[80, i*NumLengthBin+adj+34L] = Age4Size760to780countF
  WAE_length_bin[81, i*NumLengthBin+adj+34L] = Age5Size760to780countF
  WAE_length_bin[82, i*NumLengthBin+adj+34L] = Age6Size760to780countF
  WAE_length_bin[83, i*NumLengthBin+adj+34L] = Age7Size760to780countF
  WAE_length_bin[84, i*NumLengthBin+adj+34L] = Age8Size760to780countF
  WAE_length_bin[85, i*NumLengthBin+adj+34L] = Age9Size760to780countF
  WAE_length_bin[86, i*NumLengthBin+adj+34L] = Age10Size760to780countF
  WAE_length_bin[87, i*NumLengthBin+adj+34L] = Age11Size760to780countF
  WAE_length_bin[88, i*NumLengthBin+adj+34L] = Age12Size760to780countF
  WAE_length_bin[89, i*NumLengthBin+adj+34L] = Age13Size760to780countF
  WAE_length_bin[90, i*NumLengthBin+adj+34L] = Age14Size760to780countF
  WAE_length_bin[91, i*NumLengthBin+adj+34L] = Age15Size760to780countF
  WAE_length_bin[92, i*NumLengthBin+adj+34L] = Age16Size760to780countF
  WAE_length_bin[93, i*NumLengthBin+adj+34L] = Age17Size760to780countF
  WAE_length_bin[94, i*NumLengthBin+adj+34L] = Age18Size760to780countF
  WAE_length_bin[95, i*NumLengthBin+adj+34L] = Age19Size760to780countF
  WAE_length_bin[96, i*NumLengthBin+adj+34L] = Age20Size760to780countF
  WAE_length_bin[97, i*NumLengthBin+adj+34L] = Age21Size760to780countF
  WAE_length_bin[98, i*NumLengthBin+adj+34L] = Age22Size760to780countF
  WAE_length_bin[99, i*NumLengthBin+adj+34L] = Age23Size760to780countF
  WAE_length_bin[100, i*NumLengthBin+adj+34L] = Age24Size760to780countF
  WAE_length_bin[101, i*NumLengthBin+adj+34L] = Age25Size760to780countF
  WAE_length_bin[102, i*NumLengthBin+adj+34L] = Age26Size760to780countF
  ENDIF
PRINT, 'Size760to780F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+34L])

; length bin 36
IF Size780to800countF GT 0 THEN BEGIN
age0Size780to800F = WHERE((Age_Gro[Size780to800] EQ 1) AND (Sex_Gro[Size780to800] EQ 1), Age0Size780to800countF)
age1Size780to800F = WHERE((Age_Gro[Size780to800] EQ 1) AND (Sex_Gro[Size780to800] EQ 1), Age1Size780to800countF)
age2Size780to800F = WHERE((Age_Gro[Size780to800] EQ 2) AND (Sex_Gro[Size780to800] EQ 1), Age2Size780to800countF)
age3Size780to800F = WHERE((Age_Gro[Size780to800] EQ 3) AND (Sex_Gro[Size780to800] EQ 1), Age3Size780to800countF)
age4Size780to800F = WHERE((Age_Gro[Size780to800] EQ 4) AND (Sex_Gro[Size780to800] EQ 1), Age4Size780to800countF)
age5Size780to800F = WHERE((Age_Gro[Size780to800] EQ 5) AND (Sex_Gro[Size780to800] EQ 1), Age5Size780to800countF)
age6Size780to800F = WHERE((Age_Gro[Size780to800] EQ 6) AND (Sex_Gro[Size780to800] EQ 1), Age6Size780to800countF)
age7Size780to800F = WHERE((Age_Gro[Size780to800] EQ 7) AND (Sex_Gro[Size780to800] EQ 1), Age7Size780to800countF)
age8Size780to800F = WHERE((Age_Gro[Size780to800] EQ 8) AND (Sex_Gro[Size780to800] EQ 1), Age8Size780to800countF)
age9Size780to800F = WHERE((Age_Gro[Size780to800] EQ 9) AND (Sex_Gro[Size780to800] EQ 1), Age9Size780to800countF)
age10Size780to800F = WHERE((Age_Gro[Size780to800] EQ 10) AND (Sex_Gro[Size780to800] EQ 1), Age10Size780to800countF)
age11Size780to800F = WHERE((Age_Gro[Size780to800] EQ 11) AND (Sex_Gro[Size780to800] EQ 1), Age11Size780to800countF)
AGE12Size780to800F = WHERE((Age_Gro[Size780to800] EQ 12) AND (Sex_Gro[Size780to800] EQ 1), Age12Size780to800countF)
AGE13Size780to800F = WHERE((Age_Gro[Size780to800] EQ 13) AND (Sex_Gro[Size780to800] EQ 1), Age13Size780to800countF)
AGE14Size780to800F = WHERE((Age_Gro[Size780to800] EQ 14) AND (Sex_Gro[Size780to800] EQ 1), Age14Size780to800countF)
AGE15Size780to800F = WHERE((Age_Gro[Size780to800] EQ 15) AND (Sex_Gro[Size780to800] EQ 1), Age15Size780to800countF)
age16Size780to800F = WHERE((Age_Gro[Size780to800] EQ 16) AND (Sex_Gro[Size780to800] EQ 1), Age16Size780to800countF)
age17Size780to800F = WHERE((Age_Gro[Size780to800] EQ 17) AND (Sex_Gro[Size780to800] EQ 1), Age17Size780to800countF)
age18Size780to800F = WHERE((Age_Gro[Size780to800] EQ 18) AND (Sex_Gro[Size780to800] EQ 1), Age18Size780to800countF)
age19Size780to800F = WHERE((Age_Gro[Size780to800] EQ 19) AND (Sex_Gro[Size780to800] EQ 1), Age19Size780to800countF)
age20Size780to800F = WHERE((Age_Gro[Size780to800] EQ 20) AND (Sex_Gro[Size780to800] EQ 1), Age20Size780to800countF)
age21Size780to800F = WHERE((Age_Gro[Size780to800] EQ 21) AND (Sex_Gro[Size780to800] EQ 1), Age21Size780to800countF)
age22Size780to800F = WHERE((Age_Gro[Size780to800] EQ 22) AND (Sex_Gro[Size780to800] EQ 1), Age22Size780to800countF)
age23Size780to800F = WHERE((Age_Gro[Size780to800] EQ 23) AND (Sex_Gro[Size780to800] EQ 1), Age23Size780to800countF)
age24Size780to800F = WHERE((Age_Gro[Size780to800] EQ 24) AND (Sex_Gro[Size780to800] EQ 1), Age24Size780to800countF)
age25Size780to800F = WHERE((Age_Gro[Size780to800] EQ 25) AND (Sex_Gro[Size780to800] EQ 1), Age25Size780to800countF)
age26Size780to800F = WHERE((Age_Gro[Size780to800] EQ 26) AND (Sex_Gro[Size780to800] EQ 1), Age26Size780to800countF)

  WAE_length_bin[70, i*NumLengthBin+adj+35L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+35L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+35L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+35L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+35L] = 780
  WAE_length_bin[75, i*NumLengthBin+adj+35L] = Size780to800countF

  WAE_length_bin[76, i*NumLengthBin+adj+35L] = Age0Size780to800countF
  WAE_length_bin[77, i*NumLengthBin+adj+35L] = Age1Size780to800countF
  WAE_length_bin[78, i*NumLengthBin+adj+35L] = Age2Size780to800countF
  WAE_length_bin[79, i*NumLengthBin+adj+35L] = Age3Size780to800countF
  WAE_length_bin[80, i*NumLengthBin+adj+35L] = Age4Size780to800countF
  WAE_length_bin[81, i*NumLengthBin+adj+35L] = Age5Size780to800countF
  WAE_length_bin[82, i*NumLengthBin+adj+35L] = Age6Size780to800countF
  WAE_length_bin[83, i*NumLengthBin+adj+35L] = Age7Size780to800countF
  WAE_length_bin[84, i*NumLengthBin+adj+35L] = Age8Size780to800countF
  WAE_length_bin[85, i*NumLengthBin+adj+35L] = Age9Size780to800countF
  WAE_length_bin[86, i*NumLengthBin+adj+35L] = Age10Size780to800countF
  WAE_length_bin[87, i*NumLengthBin+adj+35L] = Age11Size780to800countF
  WAE_length_bin[88, i*NumLengthBin+adj+35L] = Age12Size780to800countF
  WAE_length_bin[89, i*NumLengthBin+adj+35L] = Age13Size780to800countF
  WAE_length_bin[90, i*NumLengthBin+adj+35L] = Age14Size780to800countF
  WAE_length_bin[91, i*NumLengthBin+adj+35L] = Age15Size780to800countF
  WAE_length_bin[92, i*NumLengthBin+adj+35L] = Age16Size780to800countF
  WAE_length_bin[93, i*NumLengthBin+adj+35L] = Age17Size780to800countF
  WAE_length_bin[94, i*NumLengthBin+adj+35L] = Age18Size780to800countF
  WAE_length_bin[95, i*NumLengthBin+adj+35L] = Age19Size780to800countF
  WAE_length_bin[96, i*NumLengthBin+adj+35L] = Age20Size780to800countF
  WAE_length_bin[97, i*NumLengthBin+adj+35L] = Age21Size780to800countF
  WAE_length_bin[98, i*NumLengthBin+adj+35L] = Age22Size780to800countF
  WAE_length_bin[99, i*NumLengthBin+adj+35L] = Age23Size780to800countF
  WAE_length_bin[100, i*NumLengthBin+adj+35L] = Age24Size780to800countF
  WAE_length_bin[101, i*NumLengthBin+adj+35L] = Age25Size780to800countF
  WAE_length_bin[102, i*NumLengthBin+adj+35L] = Age26Size780to800countF
  ENDIF
PRINT, 'Size780to800F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+35L])


; length bin 37
IF SizeGE800countF GT 0 THEN BEGIN
age0SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 1) AND (Sex_Gro[SizeGE800] EQ 1), Age0SizeGE800countF)
age1SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 1) AND (Sex_Gro[SizeGE800] EQ 1), Age1SizeGE800countF)
age2SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 2) AND (Sex_Gro[SizeGE800] EQ 1), Age2SizeGE800countF)
age3SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 3) AND (Sex_Gro[SizeGE800] EQ 1), Age3SizeGE800countF)
age4SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 4) AND (Sex_Gro[SizeGE800] EQ 1), Age4SizeGE800countF)
age5SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 5) AND (Sex_Gro[SizeGE800] EQ 1), Age5SizeGE800countF)
age6SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 6) AND (Sex_Gro[SizeGE800] EQ 1), Age6SizeGE800countF)
age7SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 7) AND (Sex_Gro[SizeGE800] EQ 1), Age7SizeGE800countF)
age8SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 8) AND (Sex_Gro[SizeGE800] EQ 1), Age8SizeGE800countF)
age9SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 9) AND (Sex_Gro[SizeGE800] EQ 1), Age9SizeGE800countF)
age10SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 10) AND (Sex_Gro[SizeGE800] EQ 1), Age10SizeGE800countF)
age11SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 11) AND (Sex_Gro[SizeGE800] EQ 1), Age11SizeGE800countF)
AGE12SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 12) AND (Sex_Gro[SizeGE800] EQ 1), Age12SizeGE800countF)
AGE13SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 13) AND (Sex_Gro[SizeGE800] EQ 1), Age13SizeGE800countF)
AGE14SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 14) AND (Sex_Gro[SizeGE800] EQ 1), Age14SizeGE800countF)
AGE15SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 15) AND (Sex_Gro[SizeGE800] EQ 1), Age15SizeGE800countF)
age16SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 16) AND (Sex_Gro[SizeGE800] EQ 1), Age16SizeGE800countF)
age17SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 17) AND (Sex_Gro[SizeGE800] EQ 1), Age17SizeGE800countF)
age18SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 18) AND (Sex_Gro[SizeGE800] EQ 1), Age18SizeGE800countF)
age19SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 19) AND (Sex_Gro[SizeGE800] EQ 1), Age19SizeGE800countF)
age20SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 20) AND (Sex_Gro[SizeGE800] EQ 1), Age20SizeGE800countF)
age21SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 21) AND (Sex_Gro[SizeGE800] EQ 1), Age21SizeGE800countF)
age22SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 22) AND (Sex_Gro[SizeGE800] EQ 1), Age22SizeGE800countF)
age23SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 23) AND (Sex_Gro[SizeGE800] EQ 1), Age23SizeGE800countF)
age24SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 24) AND (Sex_Gro[SizeGE800] EQ 1), Age24SizeGE800countF)
age25SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 25) AND (Sex_Gro[SizeGE800] EQ 1), Age25SizeGE800countF)
age26SizeGE800F = WHERE((Age_Gro[SizeGE800] EQ 26) AND (Sex_Gro[SizeGE800] EQ 1), Age26SizeGE800countF)

  WAE_length_bin[70, i*NumLengthBin+adj+36L] = Max(length[INDEX_growthdata[female]])
  WAE_length_bin[71, i*NumLengthBin+adj+36L] = Min(length[INDEX_growthdata[female]])
  WAE_length_bin[72, i*NumLengthBin+adj+36L] = Max(age[INDEX_growthdata[female]])
  WAE_length_bin[73, i*NumLengthBin+adj+36L] = Min(age[INDEX_growthdata[female]])
  WAE_length_bin[74, i*NumLengthBin+adj+36L] = 800
  WAE_length_bin[75, i*NumLengthBin+adj+36L] = SizeGE800countF

  WAE_length_bin[76, i*NumLengthBin+adj+36L] = Age0SizeGE800countF
  WAE_length_bin[77, i*NumLengthBin+adj+36L] = Age1SizeGE800countF
  WAE_length_bin[78, i*NumLengthBin+adj+36L] = Age2SizeGE800countF
  WAE_length_bin[79, i*NumLengthBin+adj+36L] = Age3SizeGE800countF
  WAE_length_bin[80, i*NumLengthBin+adj+36L] = Age4SizeGE800countF
  WAE_length_bin[81, i*NumLengthBin+adj+36L] = Age5SizeGE800countF
  WAE_length_bin[82, i*NumLengthBin+adj+36L] = Age6SizeGE800countF
  WAE_length_bin[83, i*NumLengthBin+adj+36L] = Age7SizeGE800countF
  WAE_length_bin[84, i*NumLengthBin+adj+36L] = Age8SizeGE800countF
  WAE_length_bin[85, i*NumLengthBin+adj+36L] = Age9SizeGE800countF
  WAE_length_bin[86, i*NumLengthBin+adj+36L] = Age10SizeGE800countF
  WAE_length_bin[87, i*NumLengthBin+adj+36L] = Age11SizeGE800countF
  WAE_length_bin[88, i*NumLengthBin+adj+36L] = Age12SizeGE800countF
  WAE_length_bin[89, i*NumLengthBin+adj+36L] = Age13SizeGE800countF
  WAE_length_bin[90, i*NumLengthBin+adj+36L] = Age14SizeGE800countF
  WAE_length_bin[91, i*NumLengthBin+adj+36L] = Age15SizeGE800countF
  WAE_length_bin[92, i*NumLengthBin+adj+36L] = Age16SizeGE800countF
  WAE_length_bin[93, i*NumLengthBin+adj+36L] = Age17SizeGE800countF
  WAE_length_bin[94, i*NumLengthBin+adj+36L] = Age18SizeGE800countF
  WAE_length_bin[95, i*NumLengthBin+adj+36L] = Age19SizeGE800countF
  WAE_length_bin[96, i*NumLengthBin+adj+36L] = Age20SizeGE800countF
  WAE_length_bin[97, i*NumLengthBin+adj+36L] = Age21SizeGE800countF
  WAE_length_bin[98, i*NumLengthBin+adj+36L] = Age22SizeGE800countF
  WAE_length_bin[99, i*NumLengthBin+adj+36L] = Age23SizeGE800countF
  WAE_length_bin[100, i*NumLengthBin+adj+36L] = Age24SizeGE800countF
  WAE_length_bin[101, i*NumLengthBin+adj+36L] = Age25SizeGE800countF
  WAE_length_bin[102, i*NumLengthBin+adj+36L] = Age26SizeGE800countF
  ENDIF
PRINT, 'SizeGE800F', TOTAL(WAE_length_bin[76L:102, i*NumLengthBin+adj+36L])
PRINT, 'Total N of fish', TOTAL(WAE_length_bin[43L:69, i*NumLengthBin+adj:i*NumLengthBin+adj+36L])

FUNCTION Gompertz, x, p
; x = abscissae
; p = parameters = [amplitude, centroid, width]
;argument = (x - p[1]) / p[2]
;gaussian = p[0] * exp(-argument^2)

; length
; 1) standard VBGF
;Length_Gro = p[0] * (1 - EXP(-p[1] * (x - p[2])))
;; 2) generalized VBGF
;Length_Gro = p[0] * (1 - EXP(-p[1] * (x - p[2])))^p[3]
; 3) Gompertz
Length_Gro = p[0]*exp(-exp(-p[1]*(x-p[2])))
; 4) Logistic



; 5) Power 
 
;; weight 
;WLslope =3.18
;Length_Gro = p[0] * (1 - EXP(-p[1] * (x - p[2])))^WLslope
 
RETURN, Length_Gro
END
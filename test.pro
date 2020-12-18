;expr = 'P[0] + GAUSS1(X, P[1:3])'
;
;;FUNCTION MYGAUSS, X, P
;;  RETURN, P[0] + GAUSS1(X, P[1:3])
;;END
;;.comp mygauss
;
;start = [950.D, 2.5, 1., 1000.]
;
;result = MPFITEXPR(expr,     t, r, rerr, start)
;;result = MPFITFUN('MYGAUSS', t, r, rerr, start)
;
;print, result




;Then, run mpfitfun, and watch as it iteratively improves our initial guess to minimize chi-squared.
x = [1,2,4,5,6,7,8,9,6,9,9]
y = [10,100,150,300,500,450,550,660,600,600,550]
startparms = [1.0, 10.0, 10.0]

;parms = mpfitfun('jacksgaussian', x, y, dy, startparms, perror = dparms, yfit=yfit)

startparms = [400.0, 0.4, -0.15]
parms = mpfitfun('vonBertalanffy', x, y, dy, startparms, perror = dparms, yfit=yfit)

end


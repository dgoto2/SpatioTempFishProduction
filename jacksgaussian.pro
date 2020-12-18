function jacksgaussian, x, p
; x = abscissae
; p = parameters = [amplitude, centroid, width]
argument = (x - p[1]) / p[2]
gaussian = p[0] * exp(-argument^2)
return, gaussian
end

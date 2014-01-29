function [I_norm] = normalizacion(I_orig)
    min1 = min(min(I_orig));
    max1 = max(max(I_orig));
    
    I_norm = (double(I_orig) .*  (255.0)) ./ (double(max1 - min1));
        
    I_norm = uint8(I_norm);
  
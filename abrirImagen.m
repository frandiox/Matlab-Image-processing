function [Imagen, cancelado] = abrirImagen()

[ruta, cancelado] = imgetfile;

if ~cancelado
    Imagen = imread(ruta);
    if ndims(Imagen) == 3
        Imagen = rgb2gray(Imagen);
    end
   Imagen = normalizacion(Imagen);
else
    Imagen = [];
end
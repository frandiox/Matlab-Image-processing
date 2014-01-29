function [] = guardarImagen(Imagen)

[ruta, extension, cancelado] = imputfile;

if ~cancelado
   imwrite(Imagen, strcat(ruta,'.',extension));
end
function [imagenTresCanales] = imagen_tres_canales(imagenOriginal)
% ImagenTresCanales
% Devuelve la misma imagen pero únicamente con tres canales.
% Si la imagen original tiene cuatro canales, elimina el cuarto.
% En caso contrario, devuelve la imagen original sin cambios.

    if size(imagenOriginal, 3) == 4
        % Si la imagen tiene 4 canales, los divido y desprecio el cuarto.
        [R, G, B, ~] = imsplit(imagenOriginal);
        % Combino los tres primeros canales para crear una nueva imagen.
        imagenTresCanales = cat(3, R, G, B);
    else
        % Si no tiene 4 canales, devuelvo la imagen original.
        imagenTresCanales = imagenOriginal;
    end
end

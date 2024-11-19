function img_bnw = convertir_a_blanco_negro_con_bordes(img)
    % Si la imagen está en color, primero la convierto a escala de grises.
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    % Extraigo los bordes superior, inferior, izquierdo y derecho.
    bordes_horizontal = [img(1,:); img(end,:)];
    bordes_vertical = [img(:,1); img(:,end)];
    bordes = [bordes_horizontal(:); bordes_vertical(:)];
    
    % Determino cuál es el color más común en los bordes de la imagen (umbral).
    umbral = mode(double(bordes));
    
    % Convierto la imagen a blanco y negro usando el umbral determinado.
    % Los píxeles por encima del umbral se vuelven blancos, los demás negros.
    img_bnw = ones(size(img));
    img_bnw(img == umbral) = 0;
end

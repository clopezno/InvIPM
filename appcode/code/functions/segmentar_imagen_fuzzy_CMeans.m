function [imgResultante, centers] = segmentar_imagen_fuzzy_CMeans(img, numClusters, maxIter)
    [height, width, ~] = size(img);
    datosImg = double(reshape(img, [], 3));

    % Aplico Fuzzy C-Means
    options = [NaN, NaN, 0.00001, maxIter];
    [centers, U] = fcm(datosImg, numClusters, options);

    % Obtengo la membresía más alta para cada píxel
    [~, membership] = max(U, [], 1);

    % Defino una paleta de colores RGB
    colores = [255, 0, 0; 0, 255, 0; 0, 0, 255; 255, 255, 0; 0, 255, 255; 255, 0, 255; 255, 127, 0; 127, 0, 255; 0, 127, 255; 127, 255, 0];
    colores = colores(1:numClusters, :); % Asegurarse de tener suficientes colores

    % Creo imagen resultante
    imgResultante = zeros(height * width, 3); % Para formato RGB
    for k = 1:numClusters
        idx = find(membership == k);
        imgResultante(idx, :) = repmat(colores(k, :), length(idx), 1);
    end

    % Cambio la forma de la imagen resultante al formato original
    imgResultante = uint8(reshape(imgResultante, [height, width, 3]));
end
